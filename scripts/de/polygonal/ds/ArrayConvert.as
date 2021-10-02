package de.polygonal.ds
{
   public class ArrayConvert
   {
       
      
      public function ArrayConvert()
      {
      }
      
      public static function toArray2(x:Array, width:int, height:int) : Array2
      {
         var _loc8_:int = 0;
         null;
         null;
         var _loc4_:Array2 = new Array2(width,height);
         var _loc5_:Array = _loc4_._a;
         var _loc6_:int = 0;
         var _loc7_:int = int(x.length);
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _loc5_[_loc8_] = x[_loc8_];
         }
         return _loc4_;
      }
      
      public static function toArray3(x:Array, width:int, height:int, depth:int) : Array3
      {
         var _loc9_:int = 0;
         null;
         null;
         var _loc5_:Array3 = new Array3(width,height,depth);
         var _loc6_:Array = _loc5_._a;
         var _loc7_:int = 0;
         var _loc8_:int = int(x.length);
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc7_++;
            _loc6_[_loc9_] = x[_loc9_];
         }
         return _loc5_;
      }
      
      public static function toArrayedQueue(x:Array) : ArrayedQueue
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null as Array;
         var _loc7_:* = null as Array;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         null;
         null;
         var _loc2_:int = int(x.length);
         var _loc3_:ArrayedQueue = new ArrayedQueue(_loc2_ > 0 && (_loc2_ & _loc2_ - 1) == 0 ? _loc2_ : (_loc4_ = _loc2_, _loc4_ |= _loc4_ >> 1, _loc4_ |= _loc4_ >> 2, _loc4_ |= _loc4_ >> 3, _loc4_ |= _loc4_ >> 4, _loc4_ |= _loc4_ >> 5, _loc4_ + 1));
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = _loc4_++;
            if(_loc3_._capacity == _loc3_._size)
            {
               if(_loc3_._isResizable)
               {
                  _loc3_._sizeLevel = _loc3_._sizeLevel + 1;
                  null;
                  _loc7_ = new Array(_loc3_._capacity << 1);
                  _loc6_ = _loc7_;
                  _loc8_ = 0;
                  _loc9_ = _loc3_._size;
                  while(_loc8_ < _loc9_)
                  {
                     _loc10_ = _loc8_++;
                     _loc3_._front = (_loc11_ = _loc3_._front) + 1;
                     _loc6_[_loc10_] = _loc3_._a[_loc11_];
                     if(_loc3_._front == _loc3_._capacity)
                     {
                        _loc3_._front = 0;
                     }
                  }
                  _loc3_._a = _loc6_;
                  _loc3_._front = 0;
                  _loc3_._capacity <<= 1;
               }
            }
            _loc3_._size = (_loc8_ = _loc3_._size) + 1;
            _loc3_._a[int((_loc8_ + _loc3_._front) % _loc3_._capacity)] = x[_loc5_];
         }
         return _loc3_;
      }
      
      public static function toArrayedStack(x:Array) : ArrayedStack
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         null;
         null;
         var _loc2_:ArrayedStack = new ArrayedStack(int(x.length));
         var _loc3_:int = 0;
         var _loc4_:int = int(x.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc2_._top = (_loc6_ = _loc2_._top) + 1;
            _loc2_._a[_loc6_] = x[_loc5_];
         }
         return _loc2_;
      }
      
      public static function toSLL(x:Array) : SLL
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as SLLNode;
         var _loc8_:* = null as SLLNode;
         null;
         null;
         var _loc2_:SLL = new SLL();
         var _loc3_:int = 0;
         var _loc4_:int = int(x.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = x[_loc5_];
            _loc7_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new SLLNode(_loc6_,_loc2_) : (null, _loc8_ = _loc2_._headPool, _loc2_._headPool = _loc2_._headPool.next, _loc2_._poolSize = _loc2_._poolSize - 1, _loc8_.val = _loc6_, _loc8_.next = null, _loc8_);
            if(_loc2_.tail != null)
            {
               _loc2_.tail.next = _loc7_;
            }
            else
            {
               _loc2_.head = _loc7_;
            }
            _loc2_.tail = _loc7_;
            _loc2_._size = _loc2_._size + 1;
            _loc7_;
         }
         return _loc2_;
      }
      
      public static function toDLL(x:Array) : DLL
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as DLLNode;
         var _loc8_:* = null as DLLNode;
         null;
         null;
         var _loc2_:DLL = new DLL();
         var _loc3_:int = 0;
         var _loc4_:int = int(x.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = x[_loc5_];
            _loc7_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new DLLNode(_loc6_,_loc2_) : (_loc8_ = _loc2_._headPool, null, null, _loc2_._headPool = _loc2_._headPool.next, _loc2_._poolSize = _loc2_._poolSize - 1, _loc8_.next = null, _loc8_.val = _loc6_, _loc8_);
            if(_loc2_.tail != null)
            {
               _loc2_.tail.next = _loc7_;
               _loc7_.prev = _loc2_.tail;
            }
            else
            {
               _loc2_.head = _loc7_;
            }
            _loc2_.tail = _loc7_;
            if(_loc2_._circular)
            {
               _loc2_.tail.next = _loc2_.head;
               _loc2_.head.prev = _loc2_.tail;
            }
            _loc2_._size = _loc2_._size + 1;
            _loc7_;
         }
         return _loc2_;
      }
      
      public static function toLinkedQueue(x:Array) : LinkedQueue
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as LinkedQueueNode;
         var _loc8_:* = null as LinkedQueueNode;
         null;
         null;
         var _loc2_:LinkedQueue = new LinkedQueue();
         var _loc3_:int = 0;
         var _loc4_:int = int(x.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = x[_loc5_];
            _loc2_._size = _loc2_._size + 1;
            _loc7_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new LinkedQueueNode(_loc6_) : (_loc8_ = _loc2_._headPool, _loc2_._headPool = _loc2_._headPool.next, _loc2_._poolSize = _loc2_._poolSize - 1, _loc8_.val = _loc6_, _loc8_);
            if(_loc2_._head == null)
            {
               _loc2_._head = _loc2_._tail = _loc7_;
               _loc2_._head.next = _loc2_._tail;
            }
            else
            {
               _loc2_._tail.next = _loc7_;
               _loc2_._tail = _loc7_;
            }
         }
         return _loc2_;
      }
      
      public static function toLinkedStack(x:Array) : LinkedStack
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as LinkedStackNode;
         var _loc8_:* = null as LinkedStackNode;
         null;
         null;
         var _loc2_:LinkedStack = new LinkedStack();
         var _loc3_:int = 0;
         var _loc4_:int = int(x.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = x[_loc5_];
            _loc7_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new LinkedStackNode(_loc6_) : (_loc8_ = _loc2_._headPool, _loc2_._headPool = _loc2_._headPool.next, _loc2_._poolSize = _loc2_._poolSize - 1, _loc8_.val = _loc6_, _loc8_);
            _loc7_.next = _loc2_._head;
            _loc2_._head = _loc7_;
            _loc2_._top = _loc2_._top + 1;
         }
         return _loc2_;
      }
      
      public static function toDA(x:Array) : DA
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         null;
         null;
         var _loc2_:DA = new DA(int(x.length));
         var _loc3_:int = 0;
         var _loc4_:int = int(x.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = _loc2_._size;
            null;
            _loc2_._a[_loc6_] = x[_loc5_];
            if(_loc6_ >= _loc2_._size)
            {
               _loc2_._size = _loc2_._size + 1;
            }
         }
         return _loc2_;
      }
   }
}
