package com.brockw.stickwar.singleplayer
{
     import com.brockw.stickwar.BaseMain;
     import com.brockw.stickwar.engine.Ai.MinerAi;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.Ore;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Team;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
     import com.brockw.stickwar.engine.units.Miner;
     import com.brockw.stickwar.engine.units.Statue;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.utils.Dictionary;
     
     public class EnemyTeamAi
     {
           
          
          protected var isAttacking:Boolean;
          
          protected var team:Team;
          
          protected var unitComposition:Dictionary;
          
          private var mines:Array;
          
          private var isCreatingUnits:Boolean;
          
          public var respectForEnemy:Number;
          
          public var alwaysAttack:Boolean;
          
          public function EnemyTeamAi(team:Team, main:BaseMain, game:StickWar, isCreatingUnits:* = true)
          {
               super();
               this.team = team;
               this.isCreatingUnits = isCreatingUnits;
               this.isAttacking = false;
          }
          
          public function update(game:StickWar) : void
          {
               this.team.calculateStatistics();
               this.team.enemyTeam.calculateStatistics();
               this.team.respectForEnemy = this.respectForEnemy;
               this.updateMiners(game);
               this.rebalanceMiners(game);
               this.updateGlobalStrategy(game);
               if(this.isCreatingUnits)
               {
                    this.updateUnitCreation(game);
               }
               this.updateSpellCasters(game);
          }
          
          protected function updateMiners(game:StickWar) : void
          {
               var miner:Miner = null;
               var i:int = 0;
               for each(miner in this.team.unitGroups[this.team.getMinerType()])
               {
                    this.updateMiner(miner,game,i++);
               }
          }
          
          protected function rebalanceMiners(param1:StickWar) : void
          {
               var _loc5_:Miner = null;
               var _loc6_:int = 0;
               var _loc2_:Array = [];
               var _loc3_:Array = [];
               var _loc4_:int = 0;
               for each(_loc5_ in this.team.unitGroups[this.team.getMinerType()])
               {
                    if(MinerAi(_loc5_.ai).targetOre is Statue)
                    {
                         _loc3_.push(_loc5_);
                    }
                    else if(MinerAi(_loc5_.ai).targetOre != null)
                    {
                         _loc2_.push(_loc5_);
                    }
               }
               _loc6_ = Math.floor((_loc3_.length + _loc2_.length) / 3);
               if(_loc3_.length + _loc2_.length > 0)
               {
                    if(_loc3_.length < _loc6_)
                    {
                         _loc5_ = _loc2_[0];
                         MinerAi(_loc5_.ai).targetOre.releaseMiningSpot(_loc5_);
                         _loc5_.team.statue.getMiningSpot(_loc5_);
                         MinerAi(_loc5_.ai).targetOre = _loc5_.team.statue;
                    }
                    else if(_loc3_.length > _loc6_)
                    {
                         _loc5_ = _loc3_[0];
                         MinerAi(_loc5_.ai).targetOre.releaseMiningSpot(_loc5_);
                         this.iterateOverFreeMines(_loc5_,param1);
                    }
               }
          }
          
          protected function updateMiner(miner:Miner, game:StickWar, index:int) : void
          {
               var target:Unit = null;
               var m:UnitMove = null;
               if(MinerAi(miner.ai).targetOre == null || MinerAi(miner.ai).targetOre && !MinerAi(miner.ai).targetOre.hasMiningSpot(miner))
               {
                    target = MinerAi(miner.ai).getClosestTarget();
                    if(target != null && miner.team.direction * target.px < miner.team.direction * (miner.px - miner.team.direction * 100))
                    {
                         m = new UnitMove();
                         m.moveType = UnitCommand.ATTACK_MOVE;
                         m.units.push(miner.id);
                         m.owner = this.team.id;
                         m.arg0 = target.px;
                         m.arg1 = target.py;
                         m.execute(this.team.game);
                    }
                    else
                    {
                         this.iterateOverFreeMines(miner,game);
                    }
               }
          }
          
          protected function iterateOverFreeMines(param1:Miner, param2:StickWar) : void
          {
               var _loc4_:int = 0;
               var _loc5_:Ore = null;
               var _loc3_:Boolean = false;
               if(this.team.direction == 1)
               {
                    _loc4_ = 0;
                    while(_loc4_ < param2.map.gold.length)
                    {
                         _loc5_ = param2.map.gold[_loc4_];
                         if(this.getFreeMine(param1,param2,_loc5_))
                         {
                              _loc3_ = true;
                              break;
                         }
                         _loc4_++;
                    }
               }
               else
               {
                    _loc4_ = int(param2.map.gold.length - 1);
                    while(_loc4_ >= 0)
                    {
                         _loc5_ = param2.map.gold[_loc4_];
                         if(this.getFreeMine(param1,param2,_loc5_))
                         {
                              _loc3_ = true;
                              break;
                         }
                         _loc4_--;
                    }
               }
               if(!_loc3_)
               {
                    MinerAi(param1.ai).targetOre = null;
               }
          }
          
          protected function getFreeMine(miner:Miner, game:StickWar, gold:Ore) : Boolean
          {
               if(!gold.isMineFull())
               {
                    gold.getMiningSpot(miner);
                    MinerAi(miner.ai).targetOre = gold;
                    return true;
               }
               return false;
          }
          
          protected function attackMoveGroupTo(x:Number) : void
          {
               var unit:* = null;
               var u:Unit = null;
               var m:UnitMove = null;
               this.isAttacking = true;
               var attackMoveUnits:* = new UnitMove();
               attackMoveUnits.moveType = UnitCommand.ATTACK_MOVE;
               var moveUnits:* = new UnitMove();
               moveUnits.moveType = UnitCommand.MOVE;
               for(unit in this.team.units)
               {
                    u = this.team.units[unit];
                    if(!u.backgroundFighter)
                    {
                         if((u.type == Unit.U_MINER || u.type == Unit.U_CHAOS_MINER) && MinerAi(u.ai).targetOre != null)
                         {
                              m = new UnitMove();
                              m.moveType = UnitCommand.MOVE;
                              m.units.push(u.id);
                              m.owner = this.team.id;
                              m.arg4 = MinerAi(u.ai).targetOre.id;
                              m.arg0 = MinerAi(u.ai).targetOre.x;
                              m.arg1 = MinerAi(u.ai).targetOre.y;
                              m.execute(this.team.game);
                         }
                         else if(u.isRejoiningFormation && this.team.direction * x <= this.team.direction * u.px)
                         {
                              moveUnits.units.push(u.id);
                              if(Math.abs(u.px - x) < 50)
                              {
                                   u.isRejoiningFormation = false;
                              }
                         }
                         else
                         {
                              attackMoveUnits.units.push(u.id);
                              if(Math.abs(u.px - x) > 1000)
                              {
                                   u.isRejoiningFormation = true;
                              }
                         }
                    }
               }
               attackMoveUnits.owner = this.team.id;
               attackMoveUnits.arg0 = x;
               attackMoveUnits.arg1 = this.team.game.gameScreen.game.map.height / 2;
               attackMoveUnits.execute(this.team.game);
               moveUnits.owner = this.team.id;
               moveUnits.arg0 = x;
               moveUnits.arg1 = this.team.game.gameScreen.game.map.height / 2;
               moveUnits.execute(this.team.game);
          }
          
          protected function garrisonGroup() : void
          {
               var unit:* = null;
               this.isAttacking = false;
               var u:UnitMove = new UnitMove();
               u.moveType = UnitCommand.GARRISON;
               for(unit in this.team.units)
               {
                    u.units.push(this.team.units[unit].id);
               }
               u.owner = this.team.id;
               u.arg0 = 0;
               u.arg1 = this.team.game.map.height / 2;
               u.execute(this.team.game);
          }
          
          protected function defendGroup() : void
          {
               var unit:* = null;
               var u:Unit = null;
               var m:UnitMove = null;
               this.isAttacking = false;
               var attackMoveUnits:* = new UnitMove();
               attackMoveUnits.moveType = UnitCommand.ATTACK_MOVE;
               var moveUnits:* = new UnitMove();
               moveUnits.moveType = UnitCommand.MOVE;
               for(unit in this.team.units)
               {
                    u = this.team.units[unit];
                    if((u.type == Unit.U_MINER || u.type == Unit.U_CHAOS_MINER) && MinerAi(u.ai).targetOre != null)
                    {
                         m = new UnitMove();
                         m.moveType = UnitCommand.MOVE;
                         m.units.push(u.id);
                         m.owner = this.team.id;
                         m.arg0 = MinerAi(u.ai).targetOre.x;
                         m.arg1 = MinerAi(u.ai).targetOre.y;
                         m.arg4 = MinerAi(u.ai).targetOre.id;
                         m.execute(this.team.game);
                    }
                    else if(!u.isHome)
                    {
                         moveUnits.units.push(u.id);
                    }
                    else
                    {
                         attackMoveUnits.units.push(u.id);
                    }
               }
               moveUnits.owner = this.team.id;
               moveUnits.arg0 = this.team.homeX + this.team.direction * 600;
               moveUnits.arg1 = this.team.game.gameScreen.game.map.height / 2;
               attackMoveUnits.owner = this.team.id;
               attackMoveUnits.arg0 = this.team.homeX + this.team.direction * 600;
               attackMoveUnits.arg1 = this.team.game.gameScreen.game.map.height / 2;
               attackMoveUnits.execute(this.team.game);
               moveUnits.execute(this.team.game);
          }
          
          protected function updateGlobalStrategy(game:StickWar) : void
          {
               var movePos:Number = NaN;
               if(this.alwaysAttack)
               {
                    this.attackMoveGroupTo(this.team.direction * 250);
               }
               else if(this.isArmyHealers())
               {
                    this.defendGroup();
               }
               else if(this.enemyIsWeak())
               {
                    this.attackMoveGroupTo(this.team.medianPosition + this.team.direction * 250);
               }
               else if(this.enemyIsEvenStrength())
               {
                    movePos = this.team.medianPosition + this.team.direction * 250;
                    if(this.team.direction * movePos > this.team.direction * this.team.game.map.width / 2)
                    {
                         movePos = this.team.game.map.width / 2;
                    }
                    this.attackMoveGroupTo(movePos);
               }
               else if(this.enemyIsAttacking())
               {
                    this.defendGroup();
               }
               else if(this.enemyAtMiddle())
               {
                    this.defendGroup();
               }
               else
               {
                    this.attackMoveGroupTo(this.team.game.map.width / 2);
               }
          }
          
          protected function updateUnitCreation(game:StickWar) : void
          {
          }
          
          protected function updateSpellCasters(game:StickWar) : void
          {
          }
          
          protected function isArmyHealers() : Boolean
          {
               return false;
          }
          
          protected function enemyIsWeak() : Boolean
          {
               if(this.respectForEnemy == 0)
               {
                    this.respectForEnemy = 1;
               }
               var percievedEnemyForce:Number = this.respectForEnemy * this.team.enemyTeam.attackingForcePopulation - 7 + getChaosTowerCount() * 6 * this.respectForEnemy + this.team.enemyTeam.castleDefence.units.length * 3;
               return percievedEnemyForce < this.team.attackingForcePopulation;
          }
          
          protected function enemyIsEvenStrength() : Boolean
          {
               if(this.team.population == 0)
               {
                    return false;
               }
               return Math.abs(this.team.enemyTeam.attackingForcePopulation - this.team.attackingForcePopulation) / this.team.attackingForcePopulation < 0.1;
          }
          
          protected function agressionMetric() : Number
          {
               var m:Number = this.team.enemyTeam.medianPosition / this.team.game.map.width;
               if(this.team.direction == 1)
               {
                    m = (this.team.game.map.width - this.team.enemyTeam.medianPosition) / this.team.game.map.width;
               }
               return m;
          }
          
          protected function enemyAtHome() : Boolean
          {
               return this.agressionMetric() < 0.3;
          }
          
          protected function enemyAtMiddle() : Boolean
          {
               return this.agressionMetric() > 0.4 && this.agressionMetric() < 0.6;
          }
          
          protected function enemyIsAttacking() : Boolean
          {
               return this.agressionMetric() >= 0.6;
          }
          
          public function setRespectForEnemy(respect:Number) : void
          {
               this.respectForEnemy = respect;
          }
          
          public function getChaosTowerCount() : int
          {
               if(this.team.enemyTeam.type == Team.T_CHAOS && this.team.enemyTeam.tech.isResearched(Tech.MINER_TOWER))
               {
                    return this.team.enemyTeam.unitGroups[Unit.U_CHAOS_TOWER].length;
               }
               return 0;
          }
     }
}
