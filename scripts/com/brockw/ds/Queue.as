package com.brockw.ds
{
   public class Queue
   {
       
      
      internal var data:Array;
      
      public function Queue(size:int)
      {
         super();
         this.data = new Array(size);
      }
      
      public function pop() : Object
      {
         return this.data.shift();
      }
      
      public function push(o:Object) : void
      {
         this.data.push(o);
      }
      
      public function size() : int
      {
         return this.data.length;
      }
      
      public function isEmpty() : Boolean
      {
         return this.data.length == 0;
      }
      
      public function clear() : void
      {
         while(!this.isEmpty())
         {
            this.data.pop();
         }
      }
   }
}
