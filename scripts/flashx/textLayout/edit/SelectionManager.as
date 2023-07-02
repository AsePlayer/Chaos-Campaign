package flashx.textLayout.edit
{
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IMEEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flash.text.engine.TextRotation;
   import flash.ui.ContextMenu;
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ColumnState;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.elements.TextRange;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.events.SelectionEvent;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.operations.CopyOperation;
   import flashx.textLayout.operations.FlowOperation;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.NavigationUtil;
   
   public class SelectionManager implements ISelectionManager
   {
       
      
      private var _focusedSelectionFormat:flashx.textLayout.edit.SelectionFormat;
      
      private var _unfocusedSelectionFormat:flashx.textLayout.edit.SelectionFormat;
      
      private var _inactiveSelectionFormat:flashx.textLayout.edit.SelectionFormat;
      
      private var _selFormatState:String = "unfocused";
      
      private var _isActive:Boolean;
      
      private var _textFlow:TextFlow;
      
      private var anchorMark:flashx.textLayout.edit.Mark;
      
      private var activeMark:flashx.textLayout.edit.Mark;
      
      private var _pointFormat:ITextLayoutFormat;
      
      protected var ignoreNextTextEvent:Boolean = false;
      
      protected var allowOperationMerge:Boolean = false;
      
      private var _mouseOverSelectionArea:Boolean = false;
      
      private var marks:Array;
      
      public function SelectionManager()
      {
         this.marks = [];
         super();
         this._textFlow = null;
         this.anchorMark = this.tlf_internal::createMark();
         this.activeMark = this.tlf_internal::createMark();
         this._pointFormat = null;
         this._isActive = false;
      }
      
      private static function computeSelectionIndexInContainer(textFlow:TextFlow, controller:ContainerController, localX:Number, localY:Number) : int
      {
         var rtline:TextFlowLine = null;
         var rtTextLine:TextLine = null;
         var bounds:Rectangle = null;
         var linePerpCoor:Number = NaN;
         var midPerpCoor:Number = NaN;
         var isLineBelow:Boolean = false;
         var prevPerpCoor:Number = NaN;
         var inPrevLine:Boolean = false;
         var lastLinePosInPar:int = 0;
         var lastChar:String = null;
         var lineIndex:int = -1;
         var firstCharVisible:int = controller.absoluteStart;
         var length:int = controller.textLength;
         var bp:String = String(textFlow.computedFormat.blockProgression);
         var isTTB:Boolean = bp == BlockProgression.RL;
         var isDirectionRTL:Boolean = textFlow.computedFormat.direction == Direction.RTL;
         var perpCoor:Number = isTTB ? localX : localY;
         var nearestColIdx:int = locateNearestColumn(controller,localX,localY,textFlow.computedFormat.blockProgression,textFlow.computedFormat.direction);
         var prevLineBounds:Rectangle = null;
         var previousLineIndex:int = -1;
         var lastLineIndexInColumn:int = -1;
         for(var testIndex:int = textFlow.flowComposer.numLines - 1; testIndex >= 0; testIndex--)
         {
            rtline = textFlow.flowComposer.getLineAt(testIndex);
            if(rtline.controller != controller || rtline.columnIndex != nearestColIdx)
            {
               if(lastLineIndexInColumn != -1)
               {
                  lineIndex = testIndex + 1;
                  break;
               }
            }
            else if(!(rtline.absoluteStart < firstCharVisible || rtline.absoluteStart >= firstCharVisible + length))
            {
               rtTextLine = rtline.getTextLine();
               if(!(rtTextLine == null || rtTextLine.parent == null))
               {
                  if(lastLineIndexInColumn == -1)
                  {
                     lastLineIndexInColumn = testIndex;
                  }
                  bounds = rtTextLine.getBounds(DisplayObject(controller.container));
                  linePerpCoor = isTTB ? bounds.left : bounds.bottom;
                  midPerpCoor = -1;
                  if(Boolean(prevLineBounds))
                  {
                     prevPerpCoor = isTTB ? prevLineBounds.right : prevLineBounds.top;
                     midPerpCoor = (linePerpCoor + prevPerpCoor) / 2;
                  }
                  isLineBelow = isTTB ? linePerpCoor > perpCoor : linePerpCoor < perpCoor;
                  if(isLineBelow || testIndex == 0)
                  {
                     inPrevLine = midPerpCoor != -1 && (isTTB ? perpCoor < midPerpCoor : perpCoor > midPerpCoor);
                     lineIndex = inPrevLine && testIndex != lastLineIndexInColumn ? testIndex + 1 : testIndex;
                     break;
                  }
                  prevLineBounds = bounds;
                  previousLineIndex = testIndex;
               }
            }
         }
         if(lineIndex == -1)
         {
            lineIndex = previousLineIndex;
            if(lineIndex == -1)
            {
               return -1;
            }
         }
         var textFlowLine:TextFlowLine = textFlow.flowComposer.getLineAt(lineIndex);
         var textLine:TextLine = textFlowLine.getTextLine(true);
         localX -= textLine.x;
         localY -= textLine.y;
         var startOnNextLineIfNecessary:Boolean = false;
         var lastAtom:int = -1;
         if(isDirectionRTL)
         {
            lastAtom = textLine.atomCount - 1;
         }
         else if(textFlowLine.absoluteStart + textFlowLine.textLength >= textFlowLine.paragraph.getAbsoluteStart() + textFlowLine.paragraph.textLength)
         {
            if(textLine.atomCount > 1)
            {
               lastAtom = textLine.atomCount - 2;
            }
         }
         else
         {
            lastLinePosInPar = textFlowLine.absoluteStart + textFlowLine.textLength - 1;
            lastChar = textLine.textBlock.content.rawText.charAt(lastLinePosInPar);
            if(lastChar == " ")
            {
               if(textLine.atomCount > 1)
               {
                  lastAtom = textLine.atomCount - 2;
               }
            }
            else
            {
               startOnNextLineIfNecessary = true;
               if(textLine.atomCount > 0)
               {
                  lastAtom = textLine.atomCount - 1;
               }
            }
         }
         var lastAtomRect:Rectangle = lastAtom > 0 ? textLine.getAtomBounds(lastAtom) : new Rectangle(0,0,0,0);
         if(!isTTB)
         {
            if(localX < 0)
            {
               localX = 0;
            }
            else if(localX > lastAtomRect.x + lastAtomRect.width)
            {
               if(startOnNextLineIfNecessary)
               {
                  return textFlowLine.absoluteStart + textFlowLine.textLength - 1;
               }
               if(lastAtomRect.x + lastAtomRect.width > 0)
               {
                  localX = lastAtomRect.x + lastAtomRect.width;
               }
            }
         }
         else if(localY < 0)
         {
            localY = 0;
         }
         else if(localY > lastAtomRect.y + lastAtomRect.height)
         {
            if(startOnNextLineIfNecessary)
            {
               return textFlowLine.absoluteStart + textFlowLine.textLength - 1;
            }
            if(lastAtomRect.y + lastAtomRect.height > 0)
            {
               localY = lastAtomRect.y + lastAtomRect.height;
            }
         }
         var result:int = computeSelectionIndexInLine(textFlow,textLine,localX,localY);
         return result != -1 ? result : firstCharVisible + length;
      }
      
      private static function locateNearestColumn(container:ContainerController, localX:Number, localY:Number, wm:String, direction:String) : int
      {
         var curCol:Rectangle = null;
         var nextCol:Rectangle = null;
         var colIdx:int = 0;
         var columnState:ColumnState = container.columnState;
         while(colIdx < columnState.columnCount - 1)
         {
            curCol = columnState.getColumnAt(colIdx);
            nextCol = columnState.getColumnAt(colIdx + 1);
            if(curCol.contains(localX,localY))
            {
               break;
            }
            if(nextCol.contains(localX,localY))
            {
               colIdx++;
               break;
            }
            if(wm == BlockProgression.RL)
            {
               if(localY < curCol.top || localY < nextCol.top && Math.abs(curCol.bottom - localY) <= Math.abs(nextCol.top - localY))
               {
                  break;
               }
               if(localY > nextCol.top)
               {
                  colIdx++;
                  break;
               }
            }
            else if(direction == Direction.LTR)
            {
               if(localX < curCol.left || localX < nextCol.left && Math.abs(curCol.right - localX) <= Math.abs(nextCol.left - localX))
               {
                  break;
               }
               if(localX < nextCol.left)
               {
                  colIdx++;
                  break;
               }
            }
            else
            {
               if(localX > curCol.right || localX > nextCol.right && Math.abs(curCol.left - localX) <= Math.abs(nextCol.right - localX))
               {
                  break;
               }
               if(localX > nextCol.right)
               {
                  colIdx++;
                  break;
               }
            }
            colIdx++;
         }
         return colIdx;
      }
      
      private static function computeSelectionIndexInLine(textFlow:TextFlow, textLine:TextLine, localX:Number, localY:Number) : int
      {
         var paraSelectionIdx:int = 0;
         if(!(textLine.userData is TextFlowLine))
         {
            return -1;
         }
         var rtline:TextFlowLine = TextFlowLine(textLine.userData);
         if(rtline.validity == TextLineValidity.INVALID)
         {
            return -1;
         }
         textLine = rtline.getTextLine(true);
         var isTTB:Boolean = textFlow.computedFormat.blockProgression == BlockProgression.RL;
         var perpCoor:Number = isTTB ? localX : localY;
         var pt:Point = new Point();
         pt.x = localX;
         pt.y = localY;
         pt = textLine.localToGlobal(pt);
         var elemIdx:int = textLine.getAtomIndexAtPoint(pt.x,pt.y);
         if(elemIdx == -1)
         {
            pt.x = localX;
            pt.y = localY;
            if(pt.x < 0 || isTTB && perpCoor > textLine.ascent)
            {
               pt.x = 0;
            }
            if(pt.y < 0 || !isTTB && perpCoor > textLine.descent)
            {
               pt.y = 0;
            }
            pt = textLine.localToGlobal(pt);
            elemIdx = textLine.getAtomIndexAtPoint(pt.x,pt.y);
         }
         if(elemIdx == -1)
         {
            pt.x = localX;
            pt.y = localY;
            pt = textLine.localToGlobal(pt);
            if(Boolean(textLine.parent))
            {
               pt = textLine.parent.globalToLocal(pt);
            }
            if(!isTTB)
            {
               return pt.x <= textLine.x ? rtline.absoluteStart : rtline.absoluteStart + rtline.textLength - 1;
            }
            return pt.y <= textLine.y ? rtline.absoluteStart : rtline.absoluteStart + rtline.textLength - 1;
         }
         var glyphRect:Rectangle = textLine.getAtomBounds(elemIdx);
         var leanRight:Boolean = false;
         if(Boolean(glyphRect))
         {
            if(isTTB && textLine.getAtomTextRotation(elemIdx) != TextRotation.ROTATE_0)
            {
               leanRight = localY > glyphRect.y + glyphRect.height / 2;
            }
            else
            {
               leanRight = localX > glyphRect.x + glyphRect.width / 2;
            }
         }
         if(textLine.getAtomBidiLevel(elemIdx) % 2 != 0)
         {
            paraSelectionIdx = leanRight ? textLine.getAtomTextBlockBeginIndex(elemIdx) : textLine.getAtomTextBlockEndIndex(elemIdx);
         }
         else
         {
            paraSelectionIdx = leanRight ? textLine.getAtomTextBlockEndIndex(elemIdx) : textLine.getAtomTextBlockBeginIndex(elemIdx);
         }
         return rtline.paragraph.getAbsoluteStart() + paraSelectionIdx;
      }
      
      private static function checkForDisplayed(container:DisplayObject) : Boolean
      {
         try
         {
            while(Boolean(container))
            {
               if(!container.visible)
               {
                  return false;
               }
               container = container.parent;
               if(container is Stage)
               {
                  return true;
               }
            }
         }
         catch(e:Error)
         {
            return true;
         }
         return false;
      }
      
      tlf_internal static function computeSelectionIndex(textFlow:TextFlow, target:Object, currentTarget:Object, localX:Number, localY:Number) : int
      {
         var containerPoint:Point = null;
         var tfl:TextFlowLine = null;
         var para:ParagraphElement = null;
         var controller:ContainerController = null;
         var idx:int = 0;
         var testController:ContainerController = null;
         var controllerCandidate:ContainerController = null;
         var candidateLocalX:Number = NaN;
         var candidateLocalY:Number = NaN;
         var relDistance:Number = NaN;
         var containerIndex:int = 0;
         var curContainerController:ContainerController = null;
         var bounds:Rectangle = null;
         var containerWidth:Number = NaN;
         var containerHeight:Number = NaN;
         var adjustX:Number = NaN;
         var adjustY:Number = NaN;
         var relDistanceX:Number = NaN;
         var relDistanceY:Number = NaN;
         var tempDist:Number = NaN;
         var rslt:int = 0;
         var useTargetedTextLine:Boolean = false;
         if(target is TextLine)
         {
            tfl = TextLine(target).userData as TextFlowLine;
            if(Boolean(tfl))
            {
               para = tfl.paragraph;
               if(para.getTextFlow() == textFlow)
               {
                  useTargetedTextLine = true;
               }
            }
         }
         if(useTargetedTextLine)
         {
            rslt = computeSelectionIndexInLine(textFlow,TextLine(target),localX,localY);
         }
         else
         {
            for(idx = 0; idx < textFlow.flowComposer.numControllers; idx++)
            {
               testController = textFlow.flowComposer.getControllerAt(idx);
               if(testController.container == target || testController.container == currentTarget)
               {
                  controller = testController;
                  break;
               }
            }
            if(Boolean(controller))
            {
               if(target != controller.container)
               {
                  containerPoint = DisplayObject(target).localToGlobal(new Point(localX,localY));
                  containerPoint = DisplayObject(controller.container).globalToLocal(containerPoint);
                  localX = containerPoint.x;
                  localY = containerPoint.y;
               }
               rslt = computeSelectionIndexInContainer(textFlow,controller,localX,localY);
            }
            else
            {
               controllerCandidate = null;
               relDistance = Number.MAX_VALUE;
               for(containerIndex = 0; containerIndex < textFlow.flowComposer.numControllers; containerIndex++)
               {
                  curContainerController = textFlow.flowComposer.getControllerAt(containerIndex);
                  if(checkForDisplayed(curContainerController.container as DisplayObject))
                  {
                     bounds = curContainerController.getContentBounds();
                     containerWidth = isNaN(curContainerController.compositionWidth) ? curContainerController.tlf_internal::getTotalPaddingLeft() + bounds.width : curContainerController.compositionWidth;
                     containerHeight = isNaN(curContainerController.compositionHeight) ? curContainerController.tlf_internal::getTotalPaddingTop() + bounds.height : curContainerController.compositionHeight;
                     containerPoint = DisplayObject(target).localToGlobal(new Point(localX,localY));
                     containerPoint = DisplayObject(curContainerController.container).globalToLocal(containerPoint);
                     adjustX = 0;
                     adjustY = 0;
                     if(curContainerController.tlf_internal::hasScrollRect)
                     {
                        containerPoint.x -= adjustX = curContainerController.container.scrollRect.x;
                        containerPoint.y -= adjustY = curContainerController.container.scrollRect.y;
                     }
                     if(containerPoint.x >= 0 && containerPoint.x <= containerWidth && containerPoint.y >= 0 && containerPoint.y <= containerHeight)
                     {
                        controllerCandidate = curContainerController;
                        candidateLocalX = containerPoint.x + adjustX;
                        candidateLocalY = containerPoint.y + adjustY;
                        break;
                     }
                     relDistanceX = 0;
                     relDistanceY = 0;
                     if(containerPoint.x < 0)
                     {
                        relDistanceX = containerPoint.x;
                        if(containerPoint.y < 0)
                        {
                           relDistanceY = containerPoint.y;
                        }
                        else if(containerPoint.y > containerHeight)
                        {
                           relDistanceY = containerPoint.y - containerHeight;
                        }
                     }
                     else if(containerPoint.x > containerWidth)
                     {
                        relDistanceX = containerPoint.x - containerWidth;
                        if(containerPoint.y < 0)
                        {
                           relDistanceY = containerPoint.y;
                        }
                        else if(containerPoint.y > containerHeight)
                        {
                           relDistanceY = containerPoint.y - containerHeight;
                        }
                     }
                     else if(containerPoint.y < 0)
                     {
                        relDistanceY = -containerPoint.y;
                     }
                     else
                     {
                        relDistanceY = containerPoint.y - containerHeight;
                     }
                     tempDist = relDistanceX * relDistanceX + relDistanceY * relDistanceY;
                     if(tempDist <= relDistance)
                     {
                        relDistance = tempDist;
                        controllerCandidate = curContainerController;
                        candidateLocalX = containerPoint.x + adjustX;
                        candidateLocalY = containerPoint.y + adjustY;
                     }
                  }
               }
               rslt = Boolean(controllerCandidate) ? computeSelectionIndexInContainer(textFlow,controllerCandidate,candidateLocalX,candidateLocalY) : -1;
            }
         }
         if(rslt >= textFlow.textLength)
         {
            rslt = textFlow.textLength - 1;
         }
         return rslt;
      }
      
      protected function get pointFormat() : ITextLayoutFormat
      {
         return this._pointFormat;
      }
      
      public function getSelectionState() : SelectionState
      {
         return new SelectionState(this._textFlow,this.anchorMark.position,this.activeMark.position,this.pointFormat);
      }
      
      public function setSelectionState(sel:SelectionState) : void
      {
         this.internalSetSelection(sel.textFlow,sel.anchorPosition,sel.activePosition,sel.pointFormat);
      }
      
      public function hasSelection() : Boolean
      {
         return this.anchorMark.position != -1;
      }
      
      public function isRangeSelection() : Boolean
      {
         return this.anchorMark.position != -1 && this.anchorMark.position != this.activeMark.position;
      }
      
      public function get textFlow() : TextFlow
      {
         return this._textFlow;
      }
      
      public function set textFlow(value:TextFlow) : void
      {
         if(this._textFlow != value)
         {
            if(Boolean(this._textFlow))
            {
               this.flushPendingOperations();
            }
            this.clear();
            if(!value)
            {
               this.setMouseCursor(MouseCursor.AUTO);
            }
            this._textFlow = value;
            if(Boolean(this._textFlow) && this._textFlow.interactionManager != this)
            {
               this._textFlow.interactionManager = this;
            }
         }
      }
      
      public function get editingMode() : String
      {
         return EditingMode.READ_SELECT;
      }
      
      public function get windowActive() : Boolean
      {
         return this._selFormatState != SelectionFormatState.INACTIVE;
      }
      
      public function get focused() : Boolean
      {
         return this._selFormatState == SelectionFormatState.FOCUSED;
      }
      
      public function get currentSelectionFormat() : flashx.textLayout.edit.SelectionFormat
      {
         if(this._selFormatState == SelectionFormatState.UNFOCUSED)
         {
            return this.unfocusedSelectionFormat;
         }
         if(this._selFormatState == SelectionFormatState.INACTIVE)
         {
            return this.inactiveSelectionFormat;
         }
         return this.focusedSelectionFormat;
      }
      
      public function set focusedSelectionFormat(val:flashx.textLayout.edit.SelectionFormat) : void
      {
         this._focusedSelectionFormat = val;
         if(this._selFormatState == SelectionFormatState.FOCUSED)
         {
            this.refreshSelection();
         }
      }
      
      public function get focusedSelectionFormat() : flashx.textLayout.edit.SelectionFormat
      {
         return Boolean(this._focusedSelectionFormat) ? this._focusedSelectionFormat : (Boolean(this._textFlow) ? this._textFlow.configuration.focusedSelectionFormat : null);
      }
      
      public function set unfocusedSelectionFormat(val:flashx.textLayout.edit.SelectionFormat) : void
      {
         this._unfocusedSelectionFormat = val;
         if(this._selFormatState == SelectionFormatState.UNFOCUSED)
         {
            this.refreshSelection();
         }
      }
      
      public function get unfocusedSelectionFormat() : flashx.textLayout.edit.SelectionFormat
      {
         return Boolean(this._unfocusedSelectionFormat) ? this._unfocusedSelectionFormat : (Boolean(this._textFlow) ? this._textFlow.configuration.unfocusedSelectionFormat : null);
      }
      
      public function set inactiveSelectionFormat(val:flashx.textLayout.edit.SelectionFormat) : void
      {
         this._inactiveSelectionFormat = val;
         if(this._selFormatState == SelectionFormatState.INACTIVE)
         {
            this.refreshSelection();
         }
      }
      
      public function get inactiveSelectionFormat() : flashx.textLayout.edit.SelectionFormat
      {
         return Boolean(this._inactiveSelectionFormat) ? this._inactiveSelectionFormat : (Boolean(this._textFlow) ? this._textFlow.configuration.inactiveSelectionFormat : null);
      }
      
      tlf_internal function get selectionFormatState() : String
      {
         return this._selFormatState;
      }
      
      tlf_internal function setSelectionFormatState(selFormatState:String) : void
      {
         var oldSelectionFormat:flashx.textLayout.edit.SelectionFormat = null;
         var newSelectionFormat:flashx.textLayout.edit.SelectionFormat = null;
         if(selFormatState != this._selFormatState)
         {
            oldSelectionFormat = this.currentSelectionFormat;
            this._selFormatState = selFormatState;
            newSelectionFormat = this.currentSelectionFormat;
            if(!newSelectionFormat.equals(oldSelectionFormat))
            {
               this.refreshSelection();
            }
         }
      }
      
      tlf_internal function cloneSelectionFormatState(oldISelectionManager:ISelectionManager) : void
      {
         var oldSelectionManager:SelectionManager = oldISelectionManager as SelectionManager;
         if(Boolean(oldSelectionManager))
         {
            this._isActive = oldSelectionManager._isActive;
            this._mouseOverSelectionArea = oldSelectionManager._mouseOverSelectionArea;
            this.tlf_internal::setSelectionFormatState(oldSelectionManager.tlf_internal::selectionFormatState);
         }
      }
      
      private function selectionPoint(currentTarget:Object, target:InteractiveObject, localX:Number, localY:Number, extendSelection:Boolean = false) : SelectionState
      {
         if(!this._textFlow)
         {
            return null;
         }
         if(!this.hasSelection())
         {
            extendSelection = false;
         }
         var begIdx:int = this.anchorMark.position;
         var endIdx:int = this.activeMark.position;
         endIdx = tlf_internal::computeSelectionIndex(this._textFlow,target,currentTarget,localX,localY);
         if(endIdx == -1)
         {
            return null;
         }
         endIdx = Math.min(endIdx,this._textFlow.textLength - 1);
         if(!extendSelection)
         {
            begIdx = endIdx;
         }
         if(begIdx == endIdx)
         {
            begIdx = int(NavigationUtil.tlf_internal::updateStartIfInReadOnlyElement(this._textFlow,begIdx));
            endIdx = int(NavigationUtil.tlf_internal::updateEndIfInReadOnlyElement(this._textFlow,endIdx));
         }
         else
         {
            endIdx = int(NavigationUtil.tlf_internal::updateEndIfInReadOnlyElement(this._textFlow,endIdx));
         }
         return new SelectionState(this.textFlow,begIdx,endIdx);
      }
      
      public function setFocus() : void
      {
         if(!this._textFlow)
         {
            return;
         }
         if(Boolean(this._textFlow.flowComposer))
         {
            this._textFlow.flowComposer.setFocus(this.activePosition,false);
         }
         this.tlf_internal::setSelectionFormatState(SelectionFormatState.FOCUSED);
      }
      
      protected function setMouseCursor(cursor:String) : void
      {
         Mouse.cursor = cursor;
      }
      
      public function get anchorPosition() : int
      {
         return this.anchorMark.position;
      }
      
      public function get activePosition() : int
      {
         return this.activeMark.position;
      }
      
      public function get absoluteStart() : int
      {
         return this.anchorMark.position < this.activeMark.position ? this.anchorMark.position : this.activeMark.position;
      }
      
      public function get absoluteEnd() : int
      {
         return this.anchorMark.position > this.activeMark.position ? this.anchorMark.position : this.activeMark.position;
      }
      
      public function selectAll() : void
      {
         this.selectRange(0,int.MAX_VALUE);
      }
      
      public function selectRange(anchorPosition:int, activePosition:int) : void
      {
         this.flushPendingOperations();
         if(anchorPosition != this.anchorMark.position || activePosition != this.activeMark.position)
         {
            this.clearSelectionShapes();
            this.internalSetSelection(this._textFlow,anchorPosition,activePosition);
            this.tlf_internal::selectionChanged();
            this.allowOperationMerge = false;
         }
      }
      
      private function internalSetSelection(root:TextFlow, anchorPosition:int, activePosition:int, format:ITextLayoutFormat = null) : void
      {
         this._textFlow = root;
         if(anchorPosition < 0 || activePosition < 0)
         {
            anchorPosition = -1;
            activePosition = -1;
         }
         var lastSelectablePos:int = this._textFlow.textLength > 0 ? this._textFlow.textLength - 1 : 0;
         if(anchorPosition != -1 && activePosition != -1)
         {
            if(anchorPosition > lastSelectablePos)
            {
               anchorPosition = lastSelectablePos;
            }
            if(activePosition > lastSelectablePos)
            {
               activePosition = lastSelectablePos;
            }
         }
         this._pointFormat = format;
         this.anchorMark.position = anchorPosition;
         this.activeMark.position = activePosition;
      }
      
      private function clear() : void
      {
         if(this.hasSelection())
         {
            this.flushPendingOperations();
            this.clearSelectionShapes();
            this.internalSetSelection(this._textFlow,-1,-1);
            this.tlf_internal::selectionChanged();
            this.allowOperationMerge = false;
         }
      }
      
      private function addSelectionShapes() : void
      {
         var containerIter:int = 0;
         if(Boolean(this._textFlow.flowComposer))
         {
            this.internalSetSelection(this._textFlow,this.anchorMark.position,this.activeMark.position,this._pointFormat);
            if(Boolean(this.currentSelectionFormat) && (this.absoluteStart == this.absoluteEnd && this.currentSelectionFormat.pointAlpha != 0 || this.absoluteStart != this.absoluteEnd && this.currentSelectionFormat.rangeAlpha != 0))
            {
               containerIter = 0;
               while(containerIter < this._textFlow.flowComposer.numControllers)
               {
                  this._textFlow.flowComposer.getControllerAt(containerIter++).tlf_internal::addSelectionShapes(this.currentSelectionFormat,this.absoluteStart,this.absoluteEnd);
               }
            }
         }
      }
      
      private function clearSelectionShapes() : void
      {
         var containerIter:int = 0;
         var flowComposer:IFlowComposer = Boolean(this._textFlow) ? this._textFlow.flowComposer : null;
         if(Boolean(flowComposer))
         {
            containerIter = 0;
            while(containerIter < flowComposer.numControllers)
            {
               flowComposer.getControllerAt(containerIter++).tlf_internal::clearSelectionShapes();
            }
         }
      }
      
      public function refreshSelection() : void
      {
         if(this.hasSelection())
         {
            this.clearSelectionShapes();
            this.addSelectionShapes();
         }
      }
      
      tlf_internal function selectionChanged(doDispatchEvent:Boolean = true, resetPointFormat:Boolean = true) : void
      {
         if(resetPointFormat)
         {
            this._pointFormat = null;
         }
         if(doDispatchEvent && Boolean(this._textFlow))
         {
            this.textFlow.dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGE,false,false,this.hasSelection() ? this.getSelectionState() : null));
         }
      }
      
      tlf_internal function setNewSelectionPoint(currentTarget:Object, target:InteractiveObject, localX:Number, localY:Number, extendSelection:Boolean = false) : Boolean
      {
         var selState:SelectionState = this.selectionPoint(currentTarget,target,localX,localY,extendSelection);
         if(selState == null)
         {
            return false;
         }
         if(selState.anchorPosition != this.anchorMark.position || selState.activePosition != this.activeMark.position)
         {
            this.selectRange(selState.anchorPosition,selState.activePosition);
            return true;
         }
         return false;
      }
      
      public function mouseDownHandler(event:MouseEvent) : void
      {
         this.tlf_internal::handleMouseEventForSelection(event,event.shiftKey);
      }
      
      public function mouseMoveHandler(event:MouseEvent) : void
      {
         var wmode:String = String(this.textFlow.computedFormat.blockProgression);
         if(wmode != BlockProgression.RL)
         {
            this.setMouseCursor(MouseCursor.IBEAM);
         }
         if(event.buttonDown)
         {
            this.tlf_internal::handleMouseEventForSelection(event,true);
         }
      }
      
      tlf_internal function handleMouseEventForSelection(event:MouseEvent, allowExtend:Boolean) : void
      {
         var startSelectionActive:Boolean = this.hasSelection();
         if(this.tlf_internal::setNewSelectionPoint(event.currentTarget,event.target as InteractiveObject,event.localX,event.localY,startSelectionActive && allowExtend))
         {
            if(startSelectionActive)
            {
               this.clearSelectionShapes();
            }
            if(this.hasSelection())
            {
               this.addSelectionShapes();
            }
         }
         this.allowOperationMerge = false;
      }
      
      public function mouseUpHandler(event:MouseEvent) : void
      {
         if(!this._mouseOverSelectionArea)
         {
            this.setMouseCursor(MouseCursor.AUTO);
         }
      }
      
      private function atBeginningWordPos(activePara:ParagraphElement, pos:int) : Boolean
      {
         if(pos == 0)
         {
            return true;
         }
         var nextPos:int = activePara.findNextWordBoundary(pos);
         nextPos = activePara.findPreviousWordBoundary(nextPos);
         return pos == nextPos;
      }
      
      public function mouseDoubleClickHandler(event:MouseEvent) : void
      {
         var newActiveIndex:int = 0;
         var newAnchorIndex:int = 0;
         var anchorPara:ParagraphElement = null;
         var anchorParaStart:int = 0;
         if(!this.hasSelection())
         {
            return;
         }
         var activePara:ParagraphElement = this._textFlow.tlf_internal::findAbsoluteParagraph(this.activeMark.position);
         var activeParaStart:int = activePara.getAbsoluteStart();
         if(this.anchorMark.position <= this.activeMark.position)
         {
            newActiveIndex = activePara.findNextWordBoundary(this.activeMark.position - activeParaStart) + activeParaStart;
         }
         else
         {
            newActiveIndex = activePara.findPreviousWordBoundary(this.activeMark.position - activeParaStart) + activeParaStart;
         }
         if(newActiveIndex == activeParaStart + activePara.textLength)
         {
            newActiveIndex--;
         }
         if(event.shiftKey)
         {
            newAnchorIndex = this.anchorMark.position;
         }
         else
         {
            anchorPara = this._textFlow.tlf_internal::findAbsoluteParagraph(this.anchorMark.position);
            anchorParaStart = anchorPara.getAbsoluteStart();
            if(this.atBeginningWordPos(anchorPara,this.anchorMark.position - anchorParaStart))
            {
               newAnchorIndex = this.anchorMark.position;
            }
            else
            {
               if(this.anchorMark.position <= this.activeMark.position)
               {
                  newAnchorIndex = anchorPara.findPreviousWordBoundary(this.anchorMark.position - anchorParaStart) + anchorParaStart;
               }
               else
               {
                  newAnchorIndex = anchorPara.findNextWordBoundary(this.anchorMark.position - anchorParaStart) + anchorParaStart;
               }
               if(newAnchorIndex == anchorParaStart + anchorPara.textLength)
               {
                  newAnchorIndex--;
               }
            }
         }
         if(newAnchorIndex != this.anchorMark.position || newActiveIndex != this.activeMark.position)
         {
            this.internalSetSelection(this._textFlow,newAnchorIndex,newActiveIndex,null);
            this.tlf_internal::selectionChanged();
            this.clearSelectionShapes();
            if(this.hasSelection())
            {
               this.addSelectionShapes();
            }
         }
         this.allowOperationMerge = false;
      }
      
      public function mouseOverHandler(event:MouseEvent) : void
      {
         this._mouseOverSelectionArea = true;
         var wmode:String = String(this.textFlow.computedFormat.blockProgression);
         if(wmode != BlockProgression.RL)
         {
            this.setMouseCursor(MouseCursor.IBEAM);
         }
         else
         {
            this.setMouseCursor(MouseCursor.AUTO);
         }
      }
      
      public function mouseOutHandler(event:MouseEvent) : void
      {
         this._mouseOverSelectionArea = false;
         this.setMouseCursor(MouseCursor.AUTO);
      }
      
      public function focusInHandler(event:FocusEvent) : void
      {
         this._isActive = true;
         this.tlf_internal::setSelectionFormatState(SelectionFormatState.FOCUSED);
      }
      
      public function focusOutHandler(event:FocusEvent) : void
      {
         if(this._isActive)
         {
            this.tlf_internal::setSelectionFormatState(SelectionFormatState.UNFOCUSED);
         }
      }
      
      public function activateHandler(event:Event) : void
      {
         if(!this._isActive)
         {
            this._isActive = true;
            this.tlf_internal::setSelectionFormatState(SelectionFormatState.UNFOCUSED);
         }
      }
      
      public function deactivateHandler(event:Event) : void
      {
         if(this._isActive)
         {
            this._isActive = false;
            this.tlf_internal::setSelectionFormatState(SelectionFormatState.INACTIVE);
         }
      }
      
      public function doOperation(op:FlowOperation) : void
      {
         var opError:Error = null;
         var opEvent:FlowOperationEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_BEGIN,false,true,op,0,null);
         this.textFlow.dispatchEvent(opEvent);
         if(!opEvent.isDefaultPrevented())
         {
            op = opEvent.operation;
            if(!(op is CopyOperation))
            {
               throw new IllegalOperationError(GlobalSettings.resourceStringFunction("illegalOperation",[getQualifiedClassName(op)]));
            }
            opError = null;
            try
            {
               op.doOperation();
            }
            catch(e:Error)
            {
               opError = e;
            }
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_END,false,true,op,0,opError);
            this.textFlow.dispatchEvent(opEvent);
            opError = opEvent.isDefaultPrevented() ? null : opEvent.error;
            if(Boolean(opError))
            {
               throw opError;
            }
            this.textFlow.dispatchEvent(new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_COMPLETE,false,false,op,0,null));
         }
      }
      
      public function editHandler(event:Event) : void
      {
         switch(event.type)
         {
            case Event.COPY:
               this.flushPendingOperations();
               this.doOperation(new CopyOperation(this.getSelectionState()));
               break;
            case Event.SELECT_ALL:
               this.flushPendingOperations();
               this.selectAll();
               this.refreshSelection();
         }
      }
      
      private function handleLeftArrow(event:KeyboardEvent) : SelectionState
      {
         var selState:SelectionState = this.getSelectionState();
         if(this._textFlow.computedFormat.blockProgression != BlockProgression.RL)
         {
            if(this._textFlow.computedFormat.direction == Direction.LTR)
            {
               if(event.ctrlKey || event.altKey)
               {
                  NavigationUtil.previousWord(selState,event.shiftKey);
               }
               else
               {
                  NavigationUtil.previousCharacter(selState,event.shiftKey);
               }
            }
            else if(event.ctrlKey || event.altKey)
            {
               NavigationUtil.nextWord(selState,event.shiftKey);
            }
            else
            {
               NavigationUtil.nextCharacter(selState,event.shiftKey);
            }
         }
         else if(event.altKey)
         {
            NavigationUtil.endOfParagraph(selState,event.shiftKey);
         }
         else if(event.ctrlKey)
         {
            NavigationUtil.endOfDocument(selState,event.shiftKey);
         }
         else
         {
            NavigationUtil.nextLine(selState,event.shiftKey);
         }
         return selState;
      }
      
      private function handleUpArrow(event:KeyboardEvent) : SelectionState
      {
         var selState:SelectionState = this.getSelectionState();
         if(this._textFlow.computedFormat.blockProgression != BlockProgression.RL)
         {
            if(event.altKey)
            {
               NavigationUtil.startOfParagraph(selState,event.shiftKey);
            }
            else if(event.ctrlKey)
            {
               NavigationUtil.startOfDocument(selState,event.shiftKey);
            }
            else
            {
               NavigationUtil.previousLine(selState,event.shiftKey);
            }
         }
         else if(this._textFlow.computedFormat.direction == Direction.LTR)
         {
            if(event.ctrlKey || event.altKey)
            {
               NavigationUtil.previousWord(selState,event.shiftKey);
            }
            else
            {
               NavigationUtil.previousCharacter(selState,event.shiftKey);
            }
         }
         else if(event.ctrlKey || event.altKey)
         {
            NavigationUtil.nextWord(selState,event.shiftKey);
         }
         else
         {
            NavigationUtil.nextCharacter(selState,event.shiftKey);
         }
         return selState;
      }
      
      private function handleRightArrow(event:KeyboardEvent) : SelectionState
      {
         var selState:SelectionState = this.getSelectionState();
         if(this._textFlow.computedFormat.blockProgression != BlockProgression.RL)
         {
            if(this._textFlow.computedFormat.direction == Direction.LTR)
            {
               if(event.ctrlKey || event.altKey)
               {
                  NavigationUtil.nextWord(selState,event.shiftKey);
               }
               else
               {
                  NavigationUtil.nextCharacter(selState,event.shiftKey);
               }
            }
            else if(event.ctrlKey || event.altKey)
            {
               NavigationUtil.previousWord(selState,event.shiftKey);
            }
            else
            {
               NavigationUtil.previousCharacter(selState,event.shiftKey);
            }
         }
         else if(event.altKey)
         {
            NavigationUtil.startOfParagraph(selState,event.shiftKey);
         }
         else if(event.ctrlKey)
         {
            NavigationUtil.startOfDocument(selState,event.shiftKey);
         }
         else
         {
            NavigationUtil.previousLine(selState,event.shiftKey);
         }
         return selState;
      }
      
      private function handleDownArrow(event:KeyboardEvent) : SelectionState
      {
         var selState:SelectionState = this.getSelectionState();
         if(this._textFlow.computedFormat.blockProgression != BlockProgression.RL)
         {
            if(event.altKey)
            {
               NavigationUtil.endOfParagraph(selState,event.shiftKey);
            }
            else if(event.ctrlKey)
            {
               NavigationUtil.endOfDocument(selState,event.shiftKey);
            }
            else
            {
               NavigationUtil.nextLine(selState,event.shiftKey);
            }
         }
         else if(this._textFlow.computedFormat.direction == Direction.LTR)
         {
            if(event.ctrlKey || event.altKey)
            {
               NavigationUtil.nextWord(selState,event.shiftKey);
            }
            else
            {
               NavigationUtil.nextCharacter(selState,event.shiftKey);
            }
         }
         else if(event.ctrlKey || event.altKey)
         {
            NavigationUtil.previousWord(selState,event.shiftKey);
         }
         else
         {
            NavigationUtil.previousCharacter(selState,event.shiftKey);
         }
         return selState;
      }
      
      private function handleHomeKey(event:KeyboardEvent) : SelectionState
      {
         var selState:SelectionState = this.getSelectionState();
         if(event.ctrlKey && !event.altKey)
         {
            NavigationUtil.startOfDocument(selState,event.shiftKey);
         }
         else
         {
            NavigationUtil.startOfLine(selState,event.shiftKey);
         }
         return selState;
      }
      
      private function handleEndKey(event:KeyboardEvent) : SelectionState
      {
         var selState:SelectionState = this.getSelectionState();
         if(event.ctrlKey && !event.altKey)
         {
            NavigationUtil.endOfDocument(selState,event.shiftKey);
         }
         else
         {
            NavigationUtil.endOfLine(selState,event.shiftKey);
         }
         return selState;
      }
      
      private function handlePageUpKey(event:KeyboardEvent) : SelectionState
      {
         var selState:SelectionState = this.getSelectionState();
         NavigationUtil.previousPage(selState,event.shiftKey);
         return selState;
      }
      
      private function handlePageDownKey(event:KeyboardEvent) : SelectionState
      {
         var selState:SelectionState = this.getSelectionState();
         NavigationUtil.nextPage(selState,event.shiftKey);
         return selState;
      }
      
      private function handleKeyEvent(event:KeyboardEvent) : void
      {
         var selState:SelectionState = null;
         this.flushPendingOperations();
         switch(event.keyCode)
         {
            case Keyboard.LEFT:
               selState = this.handleLeftArrow(event);
               break;
            case Keyboard.UP:
               selState = this.handleUpArrow(event);
               break;
            case Keyboard.RIGHT:
               selState = this.handleRightArrow(event);
               break;
            case Keyboard.DOWN:
               selState = this.handleDownArrow(event);
               break;
            case Keyboard.HOME:
               selState = this.handleHomeKey(event);
               break;
            case Keyboard.END:
               selState = this.handleEndKey(event);
               break;
            case Keyboard.PAGE_DOWN:
               selState = this.handlePageDownKey(event);
               break;
            case Keyboard.PAGE_UP:
               selState = this.handlePageUpKey(event);
         }
         if(selState != null)
         {
            event.preventDefault();
            this.updateSelectionAndShapes(this._textFlow,selState.anchorPosition,selState.activePosition);
            if(Boolean(this._textFlow.flowComposer) && this._textFlow.flowComposer.numControllers != 0)
            {
               this._textFlow.flowComposer.getControllerAt(this._textFlow.flowComposer.numControllers - 1).scrollToRange(selState.activePosition,selState.activePosition);
            }
         }
         this.allowOperationMerge = false;
      }
      
      public function keyDownHandler(event:KeyboardEvent) : void
      {
         if(!this.hasSelection() || event.isDefaultPrevented())
         {
            return;
         }
         if(event.charCode == 0)
         {
            switch(event.keyCode)
            {
               case Keyboard.LEFT:
               case Keyboard.UP:
               case Keyboard.RIGHT:
               case Keyboard.DOWN:
               case Keyboard.HOME:
               case Keyboard.END:
               case Keyboard.PAGE_DOWN:
               case Keyboard.PAGE_UP:
               case Keyboard.ESCAPE:
                  this.handleKeyEvent(event);
            }
         }
         else if(event.keyCode == Keyboard.ESCAPE)
         {
            this.handleKeyEvent(event);
         }
      }
      
      public function keyUpHandler(event:KeyboardEvent) : void
      {
      }
      
      public function keyFocusChangeHandler(event:FocusEvent) : void
      {
      }
      
      public function textInputHandler(event:TextEvent) : void
      {
         this.ignoreNextTextEvent = false;
      }
      
      public function imeStartCompositionHandler(event:IMEEvent) : void
      {
      }
      
      public function softKeyboardActivatingHandler(event:Event) : void
      {
      }
      
      protected function enterFrameHandler(event:Event) : void
      {
         this.flushPendingOperations();
      }
      
      public function focusChangeHandler(event:FocusEvent) : void
      {
      }
      
      public function menuSelectHandler(event:ContextMenuEvent) : void
      {
         var menu:ContextMenu = event.target as ContextMenu;
         if(this.activePosition != this.anchorPosition)
         {
            menu.clipboardItems.copy = true;
            menu.clipboardItems.cut = this.editingMode == EditingMode.READ_WRITE;
            menu.clipboardItems.clear = this.editingMode == EditingMode.READ_WRITE;
         }
         else
         {
            menu.clipboardItems.copy = false;
            menu.clipboardItems.cut = false;
            menu.clipboardItems.clear = false;
         }
         var systemClipboard:Clipboard = Clipboard.generalClipboard;
         if(this.activePosition != -1 && this.editingMode == EditingMode.READ_WRITE && (systemClipboard.hasFormat(TextClipboard.tlf_internal::TEXT_LAYOUT_MARKUP) || systemClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)))
         {
            menu.clipboardItems.paste = true;
         }
         else
         {
            menu.clipboardItems.paste = false;
         }
         menu.clipboardItems.selectAll = true;
      }
      
      public function mouseWheelHandler(event:MouseEvent) : void
      {
      }
      
      public function flushPendingOperations() : void
      {
      }
      
      public function getCommonCharacterFormat(range:TextRange = null) : TextLayoutFormat
      {
         if(!range && !this.hasSelection())
         {
            return null;
         }
         var selRange:ElementRange = ElementRange.createElementRange(this._textFlow,Boolean(range) ? range.absoluteStart : this.absoluteStart,Boolean(range) ? range.absoluteEnd : this.absoluteEnd);
         var rslt:TextLayoutFormat = selRange.getCommonCharacterFormat();
         if(selRange.absoluteEnd == selRange.absoluteStart && Boolean(this.pointFormat))
         {
            rslt.apply(this.pointFormat);
         }
         return rslt;
      }
      
      public function getCommonParagraphFormat(range:TextRange = null) : TextLayoutFormat
      {
         if(!range && !this.hasSelection())
         {
            return null;
         }
         return ElementRange.createElementRange(this._textFlow,Boolean(range) ? range.absoluteStart : this.absoluteStart,Boolean(range) ? range.absoluteEnd : this.absoluteEnd).getCommonParagraphFormat();
      }
      
      public function getCommonContainerFormat(range:TextRange = null) : TextLayoutFormat
      {
         if(!range && !this.hasSelection())
         {
            return null;
         }
         return ElementRange.createElementRange(this._textFlow,Boolean(range) ? range.absoluteStart : this.absoluteStart,Boolean(range) ? range.absoluteEnd : this.absoluteEnd).getCommonContainerFormat();
      }
      
      private function updateSelectionAndShapes(tf:TextFlow, begIdx:int, endIdx:int) : void
      {
         this.internalSetSelection(tf,begIdx,endIdx);
         if(Boolean(this._textFlow.flowComposer) && this._textFlow.flowComposer.numControllers != 0)
         {
            this._textFlow.flowComposer.getControllerAt(this._textFlow.flowComposer.numControllers - 1).scrollToRange(this.activeMark.position,this.anchorMark.position);
         }
         this.tlf_internal::selectionChanged();
         this.clearSelectionShapes();
         this.addSelectionShapes();
      }
      
      tlf_internal function createMark() : flashx.textLayout.edit.Mark
      {
         var mark:flashx.textLayout.edit.Mark = new flashx.textLayout.edit.Mark(-1);
         this.marks.push(mark);
         return mark;
      }
      
      tlf_internal function removeMark(mark:flashx.textLayout.edit.Mark) : void
      {
         var idx:int = this.marks.indexOf(mark);
         if(idx != -1)
         {
            this.marks.splice(idx,idx + 1);
         }
      }
      
      public function notifyInsertOrDelete(absolutePosition:int, length:int) : void
      {
         var mark:flashx.textLayout.edit.Mark = null;
         if(length == 0)
         {
            return;
         }
         for(var i:int = 0; i < this.marks.length; i++)
         {
            mark = this.marks[i];
            if(mark.position >= absolutePosition)
            {
               if(length < 0)
               {
                  mark.position = mark.position + length < absolutePosition ? absolutePosition : mark.position + length;
               }
               else
               {
                  mark.position += length;
               }
            }
         }
      }
   }
}
