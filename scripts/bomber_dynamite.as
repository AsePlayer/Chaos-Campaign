package
{
   import flash.display.MovieClip;
   
   public dynamic class bomber_dynamite extends MovieClip
   {
       
      
      public var mc:MovieClip;
      
      public function bomber_dynamite()
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
