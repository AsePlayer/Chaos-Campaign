package com.brockw.stickwar.market
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.StickWar;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class MarketScreen extends Screen
   {
      
      private static const NUM_COLS = 5;
      
      private static const NUM_ROWS = 5;
       
      
      private var main:Main;
      
      private var marketItems:Array;
      
      private var items:Array;
      
      private var timer:Timer;
      
      var stickwar:StickWar;
      
      public function MarketScreen(main:Main)
      {
         var mainMenuButton:GenericButton = null;
         super();
         this.main = main;
         var txtWelcome:GenericText = new GenericText();
         txtWelcome.text.text = "Market Place";
         txtWelcome.width *= 2.5;
         txtWelcome.height *= 2.5;
         txtWelcome.x = main.stage.stageWidth / 2 - txtWelcome.width / 2;
         txtWelcome.y = main.stage.stageHeight * 0.1 - txtWelcome.height / 2;
         addChild(txtWelcome);
         mainMenuButton = new GenericButton();
         mainMenuButton.text.text = "Main Menu";
         mainMenuButton.buttonMode = true;
         mainMenuButton.mouseChildren = false;
         mainMenuButton.width *= 1;
         mainMenuButton.height *= 1;
         mainMenuButton.x = main.stage.stageWidth / 2 - mainMenuButton.width / 2;
         mainMenuButton.y = main.stage.stageHeight * 0.9 - mainMenuButton.height / 2;
         mainMenuButton.addEventListener(MouseEvent.CLICK,function(evt:Event):*
         {
            main.showScreen("lobby");
         });
         addChild(mainMenuButton);
      }
      
      public function update(evt:Event) : void
      {
      }
      
      public function clicked(evt:MouseEvent) : void
      {
         var item:MovieClip = null;
         var params:SFSObject = null;
         var r:ExtensionRequest = null;
         for(var i:* = 0; i < this.marketItems.length; i++)
         {
            item = MarketItem(this.marketItems[i]).marketMc;
            if(item.hitTestPoint(stage.mouseX,stage.mouseY,true))
            {
               params = new SFSObject();
               params.putInt("itemId",MarketItem(this.marketItems[i]).id);
               r = new ExtensionRequest("buy",params);
               this.main.sfs.send(r);
            }
         }
      }
      
      public function drawMarketPlace() : void
      {
      }
      
      public function updateMarketItems() : void
      {
         this.setMarketItems();
      }
      
      public function setMarketItems() : void
      {
         if(this.main.marketItems == null)
         {
            return;
         }
      }
      
      override public function enter() : void
      {
         this.setMarketItems();
         this.addEventListener(MouseEvent.CLICK,this.clicked);
      }
      
      override public function leave() : void
      {
         var m:MarketItem = null;
         for(var i:int = 0; i < this.main.marketItems.length; i++)
         {
            m = this.main.marketItems[i];
            if(this.contains(m.marketMc))
            {
               removeChild(m.marketMc);
            }
         }
         this.removeEventListener(MouseEvent.CLICK,this.clicked);
      }
   }
}
