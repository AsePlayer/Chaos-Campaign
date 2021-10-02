package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class AttackMoveCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandAttackMove());
       
      
      private var _distanceToGoal:Number;
      
      private var troubleDistanceToGoal:Number;
      
      private var isHavingTrouble:Boolean;
      
      private var havingTroubleTime:int;
      
      public function AttackMoveCommand(game:StickWar)
      {
         super();
         type = UnitCommand.ATTACK_MOVE;
         this.havingTroubleTime = 0;
         this.isHavingTrouble = false;
         hotKey = 65;
         requiresMouseInput = true;
         buttonBitmap = actualButtonBitmap;
         if(game.team.type == Team.T_CHAOS)
         {
            cursor = new chaosAttackMoveMc();
         }
         else if(game.team.type == Team.T_GOOD)
         {
            cursor = new orderAttackMoveMc();
         }
         if(game != null)
         {
            this.loadXML(game.xml.xml.Commands.attackMove);
         }
      }
      
      override public function playSound(game:StickWar) : void
      {
         game.soundManager.playSoundFullVolumeRandom("CommandMove",3);
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
         cursor.scaleX = 1.3 * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
         cursor.scaleY = 1.3 * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
         return true;
      }
      
      override public function drawCursorPostClick(canvas:Sprite, gameScreen:GameScreen) : Boolean
      {
         var nCursor:Cursor = null;
         gameScreen.game.postCursors.push(nCursor = new Cursor());
         canvas.addChild(nCursor);
         nCursor.x = gameScreen.game.battlefield.mouseX;
         nCursor.y = gameScreen.game.battlefield.mouseY;
         var posX:Number = gameScreen.userInterface.hud.hud.map.mouseX / gameScreen.userInterface.hud.hud.map.width;
         var posY:Number = gameScreen.userInterface.hud.hud.map.mouseY / gameScreen.userInterface.hud.hud.map.height;
         var p:Point = gameScreen.userInterface.hud.hud.map.globalToLocal(new Point(gameScreen.userInterface.mouseState.mouseDownX,gameScreen.userInterface.mouseState.mouseDownY));
         var dposX:Number = p.x / gameScreen.userInterface.hud.hud.map.width;
         var dposY:Number = p.y / gameScreen.userInterface.hud.hud.map.height;
         if(posX >= 0 && posX <= 1 && posY >= 0 && posY <= 1 && dposX >= 0 && dposX <= 1 && dposY >= 0 && dposY <= 1)
         {
            nCursor.x = posX * gameScreen.game.map.width;
            nCursor.y = posY * gameScreen.game.map.height;
         }
         return true;
      }
      
      public function init() : void
      {
         this._distanceToGoal = 0;
      }
      
      override public function cleanUpPreClick(canvas:Sprite) : void
      {
         if(canvas.contains(cursor))
         {
            canvas.removeChild(cursor);
         }
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         ++this.havingTroubleTime;
         this._distanceToGoal = Math.sqrt(Math.pow(unit.x - goalX,2) + Math.pow(unit.y - goalY,2));
         if(this.isHavingTrouble == false && this.havingTroubleTime > 30 * 3)
         {
            this.isHavingTrouble = true;
            this.troubleDistanceToGoal = this._distanceToGoal;
            ++this.havingTroubleTime;
            return false;
         }
         this.havingTroubleTime %= 10;
         if(this.havingTroubleTime == 0)
         {
            this.troubleDistanceToGoal = this._distanceToGoal;
         }
         return Math.abs(goalX - unit.x) < 5 && Math.abs(goalY - unit.y) < 5;
      }
   }
}
