package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.Ore;
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class Statue extends Unit implements Ore
   {
       
      
      private var miners:Vector.<Miner>;
      
      private var lights:Sprite;
      
      private var MAX_WORSHIP:int;
      
      private var numMiners:int;
      
      private var beamMiners:Array;
      
      private var prayRate:int;
      
      private var statueHealth:int;
      
      public function Statue(mc:MovieClip, game:StickWar, statueHealth:int)
      {
         super(game);
         this.statueHealth = statueHealth;
         _mc = mc;
         this.init(game);
         addChild(_mc);
         _mc.cacheAsBitmap = true;
         ai = null;
         initSync();
         this.miners = new Vector.<Miner>(game.xml.xml.maxWorshipers);
         for(var i:int = 0; i < this.miners.length; i++)
         {
            this.miners[i] = null;
         }
         this.lights = new Sprite();
         this.addChild(this.lights);
         this.MAX_WORSHIP = game.xml.xml.maxWorshipers;
         this.numMiners = 0;
         this.beamMiners = [];
         this.prayRate = game.xml.xml.Order.Units.miner.manaMineRate;
         id = game.getNextUnitId();
         pwidth = mc.width / 2;
         pheight = 175;
         this.mayWalkThrough = true;
         flyingHeight = 0;
      }
      
      override public function checkForHitPoint(p:Point, target:Unit) : Boolean
      {
         if(target == null)
         {
            return false;
         }
         var dir:int = Util.sgn(target.px - px);
         p = this.globalToLocal(p);
         if(p.x > -pwidth && p.x < width && p.y > -pheight && p.y < 0)
         {
            return true;
         }
         return false;
      }
      
      override public function update(game:StickWar) : void
      {
         healthBar.health = health;
         healthBar.update();
         this.lights.graphics.clear();
         for(var i:int = 0; i < this.beamMiners.length; i++)
         {
            if(this.beamMiners[i] != null)
            {
               this.drawHolyLight(game,this.beamMiners[i]);
            }
         }
      }
      
      public function isMineFull() : Boolean
      {
         return this.numMiners == this.miners.length;
      }
      
      override public function damage(type:int, amount:int, inflictor:Entity, modifier:Number = 1) : void
      {
         var dmg:Number = NaN;
         if(isTargetable())
         {
            dmg = 0;
            if(inflictor != null)
            {
               dmg = !!this.isArmoured ? Number(inflictor.damageToArmour) : Number(inflictor.damageToNotArmour);
            }
            else
            {
               dmg = amount;
            }
            _health -= dmg;
            team.game.soundManager.playSoundRandom("StatueHit",5,px,py);
            if(_health <= 0)
            {
               isDieing = true;
               _health = 0;
               if(shadowSprite != null && mc.contains(shadowSprite))
               {
                  mc.removeChild(shadowSprite);
               }
               shadowSprite = null;
               healthBar.health = 0;
               healthBar.update();
            }
         }
      }
      
      override public function drawOnHud(canvas:MovieClip, game:StickWar) : void
      {
         var x:Number = canvas.width * px / game.map.width;
         var y:Number = canvas.height * py / game.map.height;
         if(selected)
         {
            MovieClip(canvas).graphics.lineStyle(2,65280,1);
         }
         else
         {
            MovieClip(canvas).graphics.lineStyle(2,6710886,1);
         }
         MovieClip(canvas).graphics.beginFill(6710886,1);
         MovieClip(canvas).graphics.drawRect(x - 2,y - 2,4,4);
         MovieClip(canvas).graphics.endFill();
      }
      
      public function mine(lvl:int, unit:Miner) : Number
      {
         unit.team.mana += this.prayRate;
         return 0;
      }
      
      public function drawHolyLight(game:StickWar, unit:Unit) : void
      {
         var p:Point = new Point(0,0);
         p = unit.localToGlobal(p);
         p = this.globalToLocal(p);
      }
      
      override public function init(game:StickWar) : void
      {
         initBase();
         this._health = maxHealth = this.statueHealth;
         _mass = 50;
         _maxForce = 30;
         _dragForce = 0.89;
         _scale = 0.8;
         _maxVelocity = 5;
         type = Unit.U_STATUE;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _hitBoxWidth = 25;
         this.numMiners = 0;
         var otherHeight:Number = mc.height;
         healthBar.totalHealth = _health;
         mc.addChild(healthBar);
         healthBar.scaleX *= 3.5;
         healthBar.scaleY *= 2.5;
         healthBar.y = -otherHeight * 1;
      }
      
      public function inMineRange(unit:Miner) : Boolean
      {
         return Math.abs(x - unit.team.direction * 50 - unit.x) < 150;
      }
      
      public function getMiningSpot(unit:Miner) : Number
      {
         for(var i:int = 0; i < this.miners.length; i++)
         {
            if(this.miners[i] == unit)
            {
               return (this.MAX_WORSHIP - i) * 20 - 50;
            }
         }
         return 0;
      }
      
      public function reserveMiningSpot(unit:Miner) : Boolean
      {
         for(var i:int = 0; i < this.miners.length; i++)
         {
            if(this.miners[i] == null)
            {
               this.miners[i] = unit;
               ++this.numMiners;
               return true;
            }
         }
         return false;
      }
      
      public function hasMiningSpot(unit:Miner) : Boolean
      {
         for(var i:int = 0; i < this.miners.length; i++)
         {
            if(this.miners[i] == unit)
            {
               return true;
            }
         }
         return false;
      }
      
      public function releaseMiningSpot(unit:Miner) : void
      {
         for(var i:int = 0; i < this.miners.length; i++)
         {
            if(this.miners[i] == unit)
            {
               this.miners[i] = null;
               --this.numMiners;
               this.stopMining(unit);
               return;
            }
         }
      }
      
      override public function poison(p:Number) : void
      {
      }
      
      public function startMining(unit:Miner) : void
      {
         if(this.beamMiners.indexOf(unit) == -1)
         {
            this.beamMiners.push(unit);
         }
      }
      
      public function stopMining(unit:Miner) : void
      {
         this.beamMiners.splice(this.beamMiners.indexOf(unit),1);
      }
      
      public function mayMine(unit:Miner) : Boolean
      {
         if(unit.isBagFull())
         {
            return false;
         }
         if(Math.abs(x - unit.team.direction * 50 - unit.x) < 30 && Math.abs(y - unit.y + this.getMiningSpot(unit)) < 20 && unit.getDirection() == Util.sgn(x - unit.x))
         {
            return true;
         }
         return false;
      }
      
      override public function stun(s:int) : void
      {
      }
      
      public function hitTest(x:int, y:int) : Boolean
      {
         if(x > this.x - this.width / 2 && x < this.x + this.width / 2 && y > this.y - this.height && y < this.y + 100)
         {
            return true;
         }
         return false;
      }
      
      public function miningRate(lvl:int) : Number
      {
         return lvl;
      }
   }
}
