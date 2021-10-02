package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.NinjaAi;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.market.MarketItem;
   import flash.display.MovieClip;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   
   public class Ninja extends Unit
   {
      
      private static var WEAPON_REACH:int;
       
      
      private var _stealthSpellTimer:SpellCooldown;
      
      private var stealthSpellGlow:DropShadowFilter;
      
      private var isDash:Boolean;
      
      private var ninjaCopyDistance:Number;
      
      private var dontStealth:Boolean;
      
      private var ninjaStealthVelocity:Number;
      
      private var normalVelocity:Number;
      
      private var currentStacks:int;
      
      private var maxStacks:int;
      
      private var currentTarget:Unit;
      
      private var stackDamage:int;
      
      private var furyEffect:int;
      
      private var lastHitFrame:int;
      
      public function Ninja(game:StickWar)
      {
         super(game);
         _mc = new _ninja();
         this.init(game);
         addChild(_mc);
         ai = new NinjaAi(this);
         initSync();
         firstInit();
         this.dontStealth = true;
         this.ninjaCopyDistance = 1;
      }
      
      public static function setItemForMc(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         if(mc.ninjahead)
         {
            if(armor != "")
            {
               mc.ninjahead.gotoAndStop(armor);
            }
         }
         if(mc.ninjastaff)
         {
            if(weapon != "")
            {
               mc.ninjastaff.gotoAndStop(weapon);
            }
         }
         if(mc.ninjasword)
         {
            if(misc != "")
            {
               mc.ninjasword.gotoAndStop(misc);
            }
         }
         if(mc.weaponGroup)
         {
            if(mc.weaponGroup.ninjastaff)
            {
               if(weapon != "")
               {
                  mc.weaponGroup.ninjastaff.gotoAndStop(weapon);
               }
            }
            if(mc.weaponGroup.ninjasword)
            {
               if(misc != "")
               {
                  mc.weaponGroup.ninjasword.gotoAndStop(misc);
               }
            }
         }
      }
      
      public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         var m:_ninja = _ninja(mc);
         setItemForMc(m.mc,weapon,armor,misc);
         if(m.shadow1)
         {
            setItemForMc(m.shadow1,weapon,armor,misc);
         }
         if(m.shadow2)
         {
            setItemForMc(m.shadow2,weapon,armor,misc);
         }
      }
      
      override public function weaponReach() : Number
      {
         return WEAPON_REACH;
      }
      
      override public function init(game:StickWar) : void
      {
         initBase();
         this._stealthSpellTimer = new SpellCooldown(game.xml.xml.Order.Units.ninja.stealth.effect,game.xml.xml.Order.Units.ninja.stealth.cooldown,game.xml.xml.Order.Units.ninja.stealthMana);
         WEAPON_REACH = game.xml.xml.Order.Units.ninja.weaponReach;
         population = game.xml.xml.Order.Units.ninja.population;
         _mass = game.xml.xml.Order.Units.ninja.mass;
         _maxForce = game.xml.xml.Order.Units.ninja.maxForce;
         _dragForce = game.xml.xml.Order.Units.ninja.dragForce;
         _scale = game.xml.xml.Order.Units.ninja.scale;
         _maxVelocity = this.normalVelocity = game.xml.xml.Order.Units.ninja.maxVelocity;
         this.createTime = game.xml.xml.Order.Units.ninja.cooldown;
         this.ninjaCopyDistance = game.xml.xml.Order.Units.ninja.ninjaCopyDistance;
         loadDamage(game.xml.xml.Order.Units.ninja);
         maxHealth = health = game.xml.xml.Order.Units.ninja.health;
         this.maxStacks = game.xml.xml.Order.Units.ninja.fury.stacks;
         this.stackDamage = game.xml.xml.Order.Units.ninja.fury.bonus;
         this.furyEffect = game.xml.xml.Order.Units.ninja.fury.furyEffect;
         this.currentStacks = 0;
         this.currentTarget = null;
         this.lastHitFrame = 0;
         this.ninjaStealthVelocity = game.xml.xml.Order.Units.ninja.stealth.maxVelocity;
         this.stealthSpellGlow = new DropShadowFilter();
         this.stealthSpellGlow.knockout = true;
         this.stealthSpellGlow.angle = 0;
         this.stealthSpellGlow.distance = 0;
         this.stealthSpellGlow.color = 0;
         type = Unit.U_NINJA;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.isDash = true;
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["BarracksBuilding"];
      }
      
      override public function getDamageToDeal() : Number
      {
         return damageToDeal;
      }
      
      public function stealthCooldown() : Number
      {
         return this._stealthSpellTimer.cooldown();
      }
      
      public function stealth() : void
      {
         if(team.tech.isResearched(Tech.CLOAK))
         {
            if(this._stealthSpellTimer.spellActivate(team))
            {
               this.dontStealth = false;
               team.game.soundManager.playSound("ninjaCloakSound",px,py);
            }
         }
      }
      
      override protected function checkForHit() : Boolean
      {
         var poisonDamage:Number = NaN;
         var target:Unit = ai.getClosestTarget();
         if(target == null)
         {
            return false;
         }
         var dir:int = Util.sgn(target.px - px);
         if(_mc.mc.tip == null)
         {
            return false;
         }
         var p2:Point = MovieClip(_mc.mc.tip).localToGlobal(new Point(0,0));
         if(target.checkForHitPoint(p2,target))
         {
            if(this.currentTarget != target || team.game.frame - this.lastHitFrame > this.furyEffect)
            {
               this.currentStacks = 0;
            }
            if(this.currentStacks > this.maxStacks)
            {
               this.currentStacks = this.maxStacks;
            }
            if(target is Statue)
            {
               target.damage(0,this.stackDamage * this.currentStacks + _damageToArmour,null);
            }
            else if(target.isArmoured)
            {
               target.damage(0,this.stackDamage * this.currentStacks + this.damageToArmour,null);
            }
            else
            {
               target.damage(0,this.stackDamage * this.currentStacks + this.damageToNotArmour,null);
            }
            poisonDamage = 0;
            if(team.tech.isResearched(Tech.CLOAK_II))
            {
               poisonDamage = team.game.xml.xml.Order.Units.ninja.stealth.poison2;
            }
            else if(team.tech.isResearched(Tech.CLOAK))
            {
               poisonDamage = team.game.xml.xml.Order.Units.ninja.stealth.poison;
            }
            if(!this.dontStealth)
            {
               target.poison(poisonDamage);
            }
            ++this.currentStacks;
            this.lastHitFrame = team.game.frame;
            this.currentTarget = target;
            return true;
         }
         return false;
      }
      
      override public function update(game:StickWar) : void
      {
         this._stealthSpellTimer.update();
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
            else if(this.isDash && _state == S_RUN)
            {
               if(Math.abs(_dx) + Math.abs(_dy) > 1)
               {
                  if(!this.dontStealth)
                  {
                     _mc.gotoAndStop("stealth");
                     this._maxVelocity = this.ninjaStealthVelocity;
                  }
                  else
                  {
                     _mc.gotoAndStop("run");
                     if(_mc.shadow1 && _mc.shadow2)
                     {
                        _mc.shadow1.x = _mc.mc.x - Math.abs(dx) * 10 * this.ninjaCopyDistance;
                        _mc.shadow2.x = _mc.mc.x - Math.abs(dx) * 20 * this.ninjaCopyDistance;
                        _mc.shadow1.y = _mc.mc.y - dy * 5 * this.ninjaCopyDistance;
                        _mc.shadow2.y = _mc.mc.y - dy * 10 * this.ninjaCopyDistance;
                     }
                     this._maxVelocity = this.normalVelocity;
                  }
               }
               else
               {
                  _mc.gotoAndStop("stand");
               }
            }
            else if(_state == S_RUN)
            {
               if(Math.abs(_dx) + Math.abs(_dy) > 0.1)
               {
                  if(this._stealthSpellTimer.inEffect())
                  {
                     _mc.gotoAndStop("stealth");
                     this._maxVelocity = this.ninjaStealthVelocity;
                  }
                  else
                  {
                     _mc.gotoAndStop("run");
                     this._maxVelocity = this.normalVelocity;
                  }
               }
               else
               {
                  _mc.gotoAndStop("stand");
               }
            }
            else if(_state == S_ATTACK)
            {
               if(mc.mc.swing != null)
               {
                  team.game.soundManager.playSoundRandom("ninjaSwipe",4,px,py);
               }
               if(!hasHit)
               {
                  hasHit = this.checkForHit();
                  if(hasHit)
                  {
                     this.dontStealth = true;
                     game.soundManager.playSound("sword1",px,py);
                  }
               }
               if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = S_RUN;
                  this.dontStealth = true;
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
         if(!(isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames))
         {
            Util.animateMovieClip(_mc);
         }
         if(!this._stealthSpellTimer.inEffect())
         {
            this.dontStealth = true;
         }
         if(!this.dontStealth)
         {
            mc.filters = [this.stealthSpellGlow];
            mc.mc.alpha = 1;
         }
         else
         {
            mc.filters = [];
            mc.mc.alpha = 1;
         }
         if(!hasDefaultLoadout)
         {
            Ninja.setItem(_ninja(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
         }
      }
      
      override public function isTargetable() : Boolean
      {
         return !isDead && !isDieing && !this._isDualing && this.dontStealth;
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         super.setActionInterface(a);
         a.setAction(2,0,UnitCommand.NINJA_STACK);
         if(team.tech.isResearched(Tech.CLOAK))
         {
            a.setAction(0,0,UnitCommand.STEALTH);
         }
      }
      
      override public function get damageToArmour() : Number
      {
         var assasinateDamage:Number = NaN;
         if(!this.dontStealth)
         {
            assasinateDamage = 0;
            if(team.tech.isResearched(Tech.CLOAK_II))
            {
               assasinateDamage = team.game.xml.xml.Order.Units.ninja.stealth.damageToArmour2;
            }
            else if(team.tech.isResearched(Tech.CLOAK))
            {
               assasinateDamage = team.game.xml.xml.Order.Units.ninja.stealth.damageToArmour;
            }
            return _damageToArmour + int(assasinateDamage);
         }
         return _damageToArmour;
      }
      
      override public function get damageToNotArmour() : Number
      {
         var assasinateDamage:Number = NaN;
         if(!this.dontStealth)
         {
            assasinateDamage = 0;
            if(team.tech.isResearched(Tech.CLOAK_II))
            {
               assasinateDamage = team.game.xml.xml.Order.Units.ninja.stealth.damageToNotArmour2;
            }
            else if(team.tech.isResearched(Tech.CLOAK))
            {
               assasinateDamage = team.game.xml.xml.Order.Units.ninja.stealth.damageToNotArmour;
            }
            return _damageToNotArmour + int(assasinateDamage);
         }
         return _damageToNotArmour;
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
            framesInAttack = MovieClip(_mc.mc).totalFrames;
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
