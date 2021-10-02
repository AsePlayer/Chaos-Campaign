package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.MovieClip;
   
   public class TowerSpawn extends Projectile
   {
       
      
      var spellMc:MovieClip;
      
      public function TowerSpawn(game:StickWar)
      {
         super();
         type = TOWER_SPAWN;
         this.spellMc = new spawnTowerMc();
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
         Util.animateMovieClip(this.spellMc,4);
         this.scaleX = scale * 1 * team.direction;
         this.scaleY = scale * 1;
      }
      
      override public function isReadyForCleanup() : Boolean
      {
         return this.spellMc.mc.currentFrame == this.spellMc.mc.totalFrames;
      }
      
      override public function isInFlight() : Boolean
      {
         return this.spellMc.mc.currentFrame != this.spellMc.mc.totalFrames;
      }
   }
}
