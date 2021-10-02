package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class UnGarrisonCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandExit());
       
      
      public function UnGarrisonCommand(game:StickWar)
      {
         super();
         type = UnitCommand.UNGARRISON;
         hotKey = 71;
         buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Commands.ungarrison);
         }
      }
      
      override public function playSound(game:StickWar) : void
      {
         game.soundManager.playSoundFullVolume("GarrisonExit");
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return true;
      }
   }
}
