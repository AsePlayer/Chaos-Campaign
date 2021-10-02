package com.google.analytics.events
{
   import com.google.analytics.AnalyticsTracker;
   import flash.events.Event;
   
   public class AnalyticsEvent extends Event
   {
      
      public static const READY:String = "ready";
       
      
      public var tracker:AnalyticsTracker;
      
      public function AnalyticsEvent(type:String, tracker:AnalyticsTracker, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.tracker = tracker;
      }
      
      override public function clone() : Event
      {
         return new AnalyticsEvent(type,tracker,bubbles,cancelable);
      }
   }
}
