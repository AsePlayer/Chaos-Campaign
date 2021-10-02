package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.match.MatchExpression;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class FindRoomsRequest extends BaseRequest
   {
      
      public static const KEY_EXPRESSION:String = "e";
      
      public static const KEY_GROUP:String = "g";
      
      public static const KEY_LIMIT:String = "l";
      
      public static const KEY_FILTERED_ROOMS:String = "fr";
       
      
      private var _matchExpr:MatchExpression;
      
      private var _groupId:String;
      
      private var _limit:int;
      
      public function FindRoomsRequest(expr:MatchExpression, groupId:String = null, limit:int = 0)
      {
         super(BaseRequest.FindRooms);
         this._matchExpr = expr;
         this._groupId = groupId;
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
            throw new SFSValidationError("FindRooms request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         _sfso.putSFSArray(KEY_EXPRESSION,this._matchExpr.toSFSArray());
         if(this._groupId != null)
         {
            _sfso.putUtfString(KEY_GROUP,this._groupId);
         }
         if(this._limit > 0)
         {
            _sfso.putShort(KEY_LIMIT,this._limit);
         }
      }
   }
}
