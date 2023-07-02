package
{
   import flash.display.MovieClip;
   
   public dynamic class miner_pickaxe extends MovieClip
   {
       
      
      public function miner_pickaxe()
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
