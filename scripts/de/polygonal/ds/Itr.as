package de.polygonal.ds
{
   public interface Itr
   {
       
      
      function reset() : Itr;
      
      function next() : Object;
      
      function hasNext() : Boolean;
   }
}
