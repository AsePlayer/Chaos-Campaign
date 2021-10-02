package de.polygonal.ds
{
   import flash.Boot;
   
   public class ArrayedStackIterator implements Itr
   {
       
      
      public var _i:int;
      
      public var _f:ArrayedStack;
      
      public var _a:Array;
      
      public function ArrayedStackIterator(f:ArrayedStack = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = f;
         _a = _f._a;
         _i = _f._top - 1;
         this;
      }
      
      public function reset() : Itr
      {
         _a = _f._a;
         _i = _f._top - 1;
         return this;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         _i = (_loc1_ = _i) - 1;
         return _a[_loc1_];
      }
      
      public function hasNext() : Boolean
      {
         return _i >= 0;
      }
      
      public function __top(f:Object) : int
      {
         return int(f._top);
      }
      
      public function __a(f:Object) : Array
      {
         return f._a;
      }
   }
}
