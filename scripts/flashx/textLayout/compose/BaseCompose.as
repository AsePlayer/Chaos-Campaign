package flashx.textLayout.compose
{
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineCreationResult;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.ContainerFormattedElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.ListElement;
   import flashx.textLayout.elements.ListItemElement;
   import flashx.textLayout.elements.OverflowPolicy;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.BaselineOffset;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.ClearFloats;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.Float;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.ListStylePosition;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.VerticalAlign;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.LocaleUtil;
   import flashx.textLayout.utils.Twips;
   
   [ExcludeClass]
   public class BaseCompose
   {
      
      private static var _savedAlignData:AlignData;
      
      protected static var _savedLineSlug:flashx.textLayout.compose.Slug;
      
      protected static var _floatSlug:flashx.textLayout.compose.Slug;
       
      
      protected var _parcelList:flashx.textLayout.compose.ParcelList;
      
      protected var _curElement:FlowLeafElement;
      
      protected var _curElementStart:int;
      
      protected var _curElementOffset:int;
      
      protected var _curParaElement:ParagraphElement;
      
      protected var _curParaFormat:ITextLayoutFormat;
      
      protected var _curParaStart:int;
      
      private var _curLineLeadingModel:String = "";
      
      private var _curLineLeading:Number;
      
      protected var _lastLineLeadingModel:String = "";
      
      protected var _lastLineLeading:Number;
      
      protected var _lastLineDescent:Number;
      
      protected var _paragraphSpaceCarried:Number;
      
      protected var _verticalSpaceCarried:Number;
      
      protected var _blockProgression:String;
      
      protected var _atColumnStart:Boolean;
      
      protected var _textIndent:Number;
      
      private var _controllerLeft:Number;
      
      private var _controllerTop:Number;
      
      private var _controllerRight:Number;
      
      private var _controllerBottom:Number;
      
      protected var _contentLogicalExtent:Number;
      
      protected var _contentCommittedExtent:Number;
      
      protected var _contentCommittedHeight:Number;
      
      protected var _workingContentLogicalExtent:Number;
      
      protected var _workingContentExtent:Number;
      
      protected var _workingContentHeight:Number;
      
      protected var _workingTotalDepth:Number;
      
      protected var _workingParcelIndex:int;
      
      protected var _workingParcelLogicalTop:Number;
      
      protected var _accumulatedMinimumStart:Number;
      
      protected var _parcelLogicalTop:Number;
      
      protected var _parcelLeft:Number;
      
      protected var _parcelTop:Number;
      
      protected var _parcelRight:Number;
      
      protected var _parcelBottom:Number;
      
      protected var _textFlow:TextFlow;
      
      private var _releaseLineCreationData:Boolean;
      
      protected var _flowComposer:flashx.textLayout.compose.IFlowComposer;
      
      protected var _rootElement:ContainerFormattedElement;
      
      protected var _stopComposePos:int;
      
      protected var _startController:ContainerController;
      
      protected var _startComposePosition:int;
      
      protected var _controllerVisibleBoundsXTW:int;
      
      protected var _controllerVisibleBoundsYTW:int;
      
      protected var _controllerVisibleBoundsWidthTW:int;
      
      protected var _controllerVisibleBoundsHeightTW:int;
      
      protected var _forceILGs:Boolean;
      
      protected var _lastGoodStart:int;
      
      protected var _linePass:int;
      
      protected var _paragraphContainsVisibleLines:Boolean;
      
      protected var _lineSlug:flashx.textLayout.compose.Slug;
      
      protected var _pushInFloats:Array;
      
      private var _alignLines:Array;
      
      protected var _curParcel:flashx.textLayout.compose.Parcel;
      
      protected var _curParcelStart:int;
      
      protected var _measuring:Boolean;
      
      protected var _curLine:flashx.textLayout.compose.TextFlowLine;
      
      protected var _previousLine:TextLine;
      
      protected var _listItemElement:ListItemElement;
      
      public function BaseCompose()
      {
         this._lineSlug = new flashx.textLayout.compose.Slug();
         super();
      }
      
      public static function get globalSWFContext() : ISWFContext
      {
         return GlobalSWFContext.globalSWFContext;
      }
      
      private static function createAlignData(tfl:flashx.textLayout.compose.TextFlowLine) : AlignData
      {
         var rslt:AlignData = null;
         if(Boolean(_savedAlignData))
         {
            rslt = _savedAlignData;
            rslt.textFlowLine = tfl;
            _savedAlignData = null;
            return rslt;
         }
         return new AlignData(tfl);
      }
      
      private static function releaseAlignData(ad:AlignData) : void
      {
         ad.textLine = null;
         ad.textFlowLine = null;
         _savedAlignData = ad;
      }
      
      tlf_internal static function computeNumberLineAlignment(alignData:AlignData, textLineWidth:Number, textLineOffset:Number, numberLine:TextLine, coord:Number, delta:Number, extraSpace:Number) : Number
      {
         var rslt:Number = NaN;
         if(alignData.textAlign == TextAlign.CENTER)
         {
            if(TextFlowLine.tlf_internal::getNumberLineParagraphDirection(numberLine) == Direction.LTR)
            {
               rslt = -(numberLine.textWidth + TextFlowLine.tlf_internal::getListEndIndent(numberLine) + delta) - alignData.textIndent;
            }
            else
            {
               rslt = textLineWidth + TextFlowLine.tlf_internal::getListEndIndent(numberLine) + (TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine) - numberLine.textWidth) + (coord - delta + extraSpace - textLineOffset) + alignData.textIndent;
            }
         }
         else if(alignData.textAlign == TextAlign.RIGHT)
         {
            if(TextFlowLine.tlf_internal::getNumberLineParagraphDirection(numberLine) == Direction.LTR)
            {
               rslt = -(numberLine.textWidth + TextFlowLine.tlf_internal::getListEndIndent(numberLine) + delta) - alignData.textIndent;
            }
            else
            {
               rslt = textLineWidth + TextFlowLine.tlf_internal::getListEndIndent(numberLine) + (TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine) - numberLine.textWidth) + alignData.textIndent;
            }
         }
         else if(TextFlowLine.tlf_internal::getNumberLineParagraphDirection(numberLine) == Direction.LTR)
         {
            rslt = -(numberLine.textWidth + TextFlowLine.tlf_internal::getListEndIndent(numberLine)) - alignData.textIndent;
         }
         else
         {
            rslt = textLineWidth + TextFlowLine.tlf_internal::getListEndIndent(numberLine) + (TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine) - numberLine.textWidth) + (coord - textLineOffset) + alignData.textIndent;
         }
         return rslt;
      }
      
      public function get parcelList() : flashx.textLayout.compose.ParcelList
      {
         return this._parcelList;
      }
      
      protected function createParcelList() : flashx.textLayout.compose.ParcelList
      {
         return null;
      }
      
      protected function releaseParcelList(list:flashx.textLayout.compose.ParcelList) : void
      {
      }
      
      public function get startController() : ContainerController
      {
         return this._startController;
      }
      
      tlf_internal function releaseAnyReferences() : void
      {
         this._curElement = null;
         this._curParaElement = null;
         this._curParaFormat = null;
         this._flowComposer = null;
         this._parcelList = null;
         this._rootElement = null;
         this._startController = null;
         this._textFlow = null;
         this._previousLine = null;
         this._curLine = null;
      }
      
      protected function initializeForComposer(composer:flashx.textLayout.compose.IFlowComposer, composeToPosition:int, controllerStartIndex:int, controllerEndIndex:int) : void
      {
         if(!_savedLineSlug)
         {
            this._lineSlug = new flashx.textLayout.compose.Slug();
         }
         else
         {
            this._lineSlug = _savedLineSlug;
            _savedLineSlug = null;
         }
         this._parcelList = this.createParcelList();
         this._paragraphSpaceCarried = 0;
         this._blockProgression = composer.rootElement.computedFormat.blockProgression;
         this._stopComposePos = composeToPosition >= 0 ? int(Math.min(this._textFlow.textLength,composeToPosition)) : this._textFlow.textLength;
         if(controllerStartIndex < 0)
         {
            controllerStartIndex = 0;
         }
         this._parcelList.beginCompose(composer,controllerStartIndex,controllerEndIndex,composeToPosition > 0);
         this._contentLogicalExtent = 0;
         this._contentCommittedExtent = 0;
         this._contentCommittedHeight = 0;
         this._accumulatedMinimumStart = TextLine.MAX_LINE_WIDTH;
         this._parcelLogicalTop = NaN;
         this._linePass = 0;
         this._lastGoodStart = -1;
         if(Boolean(this._pushInFloats))
         {
            this._pushInFloats.length = 0;
         }
         this._listItemElement = null;
      }
      
      private function composeBlockElement(elem:FlowGroupElement, absStart:int) : Boolean
      {
         var child:FlowElement = null;
         var rslt:Boolean = false;
         var boxLeftIndent:Number = NaN;
         var boxRightIndent:Number = NaN;
         var boxTopIndent:Number = NaN;
         var boxBottomIndent:Number = NaN;
         var para:ParagraphElement = null;
         var adjustedDepth:Number = NaN;
         var savedListItemElement:ListItemElement = null;
         var idx:int = 0;
         if(absStart != this._curElementStart + this._curElementOffset)
         {
            idx = elem.findChildIndexAtPosition(this._curElementStart + this._curElementOffset - absStart);
            child = elem.getChildAt(idx);
            absStart += child.parentRelativeStart;
         }
         var composeEntireElement:Boolean = absStart == this._curElementStart + this._curElementOffset;
         while(idx < elem.numChildren && (absStart <= this._stopComposePos || !this.parcelList.atLast()))
         {
            child = elem.getChildAt(idx);
            if(child.computedFormat.clearFloats != ClearFloats.NONE)
            {
               adjustedDepth = this._curParcel.applyClear(child.computedFormat.clearFloats,this._parcelList.totalDepth,child.computedFormat.direction);
               this._parcelList.addTotalDepth(adjustedDepth);
               this._verticalSpaceCarried = 0;
            }
            if(this._blockProgression == BlockProgression.RL)
            {
               boxLeftIndent = Number(child.tlf_internal::getEffectivePaddingTop());
               boxRightIndent = Number(child.tlf_internal::getEffectivePaddingBottom());
               boxTopIndent = Number(child.tlf_internal::getEffectivePaddingRight());
               boxBottomIndent = Number(child.tlf_internal::getEffectivePaddingLeft());
            }
            else
            {
               boxLeftIndent = Number(child.tlf_internal::getEffectivePaddingLeft());
               boxRightIndent = Number(child.tlf_internal::getEffectivePaddingRight());
               boxTopIndent = Number(child.tlf_internal::getEffectivePaddingTop());
               boxBottomIndent = Number(child.tlf_internal::getEffectivePaddingBottom());
            }
            this._parcelList.pushLeftMargin(boxLeftIndent);
            this._parcelList.pushRightMargin(boxRightIndent);
            if(composeEntireElement && boxTopIndent > this._verticalSpaceCarried)
            {
               this._parcelList.addTotalDepth(boxTopIndent - this._verticalSpaceCarried);
            }
            this._verticalSpaceCarried = Math.max(boxTopIndent,0);
            para = child as ParagraphElement;
            if(Boolean(para))
            {
               if(!this.composeParagraphElement(para,absStart))
               {
                  return false;
               }
            }
            else if(child is ListElement)
            {
               rslt = this.composeBlockElement(FlowGroupElement(child),absStart);
               if(!rslt)
               {
                  return false;
               }
            }
            else if(child is ListItemElement)
            {
               savedListItemElement = this._listItemElement;
               this._listItemElement = child as ListItemElement;
               rslt = this.composeBlockElement(FlowGroupElement(child),absStart);
               this._listItemElement = savedListItemElement;
               if(!rslt)
               {
                  return false;
               }
            }
            else if(!this.composeBlockElement(FlowGroupElement(child),absStart))
            {
               return false;
            }
            if(boxBottomIndent > this._verticalSpaceCarried)
            {
               this._parcelList.addTotalDepth(boxBottomIndent - this._verticalSpaceCarried);
            }
            this._verticalSpaceCarried = Math.max(boxBottomIndent,0);
            this._parcelList.popLeftMargin(boxLeftIndent);
            this._parcelList.popRightMargin(boxRightIndent);
            absStart += child.textLength;
            composeEntireElement = true;
            idx++;
         }
         return true;
      }
      
      public function composeTextFlow(textFlow:TextFlow, composeToPosition:int, controllerEndIndex:int) : int
      {
         var startLineIndex:int = 0;
         var line:flashx.textLayout.compose.TextFlowLine = null;
         this._textFlow = textFlow;
         this._releaseLineCreationData = Boolean(textFlow.configuration.releaseLineCreationData) && Boolean(Configuration.tlf_internal::playerEnablesArgoFeatures);
         this._flowComposer = this._textFlow.flowComposer;
         this._rootElement = textFlow;
         this._curElementOffset = 0;
         this._curElement = this._rootElement.getFirstLeaf();
         this._curElementStart = 0;
         this._curParcel = null;
         this.initializeForComposer(this._flowComposer,composeToPosition,-1,controllerEndIndex);
         this.resetControllerBounds();
         this._curElement = this._textFlow.findLeaf(this._startComposePosition);
         this._curElementStart = this._curElement.getAbsoluteStart();
         this._curElementOffset = this._startComposePosition - this._curElementStart;
         if(this._startComposePosition <= this._startController.absoluteStart || !this.advanceToComposeStartPosition())
         {
            if(this._startComposePosition > this._startController.absoluteStart)
            {
               this._startComposePosition = this._startController.absoluteStart;
               this._curElement = this._textFlow.findLeaf(this._startComposePosition);
               this._curElementStart = this._curElement.getAbsoluteStart();
               this._curElementOffset = this._startComposePosition - this._curElementStart;
            }
            if(this._startComposePosition == this._curElement.getParagraph().getAbsoluteStart())
            {
               this._previousLine = null;
            }
            else
            {
               startLineIndex = int(this._flowComposer.findLineIndexAtPosition(this._startComposePosition - 1));
               line = this._flowComposer.getLineAt(startLineIndex);
               this._previousLine = line.getTextLine(true);
            }
            this.advanceToNextParcel();
            if(Boolean(this._curParcel))
            {
               this._curParcel.controller.tlf_internal::clearFloatsAt(0);
            }
         }
         this._startController.tlf_internal::clearComposedLines(this._curElementStart + this._curElementOffset);
         this._curParcelStart = this._startController.absoluteStart;
         for(this.composeInternal(this._rootElement,0); true; )
         {
            if(this.parcelList.atEnd())
            {
               this.parcelHasChanged(null);
               break;
            }
            this.advanceToNextParcel();
         }
         this.releaseParcelList(this._parcelList);
         this._parcelList = null;
         _savedLineSlug = this._lineSlug;
         return this._curElementStart + this._curElementOffset;
      }
      
      private function advanceToComposeStartPosition() : Boolean
      {
         var numFloats:int = 0;
         var floatInfo:FloatCompositionData = null;
         var ilg:InlineGraphicElement = null;
         var logicalHeight:Number = NaN;
         var startLineIndex:int = int(this._flowComposer.findLineIndexAtPosition(this._startComposePosition - 1));
         var curLine:flashx.textLayout.compose.TextFlowLine = this._flowComposer.getLineAt(startLineIndex);
         if(Boolean(curLine.controller.tlf_internal::numFloats))
         {
            if(this._measuring)
            {
               return false;
            }
         }
         this._curLine = curLine;
         var previousElement:FlowLeafElement = this._curElementOffset == 0 ? this._curElement.getPreviousLeaf() : this._curElement;
         this._curLineLeadingModel = previousElement.getParagraph().tlf_internal::getEffectiveLeadingModel();
         var curElem:FlowLeafElement = this._textFlow.findLeaf(this._curLine.absoluteStart);
         var curElemStart:int = curElem.getAbsoluteStart();
         this.calculateLeadingParameters(curElem,curElemStart,TextFlowLine.tlf_internal::findNumberLine(this._curLine.getTextLine()));
         if(this._startComposePosition == this._curElement.getParagraph().getAbsoluteStart())
         {
            this._previousLine = null;
         }
         else
         {
            this._previousLine = this._curLine.getTextLine(true);
         }
         this._paragraphSpaceCarried = this._curLine.spaceAfter;
         this.commitLastLineState(this._curLine);
         var startParcel:int = this._curLine.columnIndex == -1 ? 0 : this._curLine.columnIndex;
         this._curParcel = this._parcelList.currentParcel;
         var floatIndex:int = 0;
         for(var parcelIndex:int = -1; parcelIndex < startParcel; parcelIndex++)
         {
            this.advanceToNextParcel();
            this._curParcelStart = this._curParcel.controller.absoluteStart;
            numFloats = int(this._curParcel.controller.tlf_internal::numFloats);
            if(Boolean(numFloats))
            {
               while(floatIndex < numFloats)
               {
                  floatInfo = this._curParcel.controller.tlf_internal::getFloatAt(floatIndex);
                  if(floatInfo.columnIndex > this._curParcel.columnIndex)
                  {
                     break;
                  }
                  if(floatInfo.floatType != Float.NONE && floatInfo.absolutePosition < this._startComposePosition)
                  {
                     ilg = this._textFlow.findLeaf(floatInfo.absolutePosition) as InlineGraphicElement;
                     logicalHeight = this._blockProgression == BlockProgression.RL ? ilg.tlf_internal::elementWidthWithMarginsAndPadding() : ilg.tlf_internal::elementHeightWithMarginsAndPadding();
                     this._curParcel.knockOut(floatInfo.knockOutWidth,floatInfo.depth - this._lastLineDescent,floatInfo.depth + logicalHeight,floatInfo.floatType == Float.LEFT);
                  }
                  floatIndex++;
               }
            }
            this._curParcel.controller.tlf_internal::clearFloatsAt(this._startComposePosition);
         }
         this._curParcelStart = this._curElementStart + this._curElementOffset;
         if(this._blockProgression == BlockProgression.TB)
         {
            this._parcelList.addTotalDepth(this._curLine.y + this._curLine.ascent - this._curParcel.y);
         }
         else
         {
            this._parcelList.addTotalDepth(this._curParcel.right - this._curLine.x);
         }
         this._atColumnStart = false;
         var lineIndex:int = int(this._flowComposer.findLineIndexAtPosition(this._startController.absoluteStart));
         this.initializeContentBounds(lineIndex,startLineIndex);
         return true;
      }
      
      private function initializeContentBounds(lineIndex:int, lastLineToCheck:int) : void
      {
         var line:flashx.textLayout.compose.TextFlowLine = null;
         var lineExtent:Number = NaN;
         var textLine:TextLine = null;
         var alignData:AlignData = null;
         var paraFormat:ITextLayoutFormat = null;
         var columnIndex:int = -1;
         this._parcelLogicalTop = this.tlf_internal::computeTextFlowLineMinimumLogicalTop(this._flowComposer.getLineAt(lineIndex),null);
         if(this._measuring)
         {
            while(lineIndex <= lastLineToCheck)
            {
               line = this._flowComposer.getLineAt(lineIndex);
               if(line.columnIndex != columnIndex)
               {
                  columnIndex = line.columnIndex;
                  this._contentLogicalExtent = 0;
                  this._contentCommittedExtent = 0;
                  this._accumulatedMinimumStart = TextLine.MAX_LINE_WIDTH;
               }
               lineExtent = Number(line.tlf_internal::lineExtent);
               this._contentLogicalExtent = Math.max(this._contentLogicalExtent,lineExtent);
               if(line.tlf_internal::alignment == TextAlign.LEFT && !line.tlf_internal::hasNumberLine)
               {
                  this._contentCommittedExtent = Math.max(this._contentCommittedExtent,lineExtent);
               }
               else
               {
                  alignData = createAlignData(line);
                  alignData.textLine = line.getTextLine(true);
                  alignData.textAlign = line.tlf_internal::alignment;
                  paraFormat = line.paragraph.computedFormat;
                  alignData.rightSideGap = this.getRightSideGap(line,line.tlf_internal::alignment != TextAlign.LEFT);
                  alignData.leftSideGap = this.getLeftSideGap(line);
                  alignData.textIndent = paraFormat.textIndent;
                  alignData.lineWidth = lineExtent - (alignData.rightSideGap + alignData.leftSideGap);
                  if(!this._alignLines)
                  {
                     this._alignLines = [];
                  }
                  this._alignLines.push(alignData);
               }
               lineIndex++;
            }
         }
         else
         {
            line = this._flowComposer.getLineAt(lastLineToCheck);
            this._contentLogicalExtent = this._contentCommittedExtent = line.tlf_internal::accumulatedLineExtent;
            this._accumulatedMinimumStart = line.tlf_internal::accumulatedMinimumStart;
            if(this._parcelList.currentParcelIndex > 0 && this._parcelList.currentParcel.columnIndex > 0)
            {
               if(this._blockProgression == BlockProgression.TB)
               {
                  this._controllerBottom = this._curParcel.controller.compositionHeight;
               }
               else
               {
                  this._controllerLeft = 0 - this._curParcel.controller.compositionWidth;
               }
               if(this._textFlow.computedFormat.direction == Direction.RTL)
               {
                  this._controllerRight = this._curParcel.controller.compositionWidth;
               }
            }
         }
      }
      
      tlf_internal function computeTextFlowLineMinimumLogicalTop(line:flashx.textLayout.compose.TextFlowLine, textLine:TextLine) : Number
      {
         var pos:int = 0;
         var leafElement:FlowLeafElement = null;
         var adjustedAscent:Number = NaN;
         var parcelTop:Number = NaN;
         var controller:ContainerController = null;
         var lineEnd:int = 0;
         var floatInfo:FloatCompositionData = null;
         if(line.tlf_internal::hasGraphicElement)
         {
            pos = line.absoluteStart;
            leafElement = this._textFlow.findLeaf(pos);
            adjustedAscent = Number(line.tlf_internal::getLineTypographicAscent(leafElement,leafElement.getAbsoluteStart(),textLine));
            parcelTop = this._blockProgression == BlockProgression.RL ? line.x + adjustedAscent : line.y + line.ascent - adjustedAscent;
            controller = line.controller;
            lineEnd = pos + line.textLength;
            if(controller.tlf_internal::numFloats > 0)
            {
               while(pos < lineEnd)
               {
                  floatInfo = controller.tlf_internal::getFloatAtPosition(pos);
                  if(!Boolean(floatInfo))
                  {
                     break;
                  }
                  parcelTop = Math.min(parcelTop,floatInfo.depth);
                  pos = floatInfo.absolutePosition + 1;
               }
            }
            return parcelTop;
         }
         return NaN;
      }
      
      private function resetControllerBounds() : void
      {
         this._controllerLeft = TextLine.MAX_LINE_WIDTH;
         this._controllerTop = TextLine.MAX_LINE_WIDTH;
         this._controllerRight = -TextLine.MAX_LINE_WIDTH;
         this._controllerBottom = -TextLine.MAX_LINE_WIDTH;
      }
      
      protected function get releaseLineCreationData() : Boolean
      {
         return this._releaseLineCreationData;
      }
      
      protected function composeInternal(composeRoot:FlowGroupElement, absStart:int) : void
      {
         this.composeBlockElement(composeRoot,absStart);
      }
      
      protected function composeParagraphElement(elem:ParagraphElement, absStart:int) : Boolean
      {
         var textBlock:TextBlock = null;
         var textLine:TextLine = null;
         this._curParaElement = elem;
         this._curParaStart = absStart;
         this._curParaFormat = elem.computedFormat;
         this._paragraphContainsVisibleLines = this._curElementStart + this._curElementOffset != this._curParaStart;
         var success:Boolean = this.composeParagraphElementIntoLines();
         var okToRelease:Boolean = true;
         if(!this._paragraphContainsVisibleLines)
         {
            textBlock = elem.tlf_internal::getTextBlock();
            textLine = textBlock.lastLine;
            while(Boolean(textLine) && okToRelease)
            {
               if(Boolean(textLine.parent))
               {
                  okToRelease = false;
               }
               textLine = textLine.previousLine;
            }
            if(okToRelease)
            {
               for(textLine = textBlock.lastLine; Boolean(textLine); )
               {
                  textBlock.releaseLines(textLine,textLine);
                  textLine.userData = null;
                  TextLineRecycler.addLineForReuse(textLine);
                  if(Boolean(this._textFlow.tlf_internal::backgroundManager))
                  {
                     this._textFlow.tlf_internal::backgroundManager.removeLineFromCache(textLine);
                  }
                  textLine = textBlock.lastLine;
               }
               elem.tlf_internal::releaseTextBlock();
            }
         }
         if(this.releaseLineCreationData && !okToRelease)
         {
            elem.tlf_internal::releaseLineCreationData();
         }
         return success;
      }
      
      protected function getFirstIndentCharPos(paragraph:ParagraphElement) : int
      {
         var pos:int = 0;
         var leaf:FlowLeafElement = paragraph.getFirstLeaf();
         while(leaf && leaf is InlineGraphicElement && InlineGraphicElement(leaf).tlf_internal::effectiveFloat != Float.NONE)
         {
            pos += leaf.textLength;
            leaf = leaf.getNextLeaf();
         }
         return pos;
      }
      
      protected function composeParagraphElementIntoLines() : Boolean
      {
         var textLine:TextLine = null;
         var leftMargin:Number = NaN;
         var rightMargin:Number = NaN;
         var textAlignment:String = null;
         var numberLine:TextLine = null;
         var needAlignData:Boolean = false;
         var alignData:AlignData = null;
         var spaceBefore:Number = NaN;
         var spaceCarried:Number = NaN;
         var location:int = 0;
         var result:Boolean = true;
         var firstLineIndent:Number = 0;
         if(this._curParaFormat.direction == Direction.LTR)
         {
            leftMargin = Number(this._curParaFormat.paragraphStartIndent);
            rightMargin = Number(this._curParaFormat.paragraphEndIndent);
         }
         else
         {
            leftMargin = Number(this._curParaFormat.paragraphEndIndent);
            rightMargin = Number(this._curParaFormat.paragraphStartIndent);
         }
         this._parcelList.pushLeftMargin(leftMargin);
         this._parcelList.pushRightMargin(rightMargin);
         var firstIndentCharPos:int = this._curParaStart;
         if(this.preProcessILGs(this._curElementStart - this._curParaStart))
         {
            firstIndentCharPos = this.getFirstIndentCharPos(this._curParaElement) + this._curParaStart;
         }
         while(result)
         {
            if(this._parcelList.atEnd())
            {
               result = false;
               break;
            }
            this.startLine();
            if(!this._forceILGs)
            {
               this.processFloatsAtLineStart();
            }
            this._textIndent = this._curElementStart + this._curElementOffset <= firstIndentCharPos ? Number(this._curParaFormat.textIndent) : 0;
            if(this._parcelList.atEnd())
            {
               result = false;
               break;
            }
            textLine = this.composeNextLine();
            if(textLine == null)
            {
               result = false;
               break;
            }
            textAlignment = String(this._curParaFormat.textAlign);
            if(textAlignment == TextAlign.JUSTIFY)
            {
               location = this._curLine.location;
               if(location == TextFlowLineLocation.LAST || location == TextFlowLineLocation.ONLY)
               {
                  textAlignment = String(this._curParaFormat.textAlignLast);
               }
            }
            switch(textAlignment)
            {
               case TextAlign.START:
                  textAlignment = this._curParaFormat.direction == Direction.LTR ? TextAlign.LEFT : TextAlign.RIGHT;
                  break;
               case TextAlign.END:
                  textAlignment = this._curParaFormat.direction == Direction.LTR ? TextAlign.RIGHT : TextAlign.LEFT;
            }
            numberLine = TextFlowLine.tlf_internal::findNumberLine(textLine);
            needAlignData = numberLine && TextFlowLine.tlf_internal::getNumberLineListStylePosition(numberLine) == ListStylePosition.OUTSIDE || textAlignment == TextAlign.CENTER || textAlignment == TextAlign.RIGHT;
            if(Configuration.tlf_internal::playerEnablesArgoFeatures)
            {
               if(Boolean(textLine["hasTabs"]))
               {
                  if(this._curParaFormat.direction == Direction.LTR)
                  {
                     if(!numberLine || TextFlowLine.tlf_internal::getNumberLineListStylePosition(numberLine) == ListStylePosition.INSIDE)
                     {
                        needAlignData = false;
                     }
                     textAlignment = TextAlign.LEFT;
                  }
                  else
                  {
                     needAlignData = true;
                     textAlignment = TextAlign.RIGHT;
                  }
               }
            }
            if(needAlignData)
            {
               alignData = createAlignData(this._curLine);
               alignData.textLine = textLine;
               alignData.textAlign = textAlignment;
            }
            spaceBefore = this._atColumnStart && this._curParaFormat.leadingModel != LeadingModel.BOX ? 0 : this._curLine.spaceBefore;
            spaceCarried = this._atColumnStart ? 0 : this._paragraphSpaceCarried;
            if(spaceBefore != 0 || spaceCarried != 0)
            {
               this._parcelList.addTotalDepth(Math.max(spaceBefore,spaceCarried));
            }
            this._paragraphSpaceCarried = 0;
            if(this._verticalSpaceCarried != 0)
            {
               this._verticalSpaceCarried = 0;
            }
            this._parcelList.addTotalDepth(this._curLine.height);
            alignData = this.calculateLineAlignmentAndBounds(textLine,numberLine,alignData);
            if(Boolean(alignData))
            {
               if(!this._alignLines)
               {
                  this._alignLines = [];
               }
               this._alignLines.push(alignData);
               this._curLine.tlf_internal::alignment = textAlignment;
            }
            if(firstLineIndent != 0)
            {
               if(this._curParaFormat.direction == Direction.LTR)
               {
                  this._parcelList.popLeftMargin(firstLineIndent);
               }
               else
               {
                  this._parcelList.popRightMargin(firstLineIndent);
               }
               firstLineIndent = 0;
            }
            if(!this.processFloatsAtLineEnd(textLine) || !this._curLine)
            {
               this.resetLine(textLine);
            }
            else
            {
               this.endLine(textLine);
               this._lastGoodStart = -1;
               if(this.isLineVisible(textLine))
               {
                  this._curParcel.controller.tlf_internal::addComposedLine(textLine);
                  this._paragraphContainsVisibleLines = true;
               }
               if(this._parcelList.atEnd())
               {
                  result = false;
                  break;
               }
               this._previousLine = textLine;
               this._curElementOffset += this._curLine.textLength;
               if(this._curElementOffset >= this._curElement.textLength)
               {
                  do
                  {
                     this._curElementOffset -= this._curElement.textLength;
                     this._curElementStart += this._curElement.textLength;
                     this._curElement = this._curElement.getNextLeaf();
                     if(this._curElementStart == this._curParaStart + this._curParaElement.textLength)
                     {
                        break;
                     }
                  }
                  while(this._curElementOffset >= this._curElement.textLength || this._curElement.textLength == 0);
                  
               }
               this._paragraphSpaceCarried = this._curLine.spaceAfter;
               if(this._curElementStart == this._curParaStart + this._curParaElement.textLength)
               {
                  break;
               }
            }
         }
         this._parcelList.popLeftMargin(leftMargin);
         this._parcelList.popRightMargin(rightMargin);
         if(firstLineIndent != 0)
         {
            if(this._curParaFormat.direction == Direction.LTR)
            {
               this._parcelList.popLeftMargin(firstLineIndent);
            }
            else
            {
               this._parcelList.popRightMargin(firstLineIndent);
            }
            firstLineIndent = 0;
         }
         this._previousLine = null;
         return result;
      }
      
      protected function createTextLine(targetWidth:Number, allowEmergencyBreaks:Boolean) : TextLine
      {
         var lineOffset:Number = this._curParaFormat.direction == Direction.LTR ? this._lineSlug.leftMargin : this._lineSlug.rightMargin;
         var textLine:TextLine = null;
         textLine = TextLineRecycler.getLineForReuse();
         var textBlock:TextBlock = this._curParaElement.tlf_internal::getTextBlock();
         if(Boolean(textLine))
         {
            textLine = this.swfContext.callInContext(textBlock["recreateTextLine"],textBlock,[textLine,this._previousLine,targetWidth,lineOffset,true]);
         }
         else
         {
            textLine = this.swfContext.callInContext(textBlock.createTextLine,textBlock,[this._previousLine,targetWidth,lineOffset,true]);
         }
         if(!allowEmergencyBreaks && textBlock.textLineCreationResult == TextLineCreationResult.EMERGENCY)
         {
            textLine = null;
         }
         if(textLine == null)
         {
            return null;
         }
         this._curLine.tlf_internal::initialize(this._curParaElement,targetWidth,lineOffset - this._parcelList.insideListItemMargin,textLine.textBlockBeginIndex + this._curParaStart,textLine.rawTextLength,textLine);
         return textLine;
      }
      
      protected function startLine() : void
      {
         this._workingContentExtent = 0;
         this._workingContentHeight = 0;
         this._workingContentLogicalExtent = 0;
         this._workingParcelIndex = this._parcelList.currentParcelIndex;
         this._workingTotalDepth = this.parcelList.totalDepth;
         this._workingParcelLogicalTop = NaN;
      }
      
      protected function isLineVisible(textLine:TextLine) : Boolean
      {
         return this._curParcel.controller.tlf_internal::isLineVisible(this._blockProgression,this._controllerVisibleBoundsXTW,this._controllerVisibleBoundsYTW,this._controllerVisibleBoundsWidthTW,this._controllerVisibleBoundsHeightTW,this._curLine,textLine) != null;
      }
      
      protected function endLine(textLine:TextLine) : void
      {
         this._contentCommittedExtent = Math.max(this._contentCommittedExtent,this._workingContentExtent);
         this._contentCommittedHeight = Math.max(this._contentCommittedHeight,this._workingContentHeight);
         this._contentLogicalExtent = Math.max(this._contentLogicalExtent,this._workingContentLogicalExtent);
         if(!this._measuring)
         {
            this._contentLogicalExtent = this._contentCommittedExtent;
         }
         if(Boolean(this._pushInFloats))
         {
            this._pushInFloats.length = 0;
         }
         this._atColumnStart = false;
         this._linePass = 0;
         if(!isNaN(this._workingParcelLogicalTop))
         {
            this._parcelLogicalTop = this._workingParcelLogicalTop;
         }
      }
      
      protected function resetLine(textLine:TextLine) : void
      {
         if(Boolean(this._textFlow.tlf_internal::backgroundManager))
         {
            this._textFlow.tlf_internal::backgroundManager.removeLineFromCache(textLine);
         }
         if(this._workingParcelIndex != this.parcelList.currentParcelIndex)
         {
            this._linePass = 0;
            if(Boolean(this._pushInFloats))
            {
               this._pushInFloats.length = 0;
            }
         }
         else
         {
            ++this._linePass;
         }
         this.parcelList.addTotalDepth(this._workingTotalDepth - this._parcelList.totalDepth);
         this._workingTotalDepth = this.parcelList.totalDepth;
      }
      
      protected function preProcessILGs(startPos:int) : Boolean
      {
         var inlineGraphic:InlineGraphicElement = null;
         if(!this._curParcel)
         {
            return false;
         }
         var foundFloat:Boolean = false;
         var verticalText:Boolean = this._blockProgression == BlockProgression.RL;
         this._forceILGs = this._parcelList.explicitLineBreaks || verticalText && Boolean(this._curParcel.controller.tlf_internal::measureHeight) || !verticalText && Boolean(this._curParcel.controller.tlf_internal::measureWidth);
         for(var leaf:FlowLeafElement = this._curParaElement.findLeaf(startPos); Boolean(leaf); leaf = leaf.getNextLeaf(this._curParaElement))
         {
            if(leaf is InlineGraphicElement)
            {
               inlineGraphic = leaf as InlineGraphicElement;
               inlineGraphic.tlf_internal::setEffectiveFloat(this._forceILGs ? Float.NONE : inlineGraphic.tlf_internal::computedFloat);
               foundFloat = true;
            }
         }
         return foundFloat;
      }
      
      protected function processFloatsAtLineStart() : void
      {
         var i:int = 0;
         var pos:int = 0;
         var leaf:FlowLeafElement = null;
         if(this._forceILGs)
         {
            return;
         }
         if(Boolean(this._pushInFloats) && this._pushInFloats.length > 0)
         {
            for(i = 0; i < this._pushInFloats.length; i++)
            {
               pos = int(this._pushInFloats[i]);
               leaf = this._textFlow.findLeaf(pos);
               if(!this.composeFloat(leaf as InlineGraphicElement,false))
               {
                  this._pushInFloats.length = i;
               }
            }
         }
      }
      
      protected function processFloatsAtLineEnd(textLine:TextLine) : Boolean
      {
         var floatPosition:int = 0;
         var floatIndex:int = 0;
         var elem:InlineGraphicElement = null;
         var logicalFloatHeight:Number = NaN;
         var floatInfo:FloatCompositionData = null;
         var adjustTop:Number = NaN;
         var inlineGraphic:InlineGraphicElement = null;
         if(!textLine.hasGraphicElement && this._linePass <= 0)
         {
            return true;
         }
         if(Boolean(this._pushInFloats) && this._pushInFloats.length > 0)
         {
            floatPosition = int(this._pushInFloats[this._pushInFloats.length - 1]);
            if(this._curLine.absoluteStart + this._curLine.textLength <= floatPosition)
            {
               for(floatIndex = this._pushInFloats.length - 1; floatIndex >= 0; floatIndex--)
               {
                  floatPosition = int(this._pushInFloats[floatIndex]);
                  elem = this._textFlow.findLeaf(floatPosition) as InlineGraphicElement;
                  logicalFloatHeight = this._blockProgression == BlockProgression.RL ? elem.tlf_internal::elementWidth + elem.tlf_internal::getEffectivePaddingLeft() + elem.tlf_internal::getEffectivePaddingRight() : elem.tlf_internal::elementHeightWithMarginsAndPadding();
                  floatInfo = this._curLine.controller.tlf_internal::getFloatAtPosition(floatPosition);
                  if(Boolean(floatInfo) && floatInfo.absolutePosition == floatPosition)
                  {
                     adjustTop = isNaN(this._lastLineDescent) ? 0 : this._lastLineDescent;
                     this._curParcel.removeKnockOut(floatInfo.knockOutWidth,floatInfo.depth - adjustTop,floatInfo.depth + logicalFloatHeight,floatInfo.floatType == Float.LEFT);
                  }
               }
               this._curLine.controller.tlf_internal::clearFloatsAt(this._pushInFloats[0]);
               --this._pushInFloats.length;
               return false;
            }
         }
         var elementStart:int = this._curElementStart;
         var element:FlowLeafElement = this._curElement;
         var endPos:int = this._curLine.absoluteStart + this._curLine.textLength;
         var skipCount:int = 0;
         var hasInlines:Boolean = false;
         while(elementStart < endPos)
         {
            if(element is InlineGraphicElement)
            {
               inlineGraphic = InlineGraphicElement(element);
               if(inlineGraphic.tlf_internal::computedFloat == Float.NONE || this._forceILGs)
               {
                  hasInlines = true;
               }
               else if(this._linePass == 0)
               {
                  if(!this._pushInFloats)
                  {
                     this._pushInFloats = [];
                  }
                  this._pushInFloats.push(elementStart);
               }
               else if(this._pushInFloats.indexOf(elementStart) >= 0)
               {
                  skipCount++;
               }
               else if(!this.composeFloat(inlineGraphic,true))
               {
                  this.advanceToNextParcel();
                  return false;
               }
            }
            elementStart += element.textLength;
            element = element.getNextLeaf();
         }
         var completed:Boolean = skipCount >= (Boolean(this._pushInFloats) ? this._pushInFloats.length : 0);
         if(completed && hasInlines)
         {
            this.processInlinesAtLineEnd(textLine);
         }
         return completed;
      }
      
      protected function processInlinesAtLineEnd(textLine:TextLine) : void
      {
         var inlineGraphic:InlineGraphicElement = null;
         var elementStart:int = this._curElementStart;
         var element:FlowLeafElement = this._curElement;
         var endPos:int = this._curLine.absoluteStart + this._curLine.textLength;
         while(elementStart < endPos)
         {
            if(element is InlineGraphicElement)
            {
               inlineGraphic = element as InlineGraphicElement;
               if(inlineGraphic.tlf_internal::computedFloat == Float.NONE || this._forceILGs)
               {
                  this.composeInlineGraphicElement(inlineGraphic,textLine);
               }
            }
            elementStart += element.textLength;
            element = element.getNextLeaf();
         }
      }
      
      protected function composeInlineGraphicElement(inlineGraphic:InlineGraphicElement, textLine:TextLine) : Boolean
      {
         var marginAndPaddingX:Number = this._blockProgression == BlockProgression.RL ? -inlineGraphic.tlf_internal::getEffectivePaddingRight() : Number(inlineGraphic.tlf_internal::getEffectivePaddingLeft());
         var marginAndPaddingY:Number = Number(inlineGraphic.tlf_internal::getEffectivePaddingTop());
         var fteInline:DisplayObject = inlineGraphic.tlf_internal::placeholderGraphic.parent;
         this._curParcel.controller.tlf_internal::addFloatAt(this._curParaStart + inlineGraphic.getElementRelativeStart(this._curParaElement),inlineGraphic.graphic,Float.NONE,marginAndPaddingX,marginAndPaddingY,Boolean(fteInline) ? fteInline.alpha : 1,Boolean(fteInline) ? fteInline.transform.matrix : null,this._parcelList.totalDepth,0,this._curParcel.columnIndex,textLine);
         return true;
      }
      
      protected function composeFloat(elem:InlineGraphicElement, afterLine:Boolean) : Boolean
      {
         var logicalFloatWidth:Number = NaN;
         var logicalFloatHeight:Number = NaN;
         var floatType:String = null;
         var floatRect:Rectangle = null;
         var knockOutWidth:Number = NaN;
         var adjustTop:Number = NaN;
         if(elem.tlf_internal::elementHeight == 0 || elem.tlf_internal::elementWidth == 0)
         {
            return true;
         }
         if(this._lastGoodStart == -1)
         {
            this._lastGoodStart = this._curElementStart + this._curElementOffset;
         }
         var verticalText:Boolean = this._blockProgression == BlockProgression.RL;
         var effectiveLastLineDescent:Number = 0;
         if((afterLine || !this._atColumnStart) && !isNaN(this._lastLineDescent))
         {
            effectiveLastLineDescent = this._lastLineDescent;
         }
         var spaceBefore:Number = 0;
         if(this._curLine && this._curParaElement != this._curLine.paragraph && !this._atColumnStart)
         {
            spaceBefore = Math.max(this._curParaElement.computedFormat.paragraphSpaceBefore,this._paragraphSpaceCarried);
         }
         var totalDepth:Number = this._parcelList.totalDepth + spaceBefore + effectiveLastLineDescent;
         if(!_floatSlug)
         {
            _floatSlug = new flashx.textLayout.compose.Slug();
         }
         if(verticalText)
         {
            logicalFloatWidth = elem.tlf_internal::elementHeight + elem.tlf_internal::getEffectivePaddingTop() + elem.tlf_internal::getEffectivePaddingBottom();
            logicalFloatHeight = elem.tlf_internal::elementWidth + elem.tlf_internal::getEffectivePaddingLeft() + elem.tlf_internal::getEffectivePaddingRight();
         }
         else
         {
            logicalFloatWidth = elem.tlf_internal::elementWidthWithMarginsAndPadding();
            logicalFloatHeight = elem.tlf_internal::elementHeightWithMarginsAndPadding();
         }
         var floatPosition:int = elem.getAbsoluteStart();
         var floatFits:Boolean = this._parcelList.fitFloat(_floatSlug,totalDepth,logicalFloatWidth,logicalFloatHeight);
         if(!floatFits && (this._curParcel.fitAny || this._curParcel.fitsInHeight(totalDepth,int(logicalFloatHeight))) && (!this._curLine || this._curLine.absoluteStart == floatPosition || afterLine))
         {
            floatFits = true;
         }
         if(floatFits)
         {
            floatType = elem.tlf_internal::computedFloat;
            if(floatType == Float.START)
            {
               floatType = this._curParaFormat.direction == Direction.LTR ? Float.LEFT : Float.RIGHT;
            }
            else if(floatType == Float.END)
            {
               floatType = this._curParaFormat.direction == Direction.LTR ? Float.RIGHT : Float.LEFT;
            }
            floatRect = this.calculateFloatBounds(elem,verticalText,floatType);
            if(verticalText)
            {
               this._workingContentExtent = Math.max(this._workingContentExtent,floatRect.bottom);
               this._workingContentHeight = Math.max(this._workingContentHeight,_floatSlug.depth + floatRect.width);
               this._workingContentLogicalExtent = Math.max(this._workingContentLogicalExtent,floatRect.bottom);
               this._accumulatedMinimumStart = Math.min(this._accumulatedMinimumStart,floatRect.y);
            }
            else
            {
               this._workingContentExtent = Math.max(this._workingContentExtent,floatRect.right);
               this._workingContentHeight = Math.max(this._workingContentHeight,_floatSlug.depth + floatRect.height);
               this._workingContentLogicalExtent = Math.max(this._workingContentLogicalExtent,floatRect.right);
               this._accumulatedMinimumStart = Math.min(this._accumulatedMinimumStart,floatRect.x);
            }
            if(floatPosition == this._curParcelStart)
            {
               this._workingParcelLogicalTop = _floatSlug.depth;
            }
            knockOutWidth = (floatType == Float.LEFT ? _floatSlug.leftMargin : _floatSlug.rightMargin) + logicalFloatWidth;
            adjustTop = isNaN(this._lastLineDescent) ? 0 : this._lastLineDescent;
            this._curParcel.knockOut(knockOutWidth,_floatSlug.depth - adjustTop,_floatSlug.depth + logicalFloatHeight,floatType == Float.LEFT);
            this._curParcel.controller.tlf_internal::addFloatAt(floatPosition,elem.graphic,floatType,floatRect.x,floatRect.y,elem.computedFormat.textAlpha,null,_floatSlug.depth,knockOutWidth,this._curParcel.columnIndex,this._curParcel.controller.container);
         }
         return floatFits;
      }
      
      private function calculateFloatBounds(elem:InlineGraphicElement, verticalText:Boolean, floatType:String) : Rectangle
      {
         var floatRect:Rectangle = new Rectangle();
         if(verticalText)
         {
            floatRect.x = this._curParcel.right - _floatSlug.depth - elem.tlf_internal::elementWidth - elem.tlf_internal::getEffectivePaddingRight();
            floatRect.y = floatType == Float.LEFT ? this._curParcel.y + _floatSlug.leftMargin + elem.tlf_internal::getEffectivePaddingTop() : this._curParcel.bottom - _floatSlug.rightMargin - elem.tlf_internal::getEffectivePaddingBottom() - elem.tlf_internal::elementHeight;
            floatRect.width = elem.tlf_internal::elementWidth;
            floatRect.height = elem.tlf_internal::elementHeight;
         }
         else
         {
            floatRect.x = floatType == Float.LEFT ? this._curParcel.x + _floatSlug.leftMargin + elem.tlf_internal::getEffectivePaddingLeft() : this._curParcel.right - _floatSlug.rightMargin - elem.tlf_internal::getEffectivePaddingRight() - elem.tlf_internal::elementWidth;
            floatRect.y = this._curParcel.y + _floatSlug.depth + elem.tlf_internal::getEffectivePaddingTop();
            floatRect.width = elem.tlf_internal::elementWidth;
            floatRect.height = elem.tlf_internal::elementHeight;
         }
         return floatRect;
      }
      
      private function calculateLineWidthExplicit(textLine:TextLine) : Number
      {
         var isRTL:Boolean = this._curParaElement.computedFormat.direction == Direction.RTL;
         var lastAtom:int = textLine.atomCount - 1;
         var endOfParagraph:Boolean = this._curLine.absoluteStart + this._curLine.textLength == this._curParaStart + this._curParaElement.textLength;
         if(endOfParagraph && !isRTL)
         {
            lastAtom--;
         }
         var bounds:Rectangle = textLine.getAtomBounds(lastAtom >= 0 ? lastAtom : 0);
         var lineWidth:Number = this._blockProgression == BlockProgression.TB ? (lastAtom >= 0 ? bounds.right : bounds.left) : (lastAtom >= 0 ? bounds.bottom : bounds.top);
         if(isRTL)
         {
            bounds = textLine.getAtomBounds(lastAtom != 0 && endOfParagraph ? 1 : 0);
            lineWidth -= this._blockProgression == BlockProgression.TB ? bounds.left : bounds.top;
         }
         textLine.flushAtomData();
         return lineWidth;
      }
      
      private function getRightSideGap(curLine:flashx.textLayout.compose.TextFlowLine, aligned:Boolean) : Number
      {
         var textLine:TextLine = null;
         var numberLine:TextLine = null;
         var elem:FlowGroupElement = curLine.paragraph;
         var paraFormat:ITextLayoutFormat = elem.computedFormat;
         var rightSideGap:Number = paraFormat.direction == Direction.RTL ? Number(paraFormat.paragraphStartIndent) : Number(paraFormat.paragraphEndIndent);
         if(paraFormat.direction == Direction.RTL && Boolean(curLine.location & TextFlowLineLocation.FIRST))
         {
            rightSideGap += paraFormat.textIndent;
            if(Boolean(curLine.tlf_internal::hasNumberLine) && elem.getParentByType(ListItemElement).computedFormat.listStylePosition == ListStylePosition.INSIDE)
            {
               textLine = curLine.getTextLine(true);
               numberLine = TextFlowLine.tlf_internal::findNumberLine(textLine);
               rightSideGap += TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine);
            }
         }
         do
         {
            rightSideGap += this._blockProgression == BlockProgression.TB ? elem.tlf_internal::getEffectivePaddingRight() : elem.tlf_internal::getEffectivePaddingBottom();
            elem = elem.parent;
         }
         while(!(elem is TextFlow));
         
         return rightSideGap;
      }
      
      private function getLeftSideGap(curLine:flashx.textLayout.compose.TextFlowLine) : Number
      {
         var textLine:TextLine = null;
         var numberLine:TextLine = null;
         var elem:FlowGroupElement = curLine.paragraph;
         var paraFormat:ITextLayoutFormat = elem.computedFormat;
         var leftSideGap:Number = paraFormat.direction == Direction.LTR ? Number(paraFormat.paragraphStartIndent) : Number(paraFormat.paragraphEndIndent);
         if(paraFormat.direction == Direction.LTR && Boolean(curLine.location & TextFlowLineLocation.FIRST))
         {
            leftSideGap += paraFormat.textIndent;
            if(Boolean(curLine.tlf_internal::hasNumberLine) && elem.getParentByType(ListItemElement).computedFormat.listStylePosition == ListStylePosition.INSIDE)
            {
               textLine = curLine.getTextLine(true);
               numberLine = TextFlowLine.tlf_internal::findNumberLine(textLine);
               leftSideGap += TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine);
            }
         }
         do
         {
            leftSideGap += this._blockProgression == BlockProgression.TB ? elem.tlf_internal::getEffectivePaddingLeft() : elem.tlf_internal::getEffectivePaddingTop();
            elem = elem.parent;
         }
         while(!(elem is TextFlow));
         
         return leftSideGap;
      }
      
      private function calculateLineAlignmentAndBounds(textLine:TextLine, numberLine:TextLine, alignData:AlignData) : AlignData
      {
         var extraSpace:Number = NaN;
         var coord:Number = NaN;
         var adjustedLogicalRight:Number = NaN;
         var textLineWidth:Number = NaN;
         var edgeAdjust:Number = NaN;
         var numberLineStart:Number = NaN;
         var numberLineMaxExtent:Number = NaN;
         var lineWidth:Number = this._parcelList.explicitLineBreaks ? this.calculateLineWidthExplicit(textLine) : textLine.textWidth;
         var rightSideGap:Number = this._lineSlug.rightMargin;
         var leftSideGap:Number = this._lineSlug.leftMargin;
         var delta:Number = 0;
         if(Boolean(alignData))
         {
            alignData.rightSideGap = rightSideGap;
            alignData.leftSideGap = leftSideGap;
            alignData.lineWidth = lineWidth;
            alignData.textIndent = this._curParaFormat.textIndent;
            if(this._blockProgression == BlockProgression.TB)
            {
               if(!this._measuring)
               {
                  textLineWidth = textLine.textWidth;
                  extraSpace = this._curParcel.width - leftSideGap - rightSideGap - textLineWidth;
                  if(alignData.textAlign != TextAlign.LEFT)
                  {
                     delta = alignData.textAlign == TextAlign.CENTER ? extraSpace / 2 : extraSpace;
                     coord = this._curParcel.x + leftSideGap + delta;
                  }
                  else
                  {
                     coord = this._curParcel.x + leftSideGap + extraSpace;
                  }
                  if(alignData.textAlign != TextAlign.LEFT)
                  {
                     this._curLine.x = coord;
                     textLine.x = coord;
                  }
                  else
                  {
                     textLine.x = this._curLine.x;
                  }
                  if(Boolean(numberLine) && TextFlowLine.tlf_internal::getNumberLineListStylePosition(numberLine) == ListStylePosition.OUTSIDE)
                  {
                     numberLine.x = tlf_internal::computeNumberLineAlignment(alignData,textLine.textWidth,textLine.x,numberLine,coord,delta,extraSpace);
                     this._curLine.tlf_internal::numberLinePosition = numberLine.x;
                  }
                  releaseAlignData(alignData);
                  alignData = null;
               }
            }
            else if(!this._measuring)
            {
               extraSpace = this._curParcel.height - leftSideGap - rightSideGap - textLine.textWidth;
               if(alignData.textAlign != TextAlign.LEFT)
               {
                  delta = alignData.textAlign == TextAlign.CENTER ? extraSpace / 2 : extraSpace;
                  coord = this._curParcel.y + leftSideGap + delta;
               }
               else
               {
                  coord = this._curParcel.y + leftSideGap + extraSpace;
               }
               if(alignData.textAlign != TextAlign.LEFT)
               {
                  this._curLine.y = coord;
                  textLine.y = coord;
               }
               else
               {
                  textLine.y = this._curLine.y;
               }
               if(Boolean(numberLine) && TextFlowLine.tlf_internal::getNumberLineListStylePosition(numberLine) == ListStylePosition.OUTSIDE)
               {
                  numberLine.y = tlf_internal::computeNumberLineAlignment(alignData,textLine.textWidth,textLine.y,numberLine,coord,delta,extraSpace);
                  this._curLine.tlf_internal::numberLinePosition = numberLine.y;
               }
               releaseAlignData(alignData);
               alignData = null;
            }
         }
         var lineExtent:Number = lineWidth + leftSideGap + rightSideGap + delta;
         this._curLine.tlf_internal::lineExtent = lineExtent;
         this._workingContentLogicalExtent = Math.max(this._workingContentLogicalExtent,lineExtent);
         this._curLine.tlf_internal::accumulatedLineExtent = Math.max(this._contentLogicalExtent,this._workingContentLogicalExtent);
         if(!alignData)
         {
            edgeAdjust = this._curParaFormat.direction == Direction.LTR ? Math.max(this._curLine.lineOffset,0) : Number(this._curParaFormat.paragraphEndIndent);
            edgeAdjust = this._blockProgression == BlockProgression.RL ? this._curLine.y - edgeAdjust : this._curLine.x - edgeAdjust;
            if(Boolean(numberLine))
            {
               numberLineStart = this._blockProgression == BlockProgression.TB ? numberLine.x + this._curLine.x : numberLine.y + this._curLine.y;
               edgeAdjust = Math.min(edgeAdjust,numberLineStart);
               if(TextFlowLine.tlf_internal::getNumberLineListStylePosition(numberLine) == ListStylePosition.OUTSIDE)
               {
                  numberLineMaxExtent = numberLineStart + TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine);
                  numberLineMaxExtent -= lineExtent;
                  if(numberLineMaxExtent > 0)
                  {
                     delta += numberLineMaxExtent;
                  }
               }
            }
            this._workingContentExtent = Math.max(this._workingContentExtent,lineWidth + leftSideGap + Math.max(0,rightSideGap) + delta);
            this._curLine.tlf_internal::accumulatedMinimumStart = this._accumulatedMinimumStart = Math.min(this._accumulatedMinimumStart,edgeAdjust);
         }
         if(this._curLine.absoluteStart == this._curParcelStart && isNaN(this._workingParcelLogicalTop))
         {
            this._workingParcelLogicalTop = this.tlf_internal::computeTextFlowLineMinimumLogicalTop(this._curLine,textLine);
         }
         return alignData;
      }
      
      protected function composeNextLine() : TextLine
      {
         return null;
      }
      
      protected function fitLineToParcel(textLine:TextLine, isNewLine:Boolean, numberLine:TextLine) : Boolean
      {
         var composeYCoord:Number = this._lineSlug.depth;
         this._curLine.tlf_internal::setController(this._curParcel.controller,this._curParcel.columnIndex);
         for(var spaceBefore:Number = Math.max(this._curLine.spaceBefore,this._paragraphSpaceCarried); true; )
         {
            this.finishComposeLine(textLine,numberLine);
            if(this._parcelList.getLineSlug(this._lineSlug,spaceBefore + (this._parcelList.atLast() && this._textFlow.configuration.overflowPolicy != OverflowPolicy.FIT_DESCENDERS ? this._curLine.height - this._curLine.ascent : this._curLine.height + this._curLine.descent),1,this._textIndent,this._curParaFormat.direction == Direction.LTR))
            {
               if(Twips.to(this._lineSlug.width) == this._curLine.tlf_internal::outerTargetWidthTW && this._lineSlug.depth != composeYCoord)
               {
                  this.finishComposeLine(textLine,numberLine);
               }
               break;
            }
            spaceBefore = this._curLine.spaceBefore;
            if(this._pushInFloats && this._parcelList.currentParcel.fitAny && this._pushInFloats.length > 0)
            {
               break;
            }
            while(true)
            {
               this.advanceToNextParcel();
               if(!this._curLine || this._parcelList.atEnd())
               {
                  return false;
               }
               if(this._parcelList.getLineSlug(this._lineSlug,0,1,this._textIndent,this._curParaFormat.direction == Direction.LTR))
               {
                  composeYCoord = this._lineSlug.depth;
                  break;
               }
            }
            this._curLine.tlf_internal::setController(this._curParcel.controller,this._curParcel.columnIndex);
         }
         if(Twips.to(this._lineSlug.width) != this._curLine.tlf_internal::outerTargetWidthTW)
         {
            return false;
         }
         if(isNewLine)
         {
            if(Boolean(numberLine))
            {
               TextFlowLine.tlf_internal::initializeNumberLinePosition(numberLine,this._listItemElement,this._curParaElement,textLine.textWidth);
            }
            this._curLine.tlf_internal::createAdornments(this._blockProgression,this._curElement,this._curElementStart,textLine,numberLine);
         }
         return true;
      }
      
      protected function calculateLeadingParameters(curElement:FlowLeafElement, curElementStart:int, numberLine:TextLine = null) : Number
      {
         var effectiveListMarkerFormat:ITextLayoutFormat = null;
         var lineBox:Rectangle = null;
         if(Boolean(numberLine))
         {
            effectiveListMarkerFormat = TextFlowLine.tlf_internal::getNumberLineSpanFormat(numberLine);
         }
         if(this._curLineLeadingModel == LeadingModel.BOX)
         {
            lineBox = this._curLine.tlf_internal::getCSSLineBox(this._blockProgression,curElement,curElementStart,this._textFlow.flowComposer.swfContext,effectiveListMarkerFormat,numberLine);
            this._curLineLeading = Boolean(lineBox) ? lineBox.bottom : 0;
            return Boolean(lineBox) ? -lineBox.top : 0;
         }
         this._curLineLeading = this._curLine.tlf_internal::getLineLeading(this._blockProgression,curElement,curElementStart);
         if(Boolean(effectiveListMarkerFormat))
         {
            this._curLineLeading = Math.max(this._curLineLeading,TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(effectiveListMarkerFormat.lineHeight,effectiveListMarkerFormat.fontSize));
         }
         return 0;
      }
      
      protected function finishComposeLine(curTextLine:TextLine, numberLine:TextLine) : void
      {
         var rise:Number = NaN;
         var run:Number = NaN;
         var containerAttrs:ITextLayoutFormat = null;
         var baselineType:Object = null;
         var firstBaselineOffsetBasis:String = null;
         var firstLineAdjustment:LeadingAdjustment = null;
         var curLineAscent:Number = NaN;
         var curLeadingDirectionUp:Boolean = false;
         var prevLeadingDirectionUp:Boolean = false;
         var prevLineFirstElement:FlowLeafElement = null;
         var adjustment:LeadingAdjustment = null;
         var spaceAdjust:Number = NaN;
         var lineHeight:Number = 0;
         if(this._blockProgression == BlockProgression.RL)
         {
            rise = this._curParcel.x + this._curParcel.width - this._lineSlug.depth;
            run = this._curParcel.y;
         }
         else
         {
            rise = this._curParcel.y + this._lineSlug.depth;
            run = this._curParcel.x;
         }
         run += this._lineSlug.leftMargin;
         this._curLineLeadingModel = this._curParaElement.tlf_internal::getEffectiveLeadingModel();
         var secondaryLeadingParameter:Number = this.calculateLeadingParameters(this._curElement,this._curElementStart,numberLine);
         if(this._curLineLeadingModel == LeadingModel.BOX)
         {
            lineHeight += this._atColumnStart ? 0 : this._lastLineDescent;
            lineHeight += secondaryLeadingParameter;
         }
         else
         {
            containerAttrs = this._curParcel.controller.computedFormat;
            baselineType = BaselineOffset.LINE_HEIGHT;
            if(this._atColumnStart)
            {
               if(containerAttrs.firstBaselineOffset != BaselineOffset.AUTO && containerAttrs.verticalAlign != VerticalAlign.BOTTOM && containerAttrs.verticalAlign != VerticalAlign.MIDDLE)
               {
                  baselineType = containerAttrs.firstBaselineOffset;
                  firstBaselineOffsetBasis = LocaleUtil.leadingModel(containerAttrs.locale) == LeadingModel.IDEOGRAPHIC_TOP_DOWN ? TextBaseline.IDEOGRAPHIC_BOTTOM : TextBaseline.ROMAN;
                  lineHeight -= curTextLine.getBaselinePosition(firstBaselineOffsetBasis);
               }
               else if(this._curLineLeadingModel == LeadingModel.APPROXIMATE_TEXT_FIELD)
               {
                  lineHeight += Math.round(curTextLine.descent) + Math.round(curTextLine.ascent);
                  if(this._blockProgression == BlockProgression.TB)
                  {
                     lineHeight = Math.round(rise + lineHeight) - rise;
                  }
                  else
                  {
                     lineHeight = rise - Math.round(rise - lineHeight);
                  }
                  baselineType = 0;
               }
               else
               {
                  baselineType = BaselineOffset.ASCENT;
                  if(curTextLine.hasGraphicElement)
                  {
                     firstLineAdjustment = this.getLineAdjustmentForInline(curTextLine,this._curLineLeadingModel,true);
                     if(firstLineAdjustment != null)
                     {
                        if(this._blockProgression == BlockProgression.RL)
                        {
                           firstLineAdjustment.rise = -firstLineAdjustment.rise;
                        }
                        this._curLineLeading += firstLineAdjustment.leading;
                        rise += firstLineAdjustment.rise;
                     }
                  }
                  lineHeight -= curTextLine.getBaselinePosition(TextBaseline.ROMAN);
               }
            }
            if(baselineType == BaselineOffset.ASCENT)
            {
               curLineAscent = Number(this._curLine.tlf_internal::getLineTypographicAscent(this._curElement,this._curElementStart,curTextLine));
               if(Boolean(numberLine))
               {
                  lineHeight += Math.max(curLineAscent,TextFlowLine.tlf_internal::getTextLineTypographicAscent(numberLine,null,0,0));
               }
               else
               {
                  lineHeight += curLineAscent;
               }
            }
            else if(baselineType == BaselineOffset.LINE_HEIGHT)
            {
               if(this._curLineLeadingModel == LeadingModel.APPROXIMATE_TEXT_FIELD)
               {
                  lineHeight += Math.round(this._lastLineDescent) + Math.round(curTextLine.ascent) + Math.round(curTextLine.descent) + Math.round(this._curLineLeading);
               }
               else if(this._curLineLeadingModel == LeadingModel.ASCENT_DESCENT_UP)
               {
                  lineHeight += this._lastLineDescent + curTextLine.ascent + this._curLineLeading;
               }
               else
               {
                  curLeadingDirectionUp = this._atColumnStart ? true : Boolean(ParagraphElement.tlf_internal::useUpLeadingDirection(this._curLineLeadingModel));
                  prevLeadingDirectionUp = this._atColumnStart || this._lastLineLeadingModel == "" ? true : Boolean(ParagraphElement.tlf_internal::useUpLeadingDirection(this._lastLineLeadingModel));
                  if(curLeadingDirectionUp)
                  {
                     lineHeight += this._curLineLeading;
                  }
                  else if(!prevLeadingDirectionUp)
                  {
                     lineHeight += this._lastLineLeading;
                  }
                  else
                  {
                     lineHeight += this._lastLineDescent + curTextLine.ascent;
                  }
               }
            }
            else
            {
               lineHeight += Number(baselineType);
            }
            if(curTextLine.hasGraphicElement && baselineType != BaselineOffset.ASCENT)
            {
               adjustment = this.getLineAdjustmentForInline(curTextLine,this._curLineLeadingModel,false);
               if(adjustment != null)
               {
                  if(this._blockProgression == BlockProgression.RL)
                  {
                     adjustment.rise = -adjustment.rise;
                  }
                  this._curLineLeading += adjustment.leading;
                  rise += adjustment.rise;
               }
            }
         }
         rise += this._blockProgression == BlockProgression.RL ? -lineHeight : lineHeight - curTextLine.ascent;
         var spaceBefore:Number = this._atColumnStart && this._curLineLeadingModel != LeadingModel.BOX ? 0 : this._curLine.spaceBefore;
         var spaceCarried:Number = this._atColumnStart ? 0 : this._paragraphSpaceCarried;
         if(spaceBefore != 0 || spaceCarried != 0)
         {
            spaceAdjust = Math.max(spaceBefore,spaceCarried);
            rise += this._blockProgression == BlockProgression.RL ? -spaceAdjust : spaceAdjust;
         }
         if(this._blockProgression == BlockProgression.TB)
         {
            this._curLine.tlf_internal::setXYAndHeight(run,rise,lineHeight);
         }
         else
         {
            this._curLine.tlf_internal::setXYAndHeight(rise,run,lineHeight);
         }
      }
      
      private function applyTextAlign(effectiveParcelWidth:Number) : void
      {
         var textLine:TextLine = null;
         var numberLine:TextLine = null;
         var line:flashx.textLayout.compose.TextFlowLine = null;
         var alignData:AlignData = null;
         var coord:Number = NaN;
         var delta:Number = NaN;
         var adjustedLogicalRight:Number = NaN;
         var extraSpace:Number = NaN;
         var leftSideGap:Number = NaN;
         var rightSideGap:Number = NaN;
         var numberLineMetric:Number = NaN;
         if(this._blockProgression == BlockProgression.TB)
         {
            for each(alignData in this._alignLines)
            {
               textLine = alignData.textLine;
               rightSideGap = alignData.rightSideGap;
               leftSideGap = alignData.leftSideGap;
               extraSpace = effectiveParcelWidth - leftSideGap - rightSideGap - textLine.textWidth;
               delta = alignData.textAlign == TextAlign.CENTER ? extraSpace / 2 : extraSpace;
               coord = this._curParcel.x + leftSideGap + delta;
               if(alignData.textAlign != TextAlign.LEFT)
               {
                  line = textLine.userData as TextFlowLine;
                  if(Boolean(line))
                  {
                     line.x = coord;
                  }
                  textLine.x = coord;
               }
               adjustedLogicalRight = alignData.lineWidth + coord + Math.max(rightSideGap,0);
               this._parcelRight = Math.max(adjustedLogicalRight,this._parcelRight);
               numberLine = TextFlowLine.tlf_internal::findNumberLine(textLine);
               if(Boolean(numberLine) && TextFlowLine.tlf_internal::getNumberLineListStylePosition(numberLine) == ListStylePosition.OUTSIDE)
               {
                  numberLine.x = tlf_internal::computeNumberLineAlignment(alignData,textLine.textWidth,textLine.x,numberLine,coord,delta,extraSpace);
                  alignData.textFlowLine.tlf_internal::numberLinePosition = numberLine.x;
                  numberLineMetric = numberLine.x + textLine.x;
                  if(numberLineMetric < this._parcelLeft)
                  {
                     this._parcelLeft = numberLineMetric;
                  }
                  numberLineMetric += TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine);
                  if(numberLineMetric > this._parcelRight)
                  {
                     this._parcelRight = numberLineMetric;
                  }
               }
            }
         }
         else
         {
            for each(alignData in this._alignLines)
            {
               textLine = alignData.textLine;
               rightSideGap = alignData.rightSideGap;
               leftSideGap = alignData.leftSideGap;
               extraSpace = effectiveParcelWidth - leftSideGap - rightSideGap - textLine.textWidth;
               delta = alignData.textAlign == TextAlign.CENTER ? extraSpace / 2 : extraSpace;
               coord = this._curParcel.y + leftSideGap + delta;
               if(alignData.textAlign != TextAlign.LEFT)
               {
                  line = textLine.userData as TextFlowLine;
                  if(Boolean(line))
                  {
                     line.y = coord;
                  }
                  textLine.y = coord;
               }
               adjustedLogicalRight = alignData.lineWidth + coord + Math.max(rightSideGap,0);
               this._parcelBottom = Math.max(adjustedLogicalRight,this._parcelBottom);
               numberLine = TextFlowLine.tlf_internal::findNumberLine(textLine);
               if(Boolean(numberLine) && TextFlowLine.tlf_internal::getNumberLineListStylePosition(numberLine) == ListStylePosition.OUTSIDE)
               {
                  numberLine.y = tlf_internal::computeNumberLineAlignment(alignData,textLine.textWidth,textLine.y,numberLine,coord,delta,extraSpace);
                  alignData.textFlowLine.tlf_internal::numberLinePosition = numberLine.y;
                  numberLineMetric = numberLine.y + textLine.y;
                  if(numberLineMetric < this._parcelTop)
                  {
                     this._parcelTop = numberLineMetric;
                  }
                  numberLineMetric += TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine);
                  if(numberLineMetric > this._parcelBottom)
                  {
                     this._parcelBottom = numberLineMetric;
                  }
               }
            }
         }
      }
      
      protected function commitLastLineState(curLine:flashx.textLayout.compose.TextFlowLine) : void
      {
         this._lastLineDescent = this._curLineLeadingModel == LeadingModel.BOX ? this._curLineLeading : curLine.descent;
         this._lastLineLeading = this._curLineLeading;
         this._lastLineLeadingModel = this._curLineLeadingModel;
      }
      
      protected function doVerticalAlignment(canVerticalAlign:Boolean, nextParcel:flashx.textLayout.compose.Parcel) : void
      {
      }
      
      protected function finalParcelAdjustment(controller:ContainerController) : void
      {
      }
      
      protected function finishParcel(controller:ContainerController, nextParcel:flashx.textLayout.compose.Parcel) : Boolean
      {
         if(this._curParcelStart == this._curElementStart + this._curElementOffset)
         {
            return false;
         }
         var totalDepth:Number = this._parcelList.totalDepth;
         if(this._textFlow.configuration.overflowPolicy == OverflowPolicy.FIT_DESCENDERS && !isNaN(this._lastLineDescent))
         {
            totalDepth += this._lastLineDescent;
         }
         totalDepth = Math.max(totalDepth,this._contentCommittedHeight);
         if(this._blockProgression == BlockProgression.TB)
         {
            this._parcelLeft = this._curParcel.x;
            this._parcelTop = this._curParcel.y;
            this._parcelRight = this._contentCommittedExtent + this._curParcel.x;
            this._parcelBottom = totalDepth + this._curParcel.y;
         }
         else
         {
            this._parcelLeft = this._curParcel.right - totalDepth;
            this._parcelTop = this._curParcel.y;
            this._parcelRight = this._curParcel.right;
            this._parcelBottom = this._contentCommittedExtent + this._curParcel.y;
         }
         if(Boolean(this._alignLines) && this._alignLines.length > 0)
         {
            this.applyTextAlign(this._contentLogicalExtent);
            releaseAlignData(this._alignLines[0]);
            this._alignLines.length = 0;
         }
         var canVerticalAlign:Boolean = false;
         if(this._blockProgression == BlockProgression.TB)
         {
            if(!controller.tlf_internal::measureHeight && (!this._curParcel.fitAny || this._curElementStart + this._curElementOffset >= this._textFlow.textLength))
            {
               canVerticalAlign = true;
            }
         }
         else if(!controller.tlf_internal::measureWidth && (!this._curParcel.fitAny || this._curElementStart + this._curElementOffset >= this._textFlow.textLength))
         {
            canVerticalAlign = true;
         }
         this.doVerticalAlignment(canVerticalAlign,nextParcel);
         this.finalParcelAdjustment(controller);
         this._contentLogicalExtent = 0;
         this._contentCommittedExtent = 0;
         this._contentCommittedHeight = 0;
         this._accumulatedMinimumStart = TextLine.MAX_LINE_WIDTH;
         return true;
      }
      
      protected function applyVerticalAlignmentToColumn(controller:ContainerController, vjType:String, lines:Array, beginIndex:int, numLines:int, beginFloatIndex:int, endFloatIndex:int) : void
      {
         var firstLineCoord:Number = NaN;
         var lastLineCoord:Number = NaN;
         var firstLine:IVerticalJustificationLine = lines[beginIndex];
         var lastLine:IVerticalJustificationLine = lines[beginIndex + numLines - 1];
         if(this._blockProgression == BlockProgression.TB)
         {
            firstLineCoord = Number(firstLine.y);
            lastLineCoord = Number(lastLine.y);
         }
         else
         {
            firstLineCoord = Number(firstLine.x);
            lastLineCoord = Number(lastLine.x);
         }
         var firstLineAdjustment:Number = VerticalJustifier.applyVerticalAlignmentToColumn(controller,vjType,lines,beginIndex,numLines,beginFloatIndex,endFloatIndex);
         if(!isNaN(this._parcelLogicalTop))
         {
            this._parcelLogicalTop += firstLineAdjustment;
         }
         if(this._blockProgression == BlockProgression.TB)
         {
            this._parcelTop += firstLine.y - firstLineCoord;
            this._parcelBottom += lastLine.y - lastLineCoord;
         }
         else
         {
            this._parcelRight += firstLine.x - firstLineCoord;
            this._parcelLeft += lastLine.x - lastLineCoord;
         }
      }
      
      protected function finishController(controller:ContainerController) : void
      {
         var paddingLeft:Number = NaN;
         var paddingTop:Number = NaN;
         var paddingRight:Number = NaN;
         var paddingBottom:Number = NaN;
         var controllerTextLength:int = this._curElementStart + this._curElementOffset - controller.absoluteStart;
         if(controllerTextLength != 0)
         {
            paddingLeft = Number(controller.tlf_internal::getTotalPaddingLeft());
            paddingTop = Number(controller.tlf_internal::getTotalPaddingTop());
            paddingRight = Number(controller.tlf_internal::getTotalPaddingRight());
            paddingBottom = Number(controller.tlf_internal::getTotalPaddingBottom());
            if(this._blockProgression == BlockProgression.TB)
            {
               if(this._controllerLeft > 0)
               {
                  if(this._controllerLeft < paddingLeft)
                  {
                     this._controllerLeft = 0;
                  }
                  else
                  {
                     this._controllerLeft -= paddingLeft;
                  }
               }
               if(this._controllerTop > 0)
               {
                  if(this._controllerTop < paddingTop)
                  {
                     this._controllerTop = 0;
                  }
                  else
                  {
                     this._controllerTop -= paddingTop;
                  }
               }
               if(isNaN(controller.compositionWidth))
               {
                  this._controllerRight += paddingRight;
               }
               else if(this._controllerRight < controller.compositionWidth)
               {
                  if(this._controllerRight > controller.compositionWidth - paddingRight)
                  {
                     this._controllerRight = controller.compositionWidth;
                  }
                  else
                  {
                     this._controllerRight += paddingRight;
                  }
               }
               this._controllerBottom += paddingBottom;
            }
            else
            {
               this._controllerLeft -= paddingLeft;
               if(this._controllerTop > 0)
               {
                  if(this._controllerTop < paddingTop)
                  {
                     this._controllerTop = 0;
                  }
                  else
                  {
                     this._controllerTop -= paddingTop;
                  }
               }
               if(this._controllerRight < 0)
               {
                  if(this._controllerRight > -paddingRight)
                  {
                     this._controllerRight = 0;
                  }
                  else
                  {
                     this._controllerRight += paddingRight;
                  }
               }
               if(isNaN(controller.compositionHeight))
               {
                  this._controllerBottom += paddingBottom;
               }
               else if(this._controllerBottom < controller.compositionHeight)
               {
                  if(this._controllerBottom > controller.compositionHeight - paddingBottom)
                  {
                     this._controllerBottom = controller.compositionHeight;
                  }
                  else
                  {
                     this._controllerBottom += paddingBottom;
                  }
               }
            }
            controller.tlf_internal::setContentBounds(this._controllerLeft,this._controllerTop,this._controllerRight - this._controllerLeft,this._controllerBottom - this._controllerTop);
         }
         else
         {
            controller.tlf_internal::setContentBounds(0,0,0,0);
         }
         controller.tlf_internal::setTextLength(controllerTextLength);
         controller.tlf_internal::finalParcelStart = this._curParcelStart;
      }
      
      private function clearControllers(oldController:ContainerController, newController:ContainerController) : void
      {
         var controllerToClear:ContainerController = null;
         var firstToClear:int = Boolean(oldController) ? int(this._flowComposer.getControllerIndex(oldController) + 1) : 0;
         var lastToClear:int = Boolean(newController) ? int(this._flowComposer.getControllerIndex(newController)) : int(this._flowComposer.numControllers - 1);
         while(firstToClear <= lastToClear)
         {
            controllerToClear = ContainerController(this._flowComposer.getControllerAt(firstToClear));
            controllerToClear.tlf_internal::setContentBounds(0,0,0,0);
            controllerToClear.tlf_internal::setTextLength(0);
            controllerToClear.tlf_internal::clearComposedLines(controllerToClear.absoluteStart);
            controllerToClear.tlf_internal::clearFloatsAt(controllerToClear.absoluteStart);
            firstToClear++;
         }
      }
      
      protected function advanceToNextParcel() : void
      {
         this.parcelHasChanged(this._parcelList.atLast() ? null : this._parcelList.getParcelAt(this._parcelList.currentParcelIndex + 1));
         this._parcelList.next();
      }
      
      protected function parcelHasChanged(newParcel:flashx.textLayout.compose.Parcel) : void
      {
         var oldController:ContainerController = Boolean(this._curParcel) ? ContainerController(this._curParcel.controller) : null;
         var newController:ContainerController = Boolean(newParcel) ? ContainerController(newParcel.controller) : null;
         if(oldController != null && this._lastGoodStart != -1)
         {
            oldController.tlf_internal::clearFloatsAt(this._lastGoodStart);
            this._curLine = null;
            this._linePass = 0;
            this._pushInFloats.length = 0;
         }
         if(this._curParcel != null)
         {
            if(this.finishParcel(oldController,newParcel))
            {
               if(this._parcelLeft < this._controllerLeft)
               {
                  this._controllerLeft = this._parcelLeft;
               }
               if(this._parcelRight > this._controllerRight)
               {
                  this._controllerRight = this._parcelRight;
               }
               if(this._parcelTop < this._controllerTop)
               {
                  this._controllerTop = this._parcelTop;
               }
               if(this._parcelBottom > this._controllerBottom)
               {
                  this._controllerBottom = this._parcelBottom;
               }
            }
         }
         if(oldController != newController)
         {
            if(Boolean(oldController))
            {
               this.finishController(oldController);
            }
            this.resetControllerBounds();
            if(this._flowComposer.numControllers > 1)
            {
               if(oldController == null && Boolean(this._startController))
               {
                  this.clearControllers(this._startController,newController);
               }
               else
               {
                  this.clearControllers(oldController,newController);
               }
            }
            if(Boolean(newController))
            {
               if(Boolean(oldController))
               {
                  this._startComposePosition = newController.absoluteStart;
               }
               this.calculateControllerVisibleBounds(newController);
            }
         }
         this._curParcel = newParcel;
         this._curParcelStart = this._curElementStart + this._curElementOffset;
         this._atColumnStart = true;
         this._workingTotalDepth = 0;
         if(Boolean(newController))
         {
            this._verticalSpaceCarried = this._blockProgression == BlockProgression.RL ? Number(newController.tlf_internal::getTotalPaddingRight()) : Number(newController.tlf_internal::getTotalPaddingTop());
            this._measuring = this._blockProgression == BlockProgression.TB && Boolean(newController.tlf_internal::measureWidth) || this._blockProgression == BlockProgression.RL && Boolean(newController.tlf_internal::measureHeight);
         }
      }
      
      private function calculateControllerVisibleBounds(controller:ContainerController) : void
      {
         var width:Number = !!controller.tlf_internal::measureWidth ? Number.MAX_VALUE : controller.compositionWidth;
         var xScroll:Number = controller.horizontalScrollPosition;
         this._controllerVisibleBoundsXTW = Twips.roundTo(this._blockProgression == BlockProgression.RL ? xScroll - width : xScroll);
         this._controllerVisibleBoundsYTW = Twips.roundTo(controller.verticalScrollPosition);
         this._controllerVisibleBoundsWidthTW = !!controller.tlf_internal::measureWidth ? int.MAX_VALUE : Twips.to(controller.compositionWidth);
         this._controllerVisibleBoundsHeightTW = !!controller.tlf_internal::measureHeight ? int.MAX_VALUE : Twips.to(controller.compositionHeight);
      }
      
      private function getLineAdjustmentForInline(curTextLine:TextLine, curLeadingDir:String, isFirstLine:Boolean) : LeadingAdjustment
      {
         var inlineImg:InlineGraphicElement = null;
         var domBaseline:String = null;
         var curAdjustment:LeadingAdjustment = null;
         var tempSize:Number = NaN;
         var adjustment:LeadingAdjustment = null;
         var para:ParagraphElement = this._curLine.paragraph;
         var flowElem:FlowLeafElement = this._curElement;
         var curPos:int = flowElem.getAbsoluteStart();
         var largestPointSize:Number = flowElem.tlf_internal::getEffectiveFontSize();
         var largestImg:Number = 0;
         while(Boolean(flowElem) && curPos < this._curLine.absoluteStart + this._curLine.textLength)
         {
            if(curPos >= this._curLine.absoluteStart || curPos + flowElem.textLength >= this._curLine.absoluteStart)
            {
               if(flowElem is InlineGraphicElement)
               {
                  inlineImg = flowElem as InlineGraphicElement;
                  if(inlineImg.tlf_internal::effectiveFloat == Float.NONE && !(this._blockProgression == BlockProgression.RL && flowElem.parent is TCYElement))
                  {
                     if(largestImg < inlineImg.tlf_internal::getEffectiveFontSize())
                     {
                        largestImg = inlineImg.tlf_internal::getEffectiveFontSize();
                        if(largestImg >= largestPointSize)
                        {
                           largestImg = largestImg;
                           domBaseline = String(flowElem.computedFormat.dominantBaseline);
                           if(domBaseline == FormatValue.AUTO)
                           {
                              domBaseline = LocaleUtil.dominantBaseline(para.computedFormat.locale);
                           }
                           if(domBaseline == TextBaseline.IDEOGRAPHIC_CENTER)
                           {
                              curAdjustment = this.calculateLinePlacementAdjustment(curTextLine,domBaseline,curLeadingDir,inlineImg,isFirstLine);
                              if(!adjustment || Math.abs(curAdjustment.rise) > Math.abs(adjustment.rise) || Math.abs(curAdjustment.leading) > Math.abs(adjustment.leading))
                              {
                                 if(Boolean(adjustment))
                                 {
                                    adjustment.rise = curAdjustment.rise;
                                    adjustment.leading = curAdjustment.leading;
                                 }
                                 else
                                 {
                                    adjustment = curAdjustment;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
               else
               {
                  tempSize = flowElem.tlf_internal::getEffectiveFontSize();
                  if(largestPointSize <= tempSize)
                  {
                     largestPointSize = tempSize;
                  }
                  if(Boolean(adjustment) && largestImg < largestPointSize)
                  {
                     adjustment.leading = 0;
                     adjustment.rise = 0;
                  }
               }
            }
            curPos += flowElem.textLength;
            flowElem = flowElem.getNextLeaf(para);
         }
         return adjustment;
      }
      
      public function get swfContext() : ISWFContext
      {
         var composerContext:ISWFContext = this._flowComposer.swfContext;
         return Boolean(composerContext) ? composerContext : GlobalSWFContext.globalSWFContext;
      }
      
      private function calculateLinePlacementAdjustment(curTextLine:TextLine, domBaseline:String, curLeadingDir:String, inlineImg:InlineGraphicElement, isFirstLine:Boolean) : LeadingAdjustment
      {
         var curAdjustment:LeadingAdjustment = new LeadingAdjustment();
         var imgHeight:Number = inlineImg.tlf_internal::getEffectiveLineHeight(this._blockProgression);
         var lineLeading:Number = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(inlineImg.computedFormat.lineHeight,curTextLine.textHeight);
         if(domBaseline == TextBaseline.IDEOGRAPHIC_CENTER)
         {
            if(!isFirstLine)
            {
               curAdjustment.rise += (imgHeight - lineLeading) / 2;
            }
            else
            {
               curAdjustment.leading -= (imgHeight - lineLeading) / 2;
            }
         }
         return curAdjustment;
      }
      
      protected function pushInsideListItemMargins(numberLine:TextLine) : void
      {
         var numberLineWidth:Number = NaN;
         if(Boolean(numberLine) && this._listItemElement.computedFormat.listStylePosition == ListStylePosition.INSIDE)
         {
            numberLineWidth = Number(TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine));
            this._parcelList.pushInsideListItemMargin(numberLineWidth);
         }
      }
      
      protected function popInsideListItemMargins(numberLine:TextLine) : void
      {
         var numberLineWidth:Number = NaN;
         if(Boolean(numberLine) && this._listItemElement.computedFormat.listStylePosition == ListStylePosition.INSIDE)
         {
            numberLineWidth = Number(TextFlowLine.tlf_internal::getNumberLineInsideLineWidth(numberLine));
            this._parcelList.popInsideListItemMargin(numberLineWidth);
         }
      }
   }
}

import flash.text.engine.TextLine;
import flashx.textLayout.compose.TextFlowLine;

class AlignData
{
    
   
   public var textFlowLine:TextFlowLine;
   
   public var textLine:TextLine;
   
   public var lineWidth:Number;
   
   public var textAlign:String;
   
   public var leftSideGap:Number;
   
   public var rightSideGap:Number;
   
   public var textIndent:Number;
   
   public function AlignData(tfl:TextFlowLine)
   {
      super();
      this.textFlowLine = tfl;
   }
}

import flashx.textLayout.compose.ISWFContext;

class GlobalSWFContext implements ISWFContext
{
   
   public static const globalSWFContext:GlobalSWFContext = new GlobalSWFContext();
    
   
   public function GlobalSWFContext()
   {
      super();
   }
   
   public function callInContext(fn:Function, thisArg:Object, argsArray:Array, returns:Boolean = true) : *
   {
      if(returns)
      {
         return fn.apply(thisArg,argsArray);
      }
      fn.apply(thisArg,argsArray);
   }
}

class LeadingAdjustment
{
    
   
   public var rise:Number = 0;
   
   public var leading:Number = 0;
   
   public var lineHeight:Number = 0;
   
   public function LeadingAdjustment()
   {
      super();
   }
}
