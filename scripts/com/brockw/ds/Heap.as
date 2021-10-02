package com.brockw.ds
{
   public class Heap
   {
       
      
      private var currentSize:int;
      
      private var array:Vector.<Comparable>;
      
      public function Heap(capacity:int)
      {
         super();
         this.array = new Vector.<Comparable>(capacity,false);
         this.currentSize = 0;
      }
      
      public function clear() : void
      {
         this.makeEmpty();
      }
      
      public function size() : int
      {
         return this.currentSize;
      }
      
      public function insert(x:Comparable) : void
      {
         var hole:int = ++this.currentSize;
         while(hole > 1 && x.compare(this.array[Math.floor(hole / 2)]) < 0)
         {
            this.array[hole] = this.array[Math.floor(hole / 2)];
            hole = Math.floor(hole / 2);
         }
         this.array[hole] = x;
      }
      
      public function findMin() : Comparable
      {
         if(this.isEmpty())
         {
            throw new Error("Heap: Can not find the min");
         }
         return this.array[1];
      }
      
      public function pop() : Comparable
      {
         if(this.isEmpty())
         {
            throw new Error("Heap: Can not delete min");
         }
         var minItem:Comparable = this.findMin();
         this.array[1] = this.array[this.currentSize--];
         this.percolateDown(1);
         return minItem;
      }
      
      private function buildHeap() : void
      {
         for(var i:int = this.currentSize / 2; i > 0; i--)
         {
            this.percolateDown(i);
         }
      }
      
      public function isEmpty() : Boolean
      {
         return this.currentSize == 0;
      }
      
      public function makeEmpty() : void
      {
         this.currentSize = 0;
      }
      
      private function percolateDown(hole:int) : void
      {
         var child:int = 0;
         for(var tmp:Comparable = this.array[hole]; hole * 2 <= this.currentSize; )
         {
            child = hole * 2;
            if(child != this.currentSize && this.array[child + 1].compare(this.array[child]) < 0)
            {
               child++;
            }
            if(this.array[child].compare(tmp) >= 0)
            {
               break;
            }
            this.array[hole] = this.array[child];
            hole = child;
         }
         this.array[hole] = tmp;
      }
   }
}
