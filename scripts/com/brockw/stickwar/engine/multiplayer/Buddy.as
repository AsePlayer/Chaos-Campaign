package com.brockw.stickwar.engine.multiplayer
{
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public class Buddy extends buddyDisplayBox
   {
      
      private static const S_ONLINE:int = 0;
      
      private static const S_OFFLINE:int = 1;
      
      private static const S_AWAY:int = 2;
      
      private static const S_IN_GAME:int = 3;
       
      
      private var _name:String;
      
      private var _id:int;
      
      private var _statusType:int;
      
      private var _isTemp:Boolean;
      
      private var _chatHistory:String;
      
      public function Buddy()
      {
         super();
         this.chatHistory = "";
         this._name = "";
         this._id = -1;
         this._statusType = -1;
         this._isTemp = true;
         this.displayName.mouseEnabled = false;
         this.displayName.selectable = false;
         this.displayName.mouseEnabled = false;
      }
      
      public static function getStatuses() : Array
      {
         var s:Array = [S_ONLINE,S_OFFLINE,S_AWAY];
         var a:Array = [];
         for(var i:int = 0; i < s.length; i++)
         {
            a.push(statusFromCode(s[i]));
         }
         return a;
      }
      
      public static function codeFromStatus(status:String) : int
      {
         switch(status)
         {
            case "Online":
               return S_ONLINE;
            case "Offline":
               return S_OFFLINE;
            case "Away":
               return S_AWAY;
            case "In Game":
               return S_IN_GAME;
            default:
               return -1;
         }
      }
      
      public static function statusFromCode(code:int) : String
      {
         switch(code)
         {
            case S_ONLINE:
               return "Online";
            case S_OFFLINE:
               return "Offline";
            case S_AWAY:
               return "Away";
            case S_IN_GAME:
               return "In Game";
            default:
               return "";
         }
      }
      
      override public function toString() : String
      {
         return this._name;
      }
      
      public function fromSFSObject(s:ISFSObject) : void
      {
         this._name = s.getUtfString("n");
         this._id = s.getInt("id");
         this._statusType = s.getInt("s");
         this._isTemp = false;
         this.displayName.text = this._name;
         this.status.gotoAndStop(Buddy.statusFromCode(this._statusType));
      }
      
      override public function get name() : String
      {
         return this._name;
      }
      
      override public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
      }
      
      public function get statusType() : int
      {
         return this._statusType;
      }
      
      public function set statusType(value:int) : void
      {
         this._statusType = value;
         this.status.gotoAndStop(Buddy.statusFromCode(this._statusType));
      }
      
      public function get isTemp() : Boolean
      {
         return this._isTemp;
      }
      
      public function set isTemp(value:Boolean) : void
      {
         this._isTemp = value;
      }
      
      public function get chatHistory() : String
      {
         return this._chatHistory;
      }
      
      public function set chatHistory(value:String) : void
      {
         this._chatHistory = value;
      }
   }
}
