package com.brockw.stickwar.engine
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class FogOfWar extends Entity
   {
      
      private static const TARGET_ALPHA:Number = 0.7;
       
      
      private var X_SIZE:Number = 100;
      
      private var Y_SIZE:Number = 700;
      
      private var VISION_LENGTH:int;
      
      private var oldForwardPosition:Number;
      
      private var movingFog:Array;
      
      var fog:_fog;
      
      var fogLowQuality:_fogLowQuality;
      
      var fogBlur:_fogFade;
      
      var xPos:Number;
      
      public var isFogOn:Boolean;
      
      private var blockMc:MovieClip;
      
      public function FogOfWar(game:StickWar)
      {
         super();
         this.xPos = 0;
         this.isFogOn = true;
         this.fog = new _fog();
         this.fog.y = 0;
         this.setTint(this.fog,0,0.9);
         this.fog.alpha = TARGET_ALPHA;
         addChild(this.fog);
         this.VISION_LENGTH = game.xml.xml.visionSize;
         this.fog.cacheAsBitmap = true;
         this.fogLowQuality = new _fogLowQuality();
         this.fogLowQuality.y = 0;
         this.fogLowQuality.alpha = 1;
         addChild(this.fogLowQuality);
         this.VISION_LENGTH = game.xml.xml.visionSize;
         this.fogLowQuality.cacheAsBitmap = true;
      }
      
      function setTint(displayObject:DisplayObject, tintColor:uint, tintMultiplier:Number) : void
      {
         var colTransform:ColorTransform = new ColorTransform();
         colTransform.redMultiplier = colTransform.greenMultiplier = colTransform.blueMultiplier = 1 - tintMultiplier;
         colTransform.redOffset = Math.round(((tintColor & 16711680) >> 16) * tintMultiplier);
         colTransform.greenOffset = Math.round(((tintColor & 65280) >> 8) * tintMultiplier);
         colTransform.blueOffset = Math.round((tintColor & 255) * tintMultiplier);
         displayObject.transform.colorTransform = colTransform;
      }
      
      public function update(game:StickWar) : void
      {
         var forwardPosition:* = game.team.getVisionRange();
         if(!this.isFogOn)
         {
            this.alpha = 0;
         }
         else
         {
            alpha = 1;
         }
         if(this.xPos == 0)
         {
            this.xPos = forwardPosition;
         }
         this.xPos += (forwardPosition - this.xPos) * 1;
         if(game.gameScreen.hasAlphaOnFogOfWar)
         {
            if(!contains(this.fog))
            {
               addChild(this.fog);
            }
            if(contains(this.fogLowQuality))
            {
               removeChild(this.fogLowQuality);
            }
            if(game.team == game.teamB)
            {
               this.fog.scaleX = -1;
            }
            else
            {
               this.fog.scaleX = 1;
            }
            if(game.team.direction == 1)
            {
               this.fog.x = Math.max(this.xPos,game.screenX);
            }
            else
            {
               this.fog.x = Math.min(this.xPos,game.screenX + game.map.screenWidth);
            }
         }
         else
         {
            if(!contains(this.fogLowQuality))
            {
               addChild(this.fogLowQuality);
            }
            if(contains(this.fog))
            {
               removeChild(this.fog);
            }
            if(game.team == game.teamB)
            {
               this.fogLowQuality.scaleX = -1;
            }
            else
            {
               this.fogLowQuality.scaleX = 1;
            }
            if(game.team.direction == 1)
            {
               this.fogLowQuality.x = Math.max(this.xPos,game.screenX);
            }
            else
            {
               this.fogLowQuality.x = Math.min(this.xPos,game.screenX + game.map.screenWidth);
            }
         }
      }
   }
}
