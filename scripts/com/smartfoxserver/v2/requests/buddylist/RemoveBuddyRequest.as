package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class RemoveBuddyRequest extends BaseRequest
   {
      
      public static const KEY_BUDDY_NAME:String = "bn";
       
      
      private var _name:String;
      
      public function RemoveBuddyRequest(buddyName:String)
      {
         super(BaseRequest.RemoveBuddy);
         this._name = buddyName;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(!sfs.buddyManager.isInited)
         {
            errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
         }
         if(sfs.buddyManager.myOnlineState == false)
         {
            errors.push("Can\'t remove buddy while off-line");
         }
         if(!sfs.buddyManager.containsBuddy(this._name))
         {
            errors.push("Can\'t remove buddy, it\'s not in your list: " + this._name);
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("BuddyList request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         _sfso.putUtfString(KEY_BUDDY_NAME,this._name);
      }
   }
}
