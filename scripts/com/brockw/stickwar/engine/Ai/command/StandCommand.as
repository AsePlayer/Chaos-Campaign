package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.Bitmap;
     
     public class StandCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandStop());
           
          
          public function StandCommand(game:StickWar)
          {
               super();
               type = UnitCommand.STAND;
               hotKey = 83;
               buttonBitmap = actualButtonBitmap;
               if(game != null)
               {
                    this.loadXML(game.xml.xml.Commands.stand);
               }
          }
          
          override public function playSound(game:StickWar) : void
          {
               game.soundManager.playSoundFullVolume("CommandStopSound");
          }
          
          override public function isFinished(unit:Unit) : Boolean
          {
               if(unit.ai.commandQueue.isEmpty())
               {
                    return false;
               }
               return true;
          }
     }
}
