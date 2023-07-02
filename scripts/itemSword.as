package
{
   import flash.display.MovieClip;
   
   public dynamic class itemSword extends MovieClip
   {
       
      
      public function itemSword()
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
