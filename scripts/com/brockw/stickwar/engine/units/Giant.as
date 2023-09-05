package com.brockw.stickwar.engine.units
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.Ai.GiantAi;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.market.MarketItem;
     import flash.display.MovieClip;
     
     public class Giant extends Unit
     {
          
          private static var WEAPON_REACH:int;
           
          
          private var difficulty:int;
          
          public var handicap:int;
          
          public var isBoss:Boolean = false;
          
          private var scaleI:Number;
          
          private var scaleII:Number;
          
          private var maxTargetsToHit:int;
          
          private var targetsHit:int;
          
          private var stunTime:int;
          
          public var hasGrowled:Boolean;
          
          public var noGrowl:Boolean;
          
          private var setup:Boolean = false;
          
          public function Giant(game:StickWar)
          {
               super(game);
               _mc = new _giant();
               this.init(game);
               addChild(_mc);
               ai = new GiantAi(this);
               initSync();
               firstInit();
               name = "Giants";
          }
          
          public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
          {
               var m:_giant = _giant(mc);
               if(weapon == "Skull Mace")
               {
                    if(m.mc.giantclub)
                    {
                         m.mc.giantclub.gotoAndStop("Skull Mace");
                    }
               }
               else if(m.mc.giantclub)
               {
                    m.mc.giantclub.gotoAndStop("Default");
               }
          }
          
          override public function weaponReach() : Number
          {
               return WEAPON_REACH;
          }
          
          override public function init(game:StickWar) : void
          {
               initBase();
               WEAPON_REACH = game.xml.xml.Chaos.Units.giant.weaponReach;
               this.hasGrowled = false;
               population = game.xml.xml.Chaos.Units.giant.population;
               _mass = game.xml.xml.Chaos.Units.giant.mass;
               _maxForce = game.xml.xml.Chaos.Units.giant.maxForce;
               _dragForce = game.xml.xml.Chaos.Units.giant.dragForce;
               _scale = game.xml.xml.Chaos.Units.giant.scale;
               _maxVelocity = game.xml.xml.Chaos.Units.giant.maxVelocity;
               damageToDeal = game.xml.xml.Chaos.Units.giant.baseDamage;
               this.createTime = game.xml.xml.Chaos.Units.giant.cooldown;
               maxHealth = health = game.xml.xml.Chaos.Units.giant.health;
               this.maxTargetsToHit = game.xml.xml.Chaos.Units.giant.maxTargetsToHit;
               this.stunTime = game.xml.xml.Chaos.Units.giant.stunTime;
               this.scaleI = game.xml.xml.Chaos.Units.giant.growthIScale;
               this.scaleII = game.xml.xml.Chaos.Units.giant.growthIIScale;
               loadDamage(game.xml.xml.Chaos.Units.giant);
               type = Unit.U_GIANT;
               _mc.stop();
               _mc.width *= _scale;
               _mc.height *= _scale;
               _state = S_RUN;
               MovieClip(_mc.mc.gotoAndPlay(1));
               MovieClip(_mc.gotoAndStop(1));
               drawShadow();
               this.healthBar.y = -mc.mc.height * 1.1;
          }
          
          override public function setBuilding() : void
          {
               building = team.buildings["GiantBuilding"];
          }
          
          override public function getDamageToDeal() : Number
          {
               return damageToDeal;
          }
          
          private function giantHit(unit:Unit) : *
          {
               if(this.targetsHit < this.maxTargetsToHit && unit.team != this.team)
               {
                    if(unit.px * mc.scaleX > px * mc.scaleX)
                    {
                         if(unit is Wall)
                         {
                              ++this.targetsHit;
                              unit.damage(0,this.damageToDeal,this);
                              unit.stun(this.stunTime);
                              unit.dx = 10 * Util.sgn(mc.scaleX);
                         }
                         else if(Math.pow(unit.px + unit.dx - dx - px,2) + Math.pow(unit.py + unit.dy - dy - py,2) < Math.pow(5 * unit.hitBoxWidth * (this.perspectiveScale + unit.perspectiveScale) / 2,2))
                         {
                              ++this.targetsHit;
                              unit.damage(0,this.damageToDeal,this);
                              unit.stun(this.stunTime);
                              unit.applyVelocity(7 * Util.sgn(mc.scaleX));
                         }
                    }
               }
          }
          
          override public function applyVelocity(xf:Number, yf:Number = 0, zf:Number = 0) : void
          {
          }
          
          override public function update(game:StickWar) : void
          {
               this.difficulty = game.main.campaign.difficultyLevel;
               this.handicap = 2000 + 1000 * this.difficulty;
               if(this.noGrowl)
               {
                    this.hasGrowled = true;
               }
               else if(!this.hasGrowled && !this.isBoss)
               {
                    this.hasGrowled = true;
                    team.game.soundManager.playSoundRandom("GiantGrowl",5,px,py);
               }
               else if(!this.hasGrowled && this.isBoss)
               {
                    this.hasGrowled = true;
                    team.game.soundManager.playSound("GiantGrowl6",px,py);
               }
               stunTimeLeft = 0;
               _dz = 0;
               if(this.isBoss && !specialTimeOver)
               {
                    isNormal = false;
                    WEAPON_REACH = 220;
                    _dragForce = 0.75;
                    Giant.setItem(_giant(mc),"Skull Mace","","");
                    if(!this.setup)
                    {
                         health = maxHealth = 7500;
                         maxHealth = maxHealth;
                         healthBar.totalHealth = maxHealth;
                         this.population = 20;
                         this.maxTargetsToHit = 5;
                         this.ai.statueTargeter = true;
                         _damageToArmour = 30;
                         _damageToNotArmour = 95;
                         this.setup = true;
                    }
                    _maxVelocity = int(game.xml.xml.Chaos.Units.giant.maxVelocity) * 0.7;
                    _scale = 1.4 * this.scaleII;
               }
               else if(team.tech.isResearched(Tech.CHAOS_GIANT_GROWTH_II))
               {
                    Giant.setItem(_giant(mc),"Default","","");
                    if(_scale != this.scaleII)
                    {
                         health = game.xml.xml.Chaos.Units.giant.healthII - (maxHealth - health);
                         maxHealth = game.xml.xml.Chaos.Units.giant.healthII;
                         healthBar.totalHealth = maxHealth;
                    }
                    _scale = this.scaleII;
               }
               else if(team.tech.isResearched(Tech.CHAOS_GIANT_GROWTH_I))
               {
                    Giant.setItem(_giant(mc),"Default","","");
                    if(_scale != this.scaleI)
                    {
                         health = game.xml.xml.Chaos.Units.giant.healthI - (maxHealth - health);
                         maxHealth = game.xml.xml.Chaos.Units.giant.healthI;
                         healthBar.totalHealth = maxHealth;
                    }
                    _scale = this.scaleI;
               }
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
                         if(this.targetsHit < this.maxTargetsToHit && mc.mc.currentFrameLabel == "hit" && !this.isBoss)
                         {
                              team.game.spatialHash.mapInArea(px - 225,py - 50,px + 225,py + 50,this.giantHit);
                         }
                         else if(this.targetsHit < this.maxTargetsToHit && mc.mc.currentFrameLabel == "hit" && this.isBoss)
                         {
                              team.game.spatialHash.mapInArea(px - 300,py - 50,px + 225,py + 50,this.giantHit);
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
                    team.game.soundManager.playSoundRandom("GiantDeath",3,px,py);
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
                    _maxVelocity = game.xml.xml.Chaos.Units.giant.maxVelocity;
                    _scale = game.xml.xml.Chaos.Units.giant.scale;
               }
               if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                    MovieClip(_mc.mc).gotoAndStop(1);
               }
               MovieClip(_mc.mc).nextFrame();
               _mc.mc.stop();
               if(!hasDefaultLoadout)
               {
                    Giant.setItem(_giant(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),"","");
               }
          }
          
          override public function canAttackAir() : Boolean
          {
               return true;
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
          }
          
          override public function faceDirection(dir:int) : void
          {
               if(_state != S_ATTACK)
               {
                    super.faceDirection(dir);
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
                    this.targetsHit = 0;
                    framesInAttack = MovieClip(_mc.mc).totalFrames;
                    attackStartFrame = team.game.frame;
               }
          }
          
          override public function mayAttack(target:Unit) : Boolean
          {
               if(framesInAttack > team.game.frame - attackStartFrame && _state != S_RUN)
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
                    if(Math.abs(px - target.px) < WEAPON_REACH && target.isFlying() && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
                    {
                         return true;
                    }
                    if(Math.abs(px - target.px) < WEAPON_REACH && !target.isFlying() && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
                    {
                         return true;
                    }
               }
               return false;
          }
     }
}
