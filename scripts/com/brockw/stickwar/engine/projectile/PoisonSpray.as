package com.brockw.stickwar.engine.projectile
{
     import com.brockw.stickwar.engine.*;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.*;
     
     public class PoisonSpray extends Projectile
     {
           
          
          internal var spellMc:MovieClip;
          
          public var startX:Number;
          
          public var startY:Number;
          
          public var endX:Number;
          
          public var endY:Number;
          
          public function PoisonSpray(game:StickWar)
          {
               super();
               type = POISON_SPRAY;
               this.spellMc = new poisonMagikilleffect();
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
               this.visible = true;
               this.spellMc.nextFrame();
               this.scaleX = 1 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               this.scaleY = 1 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               var units:Array = team.enemyTeam.units;
               var n:int = int(units.length);
               var r:Number = this.spellMc.currentFrame / 20;
               if(r > 1)
               {
                    return;
               }
               var rx:Number = r * (this.endX - this.startX) + this.startX;
               var ry:Number = r * (this.endY - this.startY) + this.startY;
               for(var i:int = 0; i < n; i++)
               {
                    if(Unit(units[i]).team != this.team && units[i] is Unit)
                    {
                         if(Math.pow(Unit(units[i]).px - rx,2) + Math.pow(Unit(units[i]).py - ry,2) < Math.pow(game.xml.xml.Order.Units.magikill.poisonSpray.area,2))
                         {
                              Unit(units[i]).poison(this.poisonDamage);
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
