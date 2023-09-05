package com.brockw.stickwar.engine.Ai
{
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Dead;
     
     public class DeadAi extends RangedAi
     {
           
          
          public function DeadAi(s:Dead)
          {
               super(s);
               unit = s;
          }
          
          override public function update(game:StickWar) : void
          {
               checkNextMove(game);
               if(currentCommand.type == UnitCommand.DEAD_POISON)
               {
                    Dead(unit).isPoisonedToggled = !Dead(unit).isPoisonedToggled;
                    restoreMove(game);
                    baseUpdate(game);
               }
               super.update(game);
          }
     }
}
