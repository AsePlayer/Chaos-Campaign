package com.brockw.stickwar.engine.maps
{
   import com.brockw.stickwar.engine.Background;
   import com.brockw.stickwar.engine.Hill;
   import com.brockw.stickwar.engine.Ore;
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.*;
   
   public class Mountains extends Map
   {
       
      
      private var _width:int;
      
      private var _height:int;
      
      private var _y:int;
      
      private var _screenWidth:int;
      
      private var _screenHeight:int;
      
      private var _gold:Vector.<Ore>;
      
      private var _hills:Vector.<Hill>;
      
      public function Mountains(game:StickWar)
      {
         super();
         this.init(game);
      }
      
      override public function init(game:StickWar) : void
      {
         var vector:Vector.<MovieClip> = new Vector.<MovieClip>();
         vector.push(new mountainsForeground());
         vector.push(new mountainsMidground());
         vector.push(new mountainsBackground());
         game.background = new Background(vector,game);
         game.addChild(game.background);
         setDimensions(game);
         createMiningBlock(game,this.screenWidth + 670,1);
         createMiningBlock(game,this.width - this.screenWidth - 670,-1);
         createMiningBlock(game,this.screenWidth + 1200,1);
         createMiningBlock(game,this.width - this.screenWidth - 1200,-1);
         var h:Hill = new Hill(game);
         h.init(this.width / 2,this.height / 2,game);
         hills.push(h);
         super.init(game);
      }
   }
}
