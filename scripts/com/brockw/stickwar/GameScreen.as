package com.brockw.stickwar
{
   import com.brockw.game.Screen;
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.SimulationSyncronizer;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.UserInterface;
   import com.brockw.stickwar.engine.multiplayer.moves.ScreenPositionUpdateMove;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class GameScreen extends Screen
   {
      
      public static const FRAME_RATE:int = 30;
      
      protected static const MAX_SKIPS:int = 3;
      
      public static const S_HIGH_QUALITY:int = 0;
      
      public static const S_MEDIUM_QUALITY:int = 1;
      
      public static const S_LOW_QUALITY:int = 2;
       
      
      protected var _game:StickWar;
      
      protected var _simulation:SimulationSyncronizer;
      
      protected var _main:BaseMain;
      
      protected var _team:Team;
      
      protected var _userInterface:UserInterface;
      
      protected var timeOfLastUpdate:Number;
      
      protected var _period:Number = 33.333333333333336;
      
      protected var _beforeTime:int = 0;
      
      protected var _afterTime:int = 0;
      
      protected var _timeDiff:int = 0;
      
      protected var _sleepTime:int = 0;
      
      protected var _overSleepTime:int = 0;
      
      protected var _excess:int = 0;
      
      protected var gameTimer:Timer;
      
      protected var consecutiveSkips:int;
      
      protected var overTime:Number;
      
      private var _isDebug:Boolean;
      
      private var lastPulse:int;
      
      private var _isPaused:Boolean;
      
      private var _quality:int;
      
      private var skipHeuristic:Number;
      
      private var messagePrompt:inGameMessagePromptMc;
      
      private var _hasMovingBackground:Boolean;
      
      private var _hasEffects:Boolean;
      
      private var _hasAlphaOnFogOfWar:Boolean;
      
      private var _hasScreenReduction:Boolean;
      
      private var lastSwitchInQuality:int;
      
      private var isFirstSwitch:Boolean;
      
      private var hasChanged:Boolean;
      
      private var showTimeoutCounter:int;
      
      private var nameLagging:String;
      
      private var _isFastForward:Boolean;
      
      public var strictPause:Boolean;
      
      private var _isFastForwardFrame:Boolean;
      
      var t:int;
      
      private var showingTimeout:Boolean;
      
      private var showingSyncError:Boolean;
      
      public function GameScreen(main:BaseMain)
      {
         this._period = 33.333333333333336;
         this._period = 33.333333333333336;
         this._period = 33.333333333333336;
         this._period = 33.333333333333336;
         super();
         this.nameLagging = "";
         this.showTimeoutCounter = 0;
         this._hasMovingBackground = true;
         this._hasEffects = true;
         this._hasAlphaOnFogOfWar = true;
         this._hasScreenReduction = true;
         this.main = main;
         this.isDebug = false;
         this.quality = S_HIGH_QUALITY;
         this.skipHeuristic = 0;
         main.loadingFraction = 0;
         this.lastSwitchInQuality = getTimer();
         this.isFastForward = false;
         this._isFastForwardFrame = false;
      }
      
      public function judgementFrame() : void
      {
      }
      
      override public function enter() : void
      {
         this.strictPause = false;
         this.stage.frameRate = 0;
         this.gameTimer = new Timer(this._period,0);
         this.gameTimer.addEventListener(TimerEvent.TIMER,this.updateGameLoop);
         this.gameTimer.start();
         this.consecutiveSkips = 0;
         this.overTime = 0;
         this._beforeTime = getTimer();
         this.isPaused = false;
         this.lastPulse = 0;
         this.main.setOverlayScreen("");
         this.messagePrompt = new inGameMessagePromptMc();
         this.lastSwitchInQuality = getTimer();
         this.isFirstSwitch = true;
         this.hasChanged = true;
         this._hasMovingBackground = true;
         this._hasEffects = true;
         this._hasAlphaOnFogOfWar = true;
         this._hasScreenReduction = true;
         this.isFastForward = false;
      }
      
      public function u(evt:Event) : void
      {
         this.t = getTimer();
      }
      
      public function updateGameLoopFrame(evt:Event) : void
      {
         this.update(evt,0);
      }
      
      public function updateGameLoop(evt:TimerEvent) : void
      {
         if(!stage)
         {
            return;
         }
         this.gameTimer.delay = this._period;
         this.gameTimer.start();
         var timeForFrame:Number = getTimer() - this._beforeTime;
         this._beforeTime = getTimer();
         this._overSleepTime = this._beforeTime - this._afterTime - this._sleepTime;
         if(this._overSleepTime < 0)
         {
            this._overSleepTime = 0;
         }
         if(stage != null)
         {
            this.update(evt,this._beforeTime - this._afterTime);
         }
         this._afterTime = getTimer();
         this._timeDiff = this._afterTime - this._beforeTime;
         this._sleepTime = this._period - this._timeDiff;
         if(this._sleepTime <= 0)
         {
            this._excess -= this._sleepTime;
            this._sleepTime = 2;
         }
         this.overTime += timeForFrame - 34;
         if(this.overTime < 0)
         {
            this.overTime = 0;
         }
         if(this.overTime < 35 || this.consecutiveSkips > 0)
         {
            if(this.game.frame == 30 * 15)
            {
               this.judgementFrame();
            }
            if(this.hasChanged)
            {
               this.hasChanged = false;
               if(this.quality == S_HIGH_QUALITY)
               {
                  this._hasMovingBackground = true;
                  this._hasEffects = true;
                  stage.quality = "HIGH";
               }
               else if(this.quality == S_MEDIUM_QUALITY)
               {
                  this._hasMovingBackground = true;
                  stage.quality = "LOW";
                  this._hasEffects = false;
               }
               else if(this.quality == S_LOW_QUALITY)
               {
                  stage.quality = "LOW";
                  this._hasEffects = false;
                  this._hasMovingBackground = false;
               }
               trace("QUALITY: ",this.quality);
            }
            evt.updateAfterEvent();
            this.consecutiveSkips = 0;
         }
         else
         {
            this.overTime = 0;
            ++this.consecutiveSkips;
            if(this.gameTimer)
            {
               this.gameTimer.reset();
               this.gameTimer.delay = 1;
               this.gameTimer.start();
            }
         }
      }
      
      public function update(evt:Event, timeDiff:Number) : void
      {
         var m:ScreenPositionUpdateMove = null;
         if(this.main.pauseForTechTree)
         {
            this.isPaused = true;
         }
         if(this.simulation.hasStarted)
         {
            this.userInterface.update(evt,timeDiff);
         }
         this.simulation.updateFPS();
         if(this.strictPause)
         {
            this.game.updateVisibilityOfUnits();
         }
         else
         {
            this.simulation.update(this);
            if(this.isFastForward)
            {
               this._isFastForwardFrame = true;
               this.simulation.update(this);
               this._isFastForwardFrame = false;
            }
         }
         if(this.simulation)
         {
            if(this.simulation.isStalled)
            {
               this.game.updateVisibilityOfUnits();
               if(this.lastPulse > 5)
               {
                  m = new ScreenPositionUpdateMove();
                  this.userInterface.lastSentScreenPosition = m.pos = this.game.screenX;
                  this.doMove(m,this.team.id);
                  this.lastPulse = 0;
               }
               ++this.lastPulse;
            }
            else if(this.showingTimeout == true)
            {
               this.hideTimeout();
            }
            if(this.showingTimeout || this.showingSyncError)
            {
               ++this.showTimeoutCounter;
            }
         }
      }
      
      public function showTimeout(user:String, time:int) : void
      {
         var m:String = null;
         if(!this.showingSyncError)
         {
            this.showingTimeout = true;
            if(this.nameLagging != user)
            {
               this.showTimeoutCounter = 0;
            }
            this.nameLagging = user;
            if(user == this.main.sfs.mySelf.name)
            {
               m = "Your computer/internet is lagging and will cause you to forfeit in " + Math.floor(time / 1000) + " seconds";
               this.showMessage(m,true);
            }
            else
            {
               this.showMessage(user + " is lagging and will forfeit in " + Math.floor(time / 1000) + " seconds",false);
            }
         }
      }
      
      public function hideTimeout() : void
      {
         if(this.showTimeoutCounter > 30 * 3)
         {
            this.hideMessage();
            this.showingTimeout = false;
            this.nameLagging = "";
         }
      }
      
      public function showSyncError() : void
      {
         this.showingSyncError = true;
         this.showMessage("Clients out of Sync. An error report has been submitted.");
      }
      
      public function showMessage(message:String, showLag:Boolean = false, offset:Number = 0) : void
      {
         if(showLag)
         {
            this.messagePrompt.gotoAndStop(2);
         }
         else
         {
            this.messagePrompt.gotoAndStop(1);
         }
         this.messagePrompt.message.text = message;
         this.messagePrompt.x = stage.stageWidth / 2;
         this.messagePrompt.y = 40 + this.messagePrompt.height / 2 + offset;
         if(!contains(this.messagePrompt))
         {
            addChild(this.messagePrompt);
         }
      }
      
      public function hideMessage() : void
      {
         if(contains(this.messagePrompt))
         {
            removeChild(this.messagePrompt);
         }
      }
      
      public function endGame() : void
      {
      }
      
      public function endTurn() : void
      {
      }
      
      public function doMove(move:Move, id:int) : void
      {
      }
      
      public function cleanUp() : void
      {
         this.gameTimer.removeEventListener(TimerEvent.TIMER,this.updateGameLoop);
         this.gameTimer.stop();
         trace("CLEAN UP THE GAMES CREEN");
         this.userInterface.cleanUp();
         this.userInterface = null;
         this._simulation = null;
         Mouse.show();
         this.game.cleanUp();
         this.game = null;
         this.gameTimer = null;
         this.stage.quality = "HIGH";
      }
      
      public function get game() : StickWar
      {
         return this._game;
      }
      
      public function set game(value:StickWar) : void
      {
         this._game = value;
      }
      
      public function get simulation() : SimulationSyncronizer
      {
         return this._simulation;
      }
      
      public function set simulation(value:SimulationSyncronizer) : void
      {
         this._simulation = value;
      }
      
      public function get team() : Team
      {
         return this._team;
      }
      
      public function set team(value:Team) : void
      {
         this._team = value;
      }
      
      public function get main() : BaseMain
      {
         return this._main;
      }
      
      public function set main(value:BaseMain) : void
      {
         this._main = value;
      }
      
      public function get userInterface() : UserInterface
      {
         return this._userInterface;
      }
      
      public function set userInterface(value:UserInterface) : void
      {
         this._userInterface = value;
      }
      
      public function get isPaused() : Boolean
      {
         return this._isPaused;
      }
      
      public function set isPaused(value:Boolean) : void
      {
         this.game.setPaused(value);
         this._isPaused = value;
      }
      
      public function get isDebug() : Boolean
      {
         return this._isDebug;
      }
      
      public function set isDebug(value:Boolean) : void
      {
         this._isDebug = value;
      }
      
      public function get hasMovingBackground() : Boolean
      {
         return this._hasMovingBackground;
      }
      
      public function set hasMovingBackground(value:Boolean) : void
      {
         this._hasMovingBackground = value;
      }
      
      public function get hasEffects() : Boolean
      {
         return this._hasEffects;
      }
      
      public function set hasEffects(value:Boolean) : void
      {
         this._hasEffects = value;
      }
      
      public function get hasAlphaOnFogOfWar() : Boolean
      {
         return this._hasAlphaOnFogOfWar;
      }
      
      public function set hasAlphaOnFogOfWar(value:Boolean) : void
      {
         this._hasAlphaOnFogOfWar = value;
      }
      
      public function get hasScreenReduction() : Boolean
      {
         return this._hasScreenReduction;
      }
      
      public function set hasScreenReduction(value:Boolean) : void
      {
         this._hasScreenReduction = value;
      }
      
      public function get quality() : int
      {
         return this._quality;
      }
      
      public function set quality(value:int) : void
      {
         this.hasChanged = true;
         this._quality = value;
      }
      
      public function get isFastForward() : Boolean
      {
         return this._isFastForward;
      }
      
      public function set isFastForward(value:Boolean) : void
      {
         this._isFastForward = value;
      }
      
      public function get isFastForwardFrame() : Boolean
      {
         return this._isFastForwardFrame;
      }
      
      public function set isFastForwardFrame(value:Boolean) : void
      {
         this._isFastForwardFrame = value;
      }
   }
}
