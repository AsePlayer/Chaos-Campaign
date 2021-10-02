package com.brockw.stickwar
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.text.StyleSheet;
   import flash.utils.getDefinitionByName;
   
   public class CampaignPreloader extends MovieClip
   {
       
      
      var loadingMc:loadingCampaignScreenMc;
      
      var isLocked:Boolean;
      
      var version:int;
      
      var minorVersion:int;
      
      public var mainClassName:String = "com.brockw.stickwar.stickwar2";
      
      private var _firstEnterFrame:Boolean;
      
      private var _preloaderBackground:Shape;
      
      private var _preloaderPercent:Shape;
      
      public function CampaignPreloader()
      {
         super();
         this.loadingMc = new loadingCampaignScreenMc();
         addChild(this.loadingMc);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         stop();
         this.loadingMc.maskLoader.scaleX = 0;
         var url:String = stage.loaderInfo.url;
         var goodPattern:RegExp = /^(http:\/\/)(www\.)?farm.stickpage\.com/;
         this.isLocked = false;
         if(goodPattern.test(url) == true)
         {
            trace("This flash is hosted on stickempires");
         }
         else
         {
            this.isLocked = true;
            trace("This flash is not hosted on stickempires");
         }
         this.isLocked = false;
         var _fullInfo:String = Capabilities.version;
         var _osSplitArr:Array = _fullInfo.split(" ");
         var _versionSplitArr:Array = _osSplitArr[1].split(",");
         var _versionInfo:Number = _versionSplitArr[0];
         var _minerVersion:Number = _versionSplitArr[1];
         this.version = _versionInfo;
         this.minorVersion = _minerVersion;
         trace(this.version,this.minorVersion);
         if(this.version < 11 || this.version == 11 && this.minorVersion < 2)
         {
            this.isLocked = true;
         }
      }
      
      public function start() : void
      {
         this._firstEnterFrame = true;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         stage.scaleMode = StageScaleMode.SHOW_ALL;
         stage.align = StageAlign.TOP_LEFT;
         this.start();
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var percent:Number = NaN;
         if(this._firstEnterFrame)
         {
            this._firstEnterFrame = false;
            if(root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
            {
               this.dispose();
               this.run();
            }
            else
            {
               this.beginLoading();
            }
            return;
         }
         if(root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
         {
            this.dispose();
            this.run();
         }
         else
         {
            percent = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
            this.updateLoading(percent);
         }
      }
      
      private function updateLoading(a_percent:Number) : void
      {
         this.loadingMc.maskLoader.scaleX += (a_percent - this.loadingMc.maskLoader.scaleX) * 0.2;
      }
      
      private function beginLoading() : void
      {
         trace("begin Loading");
      }
      
      private function dispose() : void
      {
         trace("dispose preloader");
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(this._preloaderBackground)
         {
            removeChild(this._preloaderBackground);
         }
         if(this._preloaderPercent)
         {
            removeChild(this._preloaderPercent);
         }
         if(this.loadingMc)
         {
            removeChild(this.loadingMc);
         }
         this._preloaderBackground = null;
         this._preloaderPercent = null;
      }
      
      private function run() : void
      {
         var MainClass:Class = null;
         var main:DisplayObject = null;
         var locked:lockedMc = null;
         var u:String = null;
         var style:StyleSheet = null;
         var styleObj:Object = null;
         var url:URLRequest = null;
         if(!this.isLocked)
         {
            nextFrame();
            MainClass = getDefinitionByName(this.mainClassName) as Class;
            if(MainClass == null)
            {
               throw new Error("AbstractPreloader:initialize. There was no class matching that name. Did you remember to override mainClassName?");
            }
            main = new MainClass() as DisplayObject;
            if(main == null)
            {
               throw new Error("AbstractPreloader:initialize. Main class needs to inherit from Sprite or MovieClip.");
            }
            addChildAt(main,0);
         }
         else
         {
            locked = new lockedMc();
            u = stage.loaderInfo.url;
            addChild(locked);
            if(this.version < 11 || this.version == 11 && this.minorVersion < 2)
            {
               style = new StyleSheet();
               styleObj = new Object();
               styleObj.color = "#0000FF";
               style.setStyle(".myText",styleObj);
               locked.text.styleSheet = style;
               locked.text.htmlText = "Flash version " + this.version + "." + this.minorVersion + " is out of date\n\nPlease update to the latest version of <a class=\'myText\' href=\'http://get.adobe.com/flashplayer/\'>Flash Player</a>\nor\nUse <a class=\'myText\' href=\'https://www.google.com/intl/en/chrome/browser/\'>Chrome browser</a>";
               locked.text.selectable = true;
            }
            else
            {
               url = new URLRequest("http://www.stickpage.com/stickwar2game.shtml");
               navigateToURL(url,"_blank");
            }
         }
      }
   }
}
