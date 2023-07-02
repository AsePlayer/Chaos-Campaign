package de.polygonal.ds
{
   import flash.Boot;
   
   public class LinkedQueueIterator implements Itr
   {
       
      
      public var _walker:de.polygonal.ds.LinkedQueueNode;
      
      public var _f:de.polygonal.ds.LinkedQueue;
      
      public function LinkedQueueIterator(param1:de.polygonal.ds.LinkedQueue = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
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
      
      public function __head(param1:Object) : de.polygonal.ds.LinkedQueueNode
      {
         return param1._head;
      }
   }
}
