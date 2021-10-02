package de.polygonal.ds
{
   import flash.Boot;
   
   public class DLLIterator implements Itr
   {
       
      
      public var _walker:DLLNode;
      
      public var _f:DLL;
      
      public function DLLIterator(f:DLL = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = f;
         _walker = _f.head;
         this;
      }
      
      public function reset() : Itr
      {
         _walker = _f.head;
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
   }
}
