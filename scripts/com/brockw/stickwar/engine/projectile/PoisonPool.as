package com.brockw.stickwar.engine.projectile
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     
     public class PoisonPool extends Projectile
     {
           
          
          internal var spellMc:MovieClip;
          
          internal var explosionRadius:Number;
          
          internal var explosionDamage:Number;
          
          public var frames:int;
          
          internal var timeToLive:int;
          
          public var comment:String;
          
          public function PoisonPool(game:StickWar)
          {
               super();
               type = Projectile.POISON_POOL;
               this.spellMc = new poisonMedusaSpell();
               this.addChild(this.spellMc);
               this.frames = 0;
               this.explosionRadius = game.xml.xml.Chaos.Units.medusa.poison.area;
               this.timeToLive = game.xml.xml.Chaos.Units.medusa.poison.time;
          }
          
          override public function cleanUp() : void
          {
               super.cleanUp();
               removeChild(this.spellMc);
               this.spellMc = null;
          }
          
          override public function update(game:StickWar) : void
          {
               var rx:Number = NaN;
               this.scaleX = Util.sgn(scaleX) * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               this.scaleY = 1 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
               this.spellMc.nextFrame();
               Util.animateMovieClip(this.spellMc,0);
               var units:Array = team.enemyTeam.units;
               var n:int = int(units.length);
               if(this.spellMc.currentFrame > 20)
               {
                    rx = px + Util.sgn(scaleX) * 75;
                    game.spatialHash.mapInArea(rx - this.explosionRadius / 2,py - this.explosionRadius / 2,rx + this.explosionRadius / 2,py + this.explosionRadius / 2,this.poisonUnit);
               }
               ++this.frames;
          }
          
          private function poisonUnit(unit:Unit) : void
          {
               if(unit.team != this.team)
               {
                    if(Math.pow(unit.px - this.px,2) + Math.pow(unit.py - this.py,2) < Math.pow(this.explosionRadius,2))
                    {
                         if(!unit.isFlying() || this.spellMc.currentFrame < 60 && unit.isFlying())
                         {
                              unit.poison(this.poisonDamage);
                         }
                    }
               }
          }
          
          override public function isReadyForCleanup() : Boolean
          {
               return this.timeToLive <= this.frames;
          }
          
          override public function isInFlight() : Boolean
          {
               return this.timeToLive > this.frames;
          }
     }
}
