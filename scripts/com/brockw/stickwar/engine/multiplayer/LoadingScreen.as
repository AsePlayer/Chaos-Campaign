package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.maps.Map;
   import com.brockw.stickwar.market.ArmoryScreen;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import com.smartfoxserver.v2.requests.LoginRequest;
   import com.smartfoxserver.v2.requests.LogoutRequest;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class LoadingScreen extends Screen
   {
       
      
      private var main:Main;
      
      private var timer:Timer;
      
      private var txtWelcome:GenericText;
      
      private var loadingScreen:pregameScreenMc;
      
      private var raceSelectMc:lobbyScreenMc;
      
      private var minWaitTime:int;
      
      private var setUpLoadingScreen:Boolean;
      
      private var isSelectingRace:Boolean;
      
      private var mouseIsIn:int;
      
      private var gotGameRoom:Boolean;
      
      private var initInNFrames:int;
      
      private var raceSelectionParams:SFSObject;
      
      private var didSelect:Boolean;
      
      private var readyTimer:Timer;
      
      private var timerStartTime:Number;
      
      private var isShowingMembershipRequired:Boolean = false;
      
      private var hasClicked:Boolean;
      
      private var mapDisplayPic:MovieClip;
      
      public function LoadingScreen(main:Main)
      {
         super();
         this.mapDisplayPic = null;
         this.hasClicked = true;
         this.loadingScreen = new pregameScreenMc();
         this.raceSelectMc = new lobbyScreenMc();
         addChild(this.loadingScreen);
         addChild(this.raceSelectMc);
         this.main = main;
         this.timer = new Timer(1000 / 33,0);
         this.raceSelectMc.orderButton.stop();
         this.raceSelectMc.chaosButton.stop();
         this.raceSelectMc.randomButton.stop();
         this.mouseIsIn = 0;
         this.initInNFrames = 0;
         this.raceSelectionParams = null;
         this.didSelect = false;
      }
      
      private function mouseUp(evt:Event) : void
      {
         this.hasClicked = true;
      }
      
      private function mouseDown(evt:Event) : void
      {
         var d:Number = NaN;
         if(this.hasClicked)
         {
            this.hasClicked = false;
            if(!this.setUpLoadingScreen)
            {
               d = Math.sqrt(Math.pow(this.raceSelectMc.orderButton.mouseX,2) + Math.pow(this.raceSelectMc.orderButton.mouseY + 100,2));
               if(d < 150)
               {
                  this.main.raceSelected = Team.T_GOOD;
                  this.didSelect = true;
                  this.raceChange();
                  this.main.soundManager.playSoundFullVolume("SelectRaceSound");
               }
               d = Math.sqrt(Math.pow(this.raceSelectMc.chaosButton.mouseX,2) + Math.pow(this.raceSelectMc.chaosButton.mouseY + 100,2));
               if(this.main.isMember && d < 150)
               {
                  this.main.raceSelected = Team.T_CHAOS;
                  this.didSelect = true;
                  this.raceChange();
                  this.main.soundManager.playSoundFullVolume("SelectRaceSound");
               }
               d = Math.sqrt(Math.pow(this.raceSelectMc.randomButton.mouseX,2) + Math.pow(this.raceSelectMc.randomButton.mouseY,2));
               if(this.main.isMember && d < 75)
               {
                  this.main.raceSelected = Team.T_RANDOM;
                  this.didSelect = true;
                  this.raceChange();
                  this.main.soundManager.playSoundFullVolume("SelectRaceSound");
               }
            }
         }
         this.update(evt);
      }
      
      private function raceChange() : void
      {
         var id:int = 0;
         var params:SFSObject = null;
         if(this.gotGameRoom)
         {
            id = this.main.raceSelected;
            trace("RACE CHANGE");
            params = new SFSObject();
            params.putInt("race",id);
            this.main.gameServer.send(new ExtensionRequest("racePick",params,Main(this.main).gameRoom));
            this.didSelect = false;
         }
      }
      
      public function onConnection(evt:SFSEvent) : void
      {
         var params:SFSObject = null;
         if(evt.params.success)
         {
            trace("Connected to server!");
            trace("Attempting to login to game server");
            params = new SFSObject();
            params.putUtfString("password",this.main.passwordEncrypted);
            params.putUtfString("version",this.main.version);
            this.main.gameServer.send(new LoginRequest(this.main.sfs.mySelf.name,"","stickwar",params));
         }
         else
         {
            trace("Error connecting",evt.params.errorMessage);
         }
      }
      
      public function SFSLoginError(evt:SFSEvent) : void
      {
         trace("Can not login to game server: ",evt.params.errorMessage);
      }
      
      override public function enter() : void
      {
         this.isShowingMembershipRequired = false;
         this.raceSelectMc.membershipRequired.y = 740;
         this.main.soundManager.playSoundFullVolume("MatchFoundSound");
         trace("Select your races!");
         stage.frameRate = 30;
         this.timerStartTime = getTimer();
         this.didSelect = false;
         this.loadingScreen.visible = false;
         this.raceSelectMc.visible = true;
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.isSelectingRace = true;
         this.main.gameServer.addEventListener(SFSEvent.CONNECTION,this.onConnection);
         this.timer.addEventListener(TimerEvent.TIMER,this.update);
         this.timer.start();
         this.main.gameServer.addEventListener(SFSEvent.LOGIN,this.SFSLogin);
         this.main.gameServer.addEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
         this.main.gameServer.addEventListener(SFSEvent.LOGOUT,this.SFSLogout);
         this.minWaitTime = 0;
         this.main.gameServer.addEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
         this.main.gameServer.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.main.extensionResponse,false,0,true);
         this.setUpLoadingScreen = false;
         this.gotGameRoom = false;
         this.main.setOverlayScreen("");
         this.main.raceSelected = -1;
         this.raceSelectMc.countdown.text = "" + Math.floor(10);
         this.initInNFrames = 0;
         this.raceSelectMc.chaosLocked.addEventListener(MouseEvent.CLICK,this.showMembershipRequired);
         this.raceSelectMc.chaosLocked.buttonMode = true;
         this.raceSelectMc.randomButton.buttonMode = true;
         this.raceSelectMc.orderButton.buttonMode = true;
         this.raceSelectMc.chaosButton.buttonMode = true;
         if(this.main.isMember)
         {
            this.raceSelectMc.chaosLocked.visible = false;
            this.raceSelectMc.randomButton.visible = true;
         }
         else
         {
            this.raceSelectMc.chaosLocked.visible = true;
            this.raceSelectMc.randomButton.visible = false;
         }
         this.readyTimer = new Timer(1000,1);
         this.readyTimer.addEventListener(TimerEvent.TIMER,this.readyToPlay);
      }
      
      private function showMembershipRequired(evt:Event) : void
      {
         this.isShowingMembershipRequired = true;
      }
      
      private function openMembershipBuy(evt:Event) : void
      {
         ArmoryScreen.openPayment("membership",this.main);
      }
      
      public function setCountdown(left:Number) : void
      {
      }
      
      override public function leave() : void
      {
         this.timer.stop();
         trace("Finished loading the game!");
         this.timer.removeEventListener(TimerEvent.TIMER,this.update);
         this.main.gameServer.removeEventListener(SFSEvent.CONNECTION,this.onConnection);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.main.gameServer.removeEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
         this.main.gameServer.removeEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
         this.main.gameServer.removeEventListener(SFSEvent.LOGOUT,this.SFSLogout);
         this.main.gameServer.removeEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
         this.raceSelectMc.chaosLocked.removeEventListener(MouseEvent.CLICK,this.openMembershipBuy);
         this.readyTimer.removeEventListener(TimerEvent.TIMER,this.readyToPlay);
      }
      
      public function SFSLogin(evt:SFSEvent) : void
      {
         trace("Login successful");
      }
      
      public function receivedRaceSelection(params:SFSObject) : void
      {
         var a:int = 0;
         var b:int = 0;
         var temp:int = 0;
         this.isSelectingRace = false;
         this.raceSelectionParams = params;
         trace("received race selection");
         a = this.main.gameRoom.playerList[0].id;
         b = this.main.gameRoom.playerList[1].id;
         var aLabel:String = "race_" + User(this.main.gameRoom.playerList[0]).name;
         var bLabel:String = "race_" + User(this.main.gameRoom.playerList[1]).name;
         var teamAName:int = params.getInt(this.main.gameRoom.playerList[0].name);
         var teamBName:int = params.getInt(this.main.gameRoom.playerList[1].name);
         trace(teamAName,teamBName);
         var teamARealName:String = User(this.main.gameRoom.playerList[0]).name;
         var teamBRealName:String = User(this.main.gameRoom.playerList[1]).name;
         var teamARating:Number = User(this.main.gameRoom.playerList[0]).getVariable("rating").getDoubleValue();
         var teamBRating:Number = User(this.main.gameRoom.playerList[1]).getVariable("rating").getDoubleValue();
         var realNameA:String = "";
         var realNameB:String = "";
         if(a > b)
         {
            temp = teamBName;
            teamBName = teamAName;
            teamAName = temp;
            temp = teamBRating;
            teamBRating = teamARating;
            teamARating = temp;
            realNameA = teamBRealName;
            realNameB = teamARealName;
         }
         else
         {
            realNameA = teamARealName;
            realNameB = teamBRealName;
         }
         this.setUpLoadingScreen = true;
         this.loadingScreen.userAName.text = realNameA;
         this.loadingScreen.userBName.text = realNameB;
         this.loadingScreen.userARace.text = Team.getRaceNameFromId(teamAName);
         this.loadingScreen.userBRace.text = Team.getRaceNameFromId(teamBName);
         this.loadingScreen.userAFavour.text = this.getFavour(teamARating,teamBRating);
         this.loadingScreen.userBFavour.text = this.getFavour(teamBRating,teamARating);
         this.loadingScreen.raceIconA.gotoAndStop(Team.getRaceNameFromId(teamAName));
         this.loadingScreen.raceIconB.gotoAndStop(Team.getRaceNameFromId(teamBName));
         this.loadingScreen.mapName.text = Map.getMapNameFromId(this.main.gameRoom.getVariable("map").getIntValue());
      }
      
      public function update(evt:Event) : void
      {
         var room:Room = null;
         var startLoad:Number = NaN;
         var totalLoadTime:* = undefined;
         var minimumLoadTime:Number = NaN;
         if(this.main.raceSelected == Team.T_GOOD)
         {
            this.raceSelectMc.orderButton.gotoAndStop(3);
         }
         else if(Math.sqrt(Math.pow(this.raceSelectMc.orderButton.mouseX,2) + Math.pow(this.raceSelectMc.orderButton.mouseY + 100,2)) < 150)
         {
            this.raceSelectMc.orderButton.gotoAndStop(2);
         }
         else
         {
            this.raceSelectMc.orderButton.gotoAndStop(1);
         }
         if(this.main.raceSelected == Team.T_CHAOS)
         {
            this.raceSelectMc.chaosButton.gotoAndStop(3);
         }
         else if(this.main.isMember && Math.sqrt(Math.pow(this.raceSelectMc.chaosButton.mouseX,2) + Math.pow(this.raceSelectMc.chaosButton.mouseY + 100,2)) < 150)
         {
            this.raceSelectMc.chaosButton.gotoAndStop(2);
         }
         else
         {
            this.raceSelectMc.chaosButton.gotoAndStop(1);
         }
         if(this.main.raceSelected == Team.T_RANDOM)
         {
            this.raceSelectMc.randomButton.gotoAndStop(3);
         }
         else if(this.main.isMember && this.raceSelectMc.randomButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.raceSelectMc.randomButton.gotoAndStop(2);
         }
         else
         {
            this.raceSelectMc.randomButton.gotoAndStop(1);
         }
         if(this.isShowingMembershipRequired)
         {
            this.raceSelectMc.membershipRequired.y += (684 - this.raceSelectMc.membershipRequired.y) * 0.1;
         }
         else
         {
            this.raceSelectMc.membershipRequired.y += (740 - this.raceSelectMc.membershipRequired.y) * 0.1;
         }
         if(!this.setUpLoadingScreen)
         {
            for each(room in this.main.gameServer.roomList)
            {
               if(room.isGame && room.name == this.main.gameRoomName)
               {
                  this.main.gameRoom = room;
                  this.gotGameRoom = true;
                  if(this.didSelect)
                  {
                     this.raceChange();
                  }
               }
            }
         }
         var timeUsed:Number = 10000 - (getTimer() - this.timerStartTime);
         if(timeUsed < 0)
         {
            timeUsed = 0;
            if(!this.gotGameRoom)
            {
               this.main.gameServer.send(new LogoutRequest());
               this.main.showScreen("lobby");
            }
         }
         this.raceSelectMc.countdown.text = "" + Math.floor(timeUsed / 1000);
         if(this.loadingScreen.visible == false && this.isSelectingRace == false && this.main.gameRoom != null && this.main.gameRoom.playerList.length == 2 && this.minWaitTime > 30 * 4)
         {
            this.loadingScreen.visible = true;
            this.raceSelectMc.visible = false;
            this.initInNFrames = 5;
            if(this.mapDisplayPic)
            {
               if(this.loadingScreen.container.contains(this.mapDisplayPic))
               {
                  this.loadingScreen.container.removeChild(this.mapDisplayPic);
               }
            }
            this.mapDisplayPic = null;
            this.mapDisplayPic = Map.getMapDisplayFromId(Main(this.main).gameRoom.getVariable("map").getIntValue());
            this.loadingScreen.container.addChild(this.mapDisplayPic);
            this.mapDisplayPic.x = 425 - this.mapDisplayPic.width / 2;
            this.mapDisplayPic.y = 432 - this.mapDisplayPic.height / 2;
         }
         if(this.initInNFrames - 1 == 0)
         {
            startLoad = getTimer();
            this.timer.removeEventListener(TimerEvent.TIMER,this.update);
            addChild(this.main.multiplayerGameScreen);
            this.main.multiplayerGameScreen.alpha = 0;
            this.main.multiplayerGameScreen.init(this.raceSelectionParams);
            removeChild(this.main.multiplayerGameScreen);
            this.main.multiplayerGameScreen.alpha = 1;
            this.initInNFrames -= 1;
            totalLoadTime = getTimer() - startLoad;
            minimumLoadTime = Math.max(0,2000 - totalLoadTime);
            trace(minimumLoadTime);
            this.readyTimer.delay = minimumLoadTime;
            this.readyTimer.start();
         }
         else if(this.initInNFrames > 0)
         {
            this.initInNFrames -= 1;
         }
         ++this.minWaitTime;
      }
      
      private function SFSLogout(e:Event) : void
      {
         trace("Logout");
      }
      
      private function readyToPlay(e:Event) : void
      {
         Main(this.main).gameServer.send(new ExtensionRequest("r",new SFSObject(),Main(this.main).gameRoom));
      }
      
      private function getFavour(ratingA:Number, ratingB:Number) : String
      {
         if(Math.abs(ratingA - ratingB) < 25)
         {
            return "Even";
         }
         if(ratingA < ratingB)
         {
            return "";
         }
         return "Favored";
      }
      
      public function SFSRoomJoinError(evt:SFSEvent) : void
      {
         trace("Could not join the game!");
      }
   }
}
