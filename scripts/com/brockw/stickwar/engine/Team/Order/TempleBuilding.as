package com.brockw.stickwar.engine.Team.Order
{
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Building;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     
     public class TempleBuilding extends Building
     {
           
          
          public function TempleBuilding(game:StickWar, tech:GoodTech, button:MovieClip, hitAreaMc:MovieClip)
          {
               super(game);
               this.button = button;
               _hitAreaMovieClip = hitAreaMc;
               this.type = Unit.B_TEMPLE;
               this.tech = tech;
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               a.clear();
               if(!tech.isResearched(Tech.STATUE_HEALTH))
               {
                    a.setAction(0,0,Tech.STATUE_HEALTH);
               }
               if(!tech.isResearched(Tech.MONK_CURE))
               {
                    a.setAction(0,1,Tech.MONK_CURE);
               }
          }
     }
}
