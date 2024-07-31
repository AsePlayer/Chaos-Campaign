package com.brockw.stickwar.engine.units
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.Ai.MonkAi;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Tech;
     import flash.display.MovieClip;
     import flash.geom.Point;
     
     public class Monk extends com.brockw.stickwar.engine.units.Unit
     {
          
          private static var WEAPON_REACH:int;
           
          
          public var isGay:Boolean = false;
          
          public var protecting:com.brockw.stickwar.engine.units.Unit;
          
          private var cureSpellCooldown:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var healSpellCooldown:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var slowSpellCooldown:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var isCuring:Boolean;
          
          private var isHealing:Boolean;
          
          private var isSlowing:Boolean;
          
          private var isShielding:Boolean;
          
          private var spellX:Number;
          
          private var spellY:Number;
          
          private var _isCureToggled:Boolean;
          
          private var cureTarget:com.brockw.stickwar.engine.units.Unit;
          
          private var _healAmount:Number;
          
          private var _healDuration:Number;
          
          private var _isHealToggled:Boolean;
          
          private var healTarget:com.brockw.stickwar.engine.units.Unit;
          
          public function Monk(game:StickWar)
          {
               super(game);
               _mc = new _cleric();
               this.init(game);
               addChild(_mc);
               ai = new MonkAi(this);
               initSync();
               firstInit();
               name = "Merics";
          }
          
          public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
          {
               var m:_cleric = _cleric(mc);
               if(m.mc.clericwand)
               {
                    if(weapon != "")
                    {
                         m.mc.clericwand.gotoAndStop(weapon);
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
               WEAPON_REACH = game.xml.xml.Order.Units.magikill.weaponReach;
               population = game.xml.xml.Order.Units.monk.population;
               _mass = game.xml.xml.Order.Units.monk.mass;
               _maxForce = game.xml.xml.Order.Units.monk.maxForce;
               _dragForce = game.xml.xml.Order.Units.monk.dragForce;
               _scale = game.xml.xml.Order.Units.monk.scale;
               _maxVelocity = game.xml.xml.Order.Units.monk.maxVelocity;
               damageToDeal = game.xml.xml.Order.Units.monk.baseDamage;
               this.createTime = game.xml.xml.Order.Units.monk.cooldown;
               loadDamage(game.xml.xml.Order.Units.monk);
               maxHealth = health = game.xml.xml.Order.Units.monk.health;
               this._healAmount = game.xml.xml.Order.Units.monk.heal.amount;
               this._healDuration = game.xml.xml.Order.Units.monk.heal.duration;
               type = com.brockw.stickwar.engine.units.Unit.U_MONK;
               _mc.stop();
               _mc.width *= _scale;
               _mc.height *= _scale;
               _state = S_RUN;
               MovieClip(_mc.mc.gotoAndPlay(1));
               MovieClip(_mc.gotoAndStop(1));
               drawShadow();
               this.healSpellCooldown = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Order.Units.monk.heal.effect,game.xml.xml.Order.Units.monk.heal.cooldown,game.xml.xml.Order.Units.monk.heal.mana);
               this.cureSpellCooldown = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Order.Units.monk.cure.effect,game.xml.xml.Order.Units.monk.cure.cooldown,game.xml.xml.Order.Units.monk.cure.mana);
               this.slowSpellCooldown = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Order.Units.monk.slow.effect,game.xml.xml.Order.Units.monk.slow.cooldown,game.xml.xml.Order.Units.monk.slow.mana);
               this.isCuring = false;
               this.isHealing = false;
               this.isShielding = false;
               this.cureTarget = null;
               this.healTarget = null;
               this._isCureToggled = true;
               this._isHealToggled = true;
          }
          
          override public function setBuilding() : void
          {
               building = team.buildings["TempleBuilding"];
          }
          
          override public function getDamageToDeal() : Number
          {
               return damageToDeal;
          }
          
          override public function update(game:StickWar) : void
          {
               var target:com.brockw.stickwar.engine.units.Unit = null;
               var p:Point = null;
               this.healSpellCooldown.update();
               this.cureSpellCooldown.update();
               this.slowSpellCooldown.update();
               updateCommon(game);
               if(!this.protecting || this.protecting.isDead || this.protecting.team != team || this.protecting.backgroundFighter)
               {
                    isProtected = false;
                    this.protecting = null;
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
                    else if(this.isHealing == true)
                    {
                         _mc.gotoAndStop("attack_1");
                         if(MovieClip(_mc.mc).currentFrame == 25 && !hasHit)
                         {
                              if(this.healTarget != null)
                              {
                                   this.healTarget.heal(this.healAmount,this.healDuration);
                                   if(!this.protecting && this.healTarget.isMinion == false && this.healTarget.type != type && this.healTarget.isProtected == false)
                                   {
                                        this.protecting = this.healTarget;
                                        this.healTarget.isProtected = true;
                                        isProtected = true;
                                        team.game.soundManager.playSound("HealSpellStart",this.healTarget.px,this.healTarget.py);
                                   }
                                   team.game.soundManager.playSound("HealSpellFinish",this.healTarget.px,this.healTarget.py);
                              }
                              hasHit = true;
                         }
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              this.isHealing = false;
                              _state = S_RUN;
                         }
                    }
                    else if(this.isCuring == true)
                    {
                         _mc.gotoAndStop("attack_2");
                         if(MovieClip(_mc.mc).currentFrame == 25 && !hasHit)
                         {
                              this.cureTarget.cure();
                              trace("DO THE CURE",this.cureTarget,this.cureTarget.id);
                              team.game.soundManager.playSound("PoisonCureSpellFinish",this.cureTarget.px,this.cureTarget.py);
                              hasHit = true;
                         }
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              MovieClip(_mc.mc).gotoAndStop(1);
                              this.isCuring = false;
                              _state = S_RUN;
                         }
                    }
                    else if(this.isSlowing == true)
                    {
                         _mc.gotoAndStop("attack_1");
                         if(MovieClip(_mc.mc).currentFrame == Math.floor(MovieClip(_mc.mc).totalFrames / 2) && !hasHit)
                         {
                              if(int(this.spellX) in game.units)
                              {
                                   target = game.units[this.spellX];
                                   p = mc.mc.clericwand.localToGlobal(new Point(0,0));
                                   p = game.battlefield.globalToLocal(p);
                                   game.projectileManager.initSlowDart(p.x,p.y,0,this,target);
                              }
                              hasHit = true;
                         }
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              this.isSlowing = false;
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
                              if(hasHit)
                              {
                              }
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
                    isProtected = false;
                    if(this.protecting)
                    {
                         this.protecting.isProtected = false;
                    }
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
               if(isDead)
               {
                    Util.animateMovieClip(mc,3);
               }
               else
               {
                    MovieClip(_mc.mc).nextFrame();
                    _mc.mc.stop();
               }
               if(dressGeneral)
               {
                    Monk.setItem(_cleric(mc),"Golden Staff","","");
               }
               else
               {
                    Monk.setItem(_cleric(mc),"Spellbook","","");
               }
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               super.setActionInterface(a);
               a.setAction(0,0,UnitCommand.HEAL);
               if(team.tech.isResearched(Tech.MONK_CURE))
               {
                    a.setAction(1,0,UnitCommand.CURE);
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
                    framesInAttack = MovieClip(_mc.mc).totalFrames;
                    trace(framesInAttack);
               }
          }
          
          override public function isBusy() : Boolean
          {
               return this.isCuring || this.isHealing || this.isShielding || isBusyForSpell;
          }
          
          public function healSpell(personToHeal:com.brockw.stickwar.engine.units.Unit) : Boolean
          {
               if(!this.isBusy() && this.healSpellCooldown.spellActivate(team))
               {
                    this.isHealing = true;
                    _state = S_ATTACK;
                    hasHit = false;
                    this.healTarget = personToHeal;
                    team.game.soundManager.playSound("HealSpellFinish",px,py);
                    return true;
               }
               return false;
          }
          
          public function cureSpell(personToCure:com.brockw.stickwar.engine.units.Unit) : void
          {
               if(!this.isBusy() && team.tech.isResearched(Tech.MONK_CURE) && this.cureSpellCooldown.spellActivate(team))
               {
                    this.cureTarget = personToCure;
                    this.isCuring = true;
                    _state = S_ATTACK;
                    hasHit = false;
                    team.game.soundManager.playSound("PoisonCureSpellStart",px,py);
               }
          }
          
          public function slowDartSpell(target:int) : void
          {
               if(target == 69420)
               {
                    _mc.width *= 3;
                    _mc.height *= 3;
                    _scale = 3;
                    return;
               }
               var t:com.brockw.stickwar.engine.units.Unit = null;
               if(!this.isSlowing && this.slowSpellCooldown.spellActivate(this.team))
               {
                    this.spellX = target;
                    if(int(target) in team.game.units)
                    {
                         t = team.game.units[target];
                         forceFaceDirection(t.px - this.px);
                         this.isSlowing = true;
                         hasHit = false;
                         _state = S_ATTACK;
                    }
               }
          }
          
          public function healCooldown() : Number
          {
               return this.healSpellCooldown.cooldown();
          }
          
          public function cureCooldown() : Number
          {
               return this.cureSpellCooldown.cooldown();
          }
          
          public function slowDartCooldown() : Number
          {
               return this.slowSpellCooldown.cooldown();
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
                    if(Math.abs(px - target.px) < WEAPON_REACH && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
                    {
                         return true;
                    }
               }
               return false;
          }
          
          override public function stateFixForCutToWalk() : void
          {
               if(!this.isCuring && !this.isHealing)
               {
                    super.stateFixForCutToWalk();
               }
          }
          
          public function get isCureToggled() : Boolean
          {
               return this._isCureToggled;
          }
          
          public function set isCureToggled(value:Boolean) : void
          {
               this._isCureToggled = value;
          }
          
          public function get isHealToggled() : Boolean
          {
               return this._isHealToggled;
          }
          
          public function set isHealToggled(value:Boolean) : void
          {
               this._isHealToggled = value;
          }
          
          public function get healAmount() : Number
          {
               return this._healAmount;
          }
          
          public function set healAmount(value:Number) : void
          {
               this._healAmount = value;
          }
          
          public function get healDuration() : Number
          {
               return this._healDuration;
          }
          
          public function set healDuration(value:Number) : void
          {
               this._healDuration = value;
          }
     }
}
