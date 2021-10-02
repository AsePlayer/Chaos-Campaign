package com.brockw.stickwar.engine.Ai
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.EnslavedGiant;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class EnslavedGiantAi extends UnitAi
   {
       
      
      public function EnslavedGiantAi(s:EnslavedGiant)
      {
         super();
         unit = s;
      }
      
      override public function update(game:StickWar) : void
      {
         var walkX:Number = NaN;
         checkNextMove(game);
         var target:Unit = this.getClosestTarget();
         EnslavedGiant(unit).aim(target);
         if(target != null && mayAttack && EnslavedGiant(unit).inRange(target))
         {
            unit.faceDirection(Util.sgn(target.px - unit.px));
         }
         if(mayAttack && unit.mayAttack(target))
         {
            EnslavedGiant(unit).shoot(game,target);
         }
         else if(mayMoveToAttack && target != null && EnslavedGiant(unit).inRange(target))
         {
            walkX = target.px - unit.px - 100 * unit.team.direction;
            if(Util.sgn(walkX) != Util.sgn(target.px - unit.px))
            {
               walkX = 0;
            }
            unit.walk(walkX / 100,0,intendedX);
         }
         else if(mayMove)
         {
            unit.walk((goalX - unit.px) / 100,(goalY - unit.py) / 100,intendedX);
         }
      }
   }
}
