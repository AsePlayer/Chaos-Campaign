package com.brockw.stickwar.engine.projectile
{
     import com.brockw.stickwar.engine.*;
     import com.brockw.stickwar.engine.units.*;
     import flash.display.*;
     
     public class Heal extends Projectile
     {
           
          
          internal var spellMc:MovieClip;
          
          public function Heal(game:StickWar)
          {
               super();
               type = HEAL;
               this.spellMc = new healSpellMc();
               this.addChild(this.spellMc);
          }
          
          override public function cleanUp() : void
          {
               super.cleanUp();
               removeChild(this.spellMc);
               this.spellMc = null;
          }
          
          override public function update(game:StickWar) : void
          {
               var i:int = 0;
               this.spellMc.nextFrame();
               this.scaleX = 0.4 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               this.scaleY = 0.4 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               var units:Vector.<Entity> = game.spatialHash.getNearbyEntitysXY(this.px,this.py);
               var n:int = game.spatialHash.getNumberOfNearbyEntitysXY(this.px,this.py);
               if(this.spellMc.currentFrame == Math.floor(this.spellMc.totalFrames / 4))
               {
                    for(i = 0; i < n; i++)
                    {
                         if(Unit(units[i]).team == this.team)
                         {
                              if(Math.pow(Unit(units[i]).px - this.px,2) + Math.pow(Unit(units[i]).py - this.py,2) < Math.pow(game.xml.xml.Order.Units.monk.healArea,2))
                              {
                                   dz = dx = dy = 0;
                                   Unit(units[i]).heal(game.xml.xml.Order.Units.monk.healAmount,game.xml.xml.Order.Units.monk.healDuration);
                              }
                         }
                    }
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
