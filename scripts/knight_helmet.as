package
{
   import flash.display.MovieClip;
   
   public dynamic class knight_helmet extends MovieClip
   {
       
      
      public function knight_helmet()
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
