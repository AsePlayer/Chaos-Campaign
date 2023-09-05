package com.brockw.game
{
     import flash.display.Sprite;
     import flash.events.TimerEvent;
     import flash.utils.Dictionary;
     import flash.utils.Timer;
     
     public class ScreenManager extends Sprite
     {
           
          
          private var screens:Dictionary;
          
          private var currentScreenName:String;
          
          private var nextScreenName:String;
          
          private var currentOverlayScreenName:String;
          
          private var currentOverlay:com.brockw.game.Screen;
          
          private var fadeTransitionMc:Sprite;
          
          private var isFade:Boolean;
          
          internal var timer:Timer;
          
          public function ScreenManager()
          {
               super();
               this.screens = new Dictionary();
               this.currentScreenName = null;
               this.nextScreenName = null;
               this.currentOverlayScreenName = null;
               this.currentOverlay = null;
               this.fadeTransitionMc = new Sprite();
               this.fadeTransitionMc.graphics.beginFill(0,1);
               this.fadeTransitionMc.graphics.drawRect(0,0,1000,1000);
               this.fadeTransitionMc.alpha = 0;
               this.timer = new Timer(33,0);
               this.timer.addEventListener(TimerEvent.TIMER,this.update);
          }
          
          public function setOverlayScreen(name:String) : void
          {
               if(name == this.currentOverlayScreenName)
               {
                    return;
               }
               if(this.currentOverlayScreenName != null && this.contains(this.screens[this.currentOverlayScreenName]))
               {
                    Screen(this.screens[this.currentOverlayScreenName]).leave();
                    this.removeChild(this.screens[this.currentOverlayScreenName]);
                    this.currentOverlayScreenName = null;
               }
               if(name in this.screens)
               {
                    this.addChild(this.screens[name]);
                    this.currentOverlayScreenName = name;
                    Screen(this.screens[name]).enter();
               }
          }
          
          public function getOverlayScreen() : String
          {
               return this.currentOverlayScreenName;
          }
          
          public function currentScreen() : String
          {
               return this.currentScreenName;
          }
          
          public function getScreen(name:String) : com.brockw.game.Screen
          {
               if(name in this.screens)
               {
                    return this.screens[name];
               }
               return null;
          }
          
          public function addScreen(name:String, screen:com.brockw.game.Screen) : Boolean
          {
               this.screens[name] = screen;
               return true;
          }
          
          public function removeScreen(name:String) : Boolean
          {
               delete this.screens[name];
               return true;
          }
          
          public function showScreen(name:String, force:Boolean = false, isFade:Boolean = false) : Boolean
          {
               var nextScreen:com.brockw.game.Screen = null;
               if(name == this.currentScreenName && force == true)
               {
                    this.screens[this.currentScreenName].leave();
                    this.screens[this.currentScreenName].enter();
               }
               if(this.screens[name] != null && name != this.currentScreenName && name != this.nextScreenName)
               {
                    this.nextScreenName = name;
                    nextScreen = this.screens[name];
                    this.addChild(nextScreen);
                    if(this.currentOverlayScreenName != null)
                    {
                         this.removeChild(this.screens[this.currentOverlayScreenName]);
                         this.addChild(this.screens[this.currentOverlayScreenName]);
                    }
                    nextScreen.enter();
                    nextScreen.visible = false;
                    this.timer.start();
                    if(isFade == true)
                    {
                         addChild(this.fadeTransitionMc);
                         this.fadeTransitionMc.alpha = 0;
                    }
                    else if(contains(this.fadeTransitionMc))
                    {
                         removeChild(this.fadeTransitionMc);
                    }
               }
               return true;
          }
          
          private function switchToNextScreen() : Boolean
          {
               if(this.nextScreenName == this.currentScreenName)
               {
                    return false;
               }
               var nextScreen:com.brockw.game.Screen = this.screens[this.nextScreenName];
               var currentScreen:com.brockw.game.Screen = this.screens[this.currentScreenName];
               if(currentScreen != null)
               {
                    currentScreen.x = 0;
                    this.screens[this.currentScreenName].leave();
                    if(this.contains(this.screens[this.currentScreenName]))
                    {
                         this.removeChild(this.screens[this.currentScreenName]);
                    }
               }
               this.currentScreenName = this.nextScreenName;
               nextScreen.visible = true;
               this.nextScreenName = null;
               return true;
          }
          
          private function update(evt:TimerEvent) : void
          {
               var nextScreen:com.brockw.game.Screen = this.screens[this.nextScreenName];
               var currentScreen:com.brockw.game.Screen = this.screens[this.currentScreenName];
               if(this.contains(this.fadeTransitionMc))
               {
                    if(currentScreen != nextScreen && nextScreen != null)
                    {
                         this.fadeTransitionMc.alpha += 0.075;
                         if(this.fadeTransitionMc.alpha >= 1)
                         {
                              this.switchToNextScreen();
                         }
                    }
                    else
                    {
                         this.fadeTransitionMc.alpha -= 0.075;
                         if(this.fadeTransitionMc.alpha <= 0)
                         {
                              this.timer.stop();
                              if(this.contains(this.fadeTransitionMc))
                              {
                                   removeChild(this.fadeTransitionMc);
                              }
                         }
                    }
               }
               else
               {
                    this.switchToNextScreen();
                    this.timer.stop();
                    if(this.contains(this.fadeTransitionMc))
                    {
                         removeChild(this.fadeTransitionMc);
                    }
               }
               evt.updateAfterEvent();
          }
     }
}
