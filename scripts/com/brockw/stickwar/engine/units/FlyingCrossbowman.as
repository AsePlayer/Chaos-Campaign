package com.brockw.stickwar.engine.units
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.Ai.*;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Tech;
     import com.brockw.stickwar.market.MarketItem;
     import flash.display.MovieClip;
     import flash.geom.Point;
     
     public class FlyingCrossbowman extends RangedUnit
     {
          
          private static var WEAPON_REACH:int;
           
          
          private var bowFrame:int;
          
          public function FlyingCrossbowman(game:StickWar)
          {
               super(game);
               _mc = new _flyingcrossbowmanMc();
               this.init(game);
               addChild(_mc);
               ai = new FlyingCrossbowmanAi(this);
               initSync();
               firstInit();
               this.bowFrame = 1;
               name = "The Albowtross";
          }
          
          public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
          {
               var m:_flyingcrossbowmanMc = _flyingcrossbowmanMc(mc);
               if(Boolean(m.mc.body))
               {
                    if(Boolean(m.mc.body.head))
                    {
                         if(armor != "")
                         {
                              m.mc.body.head.gotoAndStop(armor);
                         }
                    }
                    if(Boolean(m.mc.body.quiver))
                    {
                         if(weapon != "")
                         {
                              m.mc.body.quiver.gotoAndStop(weapon);
                         }
                    }
               }
               if(Boolean(m.mc.head))
               {
                    if(armor != "")
                    {
                         m.mc.head.gotoAndStop(armor);
                    }
               }
               if(Boolean(m.mc.wings))
               {
                    if(misc != "")
                    {
                         m.mc.wings.avadonwing.gotoAndStop(misc);
                         m.mc.wings.avadonebackwing.gotoAndStop(misc);
                    }
               }
          }
          
          override public function init(game:StickWar) : void
          {
               initBase();
               this.projectileVelocity = game.xml.xml.Order.Units.flyingCrossbowman.arrowVelocity;
               population = game.xml.xml.Order.Units.flyingCrossbowman.population;
               _mass = game.xml.xml.Order.Units.flyingCrossbowman.mass;
               _maxForce = game.xml.xml.Order.Units.flyingCrossbowman.maxForce;
               _dragForce = game.xml.xml.Order.Units.flyingCrossbowman.dragForce;
               _scale = game.xml.xml.Order.Units.flyingCrossbowman.scale;
               this.createTime = game.xml.xml.Order.Units.flyingCrossbowman.cooldown;
               _maxVelocity = game.xml.xml.Order.Units.flyingCrossbowman.maxVelocity;
               _maximumRange = game.xml.xml.Order.Units.flyingCrossbowman.maximumRange;
               maxHealth = health = game.xml.xml.Order.Units.flyingCrossbowman.health;
               type = Unit.U_FLYING_CROSSBOWMAN;
               flyingHeight = 250 * 1;
               loadDamage(game.xml.xml.Order.Units.flyingCrossbowman);
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
                    MovieClip(mc.mc.wings).gotoAndPlay(Math.floor(MovieClip(mc.mc.wings).totalFrames * game.random.nextNumber()));
               }
               drawShadow();
               this.healthBar.y = -mc.mc.height * 1.1;
          }
          
          override public function setBuilding() : void
          {
               building = team.buildings["ArcheryBuilding"];
          }
          
          override public function update(game:StickWar) : void
          {
               var bow:MovieClip = null;
               super.update(game);
               if(_mc.mc.bow != null)
               {
                    _mc.mc.bow.rotation = bowAngle + 12;
               }
               else if(_mc.mc.body != null && Boolean(_mc.mc.body.arms))
               {
                    _mc.mc.body.arms.rotation = bowAngle + 12;
               }
               updateCommon(game);
               if(_mc.mc.body != null && _mc.mc.body.legs != null)
               {
                    _mc.mc.body.legs.rotation = getDirection() * _dx / _maxVelocity * game.xml.xml.Order.Units.flyingCrossbowman.legRotateAngleWhenFlying;
                    MovieClip(mc.mc.body.legs).nextFrame();
                    if(MovieClip(mc.mc.body.legs).currentFrame == MovieClip(mc.mc.body.legs).totalFrames)
                    {
                         MovieClip(mc.mc.body.legs).gotoAndStop(1);
                    }
               }
               if(mc.mc.wings != null)
               {
                    MovieClip(mc.mc.wings).nextFrame();
                    if(MovieClip(mc.mc.wings).currentFrame == MovieClip(mc.mc.wings).totalFrames)
                    {
                         MovieClip(mc.mc.wings).gotoAndStop(1);
                    }
               }
               if(!isDieing)
               {
                    updateMotion(game);
                    bow = _mc.mc.body.arms;
                    if(bow != null)
                    {
                         bow.gotoAndStop(this.bowFrame);
                         if(this.bowFrame != bow.totalFrames)
                         {
                              bow.nextFrame();
                              this.bowFrame += 1;
                         }
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
                         if(isFeetMoving())
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
               if(!isDead && _mc.mc.wings != null)
               {
                    MovieClip(_mc.mc).gotoAndStop(_mc.mc.wings.currentFrame);
               }
               if(isDead)
               {
                    Util.animateMovieClip(_mc,3);
                    MovieClip(_mc.mc.wings).gotoAndStop(1);
                    if(_mc.mc.body != null && _mc.mc.body.quiver != null)
                    {
                         MovieClip(_mc.mc.body.quiver).gotoAndStop(1);
                    }
                    else if(_mc.mc.quiver != null)
                    {
                         MovieClip(_mc.mc.quiver).gotoAndStop(1);
                    }
                    if(_mc.mc.arms != null)
                    {
                         _mc.mc.arms.gotoAndStop(1);
                    }
               }
               if(!hasDefaultLoadout)
               {
                    FlyingCrossbowman.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
               }
          }
          
          override public function get damageToArmour() : Number
          {
               if(Boolean(team.tech.isResearchedMap[Tech.CROSSBOW_FIRE]))
               {
                    return _damageToArmour + int(team.game.xml.xml.Order.Units.flyingCrossbowman.fireDamageToArmour);
               }
               return _damageToArmour;
          }
          
          override public function get damageToNotArmour() : Number
          {
               if(Boolean(team.tech.isResearchedMap[Tech.CROSSBOW_FIRE]))
               {
                    return _damageToArmour + int(team.game.xml.xml.Order.Units.flyingCrossbowman.fireDamageToNotArmour);
               }
               return _damageToNotArmour;
          }
          
          override public function shoot(game:StickWar, target:Unit) : void
          {
               var arms:MovieClip = null;
               var p:Point = null;
               if(_state != S_ATTACK)
               {
                    arms = _mc.mc.body.arms;
                    if(arms.currentFrame != arms.totalFrames)
                    {
                         return;
                    }
                    arms.gotoAndStop(1);
                    this.bowFrame = 1;
                    p = arms.localToGlobal(new Point(0,0));
                    p = game.battlefield.globalToLocal(p);
                    game.soundManager.playSoundRandom("launchArrow",4,px,py);
                    if(mc.scaleX < 0)
                    {
                         game.projectileManager.initBolt(p.x,p.y,180 - bowAngle,projectileVelocity,target.py,angleToTargetW(target,projectileVelocity,angleToTarget(target)),this,20,30 * 4,team.tech.isResearched(Tech.CROSSBOW_FIRE));
                    }
                    else
                    {
                         game.projectileManager.initBolt(p.x,p.y,bowAngle,projectileVelocity,target.py,angleToTargetW(target,projectileVelocity,angleToTarget(target)),this,20,30 * 4,team.tech.isResearched(Tech.CROSSBOW_FIRE));
                    }
               }
          }
     }
}
