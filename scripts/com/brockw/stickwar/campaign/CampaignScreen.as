package com.brockw.stickwar.campaign
{
   import com.brockw.game.KeyboardState;
   import com.brockw.game.Screen;
   import com.brockw.stickwar.BaseMain;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class CampaignScreen extends Screen
   {
       
      
      private var main:BaseMain;
      
      private var txtDisplayLevel:GenericText;
      
      private var btnNextLevel:GenericButton;
      
      private var btnMainMenu:GenericButton;
      
      private var mc:campaignMap;
      
      private var keyboard:KeyboardState;
      
      internal var isB:Boolean;
      
      internal var isR:Boolean;
      
      internal var isU:Boolean;
      
      internal var isH:Boolean;
      
      internal var counter:Number = 0;
      
      internal var devReset:Number = 20;
      
      private var techTreeLoaded:Boolean;
      
      public function CampaignScreen(main:BaseMain)
      {
         super();
         this.main = main;
         this.mc = new campaignMap();
         addChild(this.mc);
         this.mc.x = -657.7;
         this.mc.y = -584.9;
      }
      
      override public function maySwitchOnDisconnect() : Boolean
      {
         return false;
      }
      
      override public function enter() : void
      {
         this.main.soundManager.playSoundInBackground("loginMusic");
         this.keyboard = new KeyboardState(this.main.stage);
         if(this.main.campaign.currentLevel != 0)
         {
            this.mc.gotoAndStop("level" + this.main.campaign.currentLevel);
         }
         else
         {
            this.mc.gotoAndStop(1);
            this.mc.map.stop();
         }
         addEventListener(Event.ENTER_FRAME,this.update);
         addEventListener(MouseEvent.CLICK,this.click);
         this.mc.bottomPanel.campaignButtons.autoSaveEnabled.addEventListener(MouseEvent.CLICK,this.disableSave);
         this.mc.bottomPanel.campaignButtons.autoSaveDisabled.addEventListener(MouseEvent.CLICK,this.enableSave);
         this.mc.bottomPanel.campaignButtons.playOnline.addEventListener(MouseEvent.CLICK,this.playOnlineClick);
         this.mc.bottomPanel.campaignButtons.strategyGuide.addEventListener(MouseEvent.CLICK,this.strategyGuideClick);
         this.mc.bottomPanel.campaignButtons.MainMenu.addEventListener(MouseEvent.CLICK,this.MainMenuClick);
         this.mc.saveGamePrompt.visible = false;
         this.mc.saveGamePrompt.okButton.addEventListener(MouseEvent.CLICK,this.okButton);
         this.mc.text.mouseEnabled = false;
         this.mc.title.mouseEnabled = false;
         if(this.main.campaign.currentLevel == 0)
         {
            this.main.showScreen("campaignGameScreen",false,true);
         }
      }
      
      private function strategyGuideClick(e:Event) : void
      {
         var s:SFSObject = null;
         if(!this.main.campaign.techTreeFix || this.techTreeLoaded)
         {
            this.main.showScreen("campaignUpgradeScreen",false,true);
            this.main.soundManager.playSoundFullVolume("clickButton");
         }
         else
         {
            this.main.soundManager.playSoundFullVolume("clickButton");
            this.main.pauseForTechTree = true;
            this.main.showScreen("campaignGameScreen",true);
            this.techTreeLoaded = true;
            this.main.showScreen("campaignUpgradeScreen",false,true);
         }
      }
      
      private function playOnlineClick(e:Event) : void
      {
         var url:URLRequest = new URLRequest("https://www.paypal.com/paypalme/aseplayer");
         navigateToURL(url,"_blank");
         if(this.main.tracker)
         {
            this.main.tracker.trackEvent("link","https://www.paypal.com/paypalme/aseplayer");
         }
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function MainMenuClick(e:Event) : void
      {
         this.main.soundManager.playSoundFullVolume("clickButton");
         this.main.showScreen("mainMenu",true);
         this.main.showScreen("mainMenu",false,true);
      }
      
      private function okButton(even:Event) : void
      {
         this.mc.saveGamePrompt.visible = false;
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function enableSave(evt:Event) : void
      {
         this.main.campaign.isAutoSaveEnabled = true;
         this.saveGame();
         trace("Enable Save");
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function disableSave(evt:Event) : void
      {
         this.main.campaign.isAutoSaveEnabled = false;
         trace("Disable Save");
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function saveGame() : void
      {
         this.main.campaign.save();
         if(this.main.tracker != null)
         {
            this.main.tracker.trackEvent(this.main.campaign.getLevelDescription(),"save");
         }
         this.mc.saveGamePrompt.visible = true;
         this.mc.saveGamePrompt.messageText.text = "Game saved at " + this.main.campaign.getCurrentLevel().title;
      }
      
      private function click(evt:MouseEvent) : void
      {
         if(evt.target == this.mc.map.playbuttonflag && this.mc.currentFrameLabel == "level" + (this.main.campaign.currentLevel + 1))
         {
            this.main.soundManager.playSoundFullVolume("clickButton");
            this.clickPlay(null);
         }
      }
      
      public function update(evt:Event) : void
      {
         if(this.isB || this.isR || this.isU || this.isH)
         {
            this.counter++;
         }
         if(this.counter > this.devReset)
         {
            this.counter = 0;
            this.isB = this.isR = this.isU = this.isH = false;
            this.keyboard.isCtrl = false;
         }
         if(this.keyboard.isPressed(66) && this.counter <= this.devReset)
         {
            this.isB = true;
            this.counter = 0;
         }
         if(this.keyboard.isPressed(82) && this.isB && this.counter <= this.devReset)
         {
            this.isR = true;
            this.counter = 0;
         }
         if(this.keyboard.isPressed(85) && this.isB && this.isR && this.counter <= this.devReset)
         {
            this.isU = true;
            this.counter = 0;
         }
         if(this.keyboard.isPressed(72) && this.isB && this.isR && this.isU && this.counter <= this.devReset)
         {
            this.isH = true;
            this.counter = 0;
         }
         if(this.keyboard.isCtrl && this.isB && this.isR && this.isU && this.isH && this.counter <= this.devReset)
         {
            this.isB = this.isR = this.isU = this.isH = false;
            this.keyboard.isCtrl = false;
            if(!this.main.isCampaignDebug)
            {
               this.main.isCampaignDebug = true;
               this.main.soundManager.playSoundFullVolume("TowerCapture");
               trace("skip level activated");
            }
            else
            {
               this.main.isCampaignDebug = false;
               this.main.soundManager.playSoundFullVolume("GarrisonExit");
               trace("skip level deactivated");
            }
         }
         if(!this.main.isKongregate && this.main.isCampaignDebug && this.keyboard.isDown(78) && this.keyboard.isShift || !this.main.isKongregate && this.keyboard.isDown(76) && this.keyboard.isShift)
         {
            if(this.main.campaign.currentLevel % 2)
            {
               ++this.main.campaign.campaignPoints;
            }
            ++this.main.campaign.campaignPoints;
            ++this.main.campaign.currentLevel;
            if(this.main.campaign.isGameFinished())
            {
               this.main.showScreen("summary",false,true);
            }
            else
            {
               this.leave();
               this.enter();
            }
         }
         this.mc.stop();
         if(this.mc.currentFrameLabel != "level" + (this.main.campaign.currentLevel + 1))
         {
            this.mc.nextFrame();
            if(this.mc.currentFrameLabel == "level" + (this.main.campaign.currentLevel + 1))
            {
               this.main.soundManager.playSoundFullVolume("SelectRaceSound");
               if(this.main.campaign.isAutoSaveEnabled == true)
               {
                  this.saveGame();
               }
            }
            this.mc.map.playbuttonflag.turning.visible = false;
            if(this.main.campaign.getCurrentLevel() != null)
            {
               this.mc.text.text = this.main.campaign.getCurrentLevel().storyName;
               this.mc.title.text = this.main.campaign.getCurrentLevel().title;
            }
         }
         else
         {
            this.mc.map.playbuttonflag.turning.visible = true;
            this.mc.text.text = this.main.campaign.getCurrentLevel().storyName;
            this.mc.title.text = this.main.campaign.getCurrentLevel().title;
            this.mc.bottomPanel.y += (1192.15 - this.mc.bottomPanel.y) * 1;
         }
         MovieClip(this.mc.map.playbuttonflag.turning).mouseEnabled = false;
         MovieClip(this.mc.map.playbuttonflag.turning).mouseChildren = false;
         MovieClip(this.mc.map.playbuttonflag).buttonMode = true;
         this.mc.map.gotoAndStop(this.mc.currentFrame);
         if(this.main.campaign.isAutoSaveEnabled)
         {
            this.mc.bottomPanel.campaignButtons.autoSaveDisabled.visible = false;
            this.mc.bottomPanel.campaignButtons.autoSaveEnabled.visible = true;
         }
         else
         {
            this.mc.bottomPanel.campaignButtons.autoSaveDisabled.visible = true;
            this.mc.bottomPanel.campaignButtons.autoSaveEnabled.visible = false;
         }
      }
      
      override public function leave() : void
      {
         this.keyboard.cleanUp();
         removeEventListener(Event.ENTER_FRAME,this.update);
         removeEventListener(MouseEvent.CLICK,this.click);
         this.mc.bottomPanel.campaignButtons.autoSaveEnabled.removeEventListener(MouseEvent.CLICK,this.disableSave);
         this.mc.bottomPanel.campaignButtons.autoSaveDisabled.removeEventListener(MouseEvent.CLICK,this.enableSave);
         this.mc.saveGamePrompt.okButton.removeEventListener(MouseEvent.CLICK,this.okButton);
      }
      
      private function clickMainMenu(evt:MouseEvent) : void
      {
         this.main.showScreen("login");
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function clickPlay(evt:MouseEvent) : void
      {
         this.main.campaign.techTreeFix = false;
         this.main.pauseForTechTree = false;
         this.main.showScreen("campaignGameScreen",false,true);
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
   }
}
