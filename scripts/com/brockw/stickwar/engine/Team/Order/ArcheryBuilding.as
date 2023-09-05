package com.brockw.stickwar.engine.Team.Order
{
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Building;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     
     public class ArcheryBuilding extends Building
     {
           
          
          public function ArcheryBuilding(game:StickWar, tech:GoodTech, button:MovieClip, hitAreaMc:MovieClip)
          {
               super(game);
               this.button = button;
               _hitAreaMovieClip = hitAreaMc;
               this.type = Unit.B_ARCHERY_RANGE;
               this.tech = tech;
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               a.clear();
               if(false && !tech.isResearched(Tech.ARCHIDON))
               {
                    a.setAction(0,1,Tech.ARCHIDON);
               }
               else if(!tech.isResearched(Tech.ARCHIDON_FIRE))
               {
                    a.setAction(0,1,Tech.ARCHIDON_FIRE);
               }
               if(!tech.isResearched(Tech.CROSSBOW_FIRE))
               {
                    a.setAction(0,2,Tech.CROSSBOW_FIRE);
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
          }
     }
}
