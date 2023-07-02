package com.brockw.stickwar
{
   import com.brockw.game.Screen;
   import com.brockw.game.ScreenManager;
   import com.brockw.game.XMLLoader;
   import com.brockw.stickwar.campaign.Campaign;
   import com.brockw.stickwar.engine.SoundLoader;
   import com.brockw.stickwar.engine.SoundManager;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.PostGameScreen;
   import com.brockw.stickwar.engine.multiplayer.SignUpScreen;
   import com.brockw.stickwar.engine.replay.ReplayLoaderScreen;
   import com.google.analytics.AnalyticsTracker;
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import flash.display.MovieClip;
   import flash.utils.Timer;
   
   [SWF(frameRate="30",width="850",height="700")]
   public class BaseMain extends ScreenManager
   {
       
      
      protected var _sfs:SmartFox;
      
      public var tracker:AnalyticsTracker;
      
      private var _gameServer:SmartFox;
      
      private var _campaign:Campaign;
      
      private var _lobby:Room;
      
      private var _stickWar:StickWar;
      
      private var _isMember:Boolean;
      
      private var _postGameScreen:PostGameScreen;
      
      private var connectionScreen:Screen;
      
      private var signUpScreen:SignUpScreen;
      
      private var _replayLoaderScreen:ReplayLoaderScreen;
      
      private var _mainIp:String;
      
      private var _soundLoader:SoundLoader;
      
      private var _soundManager:SoundManager;
      
      private var connectRetryTimer:Timer;
      
      public var seed:int;
      
      public var xml:XMLLoader;
      
      private var _loadingFraction:Number;
      
      private var _loadingBar:MovieClip;
      
      public var isCampaignDebug:Boolean;
      
      public var kongregate;
      
      public var isKongregate:Boolean;
      
      public var pauseForTechTree:Boolean;
      
      public function BaseMain()
      {
         super();
         this._loadingBar = null;
         this.isCampaignDebug = false;
         trace("BASE MAIN STUFF");
         this.soundManager = new SoundManager(this);
         this.soundLoader = new SoundLoader(this.soundManager);
         this.isKongregate = false;
         this._isMember = false;
      }
      
      public function kongregateReportStatistic(name:String, value:int) : *
      {
         if(this.kongregate != null && this.xml.xml.isKongregate)
         {
            this.kongregate.stats.submit(name,value);
         }
      }
      
      public function get sfs() : SmartFox
      {
         return this._sfs;
      }
      
      public function set sfs(value:SmartFox) : void
      {
         this._sfs = value;
      }
      
      public function get mainIp() : String
      {
         return this._mainIp;
      }
      
      public function set mainIp(value:String) : void
      {
         this._mainIp = value;
      }
      
      public function willSeeAdds() : Boolean
      {
         return !this.isA() && !this.isMember;
      }
      
      public function isA() : Boolean
      {
         var id:int = 0;
         if(this.sfs && this.sfs.mySelf != null)
         {
            id = int(this.sfs.mySelf.getVariable("dbid").getIntValue());
            return id % 2 == 0;
         }
         return true;
      }
      
      public function get campaign() : Campaign
      {
         return this._campaign;
      }
      
      public function get postGameScreen() : PostGameScreen
      {
         return this._postGameScreen;
      }
      
      public function set postGameScreen(value:PostGameScreen) : void
      {
         this._postGameScreen = value;
      }
      
      public function set campaign(value:Campaign) : void
      {
         this._campaign = value;
      }
      
      public function get stickWar() : StickWar
      {
         return this._stickWar;
      }
      
      public function set stickWar(value:StickWar) : void
      {
         this._stickWar = value;
      }
      
      public function get gameServer() : SmartFox
      {
         return this._gameServer;
      }
      
      public function set gameServer(value:SmartFox) : void
      {
         this._gameServer = value;
      }
      
      public function get soundLoader() : SoundLoader
      {
         return this._soundLoader;
      }
      
      public function set soundLoader(value:SoundLoader) : void
      {
         this._soundLoader = value;
      }
      
      public function get soundManager() : SoundManager
      {
         return this._soundManager;
      }
      
      public function set soundManager(value:SoundManager) : void
      {
         this._soundManager = value;
      }
      
      public function get loadingFraction() : Number
      {
         return this._loadingFraction;
      }
      
      public function set loadingFraction(value:Number) : void
      {
         this._loadingFraction = value;
      }
      
      public function get loadingBar() : MovieClip
      {
         return this._loadingBar;
      }
      
      public function set loadingBar(value:MovieClip) : void
      {
         this._loadingBar = value;
      }
      
      public function get replayLoaderScreen() : ReplayLoaderScreen
      {
         return this._replayLoaderScreen;
      }
      
      public function set replayLoaderScreen(value:ReplayLoaderScreen) : void
      {
         this._replayLoaderScreen = value;
      }
      
      public function get isMember() : Boolean
      {
         return this._isMember;
      }
      
      public function set isMember(value:Boolean) : void
      {
         this._isMember = value;
      }
   }
}
