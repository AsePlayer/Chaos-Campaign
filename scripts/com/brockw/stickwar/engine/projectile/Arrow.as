package com.brockw.stickwar.engine.projectile
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.StickWar;
     
     public class Arrow extends Projectile
     {
           
          
          private var mc:arrowMc;
          
          public function Arrow(game:StickWar)
          {
               super();
               isFire = false;
               type = ARROW;
               hasArrowDeath = true;
               this.mc = new arrowMc();
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
