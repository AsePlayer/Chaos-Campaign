package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.Bitmap;
     import flash.display.Sprite;
     
     public class BomberDetonateCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new DetonateBitmap());
           
          
          public function BomberDetonateCommand(game:StickWar)
          {
               super();
               type = UnitCommand.BOMBER_DETONATE;
               _hasCoolDown = true;
               _intendedEntityType = Unit.U_BOMBER;
               requiresMouseInput = false;
               isSingleSpell = false;
               buttonBitmap = actualButtonBitmap;
               if(game != null)
               {
                    this.loadXML(game.xml.xml.Chaos.Units.bomber.detonate);
               }
          }
          
          override public function drawCursorPreClick(canvas:Sprite, gameScreen:GameScreen) : Boolean
          {
               return true;
          }
          
          override public function drawCursorPostClick(canvas:Sprite, game:GameScreen) : Boolean
          {
               return true;
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
