package com.brockw.simulationSync
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.engine.Team.Team;
   import flash.display.Sprite;
   
   public class Simulation extends Sprite
   {
       
      
      private var _gameOver:Boolean;
      
      private var _winner:Team;
      
      private var _frame:int;
      
      private var _isReplay:Boolean;
      
      public function Simulation()
      {
         super();
         this._gameOver = false;
         this._isReplay = false;
         this.frame = 0;
      }
      
      public function executeTurn(turn:Turn) : void
      {
      }
      
      public function update(screen:Screen) : void
      {
         ++this.frame;
      }
      
      public function postInit() : void
      {
      }
      
      public function getCheckSum() : int
      {
         return 0;
      }
      
      public function init(seed:int) : void
      {
         this._gameOver = false;
         this.frame = 0;
      }
      
      public function get gameOver() : Boolean
      {
         return this._gameOver;
      }
      
      public function set gameOver(value:Boolean) : void
      {
         this._gameOver = value;
      }
      
      public function get winner() : Team
      {
         return this._winner;
      }
      
      public function set winner(value:Team) : void
      {
         this._winner = value;
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set frame(value:int) : void
      {
         this._frame = value;
      }
      
      public function get isReplay() : Boolean
      {
         return this._isReplay;
      }
      
      public function set isReplay(value:Boolean) : void
      {
         this._isReplay = value;
      }
   }
}
