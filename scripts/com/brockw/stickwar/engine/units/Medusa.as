package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.MedusaAi;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.market.MarketItem;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class Medusa extends Unit
   {
       
      
      public var outfit:int = 0;
      
      private var WEAPON_REACH:int;
      
      private var snakeFrames:Dictionary;
      
      private var poisonSpell:SpellCooldown;
      
      private var stoneSpell:SpellCooldown;
      
      private var inPoisonSpell:Boolean;
      
      public var inStoneSpell:Boolean;
      
      private var targetUnit:Unit;
      
      private var stoneReady:Boolean = true;
      
      private var poisonReady:Boolean = true;
      
      public function Medusa(game:StickWar)
      {
         super(game);
         _mc = new _medusaMc();
         this.snakeFrames = new Dictionary();
         this.init(game);
         addChild(_mc);
         ai = new MedusaAi(this);
         initSync();
         firstInit();
      }
      
      public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
      {
         var m:_medusaMc = _medusaMc(mc);
         if(m.mc.medusacape)
         {
            if(armor != "")
            {
               m.mc.medusacape.gotoAndStop(armor);
            }
         }
         if(m.mc.medusacrown)
         {
            if(misc != "")
            {
               m.mc.medusacrown.gotoAndStop(misc);
            }
         }
      }
      
      override public function weaponReach() : Number
      {
         return this.WEAPON_REACH;
      }
      
      override public function playDeathSound() : void
      {
         team.game.soundManager.playSoundRandom("Medusa",3,px,py);
      }
      
      override public function init(game:StickWar) : void
      {
         var i:int = 0;
         var d:DisplayObject = null;
         initBase();
         this.WEAPON_REACH = int(game.xml.xml.Chaos.Units.medusa.weaponReach);
         population = int(game.xml.xml.Chaos.Units.medusa.population);
         _mass = int(game.xml.xml.Chaos.Units.medusa.mass);
         _maxForce = Number(game.xml.xml.Chaos.Units.medusa.maxForce);
         _dragForce = Number(game.xml.xml.Chaos.Units.medusa.dragForce);
         _scale = Number(game.xml.xml.Chaos.Units.medusa.scale);
         _maxVelocity = Number(game.xml.xml.Chaos.Units.medusa.maxVelocity);
         damageToDeal = Number(game.xml.xml.Chaos.Units.medusa.baseDamage);
         this.createTime = int(game.xml.xml.Chaos.Units.medusa.cooldown);
         maxHealth = int(health = Number(game.xml.xml.Chaos.Units.medusa.health));
         loadDamage(game.xml.xml.Chaos.Units.medusa);
         type = Unit.U_MEDUSA;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = int(S_RUN);
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.inPoisonSpell = this.inStoneSpell = false;
         i = 0;
         while(i < _mc.mc.snakes.numChildren)
         {
            d = _mc.mc.snakes.getChildAt(i);
            if(d is MovieClip)
            {
               this.snakeFrames[d.name] = int(game.random.nextNumber() * MovieClip(d).totalFrames);
            }
            i++;
         }
         this.poisonSpell = new SpellCooldown(game.xml.xml.Chaos.Units.medusa.poison.effect,game.xml.xml.Chaos.Units.medusa.poison.cooldown,game.xml.xml.Chaos.Units.medusa.poison.mana);
         this.stoneSpell = new SpellCooldown(game.xml.xml.Chaos.Units.medusa.stone.effect,game.xml.xml.Chaos.Units.medusa.stone.cooldown,game.xml.xml.Chaos.Units.medusa.stone.mana);
      }
      
      override public function isBusy() : Boolean
      {
         return !this.notInSpell() || isBusyForSpell;
      }
      
      private function notInSpell() : Boolean
      {
         return !this.inPoisonSpell && !this.inStoneSpell;
      }
      
      public function poisonSpray() : void
      {
         if(!team.tech.isResearched(Tech.MEDUSA_POISON))
         {
            return;
         }
         if(this.poisonSpell.spellActivate(team))
         {
            team.game.soundManager.playSound("acidPoolSound",px,py);
            this.inPoisonSpell = true;
            this.poisonReady = false;
            _state = int(S_ATTACK);
         }
      }
      
      public function poisonPoolCooldown() : Number
      {
         return this.poisonSpell.cooldown();
      }
      
      public function stoneCooldown() : Number
      {
         return this.stoneSpell.cooldown();
      }
      
      public function stone(unit:Unit) : void
      {
         if(this.stoneSpell.spellActivate(team))
         {
            team.game.soundManager.playSound("medusaPetrifySound",px,py);
            this.inStoneSpell = true;
            this.targetUnit = unit;
            this.stoneReady = false;
            team.gold -= 50;
            _state = int(S_ATTACK);
         }
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["MedusaBuilding"];
      }
      
      override public function getDamageToDeal() : Number
      {
         return damageToDeal;
      }
      
      override public function update(game:StickWar) : void
      {
         var i:int = 0;
         var d:DisplayObject = null;
         this.poisonSpell.update();
         this.stoneSpell.update();
         updateCommon(game);
         if(this.stoneSpell.cooldown() == 0 && !this.stoneReady)
         {
            this.stoneReady = true;
            team.game.gameScreen.userInterface.helpMessage.showMessage("Petrify is ready!");
            team.game.soundManager.playSoundRandom("Medusa",3,px,py);
         }
         if(this.poisonSpell.cooldown() == 0 && !this.poisonReady)
         {
            this.poisonReady = true;
            team.game.gameScreen.userInterface.helpMessage.showMessage("Poison Pool is ready!");
            team.game.soundManager.playSoundRandom("Medusa",3,px,py);
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
                  _state = int(S_RUN);
                  px += Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale;
                  dx = Number(0);
                  dy = Number(0);
               }
            }
            else if(this.inPoisonSpell)
            {
               _mc.gotoAndStop("poisonAttack");
               if(MovieClip(_mc.mc).currentFrame == 3)
               {
                  game.projectileManager.initPoisonPool(this.px,this.py,this,0);
               }
               if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = int(S_RUN);
                  this.inPoisonSpell = false;
               }
            }
            else if(this.inStoneSpell)
            {
               _mc.gotoAndStop("stoneAttack");
               if(MovieClip(_mc.mc).currentFrame == 20)
               {
                  if(this.targetUnit)
                  {
                     if(this.targetUnit.isArmoured)
                     {
                        this.targetUnit.stoneAttack(game.xml.xml.Chaos.Units.medusa.stone.damageToArmour);
                     }
                     else
                     {
                        this.targetUnit.stoneAttack(game.xml.xml.Chaos.Units.medusa.stone.damageToNotArmour);
                     }
                  }
               }
               if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = int(S_RUN);
                  this.inStoneSpell = false;
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
                  hasHit = Boolean(this.checkForHit());
               }
               if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = int(S_RUN);
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
               }
            }
            else
            {
               _mc.gotoAndStop(getDeathLabel(game));
               game.teamA.statue.health = Number(Number(0));
               this.team.removeUnit(this,game);
               isDead = true;
            }
         }
         if(!isDead)
         {
            i = 0;
            while(i < _mc.mc.snakes.numChildren)
            {
               d = _mc.mc.snakes.getChildAt(i);
               if(d is MovieClip)
               {
                  this.snakeFrames[d.name] = (this.snakeFrames[d.name] + 1) % MovieClip(d).totalFrames;
                  MovieClip(d).gotoAndStop(this.snakeFrames[d.name]);
               }
               i++;
            }
            if(_mc.mc.multisnakes2 != null)
            {
               _mc.mc.multisnakes2.gotoAndStop((_mc.mc.multisnakes1.currentFrame + 10) % _mc.mc.multisnakes1.totalFrames);
            }
         }
         Util.animateMovieClip(_mc);
         if(!hasDefaultLoadout)
         {
            Medusa.setItem(_medusaMc(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
         }
         if(this.outfit == 1)
         {
            Medusa.setItem(_medusaMc(mc),"","Woodland Cape","More Crowny");
         }
      }
      
      override public function setActionInterface(a:ActionInterface) : void
      {
         super.setActionInterface(a);
         a.setAction(0,0,UnitCommand.STONE);
         if(team.tech.isResearched(Tech.MEDUSA_POISON))
         {
            a.setAction(1,0,UnitCommand.POISON_POOL);
         }
      }
      
      public function enableSuperMedusa() : void
      {
         this.health = Number(this.maxHealth = int(team.game.xml.xml.Chaos.Units.medusa.superHealth));
         this.scale = Number(team.game.xml.xml.Chaos.Units.medusa.superScale);
         _damageToArmour = Number(team.game.xml.xml.Chaos.Units.medusa.superDamage);
         _damageToNotArmour = Number(team.game.xml.xml.Chaos.Units.medusa.superDamage);
         this.stoneSpell = new SpellCooldown(team.game.xml.xml.Chaos.Units.medusa.stone.effect,team.game.xml.xml.Chaos.Units.medusa.stone.superCooldown,team.game.xml.xml.Chaos.Units.medusa.stone.mana);
         maxHealth = this.maxHealth;
         healthBar.totalHealth = maxHealth;
      }
      
      override public function attack() : void
      {
         var id:int = 0;
         if(_state != S_ATTACK)
         {
            id = team.game.random.nextInt() % this._attackLabels.length;
            _mc.gotoAndStop("attack_" + this._attackLabels[id]);
            MovieClip(_mc.mc).gotoAndStop(1);
            _state = int(S_ATTACK);
            hasHit = false;
            attackStartFrame = int(team.game.frame);
            framesInAttack = int(MovieClip(_mc.mc).totalFrames);
         }
      }
      
      override public function mayAttack(target:Unit) : Boolean
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
            if(Math.abs(px - target.px) < this.WEAPON_REACH && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function stateFixForCutToWalk() : void
      {
         if(!this.inPoisonSpell && !this.inStoneSpell)
         {
            super.stateFixForCutToWalk();
            this.inPoisonSpell = false;
            this.inStoneSpell = false;
         }
      }
      
      public function isMedusaMaxHp() : Boolean
      {
         return this.health == this.maxHealth;
      }
   }
}
