package com.smartfoxserver.v2.entities
{
     import com.smartfoxserver.v2.entities.data.ISFSArray;
     import com.smartfoxserver.v2.entities.variables.BuddyVariable;
     import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
     import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
     import com.smartfoxserver.v2.util.ArrayUtil;
     
     public class SFSBuddy implements Buddy
     {
           
          
          protected var _name:String;
          
          protected var _id:int;
          
          protected var _isBlocked:Boolean;
          
          protected var _variables:Object;
          
          protected var _isTemp:Boolean;
          
          public function SFSBuddy(id:int, name:String, isBlocked:Boolean = false, isTemp:Boolean = false)
          {
               super();
               this._id = id;
               this._name = name;
               this._isBlocked = isBlocked;
               this._variables = {};
               this._isTemp = isTemp;
          }
          
          public static function fromSFSArray(arr:ISFSArray) : Buddy
          {
               var buddy:Buddy = new SFSBuddy(arr.getInt(0),arr.getUtfString(1),arr.getBool(2),arr.size() > 3 ? Boolean(arr.getBool(4)) : false);
               var bVarsData:ISFSArray = arr.getSFSArray(3);
               for(var j:int = 0; j < bVarsData.size(); j++)
               {
                    buddy.setVariable(SFSBuddyVariable.fromSFSArray(bVarsData.getSFSArray(j)));
               }
               return buddy;
          }
          
          public function get id() : int
          {
               return this._id;
          }
          
          public function get name() : String
          {
               return this._name;
          }
          
          public function get isBlocked() : Boolean
          {
               return this._isBlocked;
          }
          
          public function get isTemp() : Boolean
          {
               return this._isTemp;
          }
          
          public function get isOnline() : Boolean
          {
               var bv:BuddyVariable = this.getVariable(ReservedBuddyVariables.BV_ONLINE);
               var onlineStateVar:Boolean = bv == null ? true : Boolean(bv.getBoolValue());
               return onlineStateVar && this._id > -1;
          }
          
          public function get state() : String
          {
               var bv:BuddyVariable = this.getVariable(ReservedBuddyVariables.BV_STATE);
               return bv == null ? null : String(bv.getStringValue());
          }
          
          public function get nickName() : String
          {
               var bv:BuddyVariable = this.getVariable(ReservedBuddyVariables.BV_NICKNAME);
               return bv == null ? null : String(bv.getStringValue());
          }
          
          public function get variables() : Array
          {
               return ArrayUtil.objToArray(this._variables);
          }
          
          public function getVariable(varName:String) : BuddyVariable
          {
               return this._variables[varName];
          }
          
          public function getOfflineVariables() : Array
          {
               var item:BuddyVariable = null;
               var offlineVars:Array = [];
               for each(item in this._variables)
               {
                    if(item.name.charAt(0) == SFSBuddyVariable.OFFLINE_PREFIX)
                    {
                         offlineVars.push(item);
                    }
               }
               return offlineVars;
          }
          
          public function getOnlineVariables() : Array
          {
               var item:BuddyVariable = null;
               var onlineVars:Array = [];
               for each(item in this._variables)
               {
                    if(item.name.charAt(0) != SFSBuddyVariable.OFFLINE_PREFIX)
                    {
                         onlineVars.push(item);
                    }
               }
               return onlineVars;
          }
          
          public function containsVariable(varName:String) : Boolean
          {
               return this._variables[varName] != null;
          }
          
          public function setVariable(bVar:BuddyVariable) : void
          {
               this._variables[bVar.name] = bVar;
          }
          
          public function setVariables(variables:Array) : void
          {
               var bVar:BuddyVariable = null;
               for each(bVar in variables)
               {
                    this.setVariable(bVar);
               }
          }
          
          public function setId(id:int) : void
          {
               this._id = id;
          }
          
          public function setBlocked(value:Boolean) : void
          {
               this._isBlocked = value;
          }
          
          public function removeVariable(varName:String) : void
          {
               delete this._variables[varName];
          }
          
          public function clearVolatileVariables() : void
          {
               var bVar:BuddyVariable = null;
               for each(bVar in this.variables)
               {
                    if(bVar.name.charAt(0) != SFSBuddyVariable.OFFLINE_PREFIX)
                    {
                         this.removeVariable(bVar.name);
                    }
               }
          }
          
          public function toString() : String
          {
               return "[Buddy: " + this.name + ", id: " + this.id + "]";
          }
     }
}
