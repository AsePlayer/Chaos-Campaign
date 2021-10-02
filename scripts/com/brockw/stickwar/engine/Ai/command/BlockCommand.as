package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Spearton;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class BlockCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new SpeartanShieldWall());
       
      
      public function BlockCommand(game:StickWar)
      {
         super();
         type = UnitCommand.SPEARTON_BLOCK;
         hotKey = 81;
         _hasCoolDown = false;
         _intendedEntityType = Unit.U_SPEARTON;
         requiresMouseInput = false;
         isSingleSpell = false;
         isToggle = true;
         buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Order.Units.spearton.shieldWall);
         }
      }
      
      override public function isToggled(entity:Entity) : Boolean
      {
         return Spearton(entity).isBlocking;
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
