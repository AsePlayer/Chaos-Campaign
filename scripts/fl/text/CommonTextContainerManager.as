package fl.text
{
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.TabAlignment;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.ElementRange;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   internal class CommonTextContainerManager
   {
       
      
      protected var _container:Sprite;
      
      protected var _controller:ContainerController;
      
      protected var _ownerField:fl.text.TLFTextField;
      
      public function CommonTextContainerManager()
      {
         super();
      }
      
      public function get container() : Sprite
      {
         return this._container;
      }
      
      public function setTextFormat(format:TextFormat, beginIndex:int, endIndex:int, charFormat:TextLayoutFormat, paraFormat:TextLayoutFormat) : void
      {
         var setTextFormatSelectionState:SelectionState = null;
         var arrTabStops:Array = null;
         var tabStop:String = null;
         var tabStopFmt:TabStopFormat = null;
         if(Boolean(this.textFlow) && this.textFlow.formatResolver != null)
         {
            throw new Error("This method cannot be used on a text field with a style sheet.");
         }
         var tmpSelectionState:SelectionState = null;
         if(format.align != null)
         {
            if(format.align == TextFormatAlign.CENTER || format.align == TextFormatAlign.JUSTIFY || format.align == TextFormatAlign.LEFT || format.align == TextFormatAlign.RIGHT)
            {
               paraFormat.textAlign = format.align;
            }
            else
            {
               paraFormat.textAlign = TextFormatAlign.RIGHT;
            }
         }
         if(format.blockIndent != null && format.leftMargin != null)
         {
            paraFormat.paragraphStartIndent = format.blockIndent + format.leftMargin;
         }
         else if(format.blockIndent != null)
         {
            paraFormat.paragraphStartIndent = format.blockIndent;
         }
         else if(format.leftMargin != null)
         {
            paraFormat.paragraphStartIndent = format.leftMargin;
         }
         if(format.indent != null)
         {
            paraFormat.textIndent = format.indent;
         }
         if(format.leading != null)
         {
            paraFormat.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
            charFormat.lineHeight = format.leading;
         }
         if(format.rightMargin != null)
         {
            paraFormat.paragraphEndIndent = format.rightMargin;
         }
         if(format.tabStops != null)
         {
            arrTabStops = new Array();
            format.tabStops.sort(Array.NUMERIC);
            for each(tabStop in format.tabStops)
            {
               tabStopFmt = new TabStopFormat();
               tabStopFmt.alignment = TabAlignment.START;
               tabStopFmt.position = int(tabStop);
               arrTabStops.push(tabStopFmt);
            }
            paraFormat.tabStops = arrTabStops;
         }
         if(format.bold != null)
         {
            charFormat.fontWeight = Boolean(format.bold) ? FontWeight.BOLD : FontWeight.NORMAL;
         }
         if(format.color != null)
         {
            charFormat.color = format.color;
         }
         if(format.font != null)
         {
            charFormat.fontFamily = format.font;
         }
         if(format.italic != null)
         {
            charFormat.fontStyle = Boolean(format.italic) ? FontPosture.ITALIC : FontPosture.NORMAL;
         }
         if(format.kerning != null)
         {
            charFormat.kerning = Boolean(format.kerning) ? Kerning.ON : Kerning.OFF;
         }
         if(format.letterSpacing != null)
         {
            charFormat.trackingRight = format.letterSpacing;
         }
         if(format.size != null)
         {
            charFormat.fontSize = format.size;
         }
         if(format.underline != null)
         {
            charFormat.textDecoration = Boolean(format.underline) ? TextDecoration.UNDERLINE : TextDecoration.NONE;
         }
         var priorEditingMode:String = String(this._ownerField.tlf_internal::getEditingMode(this.textFlow.interactionManager));
         if(priorEditingMode != EditingMode.READ_ONLY && priorEditingMode != null)
         {
            if(this.textFlow.interactionManager.hasSelection())
            {
               tmpSelectionState = this.textFlow.interactionManager.getSelectionState();
            }
         }
         if(priorEditingMode != EditingMode.READ_WRITE)
         {
            this._ownerField.tlf_internal::switchToEditingMode(this.textFlow,EditingMode.READ_WRITE);
         }
         var editManager:EditManager = EditManager(this.textFlow.interactionManager);
         editManager.beginCompositeOperation();
         if(beginIndex < 0 || endIndex < 0)
         {
            setTextFormatSelectionState = new SelectionState(this.textFlow,this.textFlow.getAbsoluteStart(),this.textLength);
            editManager.applyLeafFormat(charFormat,setTextFormatSelectionState);
            editManager.applyParagraphFormat(paraFormat,setTextFormatSelectionState);
            if(format.url != null)
            {
               if(format.url != "")
               {
                  editManager.applyLink(format.url,format.target,false,setTextFormatSelectionState);
               }
               else
               {
                  editManager.applyLink("",format.target,false,setTextFormatSelectionState);
               }
            }
         }
         else
         {
            setTextFormatSelectionState = new SelectionState(this.textFlow,beginIndex,endIndex);
            editManager.applyLeafFormat(charFormat,setTextFormatSelectionState);
            editManager.applyParagraphFormat(paraFormat,setTextFormatSelectionState);
            if(format.url != null)
            {
               if(format.url != null)
               {
                  editManager.applyLink(format.url,format.target,false,setTextFormatSelectionState);
               }
               else
               {
                  editManager.applyLink("",format.target,false,setTextFormatSelectionState);
               }
            }
         }
         editManager.endCompositeOperation();
         if(Boolean(this.textFlow.interactionManager))
         {
            if(Boolean(tmpSelectionState))
            {
               this.textFlow.interactionManager.selectRange(tmpSelectionState.anchorPosition,tmpSelectionState.activePosition);
            }
            else
            {
               this.textFlow.interactionManager.selectRange(-1,-1);
            }
         }
         if(priorEditingMode != EditingMode.READ_WRITE)
         {
            this._ownerField.tlf_internal::switchToEditingMode(this.textFlow,priorEditingMode);
         }
      }
      
      public function replaceText(beginIndex:int, endIndex:int, newText:String) : void
      {
         if(this.textFlow && this.textFlow.formatResolver != null && (beginIndex > 0 || endIndex < length))
         {
            throw new Error("This method cannot be used on a text field with a style sheet.");
         }
         this.compose();
         if(beginIndex < 0)
         {
            beginIndex = 0;
         }
         var priorEditingMode:String = String(this._ownerField.tlf_internal::getEditingMode(this.textFlow.interactionManager));
         this._ownerField.tlf_internal::switchToEditingMode(this.textFlow,EditingMode.READ_WRITE);
         var editManager:EditManager = EditManager(this.textFlow.interactionManager);
         editManager.beginCompositeOperation();
         editManager.selectRange(beginIndex,endIndex);
         this._ownerField.tlf_internal::insertWithParagraphs(editManager,newText);
         editManager.endCompositeOperation();
         this.update();
         this._ownerField.tlf_internal::switchToEditingMode(this.textFlow,priorEditingMode);
      }
      
      public function update() : void
      {
      }
      
      public function get hostFormat() : ITextLayoutFormat
      {
         return null;
      }
      
      public function setFormatForAllElements(flowGroupElem:FlowGroupElement, format:TextLayoutFormat) : void
      {
         var elem:FlowElement = null;
         var newFormat:TextLayoutFormat = null;
         var len:int = flowGroupElem.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            elem = flowGroupElem.getChildAt(i);
            if(elem is FlowGroupElement)
            {
               this.setFormatForAllElements(FlowGroupElement(elem),format);
            }
            else
            {
               newFormat = new TextLayoutFormat(elem.format);
               newFormat.apply(format);
               elem.format = newFormat;
            }
         }
      }
      
      public function compose() : void
      {
      }
      
      public function set lineBreak(value:String) : void
      {
         if(!this.textFlow)
         {
            this.textFlow = new TextFlow();
         }
         this.textFlow.lineBreak = value;
      }
      
      public function set text(value:String) : void
      {
         var leaf:FlowLeafElement = null;
         var tf:TextFlow = this.isTextStringAndFormat() ? null : this.textFlow;
         if(!tf)
         {
            this._ownerField.tlf_internal::doImport(TextConverter.PLAIN_TEXT_FORMAT,value);
         }
         else
         {
            leaf = tf.getFirstLeaf();
            if(Boolean(leaf))
            {
               tf.hostFormat = leaf.computedFormat;
            }
            this._ownerField.replaceText(0,this._ownerField.length,value);
         }
      }
      
      public function set blockProgression(value:Object) : void
      {
         switch(value)
         {
            case BlockProgression.RL:
            case BlockProgression.TB:
            case FormatValue.INHERIT:
               this.textFlow.blockProgression = value;
               break;
            default:
               this.textFlow.blockProgression = BlockProgression.TB;
         }
      }
      
      public function set embedFonts(value:Boolean) : void
      {
         if(!this.textFlow)
         {
            this.textFlow = new TextFlow();
         }
         this.textFlow.fontLookup = value ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
      }
      
      public function appendText(newText:String) : void
      {
         var priorEditingMode:String = null;
         var tmpSelectionState:SelectionState = null;
         if(!this.textFlow.interactionManager)
         {
            priorEditingMode = EditingMode.READ_ONLY;
         }
         else
         {
            priorEditingMode = String(this.textFlow.interactionManager.editingMode);
            tmpSelectionState = null;
         }
         if(priorEditingMode != EditingMode.READ_ONLY && priorEditingMode != null)
         {
            if(this.textFlow.interactionManager.hasSelection())
            {
               tmpSelectionState = this.textFlow.interactionManager.getSelectionState();
            }
         }
         if(priorEditingMode != EditingMode.READ_WRITE)
         {
            this._ownerField.tlf_internal::switchToEditingMode(this.textFlow,EditingMode.READ_WRITE);
         }
         var editManager:EditManager = EditManager(this.textFlow.interactionManager);
         editManager.selectRange(int.MAX_VALUE,int.MAX_VALUE);
         editManager.beginCompositeOperation();
         this._ownerField.tlf_internal::insertWithParagraphs(editManager,newText);
         editManager.endCompositeOperation();
         this.update();
         if(Boolean(this.textFlow.interactionManager))
         {
            if(Boolean(tmpSelectionState))
            {
               this.textFlow.interactionManager.selectRange(tmpSelectionState.anchorPosition,tmpSelectionState.activePosition);
            }
            else
            {
               this.textFlow.interactionManager.selectRange(-1,-1);
            }
         }
         if(priorEditingMode != EditingMode.READ_WRITE && priorEditingMode != null)
         {
            this._ownerField.tlf_internal::switchToEditingMode(this.textFlow,priorEditingMode);
         }
      }
      
      public function get embedFonts() : Boolean
      {
         if(Boolean(this.textFlow))
         {
            return this.textFlow.fontLookup == FontLookup.EMBEDDED_CFF;
         }
         return false;
      }
      
      public function set textColor(value:uint) : void
      {
         this.textFlow.color = value;
         var fmt:TextLayoutFormat = new TextLayoutFormat();
         fmt.color = value;
         this.setFormatForAllElements(this.textFlow,fmt);
      }
      
      public function isTextStringAndFormat() : Boolean
      {
         return false;
      }
      
      public function get blockProgression() : Object
      {
         if(Boolean(this.textFlow) && Boolean(this.textFlow.computedFormat.blockProgression))
         {
            return this.textFlow.computedFormat.blockProgression;
         }
         return BlockProgression.TB;
      }
      
      public function get lineBreak() : String
      {
         if(Boolean(this.textFlow))
         {
            return this.textFlow.lineBreak;
         }
         return LineBreak.EXPLICIT;
      }
      
      public function get textLength() : int
      {
         return 0;
      }
      
      public function set textFlow(theFlow:TextFlow) : void
      {
      }
      
      public function getTextFormat(beginIndex:int, endIndex:int) : TextFormat
      {
         var iStart:int = 0;
         var iEnd:int = 0;
         var arrFontFamily:Array = null;
         var leading:Number = NaN;
         var str:String = null;
         var leafFontSize:Number = NaN;
         var arrTabStops:Array = null;
         var arrLength:int = 0;
         var i:int = 0;
         var tabStopFmt:TabStopFormat = null;
         var elementRange:ElementRange = null;
         var leafIter:FlowLeafElement = null;
         var linkEl:LinkElement = null;
         var textFormat:TextFormat = new TextFormat();
         var tmpSelectionState:SelectionState = null;
         var priorEditingMode:String = String(this._ownerField.tlf_internal::getEditingMode(this.textFlow.interactionManager));
         if(priorEditingMode != EditingMode.READ_ONLY && priorEditingMode != null)
         {
            if(this.textFlow.interactionManager.hasSelection())
            {
               tmpSelectionState = this.textFlow.interactionManager.getSelectionState();
            }
         }
         else
         {
            this._ownerField.tlf_internal::switchToEditingMode(this.textFlow,EditingMode.READ_SELECT);
         }
         if(beginIndex < 0)
         {
            iStart = this.textFlow.getAbsoluteStart();
            iEnd = this.textLength;
         }
         else if(beginIndex >= 0 && endIndex < 0)
         {
            iStart = beginIndex;
            iEnd = beginIndex;
         }
         else
         {
            iStart = beginIndex;
            iEnd = endIndex;
         }
         this._ownerField.setSelection(iStart,iEnd);
         var charFormat:TextLayoutFormat = TextLayoutFormat(this.textFlow.interactionManager.getCommonCharacterFormat());
         var paraFormat:TextLayoutFormat = TextLayoutFormat(this.textFlow.interactionManager.getCommonParagraphFormat());
         if(Boolean(tmpSelectionState))
         {
            this.textFlow.interactionManager.selectRange(tmpSelectionState.anchorPosition,tmpSelectionState.activePosition);
         }
         else
         {
            this.textFlow.interactionManager.selectRange(-1,-1);
         }
         if(priorEditingMode == EditingMode.READ_ONLY)
         {
            this._ownerField.tlf_internal::switchToEditingMode(this.textFlow,priorEditingMode);
         }
         if(paraFormat.textAlign == TextFormatAlign.LEFT || paraFormat.textAlign == TextFormatAlign.CENTER || paraFormat.textAlign == TextFormatAlign.RIGHT || paraFormat.textAlign == TextFormatAlign.JUSTIFY)
         {
            textFormat.align = paraFormat.textAlign;
         }
         else
         {
            textFormat.align = null;
         }
         if(charFormat.fontWeight == undefined)
         {
            textFormat.bold = null;
         }
         else
         {
            textFormat.bold = charFormat.fontWeight == FontWeight.BOLD;
         }
         textFormat.color = charFormat.color;
         if(charFormat.fontFamily == undefined)
         {
            textFormat.font = null;
         }
         else
         {
            arrFontFamily = String(charFormat.fontFamily).split(",");
            textFormat.font = arrFontFamily[0];
         }
         textFormat.indent = paraFormat.textIndent;
         if(charFormat.fontStyle == undefined)
         {
            textFormat.italic = null;
         }
         else
         {
            textFormat.italic = charFormat.fontStyle == FontPosture.ITALIC;
         }
         if(charFormat.kerning == undefined)
         {
            textFormat.kerning = null;
         }
         else
         {
            textFormat.kerning = charFormat.kerning == Kerning.ON || charFormat.kerning == Kerning.AUTO;
         }
         if(charFormat.lineHeight == undefined || charFormat.lineHeight < -720)
         {
            textFormat.leading = null;
         }
         else
         {
            leading = Number.NaN;
            str = charFormat.lineHeight;
            if(Boolean(str))
            {
               if(str.indexOf("%") == -1)
               {
                  leading = Number(str);
               }
               else
               {
                  leafFontSize = Number(this.textFlow.findLeaf(iStart).computedFormat.fontSize);
                  leading = Number(str.replace(/%/,"")) * leafFontSize / 100;
               }
            }
            if(!isNaN(leading))
            {
               textFormat.leading = leading;
            }
         }
         textFormat.leftMargin = paraFormat.paragraphStartIndent;
         textFormat.letterSpacing = charFormat.trackingRight;
         textFormat.rightMargin = paraFormat.paragraphEndIndent;
         textFormat.size = charFormat.fontSize;
         if(paraFormat.tabStops == undefined)
         {
            textFormat.tabStops = null;
         }
         else
         {
            arrTabStops = [];
            if(paraFormat.tabStops != null)
            {
               arrLength = int(paraFormat.tabStops.length);
               for(i = 0; i < arrLength; i++)
               {
                  tabStopFmt = paraFormat.tabStops[i];
                  if(tabStopFmt.alignment == TabAlignment.START)
                  {
                     arrTabStops.push(tabStopFmt.position);
                  }
               }
               arrTabStops.sort(Array.NUMERIC);
            }
            textFormat.tabStops = arrTabStops;
         }
         if(charFormat.textDecoration == undefined)
         {
            textFormat.underline = null;
         }
         else
         {
            textFormat.underline = charFormat.textDecoration == TextDecoration.UNDERLINE;
         }
         var strURL:String = null;
         var strTarget:String = null;
         if(iStart <= iEnd)
         {
            elementRange = ElementRange.createElementRange(this.textFlow,iStart,iEnd);
            leafIter = elementRange.firstLeaf;
            while(Boolean(leafIter))
            {
               linkEl = leafIter.getParentByType(LinkElement) as LinkElement;
               if(linkEl != null)
               {
                  if(strURL == null)
                  {
                     strURL = linkEl.href;
                  }
                  else if(strURL != linkEl.href)
                  {
                     strURL = "";
                  }
                  if(strTarget == null)
                  {
                     if(linkEl.target == null)
                     {
                        strTarget = "";
                     }
                     else
                     {
                        strTarget = linkEl.target;
                     }
                  }
                  else if(strTarget != linkEl.target)
                  {
                     strTarget = "";
                  }
               }
               else
               {
                  strURL = "";
                  strTarget = "";
               }
               if(leafIter == elementRange.lastLeaf)
               {
                  break;
               }
               leafIter = leafIter.getNextLeaf();
            }
         }
         textFormat.url = strURL == "" ? null : strURL;
         textFormat.target = strTarget == "" ? null : strTarget;
         return textFormat;
      }
      
      public function get textFlow() : TextFlow
      {
         return null;
      }
      
      public function get textColor() : uint
      {
         if(Boolean(this.textFlow))
         {
            return uint(this.textFlow.getFirstLeaf().computedFormat.color);
         }
         return 0;
      }
      
      public function set direction(value:String) : void
      {
         switch(value)
         {
            case Direction.LTR:
            case Direction.RTL:
            case FormatValue.INHERIT:
               break;
            default:
               value = Direction.LTR;
         }
         var fmt:TextLayoutFormat = new TextLayoutFormat();
         fmt.direction = value;
         var p:ParagraphElement = this.textFlow.getFirstLeaf().getParagraph();
         while(Boolean(p))
         {
            p.direction = value;
            p = p.getNextParagraph();
         }
         this.textFlow.direction = value;
      }
      
      public function get direction() : String
      {
         if(this.textFlow.direction != null)
         {
            return this.textFlow.direction;
         }
         return Direction.LTR;
      }
   }
}
