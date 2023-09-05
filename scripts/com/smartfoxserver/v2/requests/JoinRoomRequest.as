package com.smartfoxserver.v2.requests
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.entities.Room;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     
     public class JoinRoomRequest extends BaseRequest
     {
          
          public static const KEY_ROOM:String = "r";
          
          public static const KEY_USER_LIST:String = "ul";
          
          public static const KEY_ROOM_NAME:String = "n";
          
          public static const KEY_ROOM_ID:String = "i";
          
          public static const KEY_PASS:String = "p";
          
          public static const KEY_ROOM_TO_LEAVE:String = "rl";
          
          public static const KEY_AS_SPECTATOR:String = "sp";
           
          
          private var _id:int = -1;
          
          private var _name:String;
          
          private var _pass:String;
          
          private var _roomIdToLeave:Number;
          
          private var _asSpectator:Boolean;
          
          public function JoinRoomRequest(id:*, pass:String = null, roomIdToLeave:Number = NaN, asSpect:Boolean = false)
          {
               super(BaseRequest.JoinRoom);
               if(id is String)
               {
                    this._name = id;
               }
               else if(id is Number)
               {
                    this._id = id;
               }
               else if(id is Room)
               {
                    this._id = (id as Room).id;
               }
               this._pass = pass;
               this._roomIdToLeave = roomIdToLeave;
               this._asSpectator = asSpect;
          }
          
          override public function validate(sfs:SmartFox) : void
          {
               var errors:Array = [];
               if(this._id < 0 && this._name == null)
               {
                    errors.push("Missing Room id or name, you should provide at least one");
               }
               if(errors.length > 0)
               {
                    throw new SFSValidationError("JoinRoom request error",errors);
               }
          }
          
          override public function execute(sfs:SmartFox) : void
          {
               if(this._id > -1)
               {
                    _sfso.putInt(KEY_ROOM_ID,this._id);
               }
               else if(this._name != null)
               {
                    _sfso.putUtfString(KEY_ROOM_NAME,this._name);
               }
               if(this._pass != null)
               {
                    _sfso.putUtfString(KEY_PASS,this._pass);
               }
               if(!isNaN(this._roomIdToLeave))
               {
                    _sfso.putInt(KEY_ROOM_TO_LEAVE,this._roomIdToLeave);
               }
               if(this._asSpectator)
               {
                    _sfso.putBool(KEY_AS_SPECTATOR,this._asSpectator);
               }
          }
     }
}
