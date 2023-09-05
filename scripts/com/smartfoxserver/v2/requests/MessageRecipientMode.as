package com.smartfoxserver.v2.requests
{
     public class MessageRecipientMode
     {
          
          public static const TO_USER:int = 0;
          
          public static const TO_ROOM:int = 1;
          
          public static const TO_GROUP:int = 2;
          
          public static const TO_ZONE:int = 3;
           
          
          private var _target;
          
          private var _mode:int;
          
          public function MessageRecipientMode(mode:int, target:*)
          {
               super();
               if(mode < TO_USER || mode > TO_ZONE)
               {
                    throw new ArgumentError("Illegal recipient mode: " + mode);
               }
               this._mode = mode;
               this._target = target;
          }
          
          public function get mode() : int
          {
               return this._mode;
          }
          
          public function get target() : *
          {
               return this._target;
          }
     }
}
