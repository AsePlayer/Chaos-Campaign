package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Gold;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Statue;
   import com.brockw.stickwar.engine.units.Unit;
   import fl.motion.Color;
   import flash.display.*;
   import flash.geom.Point;
   import flash.ui.Mouse;
   
   public class MoveCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandMove());
      
      public static const mineClip:MovieClip = new pickaxeAnimation();
      
      public static const prayClip:MovieClip = new prayCursor();
      
      public static const attackClipOrder:MovieClip = new orderAttackMoveMc();
      
      public static const attackClipChaos:MovieClip = new chaosAttackMoveMc();
       
      
      private var _distanceToGoal:Number;
      
      private var troubleDistanceToGoal:Number;
      
      private var isHavingTrouble:Boolean;
      
      private var havingTroubleTime:int;
      
      private var attackClip:MovieClip;
      
      public function MoveCommand(game:StickWar)
      {
         super();
         type = UnitCommand.MOVE;
         this.havingTroubleTime = 0;
         this.isHavingTrouble = false;
         hotKey = 68;
         requiresMouseInput = true;
         buttonBitmap = actualButtonBitmap;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Commands.move);
         }
         if(game.team.type == Team.T_CHAOS)
         {
            this.attackClip = new chaosAttackMoveMc();
         }
         else if(game.team.type == Team.T_GOOD)
         {
            this.attackClip = new orderAttackMoveMc();
         }
         var cTint:Color = new Color();
         cTint.setTint(16711680,0.4);
         this.attackClip.transform.colorTransform = cTint;
         this.attackClip.scaleX *= 0.25;
         this.attackClip.scaleY *= 0.25;
      }
      
      override public function playSound(game:StickWar) : void
      {
         if(targetId in game.units)
         {
            if(game.units[targetId] is Gold && Boolean(game.gameScreen.userInterface.selectedUnits.interactsWith & Unit.I_MINE))
            {
               game.soundManager.playSoundFullVolume("ClickGold");
            }
            else if(game.units[targetId] is Statue && Boolean(game.gameScreen.userInterface.selectedUnits.interactsWith & Unit.I_STATUE))
            {
               game.soundManager.playSoundFullVolume("ClickMana");
            }
            else
            {
               game.soundManager.playSoundFullVolumeRandom("CommandMove",6);
            }
         }
         else
         {
            game.soundManager.playSoundFullVolumeRandom("CommandMove",6);
         }
      }
      
      public function init() : void
      {
         this._distanceToGoal = 0;
      }
      
      private function checkIfUnitUnderCursor(unit:Unit) : void
      {
         if(unit.hitTestPoint(unit.team.game.stage.mouseX,unit.team.game.stage.mouseY,false))
         {
            unit.team.register = 1;
         }
      }
      
      override public function cleanUpPreClick(canvas:Sprite) : void
      {
         if(canvas.contains(cursor))
         {
            canvas.removeChild(cursor);
         }
         if(canvas.contains(this.attackClip))
         {
            canvas.removeChild(this.attackClip);
         }
         if(canvas.contains(mineClip))
         {
            canvas.removeChild(mineClip);
         }
         if(canvas.contains(prayClip))
         {
            canvas.removeChild(prayClip);
         }
      }
      
      override public function drawCursorPreClick(canvas:Sprite, gameScreen:GameScreen) : Boolean
      {
         if(canvas.contains(cursor))
         {
            canvas.removeChild(cursor);
         }
         if(canvas.contains(this.attackClip))
         {
            canvas.removeChild(this.attackClip);
         }
         if(canvas.contains(mineClip))
         {
            canvas.removeChild(mineClip);
         }
         if(canvas.contains(prayClip))
         {
            canvas.removeChild(prayClip);
         }
         Mouse.show();
         var cursor2:MovieClip = null;
         var interactsWith:* = gameScreen.userInterface.selectedUnits.interactsWith;
         if(Boolean(interactsWith & (Unit.I_MINE | Unit.I_STATUE)) && gameScreen.game.mouseOverUnit is Statue)
         {
            cursor2 = prayClip;
            Mouse.hide();
         }
         else if(Boolean(interactsWith & (Unit.I_MINE | Unit.I_STATUE)) && gameScreen.game.mouseOverUnit is Gold)
         {
            cursor2 = mineClip;
            Mouse.hide();
         }
         else if(Boolean(interactsWith & Unit.I_ENEMY))
         {
            if(gameScreen.game.mouseOverUnit is Unit && Unit(gameScreen.game.mouseOverUnit).team != gameScreen.team)
            {
               cursor2 = this.attackClip;
               Mouse.hide();
            }
         }
         if(Boolean(cursor2))
         {
            canvas.addChild(cursor2);
            cursor2.x = gameScreen.game.battlefield.mouseX;
            cursor2.y = gameScreen.game.battlefield.mouseY;
            cursor2.scaleX = 1.3 * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
            cursor2.scaleY = 1.3 * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
         }
         if(canvas.contains(prayClip))
         {
            if(prayClip.currentFrame == prayClip.totalFrames)
            {
               prayClip.gotoAndStop(1);
            }
            else
            {
               prayClip.nextFrame();
            }
            cursor2.scaleX *= 1.5;
            cursor2.scaleY *= 1.5;
         }
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
         if(canvas.contains(cursor))
         {
            cursor.nextFrame();
            if(cursor.currentFrame == cursor.totalFrames)
            {
               canvas.removeChild(cursor);
               return true;
            }
            return false;
         }
         if(canvas.contains(mineClip))
         {
            mineClip.nextFrame();
            if(mineClip.currentFrame == mineClip.totalFrames)
            {
               canvas.removeChild(mineClip);
               return true;
            }
            return false;
         }
         if(canvas.contains(prayClip))
         {
            prayClip.nextFrame();
            if(prayClip.currentFrame == prayClip.totalFrames)
            {
               canvas.removeChild(prayClip);
               return true;
            }
            return false;
         }
         if(canvas.contains(this.attackClip))
         {
            this.attackClip.nextFrame();
            if(this.attackClip.currentFrame == this.attackClip.totalFrames)
            {
               canvas.removeChild(this.attackClip);
               return true;
            }
            return false;
         }
         return true;
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         ++this.havingTroubleTime;
         this._distanceToGoal = Math.sqrt(Math.pow(unit.px - goalX,2) + Math.pow(unit.py - goalY,2));
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
         return Math.abs(goalX - unit.px) < 5 && Math.abs(goalY - unit.py) < 5;
      }
   }
}
