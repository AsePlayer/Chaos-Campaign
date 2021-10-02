package de.polygonal.ds
{
   import flash.Boot;
   
   public class Array3Iterator implements Itr
   {
       
      
      public var _s:int;
      
      public var _i:int;
      
      public var _f:Array3;
      
      public var _a:Array;
      
      public function Array3Iterator(f:Array3 = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = f;
         _a = _f._a;
         var _loc2_:* = _f;
         _s = int(_loc2_._w) * int(_loc2_._h) * int(_loc2_._d);
         _i = 0;
         this;
      }
      
      public function reset() : Itr
      {
         _a = _f._a;
         var _loc1_:* = _f;
         _s = int(_loc1_._w) * int(_loc1_._h) * int(_loc1_._d);
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
         return int(f._w) * int(f._h) * int(f._d);
      }
      
      public function __a(f:Object) : Array
      {
         return f._a;
      }
   }
}
