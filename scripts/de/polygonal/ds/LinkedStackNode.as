package de.polygonal.ds
{
   import flash.Boot;
   
   public class LinkedStackNode
   {
       
      
      public var val:Object;
      
      public var next:LinkedStackNode;
      
      public function LinkedStackNode(x:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         val = x;
      }
      
      public function toString() : String
      {
         return Std.string(val);
      }
   }
}
