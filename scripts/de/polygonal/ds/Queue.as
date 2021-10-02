package de.polygonal.ds
{
   public interface Queue extends Collection
   {
       
      
      function peek() : Object;
      
      function enqueue(x:Object) : void;
      
      function dequeue() : Object;
      
      function back() : Object;
   }
}
