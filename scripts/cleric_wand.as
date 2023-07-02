package
{
   import flash.display.MovieClip;
   
   public dynamic class cleric_wand extends MovieClip
   {
       
      
      public function cleric_wand()
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
