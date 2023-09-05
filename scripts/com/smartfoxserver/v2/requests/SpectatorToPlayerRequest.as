package com.smartfoxserver.v2.requests
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.entities.Room;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     
     public class SpectatorToPlayerRequest extends BaseRequest
     {
          
          public static const KEY_ROOM_ID:String = "r";
          
          public static const KEY_USER_ID:String = "u";
          
          public static const KEY_PLAYER_ID:String = "p";
           
          
          private var _room:Room;
          
          public function SpectatorToPlayerRequest(targetRoom:Room = null)
          {
               super(BaseRequest.SpectatorToPlayer);
               this._room = targetRoom;
          }
          
          override public function validate(sfs:SmartFox) : void
          {
               var errors:Array = [];
               if(sfs.joinedRooms.length < 1)
               {
                    errors.push("You are not joined in any rooms");
               }
               if(errors.length > 0)
               {
                    throw new SFSValidationError("SpectatorToPlayer request error",errors);
               }
          }
          
          override public function execute(sfs:SmartFox) : void
          {
               if(this._room == null)
               {
                    this._room = sfs.lastJoinedRoom;
               }
               _sfso.putInt(KEY_ROOM_ID,this._room.id);
          }
     }
}
