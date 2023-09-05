package com.brockw.stickwar.campaign.controllers
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.campaign.CampaignGameScreen;
     import com.brockw.stickwar.campaign.InGameMessage;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
     import com.brockw.stickwar.engine.units.FlyingCrossbowman;
     import com.brockw.stickwar.engine.units.Medusa;
     import com.brockw.stickwar.engine.units.Ninja;
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
          
          public function CampaignKnight(gameScreen:GameScreen)
          {
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
                    else if(this.currentLevelTitle == "Scouting Party: Unexpected Guests3")
                    {
                         this.messageOpening.setMessage("Queen Medusa: Scratch my Medussy!","",0,this.medusaOneLiner);
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
               else if(this.currentLevelTitle == "Scouting Party: Unexpected Guests3")
               {
                    CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.1);
                    if(gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL].length > 2)
                    {
                         gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL][0].magikillType = "Explosion";
                         gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL][1].magikillType = "Poison";
                         gameScreen.team.enemyTeam.unitGroups[Unit.U_MAGIKILL][2].magikillType = "Stun";
                    }
                    for each(u in gameScreen.team.enemyTeam.units)
                    {
                         if(u.px > gameScreen.game.map.width / 2)
                         {
                              u.px = gameScreen.game.map.width / 3;
                         }
                    }
               }
          }
     }
}
