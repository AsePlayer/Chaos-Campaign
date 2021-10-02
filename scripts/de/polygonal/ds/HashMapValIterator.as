package de.polygonal.ds
{
   import flash.Boot;
   import flash.utils.Dictionary;
   
   public class HashMapValIterator implements Itr
   {
       
      
      public var _s:int;
      
      public var _map:Dictionary;
      
      public var _keys:Array;
      
      public var _i:int;
      
      public var _f:Object;
      
      public function HashMapValIterator(f:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = f;
         _map = _f._map;
         var _loc3_:int = 0;
         var _loc2_:Array = [];
         var _loc4_:* = _map;
         §§push(§§findproperty(_keys));
         while(§§hasnext(_loc4_,_loc3_))
         {
            _loc2_.push(§§nextname(_loc3_,_loc4_));
         }
         §§pop()._keys = _loc2_;
         _i = 0;
         _s = int(_keys.length);
         this;
      }
      
      public function reset() : Itr
      {
         _map = _f._map;
         var _loc2_:int = 0;
         var _loc1_:Array = [];
         var _loc3_:* = _map;
         §§push(§§findproperty(_keys));
         while(§§hasnext(_loc3_,_loc2_))
         {
            _loc1_.push(§§nextname(_loc2_,_loc3_));
         }
         §§pop()._keys = _loc1_;
         _i = 0;
         _s = int(_keys.length);
         return this;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         _i = (_loc1_ = _i) + 1;
         return _map[_keys[_loc1_]];
      }
      
      public function hasNext() : Boolean
      {
         return _i < _s;
      }
      
      public function __map(f:Object) : Dictionary
      {
         return f._map;
      }
   }
}
