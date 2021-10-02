package com.smartfoxserver.v2.entities.match
{
   public class LogicOperator
   {
      
      public static const AND:LogicOperator = new LogicOperator("AND");
      
      public static const OR:LogicOperator = new LogicOperator("OR");
       
      
      private var _id:String;
      
      public function LogicOperator(id:String)
      {
         super();
         this._id = id;
      }
      
      public function get id() : String
      {
         return this._id;
      }
   }
}
