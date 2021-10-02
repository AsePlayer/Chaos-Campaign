package com.brockw.stickwar.engine.Team.Order
{
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Building;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   
   public class MagicGuildBuilding extends Building
   {
       
      
      public function MagicGuildBuilding(game:StickWar, tech:GoodTech, button:MovieClip, hitAreaMc:MovieClip)
      {
         super(game);
         this.button = button;
         _hitAreaMovieClip = hitAreaMc;
         this.type = Unit.B_MAGIC_SHOP;
         this.tech = tech;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         a.clear();
         if(!tech.isResearched(Tech.MAGIKILL_POISON))
         {
            a.setAction(0,0,Tech.MAGIKILL_POISON);
         }
         if(!tech.isResearched(Tech.MAGIKILL_WALL))
         {
            a.setAction(1,0,Tech.MAGIKILL_WALL);
         }
      }
   }
}
