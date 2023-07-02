package
{
   import flash.display.MovieClip;
   
   public dynamic class pauseMenuMultiplayer extends MovieClip
   {
       
      
      public var buttons:MovieClip;
      
      public var musicToggle:MovieClip;
      
      public var soundToggle:MovieClip;
      
      public var confirmation:MovieClip;
      
      public function pauseMenuMultiplayer()
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
