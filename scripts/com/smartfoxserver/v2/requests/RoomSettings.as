package com.smartfoxserver.v2.requests
{
     import com.smartfoxserver.v2.entities.SFSConstants;
     
     public class RoomSettings
     {
           
          
          private var _name:String;
          
          private var _password:String;
          
          private var _groupId:String;
          
          private var _isGame:Boolean;
          
          private var _maxUsers:int;
          
          private var _maxSpectators:int;
          
          private var _maxVariables:int;
          
          private var _variables:Array;
          
          private var _permissions:com.smartfoxserver.v2.requests.RoomPermissions;
          
          private var _events:com.smartfoxserver.v2.requests.RoomEvents;
          
          private var _extension:com.smartfoxserver.v2.requests.RoomExtension;
          
          public function RoomSettings(name:String)
          {
               super();
               this._name = name;
               this._password = "";
               this._isGame = false;
               this._maxUsers = 10;
               this._maxSpectators = 0;
               this._maxVariables = 5;
               this._groupId = SFSConstants.DEFAULT_GROUP_ID;
          }
          
          public function get name() : String
          {
               return this._name;
          }
          
          public function set name(value:String) : void
          {
               this._name = value;
          }
          
          public function get password() : String
          {
               return this._password;
          }
          
          public function set password(value:String) : void
          {
               this._password = value;
          }
          
          public function get isGame() : Boolean
          {
               return this._isGame;
          }
          
          public function set isGame(value:Boolean) : void
          {
               this._isGame = value;
          }
          
          public function get maxUsers() : int
          {
               return this._maxUsers;
          }
          
          public function set maxUsers(value:int) : void
          {
               this._maxUsers = value;
          }
          
          public function get maxVariables() : int
          {
               return this._maxVariables;
          }
          
          public function set maxVariables(value:int) : void
          {
               this._maxVariables = value;
          }
          
          public function get maxSpectators() : int
          {
               return this._maxSpectators;
          }
          
          public function set maxSpectators(value:int) : void
          {
               this._maxSpectators = value;
          }
          
          public function get variables() : Array
          {
               return this._variables;
          }
          
          public function set variables(value:Array) : void
          {
               this._variables = value;
          }
          
          public function get permissions() : com.smartfoxserver.v2.requests.RoomPermissions
          {
               return this._permissions;
          }
          
          public function set permissions(value:com.smartfoxserver.v2.requests.RoomPermissions) : void
          {
               this._permissions = value;
          }
          
          public function get events() : com.smartfoxserver.v2.requests.RoomEvents
          {
               return this._events;
          }
          
          public function set events(value:com.smartfoxserver.v2.requests.RoomEvents) : void
          {
               this._events = value;
          }
          
          public function get extension() : com.smartfoxserver.v2.requests.RoomExtension
          {
               return this._extension;
          }
          
          public function set extension(value:com.smartfoxserver.v2.requests.RoomExtension) : void
          {
               this._extension = value;
          }
          
          public function get groupId() : String
          {
               return this._groupId;
          }
          
          public function set groupId(value:String) : void
          {
               this._groupId = value;
          }
     }
}
