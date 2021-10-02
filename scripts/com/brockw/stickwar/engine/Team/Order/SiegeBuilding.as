package com.brockw.stickwar.engine.Team.Order
{
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Building;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   
   public class SiegeBuilding extends Building
   {
       
      
      public function SiegeBuilding(game:StickWar, tech:GoodTech, button:MovieClip, hitAreaMc:MovieClip)
      {
         super(game);
         this.button = button;
         _hitAreaMovieClip = hitAreaMc;
         this.type = Unit.B_SIEGE_WORKSHOP;
         this.tech = tech;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         a.clear();
         if(!tech.isResearched(Tech.GIANT_GROWTH_I))
         {
            a.setAction(0,0,Tech.GIANT_GROWTH_I);
         }
         else if(!tech.isResearched(Tech.GIANT_GROWTH_II))
         {
            a.setAction(0,0,Tech.GIANT_GROWTH_II);
         }
      }
   }
}
