package com.smartfoxserver.v2.requests.buddylist
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.entities.Buddy;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     import com.smartfoxserver.v2.requests.BaseRequest;
     
     public class BlockBuddyRequest extends BaseRequest
     {
          
          public static const KEY_BUDDY_NAME:String = "bn";
          
          public static const KEY_BUDDY_BLOCK_STATE:String = "bs";
           
          
          private var _buddyName:String;
          
          private var _blocked:Boolean;
          
          public function BlockBuddyRequest(buddyName:String, blocked:Boolean)
          {
               super(BaseRequest.BlockBuddy);
               this._buddyName = buddyName;
               this._blocked = blocked;
          }
          
          override public function validate(sfs:SmartFox) : void
          {
               var errors:Array = [];
               if(!sfs.buddyManager.isInited)
               {
                    errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
               }
               if(this._buddyName == null || this._buddyName.length < 1)
               {
                    errors.push("Invalid buddy name: " + this._buddyName);
               }
               if(sfs.buddyManager.myOnlineState == false)
               {
                    errors.push("Can\'t block buddy while off-line");
               }
               var buddy:Buddy = sfs.buddyManager.getBuddyByName(this._buddyName);
               if(buddy == null)
               {
                    errors.push("Can\'t block buddy, it\'s not in your list: " + this._buddyName);
               }
               else if(buddy.isBlocked == this._blocked)
               {
                    errors.push("BuddyBlock flag is already in the requested state: " + this._blocked + ", for buddy: " + buddy);
               }
               if(errors.length > 0)
               {
                    throw new SFSValidationError("BuddyList request error",errors);
               }
          }
          
          override public function execute(sfs:SmartFox) : void
          {
               _sfso.putUtfString(BlockBuddyRequest.KEY_BUDDY_NAME,this._buddyName);
               _sfso.putBool(BlockBuddyRequest.KEY_BUDDY_BLOCK_STATE,this._blocked);
          }
     }
}
