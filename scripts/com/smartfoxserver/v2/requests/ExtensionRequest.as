package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class ExtensionRequest extends BaseRequest
   {
      
      public static const KEY_CMD:String = "c";
      
      public static const KEY_PARAMS:String = "p";
      
      public static const KEY_ROOM:String = "r";
       
      
      private var _extCmd:String;
      
      private var _params:ISFSObject;
      
      private var _room:Room;
      
      private var _useUDP:Boolean;
      
      public function ExtensionRequest(extCmd:String, params:ISFSObject = null, room:Room = null, useUDP:Boolean = false)
      {
         super(BaseRequest.CallExtension);
         _targetController = 1;
         this._extCmd = extCmd;
         this._params = params;
         this._room = room;
         this._useUDP = useUDP;
         if(this._params == null)
         {
            this._params = new SFSObject();
         }
      }
      
      public function get useUDP() : Boolean
      {
         return this._useUDP;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(this._extCmd == null || this._extCmd.length == 0)
         {
            errors.push("Missing extension command");
         }
         if(this._params == null)
         {
            errors.push("Missing extension parameters");
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("ExtensionCall request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         _sfso.putUtfString(KEY_CMD,this._extCmd);
         _sfso.putInt(KEY_ROOM,this._room == null ? -1 : int(this._room.id));
         _sfso.putSFSObject(KEY_PARAMS,this._params);
      }
   }
}
