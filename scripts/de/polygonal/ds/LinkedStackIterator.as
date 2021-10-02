package de.polygonal.ds
{
   import flash.Boot;
   
   public class LinkedStackIterator implements Itr
   {
       
      
      public var _walker:LinkedStackNode;
      
      public var _f:LinkedStack;
      
      public function LinkedStackIterator(f:LinkedStack = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = f;
         _walker = _f._head;
         this;
      }
      
      public function reset() : Itr
      {
         _walker = _f._head;
         return this;
      }
      
      public function next() : Object
      {
         var _loc1_:Object = _walker.val;
         _walker = _walker.next;
         return _loc1_;
      }
      
      public function hasNext() : Boolean
      {
         return _walker != null;
      }
      
      public function __head(f:Object) : LinkedStackNode
      {
         return f._head;
      }
   }
}
