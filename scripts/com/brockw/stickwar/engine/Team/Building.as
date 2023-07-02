package com.brockw.stickwar.engine.Team
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   
   public class Building extends Unit
   {
       
      
      protected var tech:com.brockw.stickwar.engine.Team.Tech;
      
      protected var _button:MovieClip;
      
      protected var _hitAreaMovieClip:MovieClip;
      
      public function Building(game:StickWar)
      {
         super(game);
         _interactsWith = Unit.I_IS_BUILDING;
      }
      
      public function get button() : MovieClip
      {
         return this._button;
      }
      
      public function set button(value:MovieClip) : void
      {
         this._button = value;
      }
      
      public function get hitAreaMovieClip() : MovieClip
      {
         return this._hitAreaMovieClip;
      }
      
      public function set hitAreaMovieClip(value:MovieClip) : void
      {
         this._hitAreaMovieClip = value;
      }
   }
}
