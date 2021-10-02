package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Magikill;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PoisonDartCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new MagikillSummon());
       
      
      private var poisonRange:Number;
      
      private var poisonArea:Number;
      
      public function PoisonDartCommand(game:StickWar)
      {
         super();
         this.game = game;
         type = UnitCommand.POISON_DART;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_MAGIKILL;
         requiresMouseInput = true;
         isSingleSpell = true;
         this.buttonBitmap = actualButtonBitmap;
         cursor = new nukeCursor();
         if(game != null)
         {
            this.loadXML(game.xml.xml.Order.Units.magikill.poisonSpray);
            this.poisonRange = game.xml.xml.Order.Units.magikill.poisonSpray.range;
            this.poisonArea = game.xml.xml.Order.Units.magikill.poisonSpray.area;
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
         cursor.width = this.poisonRange / 2;
         cursor.height = this.poisonArea * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
         if(cursor.y + cursor.height < 0)
         {
            cursor.alpha = 1 - Math.abs(cursor.y) / 200;
         }
         else
         {
            cursor.alpha = 1;
         }
         cursor.gotoAndStop(1);
         this.drawRangeIndicators(canvas,this.poisonRange,true,gameScreen);
         return true;
      }
      
      override public function drawCursorPostClick(canvas:Sprite, game:GameScreen) : Boolean
      {
         super.drawCursorPostClick(canvas,game);
         return true;
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Magikill(entity).poisonDartCooldown();
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return Magikill(unit).poisonDartCooldown() != 0;
      }
      
      override public function inRange(entity:Entity) : Boolean
      {
         return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(this.poisonRange,2);
      }
   }
}
