package flashx.textLayout.operations
{
   public class RedoOperation extends flashx.textLayout.operations.FlowOperation
   {
       
      
      private var _operation:flashx.textLayout.operations.FlowOperation;
      
      public function RedoOperation(operation:flashx.textLayout.operations.FlowOperation)
      {
         super(operation.textFlow);
         this._operation = operation;
      }
      
      public function get operation() : flashx.textLayout.operations.FlowOperation
      {
         return this._operation;
      }
      
      public function set operation(value:flashx.textLayout.operations.FlowOperation) : void
      {
         this._operation = value;
      }
   }
}
