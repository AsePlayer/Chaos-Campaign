package
{
   import flash.display.MovieClip;
   
   public dynamic class ninja_head extends MovieClip
   {
       
      
      public function ninja_head()
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
