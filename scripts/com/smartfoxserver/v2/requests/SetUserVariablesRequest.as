package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class SetUserVariablesRequest extends BaseRequest
   {
      
      public static const KEY_USER:String = "u";
      
      public static const KEY_VAR_LIST:String = "vl";
       
      
      private var _userVariables:Array;
      
      public function SetUserVariablesRequest(userVariables:Array)
      {
         super(BaseRequest.SetUserVariables);
         this._userVariables = userVariables;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(this._userVariables == null || this._userVariables.length == 0)
         {
            errors.push("No variables were specified");
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("SetUserVariables request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         var uVar:UserVariable = null;
         var varList:ISFSArray = SFSArray.newInstance();
         for each(uVar in this._userVariables)
         {
            varList.addSFSArray(uVar.toSFSArray());
         }
         _sfso.putSFSArray(KEY_VAR_LIST,varList);
      }
   }
}
