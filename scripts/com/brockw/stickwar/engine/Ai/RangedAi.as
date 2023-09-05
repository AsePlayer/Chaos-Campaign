package com.brockw.stickwar.engine.Ai
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.RangedUnit;
     
     public class RangedAi extends UnitAi
     {
           
          
          public var mayKite:Boolean;
          
          public function RangedAi(s:RangedUnit)
          {
               super();
               unit = s;
               this.mayKite = false;
          }
          
          override public function update(game:StickWar) : void
          {
               var walkX:Number = NaN;
               if(!this.mayKite && currentTarget != null && currentTarget.isAlive() && RangedUnit(unit).inRange(currentTarget))
               {
                    currentTarget = currentTarget;
               }
               else if(mayAttack || !this.mayKite)
               {
                    currentTarget = this.getClosestTarget();
               }
               RangedUnit(unit).aim(currentTarget);
               if(RangedUnit(unit).mayAttack(currentTarget) && currentCommand.type != UnitCommand.MOVE)
               {
                    unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
               }
               else if(!this.mayKite && currentCommand.type != UnitCommand.MOVE && RangedUnit(unit).inRange(currentTarget))
               {
                    unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
               }
               if(mayAttack && unit.mayAttack(currentTarget) && (RangedUnit(unit).isLoaded() || !this.mayKite))
               {
                    unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
                    RangedUnit(unit).shoot(game,currentTarget);
               }
               else if(mayMoveToAttack && currentTarget != null && unit.sqrDistanceTo(currentTarget) < 150000 && !unit.isGarrisoned)
               {
                    walkX = currentTarget.px - unit.px - 100 * unit.team.direction;
                    if(this.mayKite && Math.abs(currentTarget.px - unit.px) < 350 && !RangedUnit(unit).isLoaded())
                    {
                         unit.walk(Util.sgn(unit.px - currentTarget.px),0,Util.sgn(unit.px - currentTarget.px));
                    }
                    else if(RangedUnit(unit).inRange(currentTarget) || Util.sgn(walkX) != Util.sgn(currentTarget.px - unit.px))
                    {
                         walkX = 0;
                         unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
                    }
                    else
                    {
                         unit.walk(walkX / 100,(goalY - unit.py) / 100,Util.sgn(currentTarget.px - unit.px));
                    }
               }
               else if(mayMove)
               {
                    unit.walk((goalX - unit.px) / 100,(goalY - unit.py) / 100,intendedX);
               }
               else if(currentTarget != null)
               {
                    unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
               }
          }
     }
}
