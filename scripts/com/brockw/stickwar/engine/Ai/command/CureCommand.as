package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Monk;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class CureCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CureBitmap());
       
      
      private var cureRange:Number;
      
      public function CureCommand(game:StickWar)
      {
         super();
         type = UnitCommand.CURE;
         hotKey = 87;
         _hasCoolDown = false;
         _intendedEntityType = Unit.U_MONK;
         requiresMouseInput = false;
         isSingleSpell = false;
         isToggle = true;
         this.buttonBitmap = actualButtonBitmap;
         this.cureRange = 0;
         if(game != null)
         {
            this.cureRange = game.xml.xml.Order.Units.monk.cure.range;
            this.loadXML(game.xml.xml.Order.Units.monk.cure);
         }
      }
      
      override public function isToggled(entity:Entity) : Boolean
      {
         return Monk(entity).isCureToggled;
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
         return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(this.cureRange,2);
      }
   }
}
