package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class LinkedStack implements Stack
   {
       
      
      public var maxSize:int;
      
      public var key:int;
      
      public var _top:int;
      
      public var _tailPool:LinkedStackNode;
      
      public var _reservedSize:int;
      
      public var _poolSize:int;
      
      public var _headPool:LinkedStackNode;
      
      public var _head:LinkedStackNode;
      
      public function LinkedStack(reservedSize:int = 0, maxSize:int = -1)
      {
         var _loc3_:* = null as Object;
         var _loc4_:* = null as LinkedStackNode;
         if(Boot.skip_constructor)
         {
            return;
         }
         if(reservedSize > 0)
         {
            if(maxSize != -1)
            {
               null;
            }
         }
         maxSize = -1;
         _reservedSize = reservedSize;
         _top = 0;
         _poolSize = 0;
         if(reservedSize > 0)
         {
            _loc3_ = null;
            _headPool = _tailPool = new LinkedStackNode(_loc3_);
         }
         var _loc5_:int;
         HashKey._counter = (_loc5_ = HashKey._counter) + 1;
         key = _loc5_;
      }
      
      public function top() : Object
      {
         null;
         return _head.val;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{LinkedStack size: %d}",[_top]);
      }
      
      public function toDA() : DA
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:DA = new DA(_top);
         _loc1_.fill(null,_top);
         var _loc2_:Array = [];
         var _loc3_:LinkedStackNode = _head;
         var _loc4_:int = 0;
         var _loc5_:int = _top;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc7_ = _top - _loc6_ - 1;
            null;
            _loc1_._a[_loc7_] = _loc3_.val;
            if(_loc7_ >= _loc1_._size)
            {
               _loc1_._size = _loc1_._size + 1;
            }
            _loc3_ = _loc3_.next;
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc5_:int = 0;
         null;
         var _loc2_:Array = new Array(_top);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = _top;
         if(_loc3_ == -1)
         {
            _loc3_ = int(_loc1_.length);
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc4_++;
            _loc1_[_loc5_] = null;
         }
         var _loc6_:LinkedStackNode = _head;
         _loc3_ = 0;
         _loc4_ = _top;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc1_[_top - _loc5_ - 1] = _loc6_.val;
            _loc6_ = _loc6_.next;
         }
         return _loc1_;
      }
      
      public function swp(i:int, j:int) : void
      {
         null;
         null;
         null;
         null;
         var _loc3_:LinkedStackNode = _head;
         if(i < j)
         {
            i ^= j;
            j ^= i;
            i ^= j;
         }
         var _loc4_:int = _top - 1;
         while(_loc4_ > i)
         {
            _loc3_ = _loc3_.next;
            _loc4_--;
         }
         var _loc5_:LinkedStackNode = _loc3_;
         while(_loc4_ > j)
         {
            _loc3_ = _loc3_.next;
            _loc4_--;
         }
         var _loc6_:Object = _loc5_.val;
         _loc5_.val = _loc3_.val;
         _loc3_.val = _loc6_;
      }
      
      public function size() : int
      {
         return _top;
      }
      
      public function shuffle(rval:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as LinkedStackNode;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Object;
         var _loc9_:* = null as LinkedStackNode;
         var _loc10_:int = 0;
         var _loc2_:int = _top;
         if(rval == null)
         {
            _loc3_ = Math;
            while(_loc2_ > 1)
            {
               _loc2_--;
               _loc4_ = int(_loc3_.random() * _loc2_);
               _loc5_ = _head;
               _loc6_ = 0;
               while(_loc6_ < _loc2_)
               {
                  _loc7_ = _loc6_++;
                  _loc5_ = _loc5_.next;
               }
               _loc8_ = _loc5_.val;
               _loc9_ = _head;
               _loc6_ = 0;
               while(_loc6_ < _loc4_)
               {
                  _loc7_ = _loc6_++;
                  _loc9_ = _loc9_.next;
               }
               _loc5_.val = _loc9_.val;
               _loc9_.val = _loc8_;
            }
         }
         else
         {
            null;
            _loc4_ = 0;
            while(_loc2_ > 1)
            {
               _loc2_--;
               null;
               _loc6_ = int(rval._a[_loc4_++] * _loc2_);
               _loc5_ = _head;
               _loc7_ = 0;
               while(_loc7_ < _loc2_)
               {
                  _loc10_ = _loc7_++;
                  _loc5_ = _loc5_.next;
               }
               _loc8_ = _loc5_.val;
               _loc9_ = _head;
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc10_ = _loc7_++;
                  _loc9_ = _loc9_.next;
               }
               _loc5_.val = _loc9_.val;
               _loc9_.val = _loc8_;
            }
         }
      }
      
      public function set(i:int, x:Object) : void
      {
         null;
         null;
         var _loc3_:LinkedStackNode = _head;
         i = _top - i;
         while(true)
         {
            i--;
            if(i <= 0)
            {
               break;
            }
            _loc3_ = _loc3_.next;
         }
         _loc3_.val = x;
      }
      
      public function rotRight(n:int) : void
      {
         var _loc5_:int = 0;
         null;
         var _loc2_:LinkedStackNode = _head;
         var _loc3_:int = 0;
         var _loc4_:int = n - 2;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc2_ = _loc2_.next;
         }
         var _loc6_:LinkedStackNode = _loc2_.next;
         _loc2_.next = _loc6_.next;
         _loc6_.next = _head;
         _head = _loc6_;
      }
      
      public function rotLeft(n:int) : void
      {
         var _loc6_:int = 0;
         null;
         var _loc2_:LinkedStackNode = _head;
         _head = _head.next;
         var _loc3_:LinkedStackNode = _head;
         var _loc4_:int = 0;
         var _loc5_:int = n - 2;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc3_ = _loc3_.next;
         }
         _loc2_.next = _loc3_.next;
         _loc3_.next = _loc2_;
      }
      
      public function remove(_tmp_x:Object) : Boolean
      {
         var _loc7_:* = null as LinkedStackNode;
         var _loc8_:* = null as Object;
         var _loc9_:* = null as LinkedStackNode;
         var _loc10_:* = null as Object;
         var _loc11_:* = null as LinkedStackNode;
         var _loc2_:Object = _tmp_x;
         if(_top == 0)
         {
            return false;
         }
         var _loc3_:Boolean = false;
         var _loc4_:LinkedStackNode = _head;
         var _loc5_:LinkedStackNode = _head.next;
         var _loc6_:Object = null;
         while(_loc5_ != null)
         {
            if(_loc5_.val == _loc2_)
            {
               _loc3_ = true;
               _loc7_ = _loc5_.next;
               _loc4_.next = _loc7_;
               _loc8_ = _loc5_.val;
               if(_reservedSize > 0 && _poolSize < _reservedSize)
               {
                  _tailPool = _tailPool.next = _loc5_;
                  _loc10_ = null;
                  _loc5_.next = null;
                  _loc5_.val = _loc10_;
                  _poolSize = _poolSize + 1;
               }
               _loc8_;
               _loc5_ = _loc7_;
               _top = _top - 1;
            }
            else
            {
               _loc4_ = _loc5_;
               _loc5_ = _loc5_.next;
            }
         }
         if(_head.val == _loc2_)
         {
            _loc3_ = true;
            _loc7_ = _head.next;
            _loc9_ = _head;
            _loc8_ = _loc9_.val;
            if(_reservedSize > 0 && _poolSize < _reservedSize)
            {
               _tailPool = _tailPool.next = _loc9_;
               _loc10_ = null;
               _loc9_.next = null;
               _loc9_.val = _loc10_;
               _poolSize = _poolSize + 1;
            }
            _loc8_;
            _head = _loc7_;
            _top = _top - 1;
         }
         return _loc3_;
      }
      
      public function push(_tmp_x:Object) : void
      {
         var _loc4_:* = null as LinkedStackNode;
         var _loc2_:Object = _tmp_x;
         var _loc3_:LinkedStackNode = _reservedSize == 0 || _poolSize == 0 ? new LinkedStackNode(_loc2_) : (_loc4_ = _headPool, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc4_.val = _loc2_, _loc4_);
         _loc3_.next = _head;
         _head = _loc3_;
         _top = _top + 1;
      }
      
      public function pop() : Object
      {
         var _loc3_:* = null as LinkedStackNode;
         var _loc4_:* = null as Object;
         null;
         _top = _top - 1;
         var _loc1_:LinkedStackNode = _head;
         _head = _head.next;
         var _loc2_:Object = _loc1_.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = _loc1_;
            _loc4_ = null;
            _loc1_.next = null;
            _loc1_.val = _loc4_;
            _poolSize = _poolSize + 1;
         }
         return _loc2_;
      }
      
      public function iterator() : Itr
      {
         return new LinkedStackIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _top == 0;
      }
      
      public function get(i:int) : Object
      {
         null;
         null;
         var _loc2_:LinkedStackNode = _head;
         i = _top - i;
         while(true)
         {
            i--;
            if(i <= 0)
            {
               break;
            }
            _loc2_ = _loc2_.next;
         }
         return _loc2_.val;
      }
      
      public function free() : void
      {
         var _loc3_:* = null as LinkedStackNode;
         var _loc4_:* = null as LinkedStackNode;
         var _loc1_:Object = null;
         var _loc2_:LinkedStackNode = _head;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.next = null;
            _loc2_.val = _loc1_;
            _loc2_ = _loc3_;
         }
         _head = null;
         _loc3_ = _headPool;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.next;
            _loc3_.next = null;
            _loc3_.val = _loc1_;
            _loc3_ = _loc4_;
         }
         _headPool = _tailPool = null;
      }
      
      public function fill(x:Object, n:int = 0) : void
      {
         var _loc5_:int = 0;
         null;
         if(n <= 0)
         {
            n = _top;
         }
         var _loc3_:LinkedStackNode = _head;
         var _loc4_:int = 0;
         while(_loc4_ < n)
         {
            _loc5_ = _loc4_++;
            _loc3_.val = x;
            _loc3_ = _loc3_.next;
         }
      }
      
      public function exchange() : void
      {
         null;
         var _loc1_:Object = _head.val;
         _head.val = _head.next.val;
         _head.next.val = _loc1_;
      }
      
      public function dup() : void
      {
         var _loc3_:* = null as LinkedStackNode;
         null;
         var _loc2_:Object = _head.val;
         var _loc1_:LinkedStackNode = _reservedSize == 0 || _poolSize == 0 ? new LinkedStackNode(_loc2_) : (_loc3_ = _headPool, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc3_.val = _loc2_, _loc3_);
         _loc1_.next = _head;
         _head = _loc1_;
         _top = _top + 1;
      }
      
      public function cpy(i:int, j:int) : void
      {
         null;
         null;
         null;
         null;
         var _loc3_:LinkedStackNode = _head;
         if(i < j)
         {
            i ^= j;
            j ^= i;
            i ^= j;
         }
         var _loc4_:int = _top - 1;
         while(_loc4_ > i)
         {
            _loc3_ = _loc3_.next;
            _loc4_--;
         }
         var _loc5_:Object = _loc3_.val;
         while(_loc4_ > j)
         {
            _loc3_ = _loc3_.next;
            _loc4_--;
         }
         _loc3_.val = _loc5_;
      }
      
      public function contains(_tmp_x:Object) : Boolean
      {
         var _loc2_:Object = _tmp_x;
         var _loc3_:LinkedStackNode = _head;
         while(_loc3_ != null)
         {
            if(_loc3_.val == _loc2_)
            {
               return true;
            }
            _loc3_ = _loc3_.next;
         }
         return false;
      }
      
      public function clone(assign:Boolean, _tmp_copier:Object = undefined) : Collection
      {
         var _loc6_:* = null as LinkedStackNode;
         var _loc7_:* = null as LinkedStackNode;
         var _loc8_:* = null as LinkedStackNode;
         var _loc9_:* = null as Cloneable;
         var _loc3_:* = _tmp_copier;
         var _loc4_:LinkedStack = new LinkedStack(_reservedSize,maxSize);
         if(_top == 0)
         {
            return _loc4_;
         }
         var _loc5_:LinkedStack = new LinkedStack(_reservedSize,maxSize);
         _loc5_._top = _top;
         if(assign)
         {
            _loc6_ = _head;
            _loc7_ = _loc5_._head = new LinkedStackNode(_loc6_.val);
            _loc6_ = _loc6_.next;
            while(_loc6_ != null)
            {
               _loc7_ = _loc7_.next = new LinkedStackNode(_loc6_.val);
               _loc6_ = _loc6_.next;
            }
         }
         else if(_loc3_ == null)
         {
            _loc6_ = _head;
            null;
            _loc9_ = _loc6_.val;
            _loc7_ = _loc5_._head = new LinkedStackNode(_loc9_.clone());
            _loc6_ = _loc6_.next;
            while(_loc6_ != null)
            {
               null;
               _loc9_ = _loc6_.val;
               _loc7_ = _loc7_.next = new LinkedStackNode(_loc9_.clone());
               _loc6_ = _loc6_.next;
            }
         }
         else
         {
            _loc6_ = _head;
            _loc7_ = _loc5_._head = new LinkedStackNode(_loc3_(_loc6_.val));
            _loc6_ = _loc6_.next;
            while(_loc6_ != null)
            {
               _loc7_ = _loc7_.next = new LinkedStackNode(_loc3_(_loc6_.val));
               _loc6_ = _loc6_.next;
            }
         }
         return _loc5_;
      }
      
      public function clear(purge:Boolean = false) : void
      {
         var _loc2_:* = null as LinkedStackNode;
         var _loc3_:* = null as LinkedStackNode;
         var _loc4_:* = null as Object;
         var _loc5_:* = null as LinkedStackNode;
         var _loc6_:* = null as Object;
         if(_top == 0)
         {
            return;
         }
         if(purge || _reservedSize > 0)
         {
            _loc2_ = _head;
            while(_loc2_ != null)
            {
               _loc3_ = _loc2_.next;
               _loc4_ = _loc2_.val;
               if(_reservedSize > 0 && _poolSize < _reservedSize)
               {
                  _tailPool = _tailPool.next = _loc2_;
                  _loc6_ = null;
                  _loc2_.next = null;
                  _loc2_.val = _loc6_;
                  _poolSize = _poolSize + 1;
               }
               _loc4_;
               _loc2_ = _loc3_;
            }
         }
         _head.next = null;
         _head.val = null;
         _top = 0;
      }
      
      public function assign(C:Class, args:Array = undefined, n:int = 0) : void
      {
         var _loc6_:int = 0;
         null;
         if(n <= 0)
         {
            n = _top;
         }
         var _loc4_:LinkedStackNode = _head;
         var _loc5_:int = 0;
         while(_loc5_ < n)
         {
            _loc6_ = _loc5_++;
            _loc4_.val = Instance.create(C,args);
            _loc4_ = _loc4_.next;
         }
      }
      
      public function _putNode(node:LinkedStackNode) : Object
      {
         var _loc3_:* = null as LinkedStackNode;
         var _loc4_:* = null as Object;
         var _loc2_:Object = node.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = node;
            _loc4_ = null;
            node.next = null;
            node.val = _loc4_;
            _poolSize = _poolSize + 1;
         }
         return _loc2_;
      }
      
      public function _getNode(x:Object) : LinkedStackNode
      {
         var _loc2_:* = null as LinkedStackNode;
         if(_reservedSize == 0 || _poolSize == 0)
         {
            return new LinkedStackNode(x);
         }
         _loc2_ = _headPool;
         _headPool = _headPool.next;
         _poolSize = _poolSize - 1;
         _loc2_.val = x;
         return _loc2_;
      }
   }
}
