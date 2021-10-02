package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.MinerAi;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Gold;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.market.MarketItem;
   import flash.display.MovieClip;
   
   public class MinerChaos extends Miner
   {
      
      public static var WEAPON_REACH:int;
       
      
      private var oreInBag:int;
      
      private var bagSize:int;
      
      private var valueOfOre:Number;
      
      private var towerGoldCost:int;
      
      private var towerSpell:SpellCooldown;
      
      private var isConstructing:Boolean;
      
      private var buildX:Number;
      
      private var buildY:Number;
      
      private var towerConstructing:ChaosTower;
      
      private var wallConstructionTime:int;
      
      private var wallConstructionFrame:int;
      
      private var normalMaxVelocity:Number;
      
      private var upgradedMaxVelocity:Number;
      
      public function MinerChaos(game:StickWar)
      {
         super(game);
         removeChild(_mc);
         _mc = new _chaosminer();
         ai = new MinerAi(this);
         this.init(game);
         addChild(_mc);
         initSync();
         firstInit();
         _interactsWith = Unit.I_MINE | Unit.I_STATUE | Unit.I_ENEMY;
         this.buildX = 0;
         this.buildY = 0;
         this.isConstructing = false;
         attackState = 0;
         wallConstructing = null;
      }
      
      public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         var m:_chaosminer = _chaosminer(mc);
         if(m.mc.minerbag)
         {
            if(misc != "")
            {
               m.mc.minerbag.gotoAndStop(misc);
            }
         }
         if(m.mc.pick)
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
         this.isConstructing = false;
         WEAPON_REACH = game.xml.xml.Chaos.miner.weaponReach;
         population = game.xml.xml.Chaos.Units.miner.population;
         _mass = game.xml.xml.Chaos.Units.miner.mass;
         _maxForce = game.xml.xml.Chaos.Units.miner.maxForce;
         _dragForce = game.xml.xml.Chaos.Units.miner.dragForce;
         _scale = game.xml.xml.Chaos.Units.miner.scale;
         _maxVelocity = this.normalMaxVelocity = game.xml.xml.Order.Units.miner.maxVelocity;
         this.upgradedMaxVelocity = game.xml.xml.Order.Units.miner.upgradedMaxVelocity;
         this.createTime = game.xml.xml.Chaos.Units.miner.cooldown;
         maxHealth = health = game.xml.xml.Chaos.Units.miner.health;
         upgradedMaxHealth = game.xml.xml.Order.Units.miner.upgradedHealth;
         loadDamage(game.xml.xml.Chaos.Units.miner);
         type = Unit.U_CHAOS_MINER;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         this.bagSize = game.xml.xml.Order.Units.miner.bagSize;
         normalBagSize = game.xml.xml.Order.Units.miner.bagSize;
         upgradedBagSize = game.xml.xml.Order.Units.miner.bagSizeUpgraded;
         this.oreInBag = 0;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.valueOfOre = 0;
         this.towerGoldCost = game.xml.xml.Chaos.Units.miner.tower.gold;
         this.towerSpell = new SpellCooldown(game.xml.xml.Chaos.Units.miner.tower.effect,game.xml.xml.Chaos.Units.miner.tower.cooldown,game.xml.xml.Chaos.Units.miner.tower.mana);
         this.towerConstructing = null;
         this.wallConstructionTime = game.xml.xml.Chaos.Units.miner.tower.constructTime;
         this.wallConstructionFrame = 0;
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["BankBuilding"];
      }
      
      public function buildTower(x:Number, y:Number) : void
      {
         if(this.towerGoldCost < team.gold && team.tech.isResearched(Tech.MINER_TOWER) && team.unitGroups[Unit.U_CHAOS_TOWER].length < team.game.xml.xml.Chaos.maxTowers)
         {
            if(this.towerSpell.spellActivate(team))
            {
               team.gold -= this.towerGoldCost;
               this.isConstructing = true;
               this.buildX = x;
               this.buildY = y;
               this.attackState = 0;
               _mc.gotoAndStop("startAttack");
            }
         }
      }
      
      override public function stateFixForCutToWalk() : void
      {
         if(!this.isConstructing)
         {
            this._state = S_RUN;
            this.hasHit = true;
         }
      }
      
      override public function constructCooldown() : Number
      {
         return this.towerSpell.cooldown();
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
               health += upgradedMaxHealth - maxHealth;
               maxHealth = upgradedMaxHealth;
               healthBar.totalHealth = maxHealth;
            }
         }
         updateCommon(game);
         this.towerSpell.update();
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
               if(attackState == 0)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     attackState = 1;
                     _mc.gotoAndStop("building");
                     game.soundManager.playSound("BuildChaosTower",px,py);
                  }
               }
               else if(attackState != 1)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     _state = S_RUN;
                     attackState = 0;
                  }
               }
               if(this.towerConstructing == null)
               {
                  this.towerConstructing = ChaosTower(game.unitFactory.getUnit(int(Unit.U_CHAOS_TOWER)));
                  team.spawn(this.towerConstructing,game);
                  this.towerConstructing.scaleX *= team.direction * -1;
                  this.towerConstructing.px = this.buildX;
                  this.towerConstructing.py = this.buildY;
                  trace("CREATED A WALL");
                  this.wallConstructionFrame = 0;
                  this.towerConstructing.setConstructionAmount(0);
               }
               else if(!this.towerConstructing.isAlive())
               {
                  this.isConstructing = false;
                  this.towerConstructing = null;
               }
               else
               {
                  ++this.wallConstructionFrame;
                  this.towerConstructing.setConstructionAmount(this.wallConstructionFrame / this.wallConstructionTime);
                  if(this.wallConstructionFrame / this.wallConstructionTime >= 1)
                  {
                     this.isConstructing = false;
                     this.towerConstructing = null;
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
               if(attackState == 0)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     attackState = 1;
                     id = team.game.random.nextInt() % this._attackLabels.length;
                     _mc.gotoAndStop("attack_" + this._attackLabels[id]);
                  }
               }
               else if(attackState == 1)
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
                     attackState = 2;
                     _mc.gotoAndStop("endAttack");
                  }
               }
               else if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = S_RUN;
                  attackState = 0;
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
                  Util.animateMovieClip(mc.mc);
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
                  else if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                  {
                     MovieClip(_mc.mc).gotoAndStop(1);
                     this.oreInBag += MinerAi(ai).targetOre.mine(game.xml.xml.Order.Units.miner.miningRate,this);
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
         if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
         {
            MovieClip(_mc.mc).gotoAndStop(1);
         }
         Util.animateMovieClip(_mc,0);
         if(game.gameScreen is CampaignGameScreen)
         {
            setItem(_mc,"Default","Default","Bone Bag");
         }
         else if(!hasDefaultLoadout)
         {
            setItem(_mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
         }
      }
      
      override public function isBagFull() : Boolean
      {
         return this.oreInBag >= this.bagSize;
      }
      
      override public function mine() : void
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
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         setActionInterfaceBase(a);
         if(team.tech.isResearched(Tech.MINER_TOWER))
         {
            a.setAction(0,0,UnitCommand.CONSTRUCT_TOWER);
         }
      }
      
      override protected function isAbleToWalk() : Boolean
      {
         return !this.isConstructing && _state != S_ATTACK;
      }
   }
}
