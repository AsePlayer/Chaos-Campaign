package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class CreateRoomRequest extends BaseRequest
   {
      
      public static const KEY_ROOM:String = "r";
      
      public static const KEY_NAME:String = "n";
      
      public static const KEY_PASSWORD:String = "p";
      
      public static const KEY_GROUP_ID:String = "g";
      
      public static const KEY_ISGAME:String = "ig";
      
      public static const KEY_MAXUSERS:String = "mu";
      
      public static const KEY_MAXSPECTATORS:String = "ms";
      
      public static const KEY_MAXVARS:String = "mv";
      
      public static const KEY_ROOMVARS:String = "rv";
      
      public static const KEY_PERMISSIONS:String = "pm";
      
      public static const KEY_EVENTS:String = "ev";
      
      public static const KEY_EXTID:String = "xn";
      
      public static const KEY_EXTCLASS:String = "xc";
      
      public static const KEY_EXTPROP:String = "xp";
      
      public static const KEY_AUTOJOIN:String = "aj";
      
      public static const KEY_ROOM_TO_LEAVE:String = "rl";
       
      
      private var _settings:com.smartfoxserver.v2.requests.RoomSettings;
      
      private var _autoJoin:Boolean;
      
      private var _roomToLeave:Room;
      
      public function CreateRoomRequest(settings:com.smartfoxserver.v2.requests.RoomSettings, autoJoin:Boolean = false, roomToLeave:Room = null)
      {
         super(BaseRequest.CreateRoom);
         this._settings = settings;
         this._autoJoin = autoJoin;
         this._roomToLeave = roomToLeave;
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         var roomVars:ISFSArray = null;
         var item:* = undefined;
         var rVar:RoomVariable = null;
         var sfsPermissions:Array = null;
         var sfsEvents:Array = null;
         _sfso.putUtfString(KEY_NAME,this._settings.name);
         _sfso.putUtfString(KEY_GROUP_ID,this._settings.groupId);
         _sfso.putUtfString(KEY_PASSWORD,this._settings.password);
         _sfso.putBool(KEY_ISGAME,this._settings.isGame);
         _sfso.putShort(KEY_MAXUSERS,this._settings.maxUsers);
         _sfso.putShort(KEY_MAXSPECTATORS,this._settings.maxSpectators);
         _sfso.putShort(KEY_MAXVARS,this._settings.maxVariables);
         if(this._settings.variables != null && this._settings.variables.length > 0)
         {
            roomVars = SFSArray.newInstance();
            for each(item in this._settings.variables)
            {
               if(item is RoomVariable)
               {
                  rVar = item as RoomVariable;
                  roomVars.addSFSArray(rVar.toSFSArray());
               }
            }
            _sfso.putSFSArray(KEY_ROOMVARS,roomVars);
         }
         if(this._settings.permissions != null)
         {
            sfsPermissions = [];
            sfsPermissions.push(this._settings.permissions.allowNameChange);
            sfsPermissions.push(this._settings.permissions.allowPasswordStateChange);
            sfsPermissions.push(this._settings.permissions.allowPublicMessages);
            sfsPermissions.push(this._settings.permissions.allowResizing);
            _sfso.putBoolArray(KEY_PERMISSIONS,sfsPermissions);
         }
         if(this._settings.events != null)
         {
            sfsEvents = [];
            sfsEvents.push(this._settings.events.allowUserEnter);
            sfsEvents.push(this._settings.events.allowUserExit);
            sfsEvents.push(this._settings.events.allowUserCountChange);
            sfsEvents.push(this._settings.events.allowUserVariablesUpdate);
            _sfso.putBoolArray(KEY_EVENTS,sfsEvents);
         }
         if(this._settings.extension != null)
         {
            _sfso.putUtfString(KEY_EXTID,this._settings.extension.id);
            _sfso.putUtfString(KEY_EXTCLASS,this._settings.extension.className);
            if(this._settings.extension.propertiesFile != null && this._settings.extension.propertiesFile.length > 0)
            {
               _sfso.putUtfString(KEY_EXTPROP,this._settings.extension.propertiesFile);
            }
         }
         _sfso.putBool(KEY_AUTOJOIN,this._autoJoin);
         if(this._roomToLeave != null)
         {
            _sfso.putInt(KEY_ROOM_TO_LEAVE,this._roomToLeave.id);
         }
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(this._settings.name == null || this._settings.name.length == 0)
         {
            errors.push("Missing room name");
         }
         if(this._settings.maxUsers <= 0)
         {
            errors.push("maxUsers must be > 0");
         }
         if(this._settings.extension != null)
         {
            if(this._settings.extension.className == null || this._settings.extension.className.length == 0)
            {
               errors.push("Missing Extension class name");
            }
            if(this._settings.extension.id == null || this._settings.extension.id.length == 0)
            {
               errors.push("Missing Extension id");
            }
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("CreateRoom request error",errors);
         }
      }
   }
}
