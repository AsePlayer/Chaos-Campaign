package flashx.textLayout.compose
{
   import flash.text.engine.TextLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.VerticalAlign;
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   public class SimpleCompose extends BaseCompose
   {
       
      
      protected var workingLine:flashx.textLayout.compose.TextFlowLine;
      
      public var _lines:Array;
      
      private var _vjLines:Array;
      
      private var vjBeginLineIndex:int = 0;
      
      private var vjDisableThisParcel:Boolean = false;
      
      private var vjType:String;
      
      private var _totalLength:Number;
      
      private var _resetLineHandler:Function;
      
      public function SimpleCompose()
      {
         this.workingLine = new flashx.textLayout.compose.TextFlowLine(null,null);
         super();
         this._lines = new Array();
         this._vjLines = new Array();
      }
      
      override protected function createParcelList() : ParcelList
      {
         return ParcelList.tlf_internal::getParcelList();
      }
      
      override protected function releaseParcelList(list:ParcelList) : void
      {
         ParcelList.tlf_internal::releaseParcelList(list);
      }
      
      override protected function initializeForComposer(composer:IFlowComposer, composeToPosition:int, controllerStartIndex:int, controllerEndIndex:int) : void
      {
         _startController = composer.getControllerAt(0);
         _startComposePosition = 0;
         super.initializeForComposer(composer,composeToPosition,0,controllerEndIndex);
         this._vjLines.splice(0);
         this.vjBeginLineIndex = 0;
         this.vjDisableThisParcel = false;
         this.vjType = _startController.computedFormat.verticalAlign;
      }
      
      override public function composeTextFlow(textFlow:TextFlow, composeToPosition:int, controllerEndIndex:int) : int
      {
         _flowComposer = textFlow.flowComposer as StandardFlowComposer;
         _curLine = this.workingLine;
         this._lines.splice(0);
         this._totalLength = 0;
         return super.composeTextFlow(textFlow,composeToPosition,controllerEndIndex);
      }
      
      override protected function doVerticalAlignment(canVerticalAlign:Boolean, nextParcel:Parcel) : void
      {
         var controller:ContainerController = null;
         var beginFloatIndex:int = 0;
         var endFloatIndex:int = 0;
         var vjParcel:Parcel = parcelList.currentParcel;
         if(canVerticalAlign && this.vjType != VerticalAlign.TOP && this.vjBeginLineIndex != this._lines.length && !this.vjDisableThisParcel)
         {
            controller = _curParcel.controller;
            beginFloatIndex = 0;
            endFloatIndex = 0;
            if(controller.tlf_internal::numFloats > 0)
            {
               beginFloatIndex = int(controller.tlf_internal::findFloatIndexAtOrAfter(_curParcelStart));
               endFloatIndex = int(controller.tlf_internal::findFloatIndexAfter(_curElementStart + _curElementOffset));
            }
            applyVerticalAlignmentToColumn(vjParcel.controller,this.vjType,this._vjLines,0,this._vjLines.length,beginFloatIndex,endFloatIndex);
         }
         this._vjLines.splice(0);
         this.vjBeginLineIndex = this._lines.length;
         this.vjDisableThisParcel = false;
         if(Boolean(nextParcel))
         {
            this.vjType = nextParcel.controller.computedFormat.verticalAlign;
         }
      }
      
      override protected function isLineVisible(textLine:TextLine) : Boolean
      {
         return textLine != null;
      }
      
      override protected function endLine(textLine:TextLine) : void
      {
         super.endLine(textLine);
         _curLine.tlf_internal::createShape(_blockProgression,textLine);
         if(Boolean(this.textFlow.tlf_internal::backgroundManager))
         {
            this.textFlow.tlf_internal::backgroundManager.finalizeLine(_curLine);
         }
         textLine.userData = this._totalLength;
         this._totalLength += textLine.rawTextLength;
         this._lines.push(textLine);
         if(this.vjType != VerticalAlign.TOP)
         {
            this._vjLines.push(new VJHelper(textLine,_curLine.height));
         }
         commitLastLineState(_curLine);
      }
      
      public function get textFlow() : TextFlow
      {
         return _textFlow;
      }
      
      public function get resetLineHandler() : Function
      {
         return this._resetLineHandler;
      }
      
      public function set resetLineHandler(val:Function) : void
      {
         this._resetLineHandler = val;
      }
      
      override protected function resetLine(textLine:TextLine) : void
      {
         super.resetLine(textLine);
         if(this._resetLineHandler != null)
         {
            this._resetLineHandler(textLine);
         }
      }
      
      override protected function composeNextLine() : TextLine
      {
         var numberLine:TextLine = null;
         var textLine:TextLine = null;
         var isRTL:Boolean = false;
         var newDepth:Number = NaN;
         if(Boolean(_listItemElement) && _listItemElement.getAbsoluteStart() == _curElementStart + _curElementOffset)
         {
            isRTL = _curParaElement.computedFormat.direction == Direction.RTL;
            numberLine = TextFlowLine.tlf_internal::createNumberLine(_listItemElement,_curParaElement,_flowComposer.swfContext,isRTL ? _parcelList.rightMargin : _parcelList.leftMargin);
            pushInsideListItemMargins(numberLine);
         }
         if(!_parcelList.getLineSlug(_lineSlug,0,0,_textIndent,_curParaFormat.direction == Direction.LTR))
         {
            return null;
         }
         while(true)
         {
            while(true)
            {
               textLine = createTextLine(_lineSlug.width,!_lineSlug.wrapsKnockOut);
               if(Boolean(textLine))
               {
                  break;
               }
               newDepth = _curParcel.findNextTransition(_lineSlug.depth);
               if(newDepth >= Number.MAX_VALUE)
               {
                  advanceToNextParcel();
                  if(!_parcelList.atEnd())
                  {
                     if(_parcelList.getLineSlug(_lineSlug,0,1,_textIndent,_curParaFormat.direction == Direction.LTR))
                     {
                        continue;
                     }
                  }
                  popInsideListItemMargins(numberLine);
                  return null;
               }
               _parcelList.addTotalDepth(newDepth - _lineSlug.depth);
               _parcelList.getLineSlug(_lineSlug,0,1,_textIndent,_curParaFormat.direction == Direction.LTR);
            }
            if(fitLineToParcel(textLine,true,numberLine))
            {
               break;
            }
            if(this.resetLineHandler != null)
            {
               this.resetLineHandler(textLine);
            }
            if(_parcelList.atEnd())
            {
               popInsideListItemMargins(numberLine);
               return null;
            }
         }
         popInsideListItemMargins(numberLine);
         return textLine;
      }
      
      tlf_internal function swapLines(lines:Array) : Array
      {
         var current:Array = this._lines;
         this._lines = lines;
         return current;
      }
      
      override protected function finalParcelAdjustment(controller:ContainerController) : void
      {
         var textLine:TextLine = null;
         var startPos:int = 0;
         var firstLineAdjust:Number = NaN;
         var effectiveIndent:Number = NaN;
         var edgeAdjust:Number = NaN;
         var curPara:ParagraphElement = null;
         var curParaFormat:ITextLayoutFormat = null;
         var paddingVerticalAdjust:Number = NaN;
         var paddingHorizontalAdjust:Number = NaN;
         var previousParagraph:ParagraphElement = null;
         var leaf:FlowLeafElement = null;
         var para:ParagraphElement = null;
         var inlineAscent:Number = NaN;
         var numberLine:TextLine = null;
         var fge:FlowGroupElement = null;
         var leafStart:int = 0;
         var numberLineStart:Number = NaN;
         var minX:Number = TextLine.MAX_LINE_WIDTH;
         var minY:Number = TextLine.MAX_LINE_WIDTH;
         var maxX:Number = -TextLine.MAX_LINE_WIDTH;
         var verticalText:Boolean = _blockProgression == BlockProgression.RL;
         if(!isNaN(_parcelLogicalTop))
         {
            if(verticalText)
            {
               maxX = _parcelLogicalTop;
            }
            else
            {
               minY = _parcelLogicalTop;
            }
         }
         if(!_measuring)
         {
            if(verticalText)
            {
               minY = _accumulatedMinimumStart;
            }
            else
            {
               minX = _accumulatedMinimumStart;
            }
         }
         else
         {
            startPos = 0;
            paddingVerticalAdjust = 0;
            paddingHorizontalAdjust = 0;
            previousParagraph = null;
            for each(textLine in this._lines)
            {
               leaf = controller.textFlow.findLeaf(startPos);
               para = leaf.getParagraph();
               if(para != previousParagraph)
               {
                  paddingVerticalAdjust = 0;
                  paddingHorizontalAdjust = 0;
                  fge = para;
                  while(Boolean(fge) && Boolean(fge.parent))
                  {
                     if(verticalText)
                     {
                        paddingVerticalAdjust += fge.tlf_internal::getEffectivePaddingRight();
                        paddingHorizontalAdjust += fge.tlf_internal::getEffectivePaddingTop();
                     }
                     else
                     {
                        paddingVerticalAdjust += fge.tlf_internal::getEffectivePaddingTop();
                        paddingHorizontalAdjust += fge.tlf_internal::getEffectivePaddingLeft();
                     }
                     fge = fge.parent;
                  }
                  previousParagraph = para;
               }
               inlineAscent = 0;
               if(textLine.numChildren > 0)
               {
                  leafStart = leaf.getAbsoluteStart();
                  inlineAscent = Number(TextFlowLine.tlf_internal::getTextLineTypographicAscent(textLine,leaf,leafStart,startPos + textLine.rawTextLength));
               }
               if(curPara != para)
               {
                  curParaFormat = para.computedFormat;
                  if(curParaFormat.direction == Direction.LTR)
                  {
                     firstLineAdjust = Math.max(curParaFormat.textIndent,0);
                     effectiveIndent = Number(curParaFormat.paragraphStartIndent);
                  }
                  else
                  {
                     firstLineAdjust = 0;
                     effectiveIndent = Number(curParaFormat.paragraphEndIndent);
                  }
               }
               effectiveIndent += paddingHorizontalAdjust;
               edgeAdjust = textLine.textBlockBeginIndex == 0 ? effectiveIndent + firstLineAdjust : effectiveIndent;
               edgeAdjust = verticalText ? textLine.y - edgeAdjust : textLine.x - edgeAdjust;
               numberLine = TextFlowLine.tlf_internal::findNumberLine(textLine);
               if(Boolean(numberLine))
               {
                  numberLineStart = verticalText ? numberLine.y + textLine.y : numberLine.x + textLine.x;
                  edgeAdjust = Math.min(edgeAdjust,numberLineStart);
               }
               if(verticalText)
               {
                  minY = Math.min(edgeAdjust,minY);
                  maxX = Math.max(textLine.x + Math.max(inlineAscent,textLine.ascent) + paddingVerticalAdjust,maxX);
               }
               else
               {
                  minX = Math.min(edgeAdjust,minX);
                  if(inlineAscent < textLine.ascent)
                  {
                     inlineAscent = textLine.ascent;
                  }
                  minY = Math.min(textLine.y - (inlineAscent + paddingVerticalAdjust),minY);
               }
               startPos += textLine.rawTextLength;
            }
         }
         if(minX != TextLine.MAX_LINE_WIDTH && Math.abs(minX - _parcelLeft) >= 1)
         {
            _parcelLeft = minX;
         }
         if(maxX != -TextLine.MAX_LINE_WIDTH && Math.abs(maxX - _parcelRight) >= 1)
         {
            _parcelRight = maxX;
         }
         if(minY != TextLine.MAX_LINE_WIDTH && Math.abs(minY - _parcelTop) >= 1)
         {
            _parcelTop = minY;
         }
      }
      
      override tlf_internal function releaseAnyReferences() : void
      {
         super.tlf_internal::releaseAnyReferences();
         this.workingLine.tlf_internal::initialize(null,0,0,0,0,null);
         this.resetLineHandler = null;
      }
   }
}

import flash.text.engine.TextLine;
import flashx.textLayout.compose.IVerticalJustificationLine;

class VJHelper implements IVerticalJustificationLine
{
    
   
   private var _line:TextLine;
   
   private var _height:Number;
   
   public function VJHelper(line:TextLine, h:Number)
   {
      super();
      this._line = line;
      this._height = h;
   }
   
   public function get x() : Number
   {
      return this._line.x;
   }
   
   public function set x(val:Number) : void
   {
      this._line.x = val;
   }
   
   public function get y() : Number
   {
      return this._line.y;
   }
   
   public function set y(val:Number) : void
   {
      this._line.y = val;
   }
   
   public function get ascent() : Number
   {
      return this._line.ascent;
   }
   
   public function get descent() : Number
   {
      return this._line.descent;
   }
   
   public function get height() : Number
   {
      return this._height;
   }
}
