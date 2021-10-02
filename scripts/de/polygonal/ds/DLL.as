package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class DLL implements Collection
   {
       
      
      public var tail:DLLNode;
      
      public var maxSize:int;
      
      public var key:int;
      
      public var head:DLLNode;
      
      public var _tailPool:DLLNode;
      
      public var _size:int;
      
      public var _reservedSize:int;
      
      public var _poolSize:int;
      
      public var _headPool:DLLNode;
      
      public var _circular:Boolean;
      
      public function DLL(reservedSize:int = 0, maxSize:int = -1)
      {
         var _loc3_:* = null as Object;
         var _loc4_:* = null as DLLNode;
         if(Boot.skip_constructor)
         {
            return;
         }
         maxSize = -1;
         _reservedSize = reservedSize;
         _circular = false;
         _size = 0;
         _poolSize = 0;
         if(reservedSize > 0)
         {
            _loc3_ = null;
            _headPool = _tailPool = new DLLNode(_loc3_,this);
         }
         head = tail = null;
         var _loc5_:int;
         HashKey._counter = (_loc5_ = HashKey._counter) + 1;
         key = _loc5_;
      }
      
      public function unlink(node:DLLNode) : DLLNode
      {
         var _loc4_:* = null as DLLNode;
         var _loc5_:* = null as Object;
         null;
         null;
         null;
         var _loc2_:DLLNode = node.next;
         if(node == head)
         {
            head = head.next;
            if(_circular)
            {
               if(head == tail)
               {
                  head = null;
               }
               else
               {
                  tail.next = head;
               }
            }
            if(head == null)
            {
               tail = null;
            }
         }
         else if(node == tail)
         {
            tail = tail.prev;
            if(_circular)
            {
               head.prev = tail;
            }
            if(tail == null)
            {
               head = null;
            }
         }
         node._unlink();
         var _loc3_:Object = node.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = node;
            _loc5_ = null;
            node.val = _loc5_;
            null;
            null;
            _poolSize = _poolSize + 1;
         }
         else
         {
            node._list = null;
         }
         _loc3_;
         _size = _size - 1;
         return _loc2_;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{DLL, size: %d, circular: %s}",[_size,_circular]);
      }
      
      public function toDA() : DA
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:DLLNode = head;
         var _loc3_:int = 0;
         var _loc4_:int = _size;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = _loc1_._size;
            null;
            _loc1_._a[_loc6_] = _loc2_.val;
            if(_loc6_ >= _loc1_._size)
            {
               _loc1_._size = _loc1_._size + 1;
            }
            _loc2_ = _loc2_.next;
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc6_:int = 0;
         null;
         var _loc2_:Array = new Array(_size);
         var _loc1_:Array = _loc2_;
         var _loc3_:DLLNode = head;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc1_[_loc6_] = _loc3_.val;
            _loc3_ = _loc3_.next;
         }
         return _loc1_;
      }
      
      public function sort(compare:Function, useInsertionSort:Boolean = false) : void
      {
         if(_size > 1)
         {
            if(_circular)
            {
               tail.next = null;
               head.prev = null;
            }
            if(compare == null)
            {
               head = !!useInsertionSort ? _insertionSortComparable(head) : _mergeSortComparable(head);
            }
            else
            {
               head = !!useInsertionSort ? _insertionSort(head,compare) : _mergeSort(head,compare);
            }
            if(_circular)
            {
               tail.next = head;
               head.prev = tail;
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
         var _loc5_:* = null as DLLNode;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Object;
         var _loc9_:* = null as DLLNode;
         var _loc10_:int = 0;
         var _loc2_:int = _size;
         if(rval == null)
         {
            _loc3_ = Math;
            while(_loc2_ > 1)
            {
               _loc2_--;
               _loc4_ = int(_loc3_.random() * _loc2_);
               _loc5_ = head;
               _loc6_ = 0;
               while(_loc6_ < _loc2_)
               {
                  _loc7_ = _loc6_++;
                  _loc5_ = _loc5_.next;
               }
               _loc8_ = _loc5_.val;
               _loc9_ = head;
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
               _loc5_ = head;
               _loc7_ = 0;
               while(_loc7_ < _loc2_)
               {
                  _loc10_ = _loc7_++;
                  _loc5_ = _loc5_.next;
               }
               _loc8_ = _loc5_.val;
               _loc9_ = head;
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
         if(_circular)
         {
            tail.next = head;
            head.prev = tail;
         }
      }
      
      public function shiftUp() : void
      {
         var _loc1_:* = null as DLLNode;
         null;
         if(_size > 1)
         {
            _loc1_ = head;
            if(head.next == tail)
            {
               head = tail;
               head.prev = null;
               tail = _loc1_;
               tail.next = null;
               head.next = tail;
               tail.prev = head;
            }
            else
            {
               head = head.next;
               head.prev = null;
               tail.next = _loc1_;
               _loc1_.next = null;
               _loc1_.prev = tail;
               tail = _loc1_;
            }
            if(_circular)
            {
               tail.next = head;
               head.prev = tail;
            }
         }
      }
      
      public function reverse() : void
      {
         var _loc1_:* = null as Object;
         var _loc2_:* = null as DLLNode;
         var _loc3_:* = null as DLLNode;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(_size <= 1)
         {
            return;
         }
         if(_size <= 3)
         {
            _loc1_ = head.val;
            head.val = tail.val;
            tail.val = _loc1_;
         }
         else
         {
            _loc2_ = head;
            _loc3_ = tail;
            _loc4_ = 0;
            _loc5_ = _size >> 1;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               _loc1_ = _loc2_.val;
               _loc2_.val = _loc3_.val;
               _loc3_.val = _loc1_;
               _loc2_ = _loc2_.next;
               _loc3_ = _loc3_.prev;
            }
         }
      }
      
      public function removeTail() : Object
      {
         var _loc2_:* = null as DLLNode;
         var _loc4_:* = null as Object;
         null;
         var _loc1_:DLLNode = tail;
         if(head == tail)
         {
            head = tail = null;
         }
         else
         {
            tail = tail.prev;
            _loc1_.prev = null;
            if(_circular)
            {
               tail.next = head;
               head.prev = tail;
            }
            else
            {
               tail.next = null;
            }
         }
         _size = _size - 1;
         var _loc3_:Object = _loc1_.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = _loc1_;
            _loc4_ = null;
            _loc1_.val = _loc4_;
            null;
            null;
            _poolSize = _poolSize + 1;
         }
         else
         {
            _loc1_._list = null;
         }
         return _loc3_;
      }
      
      public function removeHead() : Object
      {
         var _loc2_:* = null as DLLNode;
         var _loc4_:* = null as Object;
         null;
         var _loc1_:DLLNode = head;
         if(head == tail)
         {
            head = tail = null;
         }
         else
         {
            head = head.next;
            _loc1_.next = null;
            if(_circular)
            {
               head.prev = tail;
               tail.next = head;
            }
            else
            {
               head.prev = null;
            }
         }
         _size = _size - 1;
         var _loc3_:Object = _loc1_.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = _loc1_;
            _loc4_ = null;
            _loc1_.val = _loc4_;
            null;
            null;
            _poolSize = _poolSize + 1;
         }
         else
         {
            _loc1_._list = null;
         }
         return _loc3_;
      }
      
      public function remove(_tmp_x:Object) : Boolean
      {
         var _loc2_:Object = _tmp_x;
         var _loc3_:int = _size;
         if(_loc3_ == 0)
         {
            return false;
         }
         var _loc4_:DLLNode = head;
         while(_loc4_ != null)
         {
            if(_loc4_.val == _loc2_)
            {
               _loc4_ = unlink(_loc4_);
            }
            else
            {
               _loc4_ = _loc4_.next;
            }
         }
         return _size < _loc3_;
      }
      
      public function prepend(x:Object) : DLLNode
      {
         var _loc3_:* = null as DLLNode;
         var _loc2_:DLLNode = _reservedSize == 0 || _poolSize == 0 ? new DLLNode(x,this) : (_loc3_ = _headPool, null, null, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc3_.next = null, _loc3_.val = x, _loc3_);
         _loc2_.next = head;
         if(head != null)
         {
            head.prev = _loc2_;
         }
         else
         {
            tail = _loc2_;
         }
         head = _loc2_;
         if(_circular)
         {
            tail.next = head;
            head.prev = tail;
         }
         _size = _size + 1;
         return _loc2_;
      }
      
      public function popDown() : void
      {
         var _loc1_:* = null as DLLNode;
         null;
         if(_size > 1)
         {
            _loc1_ = tail;
            if(tail.prev == head)
            {
               tail = head;
               tail.next = null;
               head = _loc1_;
               head.prev = null;
               head.next = tail;
               tail.prev = head;
            }
            else
            {
               tail = tail.prev;
               tail.next = null;
               head.prev = _loc1_;
               _loc1_.prev = null;
               _loc1_.next = head;
               head = _loc1_;
            }
            if(_circular)
            {
               tail.next = head;
               head.prev = tail;
            }
         }
      }
      
      public function open() : void
      {
         if(!_circular)
         {
            return;
         }
         _circular = false;
         if(head != null)
         {
            tail.next = null;
            head.prev = null;
         }
      }
      
      public function nodeOf(x:Object, from:DLLNode = undefined) : DLLNode
      {
         var _loc6_:int = 0;
         if(from == null)
         {
            from = head;
         }
         var _loc3_:DLLNode = from;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_loc3_.val == x)
            {
               break;
            }
            _loc3_ = _loc3_.next;
         }
         return _loc3_;
      }
      
      public function merge(x:DLL) : void
      {
         var _loc2_:* = null as DLLNode;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         null;
         null;
         if(x.head != null)
         {
            _loc2_ = x.head;
            _loc3_ = 0;
            _loc4_ = x._size;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc3_++;
               _loc2_._list = this;
               _loc2_ = _loc2_.next;
            }
            if(head != null)
            {
               tail.next = x.head;
               x.head.prev = tail;
               tail = x.tail;
            }
            else
            {
               head = x.head;
               tail = x.tail;
            }
            _size += x._size;
            if(_circular)
            {
               tail.next = head;
               head.prev = tail;
            }
         }
      }
      
      public function lastNodeOf(x:Object, from:DLLNode = undefined) : DLLNode
      {
         var _loc6_:int = 0;
         if(from == null)
         {
            from = tail;
         }
         var _loc3_:DLLNode = from;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_loc3_.val == x)
            {
               break;
            }
            _loc3_ = _loc3_.prev;
         }
         return _loc3_;
      }
      
      public function join(x:String) : String
      {
         var _loc3_:* = null as DLLNode;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:String = "";
         if(_size > 0)
         {
            _loc3_ = head;
            _loc4_ = 0;
            _loc5_ = _size - 1;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               _loc2_ += Std.string(_loc3_.val) + x;
               _loc3_ = _loc3_.next;
            }
            _loc2_ += Std.string(_loc3_.val);
         }
         return _loc2_;
      }
      
      public function iterator() : Itr
      {
         if(_circular)
         {
            return new CircularDLLIterator(this);
         }
         return new DLLIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function isCircular() : Boolean
      {
         return _circular;
      }
      
      public function insertBefore(node:DLLNode, x:Object) : DLLNode
      {
         var _loc4_:* = null as DLLNode;
         null;
         null;
         var _loc3_:DLLNode = _reservedSize == 0 || _poolSize == 0 ? new DLLNode(x,this) : (_loc4_ = _headPool, null, null, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc4_.next = null, _loc4_.val = x, _loc4_);
         node._insertBefore(_loc3_);
         if(node == head)
         {
            head = _loc3_;
            if(_circular)
            {
               head.prev = tail;
            }
         }
         _size = _size + 1;
         return _loc3_;
      }
      
      public function insertAfter(node:DLLNode, x:Object) : DLLNode
      {
         var _loc4_:* = null as DLLNode;
         null;
         null;
         var _loc3_:DLLNode = _reservedSize == 0 || _poolSize == 0 ? new DLLNode(x,this) : (_loc4_ = _headPool, null, null, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc4_.next = null, _loc4_.val = x, _loc4_);
         node._insertAfter(_loc3_);
         if(node == tail)
         {
            tail = _loc3_;
            if(_circular)
            {
               tail.next = head;
            }
         }
         _size = _size + 1;
         return _loc3_;
      }
      
      public function getNodeAt(i:int) : DLLNode
      {
         var _loc4_:int = 0;
         null;
         null;
         var _loc2_:DLLNode = head;
         var _loc3_:int = 0;
         while(_loc3_ < i)
         {
            _loc4_ = _loc3_++;
            _loc2_ = _loc2_.next;
         }
         return _loc2_;
      }
      
      public function free() : void
      {
         var _loc3_:* = null as DLLNode;
         var _loc4_:* = null as DLLNode;
         var _loc1_:Object = null;
         var _loc2_:DLLNode = head;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.next = _loc2_.prev = null;
            _loc2_.val = _loc1_;
            _loc2_ = _loc3_;
         }
         head = tail = null;
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
      
      public function fill(x:Object, args:Array = undefined, n:int = 0) : void
      {
         var _loc6_:int = 0;
         null;
         if(n <= 0)
         {
            n = _size;
         }
         var _loc4_:DLLNode = head;
         var _loc5_:int = 0;
         while(_loc5_ < n)
         {
            _loc6_ = _loc5_++;
            _loc4_.val = x;
            _loc4_ = _loc4_.next;
         }
      }
      
      public function contains(_tmp_x:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Object = _tmp_x;
         var _loc3_:DLLNode = head;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_loc3_.val == _loc2_)
            {
               return true;
            }
            _loc3_ = _loc3_.next;
         }
         return false;
      }
      
      public function concat(x:DLL) : DLL
      {
         var _loc4_:* = null as DLLNode;
         var _loc5_:* = null as DLLNode;
         var _loc6_:* = null as DLLNode;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null as DLLNode;
         null;
         null;
         var _loc2_:DLL = new DLL();
         var _loc3_:int = x._size;
         if(_loc3_ > 0)
         {
            _loc4_ = x.tail;
            _loc5_ = _loc2_.tail = new DLLNode(_loc4_.val,_loc2_);
            _loc4_ = _loc4_.prev;
            _loc7_ = _loc3_ - 1;
            while(_loc7_-- > 0)
            {
               _loc6_ = new DLLNode(_loc4_.val,_loc2_);
               _loc6_.next = _loc5_;
               _loc5_.prev = _loc6_;
               _loc5_ = _loc6_;
               _loc4_ = _loc4_.prev;
            }
            _loc2_.head = _loc5_;
            _loc2_._size = _loc3_;
            if(_size > 0)
            {
               _loc6_ = tail;
               _loc8_ = _size;
               while(_loc8_-- > 0)
               {
                  _loc9_ = new DLLNode(_loc6_.val,_loc2_);
                  _loc9_.next = _loc5_;
                  _loc5_.prev = _loc9_;
                  _loc5_ = _loc9_;
                  _loc6_ = _loc6_.prev;
               }
               _loc2_.head = _loc5_;
               _loc2_._size += _size;
            }
         }
         else if(_size > 0)
         {
            _loc4_ = tail;
            _loc5_ = _loc2_.tail = new DLLNode(_loc4_.val,this);
            _loc4_ = _loc4_.prev;
            _loc7_ = _size - 1;
            while(_loc7_-- > 0)
            {
               _loc6_ = new DLLNode(_loc4_.val,this);
               _loc6_.next = _loc5_;
               _loc5_.prev = _loc6_;
               _loc5_ = _loc6_;
               _loc4_ = _loc4_.prev;
            }
            _loc2_.head = _loc5_;
            _loc2_._size = _size;
         }
         return _loc2_;
      }
      
      public function close() : void
      {
         if(_circular)
         {
            return;
         }
         _circular = true;
         if(head != null)
         {
            tail.next = head;
            head.prev = tail;
         }
      }
      
      public function clone(assign:Boolean, _tmp_copier:Object = undefined) : Collection
      {
         var _loc5_:* = null as DLLNode;
         var _loc6_:* = null as DLLNode;
         var _loc7_:* = null as DLLNode;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = null as DLLNode;
         var _loc12_:* = null as DLLNode;
         var _loc13_:* = null as Cloneable;
         var _loc3_:* = _tmp_copier;
         if(_size == 0)
         {
            return new DLL(_reservedSize,maxSize);
         }
         var _loc4_:DLL = new DLL();
         _loc4_._size = _size;
         if(assign)
         {
            _loc5_ = head;
            _loc6_ = _loc4_.head = new DLLNode(head.val,_loc4_);
            if(_size == 1)
            {
               _loc4_.tail = _loc4_.head;
               return _loc4_;
            }
            _loc5_ = _loc5_.next;
            _loc8_ = 1;
            _loc9_ = _size - 1;
            while(_loc8_ < _loc9_)
            {
               _loc10_ = _loc8_++;
               _loc7_ = _loc6_;
               _loc11_ = _loc5_;
               _loc6_ = _loc6_.next = new DLLNode(_loc5_.val,_loc4_);
               _loc6_.prev = _loc7_;
               _loc11_ = _loc5_;
               _loc5_ = _loc11_.next;
            }
            _loc7_ = _loc6_;
            _loc4_.tail = _loc6_.next = new DLLNode(_loc5_.val,_loc4_);
            _loc4_.tail.prev = _loc7_;
         }
         else if(_loc3_ == null)
         {
            _loc5_ = head;
            null;
            _loc13_ = head.val;
            _loc6_ = _loc4_.head = new DLLNode(_loc13_.clone(),_loc4_);
            if(_size == 1)
            {
               _loc4_.tail = _loc4_.head;
               return _loc4_;
            }
            _loc5_ = _loc5_.next;
            _loc8_ = 1;
            _loc9_ = _size - 1;
            while(_loc8_ < _loc9_)
            {
               _loc10_ = _loc8_++;
               _loc7_ = _loc6_;
               _loc11_ = _loc5_;
               null;
               _loc13_ = _loc5_.val;
               _loc6_ = _loc6_.next = new DLLNode(_loc13_.clone(),_loc4_);
               _loc6_.prev = _loc7_;
               _loc11_ = _loc5_;
               _loc5_ = _loc11_.next;
            }
            null;
            _loc13_ = _loc5_.val;
            _loc7_ = _loc6_;
            _loc4_.tail = _loc6_.next = new DLLNode(_loc13_.clone(),_loc4_);
            _loc4_.tail.prev = _loc7_;
         }
         else
         {
            _loc5_ = head;
            _loc6_ = _loc4_.head = new DLLNode(_loc3_(head.val),_loc4_);
            if(_size == 1)
            {
               _loc4_.tail = _loc4_.head;
               return _loc4_;
            }
            _loc5_ = _loc5_.next;
            _loc8_ = 1;
            _loc9_ = _size - 1;
            while(_loc8_ < _loc9_)
            {
               _loc10_ = _loc8_++;
               _loc7_ = _loc6_;
               _loc11_ = _loc5_;
               _loc6_ = _loc6_.next = new DLLNode(_loc3_(_loc5_.val),_loc4_);
               _loc6_.prev = _loc7_;
               _loc11_ = _loc5_;
               _loc5_ = _loc11_.next;
            }
            _loc7_ = _loc6_;
            _loc4_.tail = _loc6_.next = new DLLNode(_loc3_(_loc5_.val),_loc4_);
            _loc4_.tail.prev = _loc7_;
         }
         return _loc4_;
      }
      
      public function clear(purge:Boolean = false) : void
      {
         var _loc2_:* = null as Object;
         var _loc3_:* = null as DLLNode;
         var _loc4_:* = null as DLLNode;
         var _loc5_:* = null as Object;
         var _loc6_:* = null as DLLNode;
         var _loc7_:* = null as Object;
         if(purge || _reservedSize > 0)
         {
            _loc2_ = null;
            _loc3_ = head;
            while(_loc3_ != null)
            {
               _loc4_ = _loc3_.next;
               _loc3_.prev = null;
               _loc3_.next = null;
               _loc5_ = _loc3_.val;
               if(_reservedSize > 0 && _poolSize < _reservedSize)
               {
                  _tailPool = _tailPool.next = _loc3_;
                  _loc7_ = null;
                  _loc3_.val = _loc7_;
                  null;
                  null;
                  _poolSize = _poolSize + 1;
               }
               else
               {
                  _loc3_._list = null;
               }
               _loc5_;
               _loc3_ = _loc4_;
            }
         }
         head = tail = null;
         _size = 0;
      }
      
      public function assign(C:Class, args:Array = undefined, n:int = 0) : void
      {
         var _loc6_:int = 0;
         null;
         if(n <= 0)
         {
            n = _size;
         }
         var _loc4_:DLLNode = head;
         var _loc5_:int = 0;
         while(_loc5_ < n)
         {
            _loc6_ = _loc5_++;
            _loc4_.val = Instance.create(C,args);
            _loc4_ = _loc4_.next;
         }
      }
      
      public function append(x:Object) : DLLNode
      {
         var _loc3_:* = null as DLLNode;
         var _loc2_:DLLNode = _reservedSize == 0 || _poolSize == 0 ? new DLLNode(x,this) : (_loc3_ = _headPool, null, null, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc3_.next = null, _loc3_.val = x, _loc3_);
         if(tail != null)
         {
            tail.next = _loc2_;
            _loc2_.prev = tail;
         }
         else
         {
            head = _loc2_;
         }
         tail = _loc2_;
         if(_circular)
         {
            tail.next = head;
            head.prev = tail;
         }
         _size = _size + 1;
         return _loc2_;
      }
      
      public function _valid(node:DLLNode) : Boolean
      {
         return node != null;
      }
      
      public function _putNode(node:DLLNode) : Object
      {
         var _loc3_:* = null as DLLNode;
         var _loc4_:* = null as Object;
         var _loc2_:Object = node.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = node;
            _loc4_ = null;
            node.val = _loc4_;
            null;
            null;
            _poolSize = _poolSize + 1;
         }
         else
         {
            node._list = null;
         }
         return _loc2_;
      }
      
      public function _mergeSortComparable(node:DLLNode) : DLLNode
      {
         var _loc3_:* = null as DLLNode;
         var _loc4_:* = null as DLLNode;
         var _loc5_:* = null as DLLNode;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc2_:DLLNode = node;
         var _loc6_:DLLNode = null;
         var _loc7_:int = 1;
         while(true)
         {
            _loc3_ = _loc2_;
            _loc2_ = _loc6_ = null;
            _loc8_ = 0;
            while(_loc3_ != null)
            {
               _loc8_++;
               _loc9_ = 0;
               _loc4_ = _loc3_;
               _loc12_ = 0;
               while(_loc12_ < _loc7_)
               {
                  _loc13_ = _loc12_++;
                  _loc9_++;
                  _loc4_ = _loc4_.next;
                  if(_loc4_ == null)
                  {
                     break;
                  }
               }
               _loc10_ = _loc7_;
               while(_loc9_ > 0 || _loc10_ > 0 && _loc4_ != null)
               {
                  if(_loc9_ == 0)
                  {
                     _loc5_ = _loc4_;
                     _loc4_ = _loc4_.next;
                     _loc10_--;
                  }
                  else if(_loc10_ == 0 || _loc4_ == null)
                  {
                     _loc5_ = _loc3_;
                     _loc3_ = _loc3_.next;
                     _loc9_--;
                  }
                  else
                  {
                     null;
                     if(int(_loc3_.val.compare(_loc4_.val)) >= 0)
                     {
                        _loc5_ = _loc3_;
                        _loc3_ = _loc3_.next;
                        _loc9_--;
                     }
                     else
                     {
                        _loc5_ = _loc4_;
                        _loc4_ = _loc4_.next;
                        _loc10_--;
                     }
                  }
                  if(_loc6_ != null)
                  {
                     _loc6_.next = _loc5_;
                  }
                  else
                  {
                     _loc2_ = _loc5_;
                  }
                  _loc5_.prev = _loc6_;
                  _loc6_ = _loc5_;
               }
               _loc3_ = _loc4_;
            }
            node.prev = _loc6_;
            _loc6_.next = null;
            if(_loc8_ <= 1)
            {
               break;
            }
            _loc7_ <<= 1;
         }
         _loc2_.prev = null;
         tail = _loc6_;
         return _loc2_;
      }
      
      public function _mergeSort(node:DLLNode, cmp:Function) : DLLNode
      {
         var _loc4_:* = null as DLLNode;
         var _loc5_:* = null as DLLNode;
         var _loc6_:* = null as DLLNode;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc3_:DLLNode = node;
         var _loc7_:DLLNode = null;
         var _loc8_:int = 1;
         while(true)
         {
            _loc4_ = _loc3_;
            _loc3_ = _loc7_ = null;
            _loc9_ = 0;
            while(_loc4_ != null)
            {
               _loc9_++;
               _loc10_ = 0;
               _loc5_ = _loc4_;
               _loc13_ = 0;
               while(_loc13_ < _loc8_)
               {
                  _loc14_ = _loc13_++;
                  _loc10_++;
                  _loc5_ = _loc5_.next;
                  if(_loc5_ == null)
                  {
                     break;
                  }
               }
               _loc11_ = _loc8_;
               while(_loc10_ > 0 || _loc11_ > 0 && _loc5_ != null)
               {
                  if(_loc10_ == 0)
                  {
                     _loc6_ = _loc5_;
                     _loc5_ = _loc5_.next;
                     _loc11_--;
                  }
                  else if(_loc11_ == 0 || _loc5_ == null)
                  {
                     _loc6_ = _loc4_;
                     _loc4_ = _loc4_.next;
                     _loc10_--;
                  }
                  else if(int(cmp(_loc5_.val,_loc4_.val)) >= 0)
                  {
                     _loc6_ = _loc4_;
                     _loc4_ = _loc4_.next;
                     _loc10_--;
                  }
                  else
                  {
                     _loc6_ = _loc5_;
                     _loc5_ = _loc5_.next;
                     _loc11_--;
                  }
                  if(_loc7_ != null)
                  {
                     _loc7_.next = _loc6_;
                  }
                  else
                  {
                     _loc3_ = _loc6_;
                  }
                  _loc6_.prev = _loc7_;
                  _loc7_ = _loc6_;
               }
               _loc4_ = _loc5_;
            }
            node.prev = _loc7_;
            _loc7_.next = null;
            if(_loc9_ <= 1)
            {
               break;
            }
            _loc8_ <<= 1;
         }
         _loc3_.prev = null;
         tail = _loc7_;
         return _loc3_;
      }
      
      public function _insertionSortComparable(node:DLLNode) : DLLNode
      {
         var _loc4_:* = null as DLLNode;
         var _loc5_:* = null as DLLNode;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as DLLNode;
         var _loc2_:DLLNode = node;
         var _loc3_:DLLNode = _loc2_.next;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.next;
            _loc5_ = _loc3_.prev;
            _loc6_ = _loc3_.val;
            null;
            if(int(_loc5_.val.compare(_loc6_)) < 0)
            {
               _loc7_ = _loc5_;
               while(_loc7_.prev != null)
               {
                  null;
                  if(int(_loc7_.prev.val.compare(_loc6_)) >= 0)
                  {
                     break;
                  }
                  _loc7_ = _loc7_.prev;
               }
               if(_loc4_ != null)
               {
                  _loc5_.next = _loc4_;
                  _loc4_.prev = _loc5_;
               }
               else
               {
                  _loc5_.next = null;
                  tail = _loc5_;
               }
               if(_loc7_ == _loc2_)
               {
                  _loc3_.prev = null;
                  _loc3_.next = _loc7_;
                  _loc7_.prev = _loc3_;
                  _loc2_ = _loc3_;
               }
               else
               {
                  _loc3_.prev = _loc7_.prev;
                  _loc7_.prev.next = _loc3_;
                  _loc3_.next = _loc7_;
                  _loc7_.prev = _loc3_;
               }
            }
            _loc3_ = _loc4_;
         }
         return _loc2_;
      }
      
      public function _insertionSort(node:DLLNode, cmp:Function) : DLLNode
      {
         var _loc5_:* = null as DLLNode;
         var _loc6_:* = null as DLLNode;
         var _loc7_:* = null as Object;
         var _loc8_:* = null as DLLNode;
         var _loc3_:DLLNode = node;
         var _loc4_:DLLNode = _loc3_.next;
         while(_loc4_ != null)
         {
            _loc5_ = _loc4_.next;
            _loc6_ = _loc4_.prev;
            _loc7_ = _loc4_.val;
            if(int(cmp(_loc7_,_loc6_.val)) < 0)
            {
               _loc8_ = _loc6_;
               while(_loc8_.prev != null)
               {
                  if(int(cmp(_loc7_,_loc8_.prev.val)) >= 0)
                  {
                     break;
                  }
                  _loc8_ = _loc8_.prev;
               }
               if(_loc5_ != null)
               {
                  _loc6_.next = _loc5_;
                  _loc5_.prev = _loc6_;
               }
               else
               {
                  _loc6_.next = null;
                  tail = _loc6_;
               }
               if(_loc8_ == _loc3_)
               {
                  _loc4_.prev = null;
                  _loc4_.next = _loc8_;
                  _loc8_.prev = _loc4_;
                  _loc3_ = _loc4_;
               }
               else
               {
                  _loc4_.prev = _loc8_.prev;
                  _loc8_.prev.next = _loc4_;
                  _loc4_.next = _loc8_;
                  _loc8_.prev = _loc4_;
               }
            }
            _loc4_ = _loc5_;
         }
         return _loc3_;
      }
      
      public function _getNode(x:Object) : DLLNode
      {
         var _loc2_:* = null as DLLNode;
         if(_reservedSize == 0 || _poolSize == 0)
         {
            return new DLLNode(x,this);
         }
         _loc2_ = _headPool;
         null;
         null;
         _headPool = _headPool.next;
         _poolSize = _poolSize - 1;
         _loc2_.next = null;
         _loc2_.val = x;
         return _loc2_;
      }
      
      public function __unlink(f:Object) : void
      {
         f._unlink();
      }
      
      public function __list(f:Object, x:DLL) : void
      {
         f._list = x;
      }
      
      public function __insertBefore(f:Object, x:DLLNode) : void
      {
         f._insertBefore(x);
      }
      
      public function __insertAfter(f:Object, x:DLLNode) : void
      {
         f._insertAfter(x);
      }
   }
}
