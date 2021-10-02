package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.match.MatchExpression;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.logging.Logger;
   
   public class FindUsersRequest extends BaseRequest
   {
      
      public static const KEY_EXPRESSION:String = "e";
      
      public static const KEY_GROUP:String = "g";
      
      public static const KEY_ROOM:String = "r";
      
      public static const KEY_LIMIT:String = "l";
      
      public static const KEY_FILTERED_USERS:String = "fu";
       
      
      private var _matchExpr:MatchExpression;
      
      private var _target;
      
      private var _limit:int;
      
      public function FindUsersRequest(expr:MatchExpression, target:* = null, limit:int = 0)
      {
         super(BaseRequest.FindUsers);
         this._matchExpr = expr;
         this._target = target;
         this._limit = limit;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(this._matchExpr == null)
         {
            errors.push("Missing Match Expression");
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("FindUsers request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         _sfso.putSFSArray(KEY_EXPRESSION,this._matchExpr.toSFSArray());
         if(this._target != null)
         {
            if(this._target is Room)
            {
               _sfso.putInt(KEY_ROOM,(this._target as Room).id);
            }
            else if(this._target is String)
            {
               _sfso.putUtfString(KEY_GROUP,this._target);
            }
            else
            {
               Logger.getInstance().warn("Unsupport target type for FindUsersRequest: " + this._target);
            }
         }
         if(this._limit > 0)
         {
            _sfso.putShort(KEY_LIMIT,this._limit);
         }
      }
   }
}
