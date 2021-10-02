package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class DA implements Collection
   {
       
      
      public var maxSize:int;
      
      public var key:int;
      
      public var _size:int;
      
      public var _a:Array;
      
      public function DA(reservedSize:int = 0, maxSize:int = -1)
      {
         var _loc3_:* = null as Array;
         if(Boot.skip_constructor)
         {
            return;
         }
         _size = 0;
         maxSize = -1;
         if(reservedSize > 0)
         {
            null;
            _loc3_ = new Array(reservedSize);
            _a = _loc3_;
         }
         else
         {
            _a = [];
         }
         var _loc4_:int;
         HashKey._counter = (_loc4_ = HashKey._counter) + 1;
         key = _loc4_;
      }
      
      public function trim(x:int) : void
      {
         null;
         _size = x;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{DA, size: %d}",[_size]);
      }
      
      public function toDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:int = 0;
         var _loc3_:int = _size;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _loc5_ = _loc1_._size;
            null;
            _loc1_._a[_loc5_] = _a[_loc4_];
            if(_loc5_ >= _loc1_._size)
            {
               _loc1_._size = _loc1_._size + 1;
            }
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc5_:int = 0;
         null;
         var _loc2_:Array = new Array(_size);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:int = _size;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc1_[_loc5_] = _a[_loc5_];
         }
         return _loc1_;
      }
      
      public function swp(i:int, j:int) : void
      {
         null;
         null;
         var _loc3_:Object = _a[i];
         null;
         null;
         null;
         _a[i] = _a[j];
         if(i >= _size)
         {
            _size = _size + 1;
         }
         null;
         _a[j] = _loc3_;
         if(j >= _size)
         {
            _size = _size + 1;
         }
      }
      
      public function swapWithBack(i:int) : void
      {
         var _loc3_:* = null as Object;
         null;
         var _loc2_:int = _size - 1;
         if(i < _loc2_)
         {
            null;
            _loc3_ = _a[_size - 1];
            _a[_loc2_] = _a[i];
            _a[i] = _loc3_;
         }
      }
      
      public function sort(compare:Function, useInsertionSort:Boolean = false) : void
      {
         var _loc3_:* = null as Array;
         var _loc4_:int = 0;
         if(_size > 1)
         {
            if(compare == null)
            {
               if(useInsertionSort)
               {
                  _insertionSortComparable();
               }
               else
               {
                  _quickSortComparable(0,_size);
               }
            }
            else if(useInsertionSort)
            {
               _insertionSort(compare);
            }
            else
            {
               _loc3_ = _a;
               _loc4_ = _size;
               if(int(_loc3_.length) > _loc4_)
               {
                  _loc3_.length = _loc4_;
               }
               _loc3_;
               _a.sort(compare);
            }
         }
      }
      
      public function size() : int
      {
         return _size;
      }
      
      public function shuffle(rval:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc2_:int = _size;
         if(rval == null)
         {
            _loc3_ = Math;
            while(true)
            {
               _loc2_--;
               if(_loc2_ <= 1)
               {
                  break;
               }
               _loc4_ = int(_loc3_.random() * _loc2_);
               _loc5_ = _a[_loc2_];
               _a[_loc2_] = _a[_loc4_];
               _a[_loc4_] = _loc5_;
            }
         }
         else
         {
            null;
            _loc4_ = 0;
            while(true)
            {
               _loc2_--;
               if(_loc2_ <= 1)
               {
                  break;
               }
               null;
               _loc6_ = int(rval._a[_loc4_++] * _loc2_);
               _loc5_ = _a[_loc2_];
               _a[_loc2_] = _a[_loc6_];
               _a[_loc6_] = _loc5_;
            }
         }
      }
      
      public function set(i:int, x:Object) : void
      {
         null;
         _a[i] = x;
         if(i >= _size)
         {
            _size = _size + 1;
         }
      }
      
      public function reverse() : void
      {
         var _loc1_:* = null as Array;
         var _loc2_:int = 0;
         if(int(_a.length) > _size)
         {
            _loc1_ = _a;
            _loc2_ = _size;
            §§push(§§findproperty(_a));
            if(int(_loc1_.length) > _loc2_)
            {
               _loc1_.length = _loc2_;
            }
            §§pop()._a = _loc1_;
         }
         _a.reverse();
      }
      
      public function reserve(x:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(_size == x)
         {
            return;
         }
         var _loc2_:Array = _a;
         null;
         var _loc3_:Array = new Array(x);
         _a = _loc3_;
         if(_size < x)
         {
            _loc4_ = 0;
            _loc5_ = _size;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               _a[_loc6_] = _loc2_[_loc6_];
            }
         }
      }
      
      public function removeRange(i:int, n:int, output:DA = undefined) : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         null;
         null;
         if(output == null)
         {
            _loc4_ = _size;
            _loc5_ = i + n;
            while(_loc5_ < _loc4_)
            {
               _a[_loc5_ - n] = _a[_loc5_];
               _loc5_++;
            }
         }
         else
         {
            _loc4_ = _size;
            _loc5_ = i + n;
            while(_loc5_ < _loc4_)
            {
               _loc7_ = _loc5_ - n;
               _loc6_ = _a[_loc7_];
               _loc8_ = output._size;
               null;
               output._a[_loc8_] = _loc6_;
               if(_loc8_ >= output._size)
               {
                  output._size = output._size + 1;
               }
               _a[_loc7_] = _a[_loc5_++];
            }
         }
         _size -= n;
         return output;
      }
      
      public function removeAt(i:int) : Object
      {
         null;
         var _loc2_:Object = _a[i];
         var _loc3_:int = _size - 1;
         var _loc4_:int = i;
         while(_loc4_ < _loc3_)
         {
            _a[_loc4_++] = _a[_loc4_];
         }
         _size = _size - 1;
         return _loc2_;
      }
      
      public function remove(_tmp_x:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:Object = _tmp_x;
         if(_size == 0)
         {
            return false;
         }
         var _loc3_:int = 0;
         var _loc4_:int = _size;
         while(_loc3_ < _loc4_)
         {
            if(_a[_loc3_] == _loc2_)
            {
               _loc4_--;
               _loc5_ = _loc3_;
               while(_loc5_ < _loc4_)
               {
                  _a[_loc5_] = _a[_loc5_ + 1];
                  _loc5_++;
               }
            }
            else
            {
               _loc3_++;
            }
         }
         var _loc6_:Boolean = _size - _loc4_ != 0;
         _size = _loc4_;
         return _loc6_;
      }
      
      public function pushFront(x:Object) : void
      {
         if(maxSize != -1)
         {
            null;
         }
         null;
         null;
         var _loc2_:int = _size;
         while(_loc2_ > 0)
         {
            _a[_loc2_--] = _a[_loc2_];
         }
         _a[0] = x;
         _size = _size + 1;
      }
      
      public function pushBack(x:Object) : void
      {
         var _loc2_:int = _size;
         null;
         _a[_loc2_] = x;
         if(_loc2_ >= _size)
         {
            _size = _size + 1;
         }
      }
      
      public function popFront() : Object
      {
         null;
         var _loc1_:Object = _a[0];
         var _loc2_:int = _size - 1;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _a[_loc3_++] = _a[_loc3_];
         }
         _size = _size - 1;
         return _loc1_;
      }
      
      public function popBack() : Object
      {
         null;
         var _loc1_:Object = _a[_size - 1];
         _size = _size - 1;
         return _loc1_;
      }
      
      public function pack() : void
      {
         var _loc6_:int = 0;
         var _loc1_:int = int(_a.length);
         if(_loc1_ == _size)
         {
            return;
         }
         var _loc2_:Array = _a;
         null;
         var _loc3_:Array = new Array(_size);
         _a = _loc3_;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _a[_loc6_] = _loc2_[_loc6_];
         }
         _loc4_ = _size;
         _loc5_ = int(_loc2_.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc2_[_loc6_] = null;
         }
      }
      
      public function memmove(destination:int, source:int, n:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         null;
         null;
         null;
         null;
         if(source == destination)
         {
            return;
         }
         if(source <= destination)
         {
            _loc4_ = source + n;
            _loc5_ = destination + n;
            _loc6_ = 0;
            while(_loc6_ < n)
            {
               _loc7_ = _loc6_++;
               _loc4_--;
               _loc5_--;
               _a[_loc5_] = _a[_loc4_];
            }
         }
         else
         {
            _loc4_ = source;
            _loc5_ = destination;
            _loc6_ = 0;
            while(_loc6_ < n)
            {
               _loc7_ = _loc6_++;
               _a[_loc5_] = _a[_loc4_];
               _loc4_++;
               _loc5_++;
            }
         }
      }
      
      public function lastIndexOf(x:Object, from:int = -1) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(_size == 0)
         {
            return -1;
         }
         if(from < 0)
         {
            from = _size + from;
         }
         null;
         _loc3_ = -1;
         _loc4_ = from;
         do
         {
            if(_a[_loc4_] == x)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         while(_loc4_-- > 0);
         
         return _loc3_;
      }
      
      public function join(x:String) : String
      {
         var _loc5_:int = 0;
         if(_size == 0)
         {
            return "";
         }
         if(_size == 1)
         {
            null;
            return Std.string(_a[0]);
         }
         null;
         var _loc2_:String = Std.string(_a[0]) + x;
         var _loc3_:int = 1;
         var _loc4_:int = _size - 1;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            null;
            _loc2_ += Std.string(_a[_loc5_]);
            _loc2_ += x;
         }
         null;
         return _loc2_ + Std.string(_a[_size - 1]);
      }
      
      public function iterator() : Itr
      {
         return new DAIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function insertAt(i:int, x:Object) : void
      {
         null;
         null;
         var _loc3_:int = _size;
         while(_loc3_ > i)
         {
            _a[_loc3_--] = _a[_loc3_];
         }
         _a[i] = x;
         _size = _size + 1;
      }
      
      public function indexOf(x:Object, from:int = 0, binarySearch:Boolean = false, comparator:Object = undefined) : int
      {
         var _loc5_:* = null as Array;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(_size == 0)
         {
            return -1;
         }
         null;
         if(binarySearch)
         {
            if(comparator != null)
            {
               _loc5_ = _a;
               _loc6_ = _size - 1;
               null;
               null;
               null;
               null;
               _loc7_ = from;
               _loc9_ = _loc6_ + 1;
               while(_loc7_ < _loc9_)
               {
                  _loc8_ = _loc7_ + (_loc9_ - _loc7_ >> 1);
                  if(int(comparator(_loc5_[_loc8_],x)) < 0)
                  {
                     _loc7_ = _loc8_ + 1;
                  }
                  else
                  {
                     _loc9_ = _loc8_;
                  }
               }
               return _loc7_ <= _loc6_ && int(comparator(_loc5_[_loc7_],x)) == 0 ? _loc7_ : ~_loc7_;
            }
            null;
            _loc6_ = _size;
            _loc7_ = from;
            _loc9_ = _loc6_;
            while(_loc7_ < _loc9_)
            {
               _loc8_ = _loc7_ + (_loc9_ - _loc7_ >> 1);
               null;
               if(int(_a[_loc8_].compare(x)) < 0)
               {
                  _loc7_ = _loc8_ + 1;
               }
               else
               {
                  _loc9_ = _loc8_;
               }
            }
            null;
            return _loc7_ <= _loc6_ && int(_a[_loc7_].compare(x)) == 0 ? _loc7_ : -_loc7_;
         }
         _loc6_ = from;
         _loc7_ = -1;
         _loc8_ = _size - 1;
         do
         {
            if(_a[_loc6_] == x)
            {
               _loc7_ = _loc6_;
               break;
            }
         }
         while(_loc6_++ < _loc8_);
         
         return _loc7_;
      }
      
      public function inRange(i:int) : Boolean
      {
         return i >= 0 && i <= _size;
      }
      
      public function getPrev(i:int) : Object
      {
         null;
         return _a[i - 1 == -1 ? _size - 1 : i - 1];
      }
      
      public function getNext(i:int) : Object
      {
         null;
         return _a[i + 1 == _size ? 0 : i + 1];
      }
      
      public function getArray() : Array
      {
         return _a;
      }
      
      public function get(i:int) : Object
      {
         null;
         return _a[i];
      }
      
      public function front() : Object
      {
         null;
         return _a[0];
      }
      
      public function free() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = int(_a.length);
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _a[_loc4_] = _loc1_;
         }
         _a = null;
      }
      
      public function fill(x:Object, n:int = 0) : void
      {
         var _loc4_:int = 0;
         null;
         if(n > 0)
         {
            null;
            _size = n;
         }
         else
         {
            n = _size;
         }
         var _loc3_:int = 0;
         while(_loc3_ < n)
         {
            _loc4_ = _loc3_++;
            _a[_loc4_] = x;
         }
      }
      
      public function cpy(i:int, j:int) : void
      {
         null;
         null;
         null;
         _a[i] = _a[j];
         if(i >= _size)
         {
            _size = _size + 1;
         }
      }
      
      public function contains(_tmp_x:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Object = _tmp_x;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_a[_loc6_] == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function concat(x:DA, copy:Boolean = false) : DA
      {
         var _loc3_:* = null as DA;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         null;
         if(copy)
         {
            _loc3_ = new DA();
            _loc3_._size = _size + x._size;
            _loc4_ = 0;
            _loc5_ = _size;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               null;
               _loc3_._a[_loc6_] = _a[_loc6_];
               if(_loc6_ >= _loc3_._size)
               {
                  _loc3_._size = _loc3_._size + 1;
               }
            }
            _loc4_ = _size;
            _loc5_ = _size + x._size;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               null;
               null;
               _loc3_._a[_loc6_] = x._a[_loc6_ - _size];
               if(_loc6_ >= _loc3_._size)
               {
                  _loc3_._size = _loc3_._size + 1;
               }
            }
            return _loc3_;
         }
         null;
         _loc4_ = _size;
         _size += x._size;
         _loc5_ = 0;
         _loc6_ = x._size;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            null;
            _a[_loc4_++] = x._a[_loc7_];
         }
         return this;
      }
      
      public function clone(assign:Boolean, _tmp_copier:Object = undefined) : Collection
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Cloneable;
         var _loc3_:* = _tmp_copier;
         var _loc4_:DA = new DA(_size,maxSize);
         _loc4_._size = _size;
         if(assign)
         {
            _loc5_ = 0;
            _loc6_ = _size;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               _loc4_._a[_loc7_] = _a[_loc7_];
            }
         }
         else if(_loc3_ == null)
         {
            _loc8_ = null;
            _loc5_ = 0;
            _loc6_ = _size;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               null;
               _loc8_ = _a[_loc7_];
               _loc4_._a[_loc7_] = _loc8_.clone();
            }
         }
         else
         {
            _loc5_ = 0;
            _loc6_ = _size;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               _loc4_._a[_loc7_] = _loc3_(_a[_loc7_]);
            }
         }
         return _loc4_;
      }
      
      public function clear(purge:Boolean = false) : void
      {
         var _loc2_:* = null as Object;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(purge)
         {
            _loc2_ = null;
            _loc3_ = 0;
            _loc4_ = int(_a.length);
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc3_++;
               _a[_loc5_] = _loc2_;
            }
         }
         _size = 0;
      }
      
      public function back() : Object
      {
         null;
         return _a[_size - 1];
      }
      
      public function assign(C:Class, args:Array = undefined, n:int = 0) : void
      {
         var _loc5_:int = 0;
         null;
         if(n > 0)
         {
            null;
            _size = n;
         }
         else
         {
            n = _size;
         }
         var _loc4_:int = 0;
         while(_loc4_ < n)
         {
            _loc5_ = _loc4_++;
            _a[_loc5_] = Instance.create(C,args);
         }
      }
      
      public function _quickSortComparable(first:int, k:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null as Object;
         var _loc10_:* = null as Object;
         var _loc11_:* = null as Object;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:* = null as Object;
         var _loc3_:int = first + k - 1;
         var _loc4_:int = first;
         var _loc5_:int = _loc3_;
         if(k > 1)
         {
            _loc6_ = first;
            _loc7_ = _loc6_ + (k >> 1);
            _loc8_ = _loc6_ + k - 1;
            _loc9_ = _a[_loc6_];
            _loc10_ = _a[_loc7_];
            _loc11_ = _a[_loc8_];
            null;
            null;
            null;
            _loc13_ = int(_loc9_.compare(_loc11_));
            if(_loc13_ < 0 && int(_loc9_.compare(_loc10_)) < 0)
            {
               _loc12_ = int(_loc10_.compare(_loc11_)) < 0 ? _loc7_ : _loc8_;
            }
            else if(int(_loc9_.compare(_loc10_)) < 0 && int(_loc10_.compare(_loc11_)) < 0)
            {
               _loc12_ = _loc13_ < 0 ? _loc6_ : _loc8_;
            }
            else
            {
               _loc12_ = int(_loc11_.compare(_loc9_)) < 0 ? _loc7_ : _loc6_;
            }
            _loc14_ = _a[_loc12_];
            _a[_loc12_] = _a[first];
            while(_loc4_ < _loc5_)
            {
               null;
               null;
               null;
               while(int(_loc14_.compare(_a[_loc5_])) < 0 && _loc4_ < _loc5_)
               {
                  _loc5_--;
               }
               if(_loc5_ != _loc4_)
               {
                  _a[_loc4_] = _a[_loc5_];
                  _loc4_++;
               }
               while(int(_loc14_.compare(_a[_loc4_])) > 0 && _loc4_ < _loc5_)
               {
                  _loc4_++;
               }
               if(_loc5_ != _loc4_)
               {
                  _a[_loc5_] = _a[_loc4_];
                  _loc5_--;
               }
            }
            _a[_loc4_] = _loc14_;
            _quickSortComparable(first,_loc4_ - first);
            _quickSortComparable(_loc4_ + 1,_loc3_ - _loc4_);
         }
      }
      
      public function _quickSort(first:int, k:int, cmp:Function) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = null as Object;
         var _loc11_:* = null as Object;
         var _loc12_:* = null as Object;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:* = null as Object;
         var _loc4_:int = first + k - 1;
         var _loc5_:int = first;
         var _loc6_:int = _loc4_;
         if(k > 1)
         {
            _loc7_ = first;
            _loc8_ = _loc7_ + (k >> 1);
            _loc9_ = _loc7_ + k - 1;
            _loc10_ = _a[_loc7_];
            _loc11_ = _a[_loc8_];
            _loc12_ = _a[_loc9_];
            _loc14_ = int(cmp(_loc10_,_loc12_));
            if(_loc14_ < 0 && int(cmp(_loc10_,_loc11_)) < 0)
            {
               _loc13_ = int(cmp(_loc11_,_loc12_)) < 0 ? _loc8_ : _loc9_;
            }
            else if(int(cmp(_loc11_,_loc10_)) < 0 && int(cmp(_loc11_,_loc12_)) < 0)
            {
               _loc13_ = _loc14_ < 0 ? _loc7_ : _loc9_;
            }
            else
            {
               _loc13_ = int(cmp(_loc12_,_loc10_)) < 0 ? _loc8_ : _loc7_;
            }
            _loc15_ = _a[_loc13_];
            _a[_loc13_] = _a[first];
            while(_loc5_ < _loc6_)
            {
               while(int(cmp(_loc15_,_a[_loc6_])) < 0 && _loc5_ < _loc6_)
               {
                  _loc6_--;
               }
               if(_loc6_ != _loc5_)
               {
                  _a[_loc5_] = _a[_loc6_];
                  _loc5_++;
               }
               while(int(cmp(_loc15_,_a[_loc5_])) > 0 && _loc5_ < _loc6_)
               {
                  _loc5_++;
               }
               if(_loc6_ != _loc5_)
               {
                  _a[_loc6_] = _a[_loc5_];
                  _loc6_--;
               }
            }
            _a[_loc5_] = _loc15_;
            _quickSort(first,_loc5_ - first,cmp);
            _quickSort(_loc5_ + 1,_loc4_ - _loc5_,cmp);
         }
      }
      
      public function _insertionSortComparable() : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null as Object;
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc1_:int = 1;
         var _loc2_:int = _size;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc1_++;
            _loc4_ = _a[_loc3_];
            null;
            _loc5_ = _loc3_;
            while(_loc5_ > 0)
            {
               _loc6_ = _a[_loc5_ - 1];
               null;
               if(int(_loc6_.compare(_loc4_)) <= 0)
               {
                  break;
               }
               _a[_loc5_] = _loc6_;
               _loc5_--;
            }
            _a[_loc5_] = _loc4_;
         }
      }
      
      public function _insertionSort(cmp:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc7_:* = null as Object;
         var _loc2_:int = 1;
         var _loc3_:int = _size;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _loc5_ = _a[_loc4_];
            _loc6_ = _loc4_;
            while(_loc6_ > 0)
            {
               _loc7_ = _a[_loc6_ - 1];
               if(int(cmp(_loc7_,_loc5_)) <= 0)
               {
                  break;
               }
               _a[_loc6_] = _loc7_;
               _loc6_--;
            }
            _a[_loc6_] = _loc5_;
         }
      }
      
      public function __set(i:int, x:Object) : void
      {
         _a[i] = x;
      }
      
      public function __get(i:int) : Object
      {
         return _a[i];
      }
      
      public function __cpy(i:int, j:int) : void
      {
         _a[i] = _a[j];
      }
   }
}
