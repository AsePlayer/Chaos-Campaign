package
{
   import flash.display.MovieClip;
   
   public dynamic class ninja_katana extends MovieClip
   {
       
      
      public function ninja_katana()
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
