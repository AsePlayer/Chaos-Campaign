package com.google.analytics.data
{
   public interface Cookie
   {
       
      
      function fromSharedObject(data:Object) : void;
      
      function toURLString() : String;
      
      function get creation() : Date;
      
      function toSharedObject() : Object;
      
      function isExpired() : Boolean;
      
      function set creation(value:Date) : void;
      
      function set expiration(value:Date) : void;
      
      function get expiration() : Date;
   }
}
