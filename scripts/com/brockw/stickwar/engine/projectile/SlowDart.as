package com.brockw.stickwar.engine.projectile
{
     import com.brockw.stickwar.engine.StickWar;
     
     public class SlowDart extends DirectedProjectile
     {
           
          
          public function SlowDart(game:StickWar)
          {
               super(game);
               type = SLOW_DART;
               this.graphics.lineStyle(5,65280,1);
               this.graphics.moveTo(-5,0);
               this.graphics.lineTo(5,0);
          }
     }
}
