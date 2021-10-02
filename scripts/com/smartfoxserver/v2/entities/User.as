package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   
   public interface User
   {
       
      
      function get id() : int;
      
      function get name() : String;
      
      function get playerId() : int;
      
      function get isPlayer() : Boolean;
      
      function get isSpectator() : Boolean;
      
      function getPlayerId(room:Room) : int;
      
      function setPlayerId(id:int, room:Room) : void;
      
      function removePlayerId(room:Room) : void;
      
      function get privilegeId() : int;
      
      function set privilegeId(value:int) : void;
      
      function get userManager() : IUserManager;
      
      function set userManager(value:IUserManager) : void;
      
      function isGuest() : Boolean;
      
      function isStandardUser() : Boolean;
      
      function isModerator() : Boolean;
      
      function isAdmin() : Boolean;
      
      function isPlayerInRoom(room:Room) : Boolean;
      
      function isSpectatorInRoom(room:Room) : Boolean;
      
      function isJoinedInRoom(room:Room) : Boolean;
      
      function get isItMe() : Boolean;
      
      function getVariables() : Array;
      
      function getVariable(name:String) : UserVariable;
      
      function setVariable(userVariable:UserVariable) : void;
      
      function setVariables(userVariables:Array) : void;
      
      function containsVariable(name:String) : Boolean;
      
      function get properties() : Object;
      
      function set properties(value:Object) : void;
   }
}
