package com.brockw.stickwar.engine.projectile
{
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.DisplayObject;
     import flash.display.MovieClip;
     
     public class ElectricWall extends Projectile
     {
           
          
          internal var spellMc:MovieClip;
          
          private var wallArea:Number;
          
          private var frequency:Number;
          
          public var speed:Number;
          
          public var currentSpeed:Number;
          
          public function ElectricWall(game:StickWar)
          {
               var mc:DisplayObject = null;
               super();
               type = ELECTRIC_WALL;
               this.spellMc = new electricWallMc();
               this.addChild(this.spellMc);
               var i:* = 0;
               while(i < this.spellMc.numChildren)
               {
                    mc = this.spellMc.getChildAt(i);
                    if(mc is MovieClip)
                    {
                         MovieClip(mc).gotoAndStop(Math.floor(game.random.nextNumber() * MovieClip(mc).totalFrames));
                    }
                    i++;
               }
               this.wallArea = game.xml.xml.Order.Units.magikill.electricWall.area;
               this.frequency = game.xml.xml.Order.Units.magikill.electricWall.frequency;
          }
          
          override public function cleanUp() : void
          {
               super.cleanUp();
               removeChild(this.spellMc);
               this.spellMc = null;
          }
          
          override public function update(game:StickWar) : void
          {
               var mc:DisplayObject = null;
               this.visible = true;
               this.spellMc.nextFrame();
               var i:* = 0;
               while(i < this.spellMc.numChildren)
               {
                    mc = this.spellMc.getChildAt(i);
                    if(mc is MovieClip)
                    {
                         MovieClip(mc).nextFrame();
                         if(MovieClip(mc).currentFrame == MovieClip(mc).totalFrames)
                         {
                              MovieClip(mc).gotoAndStop(1);
                         }
                    }
                    i++;
               }
               if(game.frame % this.frequency == 0)
               {
                    game.spatialHash.mapInArea(this.px - this.wallArea,0,this.px + this.wallArea,game.map.height,this.hitElectricWall);
               }
               if(this.isReadyForCleanup())
               {
                    this.visible = false;
               }
               this.px -= this.speed;
               this.px += 0.007 * this.spellMc.currentFrame * this.speed;
               this.x -= this.speed;
               this.x += 0.007 * this.spellMc.currentFrame * this.speed;
          }
          
          private function hitElectricWall(unit:Unit) : void
          {
               if(unit.team != this.team)
               {
                    if(Math.abs(unit.px - this.px) < this.wallArea)
                    {
                         Entity(unit.damage(Unit.D_NO_SOUND | Unit.D_NO_BLOOD,damageToDeal,null));
                         unit.stun(this.frequency / 1.25);
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
