package com.brockw.stickwar.engine
{
   import com.brockw.game.Util;
   import flash.display.Sprite;
   
   public class BloodManager extends Sprite
   {
      
      private static const NUM_BLOODS:int = 100;
      
      private static const NUM_ASHES:int = 10;
       
      
      private var bloodPool:Array;
      
      private var bloods:Array;
      
      private var ashPool:Array;
      
      private var ashs:Array;
      
      public function BloodManager()
      {
         var _loc1_:int = 0;
         var _loc2_:bloodSplat = null;
         var _loc3_:_ash = null;
         this.bloods = [];
         this.bloodPool = [];
         for(_loc1_ = 0; _loc1_ < NUM_BLOODS; _loc1_++)
         {
            _loc2_ = new bloodSplat();
            _loc2_.cacheAsBitmap = true;
            this.bloodPool.push(_loc2_);
         }
         this.ashs = [];
         this.ashPool = [];
         for(_loc1_ = 0; _loc1_ < NUM_ASHES; _loc1_++)
         {
            _loc3_ = new _ash();
            _loc3_.cacheAsBitmap = true;
            this.ashPool.push(_loc3_);
         }
         super();
      }
      
      public function addAsh(px:Number, py:Number, direction:int, game:StickWar) : void
      {
         var newAsh:_ash = null;
         if(this.ashPool.length > 0)
         {
            newAsh = this.ashPool.pop();
         }
         else
         {
            newAsh = this.ashs.shift();
         }
         this.ashs.push(newAsh);
         newAsh.gotoAndStop(game.random.nextInt() % newAsh.totalFrames);
         newAsh.x = px;
         newAsh.y = py;
         newAsh.alpha = 0.9;
         newAsh.scaleX = -Util.sgn(direction) * game.getPerspectiveScale(py);
         newAsh.scaleY = game.getPerspectiveScale(py);
         addChild(newAsh);
      }
      
      public function addBlood(px:Number, py:Number, direction:int, game:StickWar) : void
      {
         var newBlood:bloodSplat = null;
         if(this.bloodPool.length > 0)
         {
            newBlood = this.bloodPool.pop();
         }
         else
         {
            newBlood = this.bloods.shift();
         }
         this.bloods.push(newBlood);
         newBlood.gotoAndStop(game.random.nextInt() % newBlood.totalFrames);
         newBlood.x = px;
         newBlood.y = py;
         newBlood.alpha = 0.8;
         newBlood.scaleX = -Util.sgn(direction) * game.getPerspectiveScale(py);
         newBlood.scaleY = game.getPerspectiveScale(py);
         addChild(newBlood);
      }
   }
}
