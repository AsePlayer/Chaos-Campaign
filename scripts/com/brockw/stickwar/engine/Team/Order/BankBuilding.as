package com.brockw.stickwar.engine.Team.Order
{
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Building;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   
   public class BankBuilding extends Building
   {
       
      
      public function BankBuilding(game:StickWar, tech:GoodTech, button:MovieClip, hitAreaMc:MovieClip)
      {
         super(game);
         this.button = button;
         _hitAreaMovieClip = hitAreaMc;
         this.type = Unit.B_ORDER_BANK;
         this.tech = tech;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         a.clear();
         if(!tech.isResearched(Tech.MINER_SPEED))
         {
            a.setAction(0,0,Tech.MINER_SPEED);
         }
         if(!tech.isResearched(Tech.MINER_WALL))
         {
            a.setAction(1,0,Tech.MINER_WALL);
         }
         if(!tech.isResearched(Tech.BANK_PASSIVE_1))
         {
            a.setAction(0,1,Tech.BANK_PASSIVE_1);
         }
         else if(!tech.isResearched(Tech.BANK_PASSIVE_2))
         {
            a.setAction(0,1,Tech.BANK_PASSIVE_2);
         }
         else if(!tech.isResearched(Tech.BANK_PASSIVE_3))
         {
            a.setAction(0,1,Tech.BANK_PASSIVE_3);
         }
         if(!tech.isResearched(Tech.TOWER_SPAWN_I))
         {
            a.setAction(0,2,Tech.TOWER_SPAWN_I);
         }
         else if(!tech.isResearched(Tech.TOWER_SPAWN_II))
         {
            a.setAction(0,2,Tech.TOWER_SPAWN_II);
         }
      }
   }
}
