package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class LinkedQueue implements Queue
   {
       
      
      public var maxSize:int;
      
      public var key:int;
      
      public var _tailPool:LinkedQueueNode;
      
      public var _tail:LinkedQueueNode;
      
      public var _size:int;
      
      public var _reservedSize:int;
      
      public var _poolSize:int;
      
      public var _headPool:LinkedQueueNode;
      
      public var _head:LinkedQueueNode;
      
      public function LinkedQueue(reservedSize:int = 0, maxSize:int = -1)
      {
         var _loc3_:* = null as Object;
         var _loc4_:* = null as LinkedQueueNode;
         if(Boot.skip_constructor)
         {
            return;
         }
         maxSize = -1;
         _reservedSize = reservedSize;
         _size = 0;
         _poolSize = 0;
         if(reservedSize > 0)
         {
            _loc3_ = null;
            _headPool = _tailPool = new LinkedQueueNode(_loc3_);
         }
         var _loc5_:int;
         HashKey._counter = (_loc5_ = HashKey._counter) + 1;
         key = _loc5_;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{LinkedQueue size: %d}",[_size]);
      }
      
      public function toDA() : DA
      {
         var _loc3_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:LinkedQueueNode = _head;
         while(_loc2_ != null)
         {
            _loc3_ = _loc1_._size;
            null;
            _loc1_._a[_loc3_] = _loc2_.val;
            if(_loc3_ >= _loc1_._size)
            {
               _loc1_._size = _loc1_._size + 1;
            }
            _loc2_ = _loc2_.next;
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         null;
         var _loc2_:Array = new Array(_size);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:LinkedQueueNode = _head;
         while(_loc4_ != null)
         {
            _loc1_[_loc3_++] = _loc4_.val;
            _loc4_ = _loc4_.next;
         }
         return _loc1_;
      }
      
      public function size() : int
      {
         return _size;
      }
      
      public function shuffle(rval:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as LinkedQueueNode;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Object;
         var _loc9_:* = null as LinkedQueueNode;
         var _loc10_:int = 0;
         var _loc2_:int = _size;
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
      
      public function remove(_tmp_x:Object) : Boolean
      {
         var _loc6_:* = null as LinkedQueueNode;
         var _loc7_:* = null as Object;
         var _loc8_:* = null as LinkedQueueNode;
         var _loc9_:* = null as Object;
         var _loc10_:* = null as LinkedQueueNode;
         var _loc2_:Object = _tmp_x;
         if(_size == 0)
         {
            return false;
         }
         var _loc3_:Boolean = false;
         var _loc4_:LinkedQueueNode = _head;
         var _loc5_:LinkedQueueNode = _head.next;
         if(_head == _tail)
         {
            if(_head.val == _loc2_)
            {
               _size = 0;
               _loc6_ = _head;
               _loc7_ = _loc6_.val;
               if(_reservedSize > 0 && _poolSize < _reservedSize)
               {
                  _tailPool = _tailPool.next = _loc6_;
                  _loc9_ = null;
                  _loc6_.val = _loc9_;
                  _loc6_.next = null;
                  _poolSize = _poolSize + 1;
               }
               _loc7_;
               _head = null;
               _tail = null;
               return true;
            }
            return false;
         }
         while(_loc5_ != null)
         {
            if(_loc5_.val == _loc2_)
            {
               _loc3_ = true;
               if(_loc5_ == _tail)
               {
                  _tail = _loc4_;
               }
               _loc6_ = _loc5_.next;
               _loc4_.next = _loc6_;
               _loc7_ = _loc5_.val;
               if(_reservedSize > 0 && _poolSize < _reservedSize)
               {
                  _tailPool = _tailPool.next = _loc5_;
                  _loc9_ = null;
                  _loc5_.val = _loc9_;
                  _loc5_.next = null;
                  _poolSize = _poolSize + 1;
               }
               _loc7_;
               _loc5_ = _loc6_;
               _size = _size - 1;
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
            _loc6_ = _head.next;
            _loc8_ = _head;
            _loc7_ = _loc8_.val;
            if(_reservedSize > 0 && _poolSize < _reservedSize)
            {
               _tailPool = _tailPool.next = _loc8_;
               _loc9_ = null;
               _loc8_.val = _loc9_;
               _loc8_.next = null;
               _poolSize = _poolSize + 1;
            }
            _loc7_;
            _head = _loc6_;
            if(_head == null)
            {
               _tail = null;
            }
            _size = _size - 1;
         }
         return _loc3_;
      }
      
      public function peek() : Object
      {
         null;
         return _head.val;
      }
      
      public function iterator() : Itr
      {
         return new LinkedQueueIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function free() : void
      {
         var _loc3_:* = null as LinkedQueueNode;
         var _loc4_:* = null as LinkedQueueNode;
         var _loc1_:Object = null;
         var _loc2_:LinkedQueueNode = _head;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.next = null;
            _loc2_.val = _loc1_;
            _loc2_ = _loc3_;
         }
         _head = _tail = null;
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
            n = _size;
         }
         var _loc3_:LinkedQueueNode = _head;
         var _loc4_:int = 0;
         while(_loc4_ < n)
         {
            _loc5_ = _loc4_++;
            _loc3_.val = x;
            _loc3_ = _loc3_.next;
         }
      }
      
      public function enqueue(_tmp_x:Object) : void
      {
         var _loc4_:* = null as LinkedQueueNode;
         var _loc2_:Object = _tmp_x;
         _size = _size + 1;
         var _loc3_:LinkedQueueNode = _reservedSize == 0 || _poolSize == 0 ? new LinkedQueueNode(_loc2_) : (_loc4_ = _headPool, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc4_.val = _loc2_, _loc4_);
         if(_head == null)
         {
            _head = _tail = _loc3_;
            _head.next = _tail;
         }
         else
         {
            _tail.next = _loc3_;
            _tail = _loc3_;
         }
      }
      
      public function dequeue() : Object
      {
         var _loc3_:* = null as LinkedQueueNode;
         var _loc4_:* = null as Object;
         null;
         _size = _size - 1;
         var _loc1_:LinkedQueueNode = _head;
         if(_head == _tail)
         {
            _head = null;
            _tail = null;
         }
         else
         {
            _head = _head.next;
         }
         var _loc2_:Object = _loc1_.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = _loc1_;
            _loc4_ = null;
            _loc1_.val = _loc4_;
            _loc1_.next = null;
            _poolSize = _poolSize + 1;
         }
         return _loc2_;
      }
      
      public function contains(_tmp_x:Object) : Boolean
      {
         var _loc2_:Object = _tmp_x;
         var _loc3_:LinkedQueueNode = _head;
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
         var _loc5_:* = null as LinkedQueueNode;
         var _loc6_:* = null as LinkedQueueNode;
         var _loc7_:* = null as LinkedQueueNode;
         var _loc8_:* = null as Cloneable;
         var _loc3_:* = _tmp_copier;
         var _loc4_:LinkedQueue = new LinkedQueue(_reservedSize,maxSize);
         if(_size == 0)
         {
            return _loc4_;
         }
         if(assign)
         {
            _loc5_ = _head;
            if(_loc5_ != null)
            {
               _loc4_._head = _loc4_._tail = new LinkedQueueNode(_loc5_.val);
               _loc4_._head.next = _loc4_._tail;
            }
            if(_size > 1)
            {
               _loc5_ = _loc5_.next;
               while(_loc5_ != null)
               {
                  _loc6_ = new LinkedQueueNode(_loc5_.val);
                  _loc4_._tail = _loc4_._tail.next = _loc6_;
                  _loc5_ = _loc5_.next;
               }
            }
         }
         else if(_loc3_ == null)
         {
            _loc8_ = null;
            _loc5_ = _head;
            if(_loc5_ != null)
            {
               null;
               _loc8_ = _loc5_.val;
               _loc4_._head = _loc4_._tail = new LinkedQueueNode(_loc8_.clone());
               _loc4_._head.next = _loc4_._tail;
            }
            if(_size > 1)
            {
               _loc5_ = _loc5_.next;
               while(_loc5_ != null)
               {
                  null;
                  _loc8_ = _loc5_.val;
                  _loc6_ = new LinkedQueueNode(_loc8_.clone());
                  _loc4_._tail = _loc4_._tail.next = _loc6_;
                  _loc5_ = _loc5_.next;
               }
            }
         }
         else
         {
            _loc5_ = _head;
            if(_loc5_ != null)
            {
               _loc4_._head = _loc4_._tail = new LinkedQueueNode(_loc3_(_loc5_.val));
               _loc4_._head.next = _loc4_._tail;
            }
            if(_size > 1)
            {
               _loc5_ = _loc5_.next;
               while(_loc5_ != null)
               {
                  _loc6_ = new LinkedQueueNode(_loc3_(_loc5_.val));
                  _loc4_._tail = _loc4_._tail.next = _loc6_;
                  _loc5_ = _loc5_.next;
               }
            }
         }
         _loc4_._size = _size;
         return _loc4_;
      }
      
      public function clear(purge:Boolean = false) : void
      {
         var _loc2_:* = null as LinkedQueueNode;
         var _loc3_:* = null as LinkedQueueNode;
         var _loc4_:* = null as Object;
         var _loc5_:* = null as LinkedQueueNode;
         var _loc6_:* = null as Object;
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
                  _loc2_.val = _loc6_;
                  _loc2_.next = null;
                  _poolSize = _poolSize + 1;
               }
               _loc4_;
               _loc2_ = _loc2_.next;
            }
         }
         _head = _tail = null;
         _size = 0;
      }
      
      public function back() : Object
      {
         null;
         return _tail.val;
      }
      
      public function assign(C:Class, args:Array = undefined, n:int = 0) : void
      {
         var _loc6_:int = 0;
         null;
         if(n <= 0)
         {
            n = _size;
         }
         var _loc4_:LinkedQueueNode = _head;
         var _loc5_:int = 0;
         while(_loc5_ < n)
         {
            _loc6_ = _loc5_++;
            _loc4_.val = Instance.create(C,args);
            _loc4_ = _loc4_.next;
         }
      }
      
      public function _putNode(node:LinkedQueueNode) : Object
      {
         var _loc3_:* = null as LinkedQueueNode;
         var _loc4_:* = null as Object;
         var _loc2_:Object = node.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = node;
            _loc4_ = null;
            node.val = _loc4_;
            node.next = null;
            _poolSize = _poolSize + 1;
         }
         return _loc2_;
      }
      
      public function _getNode(x:Object) : LinkedQueueNode
      {
         var _loc2_:* = null as LinkedQueueNode;
         if(_reservedSize == 0 || _poolSize == 0)
         {
            return new LinkedQueueNode(x);
         }
         _loc2_ = _headPool;
         _headPool = _headPool.next;
         _poolSize = _poolSize - 1;
         _loc2_.val = x;
         return _loc2_;
      }
   }
}
