package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import flash.Boot;
   import flash.utils.Dictionary;
   
   public class HashMap implements Map
   {
       
      
      public var maxSize:int;
      
      public var key:int;
      
      public var _weak:Boolean;
      
      public var _size:int;
      
      public var _map:Dictionary;
      
      public function HashMap(weak:Boolean = false, maxSize:int = -1)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _map = new Dictionary(_weak = Boolean(weak));
         _size = 0;
         var _loc4_:int;
         HashKey._counter = (_loc4_ = HashKey._counter) + 1;
         key = _loc4_;
         maxSize = -1;
      }
      
      public function toValSet() : Set
      {
         var _loc6_:* = null as Object;
         var _loc1_:ListSet = new ListSet();
         var _loc4_:int = 0;
         var _loc3_:Array = [];
         var _loc5_:* = _map;
         while(§§hasnext(_loc5_,_loc4_))
         {
            _loc3_.push(§§nextname(_loc4_,_loc5_));
         }
         var _loc2_:Array = _loc3_;
         _loc4_ = 0;
         while(_loc4_ < int(_loc2_.length))
         {
            _loc6_ = _loc2_[_loc4_];
            _loc4_++;
            _loc1_.set(_map[_loc6_]);
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{HashMap, size: %d}",[_size]);
      }
      
      public function toKeySet() : Set
      {
         var _loc6_:* = null as Object;
         var _loc1_:ListSet = new ListSet();
         var _loc4_:int = 0;
         var _loc3_:Array = [];
         var _loc5_:* = _map;
         while(§§hasnext(_loc5_,_loc4_))
         {
            _loc3_.push(§§nextname(_loc4_,_loc5_));
         }
         var _loc2_:Array = _loc3_;
         _loc4_ = 0;
         while(_loc4_ < int(_loc2_.length))
         {
            _loc6_ = _loc2_[_loc4_];
            _loc4_++;
            _loc1_.set(_loc6_);
         }
         return _loc1_;
      }
      
      public function toKeyDA() : DA
      {
         return ArrayConvert.toDA(toKeyArray());
      }
      
      public function toKeyArray() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = [];
         var _loc3_:* = _map;
         while(§§hasnext(_loc3_,_loc2_))
         {
            _loc1_.push(§§nextname(_loc2_,_loc3_));
         }
         return _loc1_;
      }
      
      public function toDA() : DA
      {
         var _loc3_:* = null as Object;
         var _loc4_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:* = iterator();
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next();
            _loc4_ = _loc1_._size;
            null;
            _loc1_._a[_loc4_] = _loc3_;
            if(_loc4_ >= _loc1_._size)
            {
               _loc1_._size = _loc1_._size + 1;
            }
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc4_:* = null as Object;
         null;
         var _loc2_:Array = new Array(_size);
         var _loc1_:Array = _loc2_;
         var _loc3_:* = iterator();
         while(_loc3_.hasNext())
         {
            _loc4_ = _loc3_.next();
            _loc1_.push(_loc4_);
         }
         return _loc1_;
      }
      
      public function size() : int
      {
         return _size;
      }
      
      public function set(_tmp_key:Object, _tmp_val:Object) : Boolean
      {
         var _loc3_:Object = _tmp_key;
         var _loc4_:Object = _tmp_val;
         var _loc5_:Object = _map[_loc3_];
         if(_loc5_ != null)
         {
            return false;
         }
         _map[_loc3_] = _loc4_;
         _size = _size + 1;
         return true;
      }
      
      public function remove(_tmp_x:Object) : Boolean
      {
         var _loc5_:* = null as Array;
         var _loc6_:* = null as Array;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc9_:* = null as Object;
         var _loc2_:Object = _tmp_x;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         _loc7_ = 0;
         _loc6_ = [];
         _loc8_ = _map;
         while(§§hasnext(_loc8_,_loc7_))
         {
            _loc6_.push(§§nextname(_loc7_,_loc8_));
         }
         _loc5_ = _loc6_;
         _loc7_ = 0;
         while(_loc7_ < int(_loc5_.length))
         {
            _loc9_ = _loc5_[_loc7_];
            _loc7_++;
            if(_map[_loc9_] == _loc2_)
            {
               _loc4_ = true;
               break;
            }
         }
         if(_loc4_)
         {
            _loc7_ = 0;
            _loc6_ = [];
            _loc8_ = _map;
            while(§§hasnext(_loc8_,_loc7_))
            {
               _loc6_.push(§§nextname(_loc7_,_loc8_));
            }
            _loc5_ = _loc6_;
            _loc7_ = 0;
            while(_loc7_ < int(_loc5_.length))
            {
               _loc9_ = _loc5_[_loc7_];
               _loc7_++;
               if(_map[_loc9_] == _loc2_)
               {
                  delete _map[_loc9_];
                  _size = _size - 1;
                  _loc3_ = true;
               }
            }
         }
         return _loc3_;
      }
      
      public function remap(_tmp_key:Object, _tmp_val:Object) : Boolean
      {
         var _loc3_:Object = _tmp_key;
         var _loc4_:Object = _tmp_val;
         var _loc5_:Object = _map[_loc3_];
         if(_loc5_ != null)
         {
            _map[_loc3_] = _loc4_;
            return true;
         }
         return false;
      }
      
      public function keys() : Itr
      {
         return new HashMapKeyIterator(this);
      }
      
      public function iterator() : Itr
      {
         return new HashMapValIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function hasKey(_tmp_key:Object) : Boolean
      {
         var _loc2_:Object = _tmp_key;
         var _loc3_:Object = _map[_loc2_];
         return _loc3_ != null;
      }
      
      public function has(_tmp_val:Object) : Boolean
      {
         var _loc8_:* = null as Object;
         var _loc2_:Object = _tmp_val;
         var _loc3_:Boolean = false;
         var _loc6_:int = 0;
         var _loc5_:Array = [];
         var _loc7_:* = _map;
         while(§§hasnext(_loc7_,_loc6_))
         {
            _loc5_.push(§§nextname(_loc6_,_loc7_));
         }
         var _loc4_:Array = _loc5_;
         _loc6_ = 0;
         while(_loc6_ < int(_loc4_.length))
         {
            _loc8_ = _loc4_[_loc6_];
            _loc6_++;
            if(_map[_loc8_] == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function get(_tmp_key:Object) : Object
      {
         var _loc2_:Object = _tmp_key;
         return _map[_loc2_];
      }
      
      public function free() : void
      {
         var _loc1_:* = null as Array;
         var _loc2_:* = null as Array;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null as Object;
         if(!_weak)
         {
            _loc3_ = 0;
            _loc2_ = [];
            _loc4_ = _map;
            while(§§hasnext(_loc4_,_loc3_))
            {
               _loc2_.push(§§nextname(_loc3_,_loc4_));
            }
            _loc1_ = _loc2_;
            _loc3_ = 0;
            while(_loc3_ < int(_loc1_.length))
            {
               _loc5_ = _loc1_[_loc3_];
               _loc3_++;
               delete _map[_loc5_];
            }
         }
         _map = null;
      }
      
      public function contains(_tmp_x:Object) : Boolean
      {
         var _loc8_:* = null as Object;
         var _loc2_:Object = _tmp_x;
         var _loc3_:Boolean = false;
         var _loc6_:int = 0;
         var _loc5_:Array = [];
         var _loc7_:* = _map;
         while(§§hasnext(_loc7_,_loc6_))
         {
            _loc5_.push(§§nextname(_loc6_,_loc7_));
         }
         var _loc4_:Array = _loc5_;
         _loc6_ = 0;
         while(_loc6_ < int(_loc4_.length))
         {
            _loc8_ = _loc4_[_loc6_];
            _loc6_++;
            if(_map[_loc8_] == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function clr(_tmp_key:Object) : Boolean
      {
         var _loc2_:Object = _tmp_key;
         if(_map[_loc2_] != null)
         {
            delete _map[_loc2_];
            _size = _size - 1;
            return true;
         }
         return false;
      }
      
      public function clone(assign:Boolean, _tmp_copier:Object = undefined) : Collection
      {
         var _loc7_:int = 0;
         var _loc9_:* = null as Object;
         var _loc10_:* = null as Object;
         var _loc11_:* = null as Cloneable;
         var _loc3_:* = _tmp_copier;
         var _loc4_:HashMap = new HashMap(_weak,maxSize);
         _loc7_ = 0;
         var _loc6_:Array = [];
         var _loc8_:* = _map;
         while(§§hasnext(_loc8_,_loc7_))
         {
            _loc6_.push(§§nextname(_loc7_,_loc8_));
         }
         var _loc5_:Array = _loc6_;
         if(assign)
         {
            _loc7_ = 0;
            while(_loc7_ < int(_loc5_.length))
            {
               _loc9_ = _loc5_[_loc7_];
               _loc7_++;
               _loc10_ = _loc4_._map[_loc9_];
               if(_loc10_ != null)
               {
                  false;
               }
               else
               {
                  _loc4_._map[_loc9_] = _map[_loc9_];
                  _loc4_._size = _loc4_._size + 1;
                  true;
               }
            }
         }
         else if(_loc3_ == null)
         {
            _loc7_ = 0;
            while(_loc7_ < int(_loc5_.length))
            {
               _loc9_ = _loc5_[_loc7_];
               _loc7_++;
               null;
               _loc11_ = _map[_loc9_];
               _loc10_ = _loc4_._map[_loc9_];
               if(_loc10_ != null)
               {
                  false;
               }
               else
               {
                  _loc4_._map[_loc9_] = _map[_loc9_];
                  _loc4_._size = _loc4_._size + 1;
                  true;
               }
            }
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < int(_loc5_.length))
            {
               _loc9_ = _loc5_[_loc7_];
               _loc7_++;
               _loc10_ = _loc4_._map[_loc9_];
               if(_loc10_ != null)
               {
                  false;
               }
               else
               {
                  _loc4_._map[_loc9_] = _loc3_(_map[_loc9_]);
                  _loc4_._size = _loc4_._size + 1;
                  true;
               }
            }
         }
         return _loc4_;
      }
      
      public function clear(purge:Boolean = false) : void
      {
         var _loc6_:* = null as Object;
         var _loc4_:int = 0;
         var _loc3_:Array = [];
         var _loc5_:* = _map;
         while(§§hasnext(_loc5_,_loc4_))
         {
            _loc3_.push(§§nextname(_loc4_,_loc5_));
         }
         var _loc2_:Array = _loc3_;
         _loc4_ = 0;
         while(_loc4_ < int(_loc2_.length))
         {
            _loc6_ = _loc2_[_loc4_];
            _loc4_++;
            delete _map[_loc6_];
         }
         _size = 0;
      }
   }
}
