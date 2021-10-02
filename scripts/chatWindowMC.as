package
{
   import fl.containers.ScrollPane;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public dynamic class chatWindowMC extends MovieClip
   {
       
      
      public var chatInput:TextField;
      
      public var blockingFrame:MovieClip;
      
      public var sendButton:SimpleButton;
      
      public var minimizeButton:SimpleButton;
      
      public var closeButton:SimpleButton;
      
      public var scroll:ScrollPane;
      
      public var chatOutput:TextField;
      
      public function chatWindowMC()
      {
         super();
      }
   }
}
