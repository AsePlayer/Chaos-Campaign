package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class SLL implements Collection
   {
       
      
      public var tail:SLLNode;
      
      public var maxSize:int;
      
      public var key:int;
      
      public var head:SLLNode;
      
      public var _tailPool:SLLNode;
      
      public var _size:int;
      
      public var _reservedSize:int;
      
      public var _poolSize:int;
      
      public var _headPool:SLLNode;
      
      public function SLL(reservedSize:int = 0, maxSize:int = -1)
      {
         var _loc3_:* = null as Object;
         var _loc4_:* = null as SLLNode;
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
            _headPool = _tailPool = new SLLNode(_loc3_,this);
         }
         head = tail = null;
         var _loc5_:int;
         HashKey._counter = (_loc5_ = HashKey._counter) + 1;
         key = _loc5_;
      }
      
      public function unlink(node:SLLNode) : SLLNode
      {
         var _loc3_:* = null as SLLNode;
         var _loc4_:* = null as SLLNode;
         var _loc5_:* = null as Object;
         var _loc6_:* = null as Object;
         null;
         null;
         null;
         var _loc2_:SLLNode = node.next;
         if(node == head)
         {
            null;
            _loc3_ = head;
            if(_size > 1)
            {
               head = head.next;
               if(head == null)
               {
                  tail = null;
               }
               _size = _size - 1;
            }
            else
            {
               head = tail = null;
               _size = 0;
            }
            _loc3_.next = null;
            _loc5_ = _loc3_.val;
            if(_reservedSize > 0 && _poolSize < _reservedSize)
            {
               null;
               _tailPool = _tailPool.next = _loc3_;
               _loc6_ = null;
               _loc3_.val = _loc6_;
               _loc3_.next = null;
               _poolSize = _poolSize + 1;
            }
            else
            {
               _loc3_._list = null;
            }
            _loc5_;
         }
         else
         {
            _loc4_ = head;
            while(_loc4_.next != node)
            {
               _loc4_ = _loc4_.next;
            }
            _loc3_ = _loc4_;
            if(_loc3_.next == tail)
            {
               tail = _loc3_;
            }
            _loc3_.next = node.next;
            _loc5_ = node.val;
            if(_reservedSize > 0 && _poolSize < _reservedSize)
            {
               null;
               _tailPool = _tailPool.next = node;
               _loc6_ = null;
               node.val = _loc6_;
               node.next = null;
               _poolSize = _poolSize + 1;
            }
            else
            {
               node._list = null;
            }
            _loc5_;
            _size = _size - 1;
         }
         return _loc2_;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{SLL, size: %d}",[_size]);
      }
      
      public function toDA() : DA
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:SLLNode = head;
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
         var _loc3_:SLLNode = head;
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
            if(compare == null)
            {
               head = !!useInsertionSort ? _insertionSortComparable(head) : _mergeSortComparable(head);
            }
            else
            {
               head = !!useInsertionSort ? _insertionSort(head,compare) : _mergeSort(head,compare);
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
         var _loc5_:* = null as SLLNode;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Object;
         var _loc9_:* = null as SLLNode;
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
      }
      
      public function shiftUp() : void
      {
         var _loc1_:* = null as SLLNode;
         null;
         if(_size > 1)
         {
            _loc1_ = head;
            if(head.next == tail)
            {
               head = tail;
               tail = _loc1_;
               tail.next = null;
               head.next = tail;
            }
            else
            {
               head = head.next;
               tail.next = _loc1_;
               _loc1_.next = null;
               tail = _loc1_;
            }
         }
      }
      
      public function reverse() : void
      {
         var _loc1_:* = null as Array;
         var _loc2_:int = 0;
         var _loc3_:* = null as SLLNode;
         var _loc4_:* = null as SLLNode;
         if(_size > 1)
         {
            _loc1_ = [];
            _loc2_ = 0;
            _loc3_ = head;
            while(_loc3_ != null)
            {
               _loc1_[_loc2_++] = _loc3_.val;
               _loc3_ = _loc3_.next;
            }
            _loc1_.reverse();
            _loc2_ = 0;
            _loc4_ = head;
            while(_loc4_ != null)
            {
               _loc4_.val = _loc1_[_loc2_++];
               _loc4_ = _loc4_.next;
            }
         }
      }
      
      public function removeTail() : Object
      {
         var _loc2_:* = null as SLLNode;
         var _loc3_:* = null as SLLNode;
         var _loc5_:* = null as Object;
         null;
         var _loc1_:SLLNode = tail;
         if(_size > 1)
         {
            _loc3_ = head;
            while(_loc3_.next != tail)
            {
               _loc3_ = _loc3_.next;
            }
            _loc2_ = _loc3_;
            tail = _loc2_;
            _loc2_.next = null;
            _size = _size - 1;
         }
         else
         {
            head = tail = null;
            _size = 0;
         }
         var _loc4_:Object = _loc1_.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            null;
            _tailPool = _tailPool.next = _loc1_;
            _loc5_ = null;
            _loc1_.val = _loc5_;
            _loc1_.next = null;
            _poolSize = _poolSize + 1;
         }
         else
         {
            _loc1_._list = null;
         }
         return _loc4_;
      }
      
      public function removeHead() : Object
      {
         var _loc2_:* = null as SLLNode;
         var _loc4_:* = null as Object;
         null;
         var _loc1_:SLLNode = head;
         if(_size > 1)
         {
            head = head.next;
            if(head == null)
            {
               tail = null;
            }
            _size = _size - 1;
         }
         else
         {
            head = tail = null;
            _size = 0;
         }
         _loc1_.next = null;
         var _loc3_:Object = _loc1_.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            null;
            _tailPool = _tailPool.next = _loc1_;
            _loc4_ = null;
            _loc1_.val = _loc4_;
            _loc1_.next = null;
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
         var _loc7_:* = null as SLLNode;
         var _loc8_:* = null as Object;
         var _loc9_:* = null as SLLNode;
         var _loc10_:* = null as Object;
         var _loc11_:* = null as SLLNode;
         var _loc2_:Object = _tmp_x;
         var _loc3_:int = _size;
         if(_loc3_ == 0)
         {
            return false;
         }
         var _loc4_:SLLNode = head;
         var _loc5_:SLLNode = head.next;
         var _loc6_:Object = null;
         while(_loc5_ != null)
         {
            if(_loc5_.val == _loc2_)
            {
               if(_loc5_ == tail)
               {
                  tail = _loc4_;
               }
               _loc7_ = _loc5_.next;
               _loc4_.next = _loc7_;
               _loc8_ = _loc5_.val;
               if(_reservedSize > 0 && _poolSize < _reservedSize)
               {
                  null;
                  _tailPool = _tailPool.next = _loc5_;
                  _loc10_ = null;
                  _loc5_.val = _loc10_;
                  _loc5_.next = null;
                  _poolSize = _poolSize + 1;
               }
               else
               {
                  _loc5_._list = null;
               }
               _loc8_;
               _loc5_ = _loc7_;
               _size = _size - 1;
            }
            else
            {
               _loc4_ = _loc5_;
               _loc5_ = _loc5_.next;
            }
         }
         if(head.val == _loc2_)
         {
            _loc7_ = head.next;
            _loc9_ = head;
            _loc8_ = _loc9_.val;
            if(_reservedSize > 0 && _poolSize < _reservedSize)
            {
               null;
               _tailPool = _tailPool.next = _loc9_;
               _loc10_ = null;
               _loc9_.val = _loc10_;
               _loc9_.next = null;
               _poolSize = _poolSize + 1;
            }
            else
            {
               _loc9_._list = null;
            }
            _loc8_;
            head = _loc7_;
            if(head == null)
            {
               tail = null;
            }
            _size = _size - 1;
         }
         return _size < _loc3_;
      }
      
      public function prepend(x:Object) : SLLNode
      {
         var _loc3_:* = null as SLLNode;
         var _loc2_:SLLNode = _reservedSize == 0 || _poolSize == 0 ? new SLLNode(x,this) : (null, _loc3_ = _headPool, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc3_.val = x, _loc3_.next = null, _loc3_);
         if(tail != null)
         {
            _loc2_.next = head;
            head = _loc2_;
         }
         else
         {
            head = tail = _loc2_;
         }
         _size = _size + 1;
         return _loc2_;
      }
      
      public function popDown() : void
      {
         var _loc1_:* = null as SLLNode;
         var _loc2_:* = null as SLLNode;
         null;
         if(_size > 1)
         {
            _loc1_ = tail;
            if(head.next == tail)
            {
               tail = head;
               head = _loc1_;
               tail.next = null;
               head.next = tail;
            }
            else
            {
               _loc2_ = head;
               while(_loc2_.next != tail)
               {
                  _loc2_ = _loc2_.next;
               }
               tail = _loc2_;
               tail.next = null;
               _loc1_.next = head;
               head = _loc1_;
            }
         }
      }
      
      public function nodeOf(x:Object, from:SLLNode = undefined) : SLLNode
      {
         var _loc3_:SLLNode = from;
         while(_loc3_ != null)
         {
            if(_loc3_.val == x)
            {
               break;
            }
            _loc3_ = _loc3_.next;
         }
         return _loc3_;
      }
      
      public function merge(x:SLL) : void
      {
         var _loc2_:* = null as SLLNode;
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
               tail = x.tail;
            }
            else
            {
               head = x.head;
               tail = x.tail;
            }
            _size += x._size;
         }
      }
      
      public function join(x:String) : String
      {
         var _loc3_:* = null as SLLNode;
         var _loc2_:String = "";
         if(_size > 0)
         {
            _loc3_ = head;
            while(_loc3_.next != null)
            {
               _loc2_ += Std.string(_loc3_.val) + x;
               _loc3_ = _loc3_.next;
            }
            _loc2_ += Std.string(_loc3_.val);
         }
         return _loc2_;
      }
      
      public function iterator() : Itr
      {
         return new SLLIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function insertBefore(node:SLLNode, x:Object) : SLLNode
      {
         var _loc4_:* = null as SLLNode;
         null;
         null;
         var _loc3_:SLLNode = _reservedSize == 0 || _poolSize == 0 ? new SLLNode(x,this) : (null, _loc4_ = _headPool, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc4_.val = x, _loc4_.next = null, _loc4_);
         if(node == head)
         {
            _loc3_.next = head;
            head = _loc3_;
         }
         else
         {
            _loc4_ = head;
            while(_loc4_.next != node)
            {
               _loc4_ = _loc4_.next;
            }
            _loc4_._insertAfter(_loc3_);
         }
         _size = _size + 1;
         return _loc3_;
      }
      
      public function insertAfter(node:SLLNode, x:Object) : SLLNode
      {
         var _loc4_:* = null as SLLNode;
         null;
         null;
         var _loc3_:SLLNode = _reservedSize == 0 || _poolSize == 0 ? new SLLNode(x,this) : (null, _loc4_ = _headPool, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc4_.val = x, _loc4_.next = null, _loc4_);
         node._insertAfter(_loc3_);
         if(node == tail)
         {
            tail = _loc3_;
         }
         _size = _size + 1;
         return _loc3_;
      }
      
      public function getNodeAt(i:int) : SLLNode
      {
         var _loc4_:int = 0;
         null;
         null;
         var _loc2_:SLLNode = head;
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
         var _loc3_:* = null as SLLNode;
         var _loc4_:* = null as SLLNode;
         var _loc1_:Object = null;
         var _loc2_:SLLNode = head;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.next = null;
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
         var _loc4_:SLLNode = head;
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
         var _loc2_:Object = _tmp_x;
         var _loc3_:SLLNode = head;
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
      
      public function concat(x:SLL) : SLL
      {
         var _loc4_:* = null as Object;
         var _loc5_:* = null as SLLNode;
         var _loc6_:* = null as SLLNode;
         null;
         null;
         var _loc2_:SLL = new SLL();
         var _loc3_:SLLNode = head;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.val;
            _loc5_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new SLLNode(_loc4_,_loc2_) : (null, _loc6_ = _loc2_._headPool, _loc2_._headPool = _loc2_._headPool.next, _loc2_._poolSize = _loc2_._poolSize - 1, _loc6_.val = _loc4_, _loc6_.next = null, _loc6_);
            if(_loc2_.tail != null)
            {
               _loc2_.tail.next = _loc5_;
            }
            else
            {
               _loc2_.head = _loc5_;
            }
            _loc2_.tail = _loc5_;
            _loc2_._size = _loc2_._size + 1;
            _loc5_;
            _loc3_ = _loc3_.next;
         }
         _loc3_ = x.head;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.val;
            _loc5_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new SLLNode(_loc4_,_loc2_) : (null, _loc6_ = _loc2_._headPool, _loc2_._headPool = _loc2_._headPool.next, _loc2_._poolSize = _loc2_._poolSize - 1, _loc6_.val = _loc4_, _loc6_.next = null, _loc6_);
            if(_loc2_.tail != null)
            {
               _loc2_.tail.next = _loc5_;
            }
            else
            {
               _loc2_.head = _loc5_;
            }
            _loc2_.tail = _loc5_;
            _loc2_._size = _loc2_._size + 1;
            _loc5_;
            _loc3_ = _loc3_.next;
         }
         return _loc2_;
      }
      
      public function clone(assign:Boolean, _tmp_copier:Object = undefined) : Collection
      {
         var _loc5_:* = null as SLLNode;
         var _loc6_:* = null as SLLNode;
         var _loc7_:* = null as SLLNode;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = null as Cloneable;
         var _loc3_:* = _tmp_copier;
         if(_size == 0)
         {
            return new SLL(_reservedSize,maxSize);
         }
         var _loc4_:SLL = new SLL();
         _loc4_._size = _size;
         if(assign)
         {
            _loc5_ = head;
            _loc6_ = _loc4_.head = new SLLNode(head.val,_loc4_);
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
               _loc6_ = _loc6_.next = new SLLNode(_loc5_.val,_loc4_);
               _loc5_ = _loc5_.next;
            }
            _loc4_.tail = _loc6_.next = new SLLNode(_loc5_.val,_loc4_);
         }
         else if(_loc3_ == null)
         {
            _loc5_ = head;
            null;
            _loc11_ = head.val;
            _loc6_ = _loc4_.head = new SLLNode(_loc11_.clone(),_loc4_);
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
               null;
               _loc11_ = _loc5_.val;
               _loc6_ = _loc6_.next = new SLLNode(_loc11_.clone(),_loc4_);
               _loc5_ = _loc5_.next;
            }
            null;
            _loc11_ = _loc5_.val;
            _loc4_.tail = _loc6_.next = new SLLNode(_loc11_.clone(),_loc4_);
         }
         else
         {
            _loc5_ = head;
            _loc6_ = _loc4_.head = new SLLNode(_loc3_(head.val),_loc4_);
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
               _loc6_ = _loc6_.next = new SLLNode(_loc3_(_loc5_.val),_loc4_);
               _loc5_ = _loc5_.next;
            }
            _loc4_.tail = _loc6_.next = new SLLNode(_loc3_(_loc5_.val),_loc4_);
         }
         return _loc4_;
      }
      
      public function clear(purge:Boolean = false) : void
      {
         var _loc2_:* = null as Object;
         var _loc3_:* = null as SLLNode;
         var _loc4_:* = null as SLLNode;
         var _loc5_:* = null as Object;
         var _loc6_:* = null as SLLNode;
         var _loc7_:* = null as Object;
         if(purge || _reservedSize > 0)
         {
            _loc2_ = null;
            _loc3_ = head;
            while(_loc3_ != null)
            {
               _loc4_ = _loc3_.next;
               _loc3_.next = null;
               _loc5_ = _loc3_.val;
               if(_reservedSize > 0 && _poolSize < _reservedSize)
               {
                  null;
                  _tailPool = _tailPool.next = _loc3_;
                  _loc7_ = null;
                  _loc3_.val = _loc7_;
                  _loc3_.next = null;
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
         var _loc4_:SLLNode = head;
         var _loc5_:int = 0;
         while(_loc5_ < n)
         {
            _loc6_ = _loc5_++;
            _loc4_.val = Instance.create(C,args);
            _loc4_ = _loc4_.next;
         }
      }
      
      public function append(x:Object) : SLLNode
      {
         var _loc3_:* = null as SLLNode;
         var _loc2_:SLLNode = _reservedSize == 0 || _poolSize == 0 ? new SLLNode(x,this) : (null, _loc3_ = _headPool, _headPool = _headPool.next, _poolSize = _poolSize - 1, _loc3_.val = x, _loc3_.next = null, _loc3_);
         if(tail != null)
         {
            tail.next = _loc2_;
         }
         else
         {
            head = _loc2_;
         }
         tail = _loc2_;
         _size = _size + 1;
         return _loc2_;
      }
      
      public function _valid(node:SLLNode) : Boolean
      {
         return node != null;
      }
      
      public function _putNode(node:SLLNode) : Object
      {
         var _loc3_:* = null as SLLNode;
         var _loc4_:* = null as Object;
         var _loc2_:Object = node.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            null;
            _tailPool = _tailPool.next = node;
            _loc4_ = null;
            node.val = _loc4_;
            node.next = null;
            _poolSize = _poolSize + 1;
         }
         else
         {
            node._list = null;
         }
         return _loc2_;
      }
      
      public function _mergeSortComparable(node:SLLNode) : SLLNode
      {
         var _loc3_:* = null as SLLNode;
         var _loc4_:* = null as SLLNode;
         var _loc5_:* = null as SLLNode;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc2_:SLLNode = node;
         var _loc6_:SLLNode = null;
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
                  _loc6_ = _loc5_;
               }
               _loc3_ = _loc4_;
            }
            _loc6_.next = null;
            if(_loc8_ <= 1)
            {
               break;
            }
            _loc7_ <<= 1;
         }
         tail = _loc6_;
         return _loc2_;
      }
      
      public function _mergeSort(node:SLLNode, cmp:Function) : SLLNode
      {
         var _loc4_:* = null as SLLNode;
         var _loc5_:* = null as SLLNode;
         var _loc6_:* = null as SLLNode;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc3_:SLLNode = node;
         var _loc7_:SLLNode = null;
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
                  _loc7_ = _loc6_;
               }
               _loc4_ = _loc5_;
            }
            _loc7_.next = null;
            if(_loc9_ <= 1)
            {
               break;
            }
            _loc8_ <<= 1;
         }
         tail = _loc7_;
         return _loc3_;
      }
      
      public function _insertionSortComparable(node:SLLNode) : SLLNode
      {
         var _loc6_:int = 0;
         var _loc7_:* = null as Object;
         var _loc10_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:SLLNode = node;
         while(_loc4_ != null)
         {
            _loc2_[_loc3_++] = _loc4_.val;
            _loc4_ = _loc4_.next;
         }
         var _loc5_:SLLNode = node;
         var _loc8_:int = 1;
         var _loc9_:int = _size;
         while(_loc8_ < _loc9_)
         {
            _loc10_ = _loc8_++;
            _loc7_ = _loc2_[_loc10_];
            _loc6_ = _loc10_;
            null;
            while(_loc6_ > 0 && int(_loc2_[_loc6_ - 1].compare(_loc7_)) < 0)
            {
               _loc2_[_loc6_] = _loc2_[_loc6_ - 1];
               _loc6_--;
            }
            _loc2_[_loc6_] = _loc7_;
         }
         _loc4_ = _loc5_;
         _loc3_ = 0;
         while(_loc4_ != null)
         {
            _loc4_.val = _loc2_[_loc3_++];
            _loc4_ = _loc4_.next;
         }
         return _loc5_;
      }
      
      public function _insertionSort(node:SLLNode, cmp:Function) : SLLNode
      {
         var _loc7_:int = 0;
         var _loc8_:* = null as Object;
         var _loc11_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:SLLNode = node;
         while(_loc5_ != null)
         {
            _loc3_[_loc4_++] = _loc5_.val;
            _loc5_ = _loc5_.next;
         }
         var _loc6_:SLLNode = node;
         var _loc9_:int = 1;
         var _loc10_:int = _size;
         while(_loc9_ < _loc10_)
         {
            _loc11_ = _loc9_++;
            _loc8_ = _loc3_[_loc11_];
            _loc7_ = _loc11_;
            while(_loc7_ > 0 && int(cmp(_loc8_,_loc3_[_loc7_ - 1])) < 0)
            {
               _loc3_[_loc7_] = _loc3_[_loc7_ - 1];
               _loc7_--;
            }
            _loc3_[_loc7_] = _loc8_;
         }
         _loc5_ = _loc6_;
         _loc4_ = 0;
         while(_loc5_ != null)
         {
            _loc5_.val = _loc3_[_loc4_++];
            _loc5_ = _loc5_.next;
         }
         return _loc6_;
      }
      
      public function _getNodeBefore(x:SLLNode) : SLLNode
      {
         var _loc2_:SLLNode = head;
         while(_loc2_.next != x)
         {
            _loc2_ = _loc2_.next;
         }
         return _loc2_;
      }
      
      public function _getNode(x:Object) : SLLNode
      {
         var _loc2_:* = null as SLLNode;
         if(_reservedSize == 0 || _poolSize == 0)
         {
            return new SLLNode(x,this);
         }
         null;
         _loc2_ = _headPool;
         _headPool = _headPool.next;
         _poolSize = _poolSize - 1;
         _loc2_.val = x;
         _loc2_.next = null;
         return _loc2_;
      }
      
      public function __list(f:Object, x:SLL) : void
      {
         f._list = x;
      }
      
      public function __insertAfter(f:Object, x:SLLNode) : void
      {
         f._insertAfter(x);
      }
   }
}
