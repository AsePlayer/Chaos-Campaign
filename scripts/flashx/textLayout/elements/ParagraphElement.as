package flashx.textLayout.elements
{
   import flash.text.engine.ContentElement;
   import flash.text.engine.EastAsianJustifier;
   import flash.text.engine.GroupElement;
   import flash.text.engine.LineJustification;
   import flash.text.engine.SpaceJustifier;
   import flash.text.engine.TabAlignment;
   import flash.text.engine.TabStop;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flash.text.engine.TextRotation;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.JustificationRule;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.TextJustify;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.CharacterUtil;
   import flashx.textLayout.utils.LocaleUtil;
   
   public final class ParagraphElement extends ParagraphFormattedElement
   {
      
      private static var _defaultTabStops:Vector.<TabStop>;
      
      private static const defaultTabWidth:int = 48;
      
      private static const defaultTabCount:int = 20;
       
      
      private var _textBlock:TextBlock;
      
      private var _terminatorSpan:flashx.textLayout.elements.SpanElement;
      
      public function ParagraphElement()
      {
         super();
         this._terminatorSpan = null;
      }
      
      private static function initializeDefaultTabStops() : void
      {
         _defaultTabStops = new Vector.<TabStop>(defaultTabCount,true);
         for(var i:int = 0; i < defaultTabCount; i++)
         {
            _defaultTabStops[i] = new TabStop(TextAlign.START,defaultTabWidth * i);
         }
      }
      
      tlf_internal static function getLeadingBasis(leadingModel:String) : String
      {
         switch(leadingModel)
         {
            case LeadingModel.ASCENT_DESCENT_UP:
            case LeadingModel.APPROXIMATE_TEXT_FIELD:
            case LeadingModel.BOX:
            case LeadingModel.ROMAN_UP:
            default:
               return TextBaseline.ROMAN;
            case LeadingModel.IDEOGRAPHIC_TOP_UP:
            case LeadingModel.IDEOGRAPHIC_TOP_DOWN:
               return TextBaseline.IDEOGRAPHIC_TOP;
            case LeadingModel.IDEOGRAPHIC_CENTER_UP:
            case LeadingModel.IDEOGRAPHIC_CENTER_DOWN:
               return TextBaseline.IDEOGRAPHIC_CENTER;
         }
      }
      
      tlf_internal static function useUpLeadingDirection(leadingModel:String) : Boolean
      {
         switch(leadingModel)
         {
            case LeadingModel.ASCENT_DESCENT_UP:
            case LeadingModel.APPROXIMATE_TEXT_FIELD:
            case LeadingModel.BOX:
            case LeadingModel.ROMAN_UP:
            case LeadingModel.IDEOGRAPHIC_TOP_UP:
            case LeadingModel.IDEOGRAPHIC_CENTER_UP:
            default:
               return true;
            case LeadingModel.IDEOGRAPHIC_TOP_DOWN:
            case LeadingModel.IDEOGRAPHIC_CENTER_DOWN:
               return false;
         }
      }
      
      tlf_internal function createTextBlock() : void
      {
         var child:FlowElement = null;
         this.computedFormat;
         this._textBlock = new TextBlock();
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i);
            child.tlf_internal::createContentElement();
         }
         this.updateTextBlock();
      }
      
      tlf_internal function releaseTextBlock() : void
      {
         var textLineTest:TextLine = null;
         var tfl:TextFlowLine = null;
         var child:FlowElement = null;
         if(!this._textBlock)
         {
            return;
         }
         if(Boolean(this._textBlock.firstLine))
         {
            for(textLineTest = this._textBlock.firstLine; textLineTest != null; textLineTest = textLineTest.nextLine)
            {
               if(textLineTest.numChildren != 0)
               {
                  tfl = textLineTest.userData as TextFlowLine;
                  if(tfl.tlf_internal::adornCount != textLineTest.numChildren)
                  {
                     return;
                  }
               }
            }
            this._textBlock.releaseLines(this._textBlock.firstLine,this._textBlock.lastLine);
         }
         this._textBlock.content = null;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i);
            child.tlf_internal::releaseContentElement();
         }
         this._textBlock = null;
         if(Boolean(_computedFormat))
         {
            _computedFormat = null;
         }
      }
      
      tlf_internal function getTextBlock() : TextBlock
      {
         if(!this._textBlock)
         {
            this.tlf_internal::createTextBlock();
         }
         return this._textBlock;
      }
      
      tlf_internal function peekTextBlock() : TextBlock
      {
         return this._textBlock;
      }
      
      tlf_internal function releaseLineCreationData() : void
      {
         if(Boolean(this._textBlock))
         {
            this._textBlock["releaseLineCreationData"]();
         }
      }
      
      override tlf_internal function createContentAsGroup() : GroupElement
      {
         var originalContent:ContentElement = null;
         var gc:Vector.<ContentElement> = null;
         var textFlow:TextFlow = null;
         var group:GroupElement = this._textBlock.content as GroupElement;
         if(!group)
         {
            originalContent = this._textBlock.content;
            group = new GroupElement();
            this._textBlock.content = group;
            if(Boolean(originalContent))
            {
               gc = new Vector.<ContentElement>();
               gc.push(originalContent);
               group.replaceElements(0,0,gc);
            }
            if(Boolean(this._textBlock.firstLine) && Boolean(textLength))
            {
               textFlow = getTextFlow();
               if(Boolean(textFlow))
               {
                  textFlow.tlf_internal::damage(getAbsoluteStart(),textLength,TextLineValidity.INVALID,false);
               }
            }
         }
         return group;
      }
      
      override tlf_internal function removeBlockElement(child:FlowElement, block:ContentElement) : void
      {
         var idx:int = 0;
         var group:GroupElement = null;
         var elem:ContentElement = null;
         if(numChildren == 1)
         {
            if(block is GroupElement)
            {
               GroupElement(this._textBlock.content).replaceElements(0,1,null);
            }
            this._textBlock.content = null;
         }
         else
         {
            idx = this.getChildIndex(child);
            group = GroupElement(this._textBlock.content);
            group.replaceElements(idx,idx + 1,null);
            if(numChildren == 2)
            {
               elem = group.getElementAt(0);
               if(!(elem is GroupElement))
               {
                  group.replaceElements(0,1,null);
                  this._textBlock.content = elem;
               }
            }
         }
      }
      
      override tlf_internal function hasBlockElement() : Boolean
      {
         return this._textBlock != null;
      }
      
      override tlf_internal function createContentElement() : void
      {
         this.tlf_internal::createTextBlock();
      }
      
      override tlf_internal function insertBlockElement(child:FlowElement, block:ContentElement) : void
      {
         var gc:Vector.<ContentElement> = null;
         var group:GroupElement = null;
         var idx:int = 0;
         if(this._textBlock == null)
         {
            child.tlf_internal::releaseContentElement();
            this.tlf_internal::createTextBlock();
            return;
         }
         if(numChildren == 1)
         {
            if(block is GroupElement)
            {
               gc = new Vector.<ContentElement>();
               gc.push(block);
               group = new GroupElement(gc);
               this._textBlock.content = group;
            }
            else
            {
               this._textBlock.content = block;
            }
         }
         else
         {
            group = this.tlf_internal::createContentAsGroup();
            idx = this.getChildIndex(child);
            gc = new Vector.<ContentElement>();
            gc.push(block);
            group.replaceElements(idx,idx,gc);
         }
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function get defaultTypeName() : String
      {
         return "p";
      }
      
      override public function replaceChildren(beginChildIndex:int, endChildIndex:int, ... rest) : void
      {
         var applyParams:Array = null;
         if(rest.length == 1)
         {
            applyParams = [beginChildIndex,endChildIndex,rest[0]];
         }
         else
         {
            applyParams = [beginChildIndex,endChildIndex];
            if(rest.length != 0)
            {
               applyParams = applyParams.concat.apply(applyParams,rest);
            }
         }
         super.replaceChildren.apply(this,applyParams);
         this.tlf_internal::ensureTerminatorAfterReplace();
      }
      
      tlf_internal function ensureTerminatorAfterReplace() : void
      {
         var s:flashx.textLayout.elements.SpanElement = null;
         var newLastLeaf:FlowLeafElement = getLastLeaf();
         if(this._terminatorSpan != newLastLeaf)
         {
            if(Boolean(this._terminatorSpan))
            {
               this._terminatorSpan.tlf_internal::removeParaTerminator();
               this._terminatorSpan = null;
            }
            if(Boolean(newLastLeaf))
            {
               if(newLastLeaf is SpanElement)
               {
                  (newLastLeaf as SpanElement).tlf_internal::addParaTerminator();
                  this._terminatorSpan = newLastLeaf as SpanElement;
               }
               else
               {
                  s = new flashx.textLayout.elements.SpanElement();
                  super.replaceChildren(numChildren,numChildren,s);
                  s.format = newLastLeaf.format;
                  s.tlf_internal::addParaTerminator();
                  this._terminatorSpan = s;
               }
            }
         }
      }
      
      tlf_internal function updateTerminatorSpan(splitSpan:flashx.textLayout.elements.SpanElement, followingSpan:flashx.textLayout.elements.SpanElement) : void
      {
         if(this._terminatorSpan == splitSpan)
         {
            this._terminatorSpan = followingSpan;
         }
      }
      
      [RichTextContent]
      override public function set mxmlChildren(array:Array) : void
      {
         var child:Object = null;
         var s:flashx.textLayout.elements.SpanElement = null;
         this.replaceChildren(0,numChildren);
         for each(child in array)
         {
            if(child is FlowElement)
            {
               if(child is SpanElement || child is SubParagraphGroupElementBase)
               {
                  child.bindableElement = true;
               }
               super.replaceChildren(numChildren,numChildren,child as FlowElement);
            }
            else if(child is String)
            {
               s = new flashx.textLayout.elements.SpanElement();
               s.text = String(child);
               s.tlf_internal::bindableElement = true;
               super.replaceChildren(numChildren,numChildren,s);
            }
            else if(child != null)
            {
               throw new TypeError(GlobalSettings.resourceStringFunction("badMXMLChildrenArgument",[getQualifiedClassName(child)]));
            }
         }
         this.tlf_internal::ensureTerminatorAfterReplace();
      }
      
      override public function getText(relativeStart:int = 0, relativeEnd:int = -1, paragraphSeparator:String = "\n") : String
      {
         var text:String = null;
         if(relativeStart == 0 && (relativeEnd == -1 || relativeEnd >= textLength - 1) && Boolean(this._textBlock))
         {
            if(Boolean(this._textBlock.content))
            {
               text = this._textBlock.content.rawText;
               return text.substring(0,text.length - 1);
            }
            return "";
         }
         return super.getText(relativeStart,relativeEnd,paragraphSeparator);
      }
      
      public function getNextParagraph() : ParagraphElement
      {
         var nextLeaf:FlowLeafElement = getLastLeaf().getNextLeaf();
         return Boolean(nextLeaf) ? nextLeaf.getParagraph() : null;
      }
      
      public function getPreviousParagraph() : ParagraphElement
      {
         var previousLeaf:FlowLeafElement = getFirstLeaf().getPreviousLeaf();
         return Boolean(previousLeaf) ? previousLeaf.getParagraph() : null;
      }
      
      public function findPreviousAtomBoundary(relativePosition:int) : int
      {
         return this.tlf_internal::getTextBlock().findPreviousAtomBoundary(relativePosition);
      }
      
      public function findNextAtomBoundary(relativePosition:int) : int
      {
         return this.tlf_internal::getTextBlock().findNextAtomBoundary(relativePosition);
      }
      
      override public function getCharAtPosition(relativePosition:int) : String
      {
         return this.tlf_internal::getTextBlock().content.rawText.charAt(relativePosition);
      }
      
      public function findPreviousWordBoundary(relativePosition:int) : int
      {
         if(relativePosition == 0)
         {
            return 0;
         }
         var prevCharCode:int = getCharCodeAtPosition(relativePosition - 1);
         if(CharacterUtil.isWhitespace(prevCharCode))
         {
            while(CharacterUtil.isWhitespace(prevCharCode) && relativePosition - 1 > 0)
            {
               relativePosition--;
               prevCharCode = getCharCodeAtPosition(relativePosition - 1);
            }
            return relativePosition;
         }
         return this.tlf_internal::getTextBlock().findPreviousWordBoundary(relativePosition);
      }
      
      public function findNextWordBoundary(relativePosition:int) : int
      {
         if(relativePosition == textLength)
         {
            return textLength;
         }
         var curCharCode:int = getCharCodeAtPosition(relativePosition);
         if(CharacterUtil.isWhitespace(curCharCode))
         {
            while(CharacterUtil.isWhitespace(curCharCode) && relativePosition < textLength - 1)
            {
               relativePosition++;
               curCharCode = getCharCodeAtPosition(relativePosition);
            }
            return relativePosition;
         }
         return this.tlf_internal::getTextBlock().findNextWordBoundary(relativePosition);
      }
      
      private function updateTextBlock() : void
      {
         var lineJust:String = null;
         var spaceJustifier:SpaceJustifier = null;
         var newMinimumSpacing:Number = NaN;
         var newMaximumSpacing:Number = NaN;
         var newOptimumSpacing:Number = NaN;
         var eastAsianJustifier:EastAsianJustifier = null;
         var tabStops:Vector.<TabStop> = null;
         var tsa:TabStopFormat = null;
         var token:String = null;
         var alignment:String = null;
         var tabStop:TabStop = null;
         var garbage:String = null;
         var containerElement:ContainerFormattedElement = tlf_internal::getAncestorWithContainer();
         if(!containerElement)
         {
            return;
         }
         var containerElementFormat:ITextLayoutFormat = Boolean(containerElement) ? containerElement.computedFormat : TextLayoutFormat.defaultFormat;
         if(this.computedFormat.textAlign == TextAlign.JUSTIFY)
         {
            lineJust = _computedFormat.textAlignLast == TextAlign.JUSTIFY ? LineJustification.ALL_INCLUDING_LAST : LineJustification.ALL_BUT_LAST;
            if(containerElementFormat.lineBreak == LineBreak.EXPLICIT)
            {
               lineJust = LineJustification.UNJUSTIFIED;
            }
         }
         else
         {
            lineJust = LineJustification.UNJUSTIFIED;
         }
         var makeJustRuleStyle:String = this.tlf_internal::getEffectiveJustificationStyle();
         var justRule:String = this.tlf_internal::getEffectiveJustificationRule();
         if(justRule == JustificationRule.SPACE)
         {
            spaceJustifier = new SpaceJustifier(_computedFormat.locale,lineJust,false);
            spaceJustifier.letterSpacing = _computedFormat.textJustify == TextJustify.DISTRIBUTE ? true : false;
            if(Configuration.tlf_internal::playerEnablesArgoFeatures)
            {
               newMinimumSpacing = Property.toNumberIfPercent(_computedFormat.wordSpacing.minimumSpacing) / 100;
               newMaximumSpacing = Property.toNumberIfPercent(_computedFormat.wordSpacing.maximumSpacing) / 100;
               newOptimumSpacing = Property.toNumberIfPercent(_computedFormat.wordSpacing.optimumSpacing) / 100;
               spaceJustifier["minimumSpacing"] = Math.min(newMinimumSpacing,spaceJustifier["minimumSpacing"]);
               spaceJustifier["maximumSpacing"] = Math.max(newMaximumSpacing,spaceJustifier["maximumSpacing"]);
               spaceJustifier["optimumSpacing"] = newOptimumSpacing;
               spaceJustifier["minimumSpacing"] = newMinimumSpacing;
               spaceJustifier["maximumSpacing"] = newMaximumSpacing;
            }
            this._textBlock.textJustifier = spaceJustifier;
            this._textBlock.baselineZero = tlf_internal::getLeadingBasis(this.tlf_internal::getEffectiveLeadingModel());
         }
         else
         {
            eastAsianJustifier = new EastAsianJustifier(_computedFormat.locale,lineJust,makeJustRuleStyle);
            this._textBlock.textJustifier = eastAsianJustifier;
            this._textBlock.baselineZero = tlf_internal::getLeadingBasis(this.tlf_internal::getEffectiveLeadingModel());
         }
         this._textBlock.bidiLevel = _computedFormat.direction == Direction.LTR ? 0 : 1;
         this._textBlock.lineRotation = containerElementFormat.blockProgression == BlockProgression.RL ? TextRotation.ROTATE_90 : TextRotation.ROTATE_0;
         if(_computedFormat.tabStops && _computedFormat.tabStops.length != 0)
         {
            tabStops = new Vector.<TabStop>();
            for each(tsa in _computedFormat.tabStops)
            {
               token = tsa.decimalAlignmentToken == null ? "" : tsa.decimalAlignmentToken;
               alignment = tsa.alignment == null ? TabAlignment.START : tsa.alignment;
               tabStop = new TabStop(alignment,Number(tsa.position),token);
               if(tsa.decimalAlignmentToken != null)
               {
                  garbage = "x" + tabStop.decimalAlignmentToken;
               }
               tabStops.push(tabStop);
            }
            this._textBlock.tabStops = tabStops;
         }
         else if(Boolean(GlobalSettings.tlf_internal::enableDefaultTabStops) && !Configuration.tlf_internal::playerEnablesArgoFeatures)
         {
            if(_defaultTabStops == null)
            {
               initializeDefaultTabStops();
            }
            this._textBlock.tabStops = _defaultTabStops;
         }
         else
         {
            this._textBlock.tabStops = null;
         }
      }
      
      override public function get computedFormat() : ITextLayoutFormat
      {
         if(!_computedFormat)
         {
            super.computedFormat;
            if(Boolean(this._textBlock))
            {
               this.updateTextBlock();
            }
         }
         return _computedFormat;
      }
      
      override tlf_internal function canOwnFlowElement(elem:FlowElement) : Boolean
      {
         return elem is FlowLeafElement || elem is SubParagraphGroupElementBase;
      }
      
      override tlf_internal function normalizeRange(normalizeStart:uint, normalizeEnd:uint) : void
      {
         var child:FlowElement = null;
         var origChildEnd:int = 0;
         var newChildEnd:int = 0;
         var prevElement:FlowElement = null;
         var lastChild:FlowElement = null;
         var s:flashx.textLayout.elements.SpanElement = null;
         var idx:int = findChildIndexAtPosition(normalizeStart);
         if(idx != -1 && idx < numChildren)
         {
            child = getChildAt(idx);
            for(normalizeStart -= child.parentRelativeStart; true; )
            {
               origChildEnd = child.parentRelativeStart + child.textLength;
               child.tlf_internal::normalizeRange(normalizeStart,normalizeEnd - child.parentRelativeStart);
               newChildEnd = child.parentRelativeStart + child.textLength;
               normalizeEnd += newChildEnd - origChildEnd;
               if(child.textLength == 0 && !child.tlf_internal::bindableElement)
               {
                  this.replaceChildren(idx,idx + 1);
               }
               else if(child.tlf_internal::mergeToPreviousIfPossible())
               {
                  prevElement = this.getChildAt(idx - 1);
                  prevElement.tlf_internal::normalizeRange(0,prevElement.textLength);
               }
               else
               {
                  idx++;
               }
               if(idx == numChildren)
               {
                  if(idx != 0)
                  {
                     lastChild = this.getChildAt(idx - 1);
                     if(lastChild is SubParagraphGroupElementBase && lastChild.textLength == 1 && !lastChild.tlf_internal::bindableElement)
                     {
                        this.replaceChildren(idx - 1,idx);
                     }
                  }
                  break;
               }
               child = getChildAt(idx);
               if(child.parentRelativeStart > normalizeEnd)
               {
                  break;
               }
               normalizeStart = 0;
            }
         }
         if(numChildren == 0 || textLength == 0)
         {
            s = new flashx.textLayout.elements.SpanElement();
            this.replaceChildren(0,0,s);
            s.tlf_internal::normalizeRange(0,s.textLength);
         }
      }
      
      tlf_internal function getEffectiveLeadingModel() : String
      {
         return this.computedFormat.leadingModel == LeadingModel.AUTO ? LocaleUtil.leadingModel(this.computedFormat.locale) : String(this.computedFormat.leadingModel);
      }
      
      tlf_internal function getEffectiveDominantBaseline() : String
      {
         return this.computedFormat.dominantBaseline == FormatValue.AUTO ? LocaleUtil.dominantBaseline(this.computedFormat.locale) : String(this.computedFormat.dominantBaseline);
      }
      
      tlf_internal function getEffectiveJustificationRule() : String
      {
         return this.computedFormat.justificationRule == FormatValue.AUTO ? LocaleUtil.justificationRule(this.computedFormat.locale) : String(this.computedFormat.justificationRule);
      }
      
      tlf_internal function getEffectiveJustificationStyle() : String
      {
         return this.computedFormat.justificationStyle == FormatValue.AUTO ? LocaleUtil.justificationStyle(this.computedFormat.locale) : String(this.computedFormat.justificationStyle);
      }
   }
}
