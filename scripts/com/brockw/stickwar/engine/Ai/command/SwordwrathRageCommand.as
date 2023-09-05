package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.*;
     import flash.display.Bitmap;
     
     public class SwordwrathRageCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new SwordwrathSacrifice());
           
          
          public function SwordwrathRageCommand(game:StickWar)
          {
               super();
               type = UnitCommand.SWORDWRATH_RAGE;
               hotKey = 81;
               _hasCoolDown = true;
               _intendedEntityType = Unit.U_SWORDWRATH;
               buttonBitmap = actualButtonBitmap;
               if(game != null)
               {
                    this.loadXML(game.xml.xml.Order.Units.swordwrath.rage);
               }
          }
          
          override public function coolDownTime(entity:Entity) : Number
          {
               return Swordwrath(entity).rageCooldown();
          }
          
          override public function isFinished(unit:Unit) : Boolean
          {
               return false;
          }
     }
}
