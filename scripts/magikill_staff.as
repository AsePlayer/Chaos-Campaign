package
{
   import flash.display.MovieClip;
   
   public dynamic class magikill_staff extends MovieClip
   {
       
      
      public var fireloopwizstaff:MovieClip;
      
      public function magikill_staff()
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
