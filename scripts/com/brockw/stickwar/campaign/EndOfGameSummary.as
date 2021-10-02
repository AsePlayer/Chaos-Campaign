package com.brockw.stickwar.campaign
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.engine.multiplayer.PostGameScreen;
   import com.brockw.stickwar.stickwar2;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   
   public class EndOfGameSummary extends Screen
   {
       
      
      private var summaryMc:endOfGameSummaryMc;
      
      private var main:stickwar2;
      
      private var selectInCount:int;
      
      private var hasShared:Boolean;
      
      public function EndOfGameSummary(main:stickwar2)
      {
         super();
         this.main = main;
         this.summaryMc = new endOfGameSummaryMc();
         addChild(this.summaryMc);
         this.selectInCount = -1;
      }
      
      override public function enter() : void
      {
         var _loc5_:int = 0;
         var _loc6_:Level = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         this.hasShared = false;
         this.summaryMc.endOfGameText.text = "";
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.summaryMc.endOfGameText.text += "You have finished Stick War II on ";
         if(this.main.campaign.difficultyLevel == Campaign.D_NORMAL)
         {
            this.summaryMc.endOfGameText.text += "NORMAL!\n";
            this.main.kongregateReportStatistic("gameCompleteOnNormal",1);
         }
         else if(this.main.campaign.difficultyLevel == Campaign.D_HARD)
         {
            this.summaryMc.endOfGameText.text += "HARD!\n";
            this.main.kongregateReportStatistic("gameCompleteOnHard",1);
         }
         else if(this.main.campaign.difficultyLevel == Campaign.D_INSANE)
         {
            this.summaryMc.endOfGameText.text += "INSANE!\n";
            this.main.kongregateReportStatistic("gameCompleteOnInsane",1);
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for(_loc5_ = 0; _loc5_ < this.main.campaign.levels.length; _loc5_++)
         {
            _loc6_ = this.main.campaign.levels[_loc5_];
            _loc7_ = "";
            if(_loc6_.retries > 1)
            {
               _loc7_ = " " + (_loc6_.retries - 1) + " retries";
            }
            if(_loc7_.length > _loc4_)
            {
               _loc4_ = _loc7_.length;
            }
            if(_loc6_.title.length > _loc3_)
            {
               _loc3_ = _loc6_.title.length;
            }
         }
         for(_loc5_ = 0; _loc5_ < this.main.campaign.levels.length; _loc5_++)
         {
            _loc6_ = this.main.campaign.levels[_loc5_];
            if(_loc6_.bestTime < 0)
            {
               _loc6_.bestTime = 0;
            }
            _loc8_ = _loc6_.title;
            _loc7_ = "";
            if(_loc6_.retries > 1)
            {
               _loc7_ = " " + (_loc6_.retries - 1) + " retries";
            }
            else
            {
               for(_loc9_ = 0; _loc9_ < _loc4_; _loc9_++)
               {
               }
            }
            for(_loc9_ = _loc6_.title.length; _loc9_ < _loc3_; _loc9_++)
            {
               _loc8_ += " ";
            }
            this.summaryMc.endOfGameText.text += "\n" + (_loc8_ + " " + PostGameScreen.getTimeFormat(_loc6_.bestTime));
            this.summaryMc.endOfGameText.text += _loc7_;
            _loc1_ += _loc6_.totalTime;
            _loc2_ += _loc6_.bestTime;
         }
         if(this.main.campaign.difficultyLevel == Campaign.D_NORMAL)
         {
            this.main.kongregateReportStatistic("timeToCompleteGameOnNormal",_loc2_);
         }
         else if(this.main.campaign.difficultyLevel == Campaign.D_HARD)
         {
            this.main.kongregateReportStatistic("timeToCompleteGameOnHard",_loc2_);
         }
         else if(this.main.campaign.difficultyLevel == Campaign.D_INSANE)
         {
            this.main.kongregateReportStatistic("timeToCompleteGameOnInsane",_loc2_);
         }
         this.summaryMc.endOfGameText.text += "\n\n" + "Total time (including retries): " + PostGameScreen.getTimeFormat(_loc1_);
         this.summaryMc.endOfGameText.text += "\n" + "Best time: " + PostGameScreen.getTimeFormat(_loc2_);
         addEventListener(Event.ENTER_FRAME,this.update);
         this.summaryMc.buttonFade.mouseEnabled = false;
         this.summaryMc.share.addEventListener(MouseEvent.CLICK,this.share);
         this.summaryMc.playOnline.addEventListener(MouseEvent.CLICK,this.playOnline);
         this.summaryMc.mainMenu.addEventListener(MouseEvent.CLICK,this.mainMenu);
         this.summaryMc.endOfGameText.mouseWheelEnabled = false;
         if(this.main.tracker != null)
         {
            this.main.tracker.trackEvent("hostname","totalPlayTime",stage.loaderInfo.url,_loc1_);
            this.main.tracker.trackEvent("hostname","bestPlayTime",stage.loaderInfo.url,_loc2_);
         }
         this.summaryMc.credits.creditsScroll.text = this.main.xml.xml.credits;
      }
      
      private function playOnline(e:Event) : void
      {
         var url:URLRequest = new URLRequest("http://www.stickempires.com");
         navigateToURL(url,"_blank");
         if(this.main.tracker != null)
         {
            this.main.tracker.trackEvent("link","http://www.stickempires.com");
         }
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function mainMenu(e:Event) : void
      {
         this.main.showScreen("mainMenu");
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function share(e:Event) : void
      {
         this.selectInCount = 2;
         this.hasShared = true;
         System.setClipboard(this.summaryMc.endOfGameText.text);
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      override public function leave() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(e:Event) : void
      {
         this.summaryMc.credits.creditsScroll.y -= 0.5;
         if(this.summaryMc.credits.creditsScroll.y + this.summaryMc.credits.creditsScroll.height < 0)
         {
            this.summaryMc.credits.creditsScroll.y = 382;
         }
         --this.selectInCount;
         if(this.selectInCount == 0)
         {
            this.main.stage.focus = this.summaryMc.endOfGameText;
            this.summaryMc.endOfGameText.setSelection(0,this.summaryMc.endOfGameText.text.length);
         }
         if(!this.hasShared)
         {
            this.summaryMc.tip.alpha = 0;
         }
         else
         {
            this.summaryMc.tip.alpha += (1 - this.summaryMc.tip.alpha) * 0.2;
         }
      }
   }
}
