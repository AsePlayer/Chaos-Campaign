package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
   import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
   import com.smartfoxserver.v2.util.ArrayUtil;
   
   public class SFSBuddyManager implements IBuddyManager
   {
       
      
      protected var _buddiesByName:Object;
      
      protected var _myVariables:Object;
      
      protected var _myOnlineState:Boolean;
      
      protected var _inited:Boolean;
      
      private var _buddyStates:Array;
      
      private var _sfs:SmartFox;
      
      public function SFSBuddyManager(sfs:SmartFox)
      {
         super();
         this._sfs = sfs;
         this._buddiesByName = {};
         this._myVariables = {};
         this._inited = false;
      }
      
      public function get isInited() : Boolean
      {
         return this._inited;
      }
      
      public function setInited() : void
      {
         this._inited = true;
      }
      
      public function addBuddy(buddy:Buddy) : void
      {
         this._buddiesByName[buddy.name] = buddy;
      }
      
      public function clearAll() : void
      {
         this._buddiesByName = {};
      }
      
      public function removeBuddyById(id:int) : Buddy
      {
         var buddy:Buddy = this.getBuddyById(id);
         if(buddy != null)
         {
            delete this._buddiesByName[buddy.name];
         }
         return buddy;
      }
      
      public function removeBuddyByName(name:String) : Buddy
      {
         var buddy:Buddy = this.getBuddyByName(name);
         if(buddy != null)
         {
            delete this._buddiesByName[name];
         }
         return buddy;
      }
      
      public function getBuddyById(id:int) : Buddy
      {
         var buddy:Buddy = null;
         if(id > -1)
         {
            for each(buddy in this._buddiesByName)
            {
               if(buddy.id == id)
               {
                  return buddy;
               }
            }
         }
         return null;
      }
      
      public function containsBuddy(name:String) : Boolean
      {
         return this.getBuddyByName(name) != null;
      }
      
      public function getBuddyByName(name:String) : Buddy
      {
         return this._buddiesByName[name];
      }
      
      public function getBuddyByNickName(nickName:String) : Buddy
      {
         var buddy:Buddy = null;
         for each(buddy in this._buddiesByName)
         {
            if(buddy.nickName == nickName)
            {
               return buddy;
            }
         }
         return null;
      }
      
      public function get offlineBuddies() : Array
      {
         var buddy:Buddy = null;
         var buddies:Array = [];
         for each(buddy in this._buddiesByName)
         {
            if(!buddy.isOnline)
            {
               buddies.push(buddy);
            }
         }
         return buddies;
      }
      
      public function get onlineBuddies() : Array
      {
         var buddy:Buddy = null;
         var buddies:Array = [];
         for each(buddy in this._buddiesByName)
         {
            if(buddy.isOnline)
            {
               buddies.push(buddy);
            }
         }
         return buddies;
      }
      
      public function get buddyList() : Array
      {
         return ArrayUtil.objToArray(this._buddiesByName);
      }
      
      public function getMyVariable(varName:String) : BuddyVariable
      {
         return this._myVariables[varName] as BuddyVariable;
      }
      
      public function get myVariables() : Array
      {
         return ArrayUtil.objToArray(this._myVariables);
      }
      
      public function get myOnlineState() : Boolean
      {
         if(!this._inited)
         {
            return false;
         }
         var onlineState:Boolean = true;
         var onlineVar:BuddyVariable = this.getMyVariable(ReservedBuddyVariables.BV_ONLINE);
         if(onlineVar != null)
         {
            onlineState = Boolean(onlineVar.getBoolValue());
         }
         return onlineState;
      }
      
      public function get myNickName() : String
      {
         var nickNameVar:BuddyVariable = this.getMyVariable(ReservedBuddyVariables.BV_NICKNAME);
         return nickNameVar != null ? String(nickNameVar.getStringValue()) : null;
      }
      
      public function get myState() : String
      {
         var stateVar:BuddyVariable = this.getMyVariable(ReservedBuddyVariables.BV_STATE);
         return stateVar != null ? String(stateVar.getStringValue()) : null;
      }
      
      public function get buddyStates() : Array
      {
         return this._buddyStates;
      }
      
      public function setMyVariable(bVar:BuddyVariable) : void
      {
         this._myVariables[bVar.name] = bVar;
      }
      
      public function setMyVariables(variables:Array) : void
      {
         var bVar:BuddyVariable = null;
         for each(bVar in variables)
         {
            this.setMyVariable(bVar);
         }
      }
      
      public function setMyOnlineState(isOnline:Boolean) : void
      {
         this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_ONLINE,isOnline));
      }
      
      public function setMyNickName(nickName:String) : void
      {
         this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_NICKNAME,nickName));
      }
      
      public function setMyState(state:String) : void
      {
         this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_STATE,state));
      }
      
      public function setBuddyStates(states:Array) : void
      {
         this._buddyStates = states;
      }
   }
}
