package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.Unit;
   import com.brockw.stickwar.engine.units.Wall;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class Boulder extends Projectile
   {
       
      
      private var spellMc:MovieClip;
      
      private var stunTimeBoulder:Number;
      
      protected var p4:Point;
      
      protected var p5:Point;
      
      protected var p6:Point;
      
      protected var p7:Point;
      
      protected var p8:Point;
      
      protected var p9:Point;
      
      public function Boulder(game:StickWar)
      {
         super();
         type = BOULDER;
         this.spellMc = new boulderMc();
         this.addChild(this.spellMc);
         this.spellMc.x -= this.spellMc.width / 2;
         this.spellMc.y -= this.spellMc.height / 2;
         this.spellMc.scaleX = 1;
         this.spellMc.scaleY = 1;
         _drotation = 0;
         _rot = 0;
         this.stunTimeBoulder = game.xml.xml.Order.Units.giant.stunTime;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         removeChild(this.spellMc);
         this.spellMc = null;
      }
      
      override protected function arrowHit(u:Unit) : void
      {
         if(hasHit)
         {
            return;
         }
         if(isDebris && u == unitNotToHit)
         {
            return;
         }
         if(Unit(u).team != this.team)
         {
            if(Unit(u).checkForHitPointArrow(p1,py,Unit(u)) || Unit(u).checkForHitPointArrow(p2,py,Unit(u)) || Unit(u).checkForHitPointArrow(p3,py,Unit(u)))
            {
               unitNotToHit = u;
               hasHit = true;
               lastDistanceToCentre = Math.abs(x - u.px);
            }
         }
      }
      
      override public function update(game:StickWar) : void
      {
         var effects:Array = null;
         var effect:Array = null;
         var dir:int = 0;
         var w:Wall = null;
         var cDistance:Number = NaN;
         var direction:Number = NaN;
         var i:int = 0;
         var ndx:* = undefined;
         var ndy:* = undefined;
         var ndz:* = undefined;
         var odx:Number = dx;
         var ody:Number = dy;
         var odz:Number = dz;
         this.stunTime = this.stunTimeBoulder;
         this.visible = true;
         this.scaleX = this._scale * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
         this.scaleY = this._scale * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
         this.x = px;
         this.y = pz + py;
         if(py < 0)
         {
            visible = false;
         }
         effects = game.projectileManager.airEffects;
         px += dx;
         py += dy;
         pz += dz;
         dz += StickWar.GRAVITY;
         for each(effect in effects)
         {
            if(Math.abs(effect[0] - px) < 100)
            {
               dir = Util.sgn(effect[2]);
               if(Util.sgn(dx) != dir && effect[3] != this.team)
               {
                  dx += effect[2];
               }
            }
         }
         if(pz > 0 && dz > 0 && !hasHit)
         {
            dz = dx = dy = 0;
            if(!hasHit)
            {
               hasHit = true;
            }
         }
         else
         {
            rotation = 90 - Math.atan2(dx,dz + dy) * 180 / Math.PI;
         }
         if(isDebris)
         {
            return;
         }
         p1 = this.localToGlobal(new Point(-10,40));
         p2 = this.localToGlobal(new Point(40,40));
         p3 = this.localToGlobal(new Point(90,40));
         this.p4 = this.localToGlobal(new Point(-10,-10));
         this.p5 = this.localToGlobal(new Point(40,-10));
         this.p6 = this.localToGlobal(new Point(90,-10));
         this.p7 = this.localToGlobal(new Point(-10,90));
         this.p8 = this.localToGlobal(new Point(40,90));
         this.p9 = this.localToGlobal(new Point(90,90));
         if(!hasHit)
         {
            game.spatialHash.mapInArea(px - 100,py - 100,px + 100,py + 100,this.arrowHit);
            for each(w in team.enemyTeam.walls)
            {
               this.arrowHit(w);
            }
         }
         else if(unitNotToHit != null)
         {
            cDistance = Math.abs(x - unitNotToHit.px);
            if(!Unit(unitNotToHit).checkForHitPoint(p3,Unit(unitNotToHit)) || cDistance > lastDistanceToCentre)
            {
               direction = Util.sgn(dx);
               dz = dx = dy = 0;
               this.visible = false;
               if(unitNotToHit is Unit)
               {
                  Unit(unitNotToHit).stun(this.stunTime);
                  Unit(unitNotToHit).poison(this.poisonDamage);
                  Unit(unitNotToHit).slow(slowFrames);
               }
               if(this is Boulder)
               {
                  Unit(unitNotToHit).applyVelocity(2 * Util.sgn(direction));
               }
               Entity(unitNotToHit.damage(isFire ? 1 : 0,damageToDeal,_inflictor));
            }
            lastDistanceToCentre = cDistance;
         }
         this.rotation = _rot;
         _rot += _drotation;
         visible = true;
         if(!this.isInFlight())
         {
            visible = false;
         }
         if(!this.isInFlight() && !isDebris)
         {
            team.game.soundManager.playSound("BoulderSmashSound",px,py);
            for(i = 0; i < 5; i++)
            {
               ndx = odx * 0.6 + game.random.nextNumber() * 4 - 2;
               ndy = ody * 0.6 + game.random.nextNumber() * 10 - 5;
               ndz = odz * 0.6 + game.random.nextNumber() * 4 - 2;
               game.projectileManager.initBoulderDebris(px,py,pz,ndx,ndy,ndz,0.2,game,inflictor,unitNotToHit);
            }
         }
      }
   }
}
