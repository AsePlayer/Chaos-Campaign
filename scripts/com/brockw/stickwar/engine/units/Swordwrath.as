package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.SwordwrathAi;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.market.MarketItem;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   
   public class Swordwrath extends Unit
   {
      
      private static var WEAPON_REACH:int;
      
      private static var RAGE_COOLDOWN:int;
      
      private static var RAGE_EFFECT:int;
       
      
      private var healthLoss:int;
      
      private var damageIncrease:Number;
      
      private var rageSpell:com.brockw.stickwar.engine.units.SpellCooldown;
      
      private var rageSpellGlow:GlowFilter;
      
      private var normalMaxVelocity:Number;
      
      private var rageMaxVelocity:Number;
      
      private var lastWasStanding:Boolean;
      
      public var isMinion:Boolean = false;
      
      public function Swordwrath(game:StickWar)
      {
         super(game);
         _mc = new _swordwrath();
         this.init(game);
         addChild(_mc);
         ai = new SwordwrathAi(this);
         initSync();
         firstInit();
         this.rageSpellGlow = new GlowFilter();
         this.rageSpellGlow.color = 16711680;
         this.rageSpellGlow.blurX = 10;
         this.rageSpellGlow.blurY = 10;
         this.lastWasStanding = false;
         name = "Swordwrath";
      }
      
      public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         var m:_swordwrath = _swordwrath(mc);
         if(m.mc.sword)
         {
            if(weapon != "")
            {
               m.mc.sword.gotoAndStop(weapon);
            }
         }
      }
      
      override public function weaponReach() : Number
      {
         return WEAPON_REACH;
      }
      
      override public function init(game:StickWar) : void
      {
         initBase();
         WEAPON_REACH = game.xml.xml.Order.Units.swordwrath.weaponReach;
         population = game.xml.xml.Order.Units.swordwrath.population;
         RAGE_COOLDOWN = game.xml.xml.Order.Units.swordwrath.rage.cooldown;
         RAGE_EFFECT = game.xml.xml.Order.Units.swordwrath.rage.effect;
         this.healthLoss = game.xml.xml.Order.Units.swordwrath.rage.healthLoss;
         this.damageIncrease = game.xml.xml.Order.Units.swordwrath.rage.damageIncrease;
         _mass = game.xml.xml.Order.Units.swordwrath.mass;
         _maxForce = game.xml.xml.Order.Units.swordwrath.maxForce;
         _dragForce = game.xml.xml.Order.Units.swordwrath.dragForce;
         _scale = game.xml.xml.Order.Units.swordwrath.scale;
         _maxVelocity = game.xml.xml.Order.Units.swordwrath.maxVelocity;
         damageToDeal = game.xml.xml.Order.Units.swordwrath.baseDamage;
         this.createTime = game.xml.xml.Order.Units.swordwrath.cooldown;
         maxHealth = health = game.xml.xml.Order.Units.swordwrath.health;
         loadDamage(game.xml.xml.Order.Units.swordwrath);
         type = Unit.U_SWORDWRATH;
         this.normalMaxVelocity = _maxVelocity;
         this.rageMaxVelocity = game.xml.xml.Order.Units.swordwrath.rage.rageMaxVelocity;
         this.rageSpell = new com.brockw.stickwar.engine.units.SpellCooldown(RAGE_EFFECT,RAGE_COOLDOWN,game.xml.xml.Order.Units.swordwrath.rage.mana);
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
      
      override public function getDamageToDeal() : Number
      {
         if(this.rageSpell.inEffect())
         {
            return 2 * damageToDeal;
         }
         return damageToDeal;
      }
      
      override public function update(game:StickWar) : void
      {
         var currentLabel:String = null;
         this.rageSpell.update();
         updateCommon(game);
         if(this.rageSpell.inEffect())
         {
            this.rageSpellGlow.blurX = 9 + 6 * Util.sin(20 * Math.PI * this.rageSpell.timeRunning() / RAGE_EFFECT);
            this.rageSpellGlow.blurY = 10;
            this.mc.filters = [this.rageSpellGlow];
            _maxVelocity = this.rageMaxVelocity;
         }
         else
         {
            this.mc.filters = [];
            _maxVelocity = this.normalMaxVelocity;
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
               if(!this.isMinion && !this.rageSpell.inEffect() && team.tech.isResearched(Tech.SWORDWRATH_RAGE) && this.rageCooldown() <= 0 && this.health <= this.maxHealth / 2)
               {
                  this.rageSpell.spellActivate(team);
                  this.heal(1,20);
                  team.game.soundManager.playSoundRandom("Rage",3,px,py);
               }
               if(isFeetMoving())
               {
                  _mc.gotoAndStop("run");
               }
               else
               {
                  currentLabel = _mc.currentFrameLabel;
                  if(!(currentLabel == "stand" || currentLabel == "stand_breath"))
                  {
                     if(game.random.nextNumber() < 0.1)
                     {
                        _mc.gotoAndStop("stand");
                     }
                     else
                     {
                        _mc.gotoAndStop("stand_breath");
                     }
                  }
               }
            }
            else if(_state == S_ATTACK)
            {
               if(!this.rageSpell.inEffect() && team.tech.isResearched(Tech.SWORDWRATH_RAGE) && this.rageCooldown() <= 0)
               {
                  this.rageSpell.spellActivate(team);
                  this.heal(5,4);
                  team.game.soundManager.playSoundRandom("Rage",3,px,py);
               }
               if(mc.mc.swing != null)
               {
                  team.game.soundManager.playSound("swordwrathSwing1",px,py);
               }
               if(!hasHit)
               {
                  hasHit = this.checkForHit();
               }
               if(this.rageSpell.inEffect())
               {
                  MovieClip(_mc.mc).nextFrame();
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
               _mc.gotoAndStop(this.getDeathLabel(game));
               this.team.removeUnit(this,game);
               isDead = true;
            }
         }
         if(isDead || _isDualing)
         {
            Util.animateMovieClip(_mc,0);
         }
         else
         {
            if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
            {
               MovieClip(_mc.mc).gotoAndStop(1);
            }
            MovieClip(_mc.mc).nextFrame();
         }
         if(!hasDefaultLoadout)
         {
            Swordwrath.setItem(_swordwrath(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),"","");
         }
      }
      
      override protected function getDeathLabel(game:StickWar) : String
      {
         if(arrowDeath)
         {
            return "arrow_death";
         }
         if(isOnFire)
         {
            return "fireDeath";
         }
         if(stoned)
         {
            return "stone";
         }
         var id:int = team.game.random.nextInt() % this._deathLabels.length;
         return "death_" + this._deathLabels[id];
      }
      
      override public function get damageToArmour() : Number
      {
         if(this.rageSpell.inEffect())
         {
            return _damageToArmour + this.damageIncrease;
         }
         return _damageToArmour;
      }
      
      override public function get damageToNotArmour() : Number
      {
         if(this.rageSpell.inEffect())
         {
            return _damageToNotArmour + this.damageIncrease;
         }
         return _damageToNotArmour;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         super.setActionInterface(a);
         if(team.tech.isResearched(Tech.SWORDWRATH_RAGE))
         {
            a.setAction(0,0,UnitCommand.SWORDWRATH_RAGE);
         }
      }
      
      public function rageCooldown() : Number
      {
         return this.rageSpell.cooldown();
      }
      
      public function rage() : void
      {
         if(health > 10 && team.tech.isResearched(Tech.SWORDWRATH_RAGE))
         {
            if(this.rageSpell.spellActivate(team))
            {
               health -= this.healthLoss;
               team.game.soundManager.playSoundRandom("Rage",3,px,py);
            }
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
            attackStartFrame = team.game.frame;
            if(this.rageSpell.inEffect())
            {
               framesInAttack = MovieClip(_mc.mc).totalFrames / 2;
            }
            else
            {
               framesInAttack = MovieClip(_mc.mc).totalFrames;
            }
         }
      }
      
      override public function mayAttack(target:Unit) : Boolean
      {
         if(framesInAttack > team.game.frame - attackStartFrame)
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
         if(_state == S_RUN)
         {
            if(Math.abs(px - target.px) < WEAPON_REACH && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
            {
               return true;
            }
         }
         return false;
      }
   }
}
