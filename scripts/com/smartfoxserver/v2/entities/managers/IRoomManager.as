package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   
   public interface IRoomManager
   {
       
      
      function get ownerZone() : String;
      
      function addRoom(room:Room, addGroupIfMissing:Boolean = true) : void;
      
      function addGroup(groupId:String) : void;
      
      function replaceRoom(room:Room, addToGroupIfMissing:Boolean = true) : Room;
      
      function removeGroup(groupId:String) : void;
      
      function containsGroup(groupId:String) : Boolean;
      
      function containsRoom(idOrName:*) : Boolean;
      
      function containsRoomInGroup(idOrName:*, groupId:String) : Boolean;
      
      function changeRoomName(room:Room, newName:String) : void;
      
      function changeRoomPasswordState(room:Room, isPassProtected:Boolean) : void;
      
      function changeRoomCapacity(room:Room, maxUsers:int, maxSpect:int) : void;
      
      function getRoomById(id:int) : Room;
      
      function getRoomByName(name:String) : Room;
      
      function getRoomList() : Array;
      
      function getRoomCount() : int;
      
      function getRoomGroups() : Array;
      
      function getRoomListFromGroup(groupId:String) : Array;
      
      function getJoinedRooms() : Array;
      
      function getUserRooms(user:User) : Array;
      
      function removeRoom(room:Room) : void;
      
      function removeRoomById(id:int) : void;
      
      function removeRoomByName(name:String) : void;
      
      function removeUser(user:User) : void;
      
      function get smartFox() : SmartFox;
   }
}
