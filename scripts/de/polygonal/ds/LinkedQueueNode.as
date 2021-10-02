package de.polygonal.ds
{
   import flash.Boot;
   
   public class LinkedQueueNode
   {
       
      
      public var val:Object;
      
      public var next:LinkedQueueNode;
      
      public function LinkedQueueNode(x:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         val = x;
      }
      
      public function toString() : String
      {
         return "" + val;
      }
   }
}
