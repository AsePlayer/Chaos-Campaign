package com.smartfoxserver.v2.requests
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.entities.Room;
     import com.smartfoxserver.v2.entities.data.ISFSArray;
     import com.smartfoxserver.v2.entities.data.SFSArray;
     import com.smartfoxserver.v2.entities.variables.RoomVariable;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     
     public class SetRoomVariablesRequest extends BaseRequest
     {
          
          public static const KEY_VAR_ROOM:String = "r";
          
          public static const KEY_VAR_LIST:String = "vl";
           
          
          private var _roomVariables:Array;
          
          private var _room:Room;
          
          public function SetRoomVariablesRequest(roomVariables:Array, room:Room = null)
          {
               super(BaseRequest.SetRoomVariables);
               this._roomVariables = roomVariables;
               this._room = room;
          }
          
          override public function validate(sfs:SmartFox) : void
          {
               var errors:Array = [];
               if(this._room != null)
               {
                    if(!this._room.containsUser(sfs.mySelf))
                    {
                         errors.push("You are not joined in the target room");
                    }
               }
               else if(sfs.lastJoinedRoom == null)
               {
                    errors.push("You are not joined in any rooms");
               }
               if(this._roomVariables == null || this._roomVariables.length == 0)
               {
                    errors.push("No variables were specified");
               }
               if(errors.length > 0)
               {
                    throw new SFSValidationError("SetRoomVariables request error",errors);
               }
          }
          
          override public function execute(sfs:SmartFox) : void
          {
               var rv:RoomVariable = null;
               var varList:ISFSArray = SFSArray.newInstance();
               for each(rv in this._roomVariables)
               {
                    varList.addSFSArray(rv.toSFSArray());
               }
               if(this._room == null)
               {
                    this._room = sfs.lastJoinedRoom;
               }
               _sfso.putSFSArray(KEY_VAR_LIST,varList);
               _sfso.putInt(KEY_VAR_ROOM,this._room.id);
          }
     }
}
