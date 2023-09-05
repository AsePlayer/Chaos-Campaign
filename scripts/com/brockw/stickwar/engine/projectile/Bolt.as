package com.brockw.stickwar.engine.projectile
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.StickWar;
     
     public class Bolt extends Projectile
     {
           
          
          private var mc:boltMc;
          
          public function Bolt(game:StickWar)
          {
               super();
               isFire = false;
               type = BOLT;
               hasArrowDeath = true;
               this.mc = new boltMc();
               addChild(this.mc);
          }
          
          public function setArrowGraphics(fire:Boolean) : void
          {
               if(fire)
               {
                    this.mc.gotoAndStop(2);
               }
               else
               {
                    this.mc.gotoAndStop(1);
               }
          }
          
          override public function update(game:StickWar) : void
          {
               super.update(game);
               Util.animateMovieClip(this.mc);
               if(!this.isInFlight())
               {
                    this.mc.gotoAndStop(3);
               }
          }
     }
}
