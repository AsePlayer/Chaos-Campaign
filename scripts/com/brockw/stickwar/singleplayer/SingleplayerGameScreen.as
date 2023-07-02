package com.brockw.stickwar.singleplayer
{
   import com.brockw.simulationSync.EndOfTurnMove;
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.SimulationSyncronizer;
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.UserInterface;
   import com.brockw.stickwar.engine.multiplayer.PostGameScreen;
   import com.brockw.stickwar.engine.multiplayer.moves.EndOfGameMove;
   import com.brockw.stickwar.engine.units.Statue;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.events.Event;
   
   public class SingleplayerGameScreen extends GameScreen
   {
       
      
      private var enemyTeamAi:com.brockw.stickwar.singleplayer.EnemyTeamAi;
      
      public function SingleplayerGameScreen(main:Main)
      {
         super(main);
      }
      
      override public function enter() : void
      {
         var a:int = 0;
         var b:int = 0;
         if(!main.stickWar)
         {
            main.stickWar = new StickWar(main,this);
         }
         game = main.stickWar;
         simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
         simulation.init(0);
         this.addChild(game);
         game.initGame(main,this,main.xml.xml.sandboxMap);
         userInterface = new UserInterface(main,this);
         addChild(userInterface);
         a = 0;
         b = 1;
         game.initTeams(Team.getIdFromRaceName(game.xml.xml.debugTeamA),Team.getIdFromRaceName(game.xml.xml.debugTeamB),game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health);
         team = game.teamA;
         game.team = team;
         game.teamA.id = a;
         game.teamB.id = b;
         game.team.realName = "Myself";
         game.team.enemyTeam.realName = "AI";
         game.teamA.gold = 100000;
         game.teamB.gold = 100000;
         game.teamA.mana = 100000;
         game.teamB.mana = 100000;
         game.teamA.name = a;
         game.teamB.name = b;
         this.team.enemyTeam.isEnemy = true;
         this.team.enemyTeam.isAi = true;
         userInterface.init(game.team);
         if(team.enemyTeam.type == Team.T_GOOD)
         {
            this.enemyTeamAi = new EnemyGoodTeamAi(team.enemyTeam,main,game,false);
         }
         else
         {
            this.enemyTeamAi = new EnemyChaosTeamAi(team.enemyTeam,main,game,false);
         }
         game.init(0);
         game.postInit();
         simulation.hasStarted = true;
         super.enter();
      }
      
      override public function update(evt:Event, timeDiff:Number) : void
      {
         var unit:Entity = null;
         var u:Unit = null;
         this.enemyTeamAi.update(game);
         if(this.userInterface.keyBoardState.isPressed(82))
         {
            for each(unit in game.units)
            {
               if(unit is Unit && !(unit is Statue))
               {
                  u = Unit(unit);
                  u.damage(0,u.maxHealth * 2,null);
               }
            }
         }
         if(this.userInterface.keyBoardState.isPressed(90))
         {
            team.enemyTeam.attack();
         }
         super.update(evt,timeDiff);
      }
      
      override public function leave() : void
      {
         this.cleanUp();
      }
      
      override public function endTurn() : void
      {
         simulation.endOfTurnMove = new EndOfTurnMove();
         simulation.endOfTurnMove.expectedNumberOfMoves = this.simulation.movesInTurn;
         simulation.endOfTurnMove.frameRate = simulation.frameRate;
         simulation.endOfTurnMove.turnSize = 5;
         simulation.endOfTurnMove.turn = simulation.turn;
         simulation.processMove(simulation.endOfTurnMove);
         simulation.movesInTurn = 0;
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
         Main(main).postGameScreen.setMode(PostGameScreen.M_SINGLEPLAYER);
         Main(main).showScreen("postGame");
      }
      
      override public function doMove(move:Move, id:int) : void
      {
         move.init(id,simulation.frame,simulation.turn);
         simulation.processMove(move);
         ++simulation.movesInTurn;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
      }
      
      override public function maySwitchOnDisconnect() : Boolean
      {
         return false;
      }
   }
}
