package com.smartfoxserver.v2.logging
{
     import com.smartfoxserver.v2.core.BaseEvent;
     import flash.events.Event;
     
     public class LoggerEvent extends BaseEvent
     {
          
          public static const DEBUG:String = "debug";
          
          public static const INFO:String = "info";
          
          public static const WARNING:String = "warn";
          
          public static const ERROR:String = "error";
           
          
          public function LoggerEvent(type:String, params:Object = null)
          {
               super(type,params);
          }
          
          override public function clone() : Event
          {
               return new LoggerEvent(this.type,this.params);
          }
          
          override public function toString() : String
          {
               return formatToString("LoggerEvent","type","bubbles","cancelable","eventPhase","params");
          }
     }
}
