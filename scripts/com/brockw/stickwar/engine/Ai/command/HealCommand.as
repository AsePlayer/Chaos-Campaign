package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Monk;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class HealCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new HealBitmap());
       
      
      public function HealCommand(game:StickWar)
      {
         super();
         type = UnitCommand.HEAL;
         hotKey = 81;
         _hasCoolDown = false;
         _intendedEntityType = Unit.U_MONK;
         requiresMouseInput = false;
         isSingleSpell = false;
         isToggle = true;
         this.buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Order.Units.monk.heal);
         }
      }
      
      override public function isToggled(entity:Entity) : Boolean
      {
         return Monk(entity).isHealToggled;
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
         return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(Unit(entity).team.game.xml.xml.Order.Units.monk.heal.range,2);
      }
   }
}
