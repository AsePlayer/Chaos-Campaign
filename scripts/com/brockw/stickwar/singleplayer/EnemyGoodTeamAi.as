package com.brockw.stickwar.singleplayer
{
     import com.brockw.stickwar.BaseMain;
     import com.brockw.stickwar.campaign.Campaign;
     import com.brockw.stickwar.engine.Ai.RangedAi;
     import com.brockw.stickwar.engine.Ai.command.NukeCommand;
     import com.brockw.stickwar.engine.Ai.command.PoisonDartCommand;
     import com.brockw.stickwar.engine.Ai.command.StunCommand;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Team;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.Team.TechItem;
     import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
     import com.brockw.stickwar.engine.units.Archer;
     import com.brockw.stickwar.engine.units.Magikill;
     import com.brockw.stickwar.engine.units.Monk;
     import com.brockw.stickwar.engine.units.Ninja;
     import com.brockw.stickwar.engine.units.Spearton;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.utils.Dictionary;
     
     public class EnemyGoodTeamAi extends EnemyTeamAi
     {
           
          
          private var buildOrder:Array;
          
          private var nukeSpell:NukeCommand;
          
          private var electricWallSpell:StunCommand;
          
          private var poisonSpell:PoisonDartCommand;
          
          internal var unitMove:UnitMove = null;
          
          public function EnemyGoodTeamAi(team:Team, main:BaseMain, game:StickWar, isCreatingUnits:* = true)
          {
               var key:int = 0;
               unitComposition = new Dictionary();
               unitComposition[Unit.U_MINER] = main.campaign.xml.Order.UnitComposition.Miner;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Miner) != "")
               {
                    unitComposition[Unit.U_MINER] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Miner);
               }
               unitComposition[Unit.U_SWORDWRATH] = main.campaign.xml.Order.UnitComposition.Swordwrath;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Swordwrath) != "")
               {
                    unitComposition[Unit.U_SWORDWRATH] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Swordwrath);
               }
               unitComposition[Unit.U_ARCHER] = main.campaign.xml.Order.UnitComposition.Archidon;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Archidon) != "")
               {
                    unitComposition[Unit.U_ARCHER] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Archidon);
               }
               unitComposition[Unit.U_SPEARTON] = main.campaign.xml.Order.UnitComposition.Spearton;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Spearton) != "")
               {
                    unitComposition[Unit.U_SPEARTON] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Spearton);
               }
               unitComposition[Unit.U_NINJA] = main.campaign.xml.Order.UnitComposition.Ninja;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Ninja) != "")
               {
                    unitComposition[Unit.U_NINJA] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Ninja);
               }
               unitComposition[Unit.U_FLYING_CROSSBOWMAN] = main.campaign.xml.Order.UnitComposition.FlyingCrossbowman;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.FlyingCrossbowman) != "")
               {
                    unitComposition[Unit.U_FLYING_CROSSBOWMAN] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.FlyingCrossbowman);
               }
               unitComposition[Unit.U_MONK] = main.campaign.xml.Order.UnitComposition.Monk;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Monk) != "")
               {
                    unitComposition[Unit.U_MONK] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Monk);
               }
               unitComposition[Unit.U_MAGIKILL] = main.campaign.xml.Order.UnitComposition.Magikill;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Magikill) != "")
               {
                    unitComposition[Unit.U_MAGIKILL] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Magikill);
               }
               unitComposition[Unit.U_ENSLAVED_GIANT] = main.campaign.xml.Order.UnitComposition.EnslavedGiant;
               if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.EnslavedGiant) != "")
               {
                    unitComposition[Unit.U_ENSLAVED_GIANT] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.EnslavedGiant);
               }
               var theoriticalBuildOrder:* = [Unit.U_ENSLAVED_GIANT,Unit.U_MAGIKILL,Unit.U_FLYING_CROSSBOWMAN,Unit.U_SPEARTON,Unit.U_SWORDWRATH,Unit.U_ARCHER,Unit.U_MONK,Unit.U_NINJA];
               this.buildOrder = [];
               for each(key in theoriticalBuildOrder)
               {
                    if(team.unitsAvailable == null || key in team.unitsAvailable)
                    {
                         this.buildOrder.push(key);
                    }
               }
               this.nukeSpell = new NukeCommand(game);
               this.electricWallSpell = new StunCommand(game);
               this.poisonSpell = new PoisonDartCommand(game);
               super(team,main,game,isCreatingUnits);
          }
          
          override public function update(game:StickWar) : void
          {
               super.update(game);
          }
          
          override protected function isArmyHealers() : Boolean
          {
               var numHealers:int = 0;
               if(Unit.U_MONK in unitComposition)
               {
                    numHealers = int(unitComposition[Unit.U_MONK]);
               }
               if(numHealers * team.game.xml.xml.Order.Units.monk.population == team.attackingForcePopulation)
               {
                    return true;
               }
               return false;
          }
          
          override protected function updateUnitCreation(param1:StickWar) : void
          {
               var _loc3_:int = 0;
               var _loc4_:int = 0;
               var _loc5_:TechItem = null;
               if(!enemyIsAttacking() && (team.population < 6 || enemyIsWeak()))
               {
                    _loc4_ = int(team.unitGroups[Unit.U_MINER].length);
                    if(_loc4_ < unitComposition[Unit.U_MINER] && team.unitProductionQueue[team.unitInfo[Unit.U_MINER][2]].length == 0)
                    {
                         param1.requestToSpawn(team.id,Unit.U_MINER);
                    }
               }
               var _loc2_:int = 0;
               _loc3_ = 0;
               while(_loc3_ < this.buildOrder.length)
               {
                    _loc4_ = int(team.unitGroups[this.buildOrder[_loc3_]].length);
                    if(_loc4_ >= unitComposition[this.buildOrder[_loc3_]])
                    {
                         _loc2_++;
                    }
                    else if(team.unitProductionQueue[team.unitInfo[this.buildOrder[_loc3_]][2]].length == 0)
                    {
                         param1.requestToSpawn(team.id,this.buildOrder[_loc3_]);
                    }
                    _loc3_++;
               }
               if(_loc2_ >= this.buildOrder.length)
               {
                    _loc3_ = 0;
                    while(_loc3_ < this.buildOrder.length)
                    {
                         _loc4_ = int(team.unitGroups[this.buildOrder[_loc3_]].length);
                         if(team.unitProductionQueue[team.unitInfo[this.buildOrder[_loc3_]][2]].length == 0)
                         {
                              param1.requestToSpawn(team.id,this.buildOrder[_loc3_]);
                         }
                         _loc3_++;
                    }
               }
               if(team.game.main.campaign.currentLevel != 0 && team.game.main.campaign.getCurrentLevel().title != "Lost Giant")
               {
                    if(!team.tech.isResearched(Tech.CASTLE_ARCHER_1))
                    {
                         _loc5_ = team.tech.upgrades[Tech.CASTLE_ARCHER_1];
                         if(_loc5_ == null)
                         {
                              return;
                         }
                         if(_loc5_.cost < team.gold && _loc5_.mana < team.mana)
                         {
                              team.tech.startResearching(Tech.CASTLE_ARCHER_1);
                         }
                    }
                    else if(!team.tech.isResearched(Tech.CASTLE_ARCHER_2) && team.game.main.campaign.difficultyLevel > Campaign.D_NORMAL)
                    {
                         _loc5_ = team.tech.upgrades[Tech.CASTLE_ARCHER_2];
                         if(_loc5_ == null)
                         {
                              return;
                         }
                         if(_loc5_.cost < team.gold && _loc5_.mana < team.mana)
                         {
                              team.tech.startResearching(Tech.CASTLE_ARCHER_2);
                         }
                    }
               }
               if(Boolean(team.tech.isResearchedMap[Tech.CROSSBOW_FIRE]) == false)
               {
                    team.tech.isResearchedMap[Tech.CROSSBOW_FIRE] = true;
               }
          }
          
          override protected function updateSpellCasters(game:StickWar) : void
          {
               var manaBefore:Number = team.mana;
               team.mana = 1000;
               this.updateMagikill(game);
               this.updateArchers(game);
               this.updateNinjas(game);
               this.updateSpeartons(game);
               this.updateMiners(game);
               team.tech.isResearchedMap[Tech.SWORDWRATH_RAGE] = true;
               team.tech.isResearchedMap[Tech.MINER_SPEED] = true;
               if(game.main.campaign.difficultyLevel != Campaign.D_NORMAL)
               {
                    team.tech.isResearchedMap[Tech.TOWER_SPAWN_I] = true;
                    team.tech.isResearchedMap[Tech.TOWER_SPAWN_II] = true;
               }
               else
               {
                    team.tech.isResearchedMap[Tech.TOWER_SPAWN_I] = true;
               }
               team.mana = manaBefore;
          }
          
          private function updateArchers(game:StickWar) : void
          {
               var archer:Archer = null;
               for each(archer in team.unitGroups[Unit.U_ARCHER])
               {
                    if(archer.ai.currentTarget != null)
                    {
                         RangedAi(archer.ai).mayKite = true;
                    }
               }
          }
          
          private function updateNinjas(game:StickWar) : void
          {
               var ninja:Ninja = null;
               var target:Unit = null;
               team.tech.isResearchedMap[Tech.CLOAK] = true;
               team.tech.isResearchedMap[Tech.CLOAK_II] = true;
               team.mana = 500;
               for each(ninja in team.unitGroups[Unit.U_NINJA])
               {
                    target = ninja.ai.getClosestTarget();
                    if(target != null && target.isAlive())
                    {
                         if(Math.abs(target.px - ninja.px) < 500)
                         {
                              ninja.stealth();
                         }
                    }
               }
          }
          
          private function updateSpeartons(game:StickWar) : void
          {
               var targetX:Number = NaN;
               var targetY:* = NaN;
               var spearton:Spearton = null;
               var s:Spearton = null;
               var target:Unit = null;
               var unitToDefend:Unit = null;
               team.tech.isResearchedMap[Tech.BLOCK] = true;
               team.tech.isResearchedMap[Tech.SHIELD_BASH] = true;
               unitToDefend = team.unitGroups[Unit.U_MONK][0] || team.unitGroups[Unit.U_MAGIKILL][0] || team.unitGroups[Unit.U_ARCHER][0];
               for each(s in team.unitGroups[Unit.U_SPEARTON])
               {
                    if(s.isMinion == false && s.isBasher == false && s.partOfWall == false)
                    {
                         spearton = s;
                    }
               }
               if(spearton && unitToDefend)
               {
                    target = spearton.ai.getClosestTarget();
                    targetX = unitToDefend.px - 80;
                    targetY = unitToDefend.py;
                    this.unitMove = new UnitMove();
                    this.unitMove.owner = team.id;
                    this.unitMove.moveType = UnitCommand.STAND;
                    spearton.wantsToShield = true;
                    if(spearton.px + 50 <= unitToDefend.px && Math.abs(spearton.px - unitToDefend.px) <= 160 + 40 * spearton.inBlock * (target.px < spearton.px) && Math.abs(spearton.py - unitToDefend.py) <= 20)
                    {
                         if(!spearton.inBlock && spearton.wantsToShield)
                         {
                              spearton.faceDirection(-1);
                              spearton.startBlocking();
                         }
                         if(Math.abs(spearton.px - target.px) < 25)
                         {
                              spearton.shieldBash();
                         }
                    }
                    else if(target)
                    {
                         this.unitMove.moveType = UnitCommand.MOVE;
                    }
                    this.unitMove.arg0 = targetX;
                    this.unitMove.arg1 = targetY;
                    this.unitMove.units.push(spearton.id);
                    this.unitMove.execute(game);
               }
               else if(spearton)
               {
                    spearton.wantsToShield = false;
               }
               for each(spearton in team.unitGroups[Unit.U_SPEARTON])
               {
                    if(spearton.isProtected)
                    {
                         this.unitMove = new UnitMove();
                         this.unitMove.owner = team.id;
                         this.unitMove.moveType = UnitCommand.ATTACK_MOVE;
                         this.unitMove.arg0 = spearton.px - 100;
                         this.unitMove.arg1 = spearton.py;
                         this.unitMove.units.push(spearton.id);
                         this.unitMove.execute(game);
                    }
                    else if(spearton.isBasher)
                    {
                         if(spearton.shieldBashCooldown() <= 0 && spearton.px - spearton.ai.getClosestTarget().px < 50)
                         {
                              this.unitMove = new UnitMove();
                              this.unitMove.owner = team.id;
                              this.unitMove.moveType = UnitCommand.STAND;
                              this.unitMove.arg0 = spearton.px;
                              this.unitMove.arg1 = spearton.py;
                              this.unitMove.units.push(spearton.id);
                              this.unitMove.execute(game);
                              if(!spearton.inBlock)
                              {
                                   spearton.startBlocking();
                                   spearton.shieldBash();
                              }
                         }
                         else if(!spearton.isShieldBashing && spearton.inBlock)
                         {
                              spearton.stopBlocking();
                         }
                    }
                    else if(spearton.partOfWall && team.walls[0])
                    {
                         if(spearton.px <= team.walls[0].px - 10)
                         {
                              this.unitMove = new UnitMove();
                              this.unitMove.owner = team.id;
                              this.unitMove.moveType = UnitCommand.STAND;
                              this.unitMove.arg0 = spearton.px;
                              this.unitMove.arg1 = spearton.py;
                              this.unitMove.units.push(spearton.id);
                              this.unitMove.execute(game);
                              if(!spearton.inBlock)
                              {
                                   spearton.startBlocking();
                              }
                              else if(Math.abs(spearton.px - spearton.ai.getClosestTarget().px) < 42 && Math.abs(spearton.py - spearton.ai.getClosestTarget().py) < 42 && spearton.shieldBashCooldown() <= 0)
                              {
                                   spearton.shieldBash();
                              }
                         }
                         else if(spearton.px < team.statue.px)
                         {
                              this.unitMove = new UnitMove();
                              this.unitMove.owner = team.id;
                              this.unitMove.moveType = UnitCommand.MOVE;
                              this.unitMove.arg0 = spearton.px - 100;
                              this.unitMove.arg1 = spearton.py;
                              this.unitMove.units.push(spearton.id);
                              this.unitMove.execute(game);
                         }
                    }
               }
          }
          
          private function updateMagikill(game:StickWar) : void
          {
               var magikill:Magikill = null;
               var monk:Monk = null;
               var target:Unit = null;
               team.tech.isResearchedMap[Tech.MAGIKILL_NUKE] = true;
               team.tech.isResearchedMap[Tech.MAGIKILL_POISON] = true;
               team.tech.isResearchedMap[Tech.MAGIKILL_WALL] = true;
               team.tech.isResearchedMap[Tech.MONK_CURE] = true;
               for each(magikill in team.unitGroups[Unit.U_MAGIKILL])
               {
                    target = magikill.ai.getClosestTarget();
                    if(target)
                    {
                         if(magikill.nukeCooldown() == 0 && magikill.magikillType == "Explosion")
                         {
                              this.nukeSpell.realX = target.px;
                              this.nukeSpell.realY = target.py;
                              if(this.nukeSpell.inRange(magikill))
                              {
                                   magikill.nukeSpell(target.px,target.py);
                              }
                         }
                         else if(magikill.stunCooldown() == 0 && magikill.magikillType == "Stun")
                         {
                              this.electricWallSpell.realX = target.px;
                              this.electricWallSpell.realY = target.py;
                              if(this.electricWallSpell.inRange(magikill))
                              {
                                   magikill.stunSpell(target.px + magikill.spellStacks * 25,target.py);
                              }
                         }
                         else if(magikill.poisonDartCooldown() == 0 && magikill.magikillType == "Poison")
                         {
                              this.poisonSpell.realX = target.px;
                              this.poisonSpell.realY = target.py;
                              if(this.poisonSpell.inRange(magikill))
                              {
                                   magikill.poisonDartSpell(target.px,target.py);
                              }
                         }
                         else if(Math.abs(magikill.px - team.forwardUnit.px) < 200 + 100 * magikill.spellStacks)
                         {
                              this.unitMove = new UnitMove();
                              this.unitMove.owner = team.id;
                              this.unitMove.moveType = UnitCommand.MOVE;
                              this.unitMove.arg0 = team.forwardUnit.px + 200 + 100 * magikill.spellStacks;
                              this.unitMove.arg1 = magikill.py;
                              this.unitMove.units.push(magikill.id);
                              this.unitMove.execute(game);
                         }
                         else
                         {
                              this.unitMove = new UnitMove();
                              this.unitMove.owner = team.id;
                              this.unitMove.moveType = UnitCommand.HOLD;
                              this.unitMove.arg0 = target.px + 20;
                              this.unitMove.arg1 = magikill.py;
                              this.unitMove.units.push(magikill.id);
                              this.unitMove.execute(game);
                         }
                         for each(monk in team.unitGroups[Unit.U_MONK])
                         {
                              if(monk.healCooldown() != 0)
                              {
                                   this.unitMove = new UnitMove();
                                   this.unitMove.owner = team.id;
                                   this.unitMove.moveType = UnitCommand.MOVE;
                                   this.unitMove.arg0 = team.forwardUnit.px + 169;
                                   this.unitMove.arg1 = team.forwardUnit.py;
                                   this.unitMove.units.push(monk.id);
                                   this.unitMove.execute(game);
                              }
                         }
                    }
               }
          }
          
          private function updateMiners(game:StickWar) : void
          {
               if(team.unitGroups[Unit.U_MINER].length <= 0)
               {
                    return;
               }
               var magikill:Magikill = null;
               var monk:Monk = null;
               var target:Unit = null;
               team.tech.isResearchedMap[Tech.MINER_WALL] = true;
               if(team.walls.length == 0 && team.unitGroups[Unit.U_MINER][0].constructCooldown() <= 0)
               {
                    this.unitMove = new UnitMove();
                    this.unitMove.owner = team.id;
                    this.unitMove.moveType = UnitCommand.CONSTRUCT_WALL;
                    this.unitMove.arg0 = team.homeX - 900;
                    this.unitMove.arg1 = team.statue.py;
                    this.unitMove.units.push(team.unitGroups[Unit.U_MINER][0].id);
                    this.unitMove.execute(game);
               }
          }
     }
}
