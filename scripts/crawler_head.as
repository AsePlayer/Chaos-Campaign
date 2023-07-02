package
{
   import flash.display.MovieClip;
   
   public dynamic class crawler_head extends MovieClip
   {
       
      
      public function crawler_head()
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
