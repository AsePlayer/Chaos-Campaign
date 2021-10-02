package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Miner;
   import com.brockw.stickwar.engine.units.Unit;
   import com.brockw.stickwar.engine.units.Wall;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.ui.Mouse;
   
   public class ConstructWallCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new OrderTowerBitmap());
       
      
      private var constructRange:Number;
      
      private var wall:Wall;
      
      public function ConstructWallCommand(game:StickWar)
      {
         super();
         type = UnitCommand.CONSTRUCT_WALL;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_MINER;
         requiresMouseInput = true;
         isSingleSpell = true;
         buttonBitmap = actualButtonBitmap;
         cursor = new nukeCursor();
         if(game != null)
         {
            this.wall = new Wall(game,game.team);
            this.loadXML(game.xml.xml.Order.Units.miner.wall);
            this.constructRange = game.xml.xml.Order.Units.miner.wall.constructRange;
         }
      }
      
      override public function cleanUpPreClick(canvas:Sprite) : void
      {
         this.wall.removeFromScene(canvas);
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
      
      override public function drawCursorPreClick(canvas:Sprite, gameScreen:GameScreen) : Boolean
      {
         var u:Unit = null;
         var c:ColorTransform = null;
         this.wall.removeFromScene(canvas);
         this.wall.setLocation(gameScreen.game.battlefield.mouseX);
         this.wall.setConstructionAmount(1);
         this.wall.healthBar.visible = false;
         this.wall.addToScene(canvas);
         Mouse.show();
         for each(u in this.wall.wallParts)
         {
            c = u.transform.colorTransform;
            if(!this.mayCast(gameScreen,gameScreen.team))
            {
               c.redOffset = 50;
               u.alpha = 0.8;
            }
            else
            {
               c.redOffset = 0;
               u.alpha = 1;
            }
            u.transform.colorTransform = c;
         }
         return true;
      }
      
      override public function drawCursorPostClick(canvas:Sprite, game:GameScreen) : Boolean
      {
         super.drawCursorPostClick(canvas,game);
         return true;
      }
      
      override public function coolDownTime(entity:Entity) : Number
      {
         return Miner(entity).constructCooldown();
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
