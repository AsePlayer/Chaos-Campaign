package com.brockw.stickwar.engine.Ai
{
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Archer;
     
     public class ArcherAi extends RangedAi
     {
           
          
          public function ArcherAi(s:Archer)
          {
               super(s);
               unit = s;
          }
          
          override public function update(game:StickWar) : void
          {
               checkNextMove(game);
               if(currentCommand.type == UnitCommand.ARCHER_FIRE)
               {
                    Archer(unit).archerFireArrow();
                    nextMove(game);
               }
               super.update(game);
          }
     }
}
