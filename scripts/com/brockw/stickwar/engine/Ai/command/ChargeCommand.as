package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.multiplayer.moves.*;
     import com.brockw.stickwar.engine.units.*;
     import flash.display.*;
     
     public class ChargeCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new knightChargeBitmap());
           
          
          public function ChargeCommand(game:StickWar)
          {
               super();
               type = UnitCommand.KNIGHT_CHARGE;
               hotKey = 81;
               _hasCoolDown = true;
               _intendedEntityType = Unit.U_KNIGHT;
               requiresMouseInput = false;
               isSingleSpell = false;
               this.buttonBitmap = actualButtonBitmap;
               cursor = new nukeCursor();
               if(game != null)
               {
                    this.loadXML(game.xml.xml.Chaos.Units.knight.charge);
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
               cursor.width = gameScreen.game.xml.xml.Order.Units.magikill.poisonRange / 2;
               cursor.height = gameScreen.game.xml.xml.Order.Units.magikill.poisonArea * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
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
               return Knight(entity).getChargeCooldown();
          }
          
          override public function isFinished(entity:Unit) : Boolean
          {
               return Knight(entity).getChargeCooldown() != 0;
          }
          
          override public function inRange(entity:Entity) : Boolean
          {
               return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(Unit(entity).team.game.xml.xml.Chaos.Units.knight.chargeRange,2);
          }
     }
}
