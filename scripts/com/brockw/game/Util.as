package com.brockw.game
{
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.display.*;
   
   public class Util
   {
      
      private static var sineTable:Array;
      
      private static var cosTable:Array;
      
      private static var tanTable:Array;
      
      private static const PI:Number = 3.14159265;
      
      private static const GRANULATIRY:Number = 360;
       
      
      public function Util()
      {
         super();
         this.preComputeMath();
      }
      
      public static function sin(x:Number) : Number
      {
         x = x * 180 / PI;
         x %= 360;
         if(x < 0)
         {
            x += 360;
         }
         return Util.sineTable[Math.floor(x)];
      }
      
      public static function cos(x:Number) : Number
      {
         x = x * 180 / PI;
         x %= 360;
         if(x < 0)
         {
            x += 360;
         }
         return Util.cosTable[Math.floor(x)];
      }
      
      public static function tan(x:Number) : Number
      {
         x = x * 180 / PI;
         x %= 360;
         if(x < 0)
         {
            x += 360;
         }
         return Util.tanTable[Math.floor(x)];
      }
      
      public static function sgn(a:Number) : int
      {
         if(a < 0)
         {
            return -1;
         }
         return 1;
      }
      
      public static function clearSFSObject(sfsObject:SFSObject) : void
      {
         var key:String = null;
         var keys:Array = sfsObject.getKeys();
         for(key in keys)
         {
            sfsObject.removeElement(key);
         }
      }
      
      public static function animateMovieClipBasic(mc:MovieClip) : void
      {
         if(mc == null)
         {
            return;
         }
         if(mc.currentFrameLabel == "stop")
         {
            return;
         }
         if(mc.currentFrame == mc.totalFrames)
         {
            mc.gotoAndStop(1);
         }
         else
         {
            mc.nextFrame();
         }
      }
      
      public static function animateMovieClip(mc:MovieClip, repeatDepth:int = 0, depthLimit:int = -1) : void
      {
         var d:DisplayObject = null;
         if(depthLimit == 0)
         {
            return;
         }
         for(var i:* = 0; i < mc.numChildren; i++)
         {
            d = mc.getChildAt(i);
            if(d is MovieClip)
            {
               animateMovieClip(MovieClip(d),repeatDepth - 1,depthLimit - 1);
               if(MovieClip(d).currentFrameLabel == null)
               {
                  if(MovieClip(d).currentFrame == MovieClip(d).totalFrames)
                  {
                     if(repeatDepth <= 0)
                     {
                        MovieClip(d).gotoAndStop(1);
                     }
                  }
                  else
                  {
                     MovieClip(d).nextFrame();
                  }
               }
            }
         }
      }
      
      public static function animateToNeutral(mc:MovieClip, depthLimit:int = -1) : void
      {
         var d:DisplayObject = null;
         if(depthLimit == 0)
         {
            return;
         }
         for(var i:* = 0; i < mc.numChildren; i++)
         {
            d = mc.getChildAt(i);
            if(d is MovieClip)
            {
               MovieClip(d).gotoAndStop(1);
               animateToNeutral(MovieClip(d),depthLimit - 1);
            }
         }
      }
      
      public static function recursiveRemoval(mc:Sprite) : void
      {
         var d:DisplayObject = null;
         while(mc != null && mc.numChildren > 0)
         {
            d = mc.getChildAt(0);
            if(d == null)
            {
               break;
            }
            if(d is Sprite || d is MovieClip)
            {
               recursiveRemoval(Sprite(d));
            }
            mc.removeChild(d);
         }
      }
      
      public function preComputeMath() : void
      {
         Util.sineTable = [];
         Util.cosTable = [];
         Util.tanTable = [];
         for(var i:* = 0; i < GRANULATIRY; i++)
         {
            Util.sineTable[i] = Math.sin(i * PI / 180);
            Util.cosTable[i] = Math.cos(i * PI / 180);
            Util.tanTable[i] = Math.tan(i * PI / 180);
         }
      }
   }
}
