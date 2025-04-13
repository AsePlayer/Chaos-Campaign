package com.brockw.stickwar.campaign.controllers
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.campaign.CampaignGameScreen;
     import com.brockw.stickwar.campaign.InGameMessage;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
     import com.brockw.stickwar.engine.units.Bomber;
     import com.brockw.stickwar.engine.units.Cat;
     import com.brockw.stickwar.engine.units.Dead;
     import com.brockw.stickwar.engine.units.Giant;
     import com.brockw.stickwar.engine.units.Knight;
     import com.brockw.stickwar.engine.units.Medusa;
     import com.brockw.stickwar.engine.units.Miner;
     import com.brockw.stickwar.engine.units.MinerChaos;
     import com.brockw.stickwar.engine.units.Skelator;
     import com.brockw.stickwar.engine.units.Statue;
     import com.brockw.stickwar.engine.units.Unit;
     import com.brockw.stickwar.engine.units.Wingidon;
     
     public class CampaignShadow extends CampaignController
     {
          
          private static const S_DONE:int = -999;
          
          private static const S_INTRO_TEXT:int = -1;
          
          private static const S_FOLLOWUP_TEXT:int = 0;
          
          private static const S_FOLLOWUP_TEXT2:int = 1;
          
          private static const S_FOLLOWUP_TEXT3:int = 2;
          
          private static const S_FOLLOWUP_TEXT4:int = 3;
          
          private static const S_TOLD_YOU_SO:int = 4;
          
          private static const S_DONT_LOSE_TOWER:int = 5;
          
          private static const S_START_MINING:int = 6;
          
          private static const CRAWLER_REGROUP_TIME:int = 1200;
           
          
          private var bossMarrow:Skelator;
          
          private var poisonCheck:Boolean = false;
          
          private var ghostCheck:Boolean = false;
          
          private var middleWarning:Boolean = false;
          
          private var alphaAlive:Boolean = false;
          
          private var alphaCount:int = 0;
          
          private var comment:String = "Writing comments as a string because we can\'t save normal comments";
          
          private var message:InGameMessage;
          
          private var message2:InGameMessage;
          
          private var message3:InGameMessage;
          
          private var message4:InGameMessage;
          
          private var message5:InGameMessage;
          
          private var message6:InGameMessage;
          
          private var messageOpening:InGameMessage;
          
          private var state:int = -2;
          
          private var dialogue:String;
          
          private var counter:int;
          
          private var counterGoal:int = 0;
          
          private var frames:int;
          
          private var queenMedusa:Medusa;
          
          private var medusaQueened:Boolean = false;
          
          private var openingMessageSent:Boolean = false;
          
          private var currentLevelTitle:String;
          
          private var medusaOneLiner:String;
          
          private var timeSinceAlpha:int;
          
          private var cat:Cat;
          
          private var alphaCat:Cat;
          
          private var handicap:int;
          
          private var timeSinceLastCat:int;
          
          private var catDelay:int;
          
          private var randomNumber:int;
          
          private var bossGiant:Giant;
          
          private var giant:Giant;
          
          private var nah:Boolean = false;
          
          private var difficulty:int;
          
          private var isGiantBossDead:Boolean = false;
          
          private var crawlerRegroupTimer:int = 0;
          
          private var bomber:Bomber;
          
          private var one:Number = 1;
          
          private var medusaWarning:Boolean = false;
          
          private var stoneWarning:Boolean = false;
          
          private var minerWarning:Boolean = false;
          
          private var bossSpawned:Boolean = false;
          
          private var firstAlphaSpawned:Boolean = false;
          
          private var amountOfSpawn:int = 0;
          
          private var destroyStatueDelay:int;
          
          private var messageCounter:int = 0;
          
          internal var bomberTypes:Array;
          
          internal var bomberTypesForDifficulty:Array;
          
          internal var bomberFrequency:int;
          
          private var bomberFrequencyIncreaseAt:Number = 3;
          
          private var warnAboutReinforcementEclipsors:Boolean;
          
          internal var bomberTimer:int = -5;
          
          internal var bomberAmounts:int = 1;
          
          internal var giantTimer:int = 0;
          
          internal var tutorialTimer:int = 0;
          
          internal var timeUntilRescue:int;
          
          internal var rescued:Boolean;
          
          internal var hasted:Boolean;
          
          internal var maxDeads:int;
          
          internal var interruptMessage:Boolean;
          
          private var cutsceneDone:Boolean;
          
          private var enemyDefendNow:Boolean;
          
          private var enemyDefendIn:int;
          
          private var spawnMyBois:Boolean = false;
          
          private var spawnedBackupJug:Boolean = false;
          
          private var statueMiners:Array;
          
          private var statueMinersSpawned:Boolean;
          
          private var miner1:MinerChaos;
          
          private var miner2:MinerChaos;
          
          private var miner3:MinerChaos;
          
          private var minerStatueOffset:int;
          
          private var bigBoomWarning:Boolean;
          
          private var lol:Boolean;
          
          public function CampaignShadow(gameScreen:GameScreen)
          {
               this.bomberFrequencyIncreaseAt = 3;
               this.timeUntilRescue = 60 * 3 * 30;
               this.maxDeads = 0;
               this.bomberTypes = ["Default","minerTargeter","medusaTargeter","statueTargeter","clusterBoi"];
               this.catDelay = 30 * 5;
               super(gameScreen);
               this.currentLevelTitle = gameScreen.main.campaign.getCurrentLevel().title;
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
               var randomNum:int = 0;
               var dead:Dead = null;
               var deadsToSpawn:* = 0;
               var wingidon:Wingidon = null;
               var i:int = 0;
               var _loc9_:UnitMove = null;
               var z:int = 0;
               var enemyStatue:Statue = null;
               var u2:Unit = null;
               var localCat:Cat = null;
               var u:* = undefined;
               this.bomberTypesForDifficulty = [[this.bomberTypes[0]],[this.bomberTypes[1],this.bomberTypes[2],this.bomberTypes[2]],[this.bomberTypes[1],this.bomberTypes[1],this.bomberTypes[1],this.bomberTypes[2],this.bomberTypes[2],this.bomberTypes[3],this.bomberTypes[4]],[this.bomberTypes[1],this.bomberTypes[3],this.bomberTypes[3],this.bomberTypes[4],this.bomberTypes[4]]];
               if(!this.medusaQueened)
               {
                    this.queenMedusa = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
                    gameScreen.team.spawn(this.queenMedusa,gameScreen.game);
                    this.queenMedusa.px = 420 * 2;
                    gameScreen.team.population += 10;
                    this.difficulty = gameScreen.team.game.main.campaign.difficultyLevel;
                    this.handicap = -1 * int(this.difficulty) + 2;
                    this.medusaQueened = true;
                    this.bomberFrequencyIncreaseAt = 3;
               }
               if(this.maxDeads == 0)
               {
                    this.maxDeads = gameScreen.team.game.main.campaign.difficultyLevel;
               }
               if(this.message2 && gameScreen.contains(this.message2) && !gameScreen.isPaused && gameScreen.game.winner == null)
               {
                    this.message2.update();
                    if(this.frames++ > 30 * 8)
                    {
                         gameScreen.removeChild(this.message2);
                         this.frames = -1;
                    }
               }
               else if(this.message3 && gameScreen.contains(this.message3) && !gameScreen.isPaused && gameScreen.game.winner == null)
               {
                    this.message3.update();
                    if(this.frames++ > 30 * 6)
                    {
                         gameScreen.removeChild(this.message3);
                         this.frames = -1;
                    }
               }
               else if(this.message4 && gameScreen.contains(this.message4) && !gameScreen.isPaused && gameScreen.game.winner == null)
               {
                    this.message4.update();
                    if(this.frames++ > 30 * 8)
                    {
                         gameScreen.removeChild(this.message4);
                         this.frames = -1;
                    }
               }
               else if(this.message5 && gameScreen.contains(this.message5) && !gameScreen.isPaused && gameScreen.game.winner == null)
               {
                    this.message5.update();
                    if(this.frames++ > 30 * 7)
                    {
                         gameScreen.removeChild(this.message5);
                         this.frames = -1;
                    }
               }
               else if(this.message6 && gameScreen.contains(this.message6) && !gameScreen.isPaused && gameScreen.game.winner == null)
               {
                    this.message6.update();
                    if(this.frames++ > 30 * 7)
                    {
                         gameScreen.removeChild(this.message6);
                         this.frames = -1;
                    }
               }
               else if(this.messageOpening && gameScreen.contains(this.messageOpening) && !gameScreen.isPaused)
               {
                    this.messageOpening.update();
                    if(this.frames++ > 30 * 8)
                    {
                         gameScreen.removeChild(this.messageOpening);
                         this.frames = -1;
                    }
               }
               if(this.message && gameScreen.contains(this.message) && !gameScreen.isPaused && gameScreen.game.winner == null)
               {
                    this.message.update();
                    if(this.frames++ > 30 * 7)
                    {
                         gameScreen.removeChild(this.message);
                         this.frames = -1;
                    }
               }
               if(!this.message)
               {
                    if(!this.openingMessageSent)
                    {
                         this.messageOpening = new InGameMessage("",gameScreen.game);
                         this.messageOpening.x = gameScreen.game.stage.stageWidth / 2;
                         this.messageOpening.y = gameScreen.game.stage.stageHeight / 4 - 75;
                         this.messageOpening.scaleX *= 1.3;
                         this.messageOpening.scaleY *= 1.3;
                         gameScreen.addChild(this.messageOpening);
                         if(this.currentLevelTitle == "Medusa")
                         {
                              this.messageOpening.setMessage("Queen Medusa: I must remind these dissenters of their place...","",0,this.medusaOneLiner);
                              gameScreen.team.spawnUnitGroup([Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                              gameScreen.team.enemyTeam.spawnUnitGroup([Unit.U_KNIGHT,Unit.U_CHAOS_MINER]);
                         }
                         else if(this.currentLevelTitle == "Apex Of The Forest: Crawlers Attack")
                         {
                              this.messageOpening.setMessage("Queen Medusa: Stupid monkeys...","",0,this.medusaOneLiner);
                              gameScreen.team.spawnUnitGroup([Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                              gameScreen.team.enemyTeam.spawnUnitGroup([Unit.U_CAT,Unit.U_CAT,Unit.U_CHAOS_MINER]);
                         }
                         else if(this.currentLevelTitle == "Monstrous Mire: Giants Attack")
                         {
                              this.messageOpening.setMessage("Queen Medusa: So HE\'S the one organizing all of this...","",0,this.medusaOneLiner);
                              gameScreen.team.spawnUnitGroup([Unit.U_CAT,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                         }
                         else if(this.currentLevelTitle == "Reach For The Sky: Eclipsors Attack")
                         {
                              this.messageOpening.setMessage("Queen Medusa: Pesky flies...","",0,this.medusaOneLiner);
                              gameScreen.team.spawnUnitGroup([Unit.U_GIANT,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                              gameScreen.team.enemyTeam.spawnUnitGroup([Unit.U_WINGIDON,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                         }
                         else if(this.currentLevelTitle == "Undead Ambush: Endless Deads Attack")
                         {
                              this.messageOpening.setMessage("Queen Medusa: The Deads shall be my devoted legion, their minds surrendered to my will...","",0,this.medusaOneLiner);
                              gameScreen.team.spawnUnitGroup([Unit.U_WINGIDON,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                         }
                         else if(this.currentLevelTitle == "Marrowkai\'s Power Grab: Reclaiming the Throne")
                         {
                              this.messageOpening.setMessage("Queen Medusa: You have grown powerful in my absence, bag of bones...","",0,this.medusaOneLiner);
                         }
                         else if(this.difficulty == 1)
                         {
                              this.messageOpening.setMessage("That\'s all the levels for now! Replay on HARD Mode for a tougher challenge.","",0,"Pain14");
                         }
                         else if(this.difficulty == 2)
                         {
                              this.messageOpening.setMessage("That\'s all the levels for now! Replay on INSANE Mode for the toughest challenge.","",0,"Pain14");
                         }
                         else if(this.difficulty == 3)
                         {
                              this.messageOpening.setMessage("That\'s all the levels for now! Congrats on beating INSANE Mode!","",0,"Pain14");
                         }
                         if(this.currentLevelTitle == "Marrowkai\'s Power Grab: Reclaiming the Throne")
                         {
                              this.frames = 90;
                         }
                         else
                         {
                              this.frames = 0;
                         }
                         this.openingMessageSent = true;
                    }
                    if(this.currentLevelTitle == "Medusa")
                    {
                         for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_KNIGHT])
                         {
                              u.charger = true;
                         }
                         CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(1);
                         if(gameScreen.game.frame > 1000)
                         {
                              CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.9);
                         }
                         if(!this.poisonCheck && this.frames == -1)
                         {
                              for each(u in gameScreen.team.units)
                              {
                                   if(u.isPoisoned())
                                   {
                                        this.message2 = new InGameMessage("",gameScreen.game);
                                        this.message2.x = gameScreen.game.stage.stageWidth / 2;
                                        this.message2.y = gameScreen.game.stage.stageHeight / 4 - 75;
                                        this.message2.scaleX *= 1.3;
                                        this.message2.scaleY *= 1.3;
                                        gameScreen.addChild(this.message2);
                                        this.message2.setMessage("Cure your Units of poison by garrisoning them or letting them auto-cure after some time.","");
                                        this.frames = 0;
                                        this.poisonCheck = true;
                                        break;
                                   }
                              }
                         }
                         if(!this.ghostCheck && this.frames == -1)
                         {
                              for each(u in gameScreen.team.enemyTeam.units)
                              {
                                   if(u.isTowerSpawned)
                                   {
                                        this.message2 = new InGameMessage("",gameScreen.game);
                                        this.message2.x = gameScreen.game.stage.stageWidth / 2;
                                        this.message2.y = gameScreen.game.stage.stageHeight / 4 - 75;
                                        this.message2.scaleX *= 1.3;
                                        this.message2.scaleY *= 1.3;
                                        gameScreen.addChild(this.message2);
                                        this.message2.setMessage("Told ya so...","");
                                        this.frames = 0;
                                        this.ghostCheck = true;
                                        break;
                                   }
                              }
                         }
                         if(gameScreen.team.enemyTeam.forwardUnit && gameScreen.team.enemyTeam.forwardUnit.x < gameScreen.game.map.width / 2 + 20 && !this.middleWarning && this.frames == -1)
                         {
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("Don\'t lose control of the Middle Tower. You will regret it...","");
                              this.frames = 0;
                              this.middleWarning = true;
                         }
                         if(!this.medusaWarning && this.queenMedusa.health < this.queenMedusa.maxHealth / 2 && this.frames == -1)
                         {
                              this.message4 = new InGameMessage("",gameScreen.game);
                              this.message4.x = gameScreen.game.stage.stageWidth / 2;
                              this.message4.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message4.scaleX *= 1.3;
                              this.message4.scaleY *= 1.3;
                              gameScreen.addChild(this.message4);
                              this.message4.setMessage("Do everything in your power to keep Queen Medusa alive. If she dies, you lose!","");
                              this.frames = 0;
                              this.medusaWarning = true;
                         }
                         if(this.queenMedusa.inStoneSpell && !this.stoneWarning && this.frames == -1)
                         {
                              this.message5 = new InGameMessage("",gameScreen.game);
                              this.message5.x = gameScreen.game.stage.stageWidth / 2;
                              this.message5.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message5.scaleX *= 1.3;
                              this.message5.scaleY *= 1.3;
                              gameScreen.addChild(this.message5);
                              this.message5.setMessage("Queen Medusa\'s Stone ability is one of the most powerful in her arsenal, dealing bonus heavy damage! Use it wisely.","");
                              this.frames = 0;
                              this.stoneWarning = true;
                         }
                         if(gameScreen.team.getNumberOfMiners() >= 6 && !this.minerWarning && this.frames == -1)
                         {
                              this.message6 = new InGameMessage("",gameScreen.game);
                              this.message6.x = gameScreen.game.stage.stageWidth / 2;
                              this.message6.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message6.scaleX *= 1.3;
                              this.message6.scaleY *= 1.3;
                              gameScreen.addChild(this.message6);
                              this.message6.setMessage("Enslaved Miners are perfect fodder for the battlefield when push comes to shove!","");
                              this.frames = 0;
                              this.minerWarning = true;
                         }
                    }
                    else if(this.currentLevelTitle == "Apex Of The Forest: Crawlers Attack")
                    {
                         if(!bomber || bomber && bomber.isDead)
                         {
                              bomber = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                              bomber.bomberType = "stunBomber";
                              gameScreen.team.spawn(bomber,gameScreen.game);
                              ++gameScreen.team.population;
                              _loc9_ = new UnitMove();
                              _loc9_.moveType = UnitCommand.ATTACK_MOVE;
                              _loc9_.units.push(bomber.id);
                              _loc9_.owner = gameScreen.team.id;
                              _loc9_.arg0 = gameScreen.team.enemyTeam.statue.px;
                              _loc9_.arg1 = gameScreen.team.enemyTeam.statue.py;
                              _loc9_.execute(gameScreen.game);
                              if(this.message3 && !gameScreen.contains(this.message3) && !(this.message5 && gameScreen.contains(this.message5)) && this.messageCounter == 1)
                              {
                                   this.message3 = new InGameMessage("",gameScreen.game);
                                   this.message3.x = gameScreen.game.stage.stageWidth / 2;
                                   this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                                   this.message3.scaleX *= 1.3;
                                   this.message3.scaleY *= 1.3;
                                   gameScreen.addChild(this.message3);
                                   this.message3.setMessage("Stun Bombers, who dared make an attempt on the Queen\'s life, will now face their punishment in a solemn death march: one by one...","");
                                   this.frames = 0;
                                   this.messageCounter = 2;
                              }
                         }
                         if(this.messageOpening && !gameScreen.contains(this.messageOpening) && this.messageCounter == 0)
                         {
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("The recently conquered Bombers are excited to display unwavering loyalty to Medusa in this battle...","");
                              this.frames = 0;
                              this.messageCounter = 1;
                         }
                         if(!gameScreen.isPaused)
                         {
                              if(true == false)
                              {
                                   gameScreen.team.mana = gameScreen.team.enemyTeam.getNumberOfCats();
                                   gameScreen.team.gold = this.crawlerRegroupTimer;
                              }
                              if(gameScreen.team.enemyTeam.getNumberOfCats() <= int(1 + 2 * int(this.difficulty)))
                              {
                                   if(this.timeSinceLastCat >= this.catDelay && this.alphaAlive == false && gameScreen.team.enemyTeam.getNumberOfCats() <= int(1 + int(this.difficulty)))
                                   {
                                        this.catDelay += 90;
                                        this.timeSinceLastCat = 0;
                                        this.cat = Cat(gameScreen.game.unitFactory.getUnit(Unit.U_CAT));
                                        gameScreen.team.enemyTeam.spawn(this.cat,gameScreen.game);
                                        ++gameScreen.team.enemyTeam.population;
                                   }
                                   else
                                   {
                                        ++this.timeSinceLastCat;
                                   }
                                   if(gameScreen.team.enemyTeam.getNumberOfCats() >= int(2 + int(this.difficulty)) && this.crawlerRegroupTimer > CRAWLER_REGROUP_TIME)
                                   {
                                        this.comment = "gameScreen.team.enemyTeam.attack(true)";
                                        CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.75);
                                        this.comment = "stop defending";
                                   }
                                   else if(gameScreen.team.enemyTeam.getNumberOfCats() >= int(2 + int(this.difficulty)) && this.crawlerRegroupTimer != CRAWLER_REGROUP_TIME)
                                   {
                                        this.crawlerRegroupTimer += gameScreen.team.enemyTeam.getNumberOfCats();
                                        this.comment = "gameScreen.team.enemyTeam.defend(true)";
                                        CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(2);
                                   }
                                   else if(gameScreen.team.enemyTeam.forwardUnit && gameScreen.team.enemyTeam.forwardUnit.px > gameScreen.team.forwardUnit.px + 750 || gameScreen.team.enemyTeam.forwardUnit && gameScreen.team.forwardUnit.px < gameScreen.team.enemyTeam.statue.px - 900)
                                   {
                                        this.crawlerRegroupTimer = 0;
                                        this.comment = "gameScreen.team.enemyTeam.defend(true)";
                                        CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(2);
                                   }
                              }
                              else if(this.crawlerRegroupTimer >= CRAWLER_REGROUP_TIME)
                              {
                                   this.comment = "stop defending";
                                   this.comment = "gameScreen.team.enemyTeam.attack(true)";
                                   CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.5);
                              }
                              else
                              {
                                   if(this.alphaAlive)
                                   {
                                        this.crawlerRegroupTimer += 2;
                                   }
                                   ++this.crawlerRegroupTimer;
                              }
                              this.alphaCount = 0;
                              for each(u2 in gameScreen.team.enemyTeam.units)
                              {
                                   if(u2.type == Unit.U_CAT)
                                   {
                                        this.alphaCount += u2.isAlpha;
                                   }
                              }
                              if(this.alphaCount == 0)
                              {
                                   if(gameScreen.team.enemyTeam.getNumberOfCats() > 2 + this.handicap && !this.alphaAlive && this.timeSinceAlpha > 30 * 60 + 15 * this.handicap || this.timeSinceAlpha > 30 * 60 * 1.5 + 15 * this.handicap && !this.alphaAlive)
                                   {
                                        this.alphaCat = Cat(gameScreen.game.unitFactory.getUnit(Unit.U_CAT));
                                        gameScreen.team.enemyTeam.spawn(this.alphaCat,gameScreen.game);
                                        gameScreen.team.enemyTeam.population += 5;
                                        this.alphaCat.isAlpha = true;
                                        this.alphaAlive = true;
                                        this.timeSinceAlpha = 0;
                                        trace("Spawning Alpha");
                                        ++this.alphaCount;
                                        this.crawlerRegroupTimer = 0;
                                   }
                              }
                              if(this.alphaCount != 0)
                              {
                                   this.alphaAlive = true;
                              }
                              else
                              {
                                   this.alphaAlive = false;
                              }
                              if(!gameScreen.isPaused)
                              {
                                   if(this.alphaAlive)
                                   {
                                        ++this.counter;
                                   }
                                   else
                                   {
                                        ++this.timeSinceAlpha;
                                   }
                              }
                              if(this.counter > 220 + 269 / int(this.difficulty) + this.randomNumber && this.alphaAlive && this.alphaCount > 0)
                              {
                                   this.randomNumber = Math.floor(Math.random() * 7) + 1;
                                   if(this.randomNumber % 2 == 0)
                                   {
                                        this.randomNumber *= -1;
                                   }
                                   this.cat = Cat(gameScreen.game.unitFactory.getUnit(Unit.U_CAT));
                                   this.cat.isAlphaSpawn = true;
                                   gameScreen.team.enemyTeam.spawn(this.cat,gameScreen.game);
                                   ++gameScreen.team.enemyTeam.population;
                                   this.counter = 0;
                                   trace("Spawning alphaSpawn with alphaCount " + this.alphaCount + " and random number " + this.randomNumber);
                                   ++this.amountOfSpawn;
                                   if(this.amountOfSpawn > 2 && !this.firstAlphaSpawned)
                                   {
                                        this.firstAlphaSpawned = true;
                                        this.message5 = new InGameMessage("",gameScreen.game);
                                        this.message5.x = gameScreen.game.stage.stageWidth / 2;
                                        this.message5.y = gameScreen.game.stage.stageHeight / 4 - 75;
                                        this.message5.scaleX *= 1.3;
                                        this.message5.scaleY *= 1.3;
                                        gameScreen.addChild(this.message5);
                                        this.message5.setMessage("The Alpha\'s \'spawn\' will continue to join the battle as long as he remains...","");
                                        this.firstAlphaSpawned = true;
                                        this.frames = 0;
                                   }
                              }
                         }
                    }
                    else if(this.currentLevelTitle == "Monstrous Mire: Giants Attack")
                    {
                         gameScreen.game.team.enemyTeam.attack(true);
                         enemyStatue = gameScreen.team.enemyTeam.statue;
                         if(!this.nah)
                         {
                              gameScreen.team.enemyTeam.gold = 1800;
                              gameScreen.team.enemyTeam.mana = 150;
                              this.nah = true;
                         }
                         if(enemyStatue.health <= 1000 && enemyStatue.maxHealth != 12000 && !this.isGiantBossDead)
                         {
                              enemyStatue.health += 9500;
                              enemyStatue.maxHealth = 12000;
                              enemyStatue.healthBar.totalHealth = enemyStatue.maxHealth;
                              this.bossGiant = Giant(gameScreen.game.unitFactory.getUnit(Unit.U_GIANT));
                              gameScreen.team.enemyTeam.spawn(this.bossGiant,gameScreen.game);
                              this.bossGiant.isBoss = true;
                              this.bossGiant.ai.statueTargeter = true;
                              gameScreen.team.enemyTeam.population += 20;
                              this.giantTimer = 30 * 1;
                              this.bomberTimer = 30 * 15;
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("???: Puny thing...","");
                              this.bossSpawned = true;
                              this.frames = 0;
                         }
                         if(this.bossSpawned && !this.bigBoomWarning && !gameScreen.contains(this.message3) && gameScreen.team.forwardUnit && gameScreen.team.forwardUnit.px > this.bossGiant.px + 20)
                         {
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("Medusa: It\'s going straight for the Statue and it\'s bigger than one too... bring out the heavy artillery and stop that thing!","");
                              this.frames = 0;
                              this.bigBoomWarning = true;
                         }
                         if(this.bossSpawned && (!bomber || bomber && bomber.isDead || !gameScreen.team.unitGroups[Unit.U_BOMBER][0]))
                         {
                              bomber = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                              bomber.bomberType = "statueTargeterNoAi";
                              gameScreen.team.spawn(bomber,gameScreen.game);
                              ++gameScreen.team.population;
                              _loc9_ = new UnitMove();
                              _loc9_.moveType = UnitCommand.ATTACK_MOVE;
                              _loc9_.units.push(bomber.id);
                              _loc9_.owner = gameScreen.team.id;
                              _loc9_.arg0 = gameScreen.team.enemyTeam.statue.px;
                              _loc9_.arg1 = gameScreen.team.enemyTeam.statue.py;
                              _loc9_.execute(gameScreen.game);
                         }
                         if(this.giantTimer != -5 && this.bossGiant)
                         {
                              if(this.giantTimer > 0)
                              {
                                   if(!gameScreen.isPaused)
                                   {
                                        if(gameScreen.isFastForward)
                                        {
                                             --this.giantTimer;
                                        }
                                        --this.giantTimer;
                                   }
                              }
                              else if(this.giantTimer <= 0)
                              {
                                   i = 0;
                                   while(i < this.difficulty - 1)
                                   {
                                        this.giant = Giant(gameScreen.game.unitFactory.getUnit(Unit.U_GIANT));
                                        gameScreen.team.enemyTeam.spawn(this.giant,gameScreen.game);
                                        this.giant.noGrowl = true;
                                        gameScreen.team.enemyTeam.population += 7;
                                        i++;
                                   }
                                   this.giantTimer = -5;
                              }
                         }
                         if(this.bossGiant && !this.bossGiant.isDead)
                         {
                              this.bossGiant.ai.currentTarget = gameScreen.team.statue;
                              if(!this.bossGiant.mayAttack(gameScreen.team.statue))
                              {
                                   _loc9_ = new UnitMove();
                                   _loc9_.moveType = UnitCommand.ATTACK_MOVE;
                                   _loc9_.units.push(this.bossGiant.id);
                                   _loc9_.owner = gameScreen.team.enemyTeam.id;
                                   _loc9_.arg0 = gameScreen.team.statue.px;
                                   _loc9_.arg1 = gameScreen.team.statue.py;
                                   _loc9_.execute(gameScreen.game);
                                   this.bossGiant.ai.mayAttack = false;
                                   this.bossGiant.ai.mayMoveToAttack = false;
                              }
                              else
                              {
                                   this.bossGiant.ai.mayAttack = true;
                                   this.bossGiant.ai.mayMoveToAttack = true;
                              }
                         }
                         else
                         {
                              this.bossGiant = null;
                              if(this.bossSpawned && !this.bossGiant && !this.isGiantBossDead)
                              {
                                   this.isGiantBossDead = true;
                                   enemyStatue.health *= 0.11;
                                   enemyStatue.maxHealth = enemyStatue.health * 1.3333;
                                   enemyStatue.healthBar.totalHealth = enemyStatue.maxHealth;
                                   this.message4 = new InGameMessage("",gameScreen.game);
                                   this.message4.x = gameScreen.game.stage.stageWidth / 2;
                                   this.message4.y = gameScreen.game.stage.stageHeight / 4 - 75;
                                   this.message4.scaleX *= 1.3;
                                   this.message4.scaleY *= 1.3;
                                   gameScreen.addChild(this.message4);
                                   this.message4.setMessage("Queen Medusa: The Enemy Statue has been weakened and the cowardly Bombers have fled! Now\'s our chance!","");
                                   this.frames = 0;
                                   for each(u in gameScreen.team.enemyTeam.units)
                                   {
                                        if(u.type == Unit.U_BOMBER)
                                        {
                                             u.detonated = true;
                                             u.detonate();
                                        }
                                   }
                              }
                         }
                         if(this.bomberTimer > 0 && this.bossGiant)
                         {
                              if(!gameScreen.isPaused)
                              {
                                   if(gameScreen.isFastForward)
                                   {
                                        --this.bomberTimer;
                                   }
                                   --this.bomberTimer;
                              }
                         }
                         else if(this.bomberTimer <= 0 && this.bossGiant)
                         {
                              i = 0;
                              while(i < this.bomberAmounts)
                              {
                                   this.bomber = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                                   gameScreen.team.enemyTeam.spawn(this.bomber,gameScreen.game);
                                   this.randomNumber = Math.floor(Math.random() * this.bomberTypesForDifficulty[this.difficulty].length);
                                   this.bomber.bomberType = this.bomberTypesForDifficulty[this.difficulty][this.randomNumber];
                                   ++gameScreen.team.enemyTeam.population;
                                   i++;
                              }
                              ++this.bomberFrequency;
                              if(this.bomberFrequency >= this.bomberFrequencyIncreaseAt)
                              {
                                   ++this.bomberAmounts;
                                   this.bomberFrequencyIncreaseAt *= 1.3;
                                   this.bomberFrequency = 0;
                              }
                              this.bomberTimer = 30 * 10 + 30 * (this.bomberFrequencyIncreaseAt * this.bomberAmounts) - Math.pow(this.bomberFrequencyIncreaseAt,1 / 2) / this.bomberAmounts;
                         }
                    }
                    else if(this.currentLevelTitle == "Reach For The Sky: Eclipsors Attack")
                    {
                         CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.8);
                    }
                    else if(this.currentLevelTitle == "Undead Ambush: Endless Deads Attack")
                    {
                         for each(dead in gameScreen.team.enemyTeam.unitGroups[Unit.U_DEAD])
                         {
                              if(dead.mayWalkThrough)
                              {
                                   dead.mayWalkThrough = false;
                              }
                         }
                         if(this.hasted && gameScreen.game.frame < this.timeUntilRescue + 300)
                         {
                              _loc9_ = new UnitMove();
                              _loc9_.moveType = UnitCommand.ATTACK_MOVE;
                              for each(wingidon in gameScreen.team.unitGroups[Unit.U_WINGIDON])
                              {
                                   if(wingidon.isFeetMoving())
                                   {
                                        _loc9_.units.push(wingidon.id);
                                        _loc9_.owner = gameScreen.team.id;
                                   }
                              }
                              _loc9_.arg0 = this.queenMedusa.px;
                              _loc9_.arg1 = this.queenMedusa.py;
                              _loc9_.execute(gameScreen.game);
                         }
                         CampaignGameScreen(gameScreen).enemyTeamAi.alwaysAttack = true;
                         if(gameScreen.game.frame % 690 / this.difficulty == 0)
                         {
                              ++this.maxDeads;
                         }
                         else if(gameScreen.isFastForward && gameScreen.game.frame % 690 / this.difficulty == 1)
                         {
                              ++this.maxDeads;
                         }
                         if(gameScreen.game.frame % 350 == 0 || gameScreen.game.frame % 351 == 0 && gameScreen.isFastForward)
                         {
                              dead = null;
                              deadsToSpawn = 0;
                              deadsToSpawn = int(gameScreen.game.frame / 3000) + 1 - this.hasted;
                              i = 0;
                              while(i < deadsToSpawn && gameScreen.team.enemyTeam.unitGroups[Unit.U_DEAD].length < this.maxDeads)
                              {
                                   this.randomNumber = Math.random() * 100;
                                   if(this.randomNumber < 30)
                                   {
                                        dead = Dead(gameScreen.game.unitFactory.getUnit(Unit.U_DEAD));
                                        gameScreen.team.enemyTeam.spawn(dead,gameScreen.game);
                                        dead.deadType = "Toxic";
                                   }
                                   else if(this.randomNumber < 80)
                                   {
                                        dead = Dead(gameScreen.game.unitFactory.getUnit(Unit.U_DEAD));
                                        gameScreen.team.enemyTeam.spawn(dead,gameScreen.game);
                                        dead.deadType = "Bomber";
                                   }
                                   else
                                   {
                                        dead = Dead(gameScreen.game.unitFactory.getUnit(Unit.U_DEAD));
                                        gameScreen.team.enemyTeam.spawn(dead,gameScreen.game);
                                   }
                                   gameScreen.team.enemyTeam.population += 3;
                                   i++;
                              }
                         }
                         else if(gameScreen.game.frame > this.timeUntilRescue && !this.hasted)
                         {
                              i = 0;
                              while(i < 9 + this.difficulty)
                              {
                                   gameScreen.team.spawn(Wingidon(gameScreen.game.unitFactory.getUnit(Unit.U_WINGIDON)),gameScreen.game);
                                   i++;
                              }
                              for each(wingidon in gameScreen.team.unitGroups[Unit.U_WINGIDON])
                              {
                                   if(wingidon.px < gameScreen.team.statue.px - 100)
                                   {
                                        if(wingidon.speedSpellCooldown() == 0)
                                        {
                                             wingidon.px -= 1000;
                                             gameScreen.team.gold += 100 - 25 * this.difficulty;
                                             gameScreen.team.mana += 25;
                                             gameScreen.team.population += 2;
                                             wingidon.speedSpell();
                                        }
                                   }
                              }
                              this.hasted = true;
                         }
                         else if(!gameScreen.contains(this.messageOpening) && this.warnAboutReinforcementEclipsors == false)
                         {
                              this.message2 = new InGameMessage("",gameScreen.game);
                              this.message2.x = gameScreen.game.stage.stageWidth / 2;
                              this.message2.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message2.scaleX *= 1.3;
                              this.message2.scaleY *= 1.3;
                              gameScreen.addChild(this.message2);
                              this.message2.setMessage("The recently conquered Eclipsors are en route to aid Queen Medusa in her conquest! Hold the line until then!","");
                              this.frames = 0;
                              this.warnAboutReinforcementEclipsors = true;
                         }
                         else if(this.hasted && !this.rescued)
                         {
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("Wingidons: Rendezvous to the Queen!","");
                              this.frames = 0;
                              this.rescued = true;
                         }
                    }
                    else if(this.currentLevelTitle == "Marrowkai\'s Power Grab: Reclaiming the Throne")
                    {
                         if(!this.lol)
                         {
                              gameScreen.team.enemyTeam.spawnUnitGroup([Unit.U_SKELATOR,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                              this.lol = true;
                         }
                         for each(u in gameScreen.team.enemyTeam.units)
                         {
                              if(Math.abs(u.px - gameScreen.team.statue.px) < 25)
                              {
                                   u.ai.currentTarget = gameScreen.team.statue;
                              }
                              if(u.type == Unit.U_DEAD && u.isNormal)
                              {
                                   u.isNormal = false;
                                   this.randomNumber = Math.random() * 100;
                                   if(this.randomNumber < 30)
                                   {
                                        u.deadType = "Toxic";
                                   }
                                   else if(this.randomNumber < 80)
                                   {
                                        u.deadType = "Bomber";
                                   }
                              }
                              if(u.type == Unit.U_CAT && u.isNormal)
                              {
                                   u.isNormal = false;
                                   this.randomNumber = Math.random() * 100;
                                   if(this.randomNumber > 69)
                                   {
                                        u.isAlphaSpawn = true;
                                   }
                              }
                              if(u.type == Unit.U_BOMBER && u.isNormal)
                              {
                                   u.isNormal = false;
                                   this.randomNumber = Math.random() * 100;
                                   if(gameScreen.game.frame > 3000)
                                   {
                                        this.randomNumber += Math.random() * 50;
                                   }
                                   if(this.randomNumber < 50)
                                   {
                                        u.bomberType = "medusaTargeter";
                                   }
                                   else if(this.randomNumber < 100)
                                   {
                                        u.bomberType = "clusterBoi";
                                   }
                                   else if(this.randomNumber < 150)
                                   {
                                        u.bomberType = "statueTargeter";
                                   }
                              }
                              if(u.type == Unit.U_BOMBER && u.bomberType == "statueTargeter")
                              {
                                   _loc9_ = new UnitMove();
                                   _loc9_.moveType = UnitCommand.MOVE;
                                   _loc9_.units.push(u.id);
                                   _loc9_.owner = gameScreen.team.enemyTeam.id;
                                   _loc9_.arg0 = gameScreen.team.statue.px;
                                   _loc9_.arg1 = gameScreen.team.statue.py;
                                   _loc9_.execute(gameScreen.game);
                              }
                         }
                         if(this.messageOpening && !gameScreen.contains(this.messageOpening) && this.messageCounter == 0)
                         {
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("Marrowkai: I mastered the power of necromancy... you have nothing...","");
                              this.frames = 30;
                              this.messageCounter = 1;
                         }
                         if(this.message3 && !gameScreen.contains(this.message3) && this.messageCounter == 1)
                         {
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("Medusa: Traitor... I\'ll show you who\'s in charge...","");
                              this.frames = 30;
                              this.messageCounter = 2;
                         }
                         if(this.message3 && !gameScreen.contains(this.message3) && this.messageCounter == 2)
                         {
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("Marrowkai: We\'ll see about that.","");
                              this.frames = 30;
                              this.messageCounter = 3;
                              this.cutsceneDone = true;
                              this.queenMedusa.reverseReap = true;
                              this.enemyDefendIn = gameScreen.game.frame + 500;
                         }
                         if(this.message3 && !gameScreen.contains(this.message3) && this.messageCounter == 3 && gameScreen.game.targetScreenX <= gameScreen.team.statue.px - 42)
                         {
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("Medusa: Where are they going? These slaves appear to have found a new master...","");
                              this.frames = 0;
                              this.messageCounter = 4;
                         }
                         if(!this.bossMarrow)
                         {
                              this.bossMarrow = gameScreen.team.enemyTeam.unitGroups[Unit.U_SKELATOR][0];
                         }
                         else if(!this.cutsceneDone)
                         {
                              this.bossMarrow.px = gameScreen.game.map.width / 2 + 150;
                              this.bossMarrow.py = gameScreen.game.map.height / 2 - 25;
                              this.bossMarrow.ai.mayMove = false;
                              this.bossMarrow.ai.mayAttack = false;
                              this.bossMarrow.ai.mayMoveToAttack = false;
                              this.bossMarrow.marrowkaiGeneralDontCast = true;
                              this.bossMarrow.faceDirection(-1);
                              this.bossMarrow.isBossMarrow = true;
                              this.bossMarrow.canCastReap = false;
                              this.bossMarrow.canCastFists = false;
                         }
                         if(!this.cutsceneDone)
                         {
                              if(gameScreen.team.statue && gameScreen.team.statue.health > 0 && gameScreen.team.enemyTeam.statue && gameScreen.team.enemyTeam.statue.health > 0)
                              {
                                   gameScreen.game.targetScreenX = gameScreen.game.map.width / 2 - 425;
                              }
                              this.queenMedusa.px = gameScreen.game.map.width / 2 - 150;
                              this.queenMedusa.py = gameScreen.game.map.height / 2 - 25;
                              this.queenMedusa.ai.mayMove = false;
                              this.queenMedusa.ai.mayAttack = false;
                              this.queenMedusa.ai.mayMoveToAttack = false;
                              this.queenMedusa.faceDirection(1);
                              gameScreen.userInterface.selectedUnits.clear();
                              gameScreen.userInterface.isGlobalsEnabled = false;
                              gameScreen.userInterface.hud.hud.fastForward.visible = false;
                              delete gameScreen.team.unitsAvailable[Unit.U_KNIGHT];
                              delete gameScreen.team.unitsAvailable[Unit.U_CHAOS_MINER];
                              delete gameScreen.team.unitsAvailable[Unit.U_BOMBER];
                              delete gameScreen.team.unitsAvailable[Unit.U_WINGIDON];
                              delete gameScreen.team.unitsAvailable[Unit.U_GIANT];
                              delete gameScreen.team.unitsAvailable[Unit.U_DEAD];
                              delete gameScreen.team.unitsAvailable[Unit.U_CAT];
                         }
                         if(this.bossMarrow.isDead && this.destroyStatueDelay == 0)
                         {
                              this.destroyStatueDelay = gameScreen.game.frame + 80;
                              this.message3 = new InGameMessage("",gameScreen.game);
                              this.message3.x = gameScreen.game.stage.stageWidth / 2;
                              this.message3.y = gameScreen.game.stage.stageHeight / 4 - 75;
                              this.message3.scaleX *= 1.3;
                              this.message3.scaleY *= 1.3;
                              gameScreen.addChild(this.message3);
                              this.message3.setMessage("Marrowkai: Nooooooo-","");
                              this.frames = 0;
                         }
                         if(this.destroyStatueDelay != 0 && this.destroyStatueDelay < gameScreen.game.frame)
                         {
                              gameScreen.game.teamB.statue.health = Number(Number(0));
                         }
                         if(this.bossMarrow.isDead)
                         {
                              this.queenMedusa.health = this.queenMedusa.maxHealth;
                         }
                         if(this.bossMarrow)
                         {
                              if(Math.abs(this.bossMarrow.px - gameScreen.team.statue.px) < 690)
                              {
                                   this.bossMarrow.ai.currentTarget = gameScreen.team.statue;
                              }
                         }
                         if(this.cutsceneDone && !this.spawnMyBois)
                         {
                              this.bossMarrow.canCastReap = true;
                              this.spawnMyBois = true;
                              gameScreen.userInterface.isGlobalsEnabled = true;
                              gameScreen.userInterface.hud.hud.fastForward.visible = true;
                              gameScreen.team.unitsAvailable[Unit.U_KNIGHT] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_CHAOS_MINER] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_MEDUSA] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_BOMBER] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_WINGIDON] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_GIANT] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_DEAD] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_CAT] = 1;
                              gameScreen.team.spawn(Dead(gameScreen.game.unitFactory.getUnit(Unit.U_DEAD)),gameScreen.game);
                              gameScreen.team.population += 3;
                         }
                         for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_KNIGHT])
                         {
                              u.charger = true;
                         }
                         if(this.bossMarrow.health < this.bossMarrow.maxHealth / 1.5 && !this.spawnedBackupJug)
                         {
                              gameScreen.team.enemyTeam.spawn(Knight(gameScreen.game.unitFactory.getUnit(Unit.U_KNIGHT)),gameScreen.game);
                              gameScreen.team.enemyTeam.population += 3;
                              this.spawnedBackupJug = true;
                         }
                         if(gameScreen.team.statue.reaperCurseFrames > 0)
                         {
                              if(gameScreen.team.statue && gameScreen.team.statue.health > 0 && !gameScreen.isPaused)
                              {
                                   if(gameScreen.team.mana < 1000)
                                   {
                                        ++gameScreen.team.mana;
                                   }
                                   else
                                   {
                                        gameScreen.team.mana = 1000;
                                   }
                                   gameScreen.team.statue.px += 0.25;
                                   gameScreen.team.statue.x += 0.25;
                                   if(gameScreen.isFastForward)
                                   {
                                        gameScreen.team.statue.px += 0.25;
                                        gameScreen.team.statue.x += 0.25;
                                   }
                                   if(!this.statueMinersSpawned)
                                   {
                                        gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                                        gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                                        gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                                        gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                                        gameScreen.team.population += 8;
                                        this.statueMinersSpawned = true;
                                        gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                                        gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                                        gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                                        gameScreen.team.spawn(Miner(gameScreen.game.unitFactory.getUnit(Unit.U_CHAOS_MINER)),gameScreen.game);
                                        this.minerStatueOffset = 0;
                                   }
                                   if(gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0])
                                   {
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].px = gameScreen.team.statue.px + 35 + this.minerStatueOffset;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].py = gameScreen.team.statue.py - 6;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].faceDirection(1);
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].isGodmoded = true;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].health = gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].maxHealth;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].stunTimeLeft = 0;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].canBeTargeted = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].ai.mayAttack = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].ai.mayMoveToAttack = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].ai.currentTarget = null;
                                        _loc9_ = new UnitMove();
                                        _loc9_.moveType = UnitCommand.MOVE;
                                        _loc9_.units.push(gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][0].id);
                                        _loc9_.owner = gameScreen.team.id;
                                        _loc9_.arg0 = gameScreen.team.statue.px + 500;
                                        _loc9_.arg1 = gameScreen.team.statue.py;
                                        _loc9_.execute(gameScreen.game);
                                   }
                                   if(gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1])
                                   {
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].px = gameScreen.team.statue.px - 25 + this.minerStatueOffset;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].py = gameScreen.team.statue.py - 16;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].faceDirection(1);
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].isGodmoded = true;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].health = gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].maxHealth;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].stunTimeLeft = 0;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].canBeTargeted = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].ai.mayAttack = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].ai.mayMoveToAttack = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].ai.mayMove = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].ai.currentTarget = null;
                                        _loc9_ = new UnitMove();
                                        _loc9_.moveType = UnitCommand.MOVE;
                                        _loc9_.units.push(gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][1].id);
                                        _loc9_.owner = gameScreen.team.id;
                                        _loc9_.arg0 = gameScreen.team.statue.px + 500;
                                        _loc9_.arg1 = gameScreen.team.statue.py;
                                        _loc9_.execute(gameScreen.game);
                                   }
                                   if(gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2])
                                   {
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].px = gameScreen.team.statue.px + 50 + this.minerStatueOffset;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].py = gameScreen.team.statue.py + 25;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].faceDirection(1);
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].isGodmoded = true;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].health = gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].maxHealth;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].stunTimeLeft = 0;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].canBeTargeted = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].ai.mayAttack = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].ai.mayMoveToAttack = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].ai.mayMove = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].ai.currentTarget = null;
                                        _loc9_ = new UnitMove();
                                        _loc9_.moveType = UnitCommand.MOVE;
                                        _loc9_.units.push(gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][2].id);
                                        _loc9_.owner = gameScreen.team.id;
                                        _loc9_.arg0 = gameScreen.team.statue.px + 500;
                                        _loc9_.arg1 = gameScreen.team.statue.py;
                                        _loc9_.execute(gameScreen.game);
                                   }
                                   if(gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3])
                                   {
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].px = gameScreen.team.statue.px - 15 + this.minerStatueOffset;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].py = gameScreen.team.statue.py + 30;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].faceDirection(1);
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].isGodmoded = true;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].health = gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].maxHealth;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].stunTimeLeft = 0;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].canBeTargeted = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].ai.mayAttack = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].ai.mayMoveToAttack = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].ai.mayMove = false;
                                        gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].ai.currentTarget = null;
                                        _loc9_ = new UnitMove();
                                        _loc9_.moveType = UnitCommand.MOVE;
                                        _loc9_.units.push(gameScreen.team.unitGroups[Unit.U_CHAOS_MINER][3].id);
                                        _loc9_.owner = gameScreen.team.id;
                                        _loc9_.arg0 = gameScreen.team.statue.px + 500;
                                        _loc9_.arg1 = gameScreen.team.statue.py;
                                        _loc9_.execute(gameScreen.game);
                                   }
                              }
                         }
                         if(gameScreen.game.frame < 1000)
                         {
                              CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.75);
                         }
                         else if(gameScreen.game.frame < 1800)
                         {
                              CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(2);
                         }
                         else if(this.spawnedBackupJug)
                         {
                              CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.8);
                         }
                         else
                         {
                              CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.7);
                         }
                    }
                    else
                    {
                         gameScreen.team.enemyTeam.statue.health = 0;
                    }
               }
          }
     }
}
