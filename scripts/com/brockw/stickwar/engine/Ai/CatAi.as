package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Cat;
   
   public class CatAi extends UnitAi
   {
       
      
      public function CatAi(s:Cat)
      {
         super();
         unit = s;
      }
      
      override public function update(game:StickWar) : void
      {
         baseUpdate(game);
      }
   }
}
