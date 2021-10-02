package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Dead;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class DeadPoisonCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new poisonGutsBitmap());
       
      
      public function DeadPoisonCommand(game:StickWar)
      {
         super();
         type = UnitCommand.DEAD_POISON;
         hotKey = 81;
         _hasCoolDown = false;
         _intendedEntityType = Unit.U_DEAD;
         requiresMouseInput = false;
         isSingleSpell = false;
         isToggle = true;
         buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Chaos.Units.dead.poison);
         }
      }
      
      override public function isToggled(entity:Entity) : Boolean
      {
         return Dead(entity).isPoisonedToggled;
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return 0;
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
      
      override public function inRange(entity:Entity) : Boolean
      {
         return true;
      }
   }
}
