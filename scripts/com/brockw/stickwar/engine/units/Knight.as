package com.brockw.stickwar.engine.units
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.Ai.KnightAi;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.market.MarketItem;
     import flash.display.MovieClip;
     
     public class Knight extends com.brockw.stickwar.engine.units.Unit
     {
          
          private static var WEAPON_REACH:int;
           
          
          private var chargeVelocity:Number;
          
          private var normalVelocity:Number;
          
          private var chargeSpell:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var isChargeSet:Boolean;
          
          private var chargeForce:Number;
          
          private var normalForce:Number;
          
          private var chargeStunArea:Number;
          
          private var hasCharged:Boolean;
          
          private var stunned:com.brockw.stickwar.engine.units.Unit;
          
          private var stunDamage:Number;
          
          private var stunEffect:Number;
          
          private var stunForce:Number;
          
          public var shield:String;
          
          private var setup:Boolean = false;
          
          public var charger:Boolean = false;
          
          public function Knight(game:StickWar)
          {
               super(game);
               _mc = new _knight();
               this.init(game);
               addChild(_mc);
               ai = new KnightAi(this);
               initSync();
               firstInit();
               this.isChargeSet = false;
               this.chargeForce = 0;
               this.hasCharged = false;
               this.stunned = null;
          }
          
          public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
          {
               var m:MovieClip = _knight(mc).mc;
               if(misc == "Riot Shield")
               {
                    if(m.knighthelm)
                    {
                         m.knighthelm.gotoAndStop("Gas Mask");
                    }
                    if(m.knightweapon)
                    {
                         m.knightweapon.gotoAndStop("Baton");
                    }
                    if(m.knightshield)
                    {
                         m.knightshield.gotoAndStop("Riot Shield");
                    }
               }
               else if(misc == "Skull Shield")
               {
                    if(m.knighthelm)
                    {
                         m.knighthelm.gotoAndStop("Chef Hat");
                    }
                    if(m.knightweapon)
                    {
                         m.knightweapon.gotoAndStop("Cleaver");
                    }
                    if(m.knightshield)
                    {
                         m.knightshield.gotoAndStop("Skull Shield");
                    }
               }
               else
               {
                    if(m.knighthelm)
                    {
                         m.knighthelm.gotoAndStop("Default");
                    }
                    if(m.knightweapon)
                    {
                         m.knightweapon.gotoAndStop("Default");
                    }
                    if(m.knightshield)
                    {
                         m.knightshield.gotoAndStop("Default");
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
               WEAPON_REACH = game.xml.xml.Chaos.Units.knight.weaponReach;
               population = game.xml.xml.Chaos.Units.knight.population;
               _mass = game.xml.xml.Chaos.Units.knight.mass;
               _maxForce = this.normalForce = game.xml.xml.Chaos.Units.knight.maxForce;
               this.chargeForce = game.xml.xml.Chaos.Units.knight.charge.force;
               this.stunForce = game.xml.xml.Chaos.Units.knight.charge.stunForce;
               _dragForce = game.xml.xml.Chaos.Units.knight.dragForce;
               _scale = game.xml.xml.Chaos.Units.knight.scale;
               _maxVelocity = this.normalVelocity = game.xml.xml.Chaos.Units.knight.maxVelocity;
               damageToDeal = game.xml.xml.Chaos.Units.knight.baseDamage;
               this.createTime = game.xml.xml.Chaos.Units.knight.cooldown;
               maxHealth = health = game.xml.xml.Chaos.Units.knight.health;
               this.chargeStunArea = game.xml.xml.Chaos.Units.knight.charge.stunArea;
               this.stunDamage = game.xml.xml.Chaos.Units.knight.charge.damage;
               this.stunEffect = game.xml.xml.Chaos.Units.knight.charge.stun;
               this.chargeVelocity = game.xml.xml.Chaos.Units.knight.charge.velocity;
               loadDamage(game.xml.xml.Chaos.Units.knight);
               type = com.brockw.stickwar.engine.units.Unit.U_KNIGHT;
               this.chargeSpell = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Chaos.Units.knight.charge.effect,game.xml.xml.Chaos.Units.knight.charge.cooldown,game.xml.xml.Chaos.Units.knight.charge.mana);
               name = "Juggerknights";
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
               return damageToDeal;
          }
          
          public function getChargeCooldown() : Number
          {
               return this.chargeSpell.cooldown();
          }
          
          public function charge() : void
          {
               if(!team.tech.isResearched(Tech.KNIGHT_CHARGE))
               {
                    return;
               }
               if(this.chargeSpell.spellActivate(team))
               {
                    team.game.soundManager.playSound("deathKnightChargeSound",px,py);
                    this.hasCharged = false;
               }
          }
          
          private function getStunnedUnit(unit:com.brockw.stickwar.engine.units.Unit) : void
          {
               if(this.stunned == null && unit.team != this.team && unit.pz == 0)
               {
                    if(unit.type == com.brockw.stickwar.engine.units.Unit.U_WALL && Math.abs(unit.px - px) < 20)
                    {
                         this.stunned = unit;
                    }
                    else if(Math.pow(unit.px + unit.dx - dx - px,2) + Math.pow(unit.py + unit.dy - dy - py,2) < Math.pow(3 * unit.hitBoxWidth * (this.perspectiveScale + unit.perspectiveScale) / 2,2))
                    {
                         this.stunned = unit;
                    }
               }
          }
          
          override public function update(game:StickWar) : void
          {
               this.chargeSpell.update();
               updateCommon(game);
               if(mc.mc.sword != null)
               {
                    mc.mc.sword.gotoAndStop(team.loadout.getItem(this.type,MarketItem.T_WEAPON));
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
                    else if(this.chargeSpell.inEffect() && this.hasCharged == false)
                    {
                         if(!this.hasCharged)
                         {
                              this.stunned = null;
                              game.spatialHash.mapInArea(this.px - this.chargeStunArea,this.py - this.chargeStunArea,this.px + this.chargeStunArea,this.py + this.chargeStunArea,this.getStunnedUnit);
                              if(this.stunned != null)
                              {
                                   this.hasCharged = true;
                                   this.stunned.stun(this.stunEffect);
                                   this.stunned.damage(0,this.stunDamage,null);
                                   this.stunned.applyVelocity(this.stunForce * Util.sgn(mc.scaleX));
                              }
                         }
                         _mc.gotoAndStop("charge");
                         this._maxVelocity = this.chargeVelocity;
                         this._maxForce = this.chargeForce;
                         this.isChargeSet = true;
                         this.walk(team.direction,0,team.direction);
                         this.isChargeSet = false;
                    }
                    else if(_state == S_RUN)
                    {
                         this._maxVelocity = this.normalVelocity;
                         this._maxForce = this.normalForce;
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
                                   game.soundManager.playSound("sword1",px,py);
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
                    if(_isDualing)
                    {
                         _mc.gotoAndStop(_currentDual.defendLabel);
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              isDualing = false;
                              mc.filters = [];
                              this.team.removeUnit(this,game);
                              isDead = true;
                              if(backgroundFighter)
                              {
                                   this.team.population += population;
                                   backgroundFighter = false;
                              }
                         }
                    }
                    else
                    {
                         _mc.gotoAndStop(getDeathLabel(game));
                         this.team.removeUnit(this,game);
                         isDead = true;
                         if(backgroundFighter)
                         {
                              this.team.population += population;
                              backgroundFighter = false;
                         }
                    }
                    if(this.setup)
                    {
                         maxHealth = health = game.xml.xml.Chaos.Units.knight.health;
                         maxHealth = maxHealth;
                         healthBar.totalHealth = maxHealth;
                         this.setup = false;
                    }
                    _maxVelocity = int(game.xml.xml.Chaos.Units.knight.maxVelocity);
                    _scale = int(game.xml.xml.Chaos.Units.knight.scale);
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
               if(_mc.mc.dust)
               {
                    Util.animateMovieClipBasic(_mc.mc.dust);
               }
               if(this.shield == "Riot Shield")
               {
                    Knight.setItem(_knight(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),"Riot Shield");
                    if(!this.setup && isDead == false)
                    {
                         health = maxHealth = 7500;
                         maxHealth = maxHealth;
                         healthBar.totalHealth = maxHealth;
                         this.setup = true;
                    }
                    _maxVelocity = int(game.xml.xml.Chaos.Units.knight.maxVelocity) * 1.7;
                    _scale = 1.4;
               }
               else if(this.shield == "Skull Shield")
               {
                    Knight.setItem(_knight(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),"Skull Shield");
                    if(!this.setup)
                    {
                         maxHealth = health = game.xml.xml.Chaos.Units.knight.health;
                         maxHealth = maxHealth;
                         healthBar.totalHealth = maxHealth;
                         this.setup = true;
                    }
                    _maxVelocity = int(game.xml.xml.Chaos.Units.knight.maxVelocity);
                    _scale = int(game.xml.xml.Chaos.Units.knight.scale);
               }
               else
               {
                    Knight.setItem(_knight(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),"Default");
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
               if(team.tech.isResearched(Tech.KNIGHT_CHARGE))
               {
                    a.setAction(0,0,UnitCommand.KNIGHT_CHARGE);
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
                    framesInAttack = MovieClip(_mc.mc).totalFrames;
                    attackStartFrame = team.game.frame;
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
                    if(this.charger && Math.abs(px - target.px) < WEAPON_REACH * 4 && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
                    {
                         charge();
                    }
               }
               return false;
          }
          
          override protected function isAbleToWalk() : Boolean
          {
               return this._state == S_RUN && (!this.chargeSpell.inEffect() || this.isChargeSet);
          }
     }
}
