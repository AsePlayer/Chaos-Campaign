package com.brockw.stickwar.engine.projectile
{
   import com.brockw.stickwar.engine.*;
   
   public class ChaosTowerDart extends DirectedProjectile
   {
       
      
      public function ChaosTowerDart(game:StickWar)
      {
         super(game);
         type = TOWER_DART;
         this.graphics.lineStyle(5,65280,1);
         this.graphics.drawCircle(0,0,3);
         if(Boolean(game))
         {
            this.damageToDeal = game.xml.xml.Chaos.Units.tower.damage;
         }
      }
   }
}
