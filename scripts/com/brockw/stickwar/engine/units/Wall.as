package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.WallAi;
   import com.brockw.stickwar.engine.Ai.command.StandCommand;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.HealthBar;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class Wall extends Unit
   {
       
      
      public var wallParts:Array;
      
      private var isConstructed:Boolean = false;
      
      private var healthLost:Number;
      
      public function Wall(game:StickWar, team:Team)
      {
         var n:wallSpike = null;
         var e:Unit = null;
         super(game);
         this.wallParts = [];
         for(var i:int = 0; i < 5; i++)
         {
            n = new wallSpike();
            e = new Unit(game);
            e.addChild(n);
            e.x = e.px = 0;
            e.y = e.py = i * game.map.height / 5;
            e.scaleX = team.direction * game.getPerspectiveScale(e.y);
            e.scaleY = game.getPerspectiveScale(e.y);
            e.pz = 0;
            e.team = team;
            this.wallParts.push(e);
         }
         this.team = team;
         ai = new WallAi(this);
         ai.setCommand(game,new StandCommand(game));
         _maxHealth = health = game.xml.xml.Order.Units.wall.health;
         healthBar = new HealthBar();
         healthBar.totalHealth = _health;
         healthBar.x = -team.direction * 10;
         healthBar.y = -100;
         healthBar.scaleX *= 1.3;
         healthBar.scaleY *= 1.2;
         pwidth = 15;
         pheight = 250;
         addChild(healthBar);
         pz = 0;
         mc = new MovieClip();
         this.isConstructed = false;
         this.setConstructionAmount(0);
         hitBoxWidth = 150;
         this.type = Unit.U_WALL;
         _interactsWith = Unit.I_IS_BUILDING;
         flyingHeight = 0;
         this.healthLost = 0;
      }
      
      override public function poison(p:Number) : void
      {
      }
      
      override public function getDirection() : int
      {
         return Util.sgn(1);
      }
      
      public function setConstructionAmount(fraction:Number) : void
      {
         var w:Unit = null;
         var mc:wallSpike = null;
         if(fraction >= 0 && fraction <= 1)
         {
            _health = fraction * _maxHealth - this.healthLost;
            healthBar.reset();
            if(fraction >= 1)
            {
               this.isConstructed = true;
            }
            else
            {
               this.isConstructed = false;
            }
            for each(w in this.wallParts)
            {
               mc = wallSpike(w.getChildAt(0));
               mc.gotoAndStop(Math.floor(mc.totalFrames * fraction));
            }
         }
      }
      
      override public function update(game:StickWar) : void
      {
         healthBar.health = health;
         healthBar.update();
         if(isDead == false && isDieing)
         {
            team.removeWall(this);
         }
         ai.update(game);
      }
      
      override public function damage(type:int, amount:int, inflictor:Entity, modifier:Number = 1) : void
      {
         var healthBefore:* = _health;
         super.damage(type,amount,inflictor);
         var healthAfter:* = _health;
         this.healthLost += healthBefore - healthAfter;
      }
      
      override public function checkForHitPoint(p:Point, target:Unit) : Boolean
      {
         return this.checkForHitPoint2(p);
      }
      
      public function checkForHitPoint2(p:Point) : Boolean
      {
         p = this.globalToLocal(p);
         if(p.x > -100 && p.x < 100 && p.y > -300 && p.y < 300)
         {
            return true;
         }
         return false;
      }
      
      public function checkForHitPoint3(p:Point) : Boolean
      {
         p = this.globalToLocal(p);
         if(p.x > -50 && p.x < 50 && p.y > -200 && p.y < 300)
         {
            return true;
         }
         return false;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         a.clear();
         a.setAction(0,0,UnitCommand.REMOVE_WALL_COMMAND);
      }
      
      public function setLocation(x:Number) : void
      {
         var e:Entity = null;
         var i:int = 0;
         for each(e in this.wallParts)
         {
            e.x = e.px = x - i * 5 * team.direction;
            i++;
         }
         this.x = px = x;
         this.y = py = team.game.map.height / 2;
      }
      
      public function addToScene(canvas:Sprite) : void
      {
         var e:Entity = null;
         canvas.addChild(this);
         for each(e in this.wallParts)
         {
            if(!canvas.contains(e))
            {
               canvas.addChild(e);
            }
         }
      }
      
      public function removeFromScene(canvas:Sprite) : void
      {
         var e:Entity = null;
         if(canvas.contains(this))
         {
            canvas.removeChild(this);
            for each(e in this.wallParts)
            {
               if(canvas.contains(e))
               {
                  canvas.removeChild(e);
               }
            }
         }
      }
   }
}
