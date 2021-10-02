package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Ninja;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class StealthCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new NinjaCloak());
       
      
      public function StealthCommand(game:StickWar)
      {
         super();
         type = UnitCommand.STEALTH;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_NINJA;
         buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Order.Units.ninja.stealth);
         }
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Ninja(entity).stealthCooldown();
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
   }
}
