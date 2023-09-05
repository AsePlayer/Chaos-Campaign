package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.multiplayer.moves.*;
     import com.brockw.stickwar.engine.units.*;
     import flash.display.*;
     
     public class FistAttackCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new skeletalFistBitmap());
           
          
          private var range:Number;
          
          private var area:Number;
          
          public function FistAttackCommand(game:StickWar)
          {
               super();
               type = UnitCommand.FIST_ATTACK;
               hotKey = 81;
               _hasCoolDown = true;
               _intendedEntityType = Unit.U_SKELATOR;
               requiresMouseInput = true;
               isSingleSpell = true;
               this.buttonBitmap = actualButtonBitmap;
               cursor = new nukeCursor();
               if(game != null)
               {
                    this.game = game;
                    this.loadXML(game.xml.xml.Chaos.Units.skelator.fist);
                    this.range = game.xml.xml.Chaos.Units.skelator.fist.range;
                    this.area = game.xml.xml.Chaos.Units.skelator.fist.area;
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
               while(canvas.numChildren != 0)
               {
                    canvas.removeChildAt(0);
               }
               canvas.addChild(cursor);
               cursor.x = gameScreen.game.battlefield.mouseX;
               cursor.y = gameScreen.game.battlefield.mouseY;
               cursor.width = this.range / 2;
               cursor.height = this.area * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
               if(cursor.y + cursor.height < 0)
               {
                    cursor.alpha = 1 - Math.abs(cursor.y) / 200;
               }
               else
               {
                    cursor.alpha = 1;
               }
               cursor.gotoAndStop(1);
               this.drawRangeIndicators(canvas,this.range,true,gameScreen);
               return true;
          }
          
          override public function drawCursorPostClick(canvas:Sprite, game:GameScreen) : Boolean
          {
               super.drawCursorPostClick(canvas,game);
               return true;
          }
          
          override public function coolDownTime(entity:Entity) : Number
          {
               return Skelator(entity).fistAttackCooldown();
          }
          
          override public function isFinished(unit:Unit) : Boolean
          {
               return Skelator(unit).fistAttackCooldown() != 0;
          }
          
          override public function inRange(entity:Entity) : Boolean
          {
               return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(this.range,2);
          }
     }
}
