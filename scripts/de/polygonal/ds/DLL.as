package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class DLL implements Collection
   {
       
      
      public var tail:de.polygonal.ds.DLLNode;
      
      public var maxSize:int;
      
      public var key:int;
      
      public var head:de.polygonal.ds.DLLNode;
      
      public var _tailPool:de.polygonal.ds.DLLNode;
      
      public var _size:int;
      
      public var _reservedSize:int;
      
      public var _poolSize:int;
      
      public var _headPool:de.polygonal.ds.DLLNode;
      
      public var _circular:Boolean;
      
      public function DLL(param1:int = 0, param2:int = -1)
      {
         var _loc3_:* = null as Object;
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         if(Boot.skip_constructor)
         {
            return;
         }
         maxSize = -1;
         _reservedSize = param1;
         _circular = false;
         _size = 0;
         _poolSize = 0;
         if(param1 > 0)
         {
            _loc3_ = null;
            _headPool = _tailPool = new de.polygonal.ds.DLLNode(_loc3_,this);
         }
         head = tail = null;
         var _loc5_:int;
         HashKey._counter = (_loc5_ = int(HashKey._counter)) + 1;
         key = _loc5_;
      }
      
      public function unlink(param1:de.polygonal.ds.DLLNode) : de.polygonal.ds.DLLNode
      {
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         var _loc5_:* = null as Object;
         null;
         null;
         null;
         var _loc2_:de.polygonal.ds.DLLNode = param1.next;
         if(param1 == head)
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
         else if(param1 == tail)
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
         param1._unlink();
         var _loc3_:Object = param1.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = param1;
            _loc5_ = null;
            param1.val = _loc5_;
            null;
            null;
            ++_poolSize;
         }
         else
         {
            param1._list = null;
         }
         _loc3_;
         --_size;
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
         var _loc2_:de.polygonal.ds.DLLNode = head;
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
               ++_loc1_._size;
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
         var _loc3_:de.polygonal.ds.DLLNode = head;
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
      
      public function sort(param1:Function, param2:Boolean = false) : void
      {
         if(_size > 1)
         {
            if(_circular)
            {
               tail.next = null;
               head.prev = null;
            }
            if(param1 == null)
            {
               head = param2 ? _insertionSortComparable(head) : _mergeSortComparable(head);
            }
            else
            {
               head = param2 ? _insertionSort(head,param1) : _mergeSort(head,param1);
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
      
      public function shuffle(param1:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as de.polygonal.ds.DLLNode;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Object;
         var _loc9_:* = null as de.polygonal.ds.DLLNode;
         var _loc10_:int = 0;
         var _loc2_:int = _size;
         if(param1 == null)
         {
            _loc3_ = Math;
            while(_loc2_ > 1)
            {
               _loc2_--;
               _loc4_ = int(Number(_loc3_.random()) * _loc2_);
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
               _loc6_ = int(Number(param1._a[_loc4_++]) * _loc2_);
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
         var _loc1_:* = null as de.polygonal.ds.DLLNode;
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
         var _loc2_:* = null as de.polygonal.ds.DLLNode;
         var _loc3_:* = null as de.polygonal.ds.DLLNode;
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
         var _loc2_:* = null as de.polygonal.ds.DLLNode;
         var _loc4_:* = null as Object;
         null;
         var _loc1_:de.polygonal.ds.DLLNode = tail;
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
         --_size;
         var _loc3_:Object = _loc1_.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = _loc1_;
            _loc4_ = null;
            _loc1_.val = _loc4_;
            null;
            null;
            ++_poolSize;
         }
         else
         {
            _loc1_._list = null;
         }
         return _loc3_;
      }
      
      public function removeHead() : Object
      {
         var _loc2_:* = null as de.polygonal.ds.DLLNode;
         var _loc4_:* = null as Object;
         null;
         var _loc1_:de.polygonal.ds.DLLNode = head;
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
         --_size;
         var _loc3_:Object = _loc1_.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = _loc1_;
            _loc4_ = null;
            _loc1_.val = _loc4_;
            null;
            null;
            ++_poolSize;
         }
         else
         {
            _loc1_._list = null;
         }
         return _loc3_;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc2_:Object = param1;
         var _loc3_:int = _size;
         if(_loc3_ == 0)
         {
            return false;
         }
         var _loc4_:de.polygonal.ds.DLLNode = head;
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
      
      public function prepend(param1:Object) : de.polygonal.ds.DLLNode
      {
         var _loc3_:* = null as de.polygonal.ds.DLLNode;
         var _loc2_:de.polygonal.ds.DLLNode = _reservedSize == 0 || _poolSize == 0 ? new de.polygonal.ds.DLLNode(param1,this) : (_loc3_ = _headPool, null, null, _headPool = _headPool.next, --_poolSize, _loc3_.next = null, _loc3_.val = param1, _loc3_);
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
         ++_size;
         return _loc2_;
      }
      
      public function popDown() : void
      {
         var _loc1_:* = null as de.polygonal.ds.DLLNode;
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
      
      public function nodeOf(param1:Object, param2:de.polygonal.ds.DLLNode = undefined) : de.polygonal.ds.DLLNode
      {
         var _loc6_:int = 0;
         if(param2 == null)
         {
            param2 = head;
         }
         var _loc3_:de.polygonal.ds.DLLNode = param2;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_loc3_.val == param1)
            {
               break;
            }
            _loc3_ = _loc3_.next;
         }
         return _loc3_;
      }
      
      public function merge(param1:DLL) : void
      {
         var _loc2_:* = null as de.polygonal.ds.DLLNode;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         null;
         null;
         if(param1.head != null)
         {
            _loc2_ = param1.head;
            _loc3_ = 0;
            _loc4_ = param1._size;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc3_++;
               _loc2_._list = this;
               _loc2_ = _loc2_.next;
            }
            if(head != null)
            {
               tail.next = param1.head;
               param1.head.prev = tail;
               tail = param1.tail;
            }
            else
            {
               head = param1.head;
               tail = param1.tail;
            }
            _size += param1._size;
            if(_circular)
            {
               tail.next = head;
               head.prev = tail;
            }
         }
      }
      
      public function lastNodeOf(param1:Object, param2:de.polygonal.ds.DLLNode = undefined) : de.polygonal.ds.DLLNode
      {
         var _loc6_:int = 0;
         if(param2 == null)
         {
            param2 = tail;
         }
         var _loc3_:de.polygonal.ds.DLLNode = param2;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_loc3_.val == param1)
            {
               break;
            }
            _loc3_ = _loc3_.prev;
         }
         return _loc3_;
      }
      
      public function join(param1:String) : String
      {
         var _loc3_:* = null as de.polygonal.ds.DLLNode;
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
               _loc2_ += Std.string(_loc3_.val) + param1;
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
      
      public function insertBefore(param1:de.polygonal.ds.DLLNode, param2:Object) : de.polygonal.ds.DLLNode
      {
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         null;
         null;
         var _loc3_:de.polygonal.ds.DLLNode = _reservedSize == 0 || _poolSize == 0 ? new de.polygonal.ds.DLLNode(param2,this) : (_loc4_ = _headPool, null, null, _headPool = _headPool.next, --_poolSize, _loc4_.next = null, _loc4_.val = param2, _loc4_);
         param1._insertBefore(_loc3_);
         if(param1 == head)
         {
            head = _loc3_;
            if(_circular)
            {
               head.prev = tail;
            }
         }
         ++_size;
         return _loc3_;
      }
      
      public function insertAfter(param1:de.polygonal.ds.DLLNode, param2:Object) : de.polygonal.ds.DLLNode
      {
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         null;
         null;
         var _loc3_:de.polygonal.ds.DLLNode = _reservedSize == 0 || _poolSize == 0 ? new de.polygonal.ds.DLLNode(param2,this) : (_loc4_ = _headPool, null, null, _headPool = _headPool.next, --_poolSize, _loc4_.next = null, _loc4_.val = param2, _loc4_);
         param1._insertAfter(_loc3_);
         if(param1 == tail)
         {
            tail = _loc3_;
            if(_circular)
            {
               tail.next = head;
            }
         }
         ++_size;
         return _loc3_;
      }
      
      public function getNodeAt(param1:int) : de.polygonal.ds.DLLNode
      {
         var _loc4_:int = 0;
         null;
         null;
         var _loc2_:de.polygonal.ds.DLLNode = head;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc4_ = _loc3_++;
            _loc2_ = _loc2_.next;
         }
         return _loc2_;
      }
      
      public function free() : void
      {
         var _loc3_:* = null as de.polygonal.ds.DLLNode;
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         var _loc1_:Object = null;
         var _loc2_:de.polygonal.ds.DLLNode = head;
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
      
      public function fill(param1:Object, param2:Array = undefined, param3:int = 0) : void
      {
         var _loc6_:int = 0;
         null;
         if(param3 <= 0)
         {
            param3 = _size;
         }
         var _loc4_:de.polygonal.ds.DLLNode = head;
         var _loc5_:int = 0;
         while(_loc5_ < param3)
         {
            _loc6_ = _loc5_++;
            _loc4_.val = param1;
            _loc4_ = _loc4_.next;
         }
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:de.polygonal.ds.DLLNode = head;
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
      
      public function concat(param1:DLL) : DLL
      {
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         var _loc5_:* = null as de.polygonal.ds.DLLNode;
         var _loc6_:* = null as de.polygonal.ds.DLLNode;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null as de.polygonal.ds.DLLNode;
         null;
         null;
         var _loc2_:DLL = new DLL();
         var _loc3_:int = param1._size;
         if(_loc3_ > 0)
         {
            _loc4_ = param1.tail;
            _loc5_ = _loc2_.tail = new de.polygonal.ds.DLLNode(_loc4_.val,_loc2_);
            _loc4_ = _loc4_.prev;
            _loc7_ = _loc3_ - 1;
            while(_loc7_-- > 0)
            {
               _loc6_ = new de.polygonal.ds.DLLNode(_loc4_.val,_loc2_);
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
                  _loc9_ = new de.polygonal.ds.DLLNode(_loc6_.val,_loc2_);
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
            _loc5_ = _loc2_.tail = new de.polygonal.ds.DLLNode(_loc4_.val,this);
            _loc4_ = _loc4_.prev;
            _loc7_ = _size - 1;
            while(_loc7_-- > 0)
            {
               _loc6_ = new de.polygonal.ds.DLLNode(_loc4_.val,this);
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
      
      public function clone(param1:Boolean, param2:Object = undefined) : Collection
      {
         var _loc5_:* = null as de.polygonal.ds.DLLNode;
         var _loc6_:* = null as de.polygonal.ds.DLLNode;
         var _loc7_:* = null as de.polygonal.ds.DLLNode;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = null as de.polygonal.ds.DLLNode;
         var _loc12_:* = null as de.polygonal.ds.DLLNode;
         var _loc13_:* = null as Cloneable;
         var _loc3_:* = param2;
         if(_size == 0)
         {
            return new DLL(_reservedSize,maxSize);
         }
         var _loc4_:DLL = new DLL();
         _loc4_._size = _size;
         if(param1)
         {
            _loc5_ = head;
            _loc6_ = _loc4_.head = new de.polygonal.ds.DLLNode(head.val,_loc4_);
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
               _loc6_ = _loc6_.next = new de.polygonal.ds.DLLNode(_loc5_.val,_loc4_);
               _loc6_.prev = _loc7_;
               _loc11_ = _loc5_;
               _loc5_ = _loc11_.next;
            }
            _loc7_ = _loc6_;
            _loc4_.tail = _loc6_.next = new de.polygonal.ds.DLLNode(_loc5_.val,_loc4_);
            _loc4_.tail.prev = _loc7_;
         }
         else if(_loc3_ == null)
         {
            _loc5_ = head;
            null;
            _loc13_ = head.val;
            _loc6_ = _loc4_.head = new de.polygonal.ds.DLLNode(_loc13_.clone(),_loc4_);
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
               _loc6_ = _loc6_.next = new de.polygonal.ds.DLLNode(_loc13_.clone(),_loc4_);
               _loc6_.prev = _loc7_;
               _loc11_ = _loc5_;
               _loc5_ = _loc11_.next;
            }
            null;
            _loc13_ = _loc5_.val;
            _loc7_ = _loc6_;
            _loc4_.tail = _loc6_.next = new de.polygonal.ds.DLLNode(_loc13_.clone(),_loc4_);
            _loc4_.tail.prev = _loc7_;
         }
         else
         {
            _loc5_ = head;
            _loc6_ = _loc4_.head = new de.polygonal.ds.DLLNode(_loc3_(head.val),_loc4_);
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
               _loc6_ = _loc6_.next = new de.polygonal.ds.DLLNode(_loc3_(_loc5_.val),_loc4_);
               _loc6_.prev = _loc7_;
               _loc11_ = _loc5_;
               _loc5_ = _loc11_.next;
            }
            _loc7_ = _loc6_;
            _loc4_.tail = _loc6_.next = new de.polygonal.ds.DLLNode(_loc3_(_loc5_.val),_loc4_);
            _loc4_.tail.prev = _loc7_;
         }
         return _loc4_;
      }
      
      public function clear(param1:Boolean = false) : void
      {
         var _loc2_:* = null as Object;
         var _loc3_:* = null as de.polygonal.ds.DLLNode;
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         var _loc5_:* = null as Object;
         var _loc6_:* = null as de.polygonal.ds.DLLNode;
         var _loc7_:* = null as Object;
         if(param1 || _reservedSize > 0)
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
                  ++_poolSize;
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
      
      public function assign(param1:Class, param2:Array = undefined, param3:int = 0) : void
      {
         var _loc6_:int = 0;
         null;
         if(param3 <= 0)
         {
            param3 = _size;
         }
         var _loc4_:de.polygonal.ds.DLLNode = head;
         var _loc5_:int = 0;
         while(_loc5_ < param3)
         {
            _loc6_ = _loc5_++;
            _loc4_.val = Instance.create(param1,param2);
            _loc4_ = _loc4_.next;
         }
      }
      
      public function append(param1:Object) : de.polygonal.ds.DLLNode
      {
         var _loc3_:* = null as de.polygonal.ds.DLLNode;
         var _loc2_:de.polygonal.ds.DLLNode = _reservedSize == 0 || _poolSize == 0 ? new de.polygonal.ds.DLLNode(param1,this) : (_loc3_ = _headPool, null, null, _headPool = _headPool.next, --_poolSize, _loc3_.next = null, _loc3_.val = param1, _loc3_);
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
         ++_size;
         return _loc2_;
      }
      
      public function _valid(param1:de.polygonal.ds.DLLNode) : Boolean
      {
         return param1 != null;
      }
      
      public function _putNode(param1:de.polygonal.ds.DLLNode) : Object
      {
         var _loc3_:* = null as de.polygonal.ds.DLLNode;
         var _loc4_:* = null as Object;
         var _loc2_:Object = param1.val;
         if(_reservedSize > 0 && _poolSize < _reservedSize)
         {
            _tailPool = _tailPool.next = param1;
            _loc4_ = null;
            param1.val = _loc4_;
            null;
            null;
            ++_poolSize;
         }
         else
         {
            param1._list = null;
         }
         return _loc2_;
      }
      
      public function _mergeSortComparable(param1:de.polygonal.ds.DLLNode) : de.polygonal.ds.DLLNode
      {
         var _loc3_:* = null as de.polygonal.ds.DLLNode;
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         var _loc5_:* = null as de.polygonal.ds.DLLNode;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc2_:de.polygonal.ds.DLLNode = param1;
         var _loc6_:de.polygonal.ds.DLLNode = null;
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
            param1.prev = _loc6_;
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
      
      public function _mergeSort(param1:de.polygonal.ds.DLLNode, param2:Function) : de.polygonal.ds.DLLNode
      {
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         var _loc5_:* = null as de.polygonal.ds.DLLNode;
         var _loc6_:* = null as de.polygonal.ds.DLLNode;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc3_:de.polygonal.ds.DLLNode = param1;
         var _loc7_:de.polygonal.ds.DLLNode = null;
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
                  else if(param2(_loc5_.val,_loc4_.val) >= 0)
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
            param1.prev = _loc7_;
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
      
      public function _insertionSortComparable(param1:de.polygonal.ds.DLLNode) : de.polygonal.ds.DLLNode
      {
         var _loc4_:* = null as de.polygonal.ds.DLLNode;
         var _loc5_:* = null as de.polygonal.ds.DLLNode;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as de.polygonal.ds.DLLNode;
         var _loc2_:de.polygonal.ds.DLLNode = param1;
         var _loc3_:de.polygonal.ds.DLLNode = _loc2_.next;
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
      
      public function _insertionSort(param1:de.polygonal.ds.DLLNode, param2:Function) : de.polygonal.ds.DLLNode
      {
         var _loc5_:* = null as de.polygonal.ds.DLLNode;
         var _loc6_:* = null as de.polygonal.ds.DLLNode;
         var _loc7_:* = null as Object;
         var _loc8_:* = null as de.polygonal.ds.DLLNode;
         var _loc3_:de.polygonal.ds.DLLNode = param1;
         var _loc4_:de.polygonal.ds.DLLNode = _loc3_.next;
         while(_loc4_ != null)
         {
            _loc5_ = _loc4_.next;
            _loc6_ = _loc4_.prev;
            _loc7_ = _loc4_.val;
            if(param2(_loc7_,_loc6_.val) < 0)
            {
               _loc8_ = _loc6_;
               while(_loc8_.prev != null)
               {
                  if(param2(_loc7_,_loc8_.prev.val) >= 0)
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
      
      public function _getNode(param1:Object) : de.polygonal.ds.DLLNode
      {
         var _loc2_:* = null as de.polygonal.ds.DLLNode;
         if(_reservedSize == 0 || _poolSize == 0)
         {
            return new de.polygonal.ds.DLLNode(param1,this);
         }
         _loc2_ = _headPool;
         null;
         null;
         _headPool = _headPool.next;
         --_poolSize;
         _loc2_.next = null;
         _loc2_.val = param1;
         return _loc2_;
      }
      
      public function __unlink(param1:Object) : void
      {
         param1._unlink();
      }
      
      public function __list(param1:Object, param2:DLL) : void
      {
         param1._list = param2;
      }
      
      public function __insertBefore(param1:Object, param2:de.polygonal.ds.DLLNode) : void
      {
         param1._insertBefore(param2);
      }
      
      public function __insertAfter(param1:Object, param2:de.polygonal.ds.DLLNode) : void
      {
         param1._insertAfter(param2);
      }
   }
}
