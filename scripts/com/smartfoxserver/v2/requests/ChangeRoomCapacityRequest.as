package com.smartfoxserver.v2.requests
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.entities.Room;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     
     public class ChangeRoomCapacityRequest extends BaseRequest
     {
          
          public static const KEY_ROOM:String = "r";
          
          public static const KEY_USER_SIZE:String = "u";
          
          public static const KEY_SPEC_SIZE:String = "s";
           
          
          private var _room:Room;
          
          private var _newMaxUsers:int;
          
          private var _newMaxSpect:int;
          
          public function ChangeRoomCapacityRequest(room:Room, newMaxUsers:int, newMaxSpect:int)
          {
               super(BaseRequest.ChangeRoomCapacity);
               this._room = room;
               this._newMaxUsers = newMaxUsers;
               this._newMaxSpect = newMaxSpect;
          }
          
          override public function validate(sfs:SmartFox) : void
          {
               var errors:Array = [];
               if(this._room == null)
               {
                    errors.push("Provided room is null");
               }
               if(errors.length > 0)
               {
                    throw new SFSValidationError("ChangeRoomCapacity request error",errors);
               }
          }
          
          override public function execute(sfs:SmartFox) : void
          {
               _sfso.putInt(KEY_ROOM,this._room.id);
               _sfso.putInt(KEY_USER_SIZE,this._newMaxUsers);
               _sfso.putInt(KEY_SPEC_SIZE,this._newMaxSpect);
          }
     }
}
