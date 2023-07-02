package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.UnitAi;
   import com.brockw.stickwar.engine.Ai.command.HoldCommand;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.HealthBar;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Building;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.dual.Dual;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class Unit extends Entity
   {
      
      public static const D_NONE = 0;
      
      public static const D_FIRE = 1;
      
      public static const D_NO_SOUND = 2;
      
      public static const D_NO_BLOOD = 4;
      
      public static const D_ARROW = 8;
      
      private static const COLLISION_DAMPNING:Number = 0.6;
      
      public static const U_MINER:int = 1;
      
      public static const U_MAGIKILL:int = 2;
      
      public static const U_MONK:int = 3;
      
      public static const U_ARCHER:int = 4;
      
      public static const U_FLYING_CROSSBOWMAN:int = 5;
      
      public static const U_NINJA:int = 6;
      
      public static const U_SWORDWRATH:int = 7;
      
      public static const U_SPEARTON:int = 8;
      
      public static const U_ENSLAVED_GIANT:int = 9;
      
      public static const U_STATUE:int = 1000;
      
      public static const U_DEAD:int = 10;
      
      public static const U_WINGIDON:int = 11;
      
      public static const U_DASHNITE:int = 12;
      
      public static const U_CHAOS_MINER:int = 13;
      
      public static const U_BOMBER:int = 14;
      
      public static const U_SKELATOR:int = 15;
      
      public static const U_CAT:int = 16;
      
      public static const U_KNIGHT:int = 17;
      
      public static const U_MEDUSA:int = 18;
      
      public static const U_GIANT:int = 19;
      
      public static const U_CHAOS_TOWER:int = 20;
      
      public static const U_WALL:int = 21;
      
      public static const B_ORDER_BANK:int = 100;
      
      public static const B_BARRACKS:int = 101;
      
      public static const B_ARCHERY_RANGE:int = 102;
      
      public static const B_SIEGE_WORKSHOP:int = 103;
      
      public static const B_MAGIC_SHOP:int = 104;
      
      public static const B_TEMPLE:int = 105;
      
      public static const B_CHAOS_BARRACKS:int = 106;
      
      public static const B_CHAOS_FLETCHER:int = 107;
      
      public static const B_CHAOS_UNDEAD:int = 108;
      
      public static const B_CHAOS_GIANT:int = 109;
      
      public static const B_CHAOS_MEDUSA:int = 110;
      
      public static const B_CHAOS_BANK:int = 111;
      
      protected static const S_RUN:int = 0;
      
      protected static const S_ATTACK:int = 1;
      
      protected static const S_DEATH:int = 2;
      
      protected static const S_MINE:int = 3;
      
      private static const stunUpForce:Number = 2;
      
      public static const I_MINE:int = 1;
      
      public static const I_STATUE:int = 1 << 2;
      
      public static const I_ENEMY:int = 1 << 3;
      
      public static const I_FRIENDS:int = 1 << 4;
      
      public static const I_IS_BUILDING:int = 1 << 5;
       
      
      private var nudgeFrame:int;
      
      protected var hasHit:Boolean;
      
      protected var _health:Number;
      
      protected var _armour:int;
      
      protected var _mass:int;
      
      protected var _maxForce:Number;
      
      protected var _dragForce:Number;
      
      protected var _maxVelocity:Number;
      
      protected var _scale:Number = 1;
      
      protected var _perspectiveScale:Number = 1;
      
      private var _population:int;
      
      protected const _worldScaleX:Number = 1;
      
      protected const _worldScaleY:Number = 0.8;
      
      protected var _dx:Number;
      
      protected var _dy:Number;
      
      protected var _dz:Number;
      
      protected var intendedWalkDirection:int;
      
      protected var _hitBoxWidth:int;
      
      protected var _hitBoxHeight:int;
      
      protected var _state:int;
      
      protected var _mc:MovieClip;
      
      protected var _ai:UnitAi;
      
      private var _team:Team;
      
      protected var _isDieing:Boolean;
      
      protected var _isDead:Boolean;
      
      private var _timeOfDeath:Number;
      
      protected var _syncAttackLabels:Dictionary;
      
      protected var _syncDefendLabels:Dictionary;
      
      protected var _attackLabels:Array;
      
      protected var _deathLabels:Array;
      
      protected var _currentDual:Dual;
      
      protected var _isDualing:Boolean;
      
      protected var _dualPartner:com.brockw.stickwar.engine.units.Unit;
      
      protected var _flyingHeight:Number;
      
      protected var _lastTurnCount:int;
      
      protected var TURN_AGILITY:int;
      
      private var _healthBar:HealthBar;
      
      private var _damageToDeal:Number;
      
      private var _mayWalkThrough:Boolean;
      
      protected var _createTime:int;
      
      protected var _stunTimeLeft:int;
      
      private var _building:Building;
      
      private var _isStationary:Boolean;
      
      private var _isGarrisoned:Boolean;
      
      public var _poisonDamage:Number;
      
      private var framesPoisoned:int;
      
      private var _randomInterval:int;
      
      private var _healAmount:Number;
      
      private var _healTimeRemaining:int;
      
      protected var _maxHealth:int;
      
      protected var slowFramesRemaining:int;
      
      private var _isBusyForSpell:Boolean;
      
      protected var _shadowSprite:MovieClip;
      
      protected var framesInAttack:int;
      
      protected var attackStartFrame:int;
      
      protected var _interactsWith:int;
      
      private var dzOffset:Number;
      
      private var _reaperCurseFrames:int;
      
      private var reaperCurseFramesTotal:int;
      
      private var reaperAmplification:Number;
      
      private var reaperInflictor:com.brockw.stickwar.engine.units.Unit;
      
      private var chaosHealRate:Number;
      
      private var _stoned:Boolean;
      
      private var isStoneable:Boolean;
      
      private var _isFirable:Boolean;
      
      private var chaosPoisonedFrames:int;
      
      private var _isOnFire:Boolean;
      
      public var isHome:Boolean;
      
      private var reaperMc:reaperEffectMc;
      
      private var poisonMc:poisonEffect;
      
      private var stunMc:dizzyMc;
      
      private var _isRejoiningFormation:Boolean;
      
      private var garrisonHealRate:Number;
      
      public var _isTowerSpawned:Boolean;
      
      private var godmodeGlow:GlowFilter;
      
      private var towerSpawnGlow:GlowFilter;
      
      private var lastHealthAnimation:int;
      
      private var _arrowDeath:Boolean;
      
      private var _hasDefaultLoadout:Boolean;
      
      private var _ddx:Number;
      
      private var _ddy:Number;
      
      private var lastWalkFrame:int;
      
      public var isMiniBoss:Boolean = false;
      
      public var isGodmoded:Boolean = false;
      
      public var isNormal:Boolean = true;
      
      public var specialTimeOver:Boolean = false;
      
      public var noAutoCure:Boolean = false;
      
      public function Unit(game:StickWar)
      {
         this.hasDefaultLoadout = false;
         this.isTowerSpawned = false;
         this._isRejoiningFormation = false;
         this.garrisonHealRate = Number(0);
         this.framesPoisoned = 0;
         this.TURN_AGILITY = 5;
         this._lastTurnCount = 0;
         this.healthBar = new HealthBar();
         this._building = null;
         this.lastHealthAnimation = 0;
         this.dzOffset = Number(0);
         this._createTime = 30;
         this._randomInterval = 90;
         this._interactsWith = I_ENEMY;
         this._healTimeRemaining = 0;
         this.reaperCurseFrames = 0;
         this.chaosPoisonedFrames = int(game.xml.xml.Chaos.poisonDuration);
         this.reaperCurseFramesTotal = int(game.xml.xml.Chaos.Units.skelator.reaper.frames);
         this.reaperAmplification = Number(game.xml.xml.Chaos.Units.skelator.reaper.amplification);
         this.chaosHealRate = Number(game.xml.xml.Chaos.healRate);
         this.garrisonHealRate = Number(game.xml.xml.garrisonHealRate);
         this.nudgeFrame = game.frame;
         var glowColor:Number = 65280;
         var glowAlpha:Number = 1;
         var glowBlurX:Number = 36;
         var glowBlurY:Number = 18;
         var glowStrength:Number = 2.64;
         var glowQuality:Number = BitmapFilterQuality.LOW;
         var glowInner:Boolean = false;
         var glowKnockout:Boolean = false;
         this.towerSpawnGlow = new GlowFilter(glowColor,glowAlpha,glowBlurX,glowBlurY,glowStrength,glowQuality,glowInner,glowKnockout);
         this.godmodeGlow = new GlowFilter(16777215,glowAlpha,glowBlurX,glowBlurY,glowStrength,glowQuality,glowInner,glowKnockout);
         this.attackStartFrame = 0;
         this.framesInAttack = 0;
         this.arrowDeath = false;
         this._ddx = this._ddy = Number(0);
         this.lastWalkFrame = 0;
         super();
      }
      
      public function weaponReach() : Number
      {
         return 0;
      }
      
      public function reaperCurse(inflictor:com.brockw.stickwar.engine.units.Unit) : void
      {
         this.stateFixForCutToWalk();
         if(this.reaperMc && this.mc.contains(this.reaperMc))
         {
            this.mc.removeChild(this.reaperMc);
         }
         this.reaperMc = new reaperEffectMc();
         this.mc.addChild(this.reaperMc);
         this.reaperMc.x = 0;
         this.reaperMc.y = this.healthBar.y - 10;
         this.reaperMc.scaleX = 0.8;
         this.reaperMc.scaleY = 0.8;
         this.reaperCurseFrames = this.reaperCurseFramesTotal;
         this.reaperInflictor = inflictor;
      }
      
      public function canAttackAir() : Boolean
      {
         return false;
      }
      
      override public function cleanUp() : void
      {
         if(this._mc != null)
         {
            if(contains(this._mc))
            {
               this.removeChild(this._mc);
            }
         }
         this._mc = null;
         if(this._ai)
         {
            this._ai.cleanUp();
         }
         this._ai = null;
         this._team = null;
         selectedFilter = null;
         nonSelectedFilter = null;
         this._syncAttackLabels = null;
         this._syncDefendLabels = null;
         this._attackLabels = null;
         this._deathLabels = null;
         this._currentDual = null;
         this._dualPartner = null;
         this._healthBar = null;
      }
      
      public function isPoisoned() : Boolean
      {
         return this._poisonDamage > 0;
      }
      
      protected function moveDualPartner(partner:com.brockw.stickwar.engine.units.Unit, xDiff:Number) : *
      {
         var differenceInPositions:Number = Math.abs(partner.px - this.px);
         var goalDifference:Number = this._currentDual.xDiff * this.team.game.getPerspectiveScale(py);
         this.px += Util.sgn(this.px - partner.px) * (goalDifference - differenceInPositions) * 0.1;
         this.py += (partner.py - 0.001 - py) * 0.1;
         this.y = this.py;
         this.x = this.px;
         if(partner.mc.mc.grunt != null)
         {
            partner.playDeathSound();
         }
         if(partner.mc.mc.fall != null)
         {
            this.team.game.soundManager.playSound("BodyfallSound",px,py);
         }
         if(partner.mc.mc.clash != null)
         {
            this.team.game.soundManager.playSoundRandom("hitOnArmour",7,px,py);
         }
      }
      
      public function isIncapacitated() : Boolean
      {
         return this.stunTimeLeft > 0;
      }
      
      override public function drawOnHud(canvas:MovieClip, game:StickWar) : void
      {
         var x:Number = canvas.width * px / game.map.width;
         var y:Number = canvas.height * py / game.map.height;
         if(this.isDead)
         {
            return;
         }
         if(this.team.isEnemy)
         {
            MovieClip(canvas).graphics.lineStyle(2,16711680,1);
         }
         else if(selected)
         {
            MovieClip(canvas).graphics.lineStyle(2,65280,1);
         }
         else
         {
            MovieClip(canvas).graphics.lineStyle(2,0,1);
         }
         MovieClip(canvas).graphics.drawRect(x,y,1,1);
      }
      
      public function getDamageToDeal() : Number
      {
         return this.damageToDeal;
      }
      
      public function setBuilding() : void
      {
         this.building = null;
      }
      
      public function firstInit() : void
      {
         var otherHeight:Number = Number(this.mc.mc.height);
         this._mayWalkThrough = false;
         pheight = Number(this.mc.height);
         pwidth = Number(this.mc.width);
         this.healthBar.totalHealth = this._health;
         this.mc.addChild(this.healthBar);
         this.healthBar.scaleX *= 1.3;
         this.healthBar.scaleY *= 1.2;
         this.healthBar.y = (0 - otherHeight) * 1.2;
         this.flyingHeight = 0;
         this._dz = Number(0);
         this.hasDefaultLoadout = false;
      }
      
      public function initBase() : void
      {
         var frameLabel:FrameLabel = null;
         _type = com.brockw.stickwar.engine.units.Unit.U_MINER;
         this._maxForce = Number(1);
         this._mass = 1;
         this._dragForce = Number(1);
         this._scale = Number(1);
         this._maxVelocity = Number(1);
         this._poisonDamage = Number(0);
         this._hitBoxWidth = 50;
         this._hitBoxHeight = 40;
         this.maxHealth = 100;
         this.isBusyForSpell = false;
         this._health = Number(100);
         this.stoned = false;
         this._population = 1;
         this.isDieing = false;
         this.timeOfDeath = 0;
         this.isDead = false;
         this._isDualing = false;
         this._currentDual = null;
         this._dualPartner = null;
         this.intendedWalkDirection = 1;
         this._dx = this._dy = Number(0);
         pz = Number(0);
         this._healTimeRemaining = 0;
         this.slowFramesRemaining = 0;
         _mouseIsOver = false;
         this.isHome = true;
         this.isOnFire = false;
         this.isStoneable = false;
         var labels:Array = this._mc.currentLabels;
         for each(frameLabel in labels)
         {
            if(frameLabel.name == "stone")
            {
               this.isStoneable = true;
            }
            if(frameLabel.name == "fireDeath")
            {
               this.isFirable = true;
            }
         }
      }
      
      protected function loadDamage(unitXml:XMLList) : void
      {
         var _damage:Number = Number(unitXml.damage);
         this.isArmoured = Boolean(unitXml.armoured == "1" ? Boolean(true) : Boolean(false));
         this._damageToArmour = Number(_damage + Number(unitXml.toArmour));
         this._damageToNotArmour = Number(_damage + Number(unitXml.toNotArmour));
      }
      
      protected function drawShadow() : void
      {
         if(this.shadowSprite == null)
         {
            this.shadowSprite = new MovieClip();
            this.addChild(this.shadowSprite);
            if(this.contains(this.mc))
            {
               this.removeChild(this.mc);
               this.addChild(this.mc);
            }
            this.removedSelected();
         }
      }
      
      public function get isDualing() : Boolean
      {
         return this._isDualing;
      }
      
      public function set isDualing(value:Boolean) : void
      {
         this._isDualing = value;
      }
      
      public function get syncAttackLabels() : Dictionary
      {
         return this._syncAttackLabels;
      }
      
      public function set syncAttackLabels(value:Dictionary) : void
      {
         this._syncAttackLabels = value;
      }
      
      public function get syncDefendLabels() : Dictionary
      {
         return this._syncDefendLabels;
      }
      
      public function set syncDefendLabels(value:Dictionary) : void
      {
         this._syncDefendLabels = value;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         super.setActionInterface(a);
         this.setActionInterfaceBase(a);
      }
      
      protected function setActionInterfaceBase(a:ActionInterface) : void
      {
         a.clear();
         a.setAction(2,1,UnitCommand.ATTACK_MOVE);
         a.setAction(2,2,UnitCommand.HOLD);
         a.setAction(1,2,UnitCommand.STAND);
         if(this.isGarrisoned)
         {
            a.setAction(0,2,UnitCommand.UNGARRISON);
         }
         else
         {
            a.setAction(0,2,UnitCommand.GARRISON);
         }
      }
      
      protected function initSync() : void
      {
         var s:* = null;
         var label:String = null;
         var parts:Array = null;
         var type:String = null;
         this._attackLabels = [];
         this._deathLabels = [];
         this._syncDefendLabels = new Dictionary();
         this._syncAttackLabels = new Dictionary();
         for(s in this.mc.currentLabels)
         {
            label = FrameLabel(this.mc.currentLabels[s]).name;
            parts = label.split("_",4);
            type = String(parts[0]);
            switch(type)
            {
               case "attack":
                  this._attackLabels.push(parts[1]);
                  break;
               case "death":
                  this._deathLabels.push(parts[1]);
                  break;
               case "syncAttack":
                  this._syncAttackLabels[parts[1]] = [parts[1],parts[2],parts[3]];
                  break;
               case "syncDefend":
                  this._syncDefendLabels[parts[1]] = parts[1];
                  break;
            }
         }
         this._attackLabels.sort();
         this._deathLabels.sort();
      }
      
      override public function onMap(game:StickWar) : Boolean
      {
         return !game.fogOfWar.isFogOn || this.team == game.team || game.team.getVisionRange() * game.team.direction > px * game.team.direction;
      }
      
      override public function onScreen(game:StickWar) : Boolean
      {
         if(!game.fogOfWar.isFogOn)
         {
            return true;
         }
         if(this.team != game.team && game.team.getVisionRange() * game.team.direction < px * game.team.direction)
         {
            return false;
         }
         return px + pwidth / 2 - game.screenX > 0 && px - pwidth / 2 - game.screenX < game.map.screenWidth;
      }
      
      public function isTargetable() : Boolean
      {
         return !this.isDead && !this.isDieing && px * this.team.direction > this.team.homeX * this.team.direction;
      }
      
      public function isAlive() : Boolean
      {
         return !this.isDieing && !this.isDead;
      }
      
      public function get mass() : int
      {
         return this._mass;
      }
      
      public function set mass(value:int) : void
      {
         this._mass = value;
      }
      
      public function init(game:StickWar) : void
      {
      }
      
      public function attack() : void
      {
      }
      
      public function update(game:StickWar) : void
      {
      }
      
      public function walk(x:Number, y:Number, intendedX:int) : void
      {
         if(this.isAbleToWalk())
         {
            this.baseWalk(x,y,intendedX);
         }
      }
      
      public function sqrDistanceToTarget(target:com.brockw.stickwar.engine.units.Unit) : Number
      {
         if(target == null)
         {
            return Number.MAX_VALUE;
         }
         return Math.pow(target.px - px,2) + Math.pow(target.py - py,2) * 10;
      }
      
      public function sqrDistanceTo(target:com.brockw.stickwar.engine.units.Unit) : Number
      {
         if(target == null)
         {
            return Number.MAX_VALUE;
         }
         return Math.pow(target.px - px,2) + Math.pow(target.py - py,2);
      }
      
      public function mayAttack(target:com.brockw.stickwar.engine.units.Unit) : Boolean
      {
         return false;
      }
      
      public function forceFaceDirection(dir:int) : void
      {
         if(!this.isDualing)
         {
            if(Util.sgn(this._mc.scaleX) != Util.sgn(dir))
            {
               this._mc.scaleX *= -1;
               this._lastTurnCount = 0;
            }
         }
      }
      
      public function heal(amount:Number, duration:int) : void
      {
         var p:Point = null;
         this._healTimeRemaining = duration;
         this._healAmount = amount;
         if(this.health != this.maxHealth && this.team.game.frame - this.lastHealthAnimation > 30)
         {
            p = this.healthBar.localToGlobal(new Point(0,40));
            p = this.team.game.battlefield.globalToLocal(p);
            this.team.game.projectileManager.initHealEffect(x,p.y,py,this.team,this);
            this.lastHealthAnimation = int(this.team.game.frame);
         }
      }
      
      public function faceDirection(dir:int) : void
      {
         if(!this.isDualing)
         {
            if(Util.sgn(this._mc.scaleX) != Util.sgn(dir))
            {
               if(this._lastTurnCount >= this.TURN_AGILITY)
               {
                  this._mc.scaleX *= -1;
                  this._lastTurnCount = 0;
               }
            }
         }
      }
      
      public function isSlow() : Boolean
      {
         return this.slowFramesRemaining > 0;
      }
      
      public function slow(frames:int) : void
      {
         if(frames > this.slowFramesRemaining)
         {
            this.slowFramesRemaining = frames;
         }
      }
      
      protected function updateCommon(game:StickWar) : void
      {
         if(this.stunMc)
         {
            Util.animateMovieClipBasic(this.stunMc);
            if(this.stunTimeLeft <= 0)
            {
               if(this.stunMc && this.mc.contains(this.stunMc))
               {
                  this.mc.removeChild(this.stunMc);
               }
            }
         }
         if(this.reaperCurseFrames > 0)
         {
            this.walk(this.team.direction,0,this.team.direction);
            this.reaperCurseFrames--;
            if(this.reaperMc.currentFrame == this.reaperMc.totalFrames)
            {
               this.reaperMc.gotoAndStop(1);
            }
            else
            {
               this.reaperMc.nextFrame();
            }
            if(this.reaperCurseFrames == 0)
            {
               if(this.reaperMc && this.mc.contains(this.reaperMc))
               {
                  this.mc.removeChild(this.reaperMc);
               }
               this.reaperMc = null;
            }
         }
         if(this._healTimeRemaining > 0)
         {
            this.health += this._healAmount;
            if(this.health > this.maxHealth)
            {
               this.health = this.maxHealth;
            }
            this._healTimeRemaining = int(this._healTimeRemaining - 1);
         }
         if(this._health + this.chaosHealRate <= this.maxHealth && this.team.type == Team.T_CHAOS)
         {
            this._health += this.chaosHealRate;
         }
         if(this.slowFramesRemaining)
         {
            this.slowFramesRemaining = int(this.slowFramesRemaining - 1);
         }
         this._timeOfDeath++;
         this.healthBar.health = this.health;
         this.healthBar.update();
         if((this.isDead || this.isDieing) && !this.isDualing)
         {
            selected = false;
            if(this.mc.mc)
            {
               this.mc.mc.filters = [];
            }
            if(this.mc.contains(this.healthBar))
            {
               this.mc.removeChild(this.healthBar);
            }
         }
         else
         {
            if(this.isDualing)
            {
               if(this.mc.contains(this.healthBar))
               {
                  this.mc.removeChild(this.healthBar);
               }
            }
            else if(!this.mc.contains(this.healthBar))
            {
               this.mc.addChild(this.healthBar);
            }
            if(mouseIsOver && this.isAlive())
            {
               this.drawSelected(65280,1);
            }
            else if(selected && !this.isTowerSpawned && this.isAlive())
            {
               this.drawSelected(16777215,1);
            }
            else
            {
               this.removedSelected();
            }
            if(this.shadowSprite != null)
            {
               this.shadowSprite.scaleX = this._mc.scaleX;
               this.shadowSprite.scaleY = this._mc.scaleY;
            }
         }
         ++this.framesPoisoned;
         if(this.team.type == Team.T_CHAOS && this.framesPoisoned > this.chaosPoisonedFrames)
         {
            if(!this.noAutoCure)
            {
               this.cure();
            }
         }
         var c:ColorTransform = this.mc.transform.colorTransform;
         if(this.isGodmoded && !this.isTowerSpawned)
         {
            this.mc.mc.filters = [this.godmodeGlow];
         }
         else if(this.team.type == Team.T_CHAOS && this.isTowerSpawned)
         {
            c.greenOffset = 255;
            c.blueOffset = 0;
            this.mc.mc.filters = [this.towerSpawnGlow];
            if(game.frame % 60 == 0 && this.isAlive())
            {
               game.projectileManager.initSpawnDrip(px,py,this.team);
            }
         }
         else if(this.team.type == Team.T_GOOD && this.isTowerSpawned)
         {
            c.greenOffset = 255;
            c.blueOffset = 250;
            this.mc.mc.filters = [this.towerSpawnGlow];
            if(game.frame % 60 == 0 && this.isAlive())
            {
               game.projectileManager.initSpawnDrip(px,py,this.team);
            }
         }
         else
         {
            c.greenOffset = 0;
            c.blueOffset = 0;
            this.mc.mc.filters = [];
         }
         if(this.isAlive() && game.frame % 90 == 0 && this._poisonDamage > 0)
         {
            this.damage(D_NO_SOUND,this._poisonDamage,null);
            c.greenOffset = 55;
            this.mc.transform.colorTransform = c;
         }
         else
         {
            c.greenOffset = 0;
            this.mc.transform.colorTransform = c;
         }
         if(this.isHome && this.team.direction * px > this.team.direction * (this.team.homeX + this.team.direction * 1200))
         {
            this.isHome = false;
         }
         else if(!this.isHome && this.team.direction * px < this.team.direction * (this.team.homeX + this.team.direction * 600))
         {
            this.isHome = true;
         }
         if(this.team.direction * px < this.team.direction * (this.team.homeX - this.team.direction * 25) && !this.noAutoCure)
         {
            this.cure();
            this.heal(this.garrisonHealRate,1);
         }
         if(this.poisonDamage == 0)
         {
            if(this.poisonMc && this.mc.contains(this.poisonMc))
            {
               this.mc.removeChild(this.poisonMc);
            }
         }
         if(this.team.game.frame > this.lastWalkFrame + 1)
         {
            this._ddx = Number(0);
            this._ddy = Number(0);
         }
      }
      
      private function removedSelected() : void
      {
         if(this.shadowSprite == null)
         {
            return;
         }
         this.shadowSprite.graphics.clear();
         this.shadowSprite.graphics.lineStyle(1,0,0);
         if(this.isAlive())
         {
            this.shadowSprite.graphics.beginFill(0,0.2);
         }
         else
         {
            this.shadowSprite.graphics.beginFill(0,0);
         }
         this.shadowSprite.graphics.drawEllipse(-40,this.flyingHeight - 4.5,80,15);
      }
      
      private function drawSelected(color:int, thickness:Number) : void
      {
         if(this.shadowSprite == null)
         {
            return;
         }
         this.shadowSprite.graphics.clear();
         this.shadowSprite.graphics.lineStyle(1,color,1);
         this.shadowSprite.graphics.beginFill(color,0.3);
         this.shadowSprite.graphics.drawEllipse(-40,this.flyingHeight - 4.5,80,15);
      }
      
      public function poison(p:Number) : void
      {
         if(!this.isAlive())
         {
            return;
         }
         this.framesPoisoned = 0;
         if(p > this._poisonDamage)
         {
            if(this.poisonMc && this.mc.contains(this.poisonMc))
            {
               this.mc.removeChild(this.poisonMc);
            }
            this.poisonMc = new poisonEffect();
            this.mc.addChild(this.poisonMc);
            this.team.game.soundManager.playSound("PoisonedSound",px,py);
            this.poisonMc.x = 0;
            this.poisonMc.y = this.healthBar.y - 20;
            this._poisonDamage = p;
            if(this._poisonDamage > 0)
            {
               this.team.poisonedUnits[this.id] = this;
            }
         }
      }
      
      public function cure() : void
      {
         var p:Point = null;
         if(this.poisonDamage != 0)
         {
            p = this.healthBar.localToGlobal(new Point(0,-40));
            p = this.team.game.battlefield.globalToLocal(p);
            this.team.game.projectileManager.initHealEffect(x,p.y,py,this.team,this,true);
            this.lastHealthAnimation = int(this.team.game.frame);
         }
         this._poisonDamage = Number(0);
         if(this.id in this.team.poisonedUnits)
         {
            delete this.team.poisonedUnits[this.id];
         }
      }
      
      public function isFlying() : Boolean
      {
         return this.flyingHeight != 0;
      }
      
      protected function updateMotion(game:StickWar) : void
      {
         var w:Wall = null;
         ++this._lastTurnCount;
         if(this._stunTimeLeft > 0)
         {
            this._stunTimeLeft = int(this._stunTimeLeft - 1);
         }
         if(this.isDualing == true)
         {
            return;
         }
         this._perspectiveScale = Number(this._scale * (game.backScale + py / game.map.height * (game.frontScale - game.backScale)));
         this._mc.scaleX = Util.sgn(this._mc.scaleX) * this._perspectiveScale;
         this._mc.scaleY = this._perspectiveScale;
         pz = Number((0 - this.flyingHeight + this.dzOffset) * this._perspectiveScale);
         if(game.random.nextNumber() > 0.4 && this.mayWalkThrough == false)
         {
            if(this.stunTimeLeft == 0)
            {
               game.spatialHash.mapInArea(px - width / 2,py - height / 2,px + width / 2,py + height / 2,this.checkCollision,false);
            }
         }
         if(this.stunTimeLeft != 0)
         {
            if(Math.abs(this._dz) < 0.1)
            {
               this._dx *= 0.7;
               this._dy *= 0.7;
            }
         }
         else
         {
            this._dx *= this._dragForce;
            this._dy *= this._dragForce;
         }
         if(this.stunTimeLeft == 0)
         {
            if(Math.abs(this._dx) > this._maxVelocity)
            {
               this._dx = Number(this._maxVelocity * Math.abs(this._dx) / this._dx);
            }
            if(Math.abs(this._dy) > this._maxVelocity / 2)
            {
               this._dy = Number(this._maxVelocity / 2 * Math.abs(this._dy) / this._dy);
            }
         }
         else
         {
            if(Math.abs(this._dx) > 8 * this._maxVelocity)
            {
               this._dx = Number(8 * this._maxVelocity * Math.abs(this._dx) / this._dx);
            }
            if(Math.abs(this._dy) > 8 * this._maxVelocity / 2)
            {
               this._dy = Number(8 * this._maxVelocity / 2 * Math.abs(this._dy) / this._dy);
            }
         }
         var CASTLE_WIDTH:int = 200;
         if(!this.isGarrisoned)
         {
            if(px + this._dx <= game.map.screenWidth + CASTLE_WIDTH && this._dx < 0)
            {
               this._dx = Number(0);
            }
            if(px + this._dx >= game.background.mapLength - game.map.screenWidth - CASTLE_WIDTH && this._dx > 0)
            {
               this._dx = Number(0);
            }
            if(!(this.ai.currentCommand is HoldCommand))
            {
               if(px + this._dx <= game.map.screenWidth + CASTLE_WIDTH)
               {
                  this.walk(1,0,1);
               }
               if(px + this._dx >= game.background.mapLength - game.map.screenWidth - CASTLE_WIDTH)
               {
                  this.walk(-1,0,-1);
               }
            }
         }
         else
         {
            if(px + this._dx < 0 && this._dx < 0)
            {
               this._dx = Number(0);
            }
            if(px + this._dx > game.background.mapLength && this._dx > 0)
            {
               this._dx = Number(0);
            }
         }
         if(py + this._dy < 0 || py + this._dy > game.map.height)
         {
            this._dy = Number(0);
         }
         if(this.isStationary)
         {
            this._dx = this._dy = Number(0);
         }
         px += this._dx;
         py += this._dy;
         var BUF:int = 7.5;
         for each(w in this.team.enemyTeam.walls)
         {
            if(px < w.px + BUF && px > w.px - BUF)
            {
               px = Number(w.px - BUF * this.team.direction);
            }
         }
         if(px < 0 + BUF)
         {
            px = Number(BUF);
         }
         else if(px > game.map.width - BUF)
         {
            px = Number(game.map.width - BUF);
         }
         this._dz += StickWar.GRAVITY;
         this.dzOffset += this._dz;
         if(this.dzOffset >= 0)
         {
            this.dzOffset = Number(0);
            this._dz = Number(0);
         }
         x = px;
         y = py + pz;
      }
      
      private function checkCollision(param1:com.brockw.stickwar.engine.units.Unit) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param1 == this || param1.pz != 0)
         {
            return;
         }
         if(param1._isGarrisoned || this._isGarrisoned)
         {
            return;
         }
         if(param1 is com.brockw.stickwar.engine.units.Unit)
         {
            param1 = Unit(param1);
            if(!param1.mayWalkThrough && param1.stunTimeLeft == 0 && param1.isCollision(this,this.dx,this.dy))
            {
               _loc2_ = 0.15;
               _loc3_ = this.ai.currentCommand.type;
               _loc4_ = param1.ai.currentCommand.type;
               _loc5_ = _loc3_ == UnitCommand.STAND;
               _loc6_ = _loc4_ == UnitCommand.STAND;
               _loc7_ = (param1.hitBoxWidth * param1.perspectiveScale + this.hitBoxWidth * this.perspectiveScale) / 2;
               _loc8_ = Math.abs(px - param1.px) / _loc7_;
               if(_loc8_ <= 1)
               {
                  if(px == param1.px)
                  {
                     px = Number(param1.px + this.team.game.random.nextNumber() - 0.5);
                  }
                  if(px != param1.px)
                  {
                     if(Util.sgn(this._dx) != 0 - Util.sgn(param1.dx) || this.team != param1.team)
                     {
                        if(Math.abs(this.dx) < 1 && Math.abs(param1.dx) < 1 || param1.isMiner() && this.isMiner())
                        {
                           this.nudgeFrame = int(this.team.game.frame);
                           if(this.mass < param1.mass || _loc5_)
                           {
                              this._dx += (1 - _loc8_) * Util.sgn(px - param1.px) * 0.51;
                           }
                           if(this.mass >= param1.mass || _loc6_)
                           {
                              param1._dx += (1 - _loc8_) * Util.sgn(param1.px - px) * 0.51;
                           }
                        }
                     }
                  }
               }
               _loc7_ = (param1.hitBoxWidth * param1.perspectiveScale + this.hitBoxWidth * this.perspectiveScale) / 2;
               _loc8_ = Math.abs(py - param1.py) / _loc7_;
               if(_loc8_ <= 1)
               {
                  if(py == param1.py)
                  {
                     py = Number(param1.py + this.team.game.random.nextNumber() - 0.5);
                  }
                  if(py != param1.py)
                  {
                     if(Util.sgn(this._dy) != 0 - Util.sgn(param1.dy) && this.team == param1.team)
                     {
                        this.nudgeFrame = int(this.team.game.frame);
                        if(Math.abs(this.dy) < 1 && Math.abs(param1.dy) < 1 || param1.isMiner() && this.isMiner())
                        {
                           if(this.mass < param1.mass || _loc5_)
                           {
                              this._dy += (1 - _loc8_) * Util.sgn(py - param1.py) * 0.51;
                           }
                           if(this.mass >= param1.mass || _loc6_)
                           {
                              param1._dy += (1 - _loc8_) * Util.sgn(param1.py - py) * 0.51;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function isMiner() : Boolean
      {
         return type == this.team.getMinerType();
      }
      
      public function isFeetMoving() : Boolean
      {
         if(!this.isGarrisoned)
         {
            return Math.abs(this._ddy) > 0.03 || Math.abs(this._ddx) > 0.03;
         }
         return Math.abs(this._dx) + Math.abs(this._dy) > 1;
      }
      
      public function stun(s:int) : void
      {
         if(!this.isAlive())
         {
            return;
         }
         if(s > 0)
         {
            this._dz = Number(0 - com.brockw.stickwar.engine.units.Unit.stunUpForce);
            this.stunTimeLeft = s;
            if(this.stunMc && this.mc.contains(this.stunMc))
            {
               this.mc.removeChild(this.stunMc);
            }
            this.mc.addChild(this.stunMc = new dizzyMc());
            this.stunMc.y = this.healthBar.y - 20;
            this.stunMc.x = 0;
            this.stunMc.scaleX = 0.4;
            this.stunMc.scaleY = 0.4;
         }
      }
      
      private function setVector(x:Number, y:Number, v:Vector3D) : void
      {
         v.x = x;
         v.y = y;
         v.z = 0;
         v.w = 0;
      }
      
      protected function fractionOfCollision(unit:com.brockw.stickwar.engine.units.Unit, dx:int, dy:int) : Number
      {
         return (Math.pow(unit.px + unit.dx - dx - px,2) + Math.pow(unit.py + unit.dy - dy - py,2)) / Math.pow(unit.hitBoxWidth * (this.perspectiveScale + unit.perspectiveScale) / 2,2);
      }
      
      protected function isCollision(unit:com.brockw.stickwar.engine.units.Unit, dx:int, dy:int) : Boolean
      {
         if(Math.pow(unit.px + unit.dx - dx - px,2) + Math.pow(unit.py + unit.dy - dy - py,2) < Math.pow(unit.hitBoxWidth * (this.perspectiveScale + unit.perspectiveScale) / 2,2))
         {
            return true;
         }
         return false;
      }
      
      protected function checkForHit() : Boolean
      {
         var target:com.brockw.stickwar.engine.units.Unit = this.ai.getClosestTarget();
         if(target == null)
         {
            return false;
         }
         var dir:int = Util.sgn(target.px - px);
         if(this._mc.mc.tip == null)
         {
            return false;
         }
         var p1:Point = MovieClip(this._mc.mc.tip).localToGlobal(new Point(0,0));
         if(target.checkForHitPoint(p1,target))
         {
            target.damage(0,this.damageToDeal,this);
            return true;
         }
         return false;
      }
      
      public function checkForHitPoint(p:Point, target:com.brockw.stickwar.engine.units.Unit) : Boolean
      {
         if(target == null)
         {
            return false;
         }
         var dir:int = Util.sgn(target.px - px);
         p = this.globalToLocal(p);
         if(p.x > 0 - pwidth && p.x < pwidth && p.y > 0 - pheight && p.y < pheight)
         {
            return true;
         }
         return false;
      }
      
      public function checkForHitPointArrow(p:Point, py:Number, target:com.brockw.stickwar.engine.units.Unit) : Boolean
      {
         if(target == null)
         {
            return false;
         }
         var dir:int = Util.sgn(target.px - px);
         p = this.globalToLocal(p);
         if(p.x > 0 - pwidth && p.x < pwidth && p.y > 0 - pheight && p.y < 0 && Math.abs(py - this.py) < 150)
         {
            return true;
         }
         return false;
      }
      
      override public function damage(type:int, amount:int, inflictor:Entity, modifier:Number = 1) : void
      {
         var dmg:Number = NaN;
         if(this.isTargetable() && !this.isDualing)
         {
            if(!(com.brockw.stickwar.engine.units.Unit.D_NO_SOUND & type))
            {
               if(this.isArmoured)
               {
                  this.team.game.soundManager.playSoundRandom("hitOnArmour",7,px,py);
               }
               else
               {
                  this.team.game.soundManager.playSoundRandom("hitOnFlesh",12,px,py);
               }
            }
            dmg = 0;
            if(inflictor != null)
            {
               dmg = inflictor.getDamageToUnit(this) * modifier;
            }
            else
            {
               dmg = amount * modifier;
            }
            if(!(com.brockw.stickwar.engine.units.Unit.D_NO_BLOOD & type))
            {
               this.team.game.bloodManager.addBlood(px,py,0 - this.team.direction,this.team.game);
            }
            if(this.reaperCurseFrames > 0)
            {
               dmg *= 1 + this.reaperAmplification;
            }
            dmg /= this.team.healthModifier;
            dmg *= this.team.enemyTeam.damageModifier;
            this._health -= dmg;
            if(this._health <= 0)
            {
               this.arrowDeath = false;
               this.playDeathSound();
               if(type & D_FIRE && this.isFirable)
               {
                  this.isOnFire = true;
               }
               else if(type & com.brockw.stickwar.engine.units.Unit.D_ARROW)
               {
                  this.arrowDeath = true;
                  this.forceFaceDirection(Util.sgn(inflictor.px - px));
               }
               this.isDieing = true;
               this.cleanUpStats();
               this._timeOfDeath = Number(0);
               this._health = Number(0);
               if(this.shadowSprite != null && this.contains(this.shadowSprite))
               {
                  this.removeChild(this.shadowSprite);
               }
               this.shadowSprite = null;
               this.healthBar.health = 0;
               this.healthBar.update();
            }
         }
      }
      
      private function cleanUpStats() : void
      {
         if(this.reaperMc && this.mc.contains(this.reaperMc))
         {
            this.mc.removeChild(this.reaperMc);
         }
         if(this.poisonMc && this.mc.contains(this.poisonMc))
         {
            this.mc.removeChild(this.poisonMc);
         }
         if(this.stunMc && this.mc.contains(this.stunMc))
         {
            this.mc.removeChild(this.stunMc);
         }
      }
      
      public function playDeathSound() : void
      {
         this.team.game.soundManager.playSoundRandom("Pain",8,px,py);
      }
      
      public function startDual(target:com.brockw.stickwar.engine.units.Unit) : Boolean
      {
         if(!this.team.isMember)
         {
            return false;
         }
         if(!this.isTargetable())
         {
            return false;
         }
         var array:Array = this.team.game.dualFactory.getDuals(this.type,target.type);
         if(array == null)
         {
            return false;
         }
         var dual:int = this.team.game.random.nextInt();
         this._currentDual = array[dual % array.length];
         target._currentDual = array[dual % array.length];
         this._isDualing = true;
         target._isDualing = true;
         target._health = Number(0);
         target.isDieing = true;
         target.timeOfDeath = 0;
         this._dualPartner = target;
         target._dualPartner = this;
         target.cleanUpStats();
         return true;
      }
      
      protected function getDeathLabel(game:StickWar) : String
      {
         if(this.isOnFire)
         {
            return "fireDeath";
         }
         if(this.stoned)
         {
            return "stone";
         }
         var id:int = this.team.game.random.nextInt() % this._deathLabels.length;
         return "death_" + this._deathLabels[id];
      }
      
      public function stoneAttack(damage:int) : void
      {
         var a:Array = this._mc.currentLabels;
         if(this.isStoneable && (!this.isMiniBoss || this._health - damage <= 0))
         {
            this.damage(0,this._health * 2,null);
            this.stoned = true;
         }
         else
         {
            this.damage(0,damage,null);
         }
      }
      
      public function garrison() : void
      {
         this.isGarrisoned = true;
         this.team.garrisonedUnits[this.id] = this;
      }
      
      public function ungarrison() : void
      {
         if(this.id in this.team.garrisonedUnits)
         {
            delete this.team.garrisonedUnits[this.id];
         }
         this.isGarrisoned = false;
      }
      
      public function damageWillKill(type:int, amount:int) : Boolean
      {
         if(this._health - amount <= 0)
         {
            return true;
         }
         return false;
      }
      
      protected function isAbleToWalk() : Boolean
      {
         return this._state == S_RUN;
      }
      
      public function isBusy() : Boolean
      {
         return false;
      }
      
      public function stateFixForCutToWalk() : void
      {
         this._state = S_RUN;
         this.hasHit = true;
      }
      
      protected function baseWalk(x:Number, y:Number, intendedX:int) : void
      {
         if(!this.isAbleToWalk() || this.stunTimeLeft != 0)
         {
            return;
         }
         this.lastWalkFrame = int(this.team.game.frame);
         if(x > 1)
         {
            x = 1;
         }
         else if(x < -1)
         {
            x = -1;
         }
         if(y > 1)
         {
            y = 1;
         }
         else if(y < -1)
         {
            y = -1;
         }
         var ddx:Number = x * this._maxForce / this._mass * this._worldScaleX;
         var ddy:Number = y * this._maxForce / this._mass * this._worldScaleY;
         this._ddx = ddx;
         this._ddy = ddy;
         this._state = S_RUN;
         if(Math.abs(this.dx) > 2 * this._maxVelocity / 5 && this.team.game.frame - this.nudgeFrame > 15)
         {
            this.faceDirection(Util.sgn(this.dx));
         }
         else
         {
            this.faceDirection(Util.sgn(intendedX));
         }
         this._dx += ddx;
         this._dy += ddy;
      }
      
      public function applyVelocity(xf:Number, yf:Number = 0, zf:Number = 0) : void
      {
         this.nudgeFrame = int(this.team.game.frame);
         this._dx = xf;
         this._dy = yf;
      }
      
      public function getDirection() : int
      {
         return Util.sgn(this._mc.scaleX);
      }
      
      public function get mc() : MovieClip
      {
         return this._mc;
      }
      
      public function set mc(value:MovieClip) : void
      {
         this._mc = value;
      }
      
      public function get ai() : UnitAi
      {
         return this._ai;
      }
      
      public function set ai(value:UnitAi) : void
      {
         this._ai = value;
      }
      
      public function get team() : Team
      {
         return this._team;
      }
      
      public function set team(value:Team) : void
      {
         this._team = value;
      }
      
      public function get hitBoxWidth() : int
      {
         return this._hitBoxWidth;
      }
      
      public function set hitBoxWidth(value:int) : void
      {
         this._hitBoxWidth = value;
      }
      
      public function get timeOfDeath() : Number
      {
         return this._timeOfDeath;
      }
      
      public function set timeOfDeath(value:Number) : void
      {
         this._timeOfDeath = value;
      }
      
      public function get perspectiveScale() : Number
      {
         return this._perspectiveScale;
      }
      
      public function set perspectiveScale(value:Number) : void
      {
         this._perspectiveScale = value;
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
      
      public function get health() : Number
      {
         return this._health;
      }
      
      public function set health(value:Number) : void
      {
         this._health = value;
      }
      
      public function get population() : int
      {
         return this._population;
      }
      
      public function set population(value:int) : void
      {
         this._population = value;
      }
      
      public function get damageToDeal() : Number
      {
         return this._damageToDeal;
      }
      
      public function set damageToDeal(value:Number) : void
      {
         this._damageToDeal = value;
      }
      
      public function get healthBar() : HealthBar
      {
         return this._healthBar;
      }
      
      public function set healthBar(value:HealthBar) : void
      {
         this._healthBar = value;
      }
      
      public function get mayWalkThrough() : Boolean
      {
         return this._mayWalkThrough;
      }
      
      public function set mayWalkThrough(value:Boolean) : void
      {
         this._mayWalkThrough = value;
      }
      
      public function get isDead() : Boolean
      {
         return this._isDead;
      }
      
      public function set isDead(value:Boolean) : void
      {
         this._isDead = value;
      }
      
      public function get stunTimeLeft() : int
      {
         return this._stunTimeLeft;
      }
      
      public function set stunTimeLeft(value:int) : void
      {
         this._stunTimeLeft = value;
      }
      
      public function get createTime() : int
      {
         return this._createTime;
      }
      
      public function set createTime(value:int) : void
      {
         this._createTime = value;
      }
      
      public function get building() : Building
      {
         return this._building;
      }
      
      public function set building(value:Building) : void
      {
         this._building = value;
      }
      
      public function get isStationary() : Boolean
      {
         return this._isStationary;
      }
      
      public function set isStationary(value:Boolean) : void
      {
         this._isStationary = value;
      }
      
      public function get isGarrisoned() : Boolean
      {
         return this._isGarrisoned;
      }
      
      public function set isGarrisoned(value:Boolean) : void
      {
         this._isGarrisoned = value;
      }
      
      public function get isBusyForSpell() : Boolean
      {
         return this._isBusyForSpell;
      }
      
      public function set isBusyForSpell(value:Boolean) : void
      {
         this._isBusyForSpell = value;
      }
      
      public function get flyingHeight() : Number
      {
         return this._flyingHeight;
      }
      
      public function set flyingHeight(value:Number) : void
      {
         this._flyingHeight = value;
      }
      
      public function get interactsWith() : int
      {
         return this._interactsWith;
      }
      
      public function set interactsWith(value:int) : void
      {
         this._interactsWith = value;
      }
      
      public function get maxHealth() : int
      {
         return this._maxHealth;
      }
      
      public function set maxHealth(value:int) : void
      {
         this._maxHealth = value;
      }
      
      public function get reaperCurseFrames() : int
      {
         return this._reaperCurseFrames;
      }
      
      public function set reaperCurseFrames(value:int) : void
      {
         this._reaperCurseFrames = value;
      }
      
      public function get shadowSprite() : MovieClip
      {
         return this._shadowSprite;
      }
      
      public function set shadowSprite(value:MovieClip) : void
      {
         this._shadowSprite = value;
      }
      
      public function get poisonDamage() : Number
      {
         return this._poisonDamage;
      }
      
      public function set poisonDamage(value:Number) : void
      {
         this._poisonDamage = value;
      }
      
      public function get isDieing() : Boolean
      {
         return this._isDieing;
      }
      
      public function set isDieing(value:Boolean) : void
      {
         this._isDieing = value;
      }
      
      public function get dz() : Number
      {
         return this._dz;
      }
      
      public function set dz(value:Number) : void
      {
         this._dz = value;
      }
      
      public function get isFirable() : Boolean
      {
         return this._isFirable;
      }
      
      public function set isFirable(value:Boolean) : void
      {
         this._isFirable = value;
      }
      
      public function get isOnFire() : Boolean
      {
         return this._isOnFire;
      }
      
      public function set isOnFire(value:Boolean) : void
      {
         this._isOnFire = value;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function set scale(value:Number) : void
      {
         this._scale = value;
      }
      
      public function get isRejoiningFormation() : Boolean
      {
         return this._isRejoiningFormation;
      }
      
      public function set isRejoiningFormation(value:Boolean) : void
      {
         this._isRejoiningFormation = value;
      }
      
      public function get isTowerSpawned() : Boolean
      {
         return this._isTowerSpawned;
      }
      
      public function set isTowerSpawned(value:Boolean) : void
      {
         this._isTowerSpawned = value;
      }
      
      public function get arrowDeath() : Boolean
      {
         return this._arrowDeath;
      }
      
      public function set arrowDeath(value:Boolean) : void
      {
         this._arrowDeath = value;
      }
      
      public function get stoned() : Boolean
      {
         return this._stoned;
      }
      
      public function set stoned(value:Boolean) : void
      {
         this._stoned = value;
      }
      
      public function get hasDefaultLoadout() : Boolean
      {
         return this._hasDefaultLoadout;
      }
      
      public function set hasDefaultLoadout(value:Boolean) : void
      {
         this._hasDefaultLoadout = value;
      }
   }
}
