package com.brockw.stickwar.engine.projectile
{
     import com.brockw.stickwar.engine.*;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.*;
     
     public class ElectricWall extends Projectile
     {
           
          
          internal var spellMc:MovieClip;
          
          private var wallArea:Number;
          
          private var frequency:Number;
          
          public function ElectricWall(game:StickWar)
          {
               var mc:DisplayObject = null;
               super();
               type = ELECTRIC_WALL;
               this.spellMc = new electricWallMc();
               this.addChild(this.spellMc);
               for(var i:* = 0; i < this.spellMc.numChildren; i++)
               {
                    mc = this.spellMc.getChildAt(i);
                    if(mc is MovieClip)
                    {
                         MovieClip(mc).gotoAndStop(Math.floor(game.random.nextNumber() * MovieClip(mc).totalFrames));
                    }
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
               for(var i:* = 0; i < this.spellMc.numChildren; i++)
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
               }
               if(game.frame % this.frequency == 0)
               {
                    game.spatialHash.mapInArea(this.px - this.wallArea,0,this.px + this.wallArea,game.map.height,this.hitElectricWall);
               }
               if(this.isReadyForCleanup())
               {
                    this.visible = false;
               }
          }
          
          private function hitElectricWall(unit:Unit) : void
          {
               if(unit.team != this.team)
               {
                    if(Math.abs(unit.px - this.px) < this.wallArea)
                    {
                         Entity(unit.damage(Unit.D_NO_SOUND | Unit.D_NO_BLOOD,damageToDeal,null));
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
