package
{
   import flash.display.MovieClip;
   
   public dynamic class knight_weapon extends MovieClip
   {
       
      
      public function knight_weapon()
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
