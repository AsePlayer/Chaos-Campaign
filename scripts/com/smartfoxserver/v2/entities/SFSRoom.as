package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.managers.IRoomManager;
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.managers.SFSUserManager;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.kernel;
   import com.smartfoxserver.v2.util.ArrayUtil;
   
   public class SFSRoom implements Room
   {
       
      
      protected var _id:int;
      
      protected var _name:String;
      
      protected var _groupId:String;
      
      protected var _isGame:Boolean;
      
      protected var _isHidden:Boolean;
      
      protected var _isJoined:Boolean;
      
      protected var _isPasswordProtected:Boolean;
      
      protected var _isManaged:Boolean;
      
      protected var _variables:Object;
      
      protected var _properties:Object;
      
      protected var _userManager:IUserManager;
      
      protected var _maxUsers:int;
      
      protected var _maxSpectators:int;
      
      protected var _userCount:int;
      
      protected var _specCount:int;
      
      protected var _roomManager:IRoomManager;
      
      public function SFSRoom(id:int, name:String, groupId:String = "default")
      {
         super();
         this._id = id;
         this._name = name;
         this._groupId = groupId;
         this._isJoined = this._isGame = this._isHidden = false;
         this._isManaged = true;
         this._userCount = this._specCount = 0;
         this._variables = new Object();
         this._properties = new Object();
         this._userManager = new SFSUserManager(null);
      }
      
      public static function fromSFSArray(sfsa:ISFSArray) : Room
      {
         var vars:Array = null;
         var j:int = 0;
         var roomVariable:RoomVariable = null;
         var newRoom:Room = new SFSRoom(sfsa.getInt(0),sfsa.getUtfString(1),sfsa.getUtfString(2));
         newRoom.isGame = sfsa.getBool(3);
         newRoom.isHidden = sfsa.getBool(4);
         newRoom.isPasswordProtected = sfsa.getBool(5);
         newRoom.userCount = sfsa.getShort(6);
         newRoom.maxUsers = sfsa.getShort(7);
         var varsList:ISFSArray = sfsa.getSFSArray(8);
         if(varsList.size() > 0)
         {
            vars = new Array();
            for(j = 0; j < varsList.size(); j++)
            {
               roomVariable = SFSRoomVariable.fromSFSArray(varsList.getSFSArray(j));
               vars.push(roomVariable);
            }
            newRoom.setVariables(vars);
         }
         if(newRoom.isGame)
         {
            newRoom.spectatorCount = sfsa.getShort(9);
            newRoom.maxSpectators = sfsa.getShort(10);
         }
         return newRoom;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get groupId() : String
      {
         return this._groupId;
      }
      
      public function get isGame() : Boolean
      {
         return this._isGame;
      }
      
      public function get isHidden() : Boolean
      {
         return this._isHidden;
      }
      
      public function get isJoined() : Boolean
      {
         return this._isJoined;
      }
      
      public function get isPasswordProtected() : Boolean
      {
         return this._isPasswordProtected;
      }
      
      public function set isPasswordProtected(value:Boolean) : void
      {
         this._isPasswordProtected = value;
      }
      
      public function set isJoined(value:Boolean) : void
      {
         this._isJoined = value;
      }
      
      public function set isGame(value:Boolean) : void
      {
         this._isGame = value;
      }
      
      public function set isHidden(value:Boolean) : void
      {
         this._isHidden = value;
      }
      
      public function get isManaged() : Boolean
      {
         return this._isManaged;
      }
      
      public function set isManaged(value:Boolean) : void
      {
         this._isManaged = value;
      }
      
      public function getVariables() : Array
      {
         return ArrayUtil.objToArray(this._variables);
      }
      
      public function getVariable(name:String) : RoomVariable
      {
         return this._variables[name];
      }
      
      public function get userCount() : int
      {
         if(!this._isJoined)
         {
            return this._userCount;
         }
         if(this.isGame)
         {
            return this.playerList.length;
         }
         return this._userManager.userCount;
      }
      
      public function get maxUsers() : int
      {
         return this._maxUsers;
      }
      
      public function get capacity() : int
      {
         return this._maxUsers + this._maxSpectators;
      }
      
      public function get spectatorCount() : int
      {
         if(!this.isGame)
         {
            return 0;
         }
         if(this._isJoined)
         {
            return this.spectatorList.length;
         }
         return this._specCount;
      }
      
      public function get maxSpectators() : int
      {
         return this._maxSpectators;
      }
      
      public function set userCount(value:int) : void
      {
         this._userCount = value;
      }
      
      public function set maxUsers(value:int) : void
      {
         this._maxUsers = value;
      }
      
      public function set spectatorCount(value:int) : void
      {
         this._specCount = value;
      }
      
      public function set maxSpectators(value:int) : void
      {
         this._maxSpectators = value;
      }
      
      public function getUserByName(name:String) : User
      {
         return this._userManager.getUserByName(name);
      }
      
      public function getUserById(id:int) : User
      {
         return this._userManager.getUserById(id);
      }
      
      public function get userList() : Array
      {
         return this._userManager.getUserList();
      }
      
      public function get playerList() : Array
      {
         var user:User = null;
         var playerList:Array = [];
         for each(user in this._userManager.getUserList())
         {
            if(user.isPlayerInRoom(this))
            {
               playerList.push(user);
            }
         }
         return playerList;
      }
      
      public function get spectatorList() : Array
      {
         var user:User = null;
         var spectatorList:Array = [];
         for each(user in this._userManager.getUserList())
         {
            if(user.isSpectatorInRoom(this))
            {
               spectatorList.push(user);
            }
         }
         return spectatorList;
      }
      
      public function removeUser(user:User) : void
      {
         this._userManager.removeUser(user);
      }
      
      public function setVariable(roomVariable:RoomVariable) : void
      {
         if(roomVariable.isNull())
         {
            delete this._variables[roomVariable.name];
         }
         else
         {
            this._variables[roomVariable.name] = roomVariable;
         }
      }
      
      public function setVariables(roomVariables:Array) : void
      {
         var roomVar:RoomVariable = null;
         for each(roomVar in roomVariables)
         {
            this.setVariable(roomVar);
         }
      }
      
      public function containsVariable(name:String) : Boolean
      {
         return this._variables[name] != null;
      }
      
      public function get properties() : Object
      {
         return this._properties;
      }
      
      public function set properties(value:Object) : void
      {
         this._properties = value;
      }
      
      public function addUser(user:User) : void
      {
         this._userManager.addUser(user);
      }
      
      public function containsUser(user:User) : Boolean
      {
         return this._userManager.containsUser(user);
      }
      
      public function get roomManager() : IRoomManager
      {
         return this._roomManager;
      }
      
      public function set roomManager(value:IRoomManager) : void
      {
         if(this._roomManager != null)
         {
            throw new SFSError("Room manager already assigned. Room: " + this);
         }
         this._roomManager = value;
      }
      
      public function setPasswordProtected(isProtected:Boolean) : void
      {
         this._isPasswordProtected = isProtected;
      }
      
      public function toString() : String
      {
         return "[Room: " + this._name + ", Id: " + this._id + ", GroupId: " + this._groupId + "]";
      }
      
      kernel function merge(anotherRoom:Room) : void
      {
         var rv:RoomVariable = null;
         var user:User = null;
         for each(rv in anotherRoom.getVariables())
         {
            this._variables[rv.name] = rv;
         }
         this._userManager.kernel::clearAll();
         for each(user in anotherRoom.userList)
         {
            this._userManager.addUser(user);
         }
      }
   }
}
