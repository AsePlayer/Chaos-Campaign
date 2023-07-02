package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class SlowDartCommand extends DartCommand
   {
       
      
      public function SlowDartCommand(game:StickWar)
      {
         super(game);
         this.game = game;
         type = UnitCommand.SLOW_DART;
         hotKey = 69;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_MONK;
         requiresMouseInput = true;
         isSingleSpell = true;
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Monk(entity).slowDartCooldown();
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return Monk(unit).slowDartCooldown() != 0;
      }
      
      override public function inRange(entity:Entity) : Boolean
      {
         return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(Unit(entity).team.game.xml.xml.Order.Units.magikill.poisonRange,2);
      }
   }
}
