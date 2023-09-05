package com.smartfoxserver.v2.requests.buddylist
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     import com.smartfoxserver.v2.requests.BaseRequest;
     
     public class GoOnlineRequest extends BaseRequest
     {
          
          public static const KEY_ONLINE:String = "o";
          
          public static const KEY_BUDDY_NAME:String = "bn";
          
          public static const KEY_BUDDY_ID:String = "bi";
           
          
          private var _online:Boolean;
          
          public function GoOnlineRequest(online:Boolean)
          {
               super(BaseRequest.GoOnline);
               this._online = online;
          }
          
          override public function validate(sfs:SmartFox) : void
          {
               var errors:Array = [];
               if(!sfs.buddyManager.isInited)
               {
                    errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
               }
               if(errors.length > 0)
               {
                    throw new SFSValidationError("GoOnline request error",errors);
               }
          }
          
          override public function execute(sfs:SmartFox) : void
          {
               sfs.buddyManager.setMyOnlineState(this._online);
               _sfso.putBool(KEY_ONLINE,this._online);
          }
     }
}
