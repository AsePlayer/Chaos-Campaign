package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import fl.controls.ScrollPolicy;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LeaderboardScreen extends Screen
   {
      
      private static const TOP_100:int = 0;
      
      private static const FRIENDS:int = 1;
       
      
      private var mc:leaderboardScreenMc;
      
      private var leaderboardType:int;
      
      private var isMouseDown:Boolean;
      
      private var main:Main;
      
      var leaderboardCards:Array;
      
      private var leaderboardContainer:MovieClip;
      
      public function LeaderboardScreen(main:Main)
      {
         super();
         this.main = main;
         this.leaderboardType = FRIENDS;
         this.mc = new leaderboardScreenMc();
         addChild(this.mc);
         this.leaderboardCards = [];
         this.leaderboardContainer = new MovieClip();
         this.mc.scrollPane.source = this.leaderboardContainer;
         this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
         this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
      }
      
      public function loadLeaderboardData(data:ISFSArray) : void
      {
         var _loc2_:LeaderboardCard = null;
         var _loc3_:LeaderboardCard = null;
         var _loc4_:int = 0;
         var _loc5_:SFSObject = null;
         for each(_loc2_ in this.leaderboardCards)
         {
            if(this.leaderboardContainer.contains(_loc2_))
            {
               this.leaderboardContainer.removeChild(_loc2_);
            }
         }
         this.leaderboardCards = [];
         for(_loc4_ = 0; _loc4_ < data.size(); _loc4_++)
         {
            _loc5_ = SFSObject(data.getSFSObject(_loc4_));
            this.leaderboardCards.push(_loc3_ = new LeaderboardCard(_loc5_));
            _loc3_.setRank(_loc4_ + 1);
         }
         this.leaderboardCards.sort(this.leaderboardCompare);
         for(_loc4_ = 0; _loc4_ < data.size(); _loc4_++)
         {
            this.leaderboardCards[_loc4_].setRank(_loc4_ + 1);
         }
      }
      
      private function leaderboardCompare(a:LeaderboardCard, b:LeaderboardCard) : int
      {
         return b.rating - a.rating;
      }
      
      private function updateLeaderboardCards() : void
      {
         var c:LeaderboardCard = null;
         var i:int = 0;
         for each(c in this.leaderboardCards)
         {
            if(!this.leaderboardContainer.contains(c))
            {
               this.leaderboardContainer.addChild(c);
            }
            c.y = i * (c.height + 5);
            c.x = 0;
            i++;
         }
      }
      
      private function getLeaderboardData(type:int) : void
      {
         var params:SFSObject = new SFSObject();
         params.putInt("type",type);
         var r:ExtensionRequest = new ExtensionRequest("leaderboard",params);
         this.main.sfs.send(r);
      }
      
      public function update(evt:Event) : void
      {
         this.updateLeaderboardCards();
         this.mc.topButton.gotoAndStop(1);
         this.mc.friendsButton.gotoAndStop(1);
         if(this.mc.topButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.topButton.gotoAndStop(2);
            if(this.isMouseDown)
            {
               this.leaderboardType = TOP_100;
               this.getLeaderboardData(TOP_100);
            }
         }
         else if(this.mc.friendsButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.friendsButton.gotoAndStop(2);
            if(this.isMouseDown)
            {
               this.getLeaderboardData(FRIENDS);
               this.leaderboardType = FRIENDS;
            }
         }
         if(this.leaderboardType == TOP_100)
         {
            this.mc.topButton.gotoAndStop(3);
         }
         else if(this.leaderboardType == FRIENDS)
         {
            this.mc.friendsButton.gotoAndStop(3);
         }
         this.mc.scrollPane.update();
         this.isMouseDown = false;
      }
      
      private function mouseDown(evt:MouseEvent) : void
      {
         this.isMouseDown = true;
      }
      
      override public function enter() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.update);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.getLeaderboardData(this.leaderboardType);
      }
      
      override public function leave() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.update);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
      }
   }
}
