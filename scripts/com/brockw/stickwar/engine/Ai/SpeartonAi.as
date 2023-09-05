package com.brockw.stickwar.engine.Ai
{
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Spearton;
     
     public class SpeartonAi extends UnitAi
     {
           
          
          public function SpeartonAi(s:Spearton)
          {
               super();
               unit = s;
          }
          
          override public function update(game:StickWar) : void
          {
               if(currentCommand.type == UnitCommand.SPEARTON_BLOCK)
               {
                    if(Spearton(unit).inBlock)
                    {
                         Spearton(unit).stopBlocking();
                    }
                    else
                    {
                         Spearton(unit).startBlocking();
                    }
                    nextMove(game);
               }
               else if(currentCommand.type == UnitCommand.SHIELD_BASH)
               {
                    Spearton(unit).shieldBash();
                    nextMove(game);
               }
               else if(currentCommand.type != UnitCommand.STAND)
               {
                    Spearton(unit).stopBlocking();
               }
               if(!Spearton(unit).inBlock)
               {
                    baseUpdate(game);
               }
          }
     }
}
