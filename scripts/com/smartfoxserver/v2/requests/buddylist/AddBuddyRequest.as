package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class AddBuddyRequest extends BaseRequest
   {
      
      public static const KEY_BUDDY_NAME:String = "bn";
       
      
      private var _name:String;
      
      public function AddBuddyRequest(buddyName:String)
      {
         super(BaseRequest.AddBuddy);
         this._name = buddyName;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(!sfs.buddyManager.isInited)
         {
            errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
         }
         if(this._name == null || this._name.length < 1)
         {
            errors.push("Invalid buddy name: " + this._name);
         }
         if(sfs.buddyManager.myOnlineState == false)
         {
            errors.push("Can\'t add buddy while off-line");
         }
         var buddy:Buddy = sfs.buddyManager.getBuddyByName(this._name);
         if(buddy != null && !buddy.isTemp)
         {
            errors.push("Can\'t add buddy, it is already in your list: " + this._name);
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
