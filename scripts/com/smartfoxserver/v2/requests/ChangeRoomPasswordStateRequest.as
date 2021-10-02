package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class ChangeRoomPasswordStateRequest extends BaseRequest
   {
      
      public static const KEY_ROOM:String = "r";
      
      public static const KEY_PASS:String = "p";
       
      
      private var _room:Room;
      
      private var _newPass:String;
      
      public function ChangeRoomPasswordStateRequest(room:Room, newPass:String)
      {
         super(BaseRequest.ChangeRoomPassword);
         this._room = room;
         this._newPass = newPass;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(this._room == null)
         {
            errors.push("Provided room is null");
         }
         if(this._newPass == null)
         {
            errors.push("Invalid new room password. It must be a non-null string.");
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("ChangePassState request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         _sfso.putInt(KEY_ROOM,this._room.id);
         _sfso.putUtfString(KEY_PASS,this._newPass);
      }
   }
}
