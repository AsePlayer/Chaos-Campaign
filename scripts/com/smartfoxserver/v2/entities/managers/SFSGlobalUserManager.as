package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.User;
   
   public class SFSGlobalUserManager extends SFSUserManager
   {
       
      
      private var _roomRefCount:Array;
      
      public function SFSGlobalUserManager(sfs:SmartFox)
      {
         super(sfs);
         this._roomRefCount = [];
      }
      
      override public function addUser(user:User) : void
      {
         if(this._roomRefCount[user] == null)
         {
            super._addUser(user);
            this._roomRefCount[user] = 1;
         }
         else
         {
            super._addUser(user);
            ++this._roomRefCount[user];
         }
      }
      
      override public function removeUser(user:User) : void
      {
         if(this._roomRefCount != null)
         {
            if(this._roomRefCount[user] < 1)
            {
               _log.warn("GlobalUserManager RefCount is already at zero. User: " + user);
               return;
            }
            --this._roomRefCount[user];
            if(this._roomRefCount[user] == 0)
            {
               super.removeUser(user);
               delete this._roomRefCount[user];
            }
         }
         else
         {
            _log.warn("Can\'t remove User from GlobalUserManager. RefCount missing. User: " + user);
         }
      }
      
      private function dumpRefCount() : void
      {
      }
   }
}
