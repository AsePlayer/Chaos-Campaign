package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.User;
   
   public interface IUserManager
   {
       
      
      function containsUserName(userName:String) : Boolean;
      
      function containsUserId(userId:int) : Boolean;
      
      function containsUser(user:User) : Boolean;
      
      function getUserByName(userName:String) : User;
      
      function getUserById(userId:int) : User;
      
      function addUser(user:User) : void;
      
      function removeUser(user:User) : void;
      
      function removeUserById(id:int) : void;
      
      function get userCount() : int;
      
      function getUserList() : Array;
      
      function get smartFox() : SmartFox;
   }
}
