package com.google.analytics.debug
{
   import com.google.analytics.core.GIFRequest;
   import flash.display.DisplayObject;
   import flash.net.URLRequest;
   
   public interface ILayout
   {
       
      
      function createAlert(message:String) : void;
      
      function addToStage(visual:DisplayObject) : void;
      
      function createGIFRequestAlert(message:String, request:URLRequest, ref:GIFRequest) : void;
      
      function createWarning(message:String) : void;
      
      function createPanel(name:String, width:uint, height:uint) : void;
      
      function createInfo(message:String) : void;
      
      function createFailureAlert(message:String) : void;
      
      function addToPanel(name:String, visual:DisplayObject) : void;
      
      function init() : void;
      
      function createSuccessAlert(message:String) : void;
      
      function createVisualDebug() : void;
      
      function destroy() : void;
      
      function bringToFront(visual:DisplayObject) : void;
      
      function isAvailable() : Boolean;
   }
}
