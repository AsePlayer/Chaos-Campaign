package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class SubscribeRoomGroupRequest extends BaseRequest
   {
      
      public static const KEY_GROUP_ID:String = "g";
      
      public static const KEY_ROOM_LIST:String = "rl";
       
      
      private var _groupId:String;
      
      public function SubscribeRoomGroupRequest(groupId:String)
      {
         super(BaseRequest.SubscribeRoomGroup);
         this._groupId = groupId;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(this._groupId == null || this._groupId.length == 0)
         {
            errors.push("Invalid groupId. Must be a string with at least 1 character.");
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("SubscribeGroup request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         _sfso.putUtfString(KEY_GROUP_ID,this._groupId);
      }
   }
}
