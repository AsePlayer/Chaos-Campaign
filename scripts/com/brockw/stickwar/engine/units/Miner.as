package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Gold;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.market.MarketItem;
   import flash.display.MovieClip;
   
   public class Miner extends Unit
   {
      
      public static var WEAPON_REACH:int;
       
      
      private var oreInBag:int;
      
      private var bagSize:int;
      
      private var valueOfOre:Number;
      
      private var wallGoldCost:int;
      
      private var wallSpell:com.brockw.stickwar.engine.units.SpellCooldown;
      
      private var isConstructing:Boolean;
      
      private var buildX:Number;
      
      private var buildY:Number;
      
      protected var normalBagSize:int;
      
      protected var upgradedBagSize:int;
      
      protected var wallConstructing:com.brockw.stickwar.engine.units.Wall;
      
      private var wallConstructionTime:int;
      
      private var wallConstructionFrame:int;
      
      protected var attackState:int;
      
      private var normalMaxVelocity:Number;
      
      private var upgradedMaxVelocity:Number;
      
      protected var upgradedMaxHealth:int;
      
      public function Miner(game:StickWar)
      {
         super(game);
         _mc = new _miner();
         ai = new MinerAi(this);
         this.init(game);
         addChild(_mc);
         initSync();
         firstInit();
         _interactsWith = Unit.I_MINE | Unit.I_STATUE | Unit.I_ENEMY;
         this.buildX = 0;
         this.buildY = 0;
         this.isConstructing = false;
         this.attackState = 0;
         this.wallConstructing = null;
         name = "Miners";
      }
      
      public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         var m:_miner = _miner(mc);
         if(Boolean(m.mc.minerbag))
         {
            if(misc != "")
            {
               m.mc.minerbag.gotoAndStop(misc);
            }
         }
         if(Boolean(m.mc.pick))
         {
            if(weapon != "")
            {
               m.mc.pick.gotoAndStop(weapon);
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
         WEAPON_REACH = game.xml.xml.Order.Units.miner.weaponReach;
         population = game.xml.xml.Order.Units.miner.population;
         _mass = game.xml.xml.Order.Units.miner.mass;
         _maxForce = game.xml.xml.Order.Units.miner.maxForce;
         _dragForce = game.xml.xml.Order.Units.miner.dragForce;
         _scale = game.xml.xml.Order.Units.miner.scale;
         _maxVelocity = this.normalMaxVelocity = game.xml.xml.Order.Units.miner.maxVelocity;
         this.upgradedMaxVelocity = game.xml.xml.Order.Units.miner.upgradedMaxVelocity;
         this.createTime = game.xml.xml.Order.Units.miner.cooldown;
         maxHealth = health = game.xml.xml.Order.Units.miner.health;
         this.upgradedMaxHealth = game.xml.xml.Order.Units.miner.upgradedHealth;
         this.wallConstructionTime = game.xml.xml.Order.Units.miner.wall.constructionTime;
         loadDamage(game.xml.xml.Order.Units.miner);
         type = Unit.U_MINER;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         this.bagSize = game.xml.xml.Order.Units.miner.bagSize;
         this.normalBagSize = game.xml.xml.Order.Units.miner.bagSize;
         this.oreInBag = 0;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.valueOfOre = 0;
         MinerAi(ai).isGoingForOre = true;
         MinerAi(ai).isUnassigned = true;
         this.wallGoldCost = game.xml.xml.Order.Units.miner.wall.gold;
         this.wallSpell = new com.brockw.stickwar.engine.units.SpellCooldown(game.xml.xml.Order.Units.miner.wall.effect,game.xml.xml.Order.Units.miner.wall.cooldown,game.xml.xml.Order.Units.miner.wall.mana);
      }
      
      override public function stateFixForCutToWalk() : void
      {
         if(!this.isConstructing)
         {
            this._state = S_RUN;
            this.hasHit = true;
         }
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["BankBuilding"];
      }
      
      public function buildWall(x:Number, y:Number) : void
      {
         if(this.wallGoldCost <= team.gold && team.tech.isResearched(Tech.MINER_WALL) && team.walls.length < team.game.xml.xml.Order.maxWalls)
         {
            if(this.wallSpell.spellActivate(team))
            {
               team.gold -= this.wallGoldCost;
               this.isConstructing = true;
               this.buildX = x;
               this.buildY = y;
               this.attackState = 0;
               _mc.gotoAndStop("startAttack");
            }
         }
      }
      
      public function constructCooldown() : Number
      {
         return this.wallSpell.cooldown();
      }
      
      override public function update(game:StickWar) : void
      {
         var id:int = 0;
         var oreMined:* = undefined;
         var distance:Number = NaN;
         var t:String = null;
         if(team.tech.isResearched(Tech.MINER_SPEED))
         {
            if(this.maxHealth != this.upgradedMaxHealth)
            {
               health += this.upgradedMaxHealth - maxHealth;
               maxHealth = this.upgradedMaxHealth;
               healthBar.totalHealth = maxHealth;
            }
         }
         updateCommon(game);
         this.wallSpell.update();
         if(!team.tech.isResearched(Tech.MINER_SPEED))
         {
            _maxVelocity = this.normalMaxVelocity;
         }
         else
         {
            _maxVelocity = this.upgradedMaxVelocity;
         }
         if(Math.abs(team.homeX - x) < 220)
         {
            team.gold += this.valueOfOre;
            this.valueOfOre = 0;
            this.oreInBag = 0;
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
            else if(this.isConstructing)
            {
               if(this.attackState == 0)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     this.attackState = 1;
                     _mc.gotoAndStop("building");
                     game.soundManager.playSound("BuildWall",px,py);
                  }
               }
               else if(this.attackState != 1)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     _state = S_RUN;
                     this.attackState = 0;
                  }
               }
               if(this.wallConstructing == null)
               {
                  this.wallConstructing = team.addWall(this.buildX);
                  this.wallConstructionFrame = 0;
                  this.wallConstructing.setConstructionAmount(0);
               }
               else if(!this.wallConstructing.isAlive())
               {
                  this.isConstructing = false;
                  this.wallConstructing = null;
               }
               else
               {
                  ++this.wallConstructionFrame;
                  this.wallConstructing.setConstructionAmount(this.wallConstructionFrame / this.wallConstructionTime);
                  if(this.wallConstructionFrame / this.wallConstructionTime >= 1)
                  {
                     this.isConstructing = false;
                     this.wallConstructing = null;
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
               if(this.attackState == 0)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     this.attackState = 1;
                     id = team.game.random.nextInt() % this._attackLabels.length;
                     _mc.gotoAndStop("attack_" + this._attackLabels[id]);
                  }
               }
               else if(this.attackState == 1)
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
                     this.attackState = 2;
                     _mc.gotoAndStop("endAttack");
                  }
               }
               else if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = S_RUN;
                  this.attackState = 0;
               }
            }
            else if(_state == S_MINE)
            {
               if(MinerAi(ai).targetOre != null && MinerAi(ai).targetOre is Gold)
               {
                  if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames && !this.isBagFull())
                  {
                     if(MinerAi(ai).targetOre != null)
                     {
                        oreMined = MinerAi(ai).targetOre.mine(game.xml.xml.Order.Units.miner.miningRate,this);
                        this.oreInBag += oreMined;
                        distance = Math.abs(MinerAi(ai).targetOre.x - px);
                        this.valueOfOre += oreMined;
                        if(this.oreInBag > this.bagSize)
                        {
                           this.oreInBag = this.bagSize;
                           this.valueOfOre = this.bagSize;
                        }
                        hasHit = true;
                     }
                  }
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     _state = S_RUN;
                  }
               }
               else
               {
                  t = MovieClip(_mc).currentFrameLabel;
                  if(t != "bendDownToPray" && t != "pray")
                  {
                     MovieClip(_mc).gotoAndStop("bendDownToPray");
                  }
                  else if(t == "bendDownToPray")
                  {
                     if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                     {
                        MovieClip(_mc).gotoAndStop("pray");
                     }
                  }
                  else
                  {
                     if(game.gameScreen.hasEffects)
                     {
                        Util.animateMovieClip(mc.mc);
                     }
                     if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                     {
                        MovieClip(_mc.mc).gotoAndStop(1);
                        this.oreInBag += MinerAi(ai).targetOre.mine(game.xml.xml.Order.Units.miner.miningRate,this);
                     }
                  }
               }
            }
         }
         else if(isDead == false)
         {
            isDead = true;
            MinerAi(ai).targetOre = null;
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
            Util.animateMovieClip(_mc,0);
         }
         else
         {
            if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
            {
               MovieClip(_mc.mc).gotoAndStop(1);
            }
            MovieClip(_mc.mc).nextFrame();
         }
         if(!hasDefaultLoadout)
         {
            setItem(_mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
         }
      }
      
      public function isBagFull() : Boolean
      {
         return this.oreInBag >= this.bagSize;
      }
      
      public function mine() : void
      {
         var id:int = 0;
         if(_state != S_MINE)
         {
            id = team.game.random.nextInt() % this._attackLabels.length;
            _mc.gotoAndStop("mine");
            MovieClip(_mc.mc).gotoAndStop(1);
            _state = S_MINE;
            hasHit = false;
         }
      }
      
      override public function attack() : void
      {
         var id:int = 0;
         if(_state != S_ATTACK || this.attackState == 2)
         {
            if(this.attackState == 0)
            {
               _mc.gotoAndStop("startAttack");
            }
            else
            {
               id = team.game.random.nextInt() % this._attackLabels.length;
               _mc.gotoAndStop("attack_" + this._attackLabels[id]);
               this.attackState = 1;
            }
            MovieClip(_mc.mc).gotoAndStop(1);
            _state = S_ATTACK;
            hasHit = false;
         }
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         super.setActionInterface(a);
         if(team.tech.isResearched(Tech.MINER_WALL))
         {
            a.setAction(0,0,UnitCommand.CONSTRUCT_WALL);
         }
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
         if(_state == S_RUN || this.attackState == 2)
         {
            if(Math.abs(px - target.px) < WEAPON_REACH && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function isAbleToWalk() : Boolean
      {
         return !this.isConstructing && _state != S_ATTACK;
      }
   }
}
