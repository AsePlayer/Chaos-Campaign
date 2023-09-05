package com.brockw.stickwar.engine.Ai
{
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Team;
     import com.brockw.stickwar.engine.units.Unit;
     
     public class TeamAi
     {
           
          
          protected var team:Team;
          
          public function TeamAi(team:Team)
          {
               super();
               this.team = team;
          }
          
          public function update(game:StickWar) : void
          {
               var unit:String = null;
               for(unit in this.team.units)
               {
                    if(Unit(this.team.units[unit]).isAlive())
                    {
                         if(Unit(this.team.units[unit]).reaperCurseFrames == 0)
                         {
                              this.team.units[unit].ai.update(game);
                         }
                    }
               }
          }
          
          public function cleanUp() : void
          {
               var unit:String = null;
               for(unit in this.team.units)
               {
                    this.team.units[unit].ai.cleanUp();
               }
               this.team = null;
          }
     }
}
