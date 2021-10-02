package com.smartfoxserver.v2.core
{
   import flash.events.Event;
   
   public class BaseEvent extends Event
   {
       
      
      public var params:Object;
      
      public function BaseEvent(type:String, params:Object = null)
      {
         super(type);
         this.params = params;
      }
      
      override public function clone() : Event
      {
         return new BaseEvent(this.type,this.params);
      }
      
      override public function toString() : String
      {
         return formatToString("BaseEvent","type","bubbles","cancelable","eventPhase","params");
      }
   }
}
