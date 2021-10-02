package com.brockw.stickwar
{
   import com.brockw.game.Screen;
   import com.brockw.game.XMLLoader;
   import com.brockw.stickwar.campaign.Campaign;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.campaign.CampaignScreen;
   import com.brockw.stickwar.campaign.CampaignUpgradeScreen;
   import com.brockw.stickwar.engine.multiplayer.ChatOverlayScreen;
   import com.brockw.stickwar.engine.multiplayer.ConnectionScreen;
   import com.brockw.stickwar.engine.multiplayer.FAQScreen;
   import com.brockw.stickwar.engine.multiplayer.LeaderboardScreen;
   import com.brockw.stickwar.engine.multiplayer.LoadingScreen;
   import com.brockw.stickwar.engine.multiplayer.LoginScreen;
   import com.brockw.stickwar.engine.multiplayer.MainLobbyScreen;
   import com.brockw.stickwar.engine.multiplayer.MultiplayerGameScreen;
   import com.brockw.stickwar.engine.multiplayer.PostGameScreen;
   import com.brockw.stickwar.engine.multiplayer.ProfileScreen;
   import com.brockw.stickwar.engine.multiplayer.RaceSelectionScreen;
   import com.brockw.stickwar.engine.multiplayer.VersionMismatchScreen;
   import com.brockw.stickwar.engine.replay.ReplayGameScreen;
   import com.brockw.stickwar.engine.replay.ReplayLoaderScreen;
   import com.brockw.stickwar.market.ArmoryScreen;
   import com.brockw.stickwar.market.ItemMap;
   import com.brockw.stickwar.market.Loadout;
   import com.brockw.stickwar.market.MarketItem;
   import com.brockw.stickwar.market.MarketScreen;
   import com.brockw.stickwar.singleplayer.SingleplayerGameScreen;
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   [Frame(factoryClass="com.brockw.stickwar.Preloader")]
   [SWF(frameRate="30",width="850",height="700")]
   public class Main extends BaseMain
   {
       
      
      private var _gameIp:String;
      
      private var C_MATCHMAKE:int = 0;
      
      private var C_CIRCLE_MOVE:int = 0;
      
      private var _lobby:Room;
      
      private var _gameRoom:Room;
      
      private var _gameRoomName:String;
      
      private var _hasReceivedPurchases:Boolean;
      
      private var _replayGameScreen:ReplayGameScreen;
      
      private var _marketScreen:MarketScreen;
      
      private var _armourScreen:ArmoryScreen;
      
      private var _chatOverlay:ChatOverlayScreen;
      
      private var _lobbyScreen:RaceSelectionScreen;
      
      private var connectionScreen:Screen;
      
      private var _profileScreen:ProfileScreen;
      
      private var _leaderboardScreen:LeaderboardScreen;
      
      private var _campaignUpgradeScreen:CampaignUpgradeScreen;
      
      private var _campaignGameScreen:CampaignGameScreen;
      
      private var _loginScreen:LoginScreen;
      
      private var _multiplayerGameScreen:MultiplayerGameScreen;
      
      private var _faqScreen:FAQScreen;
      
      private var _mainLobbyScreen:MainLobbyScreen;
      
      private var loadingScreen:LoadingScreen;
      
      private var _purchases:Array;
      
      private var _marketItems:Array;
      
      private var _itemMap:ItemMap;
      
      private var _loadout:Loadout;
      
      private var timer:Timer;
      
      public var _stickWarEngine;
      
      private var _mainIp:String;
      
      private var _inQueue:Boolean;
      
      private var _raceSelected:int;
      
      private var connectRetryTimer:Timer;
      
      public var passwordEncrypted:String;
      
      private var _empirePoints:int;
      
      public var version:String;
      
      public function Main()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      public function init() : void
      {
         var xmlLoader:XMLLoader = new XMLLoader();
         this.xml = xmlLoader;
         this.version = xmlLoader.xml.version;
         this._stickWarEngine = null;
         sfs = new SmartFox();
         gameServer = new SmartFox();
         this.connectionScreen = new ConnectionScreen(this);
         this._itemMap = new ItemMap();
         this._loadout = new Loadout();
         this._itemMap = new ItemMap();
         this._loadout = new Loadout();
         sfs.debug = false;
         seed = 0;
         sfs.addEventListener(SFSEvent.SOCKET_ERROR,this.connectRetry);
         sfs.addEventListener(SFSEvent.CONNECTION,this.onConnection);
         sfs.addEventListener(SFSEvent.CONNECTION_LOST,this.onConnectionLost);
         sfs.addEventListener(SFSEvent.LOGOUT,this.onConnectionLost);
         sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
         sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
         addScreen("connect",this.connectionScreen);
         addScreen("login",this.loginScreen = new LoginScreen(this));
         this.lobbyScreen = new RaceSelectionScreen(this);
         addScreen("pickRace",this.lobbyScreen);
         addScreen("lobby",this.mainLobbyScreen = new MainLobbyScreen(this));
         addScreen("loading",this.loadingScreen = new LoadingScreen(this));
         addScreen("game",this.multiplayerGameScreen = new MultiplayerGameScreen(this));
         addScreen("singleplayerGame",new SingleplayerGameScreen(this));
         this._replayGameScreen = new ReplayGameScreen(this);
         addScreen("replayGame",this._replayGameScreen);
         addScreen("replayLoader",replayLoaderScreen = new ReplayLoaderScreen(this));
         this._marketScreen = new MarketScreen(this);
         addScreen("market",this._marketScreen);
         this._armourScreen = new ArmoryScreen(this);
         addScreen("armoury",this._armourScreen);
         this._chatOverlay = new ChatOverlayScreen(this);
         addScreen("chatOverlay",this._chatOverlay);
         this._profileScreen = new ProfileScreen(this);
         addScreen("profile",this._profileScreen);
         postGameScreen = new PostGameScreen(this);
         addScreen("postGame",postGameScreen);
         addScreen("campaignMap",new CampaignScreen(this));
         addScreen("campaignGameScreen",new CampaignGameScreen(this));
         addScreen("campaignUpgradeScreen",new CampaignUpgradeScreen(this));
         addScreen("leaderboard",this._leaderboardScreen = new LeaderboardScreen(this));
         addScreen("versionMismatch",new VersionMismatchScreen());
         addScreen("faq",this._faqScreen = new FAQScreen(BaseMain(this)));
         this.inQueue = false;
         this.lobby = null;
         this.gameRoom = null;
         showScreen("login");
         sfs.useBlueBox = false;
         gameServer.useBlueBox = false;
         mainIp = xmlLoader.xml.mainServer;
         _sfs.connect(mainIp,9933);
         this.loginScreen.isConnecting = true;
         this.purchases = [];
         sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.extensionResponse);
         this.timer = new Timer(5000,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.keepAlive);
         this.timer.start();
         campaign = new Campaign(xmlLoader.xml.skipToLevel,xmlLoader.xml.campaignDifficulty);
         this.raceSelected = 0;
         this.connectRetryTimer = new Timer(500);
         this.connectRetryTimer.addEventListener(TimerEvent.TIMER,this.connectRetry);
         isMember = false;
         this.empirePoints = 0;
      }
      
      private function addedToStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         this.init();
      }
      
      private function connectRetry(evt:Event) : void
      {
         trace("try to connect");
         _sfs.connect(mainIp,9933);
      }
      
      private function keepAlive(evt:Event) : void
      {
         if(sfs.currentZone == "stickwar")
         {
            sfs.send(new ExtensionRequest("keepAlive",null));
         }
      }
      
      public function extensionResponse(evt:SFSEvent) : void
      {
         var _loc3_:SFSObject = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc2_:SFSObject = evt.params.params;
         switch(evt.params.cmd)
         {
            case "loadout":
               this.receiveLoadout(evt.params.params);
               trace("receiving loadout");
               break;
            case "empirePoints":
               this.armourScreen.receiveEmpirePoints(_loc2_.getInt("empirePoints"),_loc2_.getBool("isMember"),_loc2_.getBool("justBought"));
               trace("receiving empire points");
               break;
            case "marketItems":
               this.receiveMarketItems(evt.params.params);
               trace("receiving market items");
               break;
            case "purchases":
               this.receivePurchases(evt.params.params);
               trace("receiving purchases");
               break;
            case "buddyList":
               this._chatOverlay.buddyList.receiveBuddyList(evt.params.params);
               trace("receiving buddy list");
               break;
            case "buddyUpdate":
               this._chatOverlay.buddyList.receiveUpdate(evt.params.params);
               trace("update buddy list");
               break;
            case "buddyGameInvitation":
               _loc3_ = evt.params.params;
               _loc4_ = _loc3_.getInt("inviter");
               _loc5_ = _loc3_.getUtfString("name");
               this._chatOverlay.buddyList.startGameInvite(_loc4_,_loc5_);
               break;
            case "buddyChat":
               _loc3_ = evt.params.params;
               _loc6_ = _loc3_.getUtfString("n");
               _loc7_ = _loc3_.getInt("id");
               _loc8_ = _loc3_.getUtfString("m");
               this._chatOverlay.buddyList.receiveChat(_loc7_,_loc6_,_loc8_);
               trace("buddy chat");
               break;
            case "p":
               this.gameServer.send(new ExtensionRequest("p",_loc2_,this.gameRoom));
               break;
            case "gameCreated":
               trace("Game created on server: " + _loc2_.getUtfString("server"));
               seed = 0;
               trace("SEED",seed);
               this.gameIp = _loc2_.getUtfString("server");
               if(this.gameIp != mainIp)
               {
                  gameServer = new SmartFox();
                  gameServer.useBlueBox = false;
                  this.showScreen("loading");
                  gameServer.connect(this.gameIp,9933);
                  trace("Attempting to connect to game server",this.gameIp);
               }
               else
               {
                  gameServer = sfs;
                  trace("Playing on main server...");
               }
               this.inQueue = false;
               break;
            case "gameRoomName":
               trace("Game room is: " + _loc2_.getUtfString("name"));
               this.gameRoomName = _loc2_.getUtfString("name");
               showScreen("loading");
               break;
            case "buddyAddResponse":
               trace("Buddy add response: " + _loc2_.getUtfString("response"));
               this._chatOverlay.addUserResponse(_loc2_.getUtfString("response"));
               break;
            case "inMatchmakingQueue":
               this.inQueue = true;
               this._chatOverlay.startQueueCount();
               break;
            case "notInMatchmakingQueue":
               this.inQueue = false;
               break;
            case "leaderboard":
               trace("Received leaderboard data");
               this._leaderboardScreen.loadLeaderboardData(_loc2_.getSFSArray("data"));
               break;
            case "checkAvailability":
               trace("Received availability data");
               trace(_loc2_.getUtfString("username")," - ",_loc2_.getBool("available"));
               break;
            case "registerUser":
               trace("Register user response: ",_loc2_.getBool("success"));
               break;
            case "forgotPassword":
               trace("Forgot password response: ",_loc2_.getBool("success"));
               this.loginScreen.forgotPasswordForm.submitResponse(_loc2_.getBool("success"),_loc2_.getUtfString("message"));
               break;
            case "population":
               trace("receiving population");
               this._chatOverlay.setPopulation(_loc2_.getInt("n"));
               break;
            case "news":
               trace("receiving news");
               this.mainLobbyScreen.receiveNewsItem(_loc2_);
               break;
            case "loadEngine":
               this.loadingScreen.receivedRaceSelection(_loc2_);
               break;
            case "raceTimeout":
               trace("TIMEOUT");
               this.showScreen("lobby");
               this._chatOverlay.addUserResponse("Opponent timed out. Hit find match to try again.",true);
               break;
            case "raceSelectCountdown":
               this.loadingScreen.setCountdown(_loc2_.getLong("timeLeft"));
               break;
            case "profile":
               trace("receiving profile");
               if(this.currentScreen() == "profile")
               {
                  this._profileScreen.receiveProfile(_loc2_);
               }
               else
               {
                  this.postGameScreen.receiveProfile(_loc2_);
               }
               break;
            case "changePassword":
               this._profileScreen.receiveChangeMessage(_loc2_.getUtfString("reply"));
               break;
            case "changeEmail":
               this._profileScreen.receiveChangeMessage(_loc2_.getUtfString("reply"));
               break;
            case "buyResponse":
               this.armourScreen.buyResponse(_loc2_.getInt("response"));
               break;
            case "termsOfService":
               trace("receiving TOS");
               this._chatOverlay.showTerms(_loc2_);
               break;
            case "faq":
               trace("receiving FAQ");
               this._faqScreen.loadFAQ(_loc2_);
               break;
            case "systemNotifcation":
               trace("Received notification:",_loc2_.getUtfString("message"));
               this._chatOverlay.addUserResponse(_loc2_.getUtfString("message"),true);
         }
      }
      
      private function receiveLoadout(params:SFSObject) : void
      {
         this.loadout.fromSFSObject(params);
      }
      
      private function receiveMarketItems(params:SFSObject) : void
      {
         var i:int = 0;
         var m:MarketItem = null;
         this.marketItems = [];
         var a:ISFSArray = params.getSFSArray("marketData");
         i = 0;
         while(i < a.size())
         {
            m = new MarketItem(SFSObject(a.getSFSObject(i)));
            this.marketItems.push(m);
            i++;
         }
         this._marketScreen.updateMarketItems();
         this.itemMap.loadItems(this);
         this.armourScreen.initUnitCards();
      }
      
      private function receivePurchases(params:SFSObject) : void
      {
         var i:int = 0;
         this.hasReceivedPurchases = true;
         var a:ISFSArray = params.getSFSArray("purchases");
         i = 0;
         while(i < a.size())
         {
            this.purchases.push(a.getInt(i));
            i++;
         }
         this._marketScreen.updateMarketItems();
      }
      
      private function onConnection(evt:SFSEvent) : void
      {
         if(evt.params.success)
         {
            trace("Connection Success!");
            this.connectRetryTimer.stop();
            this.loginScreen.isConnecting = false;
         }
         else
         {
            this.connectRetryTimer.start();
            trace("Connection Failure: " + evt.params.errorMessage);
         }
      }
      
      private function onConnectionLost(evt:SFSEvent) : void
      {
         this._chatOverlay.cleanUp();
         this.loadout.data = new Dictionary();
         this.itemMap.data = new Dictionary();
         this.marketItems = [];
         this.purchases = [];
         this.inQueue = false;
         trace("Connection lost");
         trace("Currently on screen: ",currentScreen());
         if(this.getScreen(currentScreen()).maySwitchOnDisconnect())
         {
            trace("Show login");
            showScreen("login");
            this.setOverlayScreen("");
         }
         if(!sfs.isConnected)
         {
            trace("Connection was lost. Reason: " + evt.params.reason);
            trace("Try to reconnect...");
            this.connectRetryTimer.start();
            this.gameRoom = null;
            this.gameRoomName = "";
            this._gameIp = "";
            this.loginScreen.isConnecting = true;
         }
      }
      
      private function onConfigLoadSuccess(evt:SFSEvent) : void
      {
         trace("Config load success!");
         trace("Server settings: " + _sfs.config.host + ":" + _sfs.config.port);
      }
      
      private function onConfigLoadFailure(evt:SFSEvent) : void
      {
         trace("Config load failure!!!");
      }
      
      public function get lobby() : Room
      {
         return this._lobby;
      }
      
      public function set lobby(value:Room) : void
      {
         this._lobby = value;
      }
      
      public function get gameRoom() : Room
      {
         return this._gameRoom;
      }
      
      public function set gameRoom(value:Room) : void
      {
         this._gameRoom = value;
      }
      
      public function get replayGameScreen() : ReplayGameScreen
      {
         return this._replayGameScreen;
      }
      
      public function set replayGameScreen(value:ReplayGameScreen) : void
      {
         this._replayGameScreen = value;
      }
      
      public function get purchases() : Array
      {
         return this._purchases;
      }
      
      public function set purchases(value:Array) : void
      {
         this._purchases = value;
      }
      
      public function get itemMap() : ItemMap
      {
         return this._itemMap;
      }
      
      public function set itemMap(value:ItemMap) : void
      {
         this._itemMap = value;
      }
      
      public function get loadout() : Loadout
      {
         return this._loadout;
      }
      
      public function set loadout(value:Loadout) : void
      {
         this._loadout = value;
      }
      
      public function get marketItems() : Array
      {
         return this._marketItems;
      }
      
      public function set marketItems(value:Array) : void
      {
         this._marketItems = value;
      }
      
      public function get gameIp() : String
      {
         return this._gameIp;
      }
      
      public function set gameIp(value:String) : void
      {
         this._gameIp = value;
      }
      
      public function get gameRoomName() : String
      {
         return this._gameRoomName;
      }
      
      public function set gameRoomName(value:String) : void
      {
         this._gameRoomName = value;
      }
      
      public function get inQueue() : Boolean
      {
         return this._inQueue;
      }
      
      public function set inQueue(value:Boolean) : void
      {
         this._inQueue = value;
      }
      
      public function get lobbyScreen() : RaceSelectionScreen
      {
         return this._lobbyScreen;
      }
      
      public function set lobbyScreen(value:RaceSelectionScreen) : void
      {
         this._lobbyScreen = value;
      }
      
      public function get raceSelected() : int
      {
         return this._raceSelected;
      }
      
      public function set raceSelected(value:int) : void
      {
         this._raceSelected = value;
      }
      
      public function get campaignUpgradeScreen() : CampaignUpgradeScreen
      {
         return this._campaignUpgradeScreen;
      }
      
      public function set campaignUpgradeScreen(value:CampaignUpgradeScreen) : void
      {
         this._campaignUpgradeScreen = value;
      }
      
      public function get loginScreen() : LoginScreen
      {
         return this._loginScreen;
      }
      
      public function set loginScreen(value:LoginScreen) : void
      {
         this._loginScreen = value;
      }
      
      public function get multiplayerGameScreen() : MultiplayerGameScreen
      {
         return this._multiplayerGameScreen;
      }
      
      public function set multiplayerGameScreen(value:MultiplayerGameScreen) : void
      {
         this._multiplayerGameScreen = value;
      }
      
      public function get mainLobbyScreen() : MainLobbyScreen
      {
         return this._mainLobbyScreen;
      }
      
      public function set mainLobbyScreen(value:MainLobbyScreen) : void
      {
         this._mainLobbyScreen = value;
      }
      
      public function get profileScreen() : ProfileScreen
      {
         return this._profileScreen;
      }
      
      public function set profileScreen(value:ProfileScreen) : void
      {
         this._profileScreen = value;
      }
      
      public function get armourScreen() : ArmoryScreen
      {
         return this._armourScreen;
      }
      
      public function set armourScreen(value:ArmoryScreen) : void
      {
         this._armourScreen = value;
      }
      
      public function get hasReceivedPurchases() : Boolean
      {
         return this._hasReceivedPurchases;
      }
      
      public function set hasReceivedPurchases(value:Boolean) : void
      {
         this._hasReceivedPurchases = value;
      }
      
      public function get empirePoints() : int
      {
         return this._empirePoints;
      }
      
      public function set empirePoints(value:int) : void
      {
         this._empirePoints = value;
      }
      
      public function get campaignGameScreen() : CampaignGameScreen
      {
         return this._campaignGameScreen;
      }
      
      public function set campaignGameScreen(value:CampaignGameScreen) : void
      {
         this._campaignGameScreen = value;
      }
      
      public function get chatOverlay() : ChatOverlayScreen
      {
         return this._chatOverlay;
      }
      
      public function set chatOverlay(value:ChatOverlayScreen) : void
      {
         this._chatOverlay = value;
      }
   }
}
