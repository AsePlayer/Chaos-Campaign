package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public class Message implements IMessage
   {
       
      
      private var _id:int;
      
      private var _content:ISFSObject;
      
      private var _targetController:int;
      
      private var _isEncrypted:Boolean;
      
      private var _isUDP:Boolean;
      
      private var _packetId:Number = NaN;
      
      public function Message()
      {
         super();
         this._isEncrypted = false;
         this._isUDP = false;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
      }
      
      public function get content() : ISFSObject
      {
         return this._content;
      }
      
      public function set content(obj:ISFSObject) : void
      {
         this._content = obj;
      }
      
      public function get targetController() : int
      {
         return this._targetController;
      }
      
      public function set targetController(value:int) : void
      {
         this._targetController = value;
      }
      
      public function get isEncrypted() : Boolean
      {
         return this._isEncrypted;
      }
      
      public function set isEncrypted(value:Boolean) : void
      {
         this._isEncrypted = value;
      }
      
      public function get isUDP() : Boolean
      {
         return this._isUDP;
      }
      
      public function set isUDP(value:Boolean) : void
      {
         this._isUDP = value;
      }
      
      public function get packetId() : Number
      {
         return this._packetId;
      }
      
      public function set packetId(value:Number) : void
      {
         this._packetId = value;
      }
      
      public function toString() : String
      {
         var str:String = "{ Message id: " + this._id + " }\n";
         str += "{ Dump: }\n";
         return str + this._content.getDump();
      }
   }
}
