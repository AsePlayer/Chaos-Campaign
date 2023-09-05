package com.brockw.stickwar.engine.Team.Chaos
{
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Building;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     
     public class ChaosUndeadBuilding extends Building
     {
           
          
          public function ChaosUndeadBuilding(game:StickWar, tech:ChaosTech, button:MovieClip, hitAreaMc:MovieClip)
          {
               super(game);
               this.button = button;
               _hitAreaMovieClip = hitAreaMc;
               this.type = Unit.B_CHAOS_UNDEAD;
               this.tech = tech;
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               a.clear();
               if(!tech.isResearched(Tech.SKELETON_FIST_ATTACK))
               {
                    a.setAction(0,0,Tech.SKELETON_FIST_ATTACK);
               }
          }
     }
}
