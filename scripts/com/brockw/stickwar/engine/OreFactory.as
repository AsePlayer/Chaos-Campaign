package com.brockw.stickwar.engine
{
   import com.brockw.game.Pool;
   import flash.utils.Dictionary;
   
   public class OreFactory
   {
       
      
      private var pools:Dictionary;
      
      private var id:int;
      
      public function OreFactory(maxUnits:int, game:StickWar)
      {
         super();
         this.pools = new Dictionary();
         this.pools[new Gold(game).type] = new Pool(maxUnits * 2,Gold,game);
         this.id = 0;
      }
      
      public function getUnit(type:int) : Ore
      {
         var o:Ore = Ore(Pool(this.pools[type]).getItem());
         o.id = this.id++;
         return o;
      }
      
      public function returnUnit(type:int, unit:Ore) : void
      {
         Pool(this.pools[type]).returnItem(unit);
      }
   }
}
