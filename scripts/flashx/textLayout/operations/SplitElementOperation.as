package flashx.textLayout.operations
{
   import flashx.textLayout.edit.ElementMark;
   import flashx.textLayout.edit.IMemento;
   import flashx.textLayout.edit.ModelEdit;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.ListItemElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SubParagraphGroupElementBase;
   import flashx.textLayout.formats.ListMarkerFormat;
   import flashx.textLayout.tlf_internal;
   
   public class SplitElementOperation extends FlowTextOperation
   {
       
      
      private var delSelOp:flashx.textLayout.operations.DeleteTextOperation;
      
      private var _targetMark:ElementMark;
      
      private var _memento:IMemento;
      
      private var _newElement:FlowGroupElement;
      
      public function SplitElementOperation(operationState:SelectionState, targetElement:FlowGroupElement)
      {
         super(operationState);
         this.targetElement = targetElement;
      }
      
      public function get targetElement() : FlowGroupElement
      {
         return this._targetMark.findElement(originalSelectionState.textFlow) as FlowGroupElement;
      }
      
      public function set targetElement(value:FlowGroupElement) : void
      {
         this._targetMark = new ElementMark(value,0);
      }
      
      public function get newElement() : FlowGroupElement
      {
         return this._newElement;
      }
      
      override public function doOperation() : Boolean
      {
         var targStart:int = 0;
         var targEnd:int = 0;
         var oldLength:int = 0;
         var relativePosition:int = 0;
         var listMarkerFormat:ListMarkerFormat = null;
         var target:FlowGroupElement = this.targetElement;
         if(absoluteStart < absoluteEnd)
         {
            targStart = target.getAbsoluteStart();
            targEnd = targStart + target.textLength;
            this.delSelOp = new flashx.textLayout.operations.DeleteTextOperation(originalSelectionState);
            this.delSelOp.doOperation();
            if(absoluteStart <= targStart && targEnd <= absoluteEnd)
            {
               if(target is ParagraphElement)
               {
                  target = textFlow.tlf_internal::findAbsoluteParagraph(absoluteStart);
               }
               else
               {
                  target = null;
               }
            }
            else
            {
               target = this.targetElement;
            }
         }
         if(target != null && !(target is SubParagraphGroupElementBase) && target.getTextFlow() == textFlow)
         {
            oldLength = textFlow.textLength;
            relativePosition = absoluteStart - target.getAbsoluteStart();
            this._memento = ModelEdit.splitElement(textFlow,target,relativePosition);
            this._newElement = target.parent.getChildAt(target.parent.getChildIndex(target) + 1) as FlowGroupElement;
            if(this._newElement is ListItemElement && this._newElement.listMarkerFormat && this._newElement.listMarkerFormat.counterReset !== undefined)
            {
               listMarkerFormat = new ListMarkerFormat(this._newElement.listMarkerFormat);
               listMarkerFormat.counterReset = undefined;
               this._newElement.listMarkerFormat = listMarkerFormat;
            }
            if(textFlow.interactionManager && oldLength != textFlow.textLength && target is ParagraphElement)
            {
               textFlow.interactionManager.notifyInsertOrDelete(absoluteStart,textFlow.textLength - oldLength);
            }
         }
         return true;
      }
      
      override public function undo() : SelectionState
      {
         if(Boolean(this._memento))
         {
            this._memento.undo();
         }
         this._newElement = null;
         return absoluteStart < absoluteEnd ? this.delSelOp.undo() : originalSelectionState;
      }
      
      override public function redo() : SelectionState
      {
         super.redo();
         return textFlow.interactionManager.getSelectionState();
      }
   }
}
