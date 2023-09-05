package com.brockw.stickwar.engine.units
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.Ai.*;
     import com.brockw.stickwar.engine.Ai.command.*;
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.market.MarketItem;
     import flash.display.MovieClip;
     
     public class Spearton extends com.brockw.stickwar.engine.units.Unit
     {
          
          private static var WEAPON_REACH:int;
          
          private static var RAGE_COOLDOWN:int;
          
          private static var RAGE_EFFECT:int;
           
          
          private var _isBlocking:Boolean;
          
          private var _inBlock:Boolean;
          
          private var shieldwallDamageReduction:Number;
          
          private var shieldBashSpell:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var isShieldBashing:Boolean;
          
          private var stunForce:Number;
          
          private var stunTime:int;
          
          private var stunned:com.brockw.stickwar.engine.units.Unit;
          
          public function Spearton(game:StickWar)
          {
               super(game);
               _mc = new _speartonMc();
               this.init(game);
               addChild(_mc);
               ai = new SpeartonAi(this);
               initSync();
               firstInit();
               name = "Speartons";
          }
          
          public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
          {
               var m:_speartonMc = _speartonMc(mc);
               if(Boolean(m.mc.helm))
               {
                    if(armor != "")
                    {
                         m.mc.helm.gotoAndStop(armor);
                    }
               }
               if(Boolean(m.mc.spear))
               {
                    if(weapon != "")
                    {
                         m.mc.spear.gotoAndStop(weapon);
                    }
               }
               if(Boolean(m.mc.shield))
               {
                    if(misc != "")
                    {
                         m.mc.shield.gotoAndStop(misc);
                    }
               }
          }
          
          override public function init(game:StickWar) : void
          {
               initBase();
               this.inBlock = false;
               this.isBlocking = false;
               WEAPON_REACH = game.xml.xml.Order.Units.spearton.weaponReach;
               this.stunTime = game.xml.xml.Order.Units.spearton.shieldBash.stunTime;
               this.stunForce = game.xml.xml.Order.Units.spearton.shieldBash.stunForce;
               population = game.xml.xml.Order.Units.spearton.population;
               this.shieldwallDamageReduction = game.xml.xml.Order.Units.spearton.shieldWall.damageReduction;
               _mass = game.xml.xml.Order.Units.spearton.mass;
               _maxForce = game.xml.xml.Order.Units.spearton.maxForce;
               _dragForce = game.xml.xml.Order.Units.spearton.dragForce;
               _scale = game.xml.xml.Order.Units.spearton.scale;
               _maxVelocity = game.xml.xml.Order.Units.spearton.maxVelocity;
               damageToDeal = game.xml.xml.Order.Units.spearton.baseDamage;
               this.createTime = game.xml.xml.Order.Units.spearton.cooldown;
               maxHealth = health = game.xml.xml.Order.Units.spearton.health;
               type = com.brockw.stickwar.engine.units.Unit.U_SPEARTON;
               loadDamage(game.xml.xml.Order.Units.spearton);
               _mc.stop();
               _mc.width *= _scale;
               _mc.height *= _scale;
               _state = S_RUN;
               this.isShieldBashing = false;
               this.shieldBashSpell = new com.brockw.stickwar.engine.units.SpellCooldown(0,game.xml.xml.Order.Units.spearton.shieldBash.cooldown,game.xml.xml.Order.Units.spearton.shieldBash.mana);
               MovieClip(_mc.mc.gotoAndPlay(1));
               MovieClip(_mc.gotoAndStop(1));
               drawShadow();
          }
          
          override public function weaponReach() : Number
          {
               return WEAPON_REACH;
          }
          
          override public function setBuilding() : void
          {
               building = team.buildings["BarracksBuilding"];
          }
          
          override public function getDamageToDeal() : Number
          {
               return damageToDeal;
          }
          
          public function shieldBash() : void
          {
               if(this.shieldBashSpell.spellActivate(team) && this._isBlocking)
               {
                    this.isShieldBashing = true;
               }
          }
          
          public function shieldBashCooldown() : Number
          {
               return this.shieldBashSpell.cooldown();
          }
          
          override public function update(game:StickWar) : void
          {
               var hit:Boolean = false;
               this.shieldBashSpell.update();
               updateCommon(game);
               if(!isDieing)
               {
                    updateMotion(game);
                    if(_isDualing)
                    {
                         _mc.gotoAndStop(_currentDual.attackLabel);
                         moveDualPartner(_dualPartner,_currentDual.xDiff);
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              _isDualing = false;
                              _state = S_RUN;
                              px += Util.sgn(mc.scaleX) * team.game.getPerspectiveScale(py) * _currentDual.finalXOffset;
                              x = px;
                              dx = 0;
                              dy = 0;
                         }
                    }
                    else if(this.isShieldBashing)
                    {
                         if(MovieClip(mc.mc).currentFrameLabel == "swing")
                         {
                              team.game.soundManager.playSound("swordwrathSwing1",px,py);
                         }
                         _mc.gotoAndStop("shieldBash");
                         _mc.mc.nextFrame();
                         if(_mc.mc.currentFrame == 12)
                         {
                              hit = this.checkForBlockHit();
                         }
                         if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                         {
                              this.isShieldBashing = false;
                         }
                    }
                    else if(this.inBlock)
                    {
                         if(_mc.currentLabel == "shieldBash")
                         {
                              _mc.gotoAndStop("block");
                              _mc.mc.gotoAndStop(15);
                         }
                         else
                         {
                              _mc.gotoAndStop("block");
                         }
                         if(this.isBlocking)
                         {
                              if(_mc.mc.currentFrame < 15)
                              {
                                   _mc.mc.nextFrame();
                              }
                         }
                         else
                         {
                              _mc.mc.nextFrame();
                              if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                              {
                                   this.inBlock = false;
                              }
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
                         if(MovieClip(mc.mc).currentFrameLabel == "swing")
                         {
                              team.game.soundManager.playSound("swordwrathSwing1",px,py);
                         }
                         if(!hasHit)
                         {
                              hasHit = this.checkForHit();
                         }
                         if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                         {
                              _state = S_RUN;
                         }
                    }
               }
               else if(isDead == false)
               {
                    isDead = true;
                    if(_isDualing)
                    {
                         _mc.gotoAndStop(_currentDual.defendLabel);
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              isDualing = false;
                              mc.filters = [];
                         }
                    }
                    else
                    {
                         _mc.gotoAndStop(getDeathLabel(game));
                    }
                    this.team.removeUnit(this,game);
               }
               if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                    MovieClip(_mc.mc).gotoAndStop(1);
               }
               if(_isDualing || !this.inBlock || isDead)
               {
                    Util.animateMovieClip(_mc);
               }
               if(!hasDefaultLoadout)
               {
                    Spearton.setItem(_speartonMc(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
               }
          }
          
          private function shieldHit(unit:com.brockw.stickwar.engine.units.Unit) : *
          {
               if(this.stunned == null && unit.team != this.team && unit.pz == 0)
               {
                    if(Math.pow(unit.px + unit.dx - dx - px,2) + Math.pow(unit.py + unit.dy - dy - py,2) < Math.pow(5 * unit.hitBoxWidth * (this.perspectiveScale + unit.perspectiveScale) / 2,2))
                    {
                         this.stunned = unit;
                         unit.damage(0,this.damageToDeal,this);
                         unit.stun(this.stunTime);
                         unit.applyVelocity(this.stunForce * Util.sgn(mc.scaleX));
                    }
               }
          }
          
          protected function checkForBlockHit() : Boolean
          {
               this.stunned = null;
               team.game.spatialHash.mapInArea(px,py,px + 30,py + 30,this.shieldHit);
               return true;
          }
          
          public function stopBlocking() : void
          {
               this.isBlocking = false;
          }
          
          public function startBlocking() : void
          {
               if(team.tech.isResearched(Tech.BLOCK))
               {
                    this.isBlocking = true;
                    this.inBlock = true;
                    team.game.soundManager.playSound("speartonHoghSound",px,py);
               }
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               super.setActionInterface(a);
               if(team.tech.isResearched(Tech.BLOCK))
               {
                    a.setAction(0,0,UnitCommand.SPEARTON_BLOCK);
               }
               if(team.tech.isResearched(Tech.SHIELD_BASH))
               {
                    a.setAction(1,0,UnitCommand.SHIELD_BASH);
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
               }
          }
          
          override public function damage(type:int, amount:int, inflictor:Entity, modifier:Number = 1) : void
          {
               if(this.inBlock)
               {
                    super.damage(type,amount - amount * this.shieldwallDamageReduction,inflictor,1 - this.shieldwallDamageReduction);
               }
               else
               {
                    super.damage(type,amount,inflictor);
               }
          }
          
          override public function mayAttack(target:com.brockw.stickwar.engine.units.Unit) : Boolean
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
          
          public function get isBlocking() : Boolean
          {
               return this._isBlocking;
          }
          
          public function set isBlocking(value:Boolean) : void
          {
               this._isBlocking = value;
          }
          
          public function get inBlock() : Boolean
          {
               return this._inBlock;
          }
          
          public function set inBlock(value:Boolean) : void
          {
               this._inBlock = value;
          }
     }
}
