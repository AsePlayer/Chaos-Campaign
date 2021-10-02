package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class DirectedProjectile extends Projectile
   {
       
      
      protected var targetUnit:Unit;
      
      private var _team:Team;
      
      private var _damageToDeal:Number;
      
      private var _stunTime:int;
      
      protected var timeOfFlight:int;
      
      protected var t:int;
      
      protected var _startX:Number;
      
      protected var _startY:Number;
      
      protected var _startZ:Number;
      
      protected var _inFlight:Boolean;
      
      public function DirectedProjectile(game:StickWar)
      {
         super();
         this._inFlight = true;
         framesDead = 0;
         this.t = 0;
      }
      
      public function init(startX:Number, startY:Number, startZ:Number, target:Unit, damage:Number, team:Team) : void
      {
         x = px = this._startX = startX;
         y = py = this._startY = startY;
         this._startZ = startZ;
         this._team = team;
         this._inFlight = true;
         this.t = 0;
         framesDead = 0;
         this._stunTime = 0;
         this._damageToDeal = damage;
         this.slowFrames = 0;
         this.poisonDamage = 0;
         this.timeOfFlight = 20;
         this.targetUnit = target;
         this.scaleX = team.game.backScale + py / team.game.map.height * (team.game.frontScale - team.game.backScale);
         this.scaleY = team.game.backScale + py / team.game.map.height * (team.game.frontScale - team.game.backScale);
         var targetScale:int = Util.sgn(target.px - startX);
         if(targetScale != Util.sgn(this.scaleX))
         {
            scaleX *= -1;
         }
      }
      
      override public function update(game:StickWar) : void
      {
         var dy:Number = NaN;
         if(!this.targetUnit.isAlive())
         {
            this.visible = false;
            this._inFlight = false;
            return;
         }
         this.scaleX = game.backScale + py / game.map.height * (game.frontScale - game.backScale);
         this.scaleY = game.backScale + py / game.map.height * (game.frontScale - game.backScale);
         var nx:Number = this.targetUnit.px;
         var ny:Number = this.targetUnit.py - this.targetUnit.pheight / 2;
         var nz:Number = this.targetUnit.pz;
         var d:Number = Math.sqrt(Math.pow(nx - px,2) + Math.pow(ny - py,2) + Math.pow(nz - pz,2));
         var dx:Number = (nx - px) / d * 25;
         dy = (ny - py) / d * 25;
         var dz:Number = (nz - pz) / d * 25;
         this.visible = true;
         px += dx;
         py += dy;
         pz += dz;
         this.x = px;
         this.y = pz + py;
         if(pz > 0 && dz > 0)
         {
            dz = dx = dy = 0;
         }
         else
         {
            rotation = 90 - Math.atan2(dx,dz + dy) * 180 / Math.PI;
         }
         if(d < this.targetUnit.width / 2)
         {
            this.targetUnit.poison(this.poisonDamage);
            this.targetUnit.damage(0,this.damageToDeal,null);
            this.targetUnit.stun(this.stunTime);
            this.targetUnit.slow(this.slowFrames);
            this._inFlight = false;
            visible = false;
         }
      }
      
      override public function isInFlight() : Boolean
      {
         return this._inFlight;
      }
      
      public function get startX() : Number
      {
         return this._startX;
      }
      
      public function set startX(value:Number) : void
      {
         this._startX = value;
      }
      
      public function get startY() : Number
      {
         return this._startY;
      }
      
      public function set startY(value:Number) : void
      {
         this._startY = value;
      }
      
      public function get startZ() : Number
      {
         return this._startZ;
      }
      
      public function set startZ(value:Number) : void
      {
         this._startZ = value;
      }
   }
}
