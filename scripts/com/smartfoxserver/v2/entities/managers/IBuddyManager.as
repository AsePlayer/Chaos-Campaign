package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   
   public interface IBuddyManager
   {
       
      
      function get isInited() : Boolean;
      
      function setInited() : void;
      
      function addBuddy(buddy:Buddy) : void;
      
      function removeBuddyById(id:int) : Buddy;
      
      function removeBuddyByName(name:String) : Buddy;
      
      function containsBuddy(name:String) : Boolean;
      
      function getBuddyById(id:int) : Buddy;
      
      function getBuddyByName(name:String) : Buddy;
      
      function getBuddyByNickName(nickName:String) : Buddy;
      
      function get offlineBuddies() : Array;
      
      function get onlineBuddies() : Array;
      
      function get buddyList() : Array;
      
      function get buddyStates() : Array;
      
      function getMyVariable(varName:String) : BuddyVariable;
      
      function get myVariables() : Array;
      
      function get myOnlineState() : Boolean;
      
      function get myNickName() : String;
      
      function get myState() : String;
      
      function setMyVariable(bVar:BuddyVariable) : void;
      
      function setMyVariables(variables:Array) : void;
      
      function setMyOnlineState(isOnline:Boolean) : void;
      
      function setMyNickName(nickName:String) : void;
      
      function setMyState(state:String) : void;
      
      function setBuddyStates(states:Array) : void;
      
      function clearAll() : void;
   }
}
