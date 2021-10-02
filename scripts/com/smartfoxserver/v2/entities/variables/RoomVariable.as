package com.smartfoxserver.v2.entities.variables
{
   public interface RoomVariable extends UserVariable
   {
       
      
      function get isPrivate() : Boolean;
      
      function get isPersistent() : Boolean;
      
      function set isPrivate(value:Boolean) : void;
      
      function set isPersistent(value:Boolean) : void;
   }
}
