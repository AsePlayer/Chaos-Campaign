package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class ChangeRoomNameRequest extends BaseRequest
   {
      
      public static const KEY_ROOM:String = "r";
      
      public static const KEY_NAME:String = "n";
       
      
      private var _room:Room;
      
      private var _newName:String;
      
      public function ChangeRoomNameRequest(room:Room, newName:String)
      {
         super(BaseRequest.ChangeRoomName);
         this._room = room;
         this._newName = newName;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(this._room == null)
         {
            errors.push("Provided room is null");
         }
         if(this._newName == null || this._newName.length == 0)
         {
            errors.push("Invalid new room name. It must be a non-null and non-empty string.");
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("ChangeRoomName request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         _sfso.putInt(KEY_ROOM,this._room.id);
         _sfso.putUtfString(KEY_NAME,this._newName);
      }
   }
}
