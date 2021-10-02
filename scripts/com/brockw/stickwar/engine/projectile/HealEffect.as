package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class HealEffect extends Projectile
   {
       
      
      var spellMc:MovieClip;
      
      public var unit:Unit;
      
      private var _isCure:Boolean;
      
      public function HealEffect(game:StickWar)
      {
         super();
         type = HEAL_EFFECT;
         this.spellMc = new healingEffectMc();
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
         var p:Point = null;
         Util.animateMovieClipBasic(this.spellMc);
         this.scaleX = 2.2;
         this.scaleY = 2.2;
         p = this.unit.healthBar.localToGlobal(new Point(0,60));
         p = team.game.battlefield.globalToLocal(p);
         px = this.unit.x;
         py = this.unit.py;
         x = px;
         y = p.y;
      }
      
      override public function isReadyForCleanup() : Boolean
      {
         return this.spellMc.currentFrame == this.spellMc.totalFrames;
      }
      
      override public function isInFlight() : Boolean
      {
         return this.spellMc.currentFrame != this.spellMc.totalFrames;
      }
      
      public function get isCure() : Boolean
      {
         return this._isCure;
      }
      
      public function set isCure(value:Boolean) : void
      {
         if(value)
         {
            removeChild(this.spellMc);
            addChild(this.spellMc = new cureEffectMc());
         }
         else
         {
            removeChild(this.spellMc);
            addChild(this.spellMc = new healingEffectMc());
         }
         this._isCure = value;
      }
   }
}
