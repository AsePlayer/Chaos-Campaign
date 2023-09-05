package com.brockw.stickwar.campaign
{
     import com.brockw.game.KeyboardState;
     import com.brockw.game.MouseState;
     import com.brockw.game.Screen;
     import com.brockw.game.XMLLoader;
     import com.brockw.stickwar.BaseMain;
     import flash.display.MovieClip;
     import flash.events.Event;
     import flash.events.MouseEvent;
     import flash.net.URLLoader;
     import flash.net.URLLoaderDataFormat;
     import flash.net.URLRequest;
     import flash.net.navigateToURL;
     import flash.system.Security;
     import flash.utils.Dictionary;
     import flash.utils.getTimer;
     
     public class CampaignMenuScreen extends Screen
     {
          
          private static const S_FADE_IN:int = 0;
          
          private static const S_MAIN_MENU:int = 1;
          
          private static const S_NEW_OR_CONTINUE:int = 2;
          
          private static const S_DIFFICULTY_SELECT:int = 3;
          
          private static const S_INTRO:int = 4;
          
          private static const BOTTOM_GAP:int = 20;
          
          private static const SCREEN_HEIGHT:int = 700;
          
          private static const SCREEN_WIDTH:int = 850;
           
          
          private var isFirst:Boolean;
          
          private var mc:campaignMenuMc;
          
          private var state:int;
          
          private var panels:Array;
          
          private var currentPanel:MovieClip;
          
          private var buttons:Array;
          
          private var buttonsHit:Dictionary;
          
          private var main:BaseMain;
          
          private var youtubeLoader:com.brockw.stickwar.campaign.YoutubeLoader;
          
          private var keyboard:KeyboardState;
          
          private var mouseState:MouseState;
          
          private var version:String;
          
          private var timeSinceTriedToStartYoutube:Number;
          
          private var hasInitStickpageLink:Boolean;
          
          public function CampaignMenuScreen(main:BaseMain)
          {
               var p:MovieClip = null;
               var urlRequest:URLRequest = null;
               var urlLoader:URLLoader = null;
               super();
               var xmlLoader:XMLLoader = new XMLLoader();
               this.version = xmlLoader.xml.campaignVersion;
               this.main = main;
               this.isFirst = true;
               this.mc = new campaignMenuMc();
               this.state = S_FADE_IN;
               this.panels = [this.mc.newOrContinuePanel,this.mc.mainPanel,this.mc.difficultyPanel,this.mc.introPanel];
               for each(p in this.panels)
               {
                    p.pHeight = p.height;
               }
               this.currentPanel = null;
               addChild(this.mc);
               this.buttons = [];
               this.buttonsHit = new Dictionary();
               Security.allowDomain("stickempires.com");
               urlRequest = new URLRequest("http://www.stickempires.com/getIntroLink");
               urlLoader = new URLLoader();
               urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
               urlLoader.addEventListener(Event.COMPLETE,this.handleComplete);
               urlLoader.load(urlRequest);
               this.youtubeLoader = new com.brockw.stickwar.campaign.YoutubeLoader("w6q9EoFmu0w");
               addChild(this.youtubeLoader);
               this.hasInitStickpageLink = false;
               this.mc.introBrokenMc.visible = false;
          }
          
          public function handleComplete(e:Event) : void
          {
               var link:String = String(e.target.data);
               if(link != "")
               {
                    removeChild(this.youtubeLoader);
                    this.youtubeLoader = new com.brockw.stickwar.campaign.YoutubeLoader(link);
                    addChild(this.youtubeLoader);
               }
          }
          
          private function addNewButton(mc:MovieClip, timeDelay:Number, func:Function) : void
          {
               this.buttons.push([mc,timeDelay,func]);
          }
          
          private function switchToFadeIn() : void
          {
               this.mc.gotoAndStop("fadeIn");
               this.state = S_FADE_IN;
          }
          
          private function switchToMainMenu() : void
          {
               this.mc.gotoAndStop("mainMenu");
               this.state = S_MAIN_MENU;
          }
          
          private function switchToNewOrContinue() : void
          {
               this.mc.gotoAndStop("mainMenu");
               this.state = S_NEW_OR_CONTINUE;
          }
          
          private function switchToDifficultySelect() : void
          {
               this.mc.gotoAndStop("mainMenu");
               this.state = S_DIFFICULTY_SELECT;
          }
          
          private function switchToIntro() : void
          {
               this.mc.gotoAndStop("mainMenu");
               this.state = S_INTRO;
               this.main.soundManager.playSoundInBackground("");
               this.timeSinceTriedToStartYoutube = getTimer();
          }
          
          private function stickpageLink(e:Event) : void
          {
               var url:URLRequest = new URLRequest("http://www.stickpage.com");
               navigateToURL(url,"_blank");
               if(this.main.tracker != null)
               {
                    this.main.tracker.trackEvent("link","http://www.stickpage.com");
               }
          }
          
          private function update(evt:Event) : void
          {
               var panel:MovieClip = null;
               var buttonArray:Array = null;
               var mc:MovieClip = null;
               var delay:Number = NaN;
               var func:Function = null;
               if(stage == null)
               {
                    return;
               }
               this.mc.introBrokenMc.visible = false;
               if(Boolean(this.mc.stickpageLink))
               {
                    MovieClip(this.mc.stickpageLink).buttonMode = true;
                    this.hasInitStickpageLink = true;
                    MovieClip(this.mc.stickpageLink).addEventListener(MouseEvent.CLICK,this.stickpageLink,false,0,true);
               }
               if(this.main.soundManager.isMusic)
               {
                    this.mc.musicToggle.gotoAndStop(1);
               }
               else
               {
                    this.mc.musicToggle.gotoAndStop(2);
               }
               this.mouseState.update();
               this.mc.backButton.visible = true;
               this.mc.creditsButton.visible = false;
               if(this.state == S_INTRO)
               {
                    if(getTimer() - this.timeSinceTriedToStartYoutube > 3 * 1000 && !this.youtubeLoader.isWorking())
                    {
                         this.youtubeLoader.visible = false;
                         this.youtubeLoader.stopVideo();
                         this.mc.introBrokenMc.visible = true;
                         this.mc.introBrokenMc.buttonMode = true;
                    }
                    else
                    {
                         this.mc.introBrokenMc.buttonMode = false;
                         if(Boolean(this.youtubeLoader))
                         {
                              this.youtubeLoader.visible = true;
                              this.youtubeLoader.playVideo();
                              this.youtubeLoader.x = SCREEN_WIDTH / 2 - 640 / 2;
                              this.youtubeLoader.y = SCREEN_HEIGHT / 2 - 360 / 2;
                         }
                         this.mc.introOverlay.visible = true;
                         if(this.youtubeLoader.getTimePlayed() > 105)
                         {
                              this.youtubeLoader.pauseVideo();
                              this.skipButton();
                         }
                         this.mc.backButton.visible = false;
                         this.mc.creditsButton.visible = false;
                    }
               }
               else if(Boolean(this.youtubeLoader))
               {
                    this.youtubeLoader.visible = false;
                    this.youtubeLoader.stopVideo();
                    this.mc.introOverlay.visible = false;
               }
               if(Boolean(this.mc.difficultySelectOverlay))
               {
                    if(this.state == S_DIFFICULTY_SELECT)
                    {
                         this.mc.difficultySelectOverlay.alpha += (1 - this.mc.difficultySelectOverlay.alpha) * 0.2;
                         this.mc.difficultySelectOverlay.normal.visible = false;
                         this.mc.difficultySelectOverlay.hard.visible = false;
                         this.mc.difficultySelectOverlay.insane.visible = false;
                    }
                    else
                    {
                         this.mc.difficultySelectOverlay.alpha = 0;
                    }
               }
               if(this.state == S_FADE_IN)
               {
                    this.mc.backButton.visible = false;
                    this.mc.creditsButton.visible = false;
                    if(this.mc.fade != null)
                    {
                         if(this.mc.fade.currentFrame == MovieClip(this.mc.fade).totalFrames)
                         {
                              this.switchToMainMenu();
                         }
                    }
               }
               else
               {
                    if(this.state == S_MAIN_MENU)
                    {
                         this.currentPanel = this.mc.mainPanel;
                         this.mc.backButton.visible = false;
                         this.mc.creditsButton.visible = true;
                    }
                    else if(this.state == S_NEW_OR_CONTINUE)
                    {
                         this.currentPanel = this.mc.newOrContinuePanel;
                         if(this.main.campaign.saveGameExists())
                         {
                              this.mc.newOrContinuePanel.continueButton.visible = true;
                              this.mc.newOrContinuePanel.continueButton.x = 386;
                              this.mc.newOrContinuePanel.newGameButton.x = 106;
                         }
                         else
                         {
                              this.mc.newOrContinuePanel.continueButton.visible = false;
                              this.mc.newOrContinuePanel.newGameButton.x = 245;
                         }
                    }
                    else if(this.state == S_DIFFICULTY_SELECT)
                    {
                         this.currentPanel = this.mc.difficultyPanel;
                    }
                    else if(this.state == S_INTRO)
                    {
                         this.currentPanel = this.mc.introPanel;
                    }
                    for each(panel in this.panels)
                    {
                         if(this.currentPanel == panel)
                         {
                              panel.y += (SCREEN_HEIGHT - panel.pHeight - BOTTOM_GAP - panel.y) * 0.2;
                         }
                         else
                         {
                              panel.y += (SCREEN_HEIGHT + 50 - panel.y) * 0.2;
                         }
                    }
                    for each(buttonArray in this.buttons)
                    {
                         mc = buttonArray[0];
                         delay = Number(buttonArray[1]);
                         func = buttonArray[2];
                         if(mc in this.buttonsHit)
                         {
                              --this.buttonsHit[mc];
                              if(this.buttonsHit[mc] <= 0)
                              {
                                   func();
                                   delete this.buttonsHit[mc];
                                   break;
                              }
                              mc.gotoAndStop(3);
                         }
                         else
                         {
                              mc.gotoAndStop(1);
                              if(mc.hitTestPoint(stage.mouseX,stage.mouseY))
                              {
                                   mc.gotoAndStop(2);
                                   if(this.mouseState.mouseJustDown())
                                   {
                                        this.mouseState.mouseDown = false;
                                        mc.gotoAndStop(3);
                                        this.main.soundManager.playSoundFullVolume("clickButton");
                                        if(!(mc in this.buttonsHit))
                                        {
                                             this.buttonsHit[mc] = delay;
                                        }
                                   }
                                   if(Boolean(this.mc.difficultySelectOverlay))
                                   {
                                        if(this.state == S_DIFFICULTY_SELECT)
                                        {
                                             if(mc == this.mc.difficultyPanel.normalButton || this.mc.difficultyPanel.normalButton in this.buttonsHit)
                                             {
                                                  this.mc.difficultySelectOverlay.normal.visible = true;
                                             }
                                             else if(mc == this.mc.difficultyPanel.hardButton || this.mc.difficultyPanel.hardButton in this.buttonsHit)
                                             {
                                                  this.mc.difficultySelectOverlay.hard.visible = true;
                                             }
                                             else if(mc == this.mc.difficultyPanel.insaneButton || this.mc.difficultyPanel.insaneButton in this.buttonsHit)
                                             {
                                                  this.mc.difficultySelectOverlay.insane.visible = true;
                                             }
                                        }
                                   }
                              }
                         }
                    }
               }
               if(this.mc.creditsScreen.visible == true)
               {
                    this.mc.creditsButton.visible = false;
                    this.mc.backButton.visible = true;
               }
          }
          
          private function toggleMusic(evt:Event) : void
          {
               this.main.soundManager.isMusic = !this.main.soundManager.isMusic;
               this.main.soundManager.isSound = !this.main.soundManager.isSound;
          }
          
          override public function enter() : void
          {
               if(Boolean(this.main.stage))
               {
                    this.keyboard = new KeyboardState(this.main.stage);
                    this.mouseState = new MouseState(this.main.stage);
                    stage.frameRate = 30;
               }
               this.timeSinceTriedToStartYoutube = getTimer();
               this.hasInitStickpageLink = false;
               this.main.campaign = new Campaign(0,0);
               this.mc.version.text = this.version;
               this.mc.musicToggle.addEventListener(MouseEvent.CLICK,this.toggleMusic);
               this.mc.musicToggle.buttonMode = true;
               if(this.isFirst)
               {
                    this.switchToFadeIn();
               }
               else
               {
                    this.switchToMainMenu();
               }
               this.isFirst = false;
               addEventListener(Event.ENTER_FRAME,this.update);
               this.addNewButton(this.mc.mainPanel.campaignButton,15,this.campaignButton);
               this.addNewButton(this.mc.newOrContinuePanel.newGameButton,15,this.newGameButton);
               this.addNewButton(this.mc.newOrContinuePanel.continueButton,15,this.continueButton);
               this.addNewButton(this.mc.difficultyPanel.normalButton,15,this.normalButton);
               this.addNewButton(this.mc.difficultyPanel.hardButton,15,this.hardButton);
               this.addNewButton(this.mc.difficultyPanel.insaneButton,15,this.insaneButton);
               this.mc.creditsButton.addEventListener(MouseEvent.CLICK,this.creditsButton);
               this.mc.backButton.addEventListener(MouseEvent.CLICK,this.backButton);
               this.addNewButton(this.mc.introPanel.skipButton,15,this.skipButton);
               this.main.soundManager.playSoundInBackground("loginMusic");
               this.mc.mainPanel.onlineButton.addEventListener(MouseEvent.CLICK,this.onlineButton);
               this.mc.mainPanel.stickWarButton.addEventListener(MouseEvent.CLICK,this.stickWarButton);
               this.mc.introBrokenMc.addEventListener(MouseEvent.CLICK,this.openIntroLink);
               this.mc.creditsScreen.visible = false;
          }
          
          private function skipButton() : void
          {
               this.main.showScreen("campaignMap",false,true);
          }
          
          private function checkCheatMode() : *
          {
               if(!this.main.isCampaignDebug)
               {
                    return;
               }
               var i:int = 48;
               while(i <= 57)
               {
                    if(this.keyboard.isDown(i))
                    {
                         if(this.keyboard.isShift)
                         {
                              this.main.campaign.currentLevel = 10 + i - 48;
                              this.main.campaign.campaignPoints = 10 + i - 48;
                         }
                         else
                         {
                              this.main.campaign.currentLevel = i - 48;
                              this.main.campaign.campaignPoints = i - 48;
                         }
                    }
                    i++;
               }
          }
          
          private function normalButton() : void
          {
               this.checkCheatMode();
               this.switchToIntro();
               this.main.campaign.setDifficulty(Campaign.D_NORMAL);
          }
          
          private function hardButton() : void
          {
               this.checkCheatMode();
               this.switchToIntro();
               this.main.campaign.setDifficulty(Campaign.D_HARD);
          }
          
          private function insaneButton() : void
          {
               this.checkCheatMode();
               this.switchToIntro();
               this.main.campaign.setDifficulty(Campaign.D_INSANE);
          }
          
          private function newGameButton() : void
          {
               this.switchToDifficultySelect();
          }
          
          private function continueButton() : void
          {
               this.main.campaign.load();
               this.main.showScreen("campaignMap");
          }
          
          private function onlineButton(e:Event) : void
          {
               var url:URLRequest = new URLRequest("https://www.paypal.com/donate/?hosted_button_id=EAQQPFT8SDLD6");
               navigateToURL(url,"_blank");
               if(this.main.tracker != null)
               {
                    this.main.tracker.trackEvent("link","https://www.paypal.com/donate/?hosted_button_id=EAQQPFT8SDLD6");
               }
          }
          
          private function stickWarButton(e:Event) : void
          {
               var url:URLRequest = new URLRequest("https://www.aseplayer.com/sw2-mods");
               navigateToURL(url,"_blank");
               if(this.main.tracker != null)
               {
                    this.main.tracker.trackEvent("link","https://drive.google.com/drive/folders/1cwJ1NcCoHzrG3Z4qERPLDTbvwPFFDXbo?usp=sharing");
               }
          }
          
          private function openIntroLink(e:Event) : void
          {
               var url:URLRequest = new URLRequest("https://youtu.be/xJOMmisl54M");
               navigateToURL(url,"_blank");
               if(this.main.tracker != null)
               {
                    this.main.tracker.trackEvent("link","http://www.stickpage.com/stickwar2orderempireintro.shtml");
               }
          }
          
          override public function leave() : void
          {
               this.mc.musicToggle.removeEventListener(MouseEvent.CLICK,this.toggleMusic);
               removeEventListener(Event.ENTER_FRAME,this.update);
               this.mc.backButton.removeEventListener(MouseEvent.CLICK,this.backButton);
               this.mc.creditsButton.removeEventListener(MouseEvent.CLICK,this.creditsButton);
               this.buttons = [];
               this.keyboard.cleanUp();
               this.youtubeLoader.stopVideo();
               this.mouseState.cleanUp();
               this.mc.mainPanel.onlineButton.removeEventListener(MouseEvent.CLICK,this.onlineButton);
               this.mc.mainPanel.stickWarButton.removeEventListener(MouseEvent.CLICK,this.stickWarButton);
               this.mc.introBrokenMc.removeEventListener(MouseEvent.CLICK,this.openIntroLink);
               if(this.hasInitStickpageLink)
               {
                    MovieClip(this.mc.stickpageLink).addEventListener(MouseEvent.CLICK,this.stickpageLink,false,0,true);
               }
          }
          
          private function backButton(evt:Event) : void
          {
               if(this.mc.creditsScreen.visible)
               {
                    this.mc.creditsScreen.visible = false;
                    this.mc.creditsButton.visible = true;
                    this.mc.backButton.visible = false;
               }
               else
               {
                    this.switchToMainMenu();
               }
          }
          
          private function creditsButton(evt:Event) : void
          {
               this.mc.creditsScreen.visible = true;
               this.mc.creditsScreen.credits.text = this.main.xml.xml.credits;
          }
          
          private function campaignButton() : void
          {
               this.switchToNewOrContinue();
          }
     }
}
