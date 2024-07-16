package com.brockw.stickwar.engine.Ai
{
     import com.brockw.ds.Queue;
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.Ai.command.AttackMoveCommand;
     import com.brockw.stickwar.engine.Ai.command.MoveCommand;
     import com.brockw.stickwar.engine.Ai.command.StandCommand;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.Gold;
     import com.brockw.stickwar.engine.Ore;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Team;
     import com.brockw.stickwar.engine.units.Medusa;
     import com.brockw.stickwar.engine.units.Miner;
     import com.brockw.stickwar.engine.units.Statue;
     import com.brockw.stickwar.engine.units.Unit;
     import com.brockw.stickwar.engine.units.Wall;
     
     public class UnitAi
     {
           
          
          public var statueTargeter:Boolean = false;
          
          public var minerTargeter:Boolean = false;
          
          public var medusaTargeter:Boolean = false;
          
          public var alwaysAttack:Boolean = false;
          
          public var playerCustomUnit:Boolean = false;
          
          protected var unit:Unit;
          
          private var _commandQueue:Queue;
          
          protected var _currentCommand:UnitCommand;
          
          private var defaultStandCommand:StandCommand;
          
          protected var _mayAttack:Boolean;
          
          protected var _mayMoveToAttack:Boolean;
          
          protected var _mayMove:Boolean;
          
          protected var isTargeted:Boolean;
          
          protected var goalX:int;
          
          protected var goalY:int;
          
          protected var intendedX:int;
          
          protected var _currentTarget:Unit;
          
          protected var lastCommand:UnitCommand;
          
          protected var isNonAttackingMage:Boolean;
          
          private var cachedTarget:Unit;
          
          private var lastCacheFrame:int;
          
          public function UnitAi()
          {
               super();
               this.currentCommand = this.defaultStandCommand = new StandCommand(null);
               this.commandQueue = new Queue(1000);
               this.isNonAttackingMage = false;
               this.lastCacheFrame = 0;
               this.init();
               this.intendedX = 1;
          }
          
          public static function checkForMineAtCoordinate(team:Team, game:StickWar, x:Number, y:Number) : Ore
          {
               var ore:* = null;
               var o:Ore = null;
               if(team.statue.hitTest(x,y))
               {
                    return team.statue;
               }
               for(ore in game.map.gold)
               {
                    o = game.map.gold[ore];
                    if(o.hitTest(x,y))
                    {
                         return game.map.gold[ore];
                    }
               }
               return null;
          }
          
          public function init() : void
          {
               this.isTargeted = false;
               this.mayAttack = false;
               this.mayMoveToAttack = false;
               this.mayMove = false;
               this.currentTarget = null;
               this.lastCommand = null;
               this.goalX = 0;
               this.goalY = 0;
          }
          
          public function update(game:StickWar) : void
          {
               if(this.alwaysAttack)
               {
                    this.unit.state = 1;
               }
          }
          
          public function appendCommand(game:StickWar, c:UnitCommand) : void
          {
               this.commandQueue.push(c);
          }
          
          public function setCommand(game:StickWar, c:UnitCommand) : void
          {
               this.commandQueue.clear();
               if(!this.unit.team.isAi == true)
               {
                    if(!(this.currentCommand.type == UnitCommand.ATTACK_MOVE && c.type == UnitCommand.ATTACK_MOVE) && (this.currentCommand.targetId != c.targetId || c.targetId == -1))
                    {
                         this.unit.stateFixForCutToWalk();
                    }
               }
               this.lastCommand = this.currentCommand;
               this.currentCommand = c;
               this.setParamatersFromCommand(game);
               if(c.type == UnitCommand.REMOVE_TOWER_COMMAND)
               {
                    trace("REMOVE");
               }
          }
          
          protected function checkNextMove(game:StickWar) : void
          {
               if(this.currentCommand.isFinished(this.unit))
               {
                    if(this.currentCommand != this.defaultStandCommand)
                    {
                    }
                    this.nextMove(game);
               }
          }
          
          protected function restoreMove(game:StickWar) : void
          {
               if(this.lastCommand == null)
               {
                    this.currentCommand = this.defaultStandCommand;
               }
               else
               {
                    this.currentCommand = this.lastCommand;
               }
               if(this.currentCommand.isToggle)
               {
                    this.currentCommand = this.defaultStandCommand;
               }
               this.setParamatersFromCommand(game,true);
          }
          
          protected function nextMove(game:StickWar) : void
          {
               this.lastCommand = this.currentCommand;
               if(this.commandQueue.isEmpty())
               {
                    this.currentCommand = this.defaultStandCommand;
                    this.setParamatersFromCommand(game);
               }
               else
               {
                    this.currentCommand = UnitCommand(this.commandQueue.pop());
                    this.setParamatersFromCommand(game);
               }
          }
          
          public function baseUpdate(param1:StickWar) : void
          {
               var _loc3_:Number = NaN;
               var _loc4_:Number = NaN;
               this.checkNextMove(param1);
               var _loc2_:Unit = this.getClosestTarget();
               if(this.mayAttack && (this.unit.mayAttack(_loc2_) || _loc2_ is Wall && Math.abs(_loc2_.px - this.unit.px) < _loc2_.pwidth + this.unit.pwidth / 2))
               {
                    if(_loc2_.damageWillKill(0,this.unit.getDamageToUnit(_loc2_)) && this.unit.getDirection() != _loc2_.getDirection() && this.unit.getDirection() == Util.sgn(_loc2_.px - this.unit.px))
                    {
                         if(!this.unit.startDual(_loc2_))
                         {
                              this.unit.attack();
                         }
                    }
                    else
                    {
                         this.unit.attack();
                    }
               }
               else if(this.mayMoveToAttack && this.unit.sqrDistanceTo(_loc2_) < 640000 && !this.unit.isGarrisoned)
               {
                    if(this.isNonAttackingMage && this.unit.type != Unit.U_MEDUSA)
                    {
                         if(this.unit.type == Unit.U_MONK)
                         {
                              if(this.unit.sqrDistanceTo(_loc2_) > 50000)
                              {
                                   _loc3_ = 0;
                                   if(_loc2_.type != Unit.U_WALL && Math.abs(this.unit.px - _loc2_.px) < 200)
                                   {
                                        _loc3_ = _loc2_.py - this.unit.py;
                                   }
                                   if(Util.sgn(_loc2_.dx) == Util.sgn(this.unit.dx) && Math.abs(_loc2_.dx) > 1)
                                   {
                                        this.unit.walk((_loc2_.px - this.unit.px) / 20,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                                   }
                                   else
                                   {
                                        _loc4_ = Util.sgn(_loc2_.px - this.unit.px) * this.unit.weaponReach() * 0.5;
                                        if(Math.abs(_loc2_.px - this.unit.px) < this.unit.weaponReach() * 0.9)
                                        {
                                             this.unit.walk(0,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                                        }
                                        else
                                        {
                                             this.unit.walk((_loc2_.px - _loc4_ - this.unit.px) / 100,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                                        }
                                   }
                                   if(Math.abs(_loc2_.px - this.unit.px - (this.unit.pwidth + _loc2_.pwidth) * 0.125 * this.unit.team.direction) < 10)
                                   {
                                        this.unit.faceDirection(_loc2_.px - this.unit.px);
                                   }
                              }
                              else if(this.unit.team.isAi)
                              {
                                   _loc3_ = 0;
                                   if(_loc2_.type != Unit.U_WALL && Math.abs(this.unit.px - _loc2_.px) < 200)
                                   {
                                        _loc3_ = _loc2_.py - this.unit.py;
                                   }
                                   if(Util.sgn(_loc2_.dx) == Util.sgn(this.unit.dx) && Math.abs(_loc2_.dx) > 1)
                                   {
                                        this.unit.walk((_loc2_.px - this.unit.px) / 20,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                                   }
                                   else
                                   {
                                        _loc4_ = Util.sgn(_loc2_.px - this.unit.px) * this.unit.weaponReach() * 0.5;
                                        if(Math.abs(_loc2_.px - this.unit.px) < this.unit.weaponReach() * 0.9)
                                        {
                                             this.unit.walk(0,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                                        }
                                        else
                                        {
                                             this.unit.walk((_loc2_.px - _loc4_ - this.unit.px) / 100,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                                        }
                                   }
                                   if(Math.abs(_loc2_.px - this.unit.px - (this.unit.pwidth + _loc2_.pwidth) * 0.125 * this.unit.team.direction) < 10)
                                   {
                                        this.unit.faceDirection(_loc2_.px - this.unit.px);
                                   }
                              }
                         }
                         else if(this.currentCommand.type != UnitCommand.STAND)
                         {
                              _loc3_ = 0;
                              if(_loc2_.type != Unit.U_WALL && Math.abs(this.unit.px - _loc2_.px) < 200)
                              {
                                   _loc3_ = _loc2_.py - this.unit.py;
                              }
                              if(Util.sgn(_loc2_.dx) == Util.sgn(this.unit.dx) && Math.abs(_loc2_.dx) > 1)
                              {
                                   this.unit.walk((_loc2_.px - this.unit.px) / 20,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                              }
                              else
                              {
                                   _loc4_ = Util.sgn(_loc2_.px - this.unit.px) * this.unit.weaponReach() * 0.5;
                                   if(Math.abs(_loc2_.px - this.unit.px) < this.unit.weaponReach() * 0.9)
                                   {
                                        this.unit.walk(0,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                                   }
                                   else
                                   {
                                        this.unit.walk((_loc2_.px - _loc4_ - this.unit.px) / 100,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                                   }
                              }
                              if(Math.abs(_loc2_.px - this.unit.px - (this.unit.pwidth + _loc2_.pwidth) * 0.125 * this.unit.team.direction) < 10)
                              {
                                   this.unit.faceDirection(_loc2_.px - this.unit.px);
                              }
                         }
                         else
                         {
                              this.unit.faceDirection(_loc2_.px - this.unit.px);
                         }
                    }
                    else
                    {
                         _loc3_ = 0;
                         if(_loc2_.type != Unit.U_WALL && Math.abs(this.unit.px - _loc2_.px) < 200)
                         {
                              if(Math.abs(this.unit.py - _loc2_.py) < 40)
                              {
                                   _loc3_ = 0;
                              }
                              else
                              {
                                   _loc3_ = _loc2_.py - this.unit.py;
                              }
                         }
                         if(Util.sgn(_loc2_.dx) == Util.sgn(this.unit.dx) && Math.abs(_loc2_.dx) > 1)
                         {
                              this.unit.walk((_loc2_.px - this.unit.px) / 20,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                         }
                         else
                         {
                              _loc4_ = Util.sgn(_loc2_.px - this.unit.px) * this.unit.weaponReach() * 0.5;
                              if(Math.abs(_loc2_.px - this.unit.px) < this.unit.weaponReach() * 0.9)
                              {
                                   this.unit.walk(0,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                              }
                              else if(this.unit.type == Unit.U_MEDUSA && Math.abs(_loc2_.px - this.unit.px) > 300 && this.currentCommand.type != UnitCommand.ATTACK_MOVE && this.currentCommand.type != UnitCommand.MOVE)
                              {
                                   this.unit.walk(0,0,0);
                              }
                              else
                              {
                                   this.unit.walk((_loc2_.px - _loc4_ - this.unit.px) / 100,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                              }
                         }
                         if(Math.abs(_loc2_.px - this.unit.px - (this.unit.pwidth + _loc2_.pwidth) * 0.125 * this.unit.team.direction) < 10)
                         {
                              this.unit.faceDirection(_loc2_.px - this.unit.px);
                         }
                    }
                    this.unit.mayWalkThrough = false;
               }
               else if(this.mayMove)
               {
                    this.unit.mayWalkThrough = false;
                    this.unit.walk((this.goalX - this.unit.px) / 100,(this.goalY - this.unit.py) / 100,this.intendedX);
               }
          }
          
          protected function checkForMines(game:StickWar) : Ore
          {
               if(this.currentCommand is MoveCommand)
               {
                    if(this.currentCommand.targetId in game.units)
                    {
                         if(game.units[this.currentCommand.targetId] is Gold || game.units[this.currentCommand.targetId] is Statue)
                         {
                              return game.units[this.currentCommand.targetId];
                         }
                    }
               }
               return null;
          }
          
          protected function checkForUnitAttack(game:StickWar) : Unit
          {
               var x:int = 0;
               var y:int = 0;
               if(this.currentCommand is MoveCommand)
               {
                    x = MoveCommand(this.currentCommand).realX;
                    y = MoveCommand(this.currentCommand).realY;
                    if(x * this.unit.team.direction < this.unit.team.direction * this.unit.team.homeX)
                    {
                         return null;
                    }
                    if(this.currentCommand.targetId in game.units && game.units[this.currentCommand.targetId] is Unit)
                    {
                         if(game.units[this.currentCommand.targetId].team.id == this.unit.team.id)
                         {
                              return null;
                         }
                         if(game.units[this.currentCommand.targetId].isFlying() && !this.unit.canAttackAir())
                         {
                              return null;
                         }
                         this.currentTarget = game.units[this.currentCommand.targetId];
                         this.intendedX = Util.sgn(this.currentTarget.x - this.unit.px);
                         this.mayAttack = true;
                         this.mayMoveToAttack = true;
                         this.isTargeted = true;
                         return game.units[this.currentCommand.targetId];
                    }
                    this.isTargeted = false;
                    return null;
               }
               return null;
          }
          
          private function setParamatersFromCommand(game:StickWar, isRestore:Boolean = false) : void
          {
               if(this.currentCommand.type == UnitCommand.STAND)
               {
                    this.mayAttack = true;
                    this.mayMoveToAttack = true;
                    this.mayMove = false;
                    this.unit.mayWalkThrough = false;
               }
               else if(this.currentCommand.type == UnitCommand.HOLD)
               {
                    this.mayAttack = true;
                    this.mayMoveToAttack = false;
                    this.mayMove = false;
                    this.unit.mayWalkThrough = false;
               }
               else if(this.currentCommand.type == UnitCommand.GARRISON)
               {
                    this.mayAttack = false;
                    this.mayMoveToAttack = false;
                    this.mayMove = true;
                    this.unit.mayWalkThrough = true;
                    this.unit.garrison();
               }
               else if(this.currentCommand.type == UnitCommand.UNGARRISON)
               {
                    this.unit.ungarrison();
                    this.unit.mayWalkThrough = true;
                    this.mayAttack = false;
                    this.mayMoveToAttack = false;
                    this.mayMove = true;
                    this.goalX = this.unit.team.homeX + this.unit.team.direction * 200;
                    this.intendedX = Util.sgn(this.goalX - this.unit.px);
               }
               else if(this.currentCommand.type == UnitCommand.MOVE)
               {
                    this.unit.mayWalkThrough = false;
                    this.mayAttack = false;
                    this.mayMoveToAttack = false;
                    this.mayMove = true;
                    this.goalX = MoveCommand(this.currentCommand).goalX;
                    this.intendedX = Util.sgn(this.goalX - this.unit.px);
                    this.goalY = MoveCommand(this.currentCommand).goalY;
                    if(this.goalX * this.unit.team.direction > this.unit.team.homeX * this.unit.team.direction)
                    {
                         this.unit.ungarrison();
                    }
                    this.currentTarget = this.checkForUnitAttack(game);
                    if(this.unit.type == Unit.U_MONK && this.currentTarget != null)
                    {
                         this.mayAttack = true;
                         this.mayMoveToAttack = true;
                         this.mayMove = true;
                    }
                    else if(this.unit.type == Unit.U_MINER || this.unit.type == Unit.U_CHAOS_MINER)
                    {
                         if(!this.unit.isGarrisoned)
                         {
                              MinerAi(this).targetOre = this.checkForMines(game);
                              if(MinerAi(this).targetOre is Statue)
                              {
                                   MinerAi(this).isGoingForOre = false;
                              }
                              else
                              {
                                   MinerAi(this).isGoingForOre = true;
                              }
                         }
                    }
               }
               else if(this.currentCommand.type == UnitCommand.ATTACK_MOVE)
               {
                    this.unit.ungarrison();
                    if(this.unit.type != Unit.U_MINER && this.unit.type != Unit.U_CHAOS_MINER)
                    {
                         this.mayAttack = true;
                         this.mayMoveToAttack = true;
                         this.mayMove = true;
                         this.goalX = AttackMoveCommand(this.currentCommand).goalX;
                         this.intendedX = Util.sgn(this.goalX - this.unit.px);
                         this.goalY = AttackMoveCommand(this.currentCommand).goalY;
                         this.unit.mayWalkThrough = true;
                    }
                    else
                    {
                         if(this.unit.team.isAi == false && MinerAi(this).targetOre != null)
                         {
                              MinerAi(this).targetOre = null;
                         }
                         this.mayAttack = true;
                         this.mayMoveToAttack = true;
                         this.mayMove = true;
                         this.goalX = AttackMoveCommand(this.currentCommand).goalX;
                         this.intendedX = Util.sgn(this.goalX - this.unit.px);
                         this.goalY = AttackMoveCommand(this.currentCommand).goalY;
                    }
               }
          }
          
          public function getClosestUnitTarget() : Unit
          {
               var i:int = 0;
               var rIndex:* = undefined;
               var u:Unit = null;
               var d:Number = NaN;
               var closestMiner:Miner = null;
               var closestMedusa:Medusa = null;
               if(this.unit.team.enemyTeam.units.length == 0 || this.statueTargeter)
               {
                    return this.unit.team.enemyTeam.statue;
               }
               if(this.minerTargeter)
               {
                    for each(u in this.unit.team.enemyTeam.units)
                    {
                         if(u.type == Unit.U_CHAOS_MINER && !u.isDead)
                         {
                              if(!closestMiner)
                              {
                                   closestMiner = u;
                              }
                              if(Math.abs(u.px - this.unit.px) < Math.abs(closestMiner.px - this.unit.px))
                              {
                                   closestMiner = u;
                              }
                         }
                    }
                    return closestMiner;
               }
               if(this.medusaTargeter)
               {
                    for each(u in this.unit.team.enemyTeam.units)
                    {
                         if(u.type == Unit.U_MEDUSA && !u.isDead)
                         {
                              if(!closestMedusa)
                              {
                                   closestMedusa = u;
                              }
                              if(Math.abs(u.px - this.unit.px) < Math.abs(closestMedusa.px - this.unit.px))
                              {
                                   closestMedusa = u;
                              }
                         }
                    }
                    return closestMedusa;
               }
               var minDistance:* = Number.POSITIVE_INFINITY;
               if(this.currentTarget != null && (!this.currentTarget.isAlive() || !Unit(this.currentTarget).isTargetable() || this.unit.team == this.currentTarget.team && this.currentTarget.isSwitched))
               {
                    minDistance = Number.POSITIVE_INFINITY;
                    this.currentTarget = null;
               }
               if(this.currentTarget != null)
               {
                    minDistance = this.unit.sqrDistanceToTarget(this.currentTarget);
               }
               if(this.currentTarget != null && this.isTargeted)
               {
                    return this.currentTarget;
               }
               this.isTargeted = false;
               i = 0;
               while(i < 3)
               {
                    rIndex = this.unit.team.game.random.nextInt() % this.unit.team.enemyTeam.units.length;
                    u = this.unit.team.enemyTeam.units[rIndex];
                    if(!(u.pz != 0 && !this.unit.canAttackAir()))
                    {
                         d = this.unit.sqrDistanceToTarget(u);
                         if(d * 1.3 < minDistance && Unit(this.unit.team.enemyTeam.units[rIndex]).isTargetable() && Unit(this.unit.team.enemyTeam.units[rIndex]).backgroundFighter == this.unit.backgroundFighter)
                         {
                              minDistance = d;
                              this.currentTarget = this.unit.team.enemyTeam.units[rIndex];
                         }
                    }
                    i++;
               }
               if(this.currentTarget == null && !this.unit.backgroundFighter)
               {
                    return this.unit.team.enemyTeam.statue;
               }
               return this.currentTarget;
          }
          
          public function getClosestTarget() : Unit
          {
               var u:Unit = null;
               var closestMiner:Miner = null;
               var closestMedusa:Medusa = null;
               if(this.statueTargeter)
               {
                    return this.unit.team.enemyTeam.statue;
               }
               if(this.minerTargeter)
               {
                    for each(u in this.unit.team.enemyTeam.units)
                    {
                         if(u.type == Unit.U_CHAOS_MINER && !u.isDead)
                         {
                              if(!closestMiner)
                              {
                                   closestMiner = u;
                              }
                              if(Math.abs(u.px - this.unit.px) < Math.abs(closestMiner.px - this.unit.px))
                              {
                                   closestMiner = u;
                              }
                         }
                    }
                    this.currentTarget = closestMiner;
                    return closestMiner;
               }
               if(this.medusaTargeter)
               {
                    for each(u in this.unit.team.enemyTeam.units)
                    {
                         if(u.type == Unit.U_MEDUSA && !u.isDead)
                         {
                              if(!closestMedusa)
                              {
                                   closestMedusa = u;
                              }
                              if(Math.abs(u.px - this.unit.px) < Math.abs(closestMedusa.px - this.unit.px))
                              {
                                   closestMedusa = u;
                              }
                         }
                    }
                    return closestMedusa;
               }
               var w:Wall = null;
               if(this.lastCacheFrame == this.unit.team.game.frame)
               {
                    return this.cachedTarget;
               }
               u = this.getClosestUnitTarget();
               if(!this.unit.backgroundFighter)
               {
                    for each(w in this.unit.team.enemyTeam.walls)
                    {
                         if(this.unit.px < w.px && w.px < u.px)
                         {
                              u = w;
                         }
                         else if(this.unit.px > w.px && w.px > u.px)
                         {
                              u = w;
                         }
                    }
               }
               this.currentTarget = this.cachedTarget = u;
               this.lastCacheFrame = this.unit.team.game.frame;
               return u;
          }
          
          public function get commandQueue() : Queue
          {
               return this._commandQueue;
          }
          
          public function set commandQueue(value:Queue) : void
          {
               this._commandQueue = value;
          }
          
          public function cleanUp() : void
          {
               this.currentCommand = null;
               this.currentTarget = null;
          }
          
          public function get currentTarget() : Unit
          {
               return this._currentTarget;
          }
          
          public function set currentTarget(value:Unit) : void
          {
               this._currentTarget = value;
          }
          
          public function get mayAttack() : Boolean
          {
               return this._mayAttack;
          }
          
          public function set mayAttack(value:Boolean) : void
          {
               this._mayAttack = value;
          }
          
          public function get currentCommand() : UnitCommand
          {
               return this._currentCommand;
          }
          
          public function set currentCommand(value:UnitCommand) : void
          {
               this._currentCommand = value;
          }
          
          public function get mayMoveToAttack() : Boolean
          {
               return this._mayMoveToAttack;
          }
          
          public function set mayMoveToAttack(value:Boolean) : void
          {
               this._mayMoveToAttack = value;
          }
          
          public function get mayMove() : Boolean
          {
               return this._mayMove;
          }
          
          public function set mayMove(value:Boolean) : void
          {
               this._mayMove = value;
          }
          
          public function getIntendedX() : int
          {
               return this.goalX;
          }
          
          public function setIntendedX(value:int) : void
          {
               this.goalX = value;
          }
     }
}
