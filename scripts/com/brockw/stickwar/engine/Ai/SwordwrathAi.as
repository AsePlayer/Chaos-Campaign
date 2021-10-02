package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Swordwrath;
   
   public class SwordwrathAi extends UnitAi
   {
       
      
      public function SwordwrathAi(s:Swordwrath)
      {
         super();
         unit = s;
      }
      
      override public function update(game:StickWar) : void
      {
         if(currentCommand.type == UnitCommand.SWORDWRATH_RAGE)
         {
            Swordwrath(unit).rage();
            restoreMove(game);
         }
         baseUpdate(game);
      }
   }
}
