package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.multiplayer.moves.*;
     import com.brockw.stickwar.engine.units.*;
     import flash.display.*;
     
     public class ReaperCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new mageReaperBitmap());
           
          
          private var range:Number;
          
          public function ReaperCommand(game:StickWar)
          {
               super();
               this.game = game;
               type = UnitCommand.REAPER;
               hotKey = 87;
               _hasCoolDown = true;
               _intendedEntityType = Unit.U_SKELATOR;
               requiresMouseInput = true;
               isSingleSpell = true;
               this.buttonBitmap = actualButtonBitmap;
               cursor = new reaperEffectMc();
               if(game != null)
               {
                    this.range = game.xml.xml.Chaos.Units.skelator.reaper.range;
                    this.loadXML(game.xml.xml.Chaos.Units.skelator.reaper);
               }
          }
          
          override public function cleanUpPreClick(canvas:Sprite) : void
          {
               super.cleanUpPreClick(canvas);
               if(canvas.contains(cursor))
               {
                    canvas.removeChild(cursor);
               }
          }
          
          override public function drawCursorPreClick(canvas:Sprite, gameScreen:GameScreen) : Boolean
          {
               if(canvas.contains(cursor))
               {
                    canvas.removeChild(cursor);
               }
               canvas.addChild(cursor);
               cursor.x = gameScreen.game.battlefield.mouseX;
               cursor.y = gameScreen.game.battlefield.mouseY;
               cursor.scaleX = 1 * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
               cursor.scaleY = 1 * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
               return true;
          }
          
          override public function drawCursorPostClick(canvas:Sprite, game:GameScreen) : Boolean
          {
               super.drawCursorPostClick(canvas,game);
               return true;
          }
          
          override public function coolDownTime(entity:Entity) : Number
          {
               return Skelator(entity).reaperCooldown();
          }
          
          override public function isFinished(unit:Unit) : Boolean
          {
               return Skelator(unit).reaperCooldown() != 0 || this.targetId == -1;
          }
          
          override public function inRange(entity:Entity) : Boolean
          {
               var u:Unit = null;
               if(targetId in game.units && game.units[targetId] is Unit)
               {
                    u = game.units[targetId];
                    return Math.pow(u.px - entity.px,2) + Math.pow(u.py - entity.py,2) < Math.pow(this.range,2);
               }
               return false;
          }
     }
}
