package com.brockw.stickwar.engine.projectile
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.Ai.*;
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Team;
     import com.brockw.stickwar.engine.units.Unit;
     import com.brockw.stickwar.engine.units.Wall;
     import flash.geom.Point;
     
     public class Projectile extends Entity
     {
          
          public static const ARROW:int = 1;
          
          public static const BOLT:int = 2;
          
          public static const GUTS:int = 3;
          
          public static const HEAL:int = 4;
          
          public static const CURE:int = 5;
          
          public static const NUKE:int = 6;
          
          public static const ELECTRIC_WALL:int = 7;
          
          public static const POISON_DART:int = 8;
          
          public static const SLOW_DART:int = 9;
          
          public static const BOULDER:int = 10;
          
          public static const POISON_SPRAY:int = 11;
          
          public static const FIST_ATTACK:int = 12;
          
          public static const REAPER:int = 13;
          
          public static const POISON_POOL:int = 14;
          
          public static const TOWER_DART:int = 15;
          
          public static const WALL_EXPLOSION:int = 16;
          
          public static const TOWER_SPAWN:int = 17;
          
          public static const SPAWN_DRIP:int = 18;
          
          public static const HEAL_EFFECT:int = 19;
           
          
          protected var _scale:Number;
          
          protected var _dx:Number;
          
          protected var _dy:Number;
          
          protected var _dz:Number;
          
          protected var _targetY:Number;
          
          private var _team:Team;
          
          private var _damageToDeal:Number;
          
          private var _stunTime:int;
          
          private var _poisonDamage:int;
          
          private var _slowFrames:int;
          
          public var framesDead:int;
          
          protected var _drotation:Number;
          
          protected var _rot:Number;
          
          private var _isDebris:Boolean;
          
          protected var _inflictor:Unit;
          
          protected var p1:Point;
          
          protected var p2:Point;
          
          protected var p3:Point;
          
          protected var hasHit:Boolean;
          
          private var _unitNotToHit:Unit;
          
          protected var lastDistanceToCentre:int;
          
          public var isFire:Boolean;
          
          public var isExplode:Boolean;
          
          private var _area:Number;
          
          private var _areaDamage:Number;
          
          protected var hasArrowDeath:Boolean;
          
          public var isPierce:Boolean = false;
          
          public function Projectile()
          {
               super();
               this.dx = this.dy = this.dz = 0;
               px = py = pz = 0;
               this.damageToDeal = 5;
               this.framesDead = 0;
               this._stunTime = 0;
               this.area = 0;
               this.areaDamage = 0;
               this._scale = 1;
               this.isDebris = false;
               this.unitNotToHit = null;
               this.isFire = false;
               this.hasArrowDeath = false;
          }
          
          override public function cleanUp() : void
          {
               this._team = null;
          }
          
          public function initProjectile() : void
          {
               this.hasHit = false;
               this.unitNotToHit = null;
          }
          
          public function update(game:StickWar) : void
          {
               var effects:Array = null;
               var effect:Array = null;
               var dir:int = 0;
               var w:Wall = null;
               var cDistance:Number = NaN;
               var direction:Number = NaN;
               var type:int = 0;
               this.visible = true;
               this.scaleX = this._scale * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               this.scaleY = this._scale * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               this.x = px;
               this.y = pz + py;
               if(py < 0)
               {
                    visible = false;
               }
               if(this.isPierce)
               {
                    this.area = 100;
                    this.areaDamage = 5;
               }
               effects = game.projectileManager.airEffects;
               px += this.dx;
               py += this.dy;
               pz += this.dz;
               this.dz += StickWar.GRAVITY;
               for each(effect in effects)
               {
                    if(Math.abs(effect[0] - px) < 100)
                    {
                         dir = Util.sgn(effect[2]);
                         if(Util.sgn(this.dx) != dir && effect[3] != this.team)
                         {
                              this.dx += effect[2];
                         }
                    }
               }
               if(this.isDebris)
               {
                    return;
               }
               this.p1 = this.localToGlobal(new Point(0,0));
               this.p2 = this.localToGlobal(new Point(-30,0));
               this.p3 = this.localToGlobal(new Point(30,0));
               if(!this.hasHit)
               {
                    game.spatialHash.mapInArea(px - 50,py - 50,px + 50,py + 50,this.arrowHit);
                    for each(w in this.team.enemyTeam.walls)
                    {
                         this.arrowHit(w);
                    }
               }
               else if(this.unitNotToHit != null)
               {
                    cDistance = Math.abs(x - this.unitNotToHit.px);
                    if(!Unit(this.unitNotToHit).checkForHitPoint(this.p3,Unit(this.unitNotToHit)) || cDistance > this.lastDistanceToCentre)
                    {
                         if(this.isExplode)
                         {
                              this.team.game.projectileManager.initNuke(this.unitNotToHit.px,this.unitNotToHit.py,this._inflictor,10);
                              this.team.game.soundManager.playSoundRandom("mediumExplosion",3,px,py);
                              this.isExplode = false;
                         }
                         direction = Util.sgn(this.dx);
                         this.visible = false;
                         this.dz = this.dx = this.dy = 0;
                         if(this.unitNotToHit is Unit)
                         {
                              Unit(this.unitNotToHit).stun(this.stunTime);
                              Unit(this.unitNotToHit).poison(this.poisonDamage);
                              Unit(this.unitNotToHit).slow(this.slowFrames);
                         }
                         if(this is Boulder)
                         {
                              Unit(this.unitNotToHit).applyVelocity(2 * Util.sgn(direction));
                         }
                         type = 0;
                         type |= Unit.D_ARROW * (this.hasArrowDeath ? 1 : 0);
                         type |= Unit.D_FIRE * (this.isFire ? 1 : 0);
                         Entity(this.unitNotToHit.damage(type,this.damageToDeal,this._inflictor));
                         if(this.area != 0)
                         {
                              game.spatialHash.mapInArea(px - this.area,py - this.area,px + this.area,py + this.area,this.projectileArea);
                         }
                    }
                    this.lastDistanceToCentre = cDistance;
               }
               if(pz > 0 && this.dz > 0 && !this.hasHit)
               {
                    this.dz = this.dx = this.dy = 0;
                    if(!this.hasHit)
                    {
                         this.hasHit = true;
                         if(this.area != 0)
                         {
                              game.spatialHash.mapInArea(px - this.area,py - this.area,px + this.area,py + this.area,this.projectileArea);
                         }
                    }
               }
               else
               {
                    rotation = 90 - Math.atan2(this.dx,this.dz + this.dy) * 180 / Math.PI;
               }
          }
          
          private function projectileArea(u:Unit) : void
          {
               if(Unit(u).team != this.team)
               {
                    if(Math.pow(px - u.x,2) + Math.pow(py - u.y,2) < this.area * this.area)
                    {
                         u.damage(0,this.areaDamage,null);
                    }
               }
          }
          
          protected function arrowHit(u:Unit) : void
          {
               if(this.hasHit)
               {
                    return;
               }
               if(this.isDebris && u == this.unitNotToHit)
               {
                    return;
               }
               if(Unit(u).team != this.team)
               {
                    if(Unit(u).checkForHitPointArrow(this.p1,py,Unit(u)) || Unit(u).checkForHitPointArrow(this.p2,py,Unit(u)) || Unit(u).checkForHitPointArrow(this.p3,py,Unit(u)))
                    {
                         this.unitNotToHit = u;
                         this.hasHit = true;
                         this.lastDistanceToCentre = Math.abs(x - u.px);
                    }
               }
          }
          
          public function isReadyForCleanup() : Boolean
          {
               return this.framesDead > 400;
          }
          
          public function isInFlight() : Boolean
          {
               return this.dx != 0 || this.dy != 0 || this.dz != 0;
          }
          
          public function get dx() : Number
          {
               return this._dx;
          }
          
          public function set dx(value:Number) : void
          {
               this._dx = value;
          }
          
          public function get dy() : Number
          {
               return this._dy;
          }
          
          public function set dy(value:Number) : void
          {
               this._dy = value;
          }
          
          public function get targetY() : Number
          {
               return this._targetY;
          }
          
          public function set targetY(value:Number) : void
          {
               this._targetY = value;
          }
          
          public function get dz() : Number
          {
               return this._dz;
          }
          
          public function set dz(value:Number) : void
          {
               this._dz = value;
          }
          
          public function get team() : Team
          {
               return this._team;
          }
          
          public function set team(value:Team) : void
          {
               this._team = value;
          }
          
          public function get damageToDeal() : Number
          {
               return this._damageToDeal;
          }
          
          public function set damageToDeal(value:Number) : void
          {
               this._damageToDeal = value;
          }
          
          public function get stunTime() : int
          {
               return this._stunTime;
          }
          
          public function set stunTime(value:int) : void
          {
               this._stunTime = value;
          }
          
          public function get poisonDamage() : int
          {
               return this._poisonDamage;
          }
          
          public function set poisonDamage(value:int) : void
          {
               this._poisonDamage = value;
          }
          
          public function get slowFrames() : int
          {
               return this._slowFrames;
          }
          
          public function set slowFrames(value:int) : void
          {
               this._slowFrames = value;
          }
          
          public function get drotation() : Number
          {
               return this._drotation;
          }
          
          public function set drotation(value:Number) : void
          {
               this._drotation = value;
          }
          
          public function get rot() : Number
          {
               return this._rot;
          }
          
          public function set rot(value:Number) : void
          {
               this._rot = value;
          }
          
          public function get isDebris() : Boolean
          {
               return this._isDebris;
          }
          
          public function set isDebris(value:Boolean) : void
          {
               this._isDebris = value;
          }
          
          public function get scale() : Number
          {
               return this._scale;
          }
          
          public function set scale(value:Number) : void
          {
               this._scale = value;
          }
          
          public function get inflictor() : Unit
          {
               return this._inflictor;
          }
          
          public function set inflictor(value:Unit) : void
          {
               this._inflictor = value;
          }
          
          public function get unitNotToHit() : Unit
          {
               return this._unitNotToHit;
          }
          
          public function set unitNotToHit(value:Unit) : void
          {
               this._unitNotToHit = value;
          }
          
          public function get area() : Number
          {
               return this._area;
          }
          
          public function set area(value:Number) : void
          {
               this._area = value;
          }
          
          public function get areaDamage() : Number
          {
               return this._areaDamage;
          }
          
          public function set areaDamage(value:Number) : void
          {
               this._areaDamage = value;
          }
     }
}
