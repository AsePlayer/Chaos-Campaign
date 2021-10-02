package com.brockw.stickwar.engine.maps
{
   import com.brockw.stickwar.engine.Background;
   import com.brockw.stickwar.engine.Hill;
   import com.brockw.stickwar.engine.Ore;
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.MovieClip;
   
   public class GrassHills extends Map
   {
       
      
      private var _width:int;
      
      private var _height:int;
      
      private var _y:int;
      
      private var _screenWidth:int;
      
      private var _screenHeight:int;
      
      private var _gold:Vector.<Ore>;
      
      private var _hills:Vector.<Hill>;
      
      public function GrassHills(game:StickWar)
      {
         super();
         this.init(game);
      }
      
      override public function init(game:StickWar) : void
      {
         var vector:Vector.<MovieClip> = new Vector.<MovieClip>();
         vector.push(new grassForeground());
         vector.push(new grassMiddleground());
         vector.push(new grassClouds());
         vector.push(new grassSky());
         game.background = new Background(vector,game);
         game.addChild(game.background);
         setDimensions(game);
         createMiningBlock(game,this.screenWidth + 670,1);
         createMiningBlock(game,this.width - this.screenWidth - 670,-1);
         createMiningBlock(game,this.screenWidth + 1200,1);
         createMiningBlock(game,this.width - this.screenWidth - 1200,-1);
         this.addHill(this.width / 2,this.height / 2,game);
         super.init(game);
      }
      
      private function addHill(x:Number, y:Number, game:*) : void
      {
         var h:Hill = new Hill(game);
         h.init(x,y,game);
         hills.push(h);
      }
   }
}
