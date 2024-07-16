package com.brockw.stickwar.engine.units
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.Ai.WingidonAi;
     import com.brockw.stickwar.engine.Ai.command.UnitCommand;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.market.MarketItem;
     import flash.display.MovieClip;
     import flash.filters.GlowFilter;
     import flash.geom.Point;
     
     public class Wingidon extends RangedUnit
     {
          
          private static var WEAPON_REACH:int;
          
          private static var RAGE_COOLDOWN:int;
          
          private static var RAGE_EFFECT:int;
           
          
          private var wingidonSpeedSpell:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var normalVelocity:Number;
          
          private var increasedVelocity:Number;
          
          private var windStrength:Number;
          
          private var rageSpell:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var rageSpellGlow:GlowFilter;
          
          public var clothes:String;
          
          private var eclipsorNoises:Array;
          
          public var isWingSpell:Boolean;
          
          public var prevpx:int;
          
          public var pxCounter:int;
          
          public var shortenRange:Boolean;
          
          public var damage:int;
          
          public function Wingidon(game:StickWar)
          {
               this.eclipsorNoises = ["voiceTutorial16","voiceTutorial17"];
               super(game);
               _mc = new _wingidon();
               this.init(game);
               addChild(_mc);
               ai = new WingidonAi(this);
               initSync();
               firstInit();
               name = "Eclipsors";
               this.rageSpellGlow = new GlowFilter();
               this.rageSpellGlow.color = 16711832;
               this.rageSpellGlow.blurX = 10;
               this.rageSpellGlow.blurY = 10;
          }
          
          public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
          {
               var m:_wingidon = _wingidon(mc);
               if(m.mc.body)
               {
                    if(m.mc.body.head)
                    {
                         if(armor != "")
                         {
                              m.mc.body.head.gotoAndStop(armor);
                         }
                    }
                    if(m.mc.body.quiver)
                    {
                         if(misc != "")
                         {
                              m.mc.body.quiver.gotoAndStop(misc);
                         }
                    }
               }
          }
          
          override public function init(game:StickWar) : void
          {
               initBase();
               this.projectileVelocity = game.xml.xml.Chaos.Units.wingidon.arrowVelocity;
               population = game.xml.xml.Chaos.Units.wingidon.population;
               RAGE_COOLDOWN = game.xml.xml.Chaos.Units.wingidon.wingidonSpeed.cooldown;
               RAGE_EFFECT = game.xml.xml.Chaos.Units.wingidon.wingidonSpeed.effect;
               _mass = game.xml.xml.Chaos.Units.wingidon.mass;
               _maxForce = game.xml.xml.Chaos.Units.wingidon.maxForce;
               _dragForce = game.xml.xml.Chaos.Units.wingidon.dragForce;
               _scale = game.xml.xml.Chaos.Units.wingidon.scale;
               this.createTime = game.xml.xml.Chaos.Units.wingidon.cooldown;
               this.windStrength = game.xml.xml.Chaos.Units.wingidon.win.sStrength;
               this.normalVelocity = _maxVelocity = game.xml.xml.Chaos.Units.wingidon.maxVelocity;
               this.increasedVelocity = game.xml.xml.Chaos.Units.wingidon.maxMaxVelocity;
               _maximumRange = game.xml.xml.Chaos.Units.wingidon.maximumRange;
               maxHealth = health = game.xml.xml.Chaos.Units.wingidon.health;
               type = Unit.U_WINGIDON;
               flyingHeight = 250 * 1;
               this.wingidonSpeedSpell = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Chaos.Units.wingidon.wingidonSpeed.effect,game.xml.xml.Chaos.Units.wingidon.wingidonSpeed.cooldown,game.xml.xml.Chaos.Units.wingidon.wingidonSpeed.mana);
               this.loadDamage(game.xml.xml.Chaos.Units.wingidon);
               _mc.stop();
               _mc.width *= _scale;
               _mc.height *= _scale;
               _hitBoxWidth = 25;
               _state = S_RUN;
               MovieClip(_mc.mc.gotoAndPlay(1));
               MovieClip(_mc.gotoAndStop(1));
               py = 0;
               pz = -flyingHeight * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               y = -100;
               if(game != null)
               {
                    MovieClip(mc.mc.body.wings1).gotoAndPlay(Math.floor(MovieClip(mc.mc.body.wings1).totalFrames * game.random.nextNumber()));
                    MovieClip(mc.mc.body.wings2).gotoAndPlay(MovieClip(mc.mc.body.wings1).currentFrame);
               }
               drawShadow();
               this.healthBar.y = -mc.mc.height * 0.9;
          }
          
          override public function setBuilding() : void
          {
               building = team.buildings["ArcheryBuilding"];
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               super.setActionInterface(a);
               a.setAction(0,0,UnitCommand.WINGIDON_SPEED);
          }
          
          public function speedSpell() : void
          {
               if(this.wingidonSpeedSpell.spellActivate(team))
               {
                    team.game.soundManager.playSound(this.eclipsorNoises[Math.floor(Math.random() * 2)],px,py);
                    this.isWingSpell = true;
               }
          }
          
          public function speedSpellCooldown() : Number
          {
               return this.wingidonSpeedSpell.cooldown();
          }
          
          override public function update(game:StickWar) : void
          {
               var arms:MovieClip = null;
               this.wingidonSpeedSpell.update();
               super.update(game);
               updateCommon(game);
               if(this.shortenRange)
               {
                    this._maximumRange = 350;
                    isNormal = false;
               }
               if(this.pxCounter <= 0)
               {
                    this.prevpx = px;
                    this.pxCounter = 30;
               }
               else
               {
                    --this.pxCounter;
               }
               if(this.isWingSpell)
               {
                    aim(null);
                    aimedAtUnit(null,0);
                    if(!isFeetMoving())
                    {
                         this.wingidonSpeedSpell.increaseFalloff = true;
                    }
                    if(this.wingidonSpeedSpell.inEffect() && _maxVelocity > this.increasedVelocity)
                    {
                         _maxVelocity += 0.025;
                         this.rageSpellGlow.blurX = _maxVelocity;
                         this.rageSpellGlow.blurY = _maxVelocity;
                         this.mc.filters = [this.rageSpellGlow];
                    }
                    else if(this.wingidonSpeedSpell.inEffect())
                    {
                         _maxVelocity = this.increasedVelocity;
                         this.rageSpellGlow.blurX = 9 + 6 * Util.sin(20 * Math.PI * this.wingidonSpeedSpell.timeRunning() / RAGE_EFFECT);
                         this.rageSpellGlow.blurY = 10;
                         this.mc.filters = [this.rageSpellGlow];
                    }
                    else if(!this.wingidonSpeedSpell.inEffect() && _maxVelocity < this.normalVelocity)
                    {
                         _maxVelocity -= 0.4;
                         this.rageSpellGlow.blurX = _maxVelocity;
                         this.rageSpellGlow.blurY = _maxVelocity;
                         this.mc.filters = [this.rageSpellGlow];
                    }
                    else if(!this.wingidonSpeedSpell.inEffect())
                    {
                         this.mc.filters = [];
                         _maxVelocity = this.normalVelocity;
                         this.isWingSpell = false;
                    }
               }
               if(!isDieing)
               {
                    if(_mc.mc.body.legs != null)
                    {
                         _mc.mc.body.legs.rotation = getDirection() * _dx / _maxVelocity * game.xml.xml.Chaos.Units.wingidon.legRotateAngleWhenFlying;
                         MovieClip(mc.mc.body.legs).nextFrame();
                         if(MovieClip(mc.mc.body.legs).currentFrame == MovieClip(mc.mc.body.legs).totalFrames)
                         {
                              MovieClip(mc.mc.body.legs).gotoAndStop(1);
                         }
                    }
                    if(mc.mc.body.wings1 != null)
                    {
                         if(this.wingidonSpeedSpell.inEffect())
                         {
                              MovieClip(mc.mc.body.wings1).nextFrame();
                              MovieClip(mc.mc.body.wings2).nextFrame();
                              game.projectileManager.airEffects.push([px + team.direction * 100,py,team.direction * this.windStrength,team]);
                         }
                         MovieClip(mc.mc.body.wings1).nextFrame();
                         MovieClip(mc.mc.body.wings2).nextFrame();
                         if(MovieClip(mc.mc.body.wings1).currentFrame == MovieClip(mc.mc.body.wings1).totalFrames)
                         {
                              MovieClip(mc.mc.body.wings1).gotoAndStop(1);
                         }
                         if(MovieClip(mc.mc.body.wings2).currentFrame == MovieClip(mc.mc.body.wings2).totalFrames)
                         {
                              MovieClip(mc.mc.body.wings2).gotoAndStop(1);
                         }
                    }
                    updateMotion(game);
                    arms = _mc.mc.body.arms;
                    if(arms != null)
                    {
                         if(arms.currentFrame != 1)
                         {
                              arms.nextFrame();
                              if(arms.currentFrame == arms.totalFrames)
                              {
                                   arms.gotoAndStop(1);
                              }
                         }
                         arms.rotation = bowAngle;
                    }
                    if(_isDualing)
                    {
                         _mc.gotoAndStop(_currentDual.attackLabel);
                         moveDualPartner(_dualPartner,_currentDual.xDiff);
                         if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                         {
                              _isDualing = false;
                              _state = S_RUN;
                              px += Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale;
                              dx = 0;
                              dy = 0;
                         }
                    }
                    else if(_state == S_RUN)
                    {
                         if(Math.abs(_dx) + Math.abs(_dy) > 0.1)
                         {
                         }
                    }
                    else if(_state == S_ATTACK)
                    {
                         if(MovieClip(_mc.mc).currentFrame > MovieClip(_mc.mc).totalFrames / 2 && !hasHit)
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
                    if(backgroundFighter)
                    {
                         this.team.population += population;
                         backgroundFighter = false;
                    }
                    if(_isDualing)
                    {
                         _mc.gotoAndStop(_currentDual.defendLabel);
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
               if(!isDead && _mc.mc != null)
               {
                    MovieClip(_mc.mc).nextFrame();
                    if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                    {
                         MovieClip(_mc.mc).gotoAndStop(1);
                    }
               }
               if(!isDead && _mc.mc.wings1 != null)
               {
                    MovieClip(_mc.mc).gotoAndStop(_mc.mc.wings1.currentFrame);
               }
               if(isDead)
               {
                    Util.animateMovieClip(_mc,3);
                    if(_mc.mc.body != null && _mc.mc.body.quiver != null)
                    {
                         MovieClip(_mc.mc.body.quiver).gotoAndStop(1);
                    }
                    else if(_mc.mc.quiver != null)
                    {
                         MovieClip(_mc.mc.quiver).gotoAndStop(1);
                    }
               }
               if(!hasDefaultLoadout)
               {
                    Wingidon.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
               }
               if(this.clothes == "test")
               {
                    Wingidon.setItem(mc,"","Animal Helmet","Animal Sleeve");
               }
          }
          
          override public function mayAttack(target:Unit) : Boolean
          {
               if(isIncapacitated())
               {
                    return false;
               }
               if(this.wingidonSpeedSpell.inEffect())
               {
                    return false;
               }
               return super.mayAttack(target);
          }
          
          override public function shoot(game:StickWar, target:Unit) : void
          {
               var arms:MovieClip = null;
               var p:Point = null;
               if(_state != S_ATTACK)
               {
                    arms = _mc.mc.body.arms;
                    if(arms.currentFrame != 1)
                    {
                         return;
                    }
                    game.soundManager.playSoundRandom("launchArrow",4,px,py);
                    arms.nextFrame();
                    p = arms.localToGlobal(new Point(0,0));
                    p = game.battlefield.globalToLocal(p);
                    if(mc.scaleX < 0)
                    {
                         game.projectileManager.initBolt(p.x,p.y,180 - arms.rotation,projectileVelocity,target.py,angleToTargetW(target,projectileVelocity,angleToTarget(target)),this,20,30 * 4,false);
                    }
                    else
                    {
                         game.projectileManager.initBolt(p.x,p.y,arms.rotation,projectileVelocity,target.py,angleToTargetW(target,projectileVelocity,angleToTarget(target)),this,20,30 * 4,false);
                    }
                    if(backgroundFighter && ai.getClosestTarget())
                    {
                         ai.getClosestTarget().damage(0,14,null);
                    }
               }
          }
          
          override public function walk(x:Number, y:Number, intendedX:int) : void
          {
               if(isAbleToWalk())
               {
                    baseWalk(x,y,intendedX);
               }
          }
     }
}
