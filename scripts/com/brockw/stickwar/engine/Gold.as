package com.brockw.stickwar.engine
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.units.Miner;
   import flash.display.*;
   
   public class Gold extends com.brockw.stickwar.engine.Entity implements Ore
   {
      
      private static const scale:Number = 0.4;
       
      
      private var amount:Number;
      
      public var ore:com.brockw.stickwar.engine.Entity;
      
      public var frontOre:com.brockw.stickwar.engine.Entity;
      
      private var _total:Number;
      
      private var miners:Vector.<Miner>;
      
      private var numMiners:int;
      
      internal var gold:_ore;
      
      public function Gold(game:StickWar)
      {
         this.ore = new com.brockw.stickwar.engine.Entity();
         this.ore.addChild(this.gold = new _ore());
         this.frontOre = new com.brockw.stickwar.engine.Entity();
         this.frontOre.addChild(new _oreFront());
         this.miners = new Vector.<Miner>(2);
         for(var i:int = 0; i < this.miners.length; i++)
         {
            this.miners[i] = null;
         }
         this.numMiners = 0;
         _type = 0;
         super();
      }
      
      public function init(x:int, y:int, amount:Number, game:StickWar) : void
      {
         this.x = x;
         this.y = y;
         this.px = x;
         this.py = y;
         this.ore.x = x;
         this.ore.y = y - 3;
         this.ore.px = this.ore.x;
         this.ore.py = this.ore.y;
         this.frontOre.x = x;
         this.frontOre.y = y + 3;
         this.frontOre.px = this.frontOre.x;
         this.frontOre.py = this.frontOre.y;
         this._total = this.amount = amount;
         var mapHeight:Number = Number(game.xml.xml.battlefieldHeight);
         this.ore.scaleX = scale * (game.backScale + y / mapHeight * (game.frontScale - game.backScale));
         this.ore.scaleY = scale * (game.backScale + y / mapHeight * (game.frontScale - game.backScale));
         this.frontOre.scaleX = scale * (game.backScale + y / mapHeight * (game.frontScale - game.backScale));
         this.frontOre.scaleY = scale * (game.backScale + y / mapHeight * (game.frontScale - game.backScale));
         id = game.getNextUnitId();
         if(Boolean(this.gold.glow))
         {
            this.gold.glow.gotoAndStop(1);
         }
         this.gold.gotoAndStop(1);
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
         MovieClip(canvas).graphics.drawRect(x,y,1,1);
      }
      
      public function update(game:StickWar) : void
      {
      }
      
      public function inMineRange(unit:Miner) : Boolean
      {
         return true;
      }
      
      public function mine(lvl:int, unit:Miner) : Number
      {
         var m:int = 0;
         if(this.amount - this.miningRate(lvl) < 0)
         {
            m = this.amount;
            this.amount = 0;
         }
         else
         {
            m = this.miningRate(lvl);
            this.amount -= m;
         }
         this.ore.scaleX = this.amount / this._total * scale * (unit.team.game.backScale + y / unit.team.game.map.height * (unit.team.game.frontScale - unit.team.game.backScale));
         this.ore.scaleY = this.amount / this._total * scale * (unit.team.game.backScale + y / unit.team.game.map.height * (unit.team.game.frontScale - unit.team.game.backScale));
         return m;
      }
      
      public function getMiningSpot(unit:Miner) : Number
      {
         for(var i:int = 0; i < this.miners.length; i++)
         {
            if(this.miners[i] == unit)
            {
               return unit.team.direction * (2 * i - 1) * 50;
            }
         }
         return 0;
      }
      
      public function reserveMiningSpot(unit:Miner) : Boolean
      {
         if(this.amount <= 0)
         {
            return false;
         }
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
         if(this.amount <= 0)
         {
            return false;
         }
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
      
      public function isMineFull() : Boolean
      {
         if(this.amount <= 0)
         {
            return true;
         }
         return this.numMiners == this.miners.length;
      }
      
      public function startMining(unit:Miner) : void
      {
      }
      
      public function stopMining(unit:Miner) : void
      {
      }
      
      public function isBeingMined(unit:Miner) : Boolean
      {
         if(this.amount <= 0)
         {
            return false;
         }
         return this.numMiners < 2;
      }
      
      public function mayStartMining(unit:Miner) : Boolean
      {
         if(this.amount <= 0)
         {
            return false;
         }
         return !this.isBeingMined(unit);
      }
      
      public function mayMine(unit:Miner) : Boolean
      {
         if(this.amount <= 0)
         {
            return false;
         }
         if(unit.isBagFull())
         {
            return false;
         }
         if(Math.abs(x + this.getMiningSpot(unit) - unit.x) < 30 && Math.abs(y - unit.y) < 20 && unit.getDirection() == Util.sgn(x - unit.x))
         {
            return true;
         }
         return false;
      }
      
      public function hitTest(x:int, y:int) : Boolean
      {
         if(x > this.x - this.ore.width / 2 && x < this.x + this.ore.width / 2 && y > this.y - this.ore.width && y < this.y)
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
