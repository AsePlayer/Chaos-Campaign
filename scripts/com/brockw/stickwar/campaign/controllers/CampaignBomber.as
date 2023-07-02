package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.campaign.InGameMessage;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
   import com.brockw.stickwar.engine.units.Bomber;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Miner;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class CampaignBomber extends CampaignController
   {
      
      private static const MIN_NUM_BOMBERS:int = 2;
      
      public static const MAX_NUM_BOMBERS:int = 10;
      
      private static const FREQUENCY_SPAWN:int = 45;
      
      private static const FREQUENCY_INCREASE:int = 60;
      
      private static const S_PLANT_BOMB:int = 0;
      
      private static const S_RUN_FROM_STATUE:int = 1;
      
      private static const S_GLOAT:int = 2;
      
      private static const S_SUICIDE:int = 3;
       
      
      private var medusaOneLiner:String;
      
      private var message:InGameMessage;
      
      private var medusaQueened:Boolean = false;
      
      private var state:int = 0;
      
      private var queenMedusa:Medusa;
      
      private var bomber:Bomber;
      
      private var introBomber:Bomber;
      
      private var middleBomber:Bomber;
      
      private var formationBreak:Boolean = false;
      
      private var bruh:int = 1;
      
      private var numToSpawn:int = 0;
      
      private var counter:int = -1;
      
      private var frames:int = 0;
      
      private var sevenMinTimer:int;
      
      private var sevenMinConstant:int;
      
      private var difficulty:int;
      
      internal var bomberTypes:Array;
      
      internal var waves:Array;
      
      internal var amounts:Array;
      
      internal var times:Array;
      
      internal var progression:int = 0;
      
      internal var randomNumber:int;
      
      internal var lastRandomNumber:int = -1;
      
      public function CampaignBomber(gameScreen:GameScreen)
      {
         this.sevenMinTimer = 60 * 30 * 7;
         this.sevenMinConstant = this.sevenMinTimer;
         this.bomberTypes = ["Default","minerTargeter","medusaTargeter","statueTargeter","clusterBoi"];
         this.waves = [0,0,-1,3,0,3,0,0,1,-1,1,-1,0,2,4,1,2,-1,3,3,1,2,4,3,-1,4];
         this.amounts = [1,2,0,1,3,0,1,2,0,1,1,2,3,2,0,2,1,3,1,0,1,1,2,1,2,2];
         this.times = [7,20,25,40,50,75,90,100,115,125,135,150,165,175,180,200,205,225,230,235,250,280,310,335,375,400];
         super(gameScreen);
         this.numToSpawn = MIN_NUM_BOMBERS;
         var randomNumber:int = Math.floor(Math.random() * 7) + 1;
         switch(randomNumber)
         {
            case 1:
               this.medusaOneLiner = "voiceTutorial1";
               break;
            case 2:
               this.medusaOneLiner = "voiceTutorial2";
               break;
            case 3:
               this.medusaOneLiner = "voiceTutorial3";
               break;
            case 4:
               this.medusaOneLiner = "voiceTutorial4";
               break;
            case 5:
               this.medusaOneLiner = "voiceTutorial5";
               break;
            case 6:
               this.medusaOneLiner = "voiceTutorial6";
               break;
            case 7:
               this.medusaOneLiner = "voiceTutorial7";
               break;
            default:
               this.medusaOneLiner = "voiceTutorial5";
         }
      }
      
      override public function update(gameScreen:GameScreen) : void
      {
         var ai:* = undefined;
         var targetedMiner:Miner = null;
         var targetedMedusa:Medusa = null;
         var targetedStatue:Unit = null;
         var minerCount:int = 0;
         var i:int = 0;
         var u:Unit = null;
         var u2:Unit = null;
         var _loc9_:UnitMove = null;
         this.difficulty = gameScreen.team.game.main.campaign.difficultyLevel;
         if(gameScreen.team.population > 0)
         {
            if(this.sevenMinConstant - 30 * this.times[this.progression] == this.sevenMinTimer || this.sevenMinConstant - 30 * this.times[this.progression] == this.sevenMinTimer + 1 && gameScreen.isFastForward)
            {
               i = 0;
               if(this.difficulty == 1)
               {
                  if(this.amounts[this.progression] != 1)
                  {
                     --this.amounts[this.progression];
                  }
               }
               else if(this.difficulty == 3)
               {
                  ++this.amounts[this.progression];
               }
               if(this.waves[this.progression] == -1)
               {
                  while(i < this.amounts[this.progression])
                  {
                     this.bomber = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                     gameScreen.team.enemyTeam.spawn(this.bomber,gameScreen.game);
                     this.randomNumber = Math.floor(Math.random() * (Math.pow(this.difficulty,3) + 4 * (1 / this.difficulty)));
                     while(this.randomNumber == this.lastRandomNumber)
                     {
                        this.randomNumber = Math.floor(Math.random() * (Math.pow(this.difficulty,3) + 4 * (1 / this.difficulty)));
                     }
                     if(this.randomNumber < 2 && this.difficulty != 3)
                     {
                        this.bomber.convertBomber(this.bomberTypes[0]);
                     }
                     else if(this.randomNumber < 4)
                     {
                        this.bomber.convertBomber(this.bomberTypes[1]);
                     }
                     else if(this.randomNumber < 7)
                     {
                        this.bomber.convertBomber(this.bomberTypes[2]);
                     }
                     else if(this.randomNumber < 12)
                     {
                        this.bomber.convertBomber(this.bomberTypes[2]);
                     }
                     else if(this.randomNumber < 14)
                     {
                        this.bomber.convertBomber(this.bomberTypes[0]);
                     }
                     else if(this.randomNumber < 16)
                     {
                        this.bomber.convertBomber(this.bomberTypes[3]);
                     }
                     else if(this.randomNumber < 19)
                     {
                        this.bomber.convertBomber(this.bomberTypes[1]);
                     }
                     else
                     {
                        this.bomber.convertBomber(this.bomberTypes[4]);
                     }
                     this.lastRandomNumber = this.randomNumber;
                     ++gameScreen.team.enemyTeam.population;
                     i++;
                  }
               }
               else
               {
                  while(i < this.amounts[this.progression])
                  {
                     this.bomber = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                     gameScreen.team.enemyTeam.spawn(this.bomber,gameScreen.game);
                     this.bomber.convertBomber(this.bomberTypes[this.waves[this.progression]]);
                     this.bomber.ai.alwaysAttack = true;
                     trace(this.amounts[this.progression] + " " + this.bomberTypes[this.waves[this.progression]] + " Bomber(s) made at " + this.times[this.progression] + ". This is Bomber #" + (i + 1));
                     ++gameScreen.team.enemyTeam.population;
                     i++;
                  }
               }
               ++this.progression;
            }
         }
         if(this.state == S_SUICIDE)
         {
            CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.01);
            CampaignGameScreen(gameScreen).enemyTeamAi.alwaysAttack = true;
         }
         else
         {
            gameScreen.team.enemyTeam.defend(true);
         }
         if(this.sevenMinTimer > 0)
         {
            if(!gameScreen.isPaused)
            {
               if(gameScreen.isFastForward)
               {
                  --this.sevenMinTimer;
               }
               --this.sevenMinTimer;
            }
         }
         else if(this.sevenMinTimer != -5)
         {
            this.bomber = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
            gameScreen.team.enemyTeam.spawn(this.bomber,gameScreen.game);
            this.bomber.bomberType = "statueEndsHere";
            this.bomber.explosionDamage = 99999;
            this.bomber.px = gameScreen.team.statue.px;
            this.bomber.py = gameScreen.team.statue.py;
            this.sevenMinTimer = -5;
         }
         if(!this.medusaQueened)
         {
            this.queenMedusa = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
            gameScreen.team.spawn(this.queenMedusa,gameScreen.game);
            this.queenMedusa.px = 420 * 2;
            gameScreen.team.population += 10;
            this.medusaQueened = true;
            this.state = S_PLANT_BOMB;
         }
         if(!gameScreen.isPaused)
         {
            if(this.state < S_SUICIDE && this.state >= S_RUN_FROM_STATUE)
            {
               gameScreen.userInterface.selectedUnits.clear();
               _loc9_ = new UnitMove();
               _loc9_.owner = gameScreen.game.team.id;
               _loc9_.moveType = UnitCommand.HOLD;
               _loc9_.arg0 = this.queenMedusa.px;
               _loc9_.arg1 = this.queenMedusa.py;
               _loc9_.units.push(this.queenMedusa.id);
               _loc9_.execute(gameScreen.game);
            }
            if(this.state == S_PLANT_BOMB)
            {
               gameScreen.userInterface.selectedUnits.clear();
               gameScreen.userInterface.isGlobalsEnabled = false;
               gameScreen.userInterface.hud.hud.fastForward.visible = false;
               if(this.counter == -1)
               {
                  this.introBomber = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                  gameScreen.team.enemyTeam.spawn(this.introBomber,gameScreen.game);
                  this.introBomber.bomberType = "Intro";
                  this.introBomber.px = gameScreen.team.statue.px + 25;
                  this.introBomber.py = gameScreen.team.statue.py + 10;
                  this.introBomber.ai.mayAttack = false;
                  this.introBomber.ai.mayMoveToAttack = false;
                  delete gameScreen.team.unitsAvailable[Unit.U_CHAOS_MINER];
                  delete gameScreen.team.unitsAvailable[Unit.U_MEDUSA];
                  delete gameScreen.team.unitsAvailable[Unit.U_KNIGHT];
                  if(!gameScreen.isPaused)
                  {
                     ++this.counter;
                  }
               }
               this.introBomber.ai.mayAttack = false;
               this.introBomber.ai.mayMoveToAttack = false;
               if(this.counter++ < 30 * 0.75 && !gameScreen.isPaused)
               {
                  _loc9_ = new UnitMove();
                  _loc9_.owner = gameScreen.game.team.enemyTeam.id;
                  _loc9_.moveType = UnitCommand.HOLD;
                  _loc9_.arg0 = this.introBomber.px;
                  _loc9_.arg1 = this.introBomber.py;
                  _loc9_.units.push(this.introBomber.id);
                  _loc9_.execute(gameScreen.game);
                  this.message = new InGameMessage("",gameScreen.game);
                  this.message.x = gameScreen.game.stage.stageWidth / 2;
                  this.message.y = gameScreen.game.stage.stageHeight / 4 - 75;
                  this.message.scaleX *= 1.3;
                  this.message.scaleY *= 1.3;
                  gameScreen.addChild(this.message);
                  this.message.setMessage("Queen Medusa: What are you doing, Midget?","",0,"voiceTutorial6");
                  this.frames = 0;
               }
               else if(this.counter++ > 30 * 4 && !gameScreen.isPaused)
               {
                  _loc9_ = new UnitMove();
                  _loc9_.owner = gameScreen.game.team.enemyTeam.id;
                  _loc9_.moveType = UnitCommand.HOLD;
                  _loc9_.arg0 = gameScreen.team.statue.px + 250;
                  _loc9_.arg1 = gameScreen.game.map.height / 2;
                  _loc9_.units.push(this.introBomber.id);
                  _loc9_.execute(gameScreen.game);
                  if(this.counter > 30 * 4 && !gameScreen.isPaused)
                  {
                     this.state = S_RUN_FROM_STATUE;
                     this.counter = 0;
                  }
               }
            }
            else if(this.state == S_RUN_FROM_STATUE)
            {
               this.introBomber.ai.mayAttack = false;
               this.introBomber.ai.mayMoveToAttack = false;
               _loc9_ = new UnitMove();
               _loc9_.owner = gameScreen.game.team.enemyTeam.id;
               _loc9_.moveType = UnitCommand.HOLD;
               _loc9_.arg0 = gameScreen.team.statue.px + 250;
               _loc9_.arg1 = gameScreen.game.map.height / 2;
               _loc9_.units.push(this.introBomber.id);
               _loc9_.execute(gameScreen.game);
               if(this.counter++ < 30 * 2.5 && !gameScreen.isPaused)
               {
                  _loc9_ = new UnitMove();
                  _loc9_.owner = gameScreen.game.team.enemyTeam.id;
                  _loc9_.moveType = UnitCommand.HOLD;
                  _loc9_.arg0 = gameScreen.team.statue.px + 250;
                  _loc9_.arg1 = gameScreen.game.map.height / 2;
                  _loc9_.units.push(this.introBomber.id);
                  _loc9_.execute(gameScreen.game);
                  this.message.setMessage("Bomber: You hold no power over us any longer...","");
               }
               else if(this.counter++ > 30 * 4.5 && !gameScreen.isPaused)
               {
                  this.state = S_GLOAT;
                  this.counter = 0;
               }
               else if(this.counter++ > 30 * 3 && !gameScreen.isPaused)
               {
                  gameScreen.userInterface.selectedUnits.clear();
                  _loc9_ = new UnitMove();
                  _loc9_.owner = gameScreen.game.team.id;
                  _loc9_.moveType = UnitCommand.HOLD;
                  _loc9_.arg0 = this.queenMedusa.px;
                  _loc9_.arg1 = this.queenMedusa.py;
                  _loc9_.units.push(this.queenMedusa.id);
                  _loc9_.execute(gameScreen.game);
               }
            }
            else if(this.state == S_GLOAT)
            {
               this.message.setMessage("Bomber: You have 7 minutes. May your suffering be eternal; I know mine ends here.","");
               this.introBomber.ai.mayAttack = false;
               this.introBomber.ai.mayMoveToAttack = false;
               _loc9_ = new UnitMove();
               _loc9_.owner = gameScreen.game.team.enemyTeam.id;
               _loc9_.moveType = UnitCommand.HOLD;
               _loc9_.arg0 = gameScreen.team.statue.px + 250;
               _loc9_.arg1 = gameScreen.game.map.height / 2;
               _loc9_.units.push(this.introBomber.id);
               _loc9_.execute(gameScreen.game);
            }
            if(this.message && gameScreen.contains(this.message) && !gameScreen.isPaused)
            {
               this.message.update();
               if(this.frames++ > 30 * 10)
               {
                  gameScreen.removeChild(this.message);
                  this.introBomber.detonate();
                  this.state = S_SUICIDE;
                  this.middleBomber = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                  gameScreen.team.enemyTeam.spawn(this.middleBomber,gameScreen.game);
                  this.middleBomber.px = gameScreen.game.map.width / 2 + 50;
                  this.middleBomber.py = gameScreen.game.map.height / 2;
                  this.middleBomber.bomberType = "MiddleBoi";
                  gameScreen.userInterface.isGlobalsEnabled = true;
                  gameScreen.userInterface.hud.hud.fastForward.visible = true;
                  gameScreen.team.unitsAvailable[Unit.U_KNIGHT] = 1;
                  gameScreen.team.unitsAvailable[Unit.U_CHAOS_MINER] = 1;
                  gameScreen.team.unitsAvailable[Unit.U_MEDUSA] = 1;
               }
               else if(this.frames == 30 * 9.25 - 0.5)
               {
                  gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                  gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                  gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                  gameScreen.team.population += 6;
               }
            }
         }
         gameScreen.game.team.enemyTeam.tech.isResearchedMap[Tech.GIANT_GROWTH_I] = true;
         gameScreen.game.team.enemyTeam.tech.isResearchedMap[Tech.GIANT_GROWTH_II] = true;
         if(gameScreen.team.population > 0)
         {
            for each(u in gameScreen.team.enemyTeam.units)
            {
               if(u.type == Unit.U_BOMBER && u.bomberType == "MiddleBoi")
               {
                  _loc9_ = new UnitMove();
                  _loc9_.owner = gameScreen.game.team.enemyTeam.id;
                  _loc9_.moveType = UnitCommand.HOLD;
                  _loc9_.arg0 = gameScreen.game.map.width / 2;
                  _loc9_.arg1 = gameScreen.game.map.height / 2 + 50;
                  _loc9_.units.push(this.middleBomber.id);
                  _loc9_.execute(gameScreen.game);
               }
            }
         }
      }
   }
}
