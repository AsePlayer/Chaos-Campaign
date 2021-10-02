package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Util;
   import com.brockw.simulationSync.EndOfTurnMove;
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.SimulationSyncronizer;
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.UserInterface;
   import com.brockw.stickwar.engine.multiplayer.moves.EndOfGameMove;
   import com.brockw.stickwar.engine.multiplayer.moves.MoveFactory;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import com.smartfoxserver.v2.requests.LogoutRequest;
   import flash.utils.ByteArray;
   
   public class MultiplayerGameScreen extends GameScreen
   {
       
      
      private var isOutOfSync:Boolean;
      
      public function MultiplayerGameScreen(main:Main)
      {
         super(main);
      }
      
      public function init(raceParams:SFSObject) : void
      {
         var a:int = 0;
         var b:int = 0;
         if(!main.stickWar)
         {
            main.stickWar = new StickWar(main,this);
         }
         game = main.stickWar;
         simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
         this.addChild(game);
         game.initGame(main,this,Main(main).gameRoom.getVariable("map").getIntValue());
         this.isOutOfSync = false;
         trace("START GAME RANDOM:",1000 * game.random.lastRandom);
         a = Main(main).gameRoom.playerList[0].id;
         b = Main(main).gameRoom.playerList[1].id;
         var aLabel:String = "race_" + User(Main(main).gameRoom.playerList[0]).name;
         var bLabel:String = "race_" + User(Main(main).gameRoom.playerList[1]).name;
         var aMemberLabel:String = "member_" + User(Main(main).gameRoom.playerList[0]).name;
         var bMemberLabel:String = "member_" + User(Main(main).gameRoom.playerList[1]).name;
         var teamAName:int = raceParams.getInt(User(Main(main).gameRoom.playerList[0]).name);
         var teamBName:int = raceParams.getInt(User(Main(main).gameRoom.playerList[1]).name);
         var teamARealName:String = User(Main(main).gameRoom.playerList[0]).name;
         var teamBRealName:String = User(Main(main).gameRoom.playerList[1]).name;
         var teamARating:Number = User(Main(main).gameRoom.playerList[0]).getVariable("rating").getDoubleValue();
         var teamBRating:Number = User(Main(main).gameRoom.playerList[1]).getVariable("rating").getDoubleValue();
         trace(teamAName,teamBName,raceParams,Main(main).gameRoom.getVariable(aMemberLabel).getBoolValue(),Main(main).gameRoom.getVariable(bMemberLabel).getBoolValue());
         if(a > b)
         {
            a = Main(main).gameRoom.playerList[1].id;
            b = Main(main).gameRoom.playerList[0].id;
            game.initTeams(teamBName,teamAName,game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health);
            game.teamA.loadout.fromString(Main(main).gameRoom.getVariable(User(Main(main).gameRoom.playerList[1]).name).getStringValue());
            game.teamB.loadout.fromString(Main(main).gameRoom.getVariable(User(Main(main).gameRoom.playerList[0]).name).getStringValue());
            game.teamA.realName = teamBRealName;
            game.teamB.realName = teamARealName;
            game.teamA.isMember = Main(main).gameRoom.getVariable(bMemberLabel).getBoolValue();
            game.teamB.isMember = Main(main).gameRoom.getVariable(aMemberLabel).getBoolValue();
            game.teamA.rating = teamBRating;
            game.teamB.rating = teamARating;
         }
         else
         {
            game.initTeams(teamAName,teamBName,game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health);
            game.teamB.loadout.fromString(Main(main).gameRoom.getVariable(User(Main(main).gameRoom.playerList[1]).name).getStringValue());
            game.teamA.loadout.fromString(Main(main).gameRoom.getVariable(User(Main(main).gameRoom.playerList[0]).name).getStringValue());
            game.teamA.realName = teamARealName;
            game.teamB.realName = teamBRealName;
            game.teamB.isMember = Main(main).gameRoom.getVariable(bMemberLabel).getBoolValue();
            game.teamA.isMember = Main(main).gameRoom.getVariable(aMemberLabel).getBoolValue();
            game.teamA.rating = teamARating;
            game.teamB.rating = teamBRating;
         }
         if(a == Main(main).gameServer.mySelf.id)
         {
            team = game.teamA;
         }
         if(b == Main(main).gameServer.mySelf.id)
         {
            team = game.teamB;
         }
         game.team = team;
         game.teamA.id = a;
         game.teamB.id = b;
         game.teamA.name = a;
         game.teamB.name = b;
         this.team.enemyTeam.isEnemy = true;
         userInterface = new UserInterface(main,this);
         addChild(userInterface);
         userInterface.init(game.team);
         trace("BEFORE INIT:",1000 * game.random.lastRandom);
         game.init(0);
         Main(main).gameServer.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.extensionResponse);
         game.postInit();
         game.teamA.spawnMiners();
         game.teamB.spawnMiners();
      }
      
      override public function judgementFrame() : void
      {
         trace("SEND THE JUDGEMENT OF",simulation.fps);
         var o:SFSObject = new SFSObject();
         o.putInt("fps",simulation.fps);
         Main(main).sfs.send(new ExtensionRequest("setFPS",o));
      }
      
      override public function enter() : void
      {
         super.enter();
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
         Util.clearSFSObject(simulation.data);
         simulation.endOfTurnMove.writeToSFSObject(simulation.data);
         simulation.data.putInt("c",game.getCheckSum());
         Main(main).gameServer.send(new ExtensionRequest("m",simulation.data,Main(main).gameRoom));
         simulation.movesInTurn = 0;
      }
      
      override public function endGame() : void
      {
         var e:EndOfGameMove = new EndOfGameMove();
         e.winner = game.winner.id;
         var data:SFSObject = new SFSObject();
         e.writeToSFSObject(data);
         Main(main).gameServer.send(new ExtensionRequest("o",data,Main(main).gameRoom));
      }
      
      override public function doMove(move:Move, id:int) : void
      {
         var o:SFSObject = new SFSObject();
         move.init(id,simulation.frame,simulation.turn);
         move.writeToSFSObject(o);
         Main(main).gameServer.send(new ExtensionRequest("m",o,Main(main).gameRoom));
         ++simulation.movesInTurn;
      }
      
      public function extensionResponse(evt:SFSEvent) : void
      {
         var _loc3_:SFSObject = null;
         var _loc4_:ByteArray = null;
         var _loc5_:String = null;
         var _loc6_:Entity = null;
         var _loc2_:SFSObject = evt.params.params;
         switch(evt.params.cmd)
         {
            case "s":
               this.simulation.init(0);
               this.simulation.hasStarted = true;
               main.showScreen("game");
               trace("Start game");
               break;
            case "m":
               simulation.processMove(MoveFactory.createMove(_loc2_));
               break;
            case "f":
               trace("Game finalised");
               _loc3_ = new SFSObject();
               main.gameServer.send(new ExtensionRequest("z",_loc3_,Main(main).gameRoom));
               if(main.gameServer != main.sfs)
               {
                  main.gameServer.send(new LogoutRequest());
               }
               main.showScreen("postGame");
               break;
            case "e":
               trace("End the game and send a game report. The winner is player with id: ",_loc2_.getInt("winner"));
               _loc3_ = new SFSObject();
               _loc4_ = new ByteArray();
               _loc4_.writeMultiByte("","iso-8859-1");
               _loc3_.putByteArray("replay",_loc4_);
               _loc3_.putInt("isOutOfSync",0);
               main.gameServer.send(new ExtensionRequest("g",_loc3_,Main(main).gameRoom));
               Main(main).postGameScreen.setMode(PostGameScreen.M_MULTIPLAYER);
               Main(main).postGameScreen.setReplayFile(simulation.gameReplay.toString(game));
               Main(main).postGameScreen.setWinner(_loc2_.getInt("winner"),team.type,team.realName,team.enemyTeam.realName,team.id);
               Main(main).postGameScreen.setRatings(team.rating,team.enemyTeam.rating);
               Main(main).postGameScreen.setRecords(game.economyRecords,game.militaryRecords);
               break;
            case "c":
               break;
            case "r":
               trace("client is reconnecting");
               break;
            case "u":
               trace("client is reconnected");
               break;
            case "userTimeout":
               showTimeout(_loc2_.getUtfString("user"),_loc2_.getLong("timeLeft"));
               trace("Timeout: " + _loc2_.getUtfString("user"),_loc2_.getLong("timeLeft"));
               break;
            case "outOfSync":
               _loc5_ = simulation.gameReplay.toString(game);
               _loc3_ = new SFSObject();
               Main(main).postGameScreen.setMode(PostGameScreen.M_MULTIPLAYER);
               _loc4_ = new ByteArray();
               _loc4_.writeMultiByte(simulation.gameReplay.toString(game),"iso-8859-1");
               _loc3_.putByteArray("replay",_loc4_);
               _loc3_.putInt("isOutOfSync",1);
               main.gameServer.send(new ExtensionRequest("g",_loc3_,Main(main).gameRoom));
               trace("Out of Sync");
               for each(_loc6_ in game.units)
               {
                  trace("Unit: ",_loc6_.type,_loc6_.x,_loc6_.y,_loc6_.px,_loc6_.py);
               }
               this.isOutOfSync = false;
               showSyncError();
               Main(main).postGameScreen.setMode(PostGameScreen.M_SYNC_ERROR);
         }
      }
      
      override public function cleanUp() : void
      {
         Main(main).gameServer.removeEventListener(SFSEvent.EXTENSION_RESPONSE,this.extensionResponse);
         super.cleanUp();
      }
   }
}
