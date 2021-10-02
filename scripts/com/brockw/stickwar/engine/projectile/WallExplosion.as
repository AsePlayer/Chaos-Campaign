package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.MovieClip;
   
   public class WallExplosion extends Projectile
   {
       
      
      var spellMc:MovieClip;
      
      var explosionRadius:Number;
      
      var explosionDamage:Number;
      
      public function WallExplosion(game:StickWar)
      {
         super();
         type = WALL_EXPLOSION;
         this.spellMc = new wallExplosion();
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
         this.scaleX = 0.4 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
         this.scaleY = 0.4 * (game.backScale + py / game.map.height * (game.frontScale - game.backScale));
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
