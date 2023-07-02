package com.brockw.stickwar.engine.replay
{
   import com.brockw.*;
   import com.brockw.game.*;
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.SimulationSyncronizer;
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.UserInterface;
   import com.brockw.stickwar.engine.multiplayer.PostGameScreen;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.getTimer;
   
   public class ReplayGameScreen extends GameScreen
   {
       
      
      private var _replayString:String;
      
      public var hasFreeCamera:Boolean;
      
      public var someoneHasWon:Boolean;
      
      private var hasShownEndGameMenu:Boolean;
      
      public function ReplayGameScreen(main:Main)
      {
         super(main);
         this.hasFreeCamera = false;
         this.hasShownEndGameMenu = false;
      }
      
      override public function enter() : void
      {
         var a:int = 0;
         var b:int = 0;
         main.setOverlayScreen("");
         if(!main.stickWar)
         {
            main.stickWar = new StickWar(main,this);
         }
         game = main.stickWar;
         simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
         var isWellFormed:Boolean = simulation.gameReplay.fromString(this._replayString);
         simulation.gameReplay.isPlaying = true;
         this.addChild(game);
         game.initGame(main,this,simulation.gameReplay.mapId);
         trace("START GAME RANDOM:",1000 * game.random.lastRandom);
         game.isReplay = true;
         a = simulation.gameReplay.teamAId;
         b = simulation.gameReplay.teamBId;
         game.initTeams(simulation.gameReplay.teamAType,simulation.gameReplay.teamBType,game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health);
         team = game.teamA;
         game.team = team;
         game.teamA.id = a;
         game.teamB.id = b;
         game.teamA.realName = simulation.gameReplay.teamAName;
         game.teamB.realName = simulation.gameReplay.teamBName;
         game.teamA.loadout.fromString(simulation.gameReplay.teamALoadout);
         game.teamB.loadout.fromString(simulation.gameReplay.teamBLoadout);
         game.teamA.name = a;
         game.teamB.name = b;
         this.team.enemyTeam.isEnemy = true;
         userInterface = new UserInterface(main,this);
         addChild(userInterface);
         userInterface.init(game.team);
         trace("BEFORE INIT:",1000 * game.random.lastRandom);
         game.init(0);
         game.postInit();
         game.teamA.spawnMiners();
         game.teamB.spawnMiners();
         game.fogOfWar.isFogOn = true;
         simulation.hasStarted = true;
         this.someoneHasWon = false;
         this.setUpHUD();
         this.hasShownEndGameMenu = false;
         super.enter();
      }
      
      private function viewPlayer1(e:Event) : void
      {
         this.viewPlayer(game.teamB);
      }
      
      private function viewPlayer2(e:Event) : void
      {
         this.viewPlayer(game.teamA);
      }
      
      private function viewPlayer(team:Team) : void
      {
         game.team = team;
         game.gameScreen.team = game.team;
         this.cleanUpHUD();
         removeChild(userInterface);
         userInterface = new UserInterface(main,this);
         addChild(userInterface);
         userInterface.init(game.team);
         this.setUpHUD();
         userInterface.isSlowCamera = true;
         game.screenX = game.targetScreenX = game.team.lastScreenLookPosition;
         if(Math.abs(game.targetScreenX - game.screenX) > game.map.screenWidth)
         {
            game.gameScreen.userInterface.isSlowCamera = false;
         }
      }
      
      override public function maySwitchOnDisconnect() : Boolean
      {
         return false;
      }
      
      override public function update(evt:Event, timeDiff:Number) : void
      {
         if(game.team == game.teamA)
         {
            this.userInterface.hud.hud.replayHud.player2Highlight.visible = true;
            this.userInterface.hud.hud.replayHud.player1Highlight.visible = false;
         }
         else
         {
            this.userInterface.hud.hud.replayHud.player1Highlight.visible = true;
            this.userInterface.hud.hud.replayHud.player2Highlight.visible = false;
         }
         if(game.fogOfWar.isFogOn)
         {
            this.userInterface.hud.hud.replayHud.fogOfWar.gotoAndStop(2);
         }
         else
         {
            this.userInterface.hud.hud.replayHud.fogOfWar.gotoAndStop(1);
         }
         if(this.hasFreeCamera)
         {
            this.userInterface.hud.hud.replayHud.freeCamera.gotoAndStop(2);
         }
         else
         {
            this.userInterface.hud.hud.replayHud.freeCamera.gotoAndStop(1);
         }
         if(strictPause)
         {
            this.userInterface.hud.hud.replayHud.pauseButton.visible = false;
            this.userInterface.hud.hud.replayHud.playButton.visible = true;
         }
         else
         {
            this.userInterface.hud.hud.replayHud.pauseButton.visible = true;
            this.userInterface.hud.hud.replayHud.playButton.visible = false;
         }
         if(this.isFastForward)
         {
            this.userInterface.hud.hud.replayHud.forwardOn.visible = true;
         }
         else
         {
            this.userInterface.hud.hud.replayHud.forwardOn.visible = false;
         }
         super.update(evt,timeDiff);
      }
      
      override public function updateGameLoop(evt:TimerEvent) : void
      {
         var timeForFrame:Number = NaN;
         if(!this.someoneHasWon && game.showGameOverAnimation)
         {
            this.someoneHasWon = true;
            strictPause = true;
         }
         if(this.someoneHasWon)
         {
            if(!this.hasShownEndGameMenu)
            {
               if(game.teamA.statue.mc.currentFrame == game.teamA.statue.mc.totalFrames || game.teamB.statue.mc.currentFrame == game.teamB.statue.mc.totalFrames)
               {
                  this.userInterface.pauseMenu.showMenu();
                  this.hasShownEndGameMenu = true;
               }
            }
            game.pausedGameMc.visible = false;
         }
         gameTimer.delay = _period;
         this.gameTimer.start();
         timeForFrame = getTimer() - _beforeTime;
         _beforeTime = getTimer();
         _overSleepTime = _beforeTime - _afterTime - _sleepTime;
         if(_overSleepTime < 0)
         {
            _overSleepTime = 0;
         }
         if(userInterface.keyBoardState.isDown(32))
         {
            this.update(evt,_beforeTime - _afterTime);
            this.update(evt,_beforeTime - _afterTime);
            this.update(evt,_beforeTime - _afterTime);
            this.update(evt,_beforeTime - _afterTime);
            this.update(evt,_beforeTime - _afterTime);
            this.update(evt,_beforeTime - _afterTime);
         }
         else
         {
            this.update(evt,_beforeTime - _afterTime);
         }
         _afterTime = getTimer();
         _timeDiff = _afterTime - _beforeTime;
         _sleepTime = _period - _timeDiff;
         if(_sleepTime <= 0)
         {
            _excess -= _sleepTime;
            _sleepTime = 2;
         }
         overTime += timeForFrame - 34;
         if(overTime < 0)
         {
            overTime = 0;
         }
         if(overTime < 35)
         {
            evt.updateAfterEvent();
            consecutiveSkips = 0;
         }
         else
         {
            ++consecutiveSkips;
            gameTimer.delay = 1;
            this.gameTimer.start();
            trace("Skip: ",timeForFrame,consecutiveSkips,this.stage.stage.frameRate);
         }
      }
      
      private function restartButton(e:Event) : void
      {
         main.showScreen(main.currentScreen(),true);
      }
      
      private function setUpHUD() : void
      {
         this.userInterface.hud.hud.replayHud.player1Name.buttonMode = true;
         this.userInterface.hud.hud.replayHud.player2Name.buttonMode = true;
         this.userInterface.hud.hud.replayHud.player2Name.mouseChildren = false;
         this.userInterface.hud.hud.replayHud.player1Name.mouseChildren = false;
         this.userInterface.hud.hud.replayHud.player1Name.addEventListener(MouseEvent.CLICK,this.viewPlayer1);
         this.userInterface.hud.hud.replayHud.player2Name.addEventListener(MouseEvent.CLICK,this.viewPlayer2);
         this.userInterface.hud.hud.replayHud.freeCamera.addEventListener(MouseEvent.CLICK,this.setFreeCamera);
         this.userInterface.hud.hud.replayHud.fogOfWar.addEventListener(MouseEvent.CLICK,this.setFogOfWar);
         this.userInterface.hud.hud.replayHud.fogOfWar.buttonMode = true;
         this.userInterface.hud.hud.replayHud.freeCamera.buttonMode = true;
         this.userInterface.hud.hud.replayHud.fogOfWar.mouseChildren = false;
         this.userInterface.hud.hud.replayHud.freeCamera.mouseChildren = false;
         this.userInterface.hud.hud.replayHud.restartButton.addEventListener(MouseEvent.CLICK,this.restartButton);
         this.userInterface.hud.hud.replayHud.pauseButton.addEventListener(MouseEvent.CLICK,this.pauseButton);
         this.userInterface.hud.hud.replayHud.playButton.addEventListener(MouseEvent.CLICK,this.playButton);
         this.userInterface.hud.hud.replayHud.forwardButton.addEventListener(MouseEvent.CLICK,this.forwardButton);
         if(Boolean(userInterface.hud.hud.fastForward))
         {
            userInterface.hud.hud.fastForward.visible = false;
         }
      }
      
      private function cleanUpHUD() : void
      {
         this.userInterface.hud.hud.replayHud.restartButton.removeEventListener(MouseEvent.CLICK,this.restartButton);
         this.userInterface.hud.hud.replayHud.player1Name.removeEventListener(MouseEvent.CLICK,this.viewPlayer1);
         this.userInterface.hud.hud.replayHud.player2Name.removeEventListener(MouseEvent.CLICK,this.viewPlayer2);
         this.userInterface.hud.hud.replayHud.freeCamera.removeEventListener(MouseEvent.CLICK,this.setFreeCamera);
         this.userInterface.hud.hud.replayHud.fogOfWar.removeEventListener(MouseEvent.CLICK,this.setFogOfWar);
         this.userInterface.hud.hud.replayHud.pauseButton.removeEventListener(MouseEvent.CLICK,this.pauseButton);
         this.userInterface.hud.hud.replayHud.playButton.removeEventListener(MouseEvent.CLICK,this.playButton);
         this.userInterface.hud.hud.replayHud.forwardButton.removeEventListener(MouseEvent.CLICK,this.forwardButton);
         userInterface.cleanUp();
      }
      
      private function forwardButton(e:Event) : void
      {
         this.isFastForward = !this.isFastForward;
      }
      
      private function pauseButton(e:Event) : void
      {
         this.strictPause = true;
      }
      
      private function playButton(e:Event) : void
      {
         this.strictPause = false;
      }
      
      private function setFogOfWar(e:Event) : void
      {
         this.game.fogOfWar.isFogOn = !this.game.fogOfWar.isFogOn;
      }
      
      private function setFreeCamera(e:Event) : void
      {
         this.hasFreeCamera = !this.hasFreeCamera;
      }
      
      override public function leave() : void
      {
         this.cleanUp();
      }
      
      override public function endTurn() : void
      {
      }
      
      override public function endGame() : void
      {
         var e:EndOfGameMove = new EndOfGameMove();
         e.winner = game.winner.id;
         e.turn = simulation.turn;
         simulation.processMove(e);
         Main(main).postGameScreen.setReplayFile(simulation.gameReplay.toString(game));
         Main(main).postGameScreen.setWinner(e.winner,team.type,team.realName,team.enemyTeam.realName,team.id);
         Main(main).postGameScreen.setRecords(game.economyRecords,game.militaryRecords);
         Main(main).postGameScreen.setMode(PostGameScreen.M_SINGLEPLAYER,true);
         main.showScreen("postGame");
      }
      
      override public function doMove(move:Move, id:int) : void
      {
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
      }
      
      public function get replayString() : String
      {
         return this._replayString;
      }
      
      public function set replayString(value:String) : void
      {
         this._replayString = value;
      }
   }
}
