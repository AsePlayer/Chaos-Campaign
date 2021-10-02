package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.kernel;
   import com.smartfoxserver.v2.util.ArrayUtil;
   import de.polygonal.ds.HashMap;
   import de.polygonal.ds.Itr;
   
   public class SFSRoomManager implements IRoomManager
   {
       
      
      private var _ownerZone:String;
      
      private var _groups:Array;
      
      private var _roomsById:HashMap;
      
      private var _roomsByName:HashMap;
      
      protected var _smartFox:SmartFox;
      
      public function SFSRoomManager(sfs:SmartFox)
      {
         super();
         this._groups = new Array();
         this._roomsById = new HashMap();
         this._roomsByName = new HashMap();
      }
      
      public function get ownerZone() : String
      {
         return this._ownerZone;
      }
      
      public function set ownerZone(value:String) : void
      {
         this._ownerZone = value;
      }
      
      public function get smartFox() : SmartFox
      {
         return this._smartFox;
      }
      
      public function addRoom(room:Room, addGroupIfMissing:Boolean = true) : void
      {
         this._roomsById.set(room.id,room);
         this._roomsByName.set(room.name,room);
         if(addGroupIfMissing)
         {
            if(!this.containsGroup(room.groupId))
            {
               this.addGroup(room.groupId);
            }
         }
         else
         {
            room.isManaged = false;
         }
      }
      
      public function replaceRoom(room:Room, addToGroupIfMissing:Boolean = true) : Room
      {
         var oldRoom:Room = this.getRoomById(room.id);
         if(oldRoom != null)
         {
            oldRoom.kernel::merge(room);
            return oldRoom;
         }
         this.addRoom(room,addToGroupIfMissing);
         return room;
      }
      
      public function changeRoomName(room:Room, newName:String) : void
      {
         var oldName:String = room.name;
         room.name = newName;
         this._roomsByName.set(newName,room);
         this._roomsByName.clr(oldName);
      }
      
      public function changeRoomPasswordState(room:Room, isPassProtected:Boolean) : void
      {
         room.setPasswordProtected(isPassProtected);
      }
      
      public function changeRoomCapacity(room:Room, maxUsers:int, maxSpect:int) : void
      {
         room.maxUsers = maxUsers;
         room.maxSpectators = maxSpect;
      }
      
      public function getRoomGroups() : Array
      {
         return this._groups;
      }
      
      public function addGroup(groupId:String) : void
      {
         this._groups.push(groupId);
      }
      
      public function removeGroup(groupId:String) : void
      {
         var room:Room = null;
         ArrayUtil.removeElement(this._groups,groupId);
         var roomsInGroup:Array = this.getRoomListFromGroup(groupId);
         for each(room in roomsInGroup)
         {
            if(!room.isJoined)
            {
               this.removeRoom(room);
            }
            else
            {
               room.isManaged = false;
            }
         }
      }
      
      public function containsGroup(groupId:String) : Boolean
      {
         return this._groups.indexOf(groupId) > -1;
      }
      
      public function containsRoom(idOrName:*) : Boolean
      {
         if(typeof idOrName == "number")
         {
            return this._roomsById.hasKey(idOrName);
         }
         return this._roomsByName.hasKey(idOrName);
      }
      
      public function containsRoomInGroup(idOrName:*, groupId:String) : Boolean
      {
         var room:Room = null;
         var roomList:Array = this.getRoomListFromGroup(groupId);
         var found:Boolean = false;
         var searchById:Boolean = typeof idOrName == "number";
         for each(room in roomList)
         {
            if(searchById)
            {
               if(room.id == idOrName)
               {
                  found = true;
                  break;
               }
            }
            else if(room.name == idOrName)
            {
               found = true;
               break;
            }
         }
         return found;
      }
      
      public function getRoomById(id:int) : Room
      {
         return this._roomsById.get(id) as Room;
      }
      
      public function getRoomByName(name:String) : Room
      {
         return this._roomsByName.get(name) as Room;
      }
      
      public function getRoomList() : Array
      {
         return this._roomsById.toDA().getArray();
      }
      
      public function getRoomCount() : int
      {
         return this._roomsById.size();
      }
      
      public function getRoomListFromGroup(groupId:String) : Array
      {
         var room:Room = null;
         var roomList:Array = new Array();
         var it:Itr = this._roomsById.iterator();
         while(it.hasNext())
         {
            room = it.next() as Room;
            if(room.groupId == groupId)
            {
               roomList.push(room);
            }
         }
         return roomList;
      }
      
      public function removeRoom(room:Room) : void
      {
         this._removeRoom(room.id,room.name);
      }
      
      public function removeRoomById(id:int) : void
      {
         var room:Room = this._roomsById.get(id) as Room;
         if(room != null)
         {
            this._removeRoom(id,room.name);
         }
      }
      
      public function removeRoomByName(name:String) : void
      {
         var room:Room = this._roomsByName.get(name) as Room;
         if(room != null)
         {
            this._removeRoom(room.id,name);
         }
      }
      
      public function getJoinedRooms() : Array
      {
         var room:Room = null;
         var rooms:Array = [];
         var it:Itr = this._roomsById.iterator();
         while(it.hasNext())
         {
            room = it.next() as Room;
            if(room.isJoined)
            {
               rooms.push(room);
            }
         }
         return rooms;
      }
      
      public function getUserRooms(user:User) : Array
      {
         var room:Room = null;
         var rooms:Array = [];
         var it:Itr = this._roomsById.iterator();
         while(it.hasNext())
         {
            room = it.next() as Room;
            if(room.containsUser(user))
            {
               rooms.push(room);
            }
         }
         return rooms;
      }
      
      public function removeUser(user:User) : void
      {
         var room:Room = null;
         var it:Itr = this._roomsById.iterator();
         while(it.hasNext())
         {
            room = it.next() as Room;
            if(room.containsUser(user))
            {
               room.removeUser(user);
            }
         }
      }
      
      private function _removeRoom(id:int, name:String) : void
      {
         this._roomsById.clr(id);
         this._roomsByName.clr(name);
      }
   }
}
