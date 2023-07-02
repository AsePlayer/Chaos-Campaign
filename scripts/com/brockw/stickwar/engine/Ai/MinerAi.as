package com.brockw.stickwar.engine.Ai
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Gold;
   import com.brockw.stickwar.engine.Ore;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Miner;
   import com.brockw.stickwar.engine.units.MinerChaos;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class MinerAi extends UnitAi
   {
      
      public static var TIME_TO_AUTOMINE:int = 30 * 3;
       
      
      private var _targetOre:Ore;
      
      private var _isGoingForOre:Boolean;
      
      private var _isUnassigned:Boolean;
      
      protected var timeUnassigned:int;
      
      public var canAutoMine:Boolean;
      
      public function MinerAi(s:Miner)
      {
         super();
         unit = s;
         this.targetOre = null;
         this.isGoingForOre = true;
         this._isUnassigned = true;
         this.timeUnassigned = 0;
         this.canAutoMine = true;
      }
      
      override public function init() : void
      {
         super.init();
         this.targetOre = null;
         this._isGoingForOre = true;
         this._isUnassigned = true;
      }
      
      public function startAutoMiningNow() : void
      {
         this.timeUnassigned = TIME_TO_AUTOMINE;
      }
      
      override public function init() : void
      {
         super.init();
         this.targetOre = null;
         this._isGoingForOre = true;
         this._isUnassigned = true;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(this.targetOre != null)
         {
            this._isUnassigned = false;
         }
         if(this.targetOre == null)
         {
            this._isUnassigned = true;
         }
         unit.mayWalkThrough = false;
         checkNextMove(param1);
         var _loc2_:Unit = this.getClosestTarget();
         if(mayAttack && unit.mayAttack(_loc2_))
         {
            if(_loc2_.damageWillKill(0,unit.damageToDeal) && unit.getDirection() != _loc2_.getDirection() && unit.getDirection() == Util.sgn(_loc2_.px - unit.px))
            {
               unit.attack();
            }
            else
            {
               unit.attack();
            }
         }
         else if(currentCommand.type == UnitCommand.CONSTRUCT_WALL && !currentCommand.inRange(unit))
         {
            unit.mayWalkThrough = true;
            unit.isBusyForSpell = true;
            unit.walk((currentCommand.realX - unit.px) / 20,(currentCommand.realY - unit.py) / 20,intendedX);
         }
         else if(this.currentCommand.type == UnitCommand.CONSTRUCT_WALL)
         {
            Miner(unit).buildWall(currentCommand.realX,currentCommand.realY);
            nextMove(param1);
         }
         else if(currentCommand.type == UnitCommand.CONSTRUCT_TOWER && !currentCommand.inRange(unit))
         {
            unit.mayWalkThrough = true;
            unit.isBusyForSpell = true;
            unit.walk((currentCommand.realX - unit.px) / 20,(currentCommand.realY - unit.py) / 20,intendedX);
         }
         else if(this.currentCommand.type == UnitCommand.CONSTRUCT_TOWER)
         {
            MinerChaos(unit).buildTower(currentCommand.realX,currentCommand.realY);
            nextMove(param1);
         }
         else if(this.targetOre != null && !unit.isGarrisoned)
         {
            unit.mayWalkThrough = true;
            if(Miner(unit).isBagFull())
            {
               if(this.targetOre != null)
               {
                  this.targetOre.releaseMiningSpot(Miner(unit));
               }
               _loc3_ = param1.map.height / 2 - unit.py;
               if(Math.abs(_loc3_) < 40)
               {
                  _loc3_ = 0;
               }
               unit.walk((unit.team.homeX - unit.x) / 20,_loc3_ / 20,(unit.team.homeX - unit.x) / 20);
            }
            else if(this.targetOre != null && !unit.isGarrisoned)
            {
               if(!this.targetOre.inMineRange(Miner(unit)))
               {
                  _loc4_ = this.targetOre.x - unit.team.direction * 125 - unit.x;
                  unit.walk(_loc4_ / 20,0,_loc4_ / 20);
               }
               else
               {
                  if(!this.targetOre.hasMiningSpot(Miner(unit)))
                  {
                     if(!this.targetOre.reserveMiningSpot(Miner(unit)))
                     {
                        _loc4_ = this.targetOre.x - unit.team.direction * 110 - unit.x;
                        unit.walk(_loc4_ / 20,(this.targetOre.y - unit.y) / 20,_loc4_ / 20);
                        if(Math.abs(_loc4_) < 5)
                        {
                           unit.faceDirection(this.targetOre.x - unit.x);
                        }
                     }
                  }
                  if(this.targetOre.hasMiningSpot(Miner(unit)))
                  {
                     _loc5_ = Number(this.targetOre.getMiningSpot(Miner(unit)));
                     _loc4_ = this.targetOre.x - unit.team.direction * 50 - unit.x;
                     if(this.targetOre is Gold)
                     {
                        _loc4_ = this.targetOre.x + this.targetOre.getMiningSpot(Miner(unit)) - unit.x;
                        _loc5_ = 0;
                     }
                     if(Math.abs(_loc4_) < 1)
                     {
                        Miner(unit).faceDirection(this._targetOre.x - unit.x);
                     }
                     if(!this.targetOre.mayMine(Miner(unit)))
                     {
                        unit.walk(_loc4_ / 20,(this.targetOre.y + _loc5_ - unit.py) / 20,Util.sgn(this.targetOre.x - unit.x));
                     }
                     else
                     {
                        Miner(unit).mine();
                        this.targetOre.startMining(Miner(unit));
                     }
                  }
               }
            }
         }
         else if(mayMoveToAttack && unit.sqrDistanceTo(_loc2_) < 150000)
         {
            _loc6_ = 0;
            if(_loc2_.type != Unit.U_WALL && Math.abs(unit.px - _loc2_.px) < 200)
            {
               if(Math.abs(unit.py - _loc2_.py) < 40)
               {
                  _loc6_ = 0;
               }
               else
               {
                  _loc6_ = _loc2_.py - unit.py;
               }
            }
            if(Util.sgn(_loc2_.dx) == Util.sgn(unit.dx) && Math.abs(_loc2_.dx) > 1)
            {
               unit.walk((_loc2_.px - unit.px) / 20,_loc6_,Util.sgn(_loc2_.px - unit.px));
            }
            else
            {
               _loc7_ = Util.sgn(_loc2_.px - unit.px) * unit.weaponReach() * 0.5;
               if(Math.abs(_loc2_.px - unit.px) < unit.weaponReach() * 0.9)
               {
                  unit.walk(0,_loc6_,Util.sgn(_loc2_.px - unit.px));
               }
               else
               {
                  unit.walk((_loc2_.px - _loc7_ - unit.px) / 100,_loc6_,Util.sgn(_loc2_.px - unit.px));
               }
            }
            if(Math.abs(_loc2_.px - unit.px - (unit.pwidth + _loc2_.pwidth) * 0.125 * unit.team.direction) < 10)
            {
               unit.faceDirection(_loc2_.px - unit.px);
            }
         }
         else if(mayMove)
         {
            unit.mayWalkThrough = false;
            unit.walk((goalX - unit.px) / 20,(goalY - unit.py) / 20,intendedX);
         }
         else if(this.timeUnassigned > TIME_TO_AUTOMINE && this.canAutoMine)
         {
            this.isUnassigned = false;
            this.isGoingForOre = true;
         }
         else
         {
            this.timeUnassigned = int(this.timeUnassigned + 1);
         }
         this.updateAutoMiner(Miner(unit),param1);
      }
      
      protected function updateAutoMiner(miner:Miner, game:StickWar) : void
      {
         if(this.isUnassigned)
         {
            return;
         }
         if(this.isGoingForOre)
         {
            if(MinerAi(miner.ai).targetOre == null || MinerAi(miner.ai).targetOre && !MinerAi(miner.ai).targetOre.hasMiningSpot(miner))
            {
               this.iterateOverFreeMines(miner,game);
            }
         }
         else if(MinerAi(miner.ai).targetOre == null || MinerAi(miner.ai).targetOre && !MinerAi(miner.ai).targetOre.hasMiningSpot(miner))
         {
            miner.team.statue.reserveMiningSpot(miner);
            MinerAi(miner.ai).targetOre = miner.team.statue;
         }
      }
      
      protected function iterateOverFreeMines(param1:Miner, param2:StickWar) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Ore = null;
         if(unit.team.direction == 1)
         {
            _loc3_ = 0;
            while(_loc3_ < param2.map.gold.length / 2)
            {
               _loc4_ = param2.map.gold[_loc3_];
               if(this.getFreeMine(param1,param2,_loc4_))
               {
                  break;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = int(param2.map.gold.length - 1);
            while(_loc3_ >= param2.map.gold.length / 2)
            {
               _loc4_ = param2.map.gold[_loc3_];
               if(this.getFreeMine(param1,param2,_loc4_))
               {
                  break;
               }
               _loc3_--;
            }
         }
      }
      
      protected function getFreeMine(miner:Miner, game:StickWar, gold:Ore) : Boolean
      {
         if(!gold.isMineFull())
         {
            gold.reserveMiningSpot(miner);
            MinerAi(miner.ai).targetOre = gold;
            return true;
         }
         return false;
      }
      
      public function get targetOre() : Ore
      {
         return this._targetOre;
      }
      
      public function set targetOre(value:Ore) : void
      {
         if(this._targetOre == value)
         {
            return;
         }
         if(this._targetOre)
         {
            this._targetOre.stopMining(Miner(unit));
            this._targetOre.releaseMiningSpot(Miner(unit));
         }
         this._targetOre = value;
      }
      
      override public function cleanUp() : void
      {
         this.targetOre = null;
      }
      
      public function get isGoingForOre() : Boolean
      {
         return this._isGoingForOre;
      }
      
      public function set isGoingForOre(value:Boolean) : void
      {
         this._isGoingForOre = value;
      }
      
      public function get isUnassigned() : Boolean
      {
         return this._isUnassigned;
      }
      
      public function set isUnassigned(value:Boolean) : void
      {
         this._isUnassigned = value;
      }
   }
}
