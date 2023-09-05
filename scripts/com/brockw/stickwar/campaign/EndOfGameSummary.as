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
               var i:int = 0;
               var l:Level = null;
               var retryText:String = null;
               var newTitle:String = null;
               var j:int = 0;
               this.hasShared = false;
               this.summaryMc.endOfGameText.text = "";
               var total:int = 0;
               var best:int = 0;
               this.summaryMc.endOfGameText.text += "You have finished Stick War II: Chaos Empire Campaign on ";
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
               var maxLength:int = 0;
               var maxRetryLength:int = 0;
               i = 0;
               while(i < this.main.campaign.levels.length)
               {
                    l = this.main.campaign.levels[i];
                    retryText = "";
                    if(l.retries > 1)
                    {
                         retryText = " " + (l.retries - 1) + " retries";
                    }
                    if(retryText.length > maxRetryLength)
                    {
                         maxRetryLength = retryText.length;
                    }
                    if(l.title.length > maxLength)
                    {
                         maxLength = l.title.length;
                    }
                    i++;
               }
               i = 0;
               while(i < this.main.campaign.levels.length)
               {
                    l = this.main.campaign.levels[i];
                    if(l.bestTime < 0)
                    {
                         l.bestTime = 0;
                    }
                    newTitle = l.title;
                    retryText = "";
                    if(l.retries > 1)
                    {
                         retryText = " " + (l.retries - 1) + " retries";
                    }
                    else
                    {
                         j = 0;
                         while(j < maxRetryLength)
                         {
                              j++;
                         }
                    }
                    j = l.title.length;
                    while(j < maxLength)
                    {
                         newTitle += " ";
                         j++;
                    }
                    this.summaryMc.endOfGameText.text += "\n" + (newTitle + " " + PostGameScreen.getTimeFormat(l.bestTime));
                    this.summaryMc.endOfGameText.text += retryText;
                    total += l.totalTime;
                    best += l.bestTime;
                    i++;
               }
               if(this.main.campaign.difficultyLevel == Campaign.D_NORMAL)
               {
                    this.main.kongregateReportStatistic("timeToCompleteGameOnNormal",best);
               }
               else if(this.main.campaign.difficultyLevel == Campaign.D_HARD)
               {
                    this.main.kongregateReportStatistic("timeToCompleteGameOnHard",best);
               }
               else if(this.main.campaign.difficultyLevel == Campaign.D_INSANE)
               {
                    this.main.kongregateReportStatistic("timeToCompleteGameOnInsane",best);
               }
               this.summaryMc.endOfGameText.text += "\n\n" + "Total time (including retries): " + PostGameScreen.getTimeFormat(total);
               this.summaryMc.endOfGameText.text += "\n" + "Best time: " + PostGameScreen.getTimeFormat(best);
               addEventListener(Event.ENTER_FRAME,this.update);
               this.summaryMc.buttonFade.mouseEnabled = false;
               this.summaryMc.share.addEventListener(MouseEvent.CLICK,this.share);
               this.summaryMc.playOnline.addEventListener(MouseEvent.CLICK,this.playOnline);
               this.summaryMc.mainMenu.addEventListener(MouseEvent.CLICK,this.mainMenu);
               this.summaryMc.endOfGameText.mouseWheelEnabled = false;
               if(this.main.tracker != null)
               {
                    this.main.tracker.trackEvent("hostname","totalPlayTime",stage.loaderInfo.url,total);
                    this.main.tracker.trackEvent("hostname","bestPlayTime",stage.loaderInfo.url,best);
               }
               this.summaryMc.credits.creditsScroll.text = this.main.xml.xml.credits;
          }
          
          private function playOnline(e:Event) : void
          {
               var url:URLRequest = new URLRequest("https://www.paypal.com/donate/?hosted_button_id=EAQQPFT8SDLD6");
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
               System.setClipboard("```\n" + this.summaryMc.endOfGameText.text + "\n```");
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
