package com.smartfoxserver.v2.exceptions
{
     public class SFSValidationError extends Error
     {
           
          
          private var _errors:Array;
          
          public function SFSValidationError(message:String, errors:Array, errorId:int = 0)
          {
               super(message,errorId);
               this._errors = errors;
          }
          
          public function get errors() : Array
          {
               return this._errors;
          }
     }
}
