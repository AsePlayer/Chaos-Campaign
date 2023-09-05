package com.brockw.stickwar.engine.Team.Chaos
{
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Building;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     
     public class ChaosFletchersBuilding extends Building
     {
           
          
          public function ChaosFletchersBuilding(game:StickWar, tech:ChaosTech, button:MovieClip, hitAreaMc:MovieClip)
          {
               super(game);
               this.button = button;
               _hitAreaMovieClip = hitAreaMc;
               this.type = Unit.B_CHAOS_FLETCHER;
               this.tech = tech;
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               a.clear();
               if(!tech.isResearched(Tech.DEAD_POISON))
               {
                    a.setAction(0,1,Tech.DEAD_POISON);
               }
               if(!tech.isResearched(Tech.CASTLE_ARCHER_1))
               {
                    a.setAction(0,0,Tech.CASTLE_ARCHER_1);
               }
               else if(!tech.isResearched(Tech.CASTLE_ARCHER_2))
               {
                    a.setAction(0,0,Tech.CASTLE_ARCHER_2);
               }
               else if(!tech.isResearched(Tech.CASTLE_ARCHER_3))
               {
                    a.setAction(0,0,Tech.CASTLE_ARCHER_3);
               }
               else if(!tech.isResearched(Tech.CASTLE_ARCHER_4))
               {
                    a.setAction(0,0,Tech.CASTLE_ARCHER_4);
               }
               else if(!tech.isResearched(Tech.CASTLE_ARCHER_5))
               {
                    a.setAction(0,0,Tech.CASTLE_ARCHER_5);
               }
          }
     }
}
