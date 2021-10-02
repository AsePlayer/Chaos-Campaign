package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   
   public class RangedUnit extends Unit
   {
       
      
      protected var bowAngle:Number;
      
      private var _projectileVelocity:Number;
      
      protected var _maximumRange:Number;
      
      protected var aimXOffset:Number;
      
      protected var aimYOffset:Number;
      
      protected var takeBottomTrajectory:Boolean;
      
      public function RangedUnit(game:StickWar)
      {
         super(game);
         this._projectileVelocity = 15;
         this.bowAngle = 0;
         this._maximumRange = 600;
         this.aimXOffset = 0;
         this.aimYOffset = 0;
         this.takeBottomTrajectory = true;
      }
      
      public function aimedAtUnit(target:Unit, angleToTarget:Number) : Boolean
      {
         if(target == null)
         {
            return false;
         }
         if(Util.sgn(target.x - x) != Util.sgn(this.mc.scaleX))
         {
            return false;
         }
         if(angleToTarget == -1.35)
         {
            return false;
         }
         return this.normalise(Math.abs((this.bowAngle - this.angleToBowSpace(angleToTarget)) % 360)) < 0.5;
      }
      
      override public function update(game:StickWar) : void
      {
         if(_mc.mc != null)
         {
            if(_mc.mc.bow != null)
            {
               _mc.mc.bow.rotation = this.bowAngle;
            }
            else if(_mc.mc.body != null && _mc.mc.body.arms)
            {
               _mc.mc.body.arms.rotation = this.bowAngle;
            }
         }
      }
      
      protected function angleToBowSpace(angle:Number) : Number
      {
         return -angle * 180 / Math.PI;
      }
      
      public function aim(target:Unit) : void
      {
         var a:Number = this.angleToTarget(target);
         if(target != null && this._state == Unit.S_ATTACK && !this.inRange(target))
         {
            return;
         }
         if(Math.abs(this.normalise(this.angleToBowSpace(a) - this.bowAngle)) < 10)
         {
            this.bowAngle += this.normalise(this.angleToBowSpace(a) - this.bowAngle) * 0.8;
         }
         else
         {
            this.bowAngle += this.normalise(this.angleToBowSpace(a) - this.bowAngle) * 0.1;
         }
      }
      
      protected function normalise(angle:Number) : Number
      {
         var a:Number = angle % 360;
         if(a < 0)
         {
            a += 360;
         }
         if(a > 180)
         {
            a -= 360;
         }
         return a;
      }
      
      public function inRange(target:Unit) : Boolean
      {
         if(target == null)
         {
            return false;
         }
         var v:Number = this._projectileVelocity;
         var g:Number = StickWar.GRAVITY;
         var d:Number = Math.sqrt((target.px - this.px) * (target.px - this.px));
         d += this.aimXOffset * Util.sgn(mc.scaleX);
         var x:Number = d;
         var hDiff:Number = 0;
         var zDiff:Number = -(target.pz - pz) + hDiff + this.aimYOffset;
         if(this._maximumRange < Math.abs(target.px - px))
         {
            return false;
         }
         var t:Number = Math.pow(v,4) - g * (g * x * x + 2 * zDiff * v * v);
         if(t <= 0)
         {
            return false;
         }
         return true;
      }
      
      public function isLoaded() : Boolean
      {
         return true;
      }
      
      override public function mayAttack(target:Unit) : Boolean
      {
         var CASTLE_WIDTH:int = 200;
         if(team.direction * px < team.direction * (this.team.homeX + team.direction * CASTLE_WIDTH))
         {
            return false;
         }
         if(isIncapacitated())
         {
            return false;
         }
         if(target == null)
         {
            return false;
         }
         if(this.isDualing == true)
         {
            return false;
         }
         if(this.aimedAtUnit(target,this.angleToTarget(target)) && this.inRange(target))
         {
            return true;
         }
         return false;
      }
      
      override public function canAttackAir() : Boolean
      {
         return true;
      }
      
      public function shoot(game:StickWar, target:Unit) : void
      {
      }
      
      public function angleToTarget(target:Unit) : Number
      {
         if(target == null)
         {
            return -1.2;
         }
         var v:Number = this._projectileVelocity;
         var g:Number = StickWar.GRAVITY;
         var d:Number = Math.sqrt((target.px - this.px) * (target.px - this.px));
         var x:Number = d - this.aimXOffset * Util.sgn(mc.scaleX);
         var hDiff:Number = 0;
         if(target.mc != null)
         {
            hDiff = target.pheight - this.pheight;
         }
         hDiff = 0;
         var zDiff:Number = -(target.pz - pz) + hDiff + this.aimYOffset;
         var t:Number = Math.pow(v,4) - g * (g * x * x + 2 * zDiff * v * v);
         if(t <= 0 || x > this._maximumRange)
         {
            return -1.35;
         }
         var angle:* = Math.atan2(v * v - Math.sqrt(t),g * x);
         if(!this.takeBottomTrajectory && d > 800)
         {
            angle = Math.atan2(v * v + Math.sqrt(t),g * x);
         }
         return angle;
      }
      
      public function angleToTargetW(target:Unit, v:Number, theta:Number) : Number
      {
         if(target == null)
         {
            return 0;
         }
         v = this._projectileVelocity;
         var _loc4_:Number = StickWar.GRAVITY;
         var _loc5_:Number = Math.sqrt((target.px - this.px) * (target.px - this.px));
         _loc5_ += this.aimXOffset * Util.sgn(mc.scaleX);
         var _loc6_:Number = target.pheight - this.pheight;
         _loc6_ = 0;
         var _loc7_:Number = -(target.pz - pz) + _loc6_ + this.aimYOffset;
         theta = -Math.PI / 180 * this.angleToBowSpace(theta);
         var _loc8_:Number = v * v * Util.sin(theta) * Util.sin(theta) + 2 * _loc4_ * -_loc7_;
         if(_loc8_ < 0)
         {
            _loc8_ = 0;
         }
         var _loc9_:Number = (v * Util.sin(theta) + Math.sqrt(_loc8_)) / _loc4_;
         if(Math.abs(_loc9_) < 0.001)
         {
            return (target.py - py) / 5;
         }
         return (target.py - py) / _loc9_;
      }
      
      public function get projectileVelocity() : Number
      {
         return this._projectileVelocity;
      }
      
      public function set projectileVelocity(value:Number) : void
      {
         this._projectileVelocity = value;
      }
   }
}
