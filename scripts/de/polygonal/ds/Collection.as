package de.polygonal.ds
{
   public interface Collection extends Hashable
   {
       
      
      function toDA() : DA;
      
      function toArray() : Array;
      
      function size() : int;
      
      function remove(x:Object) : Boolean;
      
      function iterator() : Itr;
      
      function isEmpty() : Boolean;
      
      function free() : void;
      
      function contains(x:Object) : Boolean;
      
      function clone(assign:Boolean, copier:Object = undefined) : Collection;
      
      function clear(purge:Boolean = undefined) : void;
   }
}
