package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class DartCommand extends UnitCommand
   {
       
      
      public function DartCommand(game:StickWar)
      {
         super();
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Magikill(entity).poisonDartCooldown();
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
      
      override public function inRange(entity:Entity) : Boolean
      {
         return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(Unit(entity).team.game.xml.xml.Order.Units.magikill.poisonRange,2);
      }
   }
}
