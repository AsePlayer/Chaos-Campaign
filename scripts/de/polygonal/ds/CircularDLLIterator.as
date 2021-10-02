package de.polygonal.ds
{
   import flash.Boot;
   
   public class CircularDLLIterator implements Itr
   {
       
      
      public var _walker:DLLNode;
      
      public var _s:int;
      
      public var _i:int;
      
      public var _f:DLL;
      
      public function CircularDLLIterator(f:DLL = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = f;
         _walker = _f.head;
         _s = _f._size;
         _i = 0;
         this;
      }
      
      public function reset() : Itr
      {
         _walker = _f.head;
         _s = _f._size;
         _i = 0;
         return this;
      }
      
      public function next() : Object
      {
         var _loc1_:Object = _walker.val;
         _walker = _walker.next;
         _i = _i + 1;
         return _loc1_;
      }
      
      public function hasNext() : Boolean
      {
         return _i < _s;
      }
      
      public function __size(f:Object) : int
      {
         return int(f._size);
      }
   }
}
