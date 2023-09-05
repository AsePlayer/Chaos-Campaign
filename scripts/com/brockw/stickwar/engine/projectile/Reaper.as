package com.brockw.stickwar.engine.projectile
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     
     public class Reaper extends DirectedProjectile
     {
           
          
          private var spellMc:MovieClip;
          
          public var target:Unit;
          
          public var reaperScale:Number = 1;
          
          public function Reaper(game:StickWar)
          {
               super(game);
               type = REAPER;
               this.spellMc = new grimreaper();
               addChild(this.spellMc);
               this.spellMc.scaleX *= 1.5;
               this.spellMc.scaleY *= 1.5;
          }
          
          override public function update(game:StickWar) : void
          {
               var dz:Number = NaN;
               visible = true;
               if(!this.target.isAlive())
               {
                    this.visible = false;
                    _inFlight = false;
                    return;
               }
               this.scaleX = game.backScale + py / game.map.height * (game.frontScale - game.backScale);
               this.scaleX *= this.reaperScale;
               this.scaleY = game.backScale + py / game.map.height * (game.frontScale - game.backScale);
               this.scaleY *= this.reaperScale;
               var targetScale:int = Util.sgn(this.target.px - startX);
               if(targetScale != Util.sgn(this.scaleX))
               {
                    scaleX *= -1;
               }
               var nx:Number = _startX + t / timeOfFlight * (this.target.px - _startX);
               var ny:Number = _startY + t / timeOfFlight * (this.target.py - _startY);
               var nz:Number = _startZ + t / timeOfFlight * (this.target.pz - _startZ);
               var dx:Number = nx - px;
               var dy:Number = ny - py;
               dz = nz - pz;
               px = nx;
               py = ny;
               pz = nz;
               this.x = px;
               this.y = pz + py;
               if(pz > 0 && dz > 0)
               {
                    dz = dx = dy = 0;
               }
               t += 1;
               if(t >= timeOfFlight)
               {
                    this.target.reaperCurse(inflictor);
                    this.target.poison(this.poisonDamage);
                    this.target.damage(0,this.damageToDeal,null);
                    this.target.stun(this.stunTime);
                    this.target.slow(this.slowFrames);
                    _inFlight = false;
                    visible = false;
               }
          }
     }
}
