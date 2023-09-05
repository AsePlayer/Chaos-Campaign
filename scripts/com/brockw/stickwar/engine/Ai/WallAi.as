package com.brockw.stickwar.engine.Ai
{
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Wall;
     
     public class WallAi extends UnitAi
     {
           
          
          public function WallAi(s:Wall)
          {
               super();
               unit = s;
          }
          
          override public function update(game:StickWar) : void
          {
               checkNextMove(game);
               if(this.currentCommand.type == UnitCommand.REMOVE_WALL_COMMAND)
               {
                    this.unit.team.removeWall(Wall(unit));
               }
          }
     }
}
