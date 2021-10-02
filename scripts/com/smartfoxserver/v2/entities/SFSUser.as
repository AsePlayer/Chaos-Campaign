package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import com.smartfoxserver.v2.exceptions.SFSError;
   
   public class SFSUser implements User
   {
       
      
      protected var _id:int = -1;
      
      protected var _privilegeId:int = 0;
      
      protected var _name:String;
      
      protected var _isItMe:Boolean;
      
      protected var _variables:Object;
      
      protected var _properties:Object;
      
      protected var _isModerator:Boolean;
      
      protected var _playerIdByRoomId:Object;
      
      protected var _userManager:IUserManager;
      
      public function SFSUser(id:int, name:String, isItMe:Boolean = false)
      {
         super();
         this._id = id;
         this._name = name;
         this._isItMe = isItMe;
         this._variables = {};
         this._properties = {};
         this._isModerator = false;
         this._playerIdByRoomId = {};
      }
      
      public static function fromSFSArray(sfsa:ISFSArray, room:Room = null) : User
      {
         var newUser:User = new SFSUser(sfsa.getInt(0),sfsa.getUtfString(1));
         newUser.privilegeId = sfsa.getShort(2);
         if(room != null)
         {
            newUser.setPlayerId(sfsa.getShort(3),room);
         }
         var uVars:ISFSArray = sfsa.getSFSArray(4);
         for(var i:int = 0; i < uVars.size(); i++)
         {
            newUser.setVariable(SFSUserVariable.fromSFSArray(uVars.getSFSArray(i)));
         }
         return newUser;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get playerId() : int
      {
         return this.getPlayerId(this.userManager.smartFox.lastJoinedRoom);
      }
      
      public function isJoinedInRoom(room:Room) : Boolean
      {
         return room.containsUser(this);
      }
      
      public function get privilegeId() : int
      {
         return this._privilegeId;
      }
      
      public function set privilegeId(value:int) : void
      {
         this._privilegeId = value;
      }
      
      public function isGuest() : Boolean
      {
         return this._privilegeId == UserPrivileges.GUEST;
      }
      
      public function isStandardUser() : Boolean
      {
         return this._privilegeId == UserPrivileges.STANDARD;
      }
      
      public function isModerator() : Boolean
      {
         return this._privilegeId == UserPrivileges.MODERATOR;
      }
      
      public function isAdmin() : Boolean
      {
         return this._privilegeId == UserPrivileges.ADMINISTRATOR;
      }
      
      public function get isPlayer() : Boolean
      {
         return this.playerId > 0;
      }
      
      public function get isSpectator() : Boolean
      {
         return !this.isPlayer;
      }
      
      public function getPlayerId(room:Room) : int
      {
         var pId:int = 0;
         if(this._playerIdByRoomId[room.id] != null)
         {
            pId = this._playerIdByRoomId[room.id];
         }
         return pId;
      }
      
      public function setPlayerId(id:int, room:Room) : void
      {
         this._playerIdByRoomId[room.id] = id;
      }
      
      public function removePlayerId(room:Room) : void
      {
         delete this._playerIdByRoomId[room.id];
      }
      
      public function isPlayerInRoom(room:Room) : Boolean
      {
         return this._playerIdByRoomId[room.id] > 0;
      }
      
      public function isSpectatorInRoom(room:Room) : Boolean
      {
         return this._playerIdByRoomId[room.id] < 0;
      }
      
      public function get isItMe() : Boolean
      {
         return this._isItMe;
      }
      
      public function get userManager() : IUserManager
      {
         return this._userManager;
      }
      
      public function set userManager(manager:IUserManager) : void
      {
         if(this._userManager != null)
         {
            throw new SFSError("Cannot re-assign the User Manager. Already set. User: " + this);
         }
         this._userManager = manager;
      }
      
      public function getVariables() : Array
      {
         var uv:SFSUserVariable = null;
         var variables:Array = [];
         for each(uv in this._variables)
         {
            variables.push(uv);
         }
         return variables;
      }
      
      public function getVariable(name:String) : UserVariable
      {
         return this._variables[name];
      }
      
      public function setVariable(userVariable:UserVariable) : void
      {
         if(userVariable != null)
         {
            if(userVariable.isNull())
            {
               delete this._variables[userVariable.name];
            }
            else
            {
               this._variables[userVariable.name] = userVariable;
            }
         }
      }
      
      public function setVariables(userVariables:Array) : void
      {
         var userVar:UserVariable = null;
         for each(userVar in userVariables)
         {
            this.setVariable(userVar);
         }
      }
      
      public function containsVariable(name:String) : Boolean
      {
         return this._variables[name] != null;
      }
      
      private function removeUserVariable(varName:String) : void
      {
         delete this._variables[varName];
      }
      
      public function get properties() : Object
      {
         return this._properties;
      }
      
      public function set properties(value:Object) : void
      {
         this._properties = value;
      }
      
      public function toString() : String
      {
         return "[User: " + this._name + ", Id: " + this._id + ", isMe: " + this._isItMe + "]";
      }
   }
}
