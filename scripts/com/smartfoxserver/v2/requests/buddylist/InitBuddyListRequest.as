package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class InitBuddyListRequest extends BaseRequest
   {
      
      public static const KEY_BLIST:String = "bl";
      
      public static const KEY_BUDDY_STATES:String = "bs";
      
      public static const KEY_MY_VARS:String = "mv";
       
      
      public function InitBuddyListRequest()
      {
         super(BaseRequest.InitBuddyList);
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(sfs.buddyManager.isInited)
         {
            errors.push("Buddy List is already initialized.");
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("InitBuddyRequest error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
      }
   }
}
