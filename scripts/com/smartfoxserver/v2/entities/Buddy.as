package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   
   public interface Buddy
   {
       
      
      function get id() : int;
      
      function get name() : String;
      
      function get isBlocked() : Boolean;
      
      function get isOnline() : Boolean;
      
      function get isTemp() : Boolean;
      
      function get state() : String;
      
      function get nickName() : String;
      
      function get variables() : Array;
      
      function getVariable(varName:String) : BuddyVariable;
      
      function containsVariable(varName:String) : Boolean;
      
      function getOfflineVariables() : Array;
      
      function getOnlineVariables() : Array;
      
      function setVariable(bVar:BuddyVariable) : void;
      
      function setVariables(variables:Array) : void;
      
      function setId(id:int) : void;
      
      function setBlocked(value:Boolean) : void;
      
      function removeVariable(varName:String) : void;
      
      function clearVolatileVariables() : void;
   }
}
