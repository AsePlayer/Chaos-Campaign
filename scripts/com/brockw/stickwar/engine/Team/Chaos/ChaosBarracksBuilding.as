package com.brockw.stickwar.engine.Team.Chaos
{
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Building;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   
   public class ChaosBarracksBuilding extends Building
   {
       
      
      public function ChaosBarracksBuilding(game:StickWar, tech:ChaosTech, button:MovieClip, hitAreaMc:MovieClip)
      {
         super(game);
         this.button = button;
         _hitAreaMovieClip = hitAreaMc;
         this.type = Unit.B_CHAOS_BARRACKS;
         this.tech = tech;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         a.clear();
         if(!tech.isResearched(Tech.CAT_PACK))
         {
            a.setAction(0,0,Tech.CAT_PACK);
         }
         if(!tech.isResearched(Tech.CAT_SPEED))
         {
            a.setAction(1,0,Tech.CAT_SPEED);
         }
         if(!tech.isResearched(Tech.KNIGHT_CHARGE))
         {
            a.setAction(0,1,Tech.KNIGHT_CHARGE);
         }
      }
   }
}
