package com.brockw.stickwar.engine.Ai
{
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Ninja;
     
     public class NinjaAi extends UnitAi
     {
           
          
          public function NinjaAi(s:Ninja)
          {
               super();
               unit = s;
          }
          
          override public function update(game:StickWar) : void
          {
               if(currentCommand.type == UnitCommand.STEALTH)
               {
                    Ninja(unit).stealth();
                    restoreMove(game);
               }
               baseUpdate(game);
          }
     }
}
