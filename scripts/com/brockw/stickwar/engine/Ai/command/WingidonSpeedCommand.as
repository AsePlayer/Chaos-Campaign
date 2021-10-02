package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import com.brockw.stickwar.engine.units.Wingidon;
   import flash.display.Bitmap;
   
   public class WingidonSpeedCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new SwordwrathSacrifice());
       
      
      public function WingidonSpeedCommand(game:StickWar)
      {
         super();
         type = UnitCommand.WINGIDON_SPEED;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_WINGIDON;
         buttonBitmap = actualButtonBitmap;
         isSingleSpell = false;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Chaos.Units.wingidon.wingidonSpeed);
         }
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Wingidon(entity).speedSpellCooldown();
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
   }
}
