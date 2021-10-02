package de.polygonal.ds
{
   import flash.Boot;
   
   public class DAIterator implements Itr
   {
       
      
      public var _s:int;
      
      public var _i:int;
      
      public var _f:DA;
      
      public var _a:Array;
      
      public function DAIterator(f:DA = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = f;
         _a = _f._a;
         _s = _f._size;
         _i = 0;
         this;
      }
      
      public function reset() : Itr
      {
         _a = _f._a;
         _s = _f._size;
         _i = 0;
         return this;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         _i = (_loc1_ = _i) + 1;
         return _a[_loc1_];
      }
      
      public function hasNext() : Boolean
      {
         return _i < _s;
      }
      
      public function __size(f:Object) : int
      {
         return int(f._size);
      }
      
      public function __a(f:Object) : Array
      {
         return f._a;
      }
   }
}
