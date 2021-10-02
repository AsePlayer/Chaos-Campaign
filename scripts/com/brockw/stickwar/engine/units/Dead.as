package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.DeadAi;
   import com.brockw.stickwar.engine.Ai.UnitAi;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Building;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.market.MarketItem;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class Dead extends RangedUnit
   {
       
      
      private var _isCastleArcher:Boolean;
      
      private var isPoison:Boolean;
      
      private var isFire:Boolean;
      
      private var arrowDamage:Number;
      
      private var bowFrame:int;
      
      private var target:Unit;
      
      private var _isPoisonedToggled:Boolean;
      
      private var poisonMana:Number;
      
      private var poisonDamageAmount:Number;
      
      private var lastShotFrame:int;
      
      private var deezNuts:int;
      
      public function Dead(game:StickWar)
      {
         super(game);
         _mc = new _dead();
         this.init(game);
         addChild(_mc);
         ai = new DeadAi(this);
         initSync();
         firstInit();
         this.isPoisonedToggled = false;
         this.lastShotFrame = 0;
      }
      
      public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         var m:_dead = _dead(mc);
         if(m.mc.head)
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
         if(team.tech.isResearched(Tech.DEAD_POISON))
         {
            a.setAction(0,0,UnitCommand.DEAD_POISON);
         }
      }
      
      override public function init(game:StickWar) : void
      {
         initBase();
         _maximumRange = Number(Number(Number(game.xml.xml.Chaos.Units.dead.maximumRange)));
         population = int(int(int(game.xml.xml.Chaos.Units.dead.population)));
         maxHealth = int(int(int(health = Number(Number(Number(game.xml.xml.Chaos.Units.dead.health))))));
         this.createTime = int(int(int(game.xml.xml.Chaos.Units.dead.cooldown)));
         this.projectileVelocity = Number(Number(Number(game.xml.xml.Chaos.Units.dead.arrowVelocity)));
         this.arrowDamage = Number(Number(Number(game.xml.xml.Chaos.Units.dead.damage)));
         _mass = int(int(int(game.xml.xml.Chaos.Units.dead.mass)));
         _maxForce = Number(Number(Number(game.xml.xml.Chaos.Units.dead.maxForce)));
         _dragForce = Number(Number(Number(game.xml.xml.Chaos.Units.dead.dragForce)));
         _scale = Number(Number(Number(game.xml.xml.Chaos.Units.dead.scale)));
         _maxVelocity = Number(Number(Number(game.xml.xml.Chaos.Units.dead.maxVelocity)));
         this.poisonMana = Number(Number(Number(game.xml.xml.Chaos.Units.dead.poison.mana)));
         this.poisonDamageAmount = Number(Number(Number(game.xml.xml.Chaos.Units.dead.poison.damage)));
         loadDamage(game.xml.xml.Chaos.Units.dead);
         type = Unit.U_DEAD;
         if(this.isCastleArcher)
         {
            this._maximumRange = Number(Number(Number(game.xml.xml.Chaos.Units.dead.castleRange)));
            this.poisonDamageAmount = Number(Number(Number(game.xml.xml.Chaos.Units.dead.castlePoison)));
            projectileVelocity = Number(Number(Number(projectileVelocity + 10)));
         }
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = int(int(int(S_RUN)));
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.isPoison = false;
         this.isFire = false;
         this.bowFrame = 1;
         this.isPoisonedToggled = true;
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["ArcheryBuilding"];
      }
      
      public function togglePoison() : void
      {
         this.isPoisonedToggled = !this.isPoisonedToggled;
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
      
      public function set isCastleArcher(value:Boolean) : void
      {
         if(value)
         {
            this._maximumRange = Number(Number(Number(500)));
            this.healthBar.visible = false;
            isStationary = true;
         }
         this._isCastleArcher = value;
      }
      
      override public function update(game:StickWar) : void
      {
         var p:Point = null;
         var v:int = 0;
         var damage:int = 0;
         var poisonDamage:* = NaN;
         var realPoisonToggle:Boolean = false;
         super.update(game);
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
                  _state = int(int(int(S_RUN)));
                  px = Number(Number(Number(px + Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale)));
                  dx = Number(Number(Number(0)));
                  dy = Number(Number(Number(0)));
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
               if(MovieClip(_mc.mc).currentFrame == 31 && !hasHit)
               {
                  p = mc.mc.localToGlobal(new Point(0,0));
                  p = game.battlefield.globalToLocal(p);
                  v = projectileVelocity;
                  damage = this.arrowDamage;
                  if(this.target != null)
                  {
                     poisonDamage = 0;
                     realPoisonToggle = this.isPoisonedToggled;
                     if(!team.tech.isResearched(Tech.DEAD_POISON))
                     {
                        realPoisonToggle = false;
                     }
                     if(realPoisonToggle && team.mana > this.poisonMana || this._isCastleArcher)
                     {
                        if(!this.target.isPoisoned() && this.target is Unit && !(this.target is Wall) && !(this.target is ChaosTower) && !(this.target is Statue))
                        {
                           poisonDamage = this.poisonDamageAmount;
                           if(!this._isCastleArcher)
                           {
                              team.mana -= this.poisonMana;
                           }
                        }
                     }
                     if(mc.scaleX < 0)
                     {
                        game.projectileManager.initGuts(p.x,p.y,180 - bowAngle,v,this.target.y,angleToTargetW(this.target,v,angleToTarget(this.target)),poisonDamage,this);
                     }
                     else
                     {
                        game.projectileManager.initGuts(p.x,p.y,bowAngle,v,this.target.y,angleToTargetW(this.target,v,angleToTarget(this.target)),poisonDamage,this);
                     }
                     hasHit = true;
                  }
                  else
                  {
                     if(mc.scaleX < 0)
                     {
                        game.projectileManager.initGuts(p.x,p.y,180 - bowAngle,v,this.target.y,0,poisonDamage,this);
                     }
                     else
                     {
                        game.projectileManager.initGuts(p.x,p.y,bowAngle,v,this.target.y,0,poisonDamage,this);
                     }
                     hasHit = true;
                  }
               }
               if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = int(int(int(S_RUN)));
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
         Util.animateMovieClip(_mc,0);
         if(this.isCastleArcher)
         {
            Dead.setItem(mc,"Default","Wrapped Helmet","Default");
         }
         else if(!hasDefaultLoadout)
         {
            Dead.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
         }
      }
      
      override public function shoot(game:StickWar, target:Unit) : void
      {
         if(_state != S_ATTACK && game.frame - this.lastShotFrame > 45)
         {
            this.deezNuts = int(int(Math.floor(Math.random() * 2) + 1));
            _state = int(int(int(S_ATTACK)));
            if(this.deezNuts == 1)
            {
               mc.gotoAndStop("attack_2");
            }
            else
            {
               mc.gotoAndStop("attack_1");
            }
            this.target = target;
            hasHit = false;
            this.lastShotFrame = game.frame;
         }
      }
      
      public function get isPoisonedToggled() : Boolean
      {
         return this._isPoisonedToggled;
      }
      
      public function set isPoisonedToggled(value:Boolean) : void
      {
         this._isPoisonedToggled = value;
      }
      
      public function get isCastleArcher() : Boolean
      {
         return this._isCastleArcher;
      }
   }
}
