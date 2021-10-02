package
{
   import flash.display.MovieClip;
   
   public dynamic class magikill_hat extends MovieClip
   {
       
      
      public function magikill_hat()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
