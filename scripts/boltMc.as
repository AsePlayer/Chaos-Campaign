package
{
   import flash.display.MovieClip;
   
   public dynamic class boltMc extends MovieClip
   {
       
      
      public var fire:MovieClip;
      
      public function boltMc()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
