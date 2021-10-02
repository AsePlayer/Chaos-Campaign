package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class Array2 implements Collection
   {
       
      
      public var key:int;
      
      public var _w:int;
      
      public var _h:int;
      
      public var _a:Array;
      
      public function Array2(width:int = 0, height:int = 0)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         null;
         _w = width;
         _h = height;
         null;
         var _loc3_:Array = new Array(_w * _h);
         _a = _loc3_;
         var _loc4_:int;
         HashKey._counter = (_loc4_ = HashKey._counter) + 1;
         key = _loc4_;
      }
      
      public function walk(process:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = _h;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _loc5_ = 0;
            _loc6_ = _w;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               _loc8_ = _loc4_ * _w + _loc7_;
               _a[_loc8_] = process(_a[_loc8_],_loc7_,_loc4_);
            }
         }
      }
      
      public function transpose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null as Object;
         var _loc10_:* = null as Array;
         if(_w == _h)
         {
            _loc1_ = 0;
            _loc2_ = _h;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = _loc1_++;
               _loc4_ = _loc3_ + 1;
               _loc5_ = _w;
               while(_loc4_ < _loc5_)
               {
                  _loc6_ = _loc4_++;
                  null;
                  null;
                  null;
                  null;
                  null;
                  _loc7_ = _loc3_ * _w + _loc6_;
                  _loc8_ = _loc6_ * _w + _loc3_;
                  _loc9_ = _a[_loc7_];
                  _a[_loc7_] = _a[_loc8_];
                  _a[_loc8_] = _loc9_;
               }
            }
         }
         else
         {
            _loc10_ = [];
            _loc1_ = 0;
            _loc2_ = _h;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = _loc1_++;
               _loc4_ = 0;
               _loc5_ = _w;
               while(_loc4_ < _loc5_)
               {
                  _loc6_ = _loc4_++;
                  null;
                  null;
                  _loc10_[_loc6_ * _h + _loc3_] = _a[_loc3_ * _w + _loc6_];
               }
            }
            _a = _loc10_;
            _w ^= _h;
            _h ^= _w;
            _w ^= _h;
         }
      }
      
      public function toString() : String
      {
         return Sprintf.format("{Array2, %dx%d}",[_w,_h]);
      }
      
      public function toDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:DA = new DA(_w * _h);
         var _loc2_:int = 0;
         var _loc3_:int = _w * _h;
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
         var _loc2_:Array = new Array(_w * _h);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:int = _w * _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc1_[_loc5_] = _a[_loc5_];
         }
         return _loc1_;
      }
      
      public function swap(x0:int, y0:int, x1:int, y1:int) : void
      {
         null;
         null;
         null;
         null;
         null;
         var _loc5_:int = y0 * _w + x0;
         var _loc6_:int = y1 * _w + x1;
         var _loc7_:Object = _a[_loc5_];
         _a[_loc5_] = _a[_loc6_];
         _a[_loc6_] = _loc7_;
      }
      
      public function size() : int
      {
         return _w * _h;
      }
      
      public function shuffle(rval:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc2_:int = _w * _h;
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
      
      public function shiftW() : void
      {
         var _loc1_:* = null as Object;
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc2_ = _loc5_ * _w;
            _loc1_ = _a[_loc2_];
            _loc6_ = 1;
            _loc7_ = _w;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc6_++;
               _a[_loc2_ + _loc8_ - 1] = _a[_loc2_ + _loc8_];
            }
            _a[_loc2_ + _w - 1] = _loc1_;
         }
      }
      
      public function shiftS() : void
      {
         var _loc1_:* = null as Object;
         var _loc3_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:int = _h - 1;
         var _loc5_:int = _loc4_ * _w;
         var _loc6_:int = 0;
         var _loc7_:int = _w;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _loc1_ = _a[_loc5_ + _loc8_];
            _loc3_ = _loc4_;
            while(_loc3_-- > 0)
            {
               _a[(_loc3_ + 1) * _w + _loc8_] = _a[_loc3_ * _w + _loc8_];
            }
            _a[_loc8_] = _loc1_;
         }
      }
      
      public function shiftN() : void
      {
         var _loc1_:* = null as Object;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = _h - 1;
         var _loc3_:int = (_h - 1) * _w;
         var _loc4_:int = 0;
         var _loc5_:int = _w;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc1_ = _a[_loc6_];
            _loc7_ = 0;
            while(_loc7_ < _loc2_)
            {
               _loc8_ = _loc7_++;
               _a[_loc8_ * _w + _loc6_] = _a[(_loc8_ + 1) * _w + _loc6_];
            }
            _a[_loc3_ + _loc6_] = _loc1_;
         }
      }
      
      public function shiftE() : void
      {
         var _loc1_:* = null as Object;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = _h;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc3_ = _loc6_ * _w;
            _loc1_ = _a[_loc3_ + _w - 1];
            _loc2_ = _w - 1;
            while(_loc2_-- > 0)
            {
               _a[_loc3_ + _loc2_ + 1] = _a[_loc3_ + _loc2_];
            }
            _a[_loc3_] = _loc1_;
         }
      }
      
      public function setW(x:int) : void
      {
         resize(x,_h);
      }
      
      public function setRow(y:int, input:Array) : void
      {
         var _loc6_:int = 0;
         null;
         null;
         null;
         var _loc3_:int = y * _w;
         var _loc4_:int = 0;
         var _loc5_:int = _w;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _a[_loc3_ + _loc6_] = input[_loc6_];
         }
      }
      
      public function setH(x:int) : void
      {
         resize(_w,x);
      }
      
      public function setCol(x:int, input:Array) : void
      {
         var _loc5_:int = 0;
         null;
         null;
         null;
         var _loc3_:int = 0;
         var _loc4_:int = _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_ * _w + x] = input[_loc5_];
         }
      }
      
      public function setAtIndex(i:int, x:Object) : void
      {
         null;
         _a[int(i / _w) * _w + int(i % _w)] = x;
      }
      
      public function set(x:int, y:int, val:Object) : void
      {
         null;
         null;
         _a[y * _w + x] = val;
      }
      
      public function resize(w:int, h:int) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         null;
         if(w == _w && h == _h)
         {
            return;
         }
         var _loc3_:Array = _a;
         null;
         var _loc4_:Array = new Array(w * h);
         _a = _loc4_;
         var _loc5_:int = w < _w ? w : _w;
         var _loc6_:int = h < _h ? h : _h;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc7_++;
            _loc9_ = _loc8_ * w;
            _loc10_ = _loc8_ * _w;
            _loc11_ = 0;
            while(_loc11_ < _loc5_)
            {
               _loc12_ = _loc11_++;
               _a[_loc9_ + _loc12_] = _loc3_[_loc10_ + _loc12_];
            }
         }
         _w = w;
         _h = h;
      }
      
      public function remove(_tmp_x:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Object = _tmp_x;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = _w * _h;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_a[_loc6_] == _loc2_)
            {
               _a[_loc6_] = null;
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function prependRow(input:Array) : void
      {
         null;
         null;
         _h = _h + 1;
         var _loc2_:int = _w * _h;
         while(_loc2_-- > _w)
         {
            _a[_loc2_] = _a[_loc2_ - _w];
         }
         _loc2_++;
         while(_loc2_-- > 0)
         {
            _a[_loc2_] = input[_loc2_];
         }
      }
      
      public function prependCol(input:Array) : void
      {
         null;
         null;
         var _loc2_:int = _w * _h + _h;
         var _loc3_:int = _h - 1;
         var _loc4_:int = _h;
         var _loc5_:int = 0;
         var _loc6_:int = _loc2_;
         while(_loc6_-- > 0)
         {
            _loc5_++;
            if(_loc5_ > _w)
            {
               _loc5_ = 0;
               _loc4_--;
               _a[_loc6_] = input[_loc3_--];
            }
            else
            {
               _a[_loc6_] = _a[_loc6_ - _loc4_];
            }
         }
         _w = _w + 1;
      }
      
      public function iterator() : Itr
      {
         return new Array2Iterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return false;
      }
      
      public function indexToCell(i:int, cell:Array2Cell) : Array2Cell
      {
         null;
         null;
         cell.y = int(i / _w);
         cell.x = int(i % _w);
         return cell;
      }
      
      public function indexOf(x:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = _w * _h;
         while(_loc2_ < _loc3_)
         {
            if(_a[_loc2_] == x)
            {
               break;
            }
            _loc2_++;
         }
         return _loc2_ == _loc3_ ? -1 : _loc2_;
      }
      
      public function getW() : int
      {
         return _w;
      }
      
      public function getRow(y:int, output:Array) : Array
      {
         var _loc6_:int = 0;
         null;
         null;
         var _loc3_:int = y * _w;
         var _loc4_:int = 0;
         var _loc5_:int = _w;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            output[_loc6_] = _a[_loc3_ + _loc6_];
         }
         return output;
      }
      
      public function getIndex(x:int, y:int) : int
      {
         return y * _w + x;
      }
      
      public function getH() : int
      {
         return _h;
      }
      
      public function getCol(x:int, output:Array) : Array
      {
         var _loc5_:int = 0;
         null;
         null;
         var _loc3_:int = 0;
         var _loc4_:int = _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            output[_loc5_] = _a[_loc5_ * _w + x];
         }
         return output;
      }
      
      public function getAtIndex(i:int) : Object
      {
         null;
         return _a[int(i / _w) * _w + int(i % _w)];
      }
      
      public function getArray() : Array
      {
         return _a;
      }
      
      public function get(x:int, y:int) : Object
      {
         null;
         null;
         return _a[y * _w + x];
      }
      
      public function free() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = _w * _h;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _a[_loc4_] = _loc1_;
         }
         _a = null;
      }
      
      public function fill(x:Object) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = _w * _h;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _a[_loc4_] = x;
         }
      }
      
      public function contains(_tmp_x:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:Object = _tmp_x;
         var _loc3_:int = 0;
         var _loc4_:int = _w * _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            if(_a[_loc5_] == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clone(assign:Boolean, _tmp_copier:Object = undefined) : Collection
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Cloneable;
         var _loc3_:* = _tmp_copier;
         var _loc4_:Array2 = new Array2(_w,_h);
         if(assign)
         {
            _loc5_ = 0;
            _loc6_ = _w * _h;
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
            _loc6_ = _w * _h;
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
            _loc6_ = _w * _h;
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
         var _loc5_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = int(_a.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_] = _loc2_;
         }
      }
      
      public function cellToIndex(cell:Array2Cell) : int
      {
         null;
         null;
         null;
         return cell.y * _w + cell.x;
      }
      
      public function cellOf(x:Object, cell:Array2Cell) : Array2Cell
      {
         null;
         var _loc4_:int = 0;
         var _loc5_:int = _w * _h;
         while(_loc4_ < _loc5_)
         {
            if(_a[_loc4_] == x)
            {
               break;
            }
            _loc4_++;
         }
         var _loc3_:int = _loc4_ == _loc5_ ? -1 : _loc4_;
         if(_loc3_ == -1)
         {
            return null;
         }
         null;
         null;
         cell.y = int(_loc3_ / _w);
         cell.x = int(_loc3_ % _w);
         return cell;
      }
      
      public function assign(C:Class, args:Array = undefined) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = _w * _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_] = Instance.create(C,args);
         }
      }
      
      public function appendRow(input:Array) : void
      {
         var _loc5_:int = 0;
         null;
         null;
         var _loc3_:int;
         _h = (_loc3_ = _h) + 1;
         var _loc2_:int = _w * _loc3_;
         _loc3_ = 0;
         var _loc4_:int = _w;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_ + _loc2_] = input[_loc5_];
         }
      }
      
      public function appendCol(input:Array) : void
      {
         null;
         null;
         var _loc2_:int = _w * _h + _h;
         var _loc3_:int = _h - 1;
         var _loc4_:int = _h;
         var _loc5_:int = _w;
         var _loc6_:int = _loc2_;
         while(_loc6_-- > 0)
         {
            _loc5_++;
            if(_loc5_ > _w)
            {
               _loc5_ = 0;
               _loc4_--;
               _a[_loc6_] = input[_loc3_--];
            }
            else
            {
               _a[_loc6_] = _a[_loc6_ - _loc4_];
            }
         }
         _w = _w + 1;
      }
      
      public function __set(i:int, x:Object) : void
      {
         _a[i] = x;
      }
      
      public function __get(i:int) : Object
      {
         return _a[i];
      }
   }
}
