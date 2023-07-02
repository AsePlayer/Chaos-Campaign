package
{
   import flash.display.MovieClip;
   
   public dynamic class miner_bag extends MovieClip
   {
       
      
      public function miner_bag()
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
