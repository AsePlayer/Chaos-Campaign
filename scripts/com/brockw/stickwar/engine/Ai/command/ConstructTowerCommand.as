package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Team;
     import com.brockw.stickwar.engine.multiplayer.moves.*;
     import com.brockw.stickwar.engine.units.*;
     import flash.display.*;
     import flash.geom.ColorTransform;
     
     public class ConstructTowerCommand extends UnitCommand
     {
          
          public static const actualButtonBitmap:Bitmap = new Bitmap(new ChaosTowerBitmap());
          
          public static const chaosTower:chaosTowerMc = new chaosTowerMc();
           
          
          private var constructRange:Number;
          
          private var scale:Number;
          
          public function ConstructTowerCommand(game:StickWar)
          {
               super();
               type = UnitCommand.CONSTRUCT_TOWER;
               hotKey = 81;
               _hasCoolDown = true;
               _intendedEntityType = Unit.U_CHAOS_MINER;
               requiresMouseInput = true;
               isSingleSpell = true;
               buttonBitmap = actualButtonBitmap;
               chaosTower.gotoAndStop("attack");
               cursor = chaosTower;
               if(game != null)
               {
                    this.scale = game.xml.xml.Chaos.Units.tower.scale;
                    this.loadXML(game.xml.xml.Chaos.Units.miner.tower);
                    this.constructRange = game.xml.xml.Chaos.Units.miner.tower.constructRange;
               }
          }
          
          override public function mayCast(gameScreen:GameScreen, team:Team) : Boolean
          {
               var mouseX:Number = gameScreen.game.battlefield.mouseX;
               if(team.direction * mouseX < team.direction * (team.statue.px + team.direction * 1.3 * team.statue.width))
               {
                    return false;
               }
               if(team.direction * mouseX > team.direction * (team.enemyTeam.statue.px + team.direction * 1.3 * team.enemyTeam.statue.width))
               {
                    return false;
               }
               if(team.direction * mouseX > team.direction * (team.game.map.width / 2 - 400 * team.direction))
               {
                    return false;
               }
               return true;
          }
          
          override public function unableToCastMessage() : String
          {
               return "Unable to construct in this region.";
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
               var c:ColorTransform = cursor.transform.colorTransform;
               if(!this.mayCast(gameScreen,gameScreen.team))
               {
                    c.redOffset = 50;
                    cursor.alpha = 0.8;
               }
               else
               {
                    c.redOffset = 0;
                    cursor.alpha = 1;
               }
               cursor.transform.colorTransform = c;
               canvas.addChild(cursor);
               cursor.x = gameScreen.game.battlefield.mouseX;
               cursor.y = gameScreen.game.battlefield.mouseY;
               var _perspectiveScale:Number = this.scale * (gameScreen.game.backScale + cursor.y / gameScreen.game.map.height * (gameScreen.game.frontScale - gameScreen.game.backScale));
               cursor.scaleX = -gameScreen.team.direction * _perspectiveScale;
               cursor.scaleY = _perspectiveScale;
               return true;
          }
          
          override public function drawCursorPostClick(canvas:Sprite, game:GameScreen) : Boolean
          {
               super.drawCursorPostClick(canvas,game);
               return true;
          }
          
          override public function coolDownTime(entity:Entity) : Number
          {
               return MinerChaos(entity).constructCooldown();
          }
          
          override public function isFinished(unit:Unit) : Boolean
          {
               return false;
          }
          
          override public function inRange(entity:Entity) : Boolean
          {
               return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(this.constructRange,2);
          }
     }
}
