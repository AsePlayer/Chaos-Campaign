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
      
      private var maxBloods:int = 5;
      
      private var amountOfBloods:int;
      
      public function BloodManager()
      {
         var i:int = 0;
         var newBlood:bloodSplat = null;
         var newAsh:_ash = null;
         this.bloods = [];
         this.bloodPool = [];
         i = 0;
         while(i < NUM_BLOODS)
         {
            newBlood = new bloodSplat();
            newBlood.cacheAsBitmap = true;
            this.bloodPool.push(newBlood);
            i++;
         }
         this.ashs = [];
         this.ashPool = [];
         i = 0;
         while(i < NUM_ASHES)
         {
            newAsh = new _ash();
            newAsh.cacheAsBitmap = true;
            this.ashPool.push(newAsh);
            i++;
         }
         super();
      }
      
      public function addAsh(px:Number, py:Number, direction:int, game:StickWar) : void
      {
         var newAsh:_ash = null;
         if(this.ashs.length >= NUM_ASHES)
         {
            var oldestAsh:_ash = this.ashs.shift();
            removeChild(oldestAsh);
            newAsh = oldestAsh;
         }
         else if(this.ashPool.length > 0)
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
         if(this.bloods.length >= NUM_BLOODS / (this.bloods.length / 4))
         {
            var oldestBlood:bloodSplat = this.bloods.shift();
            removeChild(oldestBlood);
            newBlood = oldestBlood;
         }
         else if(this.bloodPool.length > 0)
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
