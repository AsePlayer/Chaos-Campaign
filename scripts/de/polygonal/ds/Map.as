package de.polygonal.ds
{
   public interface Map extends Collection
   {
       
      
      function toValSet() : Set;
      
      function toKeySet() : Set;
      
      function set(key:Object, x:Object) : Boolean;
      
      function remap(key:Object, x:Object) : Boolean;
      
      function keys() : Itr;
      
      function hasKey(key:Object) : Boolean;
      
      function has(x:Object) : Boolean;
      
      function get(key:Object) : Object;
      
      function clr(key:Object) : Boolean;
   }
}
