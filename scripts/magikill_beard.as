package
{
   import flash.display.MovieClip;
   
   public dynamic class magikill_beard extends MovieClip
   {
       
      
      public function magikill_beard()
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
