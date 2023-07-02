package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class ArcherFireCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new ArchidonFire());
       
      
      public function ArcherFireCommand(game:StickWar)
      {
         super();
         type = UnitCommand.ARCHER_FIRE;
         hotKey = 87;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_ARCHER;
         buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Order.Units.archer.fire);
         }
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Archer(entity).getFireCoolDown();
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
   }
}
