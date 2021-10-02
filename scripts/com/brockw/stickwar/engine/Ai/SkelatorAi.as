package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.FistAttackCommand;
   import com.brockw.stickwar.engine.Ai.command.ReaperCommand;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Skelator;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class SkelatorAi extends UnitAi
   {
       
      
      public function SkelatorAi(s:Skelator)
      {
         super();
         unit = s;
         isNonAttackingMage = true;
      }
      
      override public function update(game:StickWar) : void
      {
         var targetId:int = 0;
         var targ:Entity = null;
         unit.isBusyForSpell = false;
         if(currentCommand.type == UnitCommand.FIST_ATTACK || currentCommand.type == UnitCommand.REAPER)
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
            else if(currentCommand.type == UnitCommand.FIST_ATTACK)
            {
               Skelator(unit).fistAttack(FistAttackCommand(currentCommand).realX,FistAttackCommand(currentCommand).realY);
               nextMove(game);
            }
            else if(currentCommand.type == UnitCommand.REAPER)
            {
               targetId = ReaperCommand(currentCommand).targetId;
               if(targetId in game.units)
               {
                  targ = game.units[targetId];
                  if(targ is Unit && Unit(targ).team != unit.team)
                  {
                     Skelator(unit).reaperAttack(Unit(targ));
                     nextMove(game);
                  }
                  else
                  {
                     baseUpdate(game);
                  }
               }
               else
               {
                  baseUpdate(game);
               }
            }
         }
         else
         {
            baseUpdate(game);
         }
      }
   }
}
