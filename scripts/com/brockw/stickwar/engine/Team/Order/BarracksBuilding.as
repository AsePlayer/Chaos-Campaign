package com.brockw.stickwar.engine.Team.Order
{
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Building;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     
     public class BarracksBuilding extends Building
     {
           
          
          public function BarracksBuilding(game:StickWar, tech:GoodTech, button:MovieClip, hitAreaMc:MovieClip)
          {
               super(game);
               this.button = button;
               _hitAreaMovieClip = hitAreaMc;
               this.type = Unit.B_BARRACKS;
               this.tech = tech;
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               a.clear();
               if(!tech.isResearched(Tech.SWORDWRATH_RAGE))
               {
                    a.setAction(0,0,Tech.SWORDWRATH_RAGE);
               }
               if(false && !tech.isResearched(Tech.SPEARTON))
               {
                    a.setAction(0,1,Tech.SPEARTON);
               }
               else
               {
                    if(!tech.isResearched(Tech.BLOCK))
                    {
                         a.setAction(0,1,Tech.BLOCK);
                    }
                    if(!tech.isResearched(Tech.SHIELD_BASH))
                    {
                         a.setAction(1,1,Tech.SHIELD_BASH);
                    }
               }
               if(false && !tech.isResearched(Tech.NINJA))
               {
                    a.setAction(0,2,Tech.NINJA);
               }
               else if(!tech.isResearched(Tech.CLOAK))
               {
                    a.setAction(0,2,Tech.CLOAK);
               }
               else if(!tech.isResearched(Tech.CLOAK_II))
               {
                    a.setAction(0,2,Tech.CLOAK_II);
               }
          }
     }
}
