package
{
   import flash.display.MovieClip;
   
   public dynamic class bombers_head extends MovieClip
   {
       
      
      public function bombers_head()
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
