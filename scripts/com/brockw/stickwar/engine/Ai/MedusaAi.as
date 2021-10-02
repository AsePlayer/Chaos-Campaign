package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class MedusaAi extends UnitAi
   {
       
      
      public function MedusaAi(s:Medusa)
      {
         super();
         unit = s;
         isNonAttackingMage = true;
      }
      
      override public function update(game:StickWar) : void
      {
         var u:Unit = null;
         unit.isBusyForSpell = false;
         if(currentCommand.type == UnitCommand.STONE)
         {
            if(currentCommand.isFinished(unit))
            {
               baseUpdate(game);
               return;
            }
            if(!this.currentCommand.inRange(unit))
            {
               unit.mayWalkThrough = true;
               unit.isBusyForSpell = true;
               unit.walk((currentCommand.realX - unit.px) / 100,(currentCommand.realY - unit.py) / 100,(currentCommand.realX - unit.px) / 100);
            }
            else if(currentCommand.type == UnitCommand.STONE)
            {
               u = null;
               if(currentCommand.targetId in game.units && game.units[currentCommand.targetId] is Unit)
               {
                  u = game.units[currentCommand.targetId];
                  if(u.team == unit.team)
                  {
                     u = null;
                  }
               }
               if(u != null)
               {
                  Medusa(unit).stone(u);
                  nextMove(game);
               }
               else
               {
                  baseUpdate(game);
               }
            }
         }
         else if(currentCommand.type == UnitCommand.POISON_POOL)
         {
            Medusa(unit).poisonSpray();
            nextMove(game);
         }
         else
         {
            baseUpdate(game);
         }
      }
   }
}
