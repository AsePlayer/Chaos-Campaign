package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.multiplayer.moves.*;
     import com.brockw.stickwar.engine.units.*;
     import flash.display.*;
     
     public class PoisonPoolCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new poisonPoolBitmap());
           
          
          private var poisonPoolArea:Number;
          
          private var poisonPoolRange:Number;
          
          public function PoisonPoolCommand(game:StickWar)
          {
               super();
               type = UnitCommand.POISON_POOL;
               hotKey = 87;
               _hasCoolDown = true;
               _intendedEntityType = Unit.U_MEDUSA;
               requiresMouseInput = false;
               isSingleSpell = true;
               buttonBitmap = actualButtonBitmap;
               cursor = new nukeCursor();
               if(game != null)
               {
                    this.loadXML(game.xml.xml.Chaos.Units.medusa.poison);
                    this.poisonPoolArea = game.xml.xml.Chaos.Units.medusa.poison.area;
                    this.poisonPoolRange = game.xml.xml.Chaos.Units.medusa.poison.range;
               }
          }
          
          override public function drawCursorPreClick(canvas:Sprite, gameScreen:GameScreen) : Boolean
          {
               while(canvas.numChildren != 0)
               {
                    canvas.removeChildAt(0);
               }
               canvas.addChild(cursor);
               cursor.x = gameScreen.game.battlefield.mouseX;
               cursor.y = gameScreen.game.battlefield.mouseY;
               cursor.width = this.poisonPoolArea;
               cursor.height = 0.7 * this.poisonPoolArea * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
               if(cursor.y + cursor.height < 0)
               {
                    cursor.alpha = 1 - Math.abs(cursor.y) / 200;
               }
               else
               {
                    cursor.alpha = 1;
               }
               cursor.gotoAndStop(1);
               return true;
          }
          
          override public function drawCursorPostClick(canvas:Sprite, game:GameScreen) : Boolean
          {
               super.drawCursorPostClick(canvas,game);
               return true;
          }
          
          override public function coolDownTime(entity:Entity) : Number
          {
               return Medusa(entity).poisonPoolCooldown();
          }
          
          override public function isFinished(unit:Unit) : Boolean
          {
               return Medusa(unit).poisonPoolCooldown() == 0;
          }
          
          override public function inRange(entity:Entity) : Boolean
          {
               return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(this.poisonPoolRange,2);
          }
     }
}
