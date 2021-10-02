package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.*;
   
   public class Background extends Entity
   {
       
      
      private var layers:Vector.<MovieClip>;
      
      private var _mapLength:int;
      
      private var time:Number;
      
      private var splitLayers:Vector.<Vector.<Bitmap>>;
      
      private var splitLayersOnScreen:Vector.<int>;
      
      private var layerContainers:Vector.<Sprite>;
      
      public function Background(layerList:Vector.<MovieClip>, main:StickWar)
      {
         var m:MovieClip = null;
         var newLayers:Vector.<Bitmap> = null;
         var boundingRect:Rectangle = null;
         var x:int = 0;
         var s:Sprite = null;
         var b:BitmapData = null;
         var newBitmap:Bitmap = null;
         this.splitLayers = new Vector.<Vector.<Bitmap>>();
         this.splitLayersOnScreen = new Vector.<int>();
         this.layerContainers = new Vector.<Sprite>();
         this.layers = new Vector.<MovieClip>();
         this.mapLength = 0;
         ++main.main.loadingFraction;
         for(var i:int = layerList.length - 1; i >= 0; i--)
         {
            m = layerList[i];
            ++main.main.loadingFraction;
            if(m.width > this.mapLength)
            {
               this.mapLength = m.width;
            }
            this.layers.push(m);
            ++main.main.loadingFraction;
            newLayers = new Vector.<Bitmap>();
            ++main.main.loadingFraction;
            boundingRect = new Rectangle(0,0,main.stage.stageWidth + 1,main.stage.stageHeight);
            ++main.main.loadingFraction;
            for(x = 0; x < m.width; x += main.stage.stageWidth)
            {
               boundingRect.x = 0;
               b = new BitmapData(main.stage.stageWidth + 1,main.stage.stageHeight,true,0);
               ++main.main.loadingFraction;
               b.draw(m,new Matrix(1,0,0,1,-x,0),null,null,boundingRect,false);
               ++main.main.loadingFraction;
               newBitmap = new Bitmap(b);
               ++main.main.loadingFraction;
               newLayers.push(newBitmap);
               newBitmap.cacheAsBitmap = true;
               ++main.main.loadingFraction;
               newBitmap.x = x;
            }
            this.splitLayersOnScreen.push(-1);
            ++main.main.loadingFraction;
            this.splitLayers.push(newLayers);
            ++main.main.loadingFraction;
            s = new Sprite();
            this.layerContainers.push(s);
            addChild(s);
            ++main.main.loadingFraction;
         }
         this.time = 0;
         py = 0;
         super();
      }
      
      override public function cleanUp() : void
      {
      }
      
      public function update(game:StickWar) : void
      {
         var p:Number = NaN;
         var dest:* = undefined;
         var piece:int = 0;
         for(var i:int = 0; i < this.layers.length; i++)
         {
            if(game.gameScreen.hasMovingBackground || i == this.layers.length - 1)
            {
               p = game.screenX / (this.mapLength - stage.stageWidth);
               dest = -p * (this.layers[i].width - stage.stageWidth);
               piece = Math.floor(game.screenX / this.mapLength * this.splitLayers[i].length);
               if(piece >= this.splitLayers[i].length)
               {
                  piece = this.splitLayers[i].length - 1;
               }
               if(piece < 0)
               {
                  piece = 0;
               }
               if(piece != this.splitLayersOnScreen[i])
               {
                  if(this.splitLayersOnScreen[i] != -1)
                  {
                     this.removeAround(i,this.splitLayersOnScreen[i]);
                  }
                  this.addAround(i,piece,dest);
                  this.splitLayersOnScreen[i] = piece;
               }
               else
               {
                  this.moveAround(i,piece,dest);
               }
            }
         }
      }
      
      public function removeAround(i:int, piece:int) : void
      {
         if(piece == -1)
         {
            return;
         }
         if(piece - 1 >= 0)
         {
            this.layerContainers[i].removeChild(this.splitLayers[i][piece - 1]);
         }
         this.layerContainers[i].removeChild(this.splitLayers[i][piece]);
         if(piece + 1 < this.splitLayers[i].length)
         {
            this.layerContainers[i].removeChild(this.splitLayers[i][piece + 1]);
         }
      }
      
      public function moveAround(i:int, piece:int, dest:Number) : void
      {
         if(piece == -1)
         {
            return;
         }
         if(piece - 1 >= 0)
         {
            this.splitLayers[i][piece - 1].x = dest + (piece - 1) * stage.stageWidth;
         }
         this.splitLayers[i][piece].x = dest + piece * stage.stageWidth;
         if(piece + 1 < this.splitLayers[i].length)
         {
            this.splitLayers[i][piece + 1].x = dest + (piece + 1) * stage.stageWidth;
         }
      }
      
      public function addAround(i:int, piece:int, dest:Number) : void
      {
         if(piece == -1)
         {
            return;
         }
         if(piece - 1 >= 0)
         {
            this.layerContainers[i].addChild(this.splitLayers[i][piece - 1]);
            this.splitLayers[i][piece - 1].x = dest + (piece - 1) * stage.stageWidth;
         }
         this.layerContainers[i].addChild(this.splitLayers[i][piece]);
         this.splitLayers[i][piece].x = dest + piece * stage.stageWidth;
         if(piece + 1 < this.splitLayers[i].length)
         {
            this.layerContainers[i].addChild(this.splitLayers[i][piece + 1]);
            this.splitLayers[i][piece + 1].x = dest + (piece + 1) * stage.stageWidth;
         }
      }
      
      public function minScreenX() : int
      {
         return 0;
      }
      
      public function maxScreenX() : int
      {
         return this.mapLength - stage.stageWidth;
      }
      
      public function get mapLength() : int
      {
         return this._mapLength;
      }
      
      public function set mapLength(value:int) : void
      {
         this._mapLength = value;
      }
   }
}
