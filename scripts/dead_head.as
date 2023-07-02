package
{
   import flash.display.MovieClip;
   
   public dynamic class dead_head extends MovieClip
   {
       
      
      public function dead_head()
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
