package com.smartfoxserver.v2.requests
{
   public class RoomPermissions
   {
       
      
      private var _allowNameChange:Boolean;
      
      private var _allowPasswordStateChange:Boolean;
      
      private var _allowPublicMessages:Boolean;
      
      private var _allowResizing:Boolean;
      
      public function RoomPermissions()
      {
         super();
      }
      
      public function get allowNameChange() : Boolean
      {
         return this._allowNameChange;
      }
      
      public function set allowNameChange(value:Boolean) : void
      {
         this._allowNameChange = value;
      }
      
      public function get allowPasswordStateChange() : Boolean
      {
         return this._allowPasswordStateChange;
      }
      
      public function set allowPasswordStateChange(value:Boolean) : void
      {
         this._allowPasswordStateChange = value;
      }
      
      public function get allowPublicMessages() : Boolean
      {
         return this._allowPublicMessages;
      }
      
      public function set allowPublicMessages(value:Boolean) : void
      {
         this._allowPublicMessages = value;
      }
      
      public function get allowResizing() : Boolean
      {
         return this._allowResizing;
      }
      
      public function set allowResizing(value:Boolean) : void
      {
         this._allowResizing = value;
      }
   }
}
