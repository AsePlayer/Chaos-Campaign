package com.brockw.stickwar.campaign.controllers
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.campaign.CampaignGameScreen;
     import com.brockw.stickwar.campaign.InGameMessage;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
     import com.brockw.stickwar.engine.units.EnslavedGiant;
     import com.brockw.stickwar.engine.units.FlyingCrossbowman;
     import com.brockw.stickwar.engine.units.Medusa;
     import com.brockw.stickwar.engine.units.Ninja;
     import com.brockw.stickwar.engine.units.Spearton;
     import com.brockw.stickwar.engine.units.Unit;
     import com.brockw.stickwar.engine.units.Wall;
     
     public class CampaignKnight extends CampaignController
     {
           
          
          private var message:InGameMessage;
          
          private var frames:int;
          
          private var currentLevelTitle:String;
          
          private var medusaOneLiner:String;
          
          private var medusaQueened:Boolean;
          
          private var difficulty:int;
          
          private var queenMedusa:Medusa;
          
          private var sneakyNinjas:int;
          
          private var explodingAlbows:int;
          
          private var levelSetupComplete:Boolean;
          
          private var openingMessageSent:Boolean;
          
          private var messageOpening:InGameMessage;
          
          private var gameOver:Boolean;
          
          private var timeUntilEnd:int;
          
          private var timeUntilNextAlbow:int;
          
          private var sneakyNinjaWarning:Boolean;
          
          private var poisonCheck:Boolean = false;
          
          private var tpSpawnOffset:int;
          
          private var tpWallOffset:int;
          
          private var tpBackWallOffset:int;
          
          private var wall:Wall;
          
          private var backWall:Wall;
          
          private var sceneCounter:int;
          
          internal var holdUnits:UnitMove = null;
          
          internal var albowUnit:FlyingCrossbowman;
          
          internal var ninjaUnit:Ninja;
          
          private var spookedBackgroundUnits:Boolean;
          
          private var unitGroup1:Array;
          
          private var unitGroup1RunningAway:Array;
          
          private var boundaries:Array;
          
          private var cameraBoundaries:Array;
          
          private var leaderUnit:Unit;
          
          private var spawnQueenMedusaLateGame:Boolean;
          
          private var marrowResponse:Boolean;
          
          private var lostGiant:EnslavedGiant;
          
          private var foundLostGiant:Boolean;
          
          private var lostGiantApology:Boolean;
          
          private var lostGiantSwitches:Boolean;
          
          private var commanderStatus:String;
          
          private var justSwitchedStatus:Boolean;
          
          private var lastRoyalMessage:String = "";
          
          private var currentRoyalMessage:String = "";
          
          private var playerBackgroundUnits:Array;
          
          private var enemyBackgroundUnits:Array;
          
          private var matchups:Array;
          
          private var rngMatchup:int = 0;
          
          private var generals:Array;
          
          public function CampaignKnight(gameScreen:GameScreen)
          {
               this.playerBackgroundUnits = [];
               this.enemyBackgroundUnits = [];
               this.matchups = [];
               this.generals = [Unit.U_SWORDWRATH,Unit.U_ARCHER,Unit.U_SPEARTON,Unit.U_FLYING_CROSSBOWMAN,Unit.U_MONK,Unit.U_ENSLAVED_GIANT];
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
               var u:Unit = null;
               var localCounter:int = int(null);
               if(!this.medusaQueened && this.currentLevelTitle != "Raiding Party: Attack at Fern Crest")
               {
                    this.queenMedusa = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
                    gameScreen.team.spawn(this.queenMedusa,gameScreen.game);
                    this.queenMedusa.px = 420 * 2;
                    this.queenMedusa.medusaTrueQueen = true;
                    gameScreen.team.population += 10;
                    this.medusaQueened = true;
                    this.difficulty = gameScreen.team.game.main.campaign.difficultyLevel;
                    if(this.currentLevelTitle == "Siege: Titans Revenge")
                    {
                         this.leaderUnit = Spearton(gameScreen.game.unitFactory.getUnit(Unit.U_SPEARTON));
                         gameScreen.team.enemyTeam.spawn(this.leaderUnit,gameScreen.game);
                         this.leaderUnit.speartonType = "Royal";
                    }
               }
               if(!this.openingMessageSent)
               {
                    this.messageOpening = new InGameMessage("",gameScreen.game);
                    this.messageOpening.x = gameScreen.game.stage.stageWidth / 2;
                    this.messageOpening.y = gameScreen.game.stage.stageHeight / 4 - 75;
                    this.messageOpening.scaleX *= 1.3;
                    this.messageOpening.scaleY *= 1.3;
                    gameScreen.addChild(this.messageOpening);
                    if(this.currentLevelTitle == "Scouting Party: Unexpected Guests")
                    {
                         this.messageOpening.setMessage("Queen Medusa: No tolerance for espionage... their fate is sealed.","",0,this.medusaOneLiner);
                    }
                    else if(this.currentLevelTitle == "Raiding Party: Attack at Fern Crest")
                    {
                         this.messageOpening.setMessage("Queen Medusa has decided to grace the locals with her presence... let\'s give them something to write home about!","");
                    }
                    else if(this.currentLevelTitle == "Marrowkai\'s Grudge: Stamp out the Magic")
                    {
                         this.messageOpening.setMessage("Queen Medusa: Honestly I don\'t get the big deal. These old geezers are going to croak soon anyways!","",0,this.medusaOneLiner);
                    }
                    else if(this.currentLevelTitle == "Jailbreak: Titans Revolt")
                    {
                         this.messageOpening.setMessage("Queen Medusa: My poor babies... they will pay for this!","",0,this.medusaOneLiner);
                    }
                    else if(this.currentLevelTitle == "Siege: Titans Revenge")
                    {
                         this.messageOpening.setMessage("Queen Medusa: Their precious castle will be no more...","",0,this.medusaOneLiner);
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
               if(this.messageOpening && gameScreen.contains(this.messageOpening) && !gameScreen.isPaused)
               {
                    this.messageOpening.update();
                    if(this.frames > 5)
                    {
                         this.messageOpening.visible = true;
                    }
                    if(this.frames == -1)
                    {
                         this.messageOpening.visible = false;
                    }
                    else if(this.frames++ > 30 * 8)
                    {
                         this.messageOpening.visible = false;
                         this.frames = -1;
                    }
               }
               if(this.currentLevelTitle == "Scouting Party: Unexpected Guests")
               {
                    if(!this.levelSetupComplete)
                    {
                         CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.1);
                         this.sneakyNinjas = 3 * this.difficulty - 1;
                         this.explodingAlbows = 2.5 * (this.difficulty + 1) - this.difficulty;
                         this.levelSetupComplete = true;
                         gameScreen.game.team.enemyTeam.statue.x += 10000;
                         gameScreen.game.team.enemyTeam.statue.px += 10000;
                         ++gameScreen.team.enemyTeam.population;
                         gameScreen.team.spawnUnitGroup([Unit.U_SKELATOR,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                    }
                    if(this.explodingAlbows > 0)
                    {
                         for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_FLYING_CROSSBOWMAN])
                         {
                              if(u.isExploder && u.isNormal)
                              {
                                   u.isNormal = false;
                                   gameScreen.team.enemyTeam.population += u.population;
                                   --this.explodingAlbows;
                              }
                              else if(u.isNormal)
                              {
                                   u.isNormal = false;
                              }
                         }
                    }
                    if(!this.gameOver && gameScreen.team.enemyTeam.population == 0)
                    {
                         this.timeUntilEnd = gameScreen.game.frame + 60;
                         this.gameOver = true;
                         gameScreen.game.team.enemyTeam.statue.px -= 10000;
                         this.messageOpening.setMessage("Queen Medusa: The Scouting have become the SCOUTED...","");
                         this.frames = 0;
                    }
                    if(!this.sneakyNinjaWarning && this.albowUnit && this.albowUnit.isExploder && this.albowUnit.isDead)
                    {
                         if(gameScreen.team.unitGroups[Unit.U_SKELATOR][0])
                         {
                              this.messageOpening.setMessage("Marrowkai: That explosion rattled my bones all the way from here! Surrounding scouts must have heard that...","");
                         }
                         else
                         {
                              this.messageOpening.setMessage("Queen Medusa: I felt the force of that detonation all the way from here! Surrounding scouts must have heard that...","");
                         }
                         this.frames = 0;
                         this.sneakyNinjaWarning = true;
                    }
                    if(this.queenMedusa.isPoisoned() && !this.poisonCheck && gameScreen.team.unitGroups[Unit.U_SKELATOR][0])
                    {
                         this.poisonCheck = true;
                         this.messageOpening.setMessage("Marrowkai: My reap ability can thwart any assassin\'s plan, just give me your command!","");
                         this.frames = 0;
                    }
                    if(this.gameOver && gameScreen.game.team.enemyTeam.statue && gameScreen.game.frame > this.timeUntilEnd)
                    {
                         gameScreen.game.team.enemyTeam.statue.health = 0;
                    }
                    if(this.albowUnit && this.albowUnit.isDead)
                    {
                         this.albowUnit = null;
                    }
                    if(gameScreen.game.frame > this.timeUntilNextAlbow)
                    {
                         if((!this.albowUnit || this.albowUnit.isDead) && this.explodingAlbows > 0)
                         {
                              if(this.explodingAlbows != 1)
                              {
                                   this.albowUnit = FlyingCrossbowman(gameScreen.game.unitFactory.getUnit(Unit.U_FLYING_CROSSBOWMAN));
                                   this.albowUnit.isExploder = true;
                                   gameScreen.team.enemyTeam.spawn(this.albowUnit,gameScreen.game);
                                   gameScreen.team.enemyTeam.gold += 300;
                                   gameScreen.team.enemyTeam.mana += 150;
                              }
                              else
                              {
                                   gameScreen.team.enemyTeam.spawn(Ninja(gameScreen.game.unitFactory.getUnit(Unit.U_NINJA)),gameScreen.game);
                                   gameScreen.team.enemyTeam.population += 4;
                              }
                              --this.explodingAlbows;
                         }
                         this.timeUntilNextAlbow = gameScreen.game.frame + Math.floor(Math.random() * 200) + 400;
                    }
                    if(this.explodingAlbows <= 0 && gameScreen.team.enemyTeam.units <= 0)
                    {
                         gameScreen.team.enemyTeam.population = 0;
                    }
                    if(this.albowUnit && !this.albowUnit.isDead)
                    {
                         this.timeUntilNextAlbow = gameScreen.game.frame + Math.floor(Math.random() * 200) + 400;
                    }
               }
               else if(this.currentLevelTitle == "Raiding Party: Attack at Fern Crest")
               {
                    if(!this.levelSetupComplete)
                    {
                         CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.1);
                         gameScreen.team.instaQueue = true;
                         this.boundaries = [gameScreen.team.homeX + 2000,gameScreen.team.homeX + 2500];
                         this.cameraBoundaries = [this.boundaries[0] - 500,this.boundaries[1] - 600];
                         gameScreen.team.enemyTeam.addWall(this.boundaries[0]).setConstructionAmount(1);
                         gameScreen.team.enemyTeam.addWall(this.boundaries[1]).setConstructionAmount(1);
                         this.unitGroup1 = [Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SPEARTON,Unit.U_ARCHER];
                         this.unitGroup1RunningAway = [Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SWORDWRATH];
                         this.levelSetupComplete = true;
                         delete gameScreen.team.unitsAvailable[Unit.U_KNIGHT];
                         delete gameScreen.team.unitsAvailable[Unit.U_CHAOS_MINER];
                         delete gameScreen.team.unitsAvailable[Unit.U_MEDUSA];
                         delete gameScreen.team.unitsAvailable[Unit.U_BOMBER];
                         delete gameScreen.team.unitsAvailable[Unit.U_WINGIDON];
                         delete gameScreen.team.unitsAvailable[Unit.U_GIANT];
                         delete gameScreen.team.unitsAvailable[Unit.U_DEAD];
                         delete gameScreen.team.unitsAvailable[Unit.U_CAT];
                         delete gameScreen.team.unitsAvailable[Unit.U_SKELATOR];
                         gameScreen.team.tech.isResearchedMap[Tech.DEAD_POISON] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.MEDUSA_POISON] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.CAT_PACK] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.CAT_SPEED] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.SKELETON_FIST_ATTACK] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.KNIGHT_CHARGE] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.CHAOS_GIANT_GROWTH_I] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.CHAOS_GIANT_GROWTH_II] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.TOWER_SPAWN_I] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.TOWER_SPAWN_II] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.BANK_PASSIVE_1] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.BANK_PASSIVE_2] = true;
                         gameScreen.team.tech.isResearchedMap[Tech.BANK_PASSIVE_3] = true;
                    }
                    for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_ARCHER])
                    {
                         if(!this.spookedBackgroundUnits)
                         {
                              u.shortenRange = true;
                         }
                         else
                         {
                              u.shortenRange = false;
                         }
                    }
                    for each(u in gameScreen.team.unitGroups[Unit.U_WINGIDON])
                    {
                         u.shortenRange = true;
                    }
                    for each(u in gameScreen.team.units)
                    {
                         if(u.px + u._scale * 25 < this.boundaries[0] - 600 && this.leaderUnit)
                         {
                              if(u.type == Unit.U_DEAD)
                              {
                                   u.shortenRange = true;
                                   if(u.isNormal)
                                   {
                                        u.isNormal = false;
                                        if(Math.random() * 100 < 30)
                                        {
                                             u.deadType = "Toxic";
                                        }
                                        else if(Math.random() * 100 < 30)
                                        {
                                             u.deadType = "Bomber";
                                        }
                                   }
                              }
                              u.px = this.cameraBoundaries[0] - 100;
                              this.holdUnits = new UnitMove();
                              this.holdUnits.owner = gameScreen.team.id;
                              this.holdUnits.moveType = UnitCommand.ATTACK_MOVE;
                              this.holdUnits.arg0 = u.px + 150;
                              this.holdUnits.arg1 = u.py;
                              this.holdUnits.units.push(u.id);
                              this.holdUnits.execute(gameScreen.game);
                         }
                    }
                    if(this.unitGroup1 && this.unitGroup1RunningAway)
                    {
                         gameScreen.team.enemyTeam.spawnUnitGroup(this.unitGroup1);
                         for each(u in gameScreen.team.enemyTeam.units)
                         {
                              u.px = (this.boundaries[0] + 100 + this.boundaries[1]) / 2 + Math.floor(Math.random() * (this.boundaries[1] - this.boundaries[0])) - Math.floor((this.boundaries[1] - this.boundaries[0]) / 2);
                              u.isNormal = false;
                         }
                         gameScreen.team.enemyTeam.spawnUnitGroup(this.unitGroup1RunningAway);
                         for each(u in gameScreen.team.enemyTeam.units)
                         {
                              if(u.isNormal)
                              {
                                   u.px = (this.boundaries[0] + this.boundaries[1]) / 2 + Math.floor(Math.random() * 300 - 150);
                                   u.py = gameScreen.game.map.height / 2 - 150 + Math.floor(Math.random() * 25) - 60;
                                   u.specialTimeOver = true;
                              }
                         }
                         if(this.sceneCounter == 0)
                         {
                              this.messageOpening.setMessage("Unleash an Undead Assault against the unsuspecting victims...","");
                              gameScreen.team.gold = 2100;
                              gameScreen.team.mana = 700;
                              gameScreen.team.unitsAvailable[Unit.U_DEAD] = 1;
                              gameScreen.team.spawnUnitGroup([Unit.U_DEAD]);
                              this.leaderUnit = gameScreen.team.unitGroups[Unit.U_DEAD][0];
                              this.leaderUnit.py = gameScreen.game.map.height / 2;
                              this.leaderUnit.isNormal = false;
                              for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_SWORDWRATH])
                              {
                                   u.swordType = "Club";
                              }
                         }
                         else if(this.sceneCounter == 1)
                         {
                              this.messageOpening.setMessage("Marrowkai: Let\'s give em\' hell...","");
                              this.frames = 0;
                              gameScreen.team.gold = 4000;
                              gameScreen.team.mana = 2000;
                              delete gameScreen.team.unitsAvailable[Unit.U_DEAD];
                              gameScreen.team.unitsAvailable[Unit.U_SKELATOR] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_KNIGHT] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_WINGIDON] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_BOMBER] = 1;
                              gameScreen.team.spawnUnitGroup([Unit.U_SKELATOR]);
                              delete gameScreen.team.unitsAvailable[Unit.U_SKELATOR];
                              this.leaderUnit = gameScreen.team.unitGroups[Unit.U_SKELATOR][0];
                              this.leaderUnit.py = gameScreen.game.map.height / 2;
                              this.leaderUnit.isNormal = false;
                              for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_SWORDWRATH])
                              {
                                   u.swordType = "Random";
                              }
                              for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_ARCHER])
                              {
                                   u.archerType = "Splash";
                              }
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL][0].magikillType = "Poison";
                         }
                         else if(this.sceneCounter == 2)
                         {
                              this.queenMedusa = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
                              gameScreen.team.spawn(this.queenMedusa,gameScreen.game);
                              this.queenMedusa.px = 420 * 2;
                              this.queenMedusa.medusaTrueQueen = true;
                              gameScreen.team.population += 10;
                              this.medusaQueened = true;
                              this.leaderUnit = this.queenMedusa;
                              this.messageOpening.setMessage("Queen Medusa: Now they will feel the WRATH of the Chaos Empire!","",0,"voiceTutorial5");
                              this.frames = 0;
                              for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_SWORDWRATH])
                              {
                                   u.swordType = "Random";
                              }
                              gameScreen.team.unitsAvailable[Unit.U_GIANT] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_CAT] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_MEDUSA] = 1;
                              gameScreen.team.unitsAvailable[Unit.U_WINGIDON] = 1;
                              delete gameScreen.team.unitsAvailable[Unit.U_KNIGHT];
                              delete gameScreen.team.unitsAvailable[Unit.U_SKELATOR];
                              delete gameScreen.team.unitsAvailable[Unit.U_BOMBER];
                              gameScreen.team.gold = 6000;
                              gameScreen.team.mana = 4000;
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL][0].magikillType = "Stun";
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL][1].magikillType = "Explosion";
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_SPEARTON][0].speartonType = "Royal";
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_SPEARTON][1].speartonType = "Royal";
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_SPEARTON][1].isBasher = true;
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_FLYING_CROSSBOWMAN][0].isExploder = true;
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_FLYING_CROSSBOWMAN][0].px = gameScreen.team.enemyTeam.statue.px;
                              gameScreen.team.enemyTeam.unitGroups[Unit.U_FLYING_CROSSBOWMAN][0].py = gameScreen.game.map.height / 3;
                              localCounter = 0;
                              for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_ARCHER])
                              {
                                   if(localCounter % 2 == 0)
                                   {
                                        u.archerType = "Splash";
                                   }
                                   localCounter++;
                              }
                         }
                         this.unitGroup1 = null;
                         this.unitGroup1RunningAway = null;
                    }
                    this.holdUnits = new UnitMove();
                    this.holdUnits.owner = gameScreen.team.enemyTeam.id;
                    this.holdUnits.moveType = UnitCommand.HOLD;
                    for each(u in gameScreen.team.enemyTeam.units)
                    {
                         if(gameScreen.team.forwardUnit && gameScreen.team.enemyTeam.forwardUnit && Math.abs(u.team.forwardUnit.px - gameScreen.team.forwardUnit.px) > 300 + this.spookedBackgroundUnits * 100)
                         {
                              this.holdUnits.arg0 = u.px;
                              this.holdUnits.arg1 = u.py;
                              this.holdUnits.units.push(u.id);
                         }
                         if(u.health != u.maxHealth && !u.isDead || gameScreen.team.forwardUnit && gameScreen.team.enemyTeam.forwardUnit && Math.abs(u.team.forwardUnit.px - gameScreen.team.forwardUnit.px) < 300)
                         {
                              this.spookedBackgroundUnits = true;
                         }
                         if(this.spookedBackgroundUnits && u.specialTimeOver)
                         {
                              this.holdUnits = new UnitMove();
                              this.holdUnits.owner = gameScreen.team.enemyTeam.id;
                              this.holdUnits.moveType = UnitCommand.MOVE;
                              this.holdUnits.arg0 = gameScreen.team.enemyTeam.homeX;
                              this.holdUnits.arg1 = u.py;
                              if(u.type == Unit.U_SPEARTON && u.py < gameScreen.game.map.height / 3)
                              {
                                   this.holdUnits.arg0 = u.px + u.getDirection() * 10;
                                   u.py += Math.max(1,5 - 4 * Math.abs(u.py - gameScreen.game.map.height / 2) / 20);
                                   u.forceFaceDirection(-1);
                              }
                              else if(u.px > this.boundaries[1] && u.py < gameScreen.game.map.height / 3)
                              {
                                   u.py += Math.max(1,5 - 4 * Math.abs(u.py - gameScreen.game.map.height / 2) / 20);
                              }
                              else if(u.py >= gameScreen.game.map.height / 3)
                              {
                                   u.specialTimeOver = false;
                              }
                              this.holdUnits.units.push(u.id);
                              this.holdUnits.execute(gameScreen.game);
                         }
                         else if(this.spookedBackgroundUnits && !u.specialTimeOver)
                         {
                              if((u.type != Unit.U_SPEARTON || u.type == Unit.U_SPEARTON && u.wantsToShield == false) && u.type != Unit.U_MAGIKILL)
                              {
                                   this.holdUnits = new UnitMove();
                                   this.holdUnits.owner = gameScreen.team.enemyTeam.id;
                                   this.holdUnits.moveType = UnitCommand.ATTACK_MOVE;
                                   this.holdUnits.arg0 = (this.boundaries[0] + this.boundaries[1]) / 2;
                                   this.holdUnits.arg1 = u.py;
                                   this.holdUnits.units.push(u.id);
                                   this.holdUnits.execute(gameScreen.game);
                              }
                         }
                         if((u.type == Unit.U_ARCHER || u.type == Unit.U_MAGIKILL) && u.px > this.boundaries[1] + 50)
                         {
                              this.holdUnits = new UnitMove();
                              this.holdUnits.owner = gameScreen.team.enemyTeam.id;
                              this.holdUnits.moveType = UnitCommand.HOLD;
                              this.holdUnits.arg0 = u.px;
                              this.holdUnits.arg1 = u.py;
                              this.holdUnits.units.push(u.id);
                              this.holdUnits.execute(gameScreen.game);
                         }
                    }
                    this.holdUnits.execute(gameScreen.game);
                    if(gameScreen.team.population == 0 && gameScreen.team.enemyTeam.population != 0 && (gameScreen.team.gold < 500 || gameScreen.team.mana < 200))
                    {
                         gameScreen.team.statue.health = 0;
                    }
                    if(gameScreen.team.statue.health > 0 && gameScreen.team.enemyTeam.statue.health > 0)
                    {
                         if(gameScreen.game.targetScreenX < this.cameraBoundaries[0])
                         {
                              gameScreen.game.targetScreenX = this.cameraBoundaries[0];
                         }
                         if(gameScreen.game.targetScreenX > this.cameraBoundaries[1])
                         {
                              gameScreen.game.targetScreenX = this.cameraBoundaries[1];
                         }
                    }
                    if(gameScreen.team.enemyTeam.population == 0)
                    {
                         this.leaderUnit = null;
                         this.spookedBackgroundUnits = false;
                         gameScreen.team.enemyTeam.removeWallAll();
                         for each(u in gameScreen.team.units)
                         {
                              u.px = 10000;
                              u.damage(2,u.maxHealth,null);
                         }
                         ++this.sceneCounter;
                    }
                    if(this.sceneCounter == 1 && gameScreen.team.enemyTeam.population == 0)
                    {
                         this.boundaries = [gameScreen.team.homeX + 4000,gameScreen.team.homeX + 5000];
                         this.cameraBoundaries = [this.boundaries[0] - 500,this.boundaries[1] - 700];
                         gameScreen.team.enemyTeam.addWall(this.boundaries[0]).setConstructionAmount(1);
                         gameScreen.team.enemyTeam.addWall((this.boundaries[0] + this.boundaries[1]) / 2 - 100).setConstructionAmount(1);
                         gameScreen.team.enemyTeam.addWall(this.boundaries[1]).setConstructionAmount(1);
                         this.unitGroup1 = [Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_MAGIKILL,Unit.U_SPEARTON,Unit.U_SPEARTON,Unit.U_ARCHER,Unit.U_ARCHER,Unit.U_ARCHER];
                         this.unitGroup1RunningAway = [Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SPEARTON,Unit.U_NINJA];
                    }
                    if(this.sceneCounter == 2 && gameScreen.team.enemyTeam.population == 0)
                    {
                         this.boundaries = [gameScreen.team.homeX + 6000,gameScreen.team.homeX + 7000];
                         this.cameraBoundaries = [this.boundaries[0] - 500,this.boundaries[1] - 700];
                         gameScreen.team.enemyTeam.addWall(this.boundaries[0]).setConstructionAmount(1);
                         gameScreen.team.enemyTeam.addWall(this.boundaries[1]).setConstructionAmount(1);
                         this.unitGroup1 = [Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_MAGIKILL,Unit.U_MAGIKILL,Unit.U_SPEARTON,Unit.U_SPEARTON,Unit.U_ARCHER,Unit.U_ARCHER,Unit.U_ARCHER,Unit.U_FLYING_CROSSBOWMAN];
                         this.unitGroup1RunningAway = [Unit.U_SPEARTON,Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SPEARTON,Unit.U_ARCHER,Unit.U_ARCHER];
                         ++gameScreen.team.enemyTeam.population;
                    }
               }
               else if(this.currentLevelTitle == "Marrowkai\'s Grudge: Stamp out the Magic")
               {
                    if(!this.levelSetupComplete)
                    {
                         gameScreen.team.spawnUnitGroup([Unit.U_SKELATOR,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                         gameScreen.team.enemyTeam.spawnUnitGroup([Unit.U_MAGIKILL,Unit.U_MAGIKILL,Unit.U_MONK,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER]);
                         this.levelSetupComplete = true;
                    }
                    if(this.marrowResponse == false && this.messageOpening.visible == false)
                    {
                         this.marrowResponse = true;
                         this.messageOpening.setMessage("Marrowkai: This one\'s personal...","");
                         this.frames = 0;
                    }
                    CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.1);
                    for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL])
                    {
                         if(u.isNormal)
                         {
                              randomNumber = Math.floor(Math.random() * 3) + 1;
                              if(randomNumber == 1)
                              {
                                   u.magikillType = "Explosion";
                              }
                              else if(randomNumber == 2)
                              {
                                   u.magikillType = "Poison";
                              }
                              else
                              {
                                   u.magikillType = "Stun";
                              }
                         }
                    }
                    for each(u in gameScreen.team.enemyTeam.units)
                    {
                         if(u.isProtected && u.justDodgedDeath && u.type != Unit.U_MONK)
                         {
                              u.justDodgedDeath = false;
                              this.messageOpening.setMessage("Take down the Meric to disable her Protection ability on the enemy unit!","");
                              this.frames = 0;
                         }
                    }
               }
               else if(this.currentLevelTitle == "Jailbreak: Titans Revolt")
               {
                    if(!this.levelSetupComplete)
                    {
                         gameScreen.team.spawnUnitGroup([Unit.U_GIANT,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                         gameScreen.team.enemyTeam.spawnUnitGroup([Unit.U_ENSLAVED_GIANT,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER]);
                         this.levelSetupComplete = true;
                    }
                    CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.1);
                    if(gameScreen.team.enemyTeam.unitGroups[Unit.U_ENSLAVED_GIANT][0] && !this.lostGiant && !this.foundLostGiant)
                    {
                         this.lostGiant = gameScreen.team.enemyTeam.unitGroups[Unit.U_ENSLAVED_GIANT][0];
                         this.lostGiant.isLostGiant = true;
                         this.foundLostGiant = true;
                         this.lostGiant.px = gameScreen.game.map.width / 2;
                    }
                    if(gameScreen.team.enemyTeam.unitGroups[Unit.U_ENSLAVED_GIANT][0] && gameScreen.team.enemyTeam.unitGroups[Unit.U_ENSLAVED_GIANT][0].isLostGiant)
                    {
                         this.holdUnits = new UnitMove();
                         this.holdUnits.owner = gameScreen.team.enemyTeam.id;
                         this.holdUnits.moveType = UnitCommand.ATTACK_MOVE;
                         if(gameScreen.team.forwardUnit)
                         {
                              this.holdUnits.arg0 = gameScreen.team.forwardUnit.px;
                         }
                         else
                         {
                              this.holdUnits.arg0 = gameScreen.team.statue.px;
                         }
                         this.holdUnits.arg1 = gameScreen.team.statue.py;
                         this.holdUnits.units.push(gameScreen.team.enemyTeam.unitGroups[Unit.U_ENSLAVED_GIANT][0].id);
                         this.holdUnits.execute(gameScreen.game);
                    }
                    if(this.lostGiant && !this.lostGiantSwitches && this.lostGiant.isSwitched)
                    {
                         this.messageOpening.setMessage("Lost Giant: I think... I understand...","");
                         this.frames = 0;
                         this.lostGiantSwitches = true;
                    }
                    if(this.lostGiant && !this.lostGiantApology && this.lostGiant.health < this.lostGiant.maxHealth / 1.1)
                    {
                         this.messageOpening.setMessage("Lost Giant: I\'m sorry Mom...","");
                         this.frames = 0;
                         this.lostGiantApology = true;
                    }
                    for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_FLYING_CROSSBOWMAN])
                    {
                         u.isExploder = true;
                    }
                    for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_SPEARTON])
                    {
                         u.isBasher = true;
                    }
               }
               else if(this.currentLevelTitle == "Siege: Titans Revenge")
               {
                    if(!this.levelSetupComplete)
                    {
                         gameScreen.team.spawnUnitGroup([Unit.U_ENSLAVED_GIANT,Unit.U_ENSLAVED_GIANT,Unit.U_GIANT,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER,Unit.U_CHAOS_MINER]);
                         gameScreen.team.enemyTeam.spawnUnitGroup([Unit.U_SPEARTON,Unit.U_SPEARTON,Unit.U_SPEARTON,Unit.U_SPEARTON,Unit.U_SPEARTON,Unit.U_SPEARTON,Unit.U_ARCHER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER]);
                         this.unitGroup1 = [[],[Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SPEARTON,Unit.U_ARCHER],[Unit.U_SPEARTON,Unit.U_SPEARTON],[Unit.U_ENSLAVED_GIANT],[]];
                         this.levelSetupComplete = true;
                    }
                    if(gameScreen.game.frame % 300 == 0 || gameScreen.isFastForward && gameScreen.game.frame % 300 == 1 && this.unitGroup1[0])
                    {
                         this.unitGroup1RunningAway = gameScreen.team.enemyTeam.spawnUnitGroup(this.unitGroup1[0]);
                         for each(u in this.unitGroup1RunningAway)
                         {
                              u.ai.alwaysAttack = true;
                         }
                         this.unitGroup1.shift();
                    }
                    for each(u in gameScreen.team.enemyTeam.units)
                    {
                         if(u.ai.alwaysAttack)
                         {
                              this.holdUnits = new UnitMove();
                              this.holdUnits.owner = gameScreen.team.enemyTeam.id;
                              this.holdUnits.moveType = UnitCommand.ATTACK_MOVE;
                              this.holdUnits.arg0 = gameScreen.game.map.width / 2;
                              this.holdUnits.arg1 = u.py;
                              this.holdUnits.units.push(u.id);
                              this.holdUnits.execute(gameScreen.game);
                         }
                    }
                    if(this.currentRoyalMessage != this.lastRoyalMessage)
                    {
                         this.messageOpening.setMessage("Royal Twin: " + this.currentRoyalMessage,"");
                         this.lastRoyalMessage = this.currentRoyalMessage;
                         this.frames = 0;
                    }
                    if(!this.leaderUnit || this.leaderUnit.isDead)
                    {
                         this.leaderUnit = null;
                         this.currentRoyalMessage = "You... bastards... *ack*";
                    }
                    else if(gameScreen.team.enemyTeam.walls.length == 0)
                    {
                         this.currentRoyalMessage = "Wall down! Go on the offensive!";
                    }
                    else if(this.leaderUnit.isProtected)
                    {
                         this.currentRoyalMessage = "Archidons, behind me!";
                         this.holdUnits = new UnitMove();
                         this.holdUnits.owner = gameScreen.team.enemyTeam.id;
                         this.holdUnits.moveType = UnitCommand.ATTACK_MOVE;
                         this.holdUnits.arg0 = this.leaderUnit.px + 250;
                         this.holdUnits.arg1 = this.leaderUnit.py;
                         for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_ARCHER])
                         {
                              this.holdUnits.units.push(u.id);
                         }
                         this.holdUnits.execute(gameScreen.game);
                    }
                    else if(gameScreen.team.enemyTeam.walls[0] && this.leaderUnit.px > gameScreen.team.enemyTeam.walls[0].px && gameScreen.team.forwardUnit && gameScreen.team.forwardUnit.px > gameScreen.game.map.width / 2)
                    {
                         this.currentRoyalMessage = "Hold the line!";
                    }
                    else if(gameScreen.team.forwardUnit && gameScreen.team.forwardUnit.px > gameScreen.game.map.width / 2.25)
                    {
                         this.currentRoyalMessage = "Steady!";
                    }
                    for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_SPEARTON])
                    {
                         if(u.speartonType == "Royal" || u.ai.alwaysAttack)
                         {
                              u.partOfWall = false;
                              if(!u.isProtected)
                              {
                                   u.isBasher = false;
                              }
                              else
                              {
                                   u.isBasher = true;
                              }
                         }
                         else if(gameScreen.team.enemyTeam.walls[0])
                         {
                              u.partOfWall = true;
                              u.isBasher = false;
                         }
                         else
                         {
                              u.partOfWall = false;
                              u.isBasher = true;
                         }
                    }
                    for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_ARCHER])
                    {
                         if(gameScreen.team.enemyTeam.unitGroups[Unit.U_ARCHER].length % 2 == 0 && u.isNormal)
                         {
                              u.archerType = "Splash";
                              u.isNormal = false;
                         }
                         else if(u.isNormal)
                         {
                              u.archerType = "Fire";
                              u.isNormal = false;
                         }
                    }
                    for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL])
                    {
                         u.magikillType = "Stun";
                    }
               }
               else if(this.currentLevelTitle == "Final Battle: Order\'s Backyard")
               {
                    if(this.generals.length > 0 && (this.leaderUnit == null || this.leaderUnit.isDead))
                    {
                         unlockEnemyQueues(gameScreen);
                         this.leaderUnit = gameScreen.team.enemyTeam.spawnUnitGroup([this.generals.shift()])[0];
                         updateEnemyGeneral(gameScreen);
                    }
                    if(gameScreen.game.frame % 300 == 0 || gameScreen.isFastForward && gameScreen.game.frame % 300 == 1)
                    {
                         setMatchups();
                         if(rngMatchup >= this.matchups.length)
                         {
                              this.rngMatchup = this.matchups.length;
                         }
                         if(this.playerBackgroundUnits.length < 5)
                         {
                              var backgroundUnitsChoice:int = Math.floor(Math.random() * rngMatchup);
                              spawnBackgroundUnitsPlayer(gameScreen,this.matchups[backgroundUnitsChoice][0]);
                         }
                         if(this.enemyBackgroundUnits.length < 5)
                         {
                              backgroundUnitsChoice = Math.floor(Math.random() * rngMatchup);
                              spawnBackgroundUnitsEnemy(gameScreen,this.matchups[backgroundUnitsChoice][2]);
                         }
                         this.rngMatchup += 1;
                    }
                    updateBackgroundUnits(gameScreen);
                    for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL])
                    {
                         if(u.magikillType == "")
                         {
                              u.magikillType = "Stun";
                         }
                    }
               }
          }
          
          public function spawnBackgroundUnitsPlayer(gameScreen:GameScreen, units:Array) : void
          {
               var spawnedUnits:Array = gameScreen.team.spawnUnitGroup(units);
               var forward_unit_px:int = -1;
               if(gameScreen.team.forwardUnit)
               {
                    forward_unit_px = gameScreen.team.forwardUnit.px;
               }
               if(forward_unit_px == -1 || forward_unit_px > gameScreen.game.targetScreenX)
               {
                    forward_unit_px = gameScreen.game.targetScreenX - 200;
               }
               else if(forward_unit_px != -1 && forward_unit_px < gameScreen.game.targetScreenX)
               {
                    forward_unit_px -= 200;
               }
               for each(var u in spawnedUnits)
               {
                    u.px = forward_unit_px - 200;
                    u.py = gameScreen.game.map.height / 2 - 150 + Math.floor(Math.random() * 25) - 60;
                    u.backgroundFighter = true;
                    u.healthBar.visible = false;
                    u.health = u.maxHealth;
                    gameScreen.team.population -= u.population;
                    this.playerBackgroundUnits.push(u);
               }
          }
          
          public function spawnBackgroundUnitsEnemy(gameScreen:GameScreen, units:Array) : void
          {
               var spawnedUnits:Array = gameScreen.team.enemyTeam.spawnUnitGroup(units);
               var forward_unit_px:int = -1;
               if(gameScreen.team.enemyTeam.forwardUnit)
               {
                    forward_unit_px = gameScreen.team.enemyTeam.forwardUnit.px;
               }
               if(forward_unit_px == -1 || forward_unit_px < gameScreen.game.targetScreenX)
               {
                    forward_unit_px = gameScreen.game.targetScreenX + 1000;
               }
               else if(forward_unit_px != -1 && forward_unit_px > gameScreen.game.targetScreenX)
               {
                    forward_unit_px += 1000;
               }
               for each(var u in spawnedUnits)
               {
                    u.px = forward_unit_px;
                    u.py = gameScreen.game.map.height / 2 - 150 + Math.floor(Math.random() * 25) - 60;
                    u.backgroundFighter = true;
                    u.healthBar.visible = false;
                    u.health = u.maxHealth;
                    gameScreen.team.enemyTeam.population -= u.population;
                    this.enemyBackgroundUnits.push(u);
               }
          }
          
          public function updateBackgroundUnits(gameScreen:GameScreen) : void
          {
               var counter:int = 0;
               this.holdUnits = new UnitMove();
               this.holdUnits.owner = gameScreen.team.id;
               this.holdUnits.moveType = UnitCommand.ATTACK_MOVE;
               this.holdUnits.arg0 = gameScreen.team.enemyTeam.statue.px + 2000;
               for each(var u in playerBackgroundUnits)
               {
                    if(u.px < 1055)
                    {
                         u.ai.currentTarget = null;
                         u.px += 1;
                    }
                    if(u.px > 7945 && u.px < 8600)
                    {
                         u.ai.currentTarget = null;
                         u.canBeTargeted = false;
                         u.px += 1;
                    }
                    else if(u.px > 8500 && !u.isDead)
                    {
                         u.px = 20000;
                         u.canBeTargeted = true;
                         u.isDieing = true;
                    }
                    else if(u.ai.currentCommand != UnitCommand.ATTACK_MOVE)
                    {
                         this.holdUnits.arg1 = u.py;
                         this.holdUnits.units.push(u.id);
                    }
                    if(u.isDead || u.health == 0)
                    {
                         u.healthBar.visible = true;
                         this.playerBackgroundUnits.splice(counter,1);
                    }
                    else
                    {
                         counter += 1;
                    }
               }
               this.holdUnits.execute(gameScreen.game);
               counter = 0;
               this.holdUnits = new UnitMove();
               this.holdUnits.owner = gameScreen.team.id;
               this.holdUnits.moveType = UnitCommand.ATTACK_MOVE;
               this.holdUnits.arg0 = gameScreen.team.statue.px - 2000;
               for each(u in enemyBackgroundUnits)
               {
                    if(u.px > 7945)
                    {
                         u.ai.currentTarget = null;
                         u.px -= 1;
                    }
                    if(u.px < 1055 && u.px > 600)
                    {
                         u.ai.currentTarget = null;
                         u.canBeTargeted = false;
                         u.px -= 1;
                    }
                    else if(u.px < 600 && !u.isDead)
                    {
                         u.px = -20000;
                         u.canBeTargeted = true;
                         u.isDieing = true;
                    }
                    else if(u.ai.currentCommand != UnitCommand.ATTACK_MOVE)
                    {
                         this.holdUnits.arg1 = u.py;
                         this.holdUnits.units.push(u.id);
                    }
                    if(u.isDead || u.health == 0)
                    {
                         u.healthBar.visible = true;
                         this.enemyBackgroundUnits.splice(counter,1);
                    }
                    else
                    {
                         u.canBeTargeted = true;
                         counter += 1;
                    }
               }
               this.holdUnits.execute(gameScreen.game);
          }
          
          public function updateEnemyGeneral(gameScreen:GameScreen) : void
          {
               var everyUnit:Array = [Unit.U_SWORDWRATH,Unit.U_ARCHER,Unit.U_MONK,Unit.U_MAGIKILL,Unit.U_SPEARTON,Unit.U_NINJA,Unit.U_FLYING_CROSSBOWMAN,Unit.U_ENSLAVED_GIANT];
               this.leaderUnit.scale *= 1.5;
               this.leaderUnit.maxHealth *= 2.5;
               this.leaderUnit.healthBar.totalHealth = this.leaderUnit.maxHealth;
               this.leaderUnit.health = this.leaderUnit.maxHealth;
               this.leaderUnit.isMiniBoss = true;
               this.leaderUnit.dressGeneral = true;
               this.leaderUnit.isNormal = false;
               for each(u in everyUnit)
               {
                    if(u == this.leaderUnit.type)
                    {
                         gameScreen.team.enemyTeam.unitsAvailable[u] = 1;
                    }
                    else
                    {
                         delete gameScreen.team.enemyTeam.unitsAvailable[u];
                    }
               }
               if(this.leaderUnit.type == Unit.U_SWORDWRATH)
               {
                    gameScreen.team.enemyTeam.unitsAvailable[Unit.U_SWORDWRATH] = 1;
               }
               if(this.leaderUnit.type == Unit.U_ARCHER)
               {
                    gameScreen.team.enemyTeam.unitsAvailable[Unit.U_SWORDWRATH] = 1;
                    gameScreen.team.enemyTeam.unitsAvailable[Unit.U_ARCHER] = 1;
               }
          }
          
          public function setMatchups() : void
          {
               this.matchups[0] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_SWORDWRATH,Unit.U_ARCHER,Unit.U_SPEARTON,Unit.U_ENSLAVED_GIANT,Unit.U_NINJA,Unit.U_FLYING_CROSSBOWMAN]];
               if(this.leaderUnit.type == Unit.U_SWORDWRATH)
               {
                    this.matchups[0] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_SWORDWRATH]];
                    this.matchups[1] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_SWORDWRATH,Unit.U_SWORDWRATH]];
                    this.matchups[2] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SWORDWRATH]];
                    this.matchups[3] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SWORDWRATH,Unit.U_SWORDWRATH]];
               }
               else if(this.leaderUnit.type == Unit.U_ARCHER)
               {
                    this.matchups[0] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_ARCHER]];
                    this.matchups[1] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_ARCHER,Unit.U_SWORDWRATH]];
                    this.matchups[2] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_SWORDWRATH,Unit.U_SWORDWRATH]];
                    this.matchups[3] = [[Unit.U_KNIGHT,Unit.U_BOMBER,Unit.U_WINGIDON],"vs",[Unit.U_ARCHER,Unit.U_ARCHER,Unit.U_SWORDWRATH]];
               }
          }
          
          public function unlockEnemyQueues(gameScreen:GameScreen) : void
          {
               var everyUnit:Array = [Unit.U_SWORDWRATH,Unit.U_ARCHER,Unit.U_MONK,Unit.U_MAGIKILL,Unit.U_SPEARTON,Unit.U_NINJA,Unit.U_FLYING_CROSSBOWMAN,Unit.U_ENSLAVED_GIANT];
               for each(u in everyUnit)
               {
                    gameScreen.team.enemyTeam.unitsAvailable[u] = 1;
               }
          }
     }
}
