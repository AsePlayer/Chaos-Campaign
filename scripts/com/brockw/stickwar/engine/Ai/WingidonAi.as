package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Wingidon;
   
   public class WingidonAi extends RangedAi
   {
       
      
      public function WingidonAi(s:Wingidon)
      {
         super(s);
         unit = s;
      }
      
      override public function update(game:StickWar) : void
      {
         checkNextMove(game);
         if(currentCommand.type == UnitCommand.WINGIDON_SPEED)
         {
            Wingidon(unit).speedSpell();
            restoreMove(game);
         }
         super.update(game);
      }
   }
}
