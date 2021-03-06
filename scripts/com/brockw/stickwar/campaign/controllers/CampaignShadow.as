package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.campaign.InGameMessage;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
   import com.brockw.stickwar.engine.units.Bomber;
   import com.brockw.stickwar.engine.units.Cat;
   import com.brockw.stickwar.engine.units.Giant;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Statue;
   import com.brockw.stickwar.engine.units.Unit;
   
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
      
      var bomberTypes:Array;
      
      var bomberTypesForDifficulty:Array;
      
      var bomberFrequency:int;
      
      var bomberFrequencyIncreaseAt:Number = 3.0;
      
      var bomberTimer:int = -5;
      
      var bomberAmounts:int = 1;
      
      var giantTimer:int = 0;
      
      var tutorialTimer:int = 0;
      
      public function CampaignShadow(gameScreen:GameScreen)
      {
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberFrequencyIncreaseAt = 3;
         this.bomberTypes = ["Default","minerTargeter","medusaTargeter","statueTargeter","clusterBoi"];
         this.catDelay = 30 * 5;
         super(gameScreen);
         this.message = null;
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
         if(this.message && gameScreen.contains(this.message))
         {
            this.message.update();
            if(this.frames++ > 30 * 7)
            {
               gameScreen.removeChild(this.message);
            }
         }
         else if(this.message2 && gameScreen.contains(this.message2))
         {
            this.message2.update();
            if(this.frames++ > 30 * 8)
            {
               gameScreen.removeChild(this.message2);
            }
         }
         else if(this.message3 && gameScreen.contains(this.message3))
         {
            this.message3.update();
            if(this.frames++ > 30 * 8)
            {
               gameScreen.removeChild(this.message3);
            }
         }
         else if(this.message4 && gameScreen.contains(this.message4))
         {
            this.message4.update();
            if(this.frames++ > 30 * 8)
            {
               gameScreen.removeChild(this.message4);
            }
         }
         else if(this.message5 && gameScreen.contains(this.message5))
         {
            this.message5.update();
            if(this.frames++ > 30 * 7)
            {
               gameScreen.removeChild(this.message5);
            }
         }
         else if(this.message6 && gameScreen.contains(this.message6))
         {
            this.message6.update();
            if(this.frames++ > 30 * 7)
            {
               gameScreen.removeChild(this.message6);
            }
         }
         else if(this.messageOpening && gameScreen.contains(this.messageOpening))
         {
            this.messageOpening.update();
            if(this.frames++ > 30 * 8)
            {
               gameScreen.removeChild(this.messageOpening);
            }
         }
         else if(!this.message)
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
               }
               else if(this.currentLevelTitle == "Apex Of The Forest: Crawlers Attack")
               {
                  this.messageOpening.setMessage("Queen Medusa: Stupid monkeys...","",0,this.medusaOneLiner);
               }
               else if(this.currentLevelTitle == "Monstrous Mire: Giants Attack")
               {
                  this.messageOpening.setMessage("Queen Medusa: So HE\'S the one organizing all of this...","",0,this.medusaOneLiner);
               }
               else if(this.currentLevelTitle == "Reach For The Sky: Eclipsors Attack")
               {
                  this.messageOpening.setMessage("Queen Medusa: Pesky flies...","",0,this.medusaOneLiner);
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
               this.frames = 0;
               this.openingMessageSent = true;
            }
            if(this.currentLevelTitle == "Medusa")
            {
               for each(u in gameScreen.team.units)
               {
                  if(u.isPoisoned() && !this.poisonCheck)
                  {
                     this.message = new InGameMessage("",gameScreen.game);
                     this.message.x = gameScreen.game.stage.stageWidth / 2;
                     this.message.y = gameScreen.game.stage.stageHeight / 4 - 75;
                     this.message.scaleX *= 1.3;
                     this.message.scaleY *= 1.3;
                     gameScreen.addChild(this.message);
                     this.message.setMessage("Cure your Units of poison by garrisoning them or letting them auto-cure after some time.","");
                     this.frames = 0;
                     this.poisonCheck = true;
                     break;
                  }
               }
               for each(u in gameScreen.team.enemyTeam.units)
               {
                  if(u.isTowerSpawned && !this.ghostCheck)
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
               if(gameScreen.team.enemyTeam.forwardUnit && gameScreen.team.enemyTeam.forwardUnit.x < gameScreen.game.map.width / 2 + 20 && !this.middleWarning)
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
               if(!this.queenMedusa.isMedusaMaxHp() && !this.medusaWarning && this.queenMedusa.health < this.queenMedusa.maxHealth / 2)
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
               if(this.queenMedusa.inStoneSpell && !this.stoneWarning)
               {
                  this.message5 = new InGameMessage("",gameScreen.game);
                  this.message5.x = gameScreen.game.stage.stageWidth / 2;
                  this.message5.y = gameScreen.game.stage.stageHeight / 4 - 75;
                  this.message5.scaleX *= 1.3;
                  this.message5.scaleY *= 1.3;
                  gameScreen.addChild(this.message5);
                  this.message5.setMessage("Queen Medusa\'s Stone ability is more expensive, has a longer cooldown, and is stronger against heavy units. Use it wisely!","");
                  this.frames = 0;
                  this.stoneWarning = true;
               }
               if(gameScreen.team.getNumberOfMiners() >= 12 && !this.minerWarning)
               {
                  this.message6 = new InGameMessage("",gameScreen.game);
                  this.message6.x = gameScreen.game.stage.stageWidth / 2;
                  this.message6.y = gameScreen.game.stage.stageHeight / 4 - 75;
                  this.message6.scaleX *= 1.3;
                  this.message6.scaleY *= 1.3;
                  gameScreen.addChild(this.message6);
                  this.message6.setMessage("Never hesitate to utilize ALL your Units when you need to beat a level!","");
                  this.frames = 0;
                  this.minerWarning = true;
               }
            }
            else if(this.currentLevelTitle == "Apex Of The Forest: Crawlers Attack")
            {
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
                     if(this.amountOfSpawn > 4 && !this.firstAlphaSpawned)
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
                  this.message5 = new InGameMessage("",gameScreen.game);
                  this.message5.x = gameScreen.game.stage.stageWidth / 2;
                  this.message5.y = gameScreen.game.stage.stageHeight / 4 - 75;
                  this.message5.scaleX *= 1.3;
                  this.message5.scaleY *= 1.3;
                  gameScreen.addChild(this.message5);
                  this.message5.setMessage("???: Puny thing...","");
                  this.bossSpawned = true;
                  this.frames = 0;
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
            else if(this.currentLevelTitle == "Deez")
            {
               this.comment = "";
            }
            else if(this.currentLevelTitle == "Reach For The Sky: Eclipsors Attack")
            {
               CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.8);
            }
            else
            {
               gameScreen.team.statue.health = 0;
            }
         }
      }
   }
}
