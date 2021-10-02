package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.ChaosTowerAi;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ChaosTower extends RangedUnit
   {
       
      
      private var _isCastleArcher:Boolean;
      
      private var isPoison:Boolean;
      
      private var isFire:Boolean;
      
      private var arrowDamage:Number;
      
      private var bowFrame:int;
      
      private var target:Unit;
      
      private var _isPoisonedToggled:Boolean;
      
      private var lastShotCounter:int;
      
      private var shotRate:int;
      
      private var isConstructed:Boolean = false;
      
      public function ChaosTower(game:StickWar)
      {
         super(game);
         _mc = new chaosTowerMc();
         this.init(game);
         addChild(_mc);
         ai = new ChaosTowerAi(this);
         initSync();
         firstInit();
         pwidth = this.width;
         pheight = this.height;
         this.isConstructed = false;
      }
      
      override public function poison(p:Number) : void
      {
      }
      
      override public function init(game:StickWar) : void
      {
         initBase();
         this.lastShotCounter = 99999;
         this.shotRate = game.xml.xml.Chaos.Units.tower.shotRate;
         _maximumRange = game.xml.xml.Chaos.Units.tower.maximumRange;
         population = game.xml.xml.Chaos.Units.tower.population;
         maxHealth = health = game.xml.xml.Chaos.Units.tower.health;
         this.createTime = game.xml.xml.Chaos.Units.tower.cooldown;
         this.projectileVelocity = game.xml.xml.Chaos.Units.tower.arrowVelocity;
         this.arrowDamage = game.xml.xml.Chaos.Units.tower.damage;
         _mass = game.xml.xml.Chaos.Units.tower.mass;
         _maxForce = game.xml.xml.Chaos.Units.tower.maxForce;
         _dragForce = game.xml.xml.Chaos.Units.tower.dragForce;
         _scale = game.xml.xml.Chaos.Units.tower.scale;
         _maxVelocity = game.xml.xml.Chaos.Units.tower.maxVelocity;
         loadDamage(game.xml.xml.Chaos.Units.tower);
         type = Unit.U_CHAOS_TOWER;
         if(this.isCastleArcher)
         {
            this._maximumRange = game.xml.xml.Chaos.Units.tower.castleRange;
         }
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _hitBoxWidth = 25;
         _state = S_RUN;
         isStationary = true;
         this.healthBar.y = -190;
         _interactsWith = Unit.I_IS_BUILDING;
         isDead = false;
         isDieing = false;
      }
      
      override public function faceDirection(dir:int) : void
      {
      }
      
      public function setConstructionAmount(fraction:Number) : void
      {
         _health = fraction * _maxHealth;
         healthBar.reset();
         if(fraction >= 1)
         {
            this.isConstructed = true;
         }
         else
         {
            this.isConstructed = false;
         }
         if(!this.isConstructed)
         {
            _mc.mc.gotoAndStop(Math.floor(_mc.mc.totalFrames * fraction));
         }
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["ArcheryBuilding"];
      }
      
      public function set isCastleArcher(value:Boolean) : void
      {
         this._isCastleArcher = value;
      }
      
      override public function update(game:StickWar) : void
      {
         super.update(game);
         ++this.lastShotCounter;
         updateCommon(game);
         if(!isDieing)
         {
            updateMotion(game);
            if(!this.isConstructed)
            {
               _mc.gotoAndStop("build");
            }
            else
            {
               _mc.gotoAndStop("attack");
            }
         }
         else if(isDead == false)
         {
            isDead = true;
            _mc.gotoAndStop(getDeathLabel(game));
            this.team.removeUnit(this,game);
            game.projectileManager.initNuke(px,py,this,0);
         }
         if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
         {
            MovieClip(_mc.mc).gotoAndStop(1);
         }
         if(this.lastShotCounter < 15)
         {
            Util.animateMovieClip(_mc.mc,0);
         }
         if(isDead)
         {
            _mc.gotoAndStop(getDeathLabel(game));
            _mc.alpha = 0;
         }
         else
         {
            _mc.alpha = 1;
         }
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         a.clear();
         a.setAction(0,0,UnitCommand.REMOVE_TOWER_COMMAND);
      }
      
      override public function aim(target:Unit) : void
      {
         var a:Number = angleToTarget(target);
         if(Math.abs(normalise(angleToBowSpace(a) - bowAngle)) < 10)
         {
            bowAngle += normalise(angleToBowSpace(a) - bowAngle) * 1;
         }
         else
         {
            bowAngle += normalise(angleToBowSpace(a) - bowAngle) * 1;
         }
      }
      
      override public function aimedAtUnit(target:Unit, angleToTarget:Number) : Boolean
      {
         if(target == null)
         {
            return false;
         }
         if(angleToTarget == -1.35)
         {
            return false;
         }
         return normalise(Math.abs((bowAngle - angleToBowSpace(angleToTarget)) % 360)) < 0.5;
      }
      
      override public function shoot(game:StickWar, target:Unit) : void
      {
         var p:Point = null;
         if(this.lastShotCounter > this.shotRate && this.isConstructed)
         {
            mc.gotoAndStop("attack");
            this.target = target;
            p = mc.mc.localToGlobal(new Point(0,0));
            p = game.battlefield.globalToLocal(p);
            hasHit = false;
            if(mc.scaleX < 0)
            {
            }
            if(!(target.type == Unit.U_BOMBER && target.bomberType == "Intro"))
            {
               game.projectileManager.initTowerDart(p.x,p.y,0,this,target);
            }
            this.lastShotCounter = 0;
         }
      }
      
      public function get isCastleArcher() : Boolean
      {
         return this._isCastleArcher;
      }
   }
}
