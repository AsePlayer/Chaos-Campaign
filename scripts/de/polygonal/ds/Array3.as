package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class Array3 implements Collection
   {
       
      
      public var key:int;
      
      public var _w:int;
      
      public var _h:int;
      
      public var _d:int;
      
      public var _a:Array;
      
      public function Array3(width:int = 0, height:int = 0, depth:int = 0)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         null;
         _w = width;
         _h = height;
         _d = depth;
         null;
         var _loc4_:Array = new Array(_w * _h * _d);
         _a = _loc4_;
         var _loc5_:int;
         HashKey._counter = (_loc5_ = HashKey._counter) + 1;
         key = _loc5_;
      }
      
      public function walk(process:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = _d;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _loc5_ = 0;
            _loc6_ = _h;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               _loc8_ = 0;
               _loc9_ = _w;
               while(_loc8_ < _loc9_)
               {
                  _loc10_ = _loc8_++;
                  _loc11_ = _loc4_ * _w * _h + _loc7_ * _w + _loc10_;
                  _a[_loc11_] = process(_a[_loc11_],_loc10_,_loc7_,_loc4_);
               }
            }
         }
      }
      
      public function toString() : String
      {
         return Sprintf.format("{Array3, %dx%dx%d}",[_w,_h,_d]);
      }
      
      public function toDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:DA = new DA(_w * _h * _d);
         var _loc2_:int = 0;
         var _loc3_:int = _w * _h * _d;
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
         var _loc2_:Array = new Array(_w * _h * _d);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:int = _w * _h * _d;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc1_[_loc5_] = _a[_loc5_];
         }
         return _loc1_;
      }
      
      public function swap(x0:int, y0:int, z0:int, x1:int, y1:int, z1:int) : void
      {
         null;
         null;
         null;
         null;
         null;
         null;
         null;
         var _loc7_:int = z0 * _w * _h + y0 * _w + x0;
         var _loc8_:int = z1 * _w * _h + y1 * _w + x1;
         var _loc9_:Object = _a[_loc7_];
         _a[_loc7_] = _a[_loc8_];
         _a[_loc8_] = _loc9_;
      }
      
      public function size() : int
      {
         return _w * _h * _d;
      }
      
      public function shuffle(rval:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc2_:int = _w * _h * _d;
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
      
      public function setW(x:int) : void
      {
         resize(x,_h,_d);
      }
      
      public function setRow(z:int, y:int, input:Array) : void
      {
         var _loc7_:int = 0;
         null;
         null;
         null;
         null;
         var _loc4_:int = z * _w * _h + y * _w;
         var _loc5_:int = 0;
         var _loc6_:int = _w;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _a[_loc4_ + _loc7_] = input[_loc7_];
         }
      }
      
      public function setPile(x:int, y:int, input:Array) : void
      {
         var _loc8_:int = 0;
         null;
         null;
         null;
         null;
         var _loc4_:int = _w * _h;
         var _loc5_:int = y * _w + x;
         var _loc6_:int = 0;
         var _loc7_:int = _d;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _a[_loc8_ * _loc4_ + _loc5_] = input[_loc8_];
         }
      }
      
      public function setH(x:int) : void
      {
         resize(_w,x,_d);
      }
      
      public function setD(x:int) : void
      {
         resize(_w,_h,x);
      }
      
      public function setCol(z:int, x:int, input:Array) : void
      {
         var _loc7_:int = 0;
         null;
         null;
         null;
         null;
         var _loc4_:int = z * _w * _h;
         var _loc5_:int = 0;
         var _loc6_:int = _h;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _a[_loc4_ + (_loc7_ * _w + x)] = input[_loc7_];
         }
      }
      
      public function set(x:int, y:int, z:int, val:Object) : void
      {
         null;
         null;
         null;
         _a[z * _w * _h + y * _w + x] = val;
      }
      
      public function resize(width:int, height:int, depth:int) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         null;
         if(width == _w && height == _h && depth == _d)
         {
            return;
         }
         var _loc4_:Array = _a;
         null;
         var _loc5_:Array = new Array(width * height * depth);
         _a = _loc5_;
         var _loc6_:int = width < _w ? width : _w;
         var _loc7_:int = height < _h ? height : _h;
         var _loc8_:int = depth < _d ? depth : _d;
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc10_ = _loc9_++;
            _loc11_ = _loc10_ * width * height;
            _loc12_ = _loc10_ * _w * _h;
            _loc13_ = 0;
            while(_loc13_ < _loc7_)
            {
               _loc14_ = _loc13_++;
               _loc15_ = _loc14_ * width;
               _loc16_ = _loc14_ * _w;
               _loc17_ = 0;
               while(_loc17_ < _loc6_)
               {
                  _loc18_ = _loc17_++;
                  _a[_loc11_ + _loc15_ + _loc18_] = _loc4_[_loc12_ + _loc16_ + _loc18_];
               }
            }
         }
         _w = width;
         _h = height;
         _d = depth;
      }
      
      public function remove(_tmp_x:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Object = _tmp_x;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = _w * _h * _d;
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
      
      public function iterator() : Itr
      {
         return new Array3Iterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return false;
      }
      
      public function indexToCell(i:int, cell:Array3Cell) : Array3Cell
      {
         null;
         null;
         var _loc3_:int = _w * _h;
         var _loc4_:int = int(i % _loc3_);
         cell.z = int(i / _loc3_);
         cell.y = int(_loc4_ / _w);
         cell.x = int(_loc4_ % _w);
         return cell;
      }
      
      public function indexOf(x:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = _w * _h * _d;
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
      
      public function getRow(z:int, y:int, output:Array) : Array
      {
         var _loc7_:int = 0;
         null;
         null;
         null;
         var _loc4_:int = z * _w * _h + y * _w;
         var _loc5_:int = 0;
         var _loc6_:int = _w;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            output.push(_a[_loc4_ + _loc7_]);
         }
         return output;
      }
      
      public function getPile(x:int, y:int, output:Array) : Array
      {
         var _loc8_:int = 0;
         null;
         null;
         null;
         var _loc4_:int = _w * _h;
         var _loc5_:int = y * _w + x;
         var _loc6_:int = 0;
         var _loc7_:int = _d;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            output.push(_a[_loc8_ * _loc4_ + _loc5_]);
         }
         return output;
      }
      
      public function getLayer(z:int, output:Array2) : Array2
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         null;
         null;
         null;
         var _loc3_:int = z * _w * _h;
         var _loc4_:int = 0;
         var _loc5_:int = _w;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc7_ = 0;
            _loc8_ = _h;
            while(_loc7_ < _loc8_)
            {
               _loc9_ = _loc7_++;
               null;
               null;
               output._a[_loc9_ * output._w + _loc6_] = _a[_loc3_ + _loc9_ * _w + _loc6_];
            }
         }
         return output;
      }
      
      public function getIndex(x:int, y:int, z:int) : int
      {
         return z * _w * _h + y * _w + x;
      }
      
      public function getH() : int
      {
         return _h;
      }
      
      public function getD() : int
      {
         return _d;
      }
      
      public function getCol(z:int, x:int, output:Array) : Array
      {
         var _loc7_:int = 0;
         null;
         null;
         null;
         var _loc4_:int = z * _w * _h;
         var _loc5_:int = 0;
         var _loc6_:int = _h;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            output.push(_a[_loc4_ + (_loc7_ * _w + x)]);
         }
         return output;
      }
      
      public function getArray() : Array
      {
         return _a;
      }
      
      public function get(x:int, y:int, z:int) : Object
      {
         null;
         null;
         null;
         return _a[z * _w * _h + y * _w + x];
      }
      
      public function free() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = _w * _h * _d;
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
         var _loc3_:int = _w * _h * _d;
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
         var _loc4_:int = _w * _h * _d;
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
         var _loc4_:Array3 = new Array3(_w,_h,_d);
         if(assign)
         {
            _loc5_ = 0;
            _loc6_ = _w * _h * _d;
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
            _loc6_ = _w * _h * _d;
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
            _loc6_ = _w * _h * _d;
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
            _a[_loc5_] = null;
         }
      }
      
      public function cellToIndex(cell:Array3Cell) : int
      {
         null;
         null;
         null;
         null;
         return cell.z * _w * _h + cell.y * _w + cell.x;
      }
      
      public function cellOf(x:Object, cell:Array3Cell) : Array3Cell
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         null;
         _loc4_ = 0;
         _loc5_ = _w * _h * _d;
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
         _loc4_ = _w * _h;
         _loc5_ = int(_loc3_ % _loc4_);
         cell.z = int(_loc3_ / _loc4_);
         cell.y = int(_loc5_ / _w);
         cell.x = int(_loc5_ % _w);
         return cell;
      }
      
      public function assign(C:Class, args:Array = undefined) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = _w * _h * _d;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_] = Instance.create(C,args);
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
   }
}
