package com.brockw.stickwar.engine.Team
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class CastleDefence
   {
       
      
      private var _units:Array;
      
      protected var game:StickWar;
      
      protected var team:Team;
      
      public function CastleDefence(game:StickWar, team:Team)
      {
         super();
         this.game = game;
         this.team = team;
         this._units = [];
      }
      
      public function update(game:StickWar) : void
      {
         for(var i:int = 0; i < this.units.length; i++)
         {
            this.units[i].ai.update(game);
            this.units[i].update(game);
         }
      }
      
      public function cleanUpUnits() : void
      {
         var unit:Unit = null;
         for each(unit in this._units)
         {
            if(this.game.battlefield.contains(unit))
            {
               this.game.battlefield.removeChild(unit);
            }
         }
         this._units = [];
      }
      
      public function cleanUp() : void
      {
         this._units = null;
         this.game = null;
         this.team = null;
      }
      
      public function addUnit() : void
      {
      }
      
      public function get units() : Array
      {
         return this._units;
      }
      
      public function set units(value:Array) : void
      {
         this._units = value;
      }
   }
}
