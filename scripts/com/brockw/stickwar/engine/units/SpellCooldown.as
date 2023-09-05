package com.brockw.stickwar.engine.units
{
     import com.brockw.stickwar.engine.Team.Team;
     
     public class SpellCooldown
     {
           
          
          private var counter:int;
          
          private var cooldownTime:int = 0;
          
          private var effect:int = 0;
          
          private var mana:int = 0;
          
          public var increaseFalloff:Boolean;
          
          public var effectShortened:int;
          
          public function SpellCooldown(effect:int, cooldownTime:int, mana:int)
          {
               super();
               this.cooldownTime = cooldownTime;
               this.effect = effect;
               this.effectShortened = effect;
               this.mana = mana;
               this.counter = effect + cooldownTime;
          }
          
          public function spellActivate(team:Team) : Boolean
          {
               if(this.counter >= this.cooldownTime && this.mana <= team.mana)
               {
                    team.mana -= this.mana;
                    this.counter = 0;
                    this.effectShortened = effect;
                    this.increaseFalloff = false;
                    return true;
               }
               return false;
          }
          
          public function update() : void
          {
               ++this.counter;
               if(this.increaseFalloff)
               {
                    --this.effectShortened;
                    --this.effectShortened;
               }
          }
          
          public function timeRunning() : Number
          {
               return this.counter;
          }
          
          public function inEffect() : Boolean
          {
               if(this.increaseFalloff)
               {
                    return this.counter < this.effectShortened;
               }
               return this.counter < this.effect;
          }
          
          public function cooldown() : Number
          {
               var t:Number = 1 * (this.cooldownTime - this.counter) / (1 * this.cooldownTime);
               if(t < 0)
               {
                    t = 0;
               }
               return t;
          }
     }
}
