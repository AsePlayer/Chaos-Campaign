package com.brockw.stickwar.engine.units
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.Ai.*;
     import com.brockw.stickwar.engine.Ai.command.*;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.*;
     import com.brockw.stickwar.market.MarketItem;
     import flash.display.MovieClip;
     
     public class Magikill extends Unit
     {
          
          private static var WEAPON_REACH:int;
           
          
          private var stunSpellCooldown:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var nukeSpellCooldown:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var poisonDartSpellCooldown:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var isStunning:Boolean;
          
          private var isNuking:Boolean;
          
          private var isPoisonDarting:Boolean;
          
          private var spellX:Number;
          
          private var spellY:Number;
          
          private var explosionDamage:Number;
          
          public function Magikill(game:StickWar)
          {
               super(game);
               _mc = new _magikill();
               this.init(game);
               addChild(_mc);
               ai = new MagikillAi(this);
               initSync();
               firstInit();
               healthBar.y = -pheight * 1;
               name = "The Magikill";
          }
          
          public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
          {
               var m:_magikill = _magikill(mc);
               if(Boolean(m.mc.wizhat))
               {
                    if(armor != "")
                    {
                         m.mc.wizhat.gotoAndStop(armor);
                    }
               }
               if(Boolean(m.mc.wizstaff))
               {
                    if(weapon != "")
                    {
                         m.mc.wizstaff.gotoAndStop(weapon);
                    }
               }
               if(Boolean(m.mc.wizbeard))
               {
                    if(misc != "")
                    {
                         m.mc.wizbeard.gotoAndStop(misc);
                    }
               }
          }
          
          override public function weaponReach() : Number
          {
               return WEAPON_REACH;
          }
          
          override public function playDeathSound() : void
          {
               team.game.soundManager.playSound("MagikillDeath",px,py);
          }
          
          override public function init(game:StickWar) : void
          {
               initBase();
               WEAPON_REACH = game.xml.xml.Order.Units.magikill.weaponReach;
               population = game.xml.xml.Order.Units.magikill.population;
               _mass = game.xml.xml.Order.Units.magikill.mass;
               _maxForce = game.xml.xml.Order.Units.magikill.maxForce;
               _dragForce = game.xml.xml.Order.Units.magikill.dragForce;
               _scale = game.xml.xml.Order.Units.magikill.scale;
               _maxVelocity = game.xml.xml.Order.Units.magikill.maxVelocity;
               this.explosionDamage = game.xml.xml.Order.Units.magikill.nuke.damage;
               this.createTime = game.xml.xml.Order.Units.magikill.cooldown;
               maxHealth = health = game.xml.xml.Order.Units.magikill.health;
               loadDamage(game.xml.xml.Order.Units.magikill);
               type = Unit.U_MAGIKILL;
               _mc.stop();
               _mc.width *= _scale;
               _mc.height *= _scale;
               _state = S_RUN;
               MovieClip(_mc.mc.gotoAndPlay(1));
               MovieClip(_mc.gotoAndStop(1));
               drawShadow();
               this.stunSpellCooldown = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Order.Units.magikill.electricWall.effect,game.xml.xml.Order.Units.magikill.electricWall.cooldown,game.xml.xml.Order.Units.magikill.electricWall.mana);
               this.nukeSpellCooldown = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Order.Units.magikill.nuke.effect,game.xml.xml.Order.Units.magikill.nuke.cooldown,game.xml.xml.Order.Units.magikill.nuke.mana);
               this.poisonDartSpellCooldown = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Order.Units.magikill.poisonSpray.effect,game.xml.xml.Order.Units.magikill.poisonSpray.cooldown,game.xml.xml.Order.Units.magikill.poisonSpray.mana);
               this.isNuking = false;
               this.isStunning = false;
               this.isPoisonDarting = false;
          }
          
          override public function setBuilding() : void
          {
               building = team.buildings["MagicGuildBuilding"];
          }
          
          override public function getDamageToDeal() : Number
          {
               return damageToDeal;
          }
          
          override public function update(game:StickWar) : void
          {
               this.stunSpellCooldown.update();
               this.nukeSpellCooldown.update();
               this.poisonDartSpellCooldown.update();
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
                    else if(this.isNuking == true)
                    {
                         _mc.gotoAndStop("attack_1");
                         if(MovieClip(_mc.mc).currentFrame == 36 && !hasHit)
                         {
                              game.soundManager.playSoundRandom("mediumExplosion",3,this.spellX,this.spellY);
                              game.projectileManager.initNuke(this.spellX,this.spellY,this,this.explosionDamage);
                              hasHit = true;
                         }
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              this.isNuking = false;
                              _state = S_RUN;
                         }
                    }
                    else if(this.isStunning == true)
                    {
                         _mc.gotoAndStop("electricAttack");
                         if(MovieClip(_mc.mc).currentFrame == 47 && !hasHit)
                         {
                              game.soundManager.playSound("electricWall",this.spellX,this.spellY);
                              game.projectileManager.initStun(this.spellX,this.spellY,game.xml.xml.Order.Units.magikill.electricWallDamage,this);
                              hasHit = true;
                         }
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              this.isStunning = false;
                              _state = S_RUN;
                         }
                    }
                    else if(this.isPoisonDarting == true)
                    {
                         _mc.gotoAndStop("poisonAttack");
                         if(MovieClip(_mc.mc).currentFrame == 44 && !hasHit)
                         {
                              game.soundManager.playSound("AcidSpraySound",px,py);
                              game.projectileManager.initPoisonSpray(this.spellX,this.spellY,this);
                              hasHit = true;
                         }
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              this.isPoisonDarting = false;
                              _state = S_RUN;
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
               if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                    MovieClip(_mc.mc).gotoAndStop(1);
               }
               Util.animateMovieClip(_mc,0);
               if(mc.mc.wizhat != null)
               {
                    mc.mc.wizhat.gotoAndStop(1);
               }
               if(mc.mc.wizstaff != null)
               {
                    mc.mc.wizstaff.gotoAndStop(1);
                    if(mc.mc.wizstaff.fireloopwizstaff != null)
                    {
                         mc.mc.wizstaff.fireloopwizstaff.nextFrame();
                         if(mc.mc.wizstaff.fireloopwizstaff.currentFrame == mc.mc.wizstaff.fireloopwizstaff.totalFrames)
                         {
                              mc.mc.wizstaff.fireloopwizstaff.gotoAndStop(1);
                         }
                    }
               }
               if(!hasDefaultLoadout)
               {
                    Magikill.setItem(_magikill(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
               }
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               super.setActionInterface(a);
               a.setAction(0,0,UnitCommand.NUKE);
               if(team.tech.isResearched(Tech.MAGIKILL_POISON))
               {
                    a.setAction(1,0,UnitCommand.POISON_DART);
               }
               if(team.tech.isResearched(Tech.MAGIKILL_WALL))
               {
                    a.setAction(2,0,UnitCommand.STUN);
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
          
          override public function isBusy() : Boolean
          {
               return !this.notInSpell() || isBusyForSpell;
          }
          
          private function notInSpell() : Boolean
          {
               return !this.isPoisonDarting && !this.isStunning && !this.isNuking;
          }
          
          public function poisonDartSpell(x:Number, y:Number) : void
          {
               if(!team.tech.isResearched(Tech.MAGIKILL_POISON))
               {
                    return;
               }
               if(this.notInSpell() && this.poisonDartSpellCooldown.spellActivate(this.team))
               {
                    this.spellX = x;
                    this.spellY = y;
                    forceFaceDirection(this.spellX - this.px);
                    this.isPoisonDarting = true;
                    hasHit = false;
                    _state = S_ATTACK;
                    team.game.soundManager.playSound("wizardPoisonSound",px,py);
               }
          }
          
          public function nukeSpell(x:Number, y:Number) : void
          {
               if(this.notInSpell() && this.nukeSpellCooldown.spellActivate(this.team))
               {
                    this.spellX = x;
                    forceFaceDirection(this.spellX - this.px);
                    this.spellY = y;
                    this.isNuking = true;
                    hasHit = false;
                    _state = S_ATTACK;
                    _mc.gotoAndStop("attack_1");
                    MovieClip(_mc.mc).gotoAndStop(1);
                    team.game.soundManager.playSound("fulminateSound",px,py);
               }
          }
          
          public function stunSpell(x:Number, y:Number) : void
          {
               if(!team.tech.isResearched(Tech.MAGIKILL_WALL))
               {
                    return;
               }
               if(this.notInSpell() && this.stunSpellCooldown.spellActivate(this.team))
               {
                    this.spellX = x;
                    forceFaceDirection(this.spellX - this.px);
                    this.spellY = y;
                    this.isStunning = true;
                    hasHit = false;
                    _state = S_ATTACK;
                    team.game.soundManager.playSound("electricWallSound",px,py);
               }
          }
          
          public function stunCooldown() : Number
          {
               return this.stunSpellCooldown.cooldown();
          }
          
          public function nukeCooldown() : Number
          {
               return this.nukeSpellCooldown.cooldown();
          }
          
          public function poisonDartCooldown() : Number
          {
               return this.poisonDartSpellCooldown.cooldown();
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
                    if(Math.abs(px - target.px) < WEAPON_REACH && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
                    {
                         return true;
                    }
               }
               return false;
          }
          
          override public function stateFixForCutToWalk() : void
          {
               if(!this.isStunning && !this.isNuking && !this.isPoisonDarting)
               {
                    super.stateFixForCutToWalk();
                    this.isStunning = false;
                    this.isNuking = false;
                    this.isPoisonDarting = false;
               }
          }
     }
}
