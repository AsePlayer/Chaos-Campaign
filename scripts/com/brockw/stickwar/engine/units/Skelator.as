package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.SkelatorAi;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.market.MarketItem;
   import flash.display.MovieClip;
   
   public class Skelator extends com.brockw.stickwar.engine.units.Unit
   {
       
      
      private var WEAPON_REACH:Number;
      
      private var fistAttackSpell:com.brockw.stickwar.engine.units.SpellCooldown;
      
      private var reaperSpell:com.brockw.stickwar.engine.units.SpellCooldown;
      
      private var isFistAttacking:Boolean;
      
      private var isReaperSpell:Boolean;
      
      private var spellX:Number;
      
      private var spellY:Number;
      
      private var target:com.brockw.stickwar.engine.units.Unit;
      
      private var _fistDamage:Number;
      
      public var marrowkaiGeneralDontCast:Boolean = false;
      
      public var isBossMarrow:Boolean;
      
      public var canCastReap:Boolean = true;
      
      public var canCastFists:Boolean = true;
      
      public function Skelator(game:StickWar)
      {
         super(game);
         _mc = new _skelator();
         this.init(game);
         addChild(_mc);
         ai = new SkelatorAi(this);
         initSync();
         firstInit();
      }
      
      public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         var m:_skelator = _skelator(mc);
         if(Boolean(m.mc.skullhead))
         {
            if(armor != "")
            {
               m.mc.skullhead.gotoAndStop(armor);
            }
         }
         if(Boolean(m.mc.skullstaff))
         {
            if(weapon != "")
            {
               m.mc.skullstaff.gotoAndStop(weapon);
            }
         }
      }
      
      override public function weaponReach() : Number
      {
         return this.WEAPON_REACH;
      }
      
      override public function init(game:StickWar) : void
      {
         initBase();
         this.WEAPON_REACH = game.xml.xml.Chaos.Units.skelator.weaponReach;
         population = game.xml.xml.Chaos.Units.skelator.population;
         _mass = game.xml.xml.Chaos.Units.skelator.mass;
         _maxForce = game.xml.xml.Chaos.Units.skelator.maxForce;
         _dragForce = game.xml.xml.Chaos.Units.skelator.dragForce;
         _scale = game.xml.xml.Chaos.Units.skelator.scale;
         _maxVelocity = game.xml.xml.Chaos.Units.skelator.maxVelocity;
         damageToDeal = game.xml.xml.Chaos.Units.skelator.baseDamage;
         this.createTime = game.xml.xml.Chaos.Units.skelator.cooldown;
         maxHealth = health = game.xml.xml.Chaos.Units.skelator.health;
         this.fistDamage = game.xml.xml.Chaos.Units.skelator.fist.damage;
         loadDamage(game.xml.xml.Chaos.Units.skelator);
         type = com.brockw.stickwar.engine.units.Unit.U_SKELATOR;
         this.isFistAttacking = false;
         this.isReaperSpell = false;
         this.spellX = this.spellY = 0;
         this.fistAttackSpell = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Chaos.Units.skelator.fist.effect,game.xml.xml.Chaos.Units.skelator.fist.cooldown,game.xml.xml.Chaos.Units.skelator.fist.mana);
         this.reaperSpell = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Chaos.Units.skelator.reaper.effect,game.xml.xml.Chaos.Units.skelator.reaper.cooldown,game.xml.xml.Chaos.Units.skelator.reaper.mana);
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.healthBar.y = -mc.mc.height * 1.1;
         this.target = null;
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["UndeadBuilding"];
      }
      
      override public function update(game:StickWar) : void
      {
         var num:int = 0;
         this.fistAttackSpell.update();
         this.reaperSpell.update();
         updateCommon(game);
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
            else if(this.isFistAttacking)
            {
               _mc.gotoAndStop("fistAttack");
               num = (_mc.mc.currentFrame - 27) / 5;
               if(_mc.mc.currentFrame >= 27 && (_mc.mc.currentFrame - 27) % 5 == 0 && num < 6)
               {
                  game.projectileManager.initFistAttack(this.spellX,this.spellY,this,num);
               }
               if(_mc.mc.currentFrame == _mc.mc.totalFrames)
               {
                  _state = S_RUN;
                  this.isFistAttacking = false;
               }
            }
            else if(this.isReaperSpell)
            {
               _mc.gotoAndStop("reaperAttack");
               if(_mc.mc.currentFrame == 42)
               {
                  game.projectileManager.initReaper(this,this.target);
               }
               if(_mc.mc.currentFrame == _mc.mc.totalFrames)
               {
                  _state = S_RUN;
                  this.isReaperSpell = false;
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
               if(!hasHit)
               {
                  hasHit = this.checkForHit();
               }
               if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = S_RUN;
               }
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
               _mc.gotoAndStop(getDeathLabel(game));
               this.team.removeUnit(this,game);
               isDead = true;
            }
         }
         Util.animateMovieClip(mc);
         if(!hasDefaultLoadout)
         {
            Skelator.setItem(_skelator(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
         }
      }
      
      override public function stateFixForCutToWalk() : void
      {
         if(!this.isFistAttacking && !this.isReaperSpell)
         {
            super.stateFixForCutToWalk();
            this.isFistAttacking = false;
            this.isReaperSpell = false;
         }
      }
      
      public function fistAttackCooldown() : Number
      {
         if(!canCastFists)
         {
            return 900;
         }
         return this.fistAttackSpell.cooldown();
      }
      
      public function reaperCooldown() : Number
      {
         if(!canCastReap)
         {
            return 900;
         }
         return this.reaperSpell.cooldown();
      }
      
      override public function isBusy() : Boolean
      {
         return !this.notInSpell() || isBusyForSpell;
      }
      
      private function notInSpell() : Boolean
      {
         return !this.isFistAttacking && !this.isReaperSpell;
      }
      
      public function fistAttack(x:Number, y:Number) : void
      {
         if(!team.tech.isResearched(Tech.SKELETON_FIST_ATTACK))
         {
            return;
         }
         if(this.notInSpell() && this.fistAttackSpell.spellActivate(this.team))
         {
            this.spellX = x;
            this.spellY = y;
            forceFaceDirection(this.spellX - this.px);
            this.isFistAttacking = true;
            hasHit = false;
            _state = S_ATTACK;
            team.game.soundManager.playSound("skeltalFistsSound",px,py);
         }
      }
      
      public function reaperAttack(unit:com.brockw.stickwar.engine.units.Unit) : void
      {
         if(unit != null && unit.isAlive())
         {
            if(this.notInSpell() && this.reaperSpell.spellActivate(this.team))
            {
               this.target = unit;
               forceFaceDirection(this.target.px - px);
               this.isReaperSpell = true;
               hasHit = false;
               _state = S_ATTACK;
               team.game.soundManager.playSound("skeletalReaperSound",px,py);
            }
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
         a.setAction(0,0,UnitCommand.REAPER);
         if(team.tech.isResearched(Tech.SKELETON_FIST_ATTACK))
         {
            a.setAction(1,0,UnitCommand.FIST_ATTACK);
         }
      }
      
      override public function attack() : void
      {
         var id:int = 0;
         if(_state != S_ATTACK)
         {
            id = team.game.random.nextInt() % this._attackLabels.length;
            _mc.gotoAndStop("attack_" + this._attackLabels[id]);
            MovieClip(_mc.mc).gotoAndStop(1);
            _state = S_ATTACK;
            hasHit = false;
         }
      }
      
      override public function mayAttack(target:com.brockw.stickwar.engine.units.Unit) : Boolean
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
      
      public function get fistDamage() : Number
      {
         return this._fistDamage;
      }
      
      public function set fistDamage(value:Number) : void
      {
         this._fistDamage = value;
      }
   }
}
