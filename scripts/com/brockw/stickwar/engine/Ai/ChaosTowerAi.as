package com.brockw.stickwar.engine.Ai
{
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.ChaosTower;
     
     public class ChaosTowerAi extends RangedAi
     {
           
          
          public function ChaosTowerAi(s:ChaosTower)
          {
               super(s);
               unit = s;
          }
          
          override public function update(game:StickWar) : void
          {
               if(this.currentCommand.type == UnitCommand.REMOVE_TOWER_COMMAND)
               {
                    this.unit.isDieing = true;
                    this.unit.health = 0;
                    this.unit.healthBar.health = 0;
               }
               checkNextMove(game);
               mayAttack = true;
               super.update(game);
          }
     }
}
