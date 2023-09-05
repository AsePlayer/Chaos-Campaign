package com.brockw.stickwar.engine.Ai
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Bomber;
     import com.brockw.stickwar.engine.units.Unit;
     
     public class BomberAi extends UnitAi
     {
           
          
          public function BomberAi(s:Bomber)
          {
               super();
               unit = s;
          }
          
          override public function update(game:StickWar) : void
          {
               checkNextMove(game);
               var target:Unit = this.getClosestTarget();
               if(currentCommand.type == UnitCommand.BOMBER_DETONATE)
               {
                    Bomber(unit).detonate();
               }
               if(mayAttack && unit.mayAttack(target))
               {
                    if(target.damageWillKill(0,unit.damageToDeal) && unit.getDirection() != target.getDirection() && unit.getDirection() == Util.sgn(target.px - unit.px))
                    {
                         unit.attack();
                    }
                    else
                    {
                         unit.attack();
                    }
               }
               else if(mayMoveToAttack && unit.sqrDistanceTo(target) < 150000 && !unit.isGarrisoned)
               {
                    unit.walk((target.px - unit.px) / 30,target.py - unit.py,Util.sgn(target.px - unit.px));
                    if(Math.abs(target.px - unit.px) < 10)
                    {
                         unit.faceDirection(target.px - unit.px);
                    }
                    unit.mayWalkThrough = false;
               }
               else if(mayMove)
               {
                    unit.mayWalkThrough = true;
                    unit.walk((goalX - unit.px) / 100,(goalY - unit.py) / 100,intendedX);
               }
          }
     }
}
