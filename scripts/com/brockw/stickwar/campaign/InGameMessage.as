package com.brockw.stickwar.campaign
{
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   
   public class InGameMessage extends Sprite
   {
       
      
      private var mc:inGameMessageBoxMc;
      
      private var newTxt:String;
      
      private var newStep:String;
      
      private var isTransitioning:Boolean;
      
      private var nextYOffset:Number;
      
      private var soundToPlay:String;
      
      private var length:Number;
      
      private var startPlayingTime:Number;
      
      private var game:StickWar;
      
      private var compliment:Boolean;
      
      private var shouldCompliment:Boolean;
      
      public function InGameMessage(txt:String, game:StickWar)
      {
         super();
         this.mc = new inGameMessageBoxMc();
         this.setMessage(txt,"Step 1");
         this.isTransitioning = true;
         this.mc.x = -600;
         this.nextYOffset = 0;
         addChild(this.mc);
         this.game = game;
         this.soundToPlay = "";
         this.length = 0;
         this.startPlayingTime = 0;
         this.shouldCompliment = this.compliment = false;
      }
      
      public function isMessageShowing() : Boolean
      {
         return !this.isTransitioning && this.mc.text.text == this.newTxt;
      }
      
      public function isShowingNewMessage() : Boolean
      {
         return this.mc.text.text == this.newTxt;
      }
      
      public function hasFinishedPlayingSound() : Boolean
      {
         return this.mc.text.text == this.newTxt && getTimer() - this.startPlayingTime > this.length;
      }
      
      public function setMessage(txt:String, step:String, yOffset:* = 0, soundToPlay:String = "", compliment:Boolean = false) : void
      {
         if(this.mc.text.text != txt && getTimer() - this.startPlayingTime > this.length)
         {
            this.newTxt = txt;
            this.newStep = step;
            this.nextYOffset = yOffset;
            this.soundToPlay = soundToPlay;
            this.compliment = compliment;
         }
      }
      
      public function update() : void
      {
         if(!this.isTransitioning)
         {
            if(this.mc.text.text != this.newTxt && getTimer() - this.startPlayingTime > this.length)
            {
               if(this.mc.tick.currentFrame != this.mc.tick.totalFrames && this.mc.step.text != "")
               {
                  if(this.mc.tick.currentFrame == 1 && this.shouldCompliment)
                  {
                     this.game.soundManager.playSoundFullVolumeRandom("tutorialGood",4);
                  }
                  this.mc.tick.nextFrame();
               }
               else
               {
                  this.isTransitioning = true;
               }
            }
         }
         else if(this.mc.text.text == this.newTxt)
         {
            this.mc.x += (0 - this.mc.x) * 0.4;
            if(Math.abs(0 - this.mc.x) < 1)
            {
               this.isTransitioning = false;
            }
         }
         else
         {
            this.mc.x += (-stage.stageWidth / 2 - this.mc.width / 2 - this.mc.x) * 0.4;
            if(Math.abs(-stage.stageWidth / 2 - this.mc.width / 2 - this.mc.x) < 1)
            {
               this.mc.text.text = this.newTxt;
               this.mc.step.text = this.newStep;
               this.mc.y = this.nextYOffset;
               this.shouldCompliment = this.compliment;
               this.mc.tick.gotoAndStop(1);
               this.mc.x = stage.stageWidth / 2 + this.mc.width / 2;
               this.length = this.game.soundManager.playSoundFullVolume(this.soundToPlay);
               this.startPlayingTime = getTimer();
               if(this.newStep == "")
               {
                  this.mc.tick.visible = false;
               }
               else
               {
                  this.mc.tick.visible = true;
               }
            }
         }
      }
   }
}
