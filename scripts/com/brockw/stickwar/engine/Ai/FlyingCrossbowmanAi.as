package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.FlyingCrossbowman;
   
   public class FlyingCrossbowmanAi extends RangedAi
   {
       
      
      public function FlyingCrossbowmanAi(s:FlyingCrossbowman)
      {
         super(s);
         unit = s;
      }
      
      override public function update(game:StickWar) : void
      {
         checkNextMove(game);
         super.update(game);
      }
   }
}
