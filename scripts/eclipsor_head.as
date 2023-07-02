package
{
   import flash.display.MovieClip;
   
   public dynamic class eclipsor_head extends MovieClip
   {
       
      
      public function eclipsor_head()
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
