package
{
   import flash.display.MovieClip;
   
   public dynamic class giant_weapon extends MovieClip
   {
       
      
      public function giant_weapon()
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
