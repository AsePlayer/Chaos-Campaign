package com.brockw.stickwar.engine
{
   public class DisplayClip extends Entity
   {
       
      
      public var mc:displayMc;
      
      public function DisplayClip()
      {
         super();
         addChild(this.mc = new displayMc());
         scaleX *= 2;
         scaleY *= 2;
      }
   }
}
