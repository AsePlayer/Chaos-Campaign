package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.NukeCommand;
   import com.brockw.stickwar.engine.Ai.command.PoisonDartCommand;
   import com.brockw.stickwar.engine.Ai.command.StunCommand;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Magikill;
   
   public class MagikillAi extends UnitAi
   {
       
      
      public function MagikillAi(s:Magikill)
      {
         super();
         unit = s;
         isNonAttackingMage = true;
      }
      
      override public function update(game:StickWar) : void
      {
         unit.isBusyForSpell = false;
         if(currentCommand.type == UnitCommand.NUKE || currentCommand.type == UnitCommand.STUN || currentCommand.type == UnitCommand.POISON_DART)
         {
            if(!this.currentCommand.inRange(unit))
            {
               unit.mayWalkThrough = true;
               unit.isBusyForSpell = true;
               unit.walk((currentCommand.realX - unit.px) / 100,(currentCommand.realY - unit.py) / 100,(currentCommand.realX - unit.px) / 100);
            }
            else if(currentCommand.type == UnitCommand.NUKE)
            {
               Magikill(unit).nukeSpell(NukeCommand(currentCommand).realX,NukeCommand(currentCommand).realY);
               nextMove(game);
            }
            else if(currentCommand.type == UnitCommand.STUN)
            {
               Magikill(unit).stunSpell(StunCommand(currentCommand).realX,StunCommand(currentCommand).realY);
               nextMove(game);
            }
            else if(currentCommand.type == UnitCommand.POISON_DART)
            {
               Magikill(unit).poisonDartSpell(PoisonDartCommand(currentCommand).realX,PoisonDartCommand(currentCommand).realY);
               nextMove(game);
            }
         }
         else
         {
            baseUpdate(game);
         }
      }
   }
}
