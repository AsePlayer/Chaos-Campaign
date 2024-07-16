package com.brockw.stickwar.engine.units
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.ActionInterface;
     import com.brockw.stickwar.engine.Ai.*;
     import com.brockw.stickwar.engine.Ai.command.*;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.market.MarketItem;
     import flash.display.MovieClip;
     import flash.geom.Point;
     
     public class Archer extends RangedUnit
     {
           
          
          private var _isCastleArcher:Boolean;
          
          private var isFire:Boolean;
          
          private var archerFireSpellCooldown:com.brockw.stickwar.engine.units.SpellCooldown;
          
          private var arrowDamage:Number;
          
          private var bowFrame:int;
          
          private var normalRange:Number;
          
          private var fireArrowRange:Number;
          
          private var areaDamage:Number;
          
          private var area:Number;
          
          public var shortenRange:Boolean;
          
          public var archerType:String;
          
          public function Archer(game:StickWar)
          {
               super(game);
               _mc = new _archer();
               this.init(game);
               addChild(_mc);
               ai = new ArcherAi(this);
               initSync();
               firstInit();
               this.archerFireSpellCooldown = new com.brockw.stickwar.engine.units.SpellCooldown(0,game.xml.xml.Order.Units.archer.fire.cooldown,game.xml.xml.Order.Units.archer.fire.mana);
               name = "Archidons";
          }
          
          public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
          {
               var m:_archer = _archer(mc);
               if(Boolean(m.mc.archerBag))
               {
                    if(misc != "")
                    {
                         m.mc.archerBag.gotoAndStop(misc);
                    }
               }
               if(Boolean(m.mc.head))
               {
                    if(armor != "")
                    {
                         m.mc.head.gotoAndStop(armor);
                    }
               }
          }
          
          override public function setActionInterface(a:ActionInterface) : void
          {
               super.setActionInterface(a);
               if(team.tech.isResearched(Tech.ARCHIDON_FIRE))
               {
                    a.setAction(0,0,UnitCommand.ARCHER_FIRE);
               }
          }
          
          public function getFireCoolDown() : Number
          {
               return this.archerFireSpellCooldown.cooldown();
          }
          
          override public function init(game:StickWar) : void
          {
               initBase();
               _maximumRange = this.normalRange = game.xml.xml.Order.Units.archer.maximumRange;
               this.fireArrowRange = game.xml.xml.Order.Units.archer.fire.range;
               maxHealth = health = game.xml.xml.Order.Units.archer.health;
               this.createTime = game.xml.xml.Order.Units.archer.cooldown;
               this.projectileVelocity = game.xml.xml.Order.Units.archer.arrowVelocity;
               this.arrowDamage = game.xml.xml.Order.Units.archer.damage;
               population = game.xml.xml.Order.Units.archer.population;
               _mass = game.xml.xml.Order.Units.archer.mass;
               _maxForce = game.xml.xml.Order.Units.archer.maxForce;
               _dragForce = game.xml.xml.Order.Units.archer.dragForce;
               _scale = game.xml.xml.Order.Units.archer.scale;
               _maxVelocity = game.xml.xml.Order.Units.archer.maxVelocity;
               this.loadDamage(game.xml.xml.Order.Units.archer);
               this.areaDamage = 0;
               this.area = 0;
               if(this.isCastleArcher)
               {
                    this._maximumRange = this.normalRange = game.xml.xml.Order.Units.archer.castleRange;
                    _scale *= 1.1;
                    this.area = game.xml.xml.Order.Units.archer.castleArea;
                    this.areaDamage = game.xml.xml.Order.Units.archer.castleAreaDamage;
               }
               type = Unit.U_ARCHER;
               _mc.stop();
               _mc.width *= _scale;
               _mc.height *= _scale;
               _state = S_RUN;
               MovieClip(_mc.mc.gotoAndPlay(1));
               MovieClip(_mc.gotoAndStop(1));
               drawShadow();
               this.isFire = false;
               this.bowFrame = 1;
          }
          
          override protected function loadDamage(unitXml:XMLList) : void
          {
               var _damage:Number = NaN;
               this.isArmoured = unitXml.armoured == 1 ? true : false;
               if(!this._isCastleArcher)
               {
                    _damage = Number(unitXml.damage);
                    this._damageToArmour = _damage + Number(unitXml.toArmour);
                    this._damageToNotArmour = _damage + Number(unitXml.toNotArmour);
               }
               else
               {
                    _damage = Number(unitXml.castleDamage);
                    this._damageToArmour = _damage + Number(unitXml.castleToArmour);
                    this._damageToNotArmour = _damage + Number(unitXml.castleToNotArmour);
               }
          }
          
          override public function setBuilding() : void
          {
               building = team.buildings["ArcheryBuilding"];
          }
          
          public function archerFireArrow() : void
          {
               if(this.archerFireSpellCooldown.spellActivate(team) && team.tech.isResearched(Tech.ARCHIDON_FIRE))
               {
                    this.isFire = true;
                    takeBottomTrajectory = false;
                    _maximumRange = this.fireArrowRange;
               }
          }
          
          override public function update(game:StickWar) : void
          {
               super.update(game);
               this.archerFireSpellCooldown.update();
               updateCommon(game);
               if(this.shortenRange)
               {
                    this._maximumRange = 400;
                    isNormal = false;
               }
               else if(!isNormal)
               {
                    this._maximumRange = this.normalRange;
               }
               if(this.archerType == "Splash")
               {
                    _scale = game.xml.xml.Order.Units.archer.scale;
                    this.area = game.xml.xml.Order.Units.archer.castleArea;
                    this.areaDamage = game.xml.xml.Order.Units.archer.castleAreaDamage;
                    isNormal = false;
               }
               if(this.archerType == "Fire")
               {
                    team.tech.isResearchedMap[Tech.ARCHIDON_FIRE] = true;
                    if(getFireCoolDown() == 0)
                    {
                         archerFireArrow();
                    }
               }
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
               if(isDead)
               {
                    Util.animateMovieClip(_mc);
               }
               else
               {
                    if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                    {
                         MovieClip(_mc.mc).gotoAndStop(1);
                    }
                    MovieClip(_mc.mc).nextFrame();
                    _mc.mc.stop();
               }
               var bow:MovieClip = _mc.mc.bow;
               if(bow != null)
               {
                    bow.gotoAndStop(this.bowFrame);
                    if(this.bowFrame != 1)
                    {
                         if(this.bowFrame == 46)
                         {
                              game.soundManager.playSound("BowReady",px,py);
                         }
                         bow.nextFrame();
                         this.bowFrame += 1;
                         if(bow.currentFrame == bow.totalFrames)
                         {
                              bow.gotoAndStop(1);
                              this.bowFrame = 1;
                         }
                    }
               }
               if(this.archerType == "Splash")
               {
                    Archer.setItem(mc,"Default","Basic Helmet","Silver Archidon");
               }
               else if(this.archerType == "Fire")
               {
                    Archer.setItem(mc,"Default","Robin Hood Hat","Robin Hood Quiver");
               }
               else if(!hasDefaultLoadout)
               {
                    Archer.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
               }
               if(this.isCastleArcher)
               {
                    Archer.setItem(mc,"Default","Basic Helmet","Default");
               }
               if(_mc.mc.bow != null)
               {
                    _mc.mc.bow.rotation = bowAngle;
               }
          }
          
          override public function isLoaded() : Boolean
          {
               var bow:MovieClip = _mc.mc.bow;
               return this.bowFrame < 35;
          }
          
          override public function shoot(game:StickWar, target:Unit) : void
          {
               var bow:MovieClip = null;
               var p:Point = null;
               var v:int = 0;
               var damage:int = 0;
               var poison:Number = NaN;
               var fireDamage:Number = NaN;
               if(_state != S_ATTACK)
               {
                    bow = _mc.mc.bow;
                    if(this.bowFrame != 1)
                    {
                         return;
                    }
                    this.bowFrame += 1;
                    bow.nextFrame();
                    p = bow.localToGlobal(new Point(0,0));
                    p = game.battlefield.globalToLocal(p);
                    v = projectileVelocity;
                    damage = this.arrowDamage;
                    poison = 0;
                    fireDamage = 0;
                    if(this.isFire)
                    {
                         fireDamage = Number(game.xml.xml.Order.Units.archer.fire.damage);
                    }
                    game.soundManager.playSoundRandom("launchArrow",5,px,py);
                    if(mc.scaleX < 0)
                    {
                         game.projectileManager.initArrow(p.x,p.y,180 - bowAngle,v,target.y,angleToTargetW(target,v,angleToTarget(target)),this,damage,poison,this.isFire,this.area,this.areaDamage);
                    }
                    else
                    {
                         game.projectileManager.initArrow(p.x,p.y,bowAngle,v,target.y,angleToTargetW(target,v,angleToTarget(target)),this,damage,poison,this.isFire,this.area,this.areaDamage);
                    }
                    if(backgroundFighter && ai.getClosestTarget())
                    {
                         ai.getClosestTarget().damage(0,damage,null);
                    }
                    this.isFire = false;
                    _maximumRange = this.normalRange;
                    takeBottomTrajectory = true;
               }
          }
          
          override public function aim(target:Unit) : void
          {
               var a:Number = angleToTarget(target);
               if(Math.abs(normalise(angleToBowSpace(a) - bowAngle)) < 10)
               {
                    bowAngle += normalise(angleToBowSpace(a) - bowAngle) * 0.8;
               }
               else
               {
                    bowAngle += normalise(angleToBowSpace(a) - bowAngle) * 0.1;
               }
          }
          
          override public function mayAttack(target:Unit) : Boolean
          {
               var CASTLE_WIDTH:int = 200;
               if(!this.isCastleArcher && team.direction * px < team.direction * (this.team.homeX + team.direction * CASTLE_WIDTH))
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
               if(aimedAtUnit(target,angleToTarget(target)) && this.inRange(target))
               {
                    return true;
               }
               return false;
          }
          
          override public function walk(x:Number, y:Number, intendedX:int) : void
          {
               if(isAbleToWalk())
               {
                    baseWalk(x,y,intendedX);
               }
          }
          
          public function get isCastleArcher() : Boolean
          {
               return this._isCastleArcher;
          }
          
          public function set isCastleArcher(value:Boolean) : void
          {
               if(value)
               {
                    this._maximumRange = 500;
                    this.healthBar.visible = false;
                    isStationary = true;
               }
               this._isCastleArcher = value;
          }
     }
}
