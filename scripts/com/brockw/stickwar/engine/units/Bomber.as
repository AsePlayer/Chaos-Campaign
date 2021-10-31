package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.BomberAi;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.MovieClip;
   
   public class Bomber extends Unit
   {
       
      
      public var bomberType:String;
      
      public var didIBlowUp:Boolean = false;
      
      private var poisonRN:Boolean = false;
      
      private var noMorePoison:Boolean = false;
      
      private var divider:String;
      
      private var WEAPON_REACH:Number;
      
      public var explosionDamage:Number;
      
      private var clusterTime:Boolean = false;
      
      private var clusterTimer:Number;
      
      private var clusterLad:Bomber;
      
      private var timeToRun:Boolean = false;
      
      public var newMinerTargeter:Boolean = false;
      
      public var detonated:Boolean = false;
      
      public var comment:String;
      
      public function Bomber(game:StickWar)
      {
         super(game);
         _mc = new _bomber();
         this.init(game);
         addChild(_mc);
         ai = new BomberAi(this);
         this.bomberType = "Default";
         initSync();
         firstInit();
      }
      
      public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         var m:_bomber = _bomber(mc);
         if(m.mc.dynamite2)
         {
            if(weapon != "")
            {
               m.mc.dynamite2.gotoAndStop(weapon);
               Util.animateMovieClipBasic(m.mc.dynamite2.mc);
            }
         }
         if(m.mc.dynamite)
         {
            if(weapon != "")
            {
               m.mc.dynamite.gotoAndStop(weapon);
               Util.animateMovieClipBasic(m.mc.dynamite.mc);
            }
         }
         if(m.mc.inner)
         {
            if(m.mc.inner.dynamite)
            {
               if(weapon != "")
               {
                  m.mc.inner.dynamite.gotoAndStop(weapon);
                  Util.animateMovieClipBasic(m.mc.inner.dynamite.mc);
               }
            }
         }
         if(m.mc.head)
         {
            if(armor != "")
            {
               m.mc.head.gotoAndStop(armor);
            }
         }
         if(m.mc.top)
         {
            if(m.mc.top.head)
            {
               if(armor != "")
               {
                  m.mc.top.head.gotoAndStop(armor);
               }
            }
         }
      }
      
      override public function weaponReach() : Number
      {
         return 0;
      }
      
      override public function init(game:StickWar) : void
      {
         initBase();
         this.WEAPON_REACH = game.xml.xml.Chaos.Units.bomber.weaponReach;
         population = game.xml.xml.Chaos.Units.bomber.population;
         _mass = game.xml.xml.Chaos.Units.bomber.mass;
         _maxForce = game.xml.xml.Chaos.Units.bomber.maxForce;
         _dragForce = game.xml.xml.Chaos.Units.bomber.dragForce;
         _scale = game.xml.xml.Chaos.Units.bomber.scale;
         _maxVelocity = game.xml.xml.Chaos.Units.bomber.maxVelocity;
         damageToDeal = game.xml.xml.Chaos.Units.bomber.baseDamage;
         this.explosionDamage = game.xml.xml.Chaos.Units.bomber.explosionDamage;
         this.createTime = game.xml.xml.Chaos.Units.bomber.cooldown;
         maxHealth = health = game.xml.xml.Chaos.Units.bomber.health;
         loadDamage(game.xml.xml.Chaos.Units.bomber);
         type = Unit.U_BOMBER;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["BarracksBuilding"];
      }
      
      override public function update(game:StickWar) : void
      {
         var clusterLad:Bomber = null;
         updateCommon(game);
         if(this.bomberType == "minerTargeter")
         {
            this.ai.minerTargeter = true;
            isNormal = false;
         }
         if(this.bomberType == "medusaTargeter")
         {
            this.ai.medusaTargeter = true;
            isNormal = false;
         }
         if(this.bomberType == "statueTargeter" || this.bomberType == "statueEndsHere")
         {
            this.ai.statueTargeter = true;
            isNormal = false;
         }
         if(this.bomberType == "clusterBoi")
         {
            isNormal = false;
            this._maxHealth = game.xml.xml.Chaos.Units.bomber.health * 2;
            if(this.scale != 0.825)
            {
               this._health = this._maxHealth;
               this.scale = 0.825;
            }
            else
            {
               this.scale = 0.825;
            }
            this.healthBar.totalHealth = this._maxHealth;
         }
         if(this.bomberType == "statueTargeter" && !this.timeToRun)
         {
            isNormal = false;
            this._maxForce = 140;
            this._maxVelocity = 8;
         }
         else if(this.timeToRun)
         {
            this.timeToRun = true;
            this._maxVelocity = 8.75;
         }
         if(!isDieing)
         {
            if(_isDualing)
            {
               _mc.gotoAndStop(_currentDual.attackLabel);
               moveDualPartner(_dualPartner,_currentDual.xDiff);
               if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                  _mc.gotoAndStop("run");
                  _isDualing = false;
                  _state = S_RUN;
                  px += Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale;
                  dx = 0;
                  dy = 0;
               }
            }
            else if(_state == S_RUN)
            {
               if(isFeetMoving())
               {
                  _mc.gotoAndStop("run");
               }
               else
               {
                  _mc.gotoAndStop("stand");
               }
            }
            else if(_state == S_ATTACK)
            {
               damage(0,1000,null);
            }
            updateMotion(game);
         }
         else if(isDead == false)
         {
            if(_isDualing)
            {
               _mc.gotoAndStop(_currentDual.defendLabel);
               if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                  isDualing = false;
                  mc.filters = [];
                  this.team.removeUnit(this,game);
                  isDead = true;
               }
            }
            else
            {
               this.detonate();
               _mc.gotoAndStop(getDeathLabel(game));
               this.team.removeUnit(this,game);
               isDead = true;
            }
            this.convertBomber("Default");
            this.poisonRN = false;
            this.timeToRun = false;
            maxHealth = game.xml.xml.Chaos.Units.bomber.health;
            this.WEAPON_REACH = game.xml.xml.Chaos.Units.bomber.weaponReach;
            population = game.xml.xml.Chaos.Units.bomber.population;
            _mass = game.xml.xml.Chaos.Units.bomber.mass;
            _maxForce = game.xml.xml.Chaos.Units.bomber.maxForce;
            _dragForce = game.xml.xml.Chaos.Units.bomber.dragForce;
            _scale = game.xml.xml.Chaos.Units.bomber.scale;
            _maxVelocity = game.xml.xml.Chaos.Units.bomber.maxVelocity;
            damageToDeal = game.xml.xml.Chaos.Units.bomber.baseDamage;
            this.explosionDamage = game.xml.xml.Chaos.Units.bomber.explosionDamage;
            this.createTime = game.xml.xml.Chaos.Units.bomber.cooldown;
            maxHealth = health = game.xml.xml.Chaos.Units.bomber.health;
            loadDamage(game.xml.xml.Chaos.Units.bomber);
         }
         Util.animateMovieClipBasic(mc.mc);
         if(isDead)
         {
            _mc.gotoAndStop(getDeathLabel(game));
            _mc.mc.alpha = 0;
         }
         if(this.bomberType == "medusaTargeter" && !specialTimeOver && !stoned)
         {
            Bomber.setItem(_bomber(mc),"C4","Red Bike Helmet","");
         }
         else if(this.bomberType == "statueTargeter" && !specialTimeOver && !stoned)
         {
            Bomber.setItem(_bomber(mc),"Rocket","Flash","");
         }
         else if(this.bomberType == "minerTargeter" && !specialTimeOver && !stoned)
         {
            Bomber.setItem(_bomber(mc),"Flask","Scientist","");
         }
         else if(this.bomberType == "clusterBoi" && !specialTimeOver && !stoned)
         {
            Bomber.setItem(_bomber(mc),"Round Cluster Bomb","Round Bomb","");
         }
         else if(this.bomberType == "Default")
         {
            Bomber.setItem(_bomber(mc),"Default","Default","");
         }
      }
      
      public function detonate() : void
      {
         var randomNumber:int = 0;
         var randomNumber2:int = 0;
         if(this.didIBlowUp)
         {
            this.comment = "no double detonate for u";
            trace("Bomber tried to detonate again.");
            this.didIBlowUp = false;
         }
         else if(this.bomberType == "minerTargeter")
         {
            team.game.soundManager.playSoundRandom("mediumExplosion",3,px,py);
            team.game.projectileManager.initPoisonPool(px,py,this,5);
            this.damage(0,this.maxHealth,null);
            team.game.projectileManager.initNuke(px,py,this,this.explosionDamage / 2);
            this.didIBlowUp = true;
         }
         else if(this.bomberType == "clusterBoi" && !this.detonated)
         {
            randomNumber = Math.floor(Math.random() * 4) + 3;
            randomNumber2 = Math.floor(Math.random() * 3) + 1;
            this.clusterLad = team.game.unitFactory.getUnit(Unit.U_BOMBER);
            team.spawn(this.clusterLad,team.game);
            this.clusterLad.px = px + 75;
            this.clusterLad.py = py;
            this.clusterLad.stun(randomNumber2 * 10);
            this.clusterLad.applyVelocity(-1 * randomNumber * Util.sgn(mc.scaleX));
            this.divider = "--------------------------------------------------------------------------";
            randomNumber = Math.floor(Math.random() * 4) + 3;
            randomNumber2 = Math.floor(Math.random() * 3) + 1;
            this.clusterLad = team.game.unitFactory.getUnit(Unit.U_BOMBER);
            team.spawn(this.clusterLad,team.game);
            this.clusterLad.px = px;
            this.clusterLad.py = py + 50;
            this.clusterLad.stun(randomNumber2 * 10);
            this.clusterLad.applyVelocity(-1 * randomNumber2 * Util.sgn(mc.scaleX));
            this.divider = "--------------------------------------------------------------------------";
            randomNumber = Math.floor(Math.random() * 4) + 3;
            randomNumber2 = Math.floor(Math.random() * 3) + 1;
            this.clusterLad = team.game.unitFactory.getUnit(Unit.U_BOMBER);
            team.spawn(this.clusterLad,team.game);
            this.clusterLad.px = px - 75;
            this.clusterLad.py = py;
            this.clusterLad.stun(randomNumber2 * 10);
            this.clusterLad.applyVelocity(1 * randomNumber * Util.sgn(mc.scaleX));
            team.game.soundManager.playSoundRandom("mediumExplosion",3,px,py);
            this.damage(0,this.maxHealth,null);
            team.game.projectileManager.initNuke(px,py,this,this.explosionDamage);
            team.population += 3;
            this.didIBlowUp = true;
         }
         else
         {
            team.game.soundManager.playSoundRandom("mediumExplosion",3,px,py);
            this.damage(0,this.maxHealth,null);
            team.game.projectileManager.initNuke(px,py,this,this.explosionDamage);
            this.didIBlowUp = true;
         }
      }
      
      override public function get damageToArmour() : Number
      {
         return _damageToArmour;
      }
      
      override public function get damageToNotArmour() : Number
      {
         return _damageToNotArmour;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         super.setActionInterface(a);
         a.setAction(0,0,UnitCommand.BOMBER_DETONATE);
      }
      
      override public function attack() : void
      {
         if(_state != S_ATTACK)
         {
            _state = S_ATTACK;
            hasHit = false;
         }
      }
      
      override public function mayAttack(target:Unit) : Boolean
      {
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
         if(_state == S_RUN)
         {
            if(Math.abs(px - target.px) < this.WEAPON_REACH && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
            {
               return true;
            }
         }
         return false;
      }
      
      public function aseSpeedUp() : void
      {
         this.timeToRun = true;
      }
      
      public function asePoisonNow() : void
      {
         this.poisonRN = true;
      }
      
      public function convertBomber(type:String) : void
      {
         this.bomberType = type;
      }
   }
}
