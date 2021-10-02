package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class HoldCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandHold());
       
      
      public function HoldCommand(game:StickWar)
      {
         super();
         type = UnitCommand.HOLD;
         hotKey = 72;
         buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Commands.hold);
         }
      }
      
      override public function playSound(game:StickWar) : void
      {
         game.soundManager.playSoundFullVolume("CommandHoldSound");
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
   }
}
