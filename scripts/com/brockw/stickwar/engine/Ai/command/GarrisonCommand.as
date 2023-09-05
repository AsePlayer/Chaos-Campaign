package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.Bitmap;
     
     public class GarrisonCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandGarrison());
           
          
          public function GarrisonCommand(game:StickWar)
          {
               super();
               type = UnitCommand.GARRISON;
               hotKey = 71;
               buttonBitmap = actualButtonBitmap;
               if(game != null)
               {
                    this.loadXML(game.xml.xml.Commands.garrison);
               }
          }
          
          override public function playSound(game:StickWar) : void
          {
               game.soundManager.playSoundFullVolume("GarrisonEnter");
          }
          
          override public function isFinished(unit:Unit) : Boolean
          {
               return true;
          }
     }
}
