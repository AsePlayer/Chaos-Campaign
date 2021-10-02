package com.brockw.simulationSync
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.BaseMain;
   import com.brockw.stickwar.GameScreen;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.utils.getTimer;
   
   public class SimulationSyncronizer
   {
       
      
      public var frame:int;
      
      public var turn:int;
      
      public var frameRate:int;
      
      public var turnSize:int;
      
      public var ping:Number;
      
      public var movesInTurn:int;
      
      public var framesLeftInTurn:int;
      
      private var currentTurn:Turn;
      
      private var nextTurn:Turn;
      
      private var nextnextTurn:Turn;
      
      private var temp:Turn;
      
      private var _game:Simulation;
      
      private var main:BaseMain;
      
      private var tempSFSObject:SFSObject;
      
      private var waitingForTurn:Boolean;
      
      private var _sentEndGame:Boolean;
      
      private var _hasStarted:Boolean;
      
      public var data:SFSObject;
      
      public var endOfTurnMove:EndOfTurnMove;
      
      private var endOfTurnFunction:Function;
      
      private var endGame:Function;
      
      private var _gameReplay:GameReplay;
      
      private var lastNFrames:Array;
      
      private var lastTime:Number;
      
      private var _fps:Number;
      
      private var _isStalled:Boolean;
      
      public function SimulationSyncronizer(game:Simulation, main:BaseMain, eot:Function, endGame:Function)
      {
         super();
         this._sentEndGame = false;
         this.frame = 0;
         this.turn = 0;
         this.frameRate = 30;
         this.turnSize = 5;
         this.ping = 0;
         this.game = game;
         this.main = main;
         this.endOfTurnFunction = eot;
         this.framesLeftInTurn = this.turnSize;
         this.movesInTurn = 0;
         this._isStalled = false;
         this.tempSFSObject = new SFSObject();
         this.currentTurn = new Turn();
         this.currentTurn.ready = true;
         this.nextTurn = new Turn();
         this.nextnextTurn = new Turn();
         this.waitingForTurn = false;
         this._hasStarted = false;
         this.endOfTurnMove = new EndOfTurnMove();
         this.endGame = endGame;
         this.data = new SFSObject();
         this.gameReplay = new GameReplay();
         this.lastNFrames = [];
      }
      
      public function init(seed:int) : void
      {
         this.game.init(seed);
         this.frame = 0;
         this.turn = 0;
         this.lastTime = getTimer();
      }
      
      public function update(screen:Screen) : void
      {
         if(!this._hasStarted)
         {
            return;
         }
         if(this.gameReplay.isPlaying)
         {
            this.gameReplay.play(this);
            if(this.gameReplay.isFinished())
            {
               this.game.gameOver = true;
            }
         }
         if(this.game.gameOver)
         {
            if(this._sentEndGame == false)
            {
               this.endGame();
               this._sentEndGame = true;
            }
            return;
         }
         if(this.framesLeftInTurn == 0)
         {
            if(!this.currentTurn.ready)
            {
               this._isStalled = true;
               return;
            }
            this._isStalled = false;
            this.endOfTurnFunction();
            if(!this.gameReplay.isPlaying)
            {
               this.gameReplay.addSyncCheck(this);
            }
            this.game.executeTurn(this.currentTurn);
            ++this.turn;
            this.temp = this.currentTurn;
            this.currentTurn = this.nextTurn;
            this.nextTurn = this.nextnextTurn;
            this.nextnextTurn = this.temp;
            this.nextnextTurn.init();
            this.framesLeftInTurn = this.turnSize = this.currentTurn.turnSize;
            this.frameRate = this.currentTurn.frameRate;
            this.ping = this.currentTurn.ping;
         }
         if(!GameScreen(screen).isPaused)
         {
            this.game.update(screen);
         }
         this.frame += 1;
         this.framesLeftInTurn -= 1;
      }
      
      public function updateFPS() : void
      {
         this.lastNFrames.push(getTimer() - this.lastTime);
         if(this.lastNFrames.length > 10)
         {
            this.lastNFrames.shift();
         }
         var sum:* = 0;
         for(var i:int = 0; i < this.lastNFrames.length; i++)
         {
            sum += this.lastNFrames[i];
         }
         this.fps = 1000 / (sum / this.lastNFrames.length);
         this.lastTime = getTimer();
      }
      
      public function processMove(move:Move) : void
      {
         if(move == null)
         {
            return;
         }
         if(!this.gameReplay.isPlaying)
         {
            this.gameReplay.addMove(move,this);
         }
         if(move.turn + 1 == this.turn)
         {
            this.currentTurn.processMove(move);
         }
         else if(move.turn == this.turn)
         {
            this.nextTurn.processMove(move);
         }
         else
         {
            if(move.turn != this.turn + 1)
            {
               throw new Error("Error with process move");
            }
            this.nextnextTurn.processMove(move);
         }
      }
      
      public function get gameReplay() : GameReplay
      {
         return this._gameReplay;
      }
      
      public function set gameReplay(value:GameReplay) : void
      {
         this._gameReplay = value;
      }
      
      public function get fps() : Number
      {
         return this._fps;
      }
      
      public function set fps(value:Number) : void
      {
         this._fps = value;
      }
      
      public function get hasStarted() : Boolean
      {
         return this._hasStarted;
      }
      
      public function set hasStarted(value:Boolean) : void
      {
         this._hasStarted = value;
      }
      
      public function get isStalled() : Boolean
      {
         return this._isStalled;
      }
      
      public function set isStalled(value:Boolean) : void
      {
         this._isStalled = value;
      }
      
      public function get game() : Simulation
      {
         return this._game;
      }
      
      public function set game(value:Simulation) : void
      {
         this._game = value;
      }
   }
}
