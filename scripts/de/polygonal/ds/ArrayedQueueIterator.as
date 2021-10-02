package de.polygonal.ds
{
   import flash.Boot;
   
   public class ArrayedQueueIterator implements Itr
   {
       
      
      public var _size:int;
      
      public var _i:int;
      
      public var _front:int;
      
      public var _f:ArrayedQueue;
      
      public var _capacity:int;
      
      public var _a:Array;
      
      public function ArrayedQueueIterator(f:ArrayedQueue = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = f;
         _a = _f._a;
         _front = _f._front;
         _capacity = _f._capacity;
         _size = _f._size;
         _i = 0;
         this;
      }
      
      public function reset() : Itr
      {
         _a = _f._a;
         _front = _f._front;
         _capacity = _f._capacity;
         _size = _f._size;
         _i = 0;
         return this;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         _i = (_loc1_ = _i) + 1;
         return _a[int((_loc1_ + _front) % _capacity)];
      }
      
      public function hasNext() : Boolean
      {
         return _i < _size;
      }
      
      public function __size(f:Object) : int
      {
         return int(f._capacity);
      }
      
      public function __front(f:Object) : int
      {
         return int(f._front);
      }
      
      public function __count(f:Object) : int
      {
         return int(f._size);
      }
      
      public function __a(f:Object) : Array
      {
         return f._a;
      }
   }
}
