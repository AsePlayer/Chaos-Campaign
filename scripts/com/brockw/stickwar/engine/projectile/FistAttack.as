package com.brockw.stickwar.engine.projectile
{
     import com.brockw.stickwar.engine.*;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.*;
     
     public class FistAttack extends Projectile
     {
           
          
          internal var spellMc:MovieClip;
          
          public var startX:Number;
          
          public var startY:Number;
          
          public var endX:Number;
          
          public var endY:Number;
          
          private var fistRange:Number;
          
          public function FistAttack(game:StickWar)
          {
               super();
               type = FIST_ATTACK;
               this.spellMc = new skullHand();
               this.addChild(this.spellMc);
               this.spellMc.scaleX *= 1.5;
               this.spellMc.scaleY *= 1.5;
               this.fistRange = game.xml.xml.Chaos.Units.skelator.fist.area;
          }
          
          override public function cleanUp() : void
          {
               super.cleanUp();
               removeChild(this.spellMc);
               this.spellMc = null;
          }
          
          private function damageUnit(unit:Unit) : void
          {
               if(this.team != unit.team)
               {
                    unit.damage(0,damageToDeal,null);
               }
          }
          
          override public function update(game:StickWar) : void
          {
               if(this.spellMc.currentFrame == 1)
               {
                    game.soundManager.playSound("Hellfistin",px,py);
               }
               else if(this.spellMc.currentFrame == 24)
               {
                    game.soundManager.playSoundRandom("Hellfistout",3,px,py);
               }
               this.visible = true;
               this.spellMc.nextFrame();
               this.scaleX = 1 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               this.scaleY = 1 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               if(this.spellMc.currentFrame == 10)
               {
                    game.spatialHash.mapInArea(this.px - this.fistRange,this.py - this.fistRange,this.px + this.fistRange,this.py + this.fistRange,this.damageUnit);
               }
          }
          
          override public function isReadyForCleanup() : Boolean
          {
               return this.spellMc.currentFrame == this.spellMc.totalFrames;
          }
          
          override public function isInFlight() : Boolean
          {
               return this.spellMc.currentFrame != this.spellMc.totalFrames;
          }
     }
}
