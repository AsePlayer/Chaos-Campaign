package flashx.textLayout.operations
{
   import flashx.textLayout.edit.IMemento;
   import flashx.textLayout.edit.ModelEdit;
   import flashx.textLayout.edit.PointFormat;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.tlf_internal;
   
   public class DeleteTextOperation extends FlowTextOperation
   {
       
      
      private var _memento:IMemento;
      
      private var _allowMerge:Boolean;
      
      private var _pendingFormat:PointFormat;
      
      private var _deleteSelectionState:SelectionState = null;
      
      public function DeleteTextOperation(operationState:SelectionState, deleteSelectionState:SelectionState = null, allowMerge:Boolean = false)
      {
         this._deleteSelectionState = Boolean(deleteSelectionState) ? deleteSelectionState : operationState;
         super(this._deleteSelectionState);
         originalSelectionState = operationState;
         this._allowMerge = allowMerge;
      }
      
      public function get allowMerge() : Boolean
      {
         return this._allowMerge;
      }
      
      public function set allowMerge(value:Boolean) : void
      {
         this._allowMerge = value;
      }
      
      public function get deleteSelectionState() : SelectionState
      {
         return this._deleteSelectionState;
      }
      
      public function set deleteSelectionState(value:SelectionState) : void
      {
         this._deleteSelectionState = value;
      }
      
      override public function doOperation() : Boolean
      {
         var state:SelectionState = null;
         if(absoluteStart == absoluteEnd)
         {
            return false;
         }
         this._pendingFormat = PointFormat.tlf_internal::createFromFlowElement(textFlow.findLeaf(absoluteStart));
         if(Boolean(this._pendingFormat.linkElement))
         {
            this._pendingFormat.linkElement = null;
         }
         if(Boolean(this._pendingFormat.tcyElement))
         {
            this._pendingFormat.tcyElement = null;
         }
         this._memento = ModelEdit.deleteText(textFlow,absoluteStart,absoluteEnd,true);
         if(Boolean(originalSelectionState.tlf_internal::selectionManagerOperationState) && Boolean(textFlow.interactionManager))
         {
            state = textFlow.interactionManager.getSelectionState();
            if(state.anchorPosition == state.activePosition)
            {
               state.pointFormat = PointFormat.tlf_internal::clone(this._pendingFormat);
               textFlow.interactionManager.setSelectionState(state);
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
         return originalSelectionState;
      }
      
      override public function redo() : SelectionState
      {
         if(Boolean(this._memento))
         {
            this._memento.redo();
         }
         return new SelectionState(textFlow,absoluteStart,absoluteStart,this._pendingFormat);
      }
      
      override tlf_internal function merge(op2:FlowOperation) : FlowOperation
      {
         if(this.endGeneration != op2.beginGeneration)
         {
            return null;
         }
         var delOp:DeleteTextOperation = op2 as DeleteTextOperation;
         if(delOp == null || !delOp.allowMerge || !this._allowMerge)
         {
            return null;
         }
         return new CompositeOperation([this,op2]);
      }
   }
}
