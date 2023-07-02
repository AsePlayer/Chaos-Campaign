package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public dynamic class campaignMenuMc extends MovieClip
   {
       
      
      public var creditsScreen:MovieClip;
      
      public var introOverlay:MovieClip;
      
      public var difficultySelectOverlay:MovieClip;
      
      public var stickpageLink:MovieClip;
      
      public var backButton:SimpleButton;
      
      public var musicToggle:MovieClip;
      
      public var difficultyPanel:MovieClip;
      
      public var mainPanel:MovieClip;
      
      public var version:TextField;
      
      public var introPanel:MovieClip;
      
      public var creditsButton:SimpleButton;
      
      public var introBrokenMc:MovieClip;
      
      public var newOrContinuePanel:MovieClip;
      
      public var fade:MovieClip;
      
      public function campaignMenuMc()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
