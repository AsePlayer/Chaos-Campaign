package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class StoneCommand extends DartCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new medusaStoneBitmap());
       
      
      private var range:Number;
      
      public function StoneCommand(game:StickWar)
      {
         super(game);
         this.game = game;
         type = UnitCommand.STONE;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_MEDUSA;
         requiresMouseInput = true;
         isSingleSpell = true;
         this.buttonBitmap = actualButtonBitmap;
         cursor = new petrifyCursor();
         if(game != null)
         {
            this.loadXML(game.xml.xml.Chaos.Units.medusa.stone);
            this.range = game.xml.xml.Chaos.Units.medusa.stone.range;
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
         this.drawRangeIndicators(canvas,this.range,true,gameScreen);
         return true;
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Medusa(entity).stoneCooldown();
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return Medusa(unit).stoneCooldown() != 0 || this.targetId == -1;
      }
      
      override public function inRange(entity:Entity) : Boolean
      {
         var u:Unit = null;
         if(game.teamA.gold < 50)
         {
            game.gameScreen.userInterface.helpMessage.showMessage("Not enough gold to cast");
            return false;
         }
         if(targetId in game.units && game.units[targetId] is Unit)
         {
            u = game.units[targetId];
            return Math.pow(u.px - entity.px,2) + Math.pow(u.py - entity.py,2) < Math.pow(Unit(entity).team.game.xml.xml.Chaos.Units.medusa.stone.range,2);
         }
         return false;
      }
   }
}
