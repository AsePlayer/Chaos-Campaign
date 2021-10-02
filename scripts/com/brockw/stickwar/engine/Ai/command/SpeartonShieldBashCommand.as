package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Spearton;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class SpeartonShieldBashCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new shieldHitBitmap());
       
      
      public function SpeartonShieldBashCommand(game:StickWar)
      {
         super();
         type = UnitCommand.SHIELD_BASH;
         hotKey = 87;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_SPEARTON;
         buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Order.Units.spearton.shieldBash);
         }
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Spearton(entity).shieldBashCooldown();
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
   }
}
