package com.smartfoxserver.v2.requests.buddylist
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.entities.data.ISFSArray;
     import com.smartfoxserver.v2.entities.data.SFSArray;
     import com.smartfoxserver.v2.entities.variables.BuddyVariable;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     import com.smartfoxserver.v2.requests.BaseRequest;
     
     public class SetBuddyVariablesRequest extends BaseRequest
     {
          
          public static const KEY_BUDDY_NAME:String = "bn";
          
          public static const KEY_BUDDY_VARS:String = "bv";
           
          
          private var _buddyVariables:Array;
          
          public function SetBuddyVariablesRequest(buddyVariables:Array)
          {
               super(BaseRequest.SetBuddyVariables);
               this._buddyVariables = buddyVariables;
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
                    errors.push("Can\'t set buddy variables while off-line");
               }
               if(this._buddyVariables == null || this._buddyVariables.length == 0)
               {
                    errors.push("No variables were specified");
               }
               if(errors.length > 0)
               {
                    throw new SFSValidationError("SetBuddyVariables request error",errors);
               }
          }
          
          override public function execute(sfs:SmartFox) : void
          {
               var bVar:BuddyVariable = null;
               var varList:ISFSArray = new SFSArray();
               for each(bVar in this._buddyVariables)
               {
                    varList.addSFSArray(bVar.toSFSArray());
               }
               _sfso.putSFSArray(KEY_BUDDY_VARS,varList);
          }
     }
}
