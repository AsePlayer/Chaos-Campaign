package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.managers.IRoomManager;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   
   public interface Room
   {
       
      
      function get id() : int;
      
      function get name() : String;
      
      function set name(value:String) : void;
      
      function get groupId() : String;
      
      function get isJoined() : Boolean;
      
      function get isGame() : Boolean;
      
      function get isHidden() : Boolean;
      
      function get isPasswordProtected() : Boolean;
      
      function set isPasswordProtected(value:Boolean) : void;
      
      function get isManaged() : Boolean;
      
      function get userCount() : int;
      
      function get maxUsers() : int;
      
      function get spectatorCount() : int;
      
      function get maxSpectators() : int;
      
      function get capacity() : int;
      
      function set isJoined(value:Boolean) : void;
      
      function set isGame(value:Boolean) : void;
      
      function set isHidden(value:Boolean) : void;
      
      function set isManaged(value:Boolean) : void;
      
      function set userCount(value:int) : void;
      
      function set maxUsers(value:int) : void;
      
      function set spectatorCount(value:int) : void;
      
      function set maxSpectators(value:int) : void;
      
      function addUser(user:User) : void;
      
      function removeUser(user:User) : void;
      
      function containsUser(user:User) : Boolean;
      
      function getUserByName(name:String) : User;
      
      function getUserById(id:int) : User;
      
      function get userList() : Array;
      
      function get playerList() : Array;
      
      function get spectatorList() : Array;
      
      function getVariable(name:String) : RoomVariable;
      
      function getVariables() : Array;
      
      function setVariable(roomVariable:RoomVariable) : void;
      
      function setVariables(roomVariables:Array) : void;
      
      function containsVariable(name:String) : Boolean;
      
      function get properties() : Object;
      
      function set properties(value:Object) : void;
      
      function get roomManager() : IRoomManager;
      
      function set roomManager(manager:IRoomManager) : void;
      
      function setPasswordProtected(isProtected:Boolean) : void;
   }
}
