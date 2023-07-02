package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.game.Util;
   import com.brockw.stickwar.BaseMain;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Unit;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   import flash.text.*;
   import flash.utils.Timer;
   
   public class PostGameScreen extends Screen
   {
      
      private static const TEXT_SPACING:Number = 75;
      
      public static const M_CAMPAIGN:int = 0;
      
      public static const M_MULTIPLAYER:int = 1;
      
      public static const M_SINGLEPLAYER:int = 2;
      
      public static const M_SYNC_ERROR:int = 3;
       
      
      private var main:BaseMain;
      
      private var id:int;
      
      private var txtWelcome:GenericText;
      
      internal var btnConnect:GenericButton;
      
      internal var txtReplayFile:TextField;
      
      private var _economyRecords:Array;
      
      private var _militaryRecords:Array;
      
      private var mc:victoryScreenMc;
      
      private var displayGraph:Sprite;
      
      private var displayGraphBackground:Sprite;
      
      private var displayGraphBackgroundHighlight:Sprite;
      
      private var D_WIDTH:int = 570;
      
      private var D_HEIGHT:int = 350;
      
      private var textBoxes:Array;
      
      private var mode:int;
      
      private var unitUnlocked:Array;
      
      private var teamAName:String;
      
      private var teamBName:String;
      
      private var showCard:Boolean;
      
      private var newRating:int;
      
      private var currentRating:int;
      
      private var oldRating:int;
      
      private var timerToGetProfile:Timer;
      
      private var frameCount:int;
      
      private var wasWin:Boolean;
      
      private var lastAddImage:MovieClip;
      
      public function PostGameScreen(main:BaseMain)
      {
         super();
         this.mode = M_CAMPAIGN;
         this.textBoxes = [];
         this.mc = new victoryScreenMc();
         addChild(this.mc);
         this.displayGraph = this.mc.graphArea;
         this.displayGraphBackground = this.mc.graphAreaBackground;
         this.displayGraphBackgroundHighlight = this.mc.graphAreaBackgroundHighlight;
         this.D_WIDTH = 740;
         this.D_HEIGHT = 216;
         this.lastAddImage = null;
         this.main = main;
         this.unitUnlocked = [];
         this.mc.unlockCard.visible = false;
         this.mc.exit.text.text = "Quit";
         this.mc.exit.buttonMode = true;
         this.mc.exit.mouseChildren = false;
         this.id = -1;
         this.showCard = false;
      }
      
      public static function getTimeFormat(seconds:int) : String
      {
         var minutes:int = Math.floor(seconds / 60);
         seconds = Math.floor(seconds % 60);
         var result:String = "";
         if(minutes < 10)
         {
            result += "0";
         }
         result += minutes + ":";
         if(seconds < 10)
         {
            result += "0";
         }
         return result + ("" + seconds);
      }
      
      public function appendUnitUnlocked(u:int, game:StickWar) : void
      {
         var unit:Unit = game.unitFactory.getUnit(u);
         var item:XMLList = game.team.buttonInfoMap[u][2];
         this.unitUnlocked.push([item.name,item.info,game.unitFactory.getProfile(u)]);
         game.unitFactory.returnUnit(unit.type,unit);
      }
      
      public function showNextUnitUnlocked() : void
      {
         var nextUnit:Array = null;
         var m:MovieClip = null;
         if(this.unitUnlocked.length == 0)
         {
            this.mc.unlockCard.visible = false;
            this.showCard = false;
         }
         else
         {
            this.showCard = true;
            nextUnit = this.unitUnlocked.shift();
            this.mc.unlockCard.visible = true;
            this.mc.unlockCard.alpha = 0;
            this.mc.unlockCard.description.text = nextUnit[1];
            this.mc.unlockCard.unitName.text = nextUnit[0];
            m = MovieClip(this.mc.unlockCard.profilePictureBacking);
            if(this.lastAddImage != null)
            {
               if(Boolean(this.mc.unlockCard.profilePictureBacking.contains(this.lastAddImage)))
               {
                  this.mc.unlockCard.profilePictureBacking.removeChild(this.lastAddImage);
               }
            }
            this.mc.unlockCard.profilePictureBacking.addChild(nextUnit[2]);
            this.main.soundManager.playSoundFullVolume("UnitUnlock");
            this.lastAddImage = nextUnit[2];
         }
      }
      
      public function setRatings(a:int, b:int) : void
      {
         this.mc.ratingA.text = "" + a;
         this.mc.ratingB.text = "" + b;
         this.oldRating = this.currentRating = this.newRating = a;
      }
      
      public function setMode(m:int, isReplay:Boolean = false) : void
      {
         this.mode = m;
         this.mc.userAButton.buttonMode = false;
         this.mc.userBButton.buttonMode = false;
         this.mc.userAButton.mouseEnabled = false;
         this.mc.userBButton.mouseEnabled = false;
         this.mc.tip.visible = false;
         if(this.mode == PostGameScreen.M_CAMPAIGN)
         {
            this.mc.exit.text.text = "Continue";
            this.mc.singlePlayerOverlay.visible = true;
            this.mc.timer.visible = true;
            this.mc.saveReplay.text.text = "Play Online";
            this.mc.saveReplay.visible = true;
            if(!this.wasWin)
            {
               this.mc.exit.text.text = "Retry";
            }
         }
         else if(this.mode == PostGameScreen.M_SYNC_ERROR)
         {
            this.mc.exit.text.text = "Continue";
            this.mc.replay.text = "If this continues to happen try installing the latest version of flash player";
            this.displayGraph.graphics.clear();
            this.mc.saveReplay.visible = false;
            this.mc.gameStatus.gotoAndStop("syncError");
            this.mc.singlePlayerOverlay.visible = false;
            this.mc.timer.visible = false;
         }
         else if(this.mode == PostGameScreen.M_SINGLEPLAYER)
         {
            this.mc.exit.text.text = "Quit";
            this.mc.singlePlayerOverlay.visible = true;
            this.mc.timer.visible = true;
            this.mc.saveReplay.text.text = "Game Guide";
         }
         else
         {
            this.mc.unlockCard.visible = false;
            this.mc.exit.text.text = "Continue";
            this.mc.singlePlayerOverlay.visible = false;
            this.mc.timer.visible = false;
            this.mc.saveReplay.text.text = "Save Replay";
            this.mc.userAButton.buttonMode = true;
            this.mc.userBButton.buttonMode = true;
            this.mc.userAButton.mouseEnabled = true;
            this.mc.userBButton.mouseEnabled = true;
         }
      }
      
      private function drawLineGraph(records:Array, max:Number, canvas:Sprite, isEven:Boolean, yOffset:Number = 0) : void
      {
         var gapSize:Number = this.D_WIDTH / (records.length / 2 - 1);
         var incrementSize:Number = this.D_HEIGHT / max;
         for(var i:int = isEven ? 0 : 1; i < records.length; i += 2)
         {
            if(i == 0 || i == 1)
            {
               canvas.graphics.moveTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * records[i] + yOffset);
            }
            else
            {
               canvas.graphics.lineTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * records[i] + yOffset);
            }
         }
      }
      
      private function drawSpecialLine(records:Array, max:Number, canvas:Sprite, isEven:Boolean, colour:int) : void
      {
         this.displayGraphBackground.graphics.lineStyle(10,0);
         this.drawLineGraph(records,max,this.displayGraphBackground,isEven);
         this.displayGraphBackground.graphics.endFill();
         this.displayGraph.graphics.lineStyle(2,colour);
         this.drawLineGraph(records,max,canvas,isEven);
         this.displayGraph.graphics.endFill();
         this.displayGraphBackgroundHighlight.graphics.lineStyle(2,2365457);
         this.drawLineGraph(records,max,this.displayGraphBackgroundHighlight,isEven,6);
         this.displayGraphBackgroundHighlight.graphics.endFill();
      }
      
      private function drawGraph() : void
      {
         var i:int = 0;
         var box:TextField = null;
         var prevValue:String = null;
         var newTxt:TextField = null;
         var t:TextFormat = null;
         this.displayGraph.graphics.clear();
         this.displayGraphBackground.graphics.clear();
         this.displayGraphBackgroundHighlight.graphics.clear();
         var maxMiners:int = 0;
         var maxPopulation:int = 0;
         for(i = 0; i < this.economyRecords.length; i++)
         {
            if(this.economyRecords[i] > maxMiners)
            {
               maxMiners = int(this.economyRecords[i]);
            }
         }
         for(i = 0; i < this.militaryRecords.length; i++)
         {
            if(this.militaryRecords[i] > maxPopulation)
            {
               maxPopulation = int(this.militaryRecords[i]);
            }
         }
         var max:int = Math.max(maxMiners,maxPopulation);
         var gapSize:Number = this.D_WIDTH / (this.economyRecords.length / 2 - 1);
         var incrementSize:Number = this.D_HEIGHT / Math.max(maxMiners,maxPopulation);
         this.drawSpecialLine(this.economyRecords,max,this.displayGraph,true,26367);
         this.drawSpecialLine(this.economyRecords,max,this.displayGraph,false,16685313);
         this.drawSpecialLine(this.militaryRecords,max,this.displayGraph,true,35840);
         this.drawSpecialLine(this.militaryRecords,max,this.displayGraph,false,10223616);
         for each(box in this.textBoxes)
         {
            this.displayGraph.removeChild(box);
         }
         this.textBoxes = [];
         prevValue = "";
         for(i = 0; i < this.D_WIDTH / TEXT_SPACING; i++)
         {
            newTxt = new TextField();
            newTxt.y = this.D_HEIGHT + 3;
            newTxt.x = i * TEXT_SPACING - 5;
            t = new TextFormat();
            t.color = 16777215;
            newTxt.defaultTextFormat = t;
            newTxt.text = getTimeFormat(Math.floor(i / (this.D_WIDTH / TEXT_SPACING) * this.militaryRecords.length / 2 * 2));
            if(newTxt.text == prevValue)
            {
               newTxt.visible = false;
            }
            prevValue = newTxt.text;
            newTxt.mouseEnabled = false;
            this.displayGraph.addChild(newTxt);
            this.textBoxes.push(newTxt);
         }
         prevValue = "";
         for(i = 0; i < this.D_HEIGHT / TEXT_SPACING + 1; i++)
         {
            newTxt = new TextField();
            newTxt.y = this.D_HEIGHT - i * TEXT_SPACING - 6;
            newTxt.x = 0 - 20;
            t = new TextFormat();
            t.color = 16777215;
            newTxt.defaultTextFormat = t;
            newTxt.text = "" + Math.floor(maxPopulation * i / (this.D_WIDTH / TEXT_SPACING));
            newTxt.mouseEnabled = false;
            if(newTxt.text == prevValue)
            {
               newTxt.visible = false;
            }
            prevValue = newTxt.text;
            this.displayGraph.addChild(newTxt);
            this.textBoxes.push(newTxt);
         }
         this.mc.timer.text = getTimeFormat(this.militaryRecords.length);
      }
      
      public function setRecords(economyRecords:Array, militaryRecords:Array) : void
      {
         this.economyRecords = economyRecords;
         this.militaryRecords = militaryRecords;
         this.drawGraph();
      }
      
      private function btnConnectLogin(evt:Event) : void
      {
         if(this.mode == PostGameScreen.M_MULTIPLAYER || this.mode == PostGameScreen.M_SYNC_ERROR || this.mode == PostGameScreen.M_SINGLEPLAYER)
         {
            if(this.main.sfs != null && this.main.sfs.isConnected && this.main.sfs.mySelf != null)
            {
               if(this.main.willSeeAdds())
               {
                  this.main.showScreen("lobby");
                  Main(this.main).chatOverlay.addManager.showAdd();
               }
               else
               {
                  this.main.showScreen("lobby");
               }
            }
            else
            {
               this.main.showScreen("login");
            }
         }
         else if(this.mode == PostGameScreen.M_CAMPAIGN)
         {
            if(this.main.campaign.isGameFinished())
            {
               this.main.showScreen("summary",false,true);
            }
            else
            {
               this.main.soundManager.playSoundFullVolume("clickButton");
               this.main.showScreen("campaignUpgradeScreen",false,true);
            }
         }
      }
      
      private function secondButton(e:Event) : void
      {
         var url:URLRequest = null;
         if(this.mode == PostGameScreen.M_CAMPAIGN)
         {
            url = new URLRequest("http://www.stickempires.com");
            navigateToURL(url,"_blank");
            this.main.soundManager.playSoundFullVolume("clickButton");
         }
         else if(this.mode == PostGameScreen.M_SINGLEPLAYER)
         {
            url = new URLRequest("http://www.stickpage.com/stickempiresguide.shtml");
            navigateToURL(url,"_blank");
         }
         else
         {
            this.mc.replayViewer.visible = true;
            this.mc.replayViewer.view.text.text = "View Replay";
            this.mc.replayViewer.copy.text.text = "Copy Replay";
            this.mc.replayViewer.exit.text.text = "Exit";
            this.mc.replayViewer.replayText.text = this.mc.replay.text;
         }
      }
      
      private function copyReplay(e:Event) : void
      {
         this.mc.replayViewer.replayText.text;
         System.setClipboard(this.mc.replayViewer.replayText.text);
         this.main.stage.focus = this.mc.replayViewer.replayText;
         this.mc.replayViewer.replayText.setSelection(0,this.mc.replayViewer.replayText.length);
      }
      
      override public function enter() : void
      {
         this.frameCount = 0;
         stage.frameRate = 30;
         addEventListener(Event.ENTER_FRAME,this.update);
         this.mc.exit.addEventListener(MouseEvent.CLICK,this.btnConnectLogin);
         this.mc.saveReplay.addEventListener(MouseEvent.CLICK,this.secondButton);
         this.mc.saveReplay.buttonMode = true;
         this.mc.saveReplay.text.mouseEnabled = false;
         this.mc.userAButton.addEventListener(MouseEvent.CLICK,this.hitUserA);
         this.mc.userBButton.addEventListener(MouseEvent.CLICK,this.hitUserB);
         this.mc.userA.mouseEnabled = false;
         this.mc.userB.mouseEnabled = false;
         this.mc.userAButton.buttonMode = true;
         this.mc.userBButton.buttonMode = true;
         this.mc.userA.mouseEnabled = false;
         this.mc.userB.mouseEnabled = false;
         this.mc.unlockCard.okButton.addEventListener(MouseEvent.CLICK,this.closeCard);
         this.mc.tip.okButton.addEventListener(MouseEvent.CLICK,this.closeTipCard);
         if(this.mode == PostGameScreen.M_MULTIPLAYER)
         {
            this.timerToGetProfile = new Timer(1000,1);
            this.timerToGetProfile.addEventListener(TimerEvent.TIMER,this.getProfile);
            this.timerToGetProfile.start();
         }
         this.mc.replayViewer.visible = false;
         this.mc.replayViewer.exit.addEventListener(MouseEvent.CLICK,this.exit);
         this.mc.replayViewer.view.addEventListener(MouseEvent.CLICK,this.viewReplay);
         this.mc.replayViewer.copy.addEventListener(MouseEvent.CLICK,this.copyReplay);
         this.mc.replayViewer.exit.buttonMode = true;
         this.mc.replayViewer.copy.buttonMode = true;
         this.mc.replayViewer.view.buttonMode = true;
         this.mc.replayViewer.exit.mouseChildren = false;
         this.mc.replayViewer.copy.mouseChildren = false;
         this.mc.replayViewer.view.mouseChildren = false;
      }
      
      private function exit(e:Event) : void
      {
         this.mc.replayViewer.visible = false;
      }
      
      private function viewReplay(e:Event) : void
      {
         this.main.showScreen("replayLoader");
         this.main.replayLoaderScreen.mc.replayText.text.text = this.mc.replay.text;
      }
      
      private function closeTipCard(e:Event) : void
      {
         this.mc.tip.visible = false;
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function getProfile(e:Event) : void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("name",this.main.sfs.mySelf.name);
         var r:ExtensionRequest = new ExtensionRequest("getProfile",params);
         this.main.sfs.send(r);
      }
      
      override public function maySwitchOnDisconnect() : Boolean
      {
         return false;
      }
      
      private function hitUserA(evt:Event) : void
      {
         this.main.showScreen("profile");
         if(this.main is Main)
         {
            Main(this.main).profileScreen.loadProfile(this.teamAName);
         }
      }
      
      private function hitUserB(evt:Event) : void
      {
         this.main.showScreen("profile");
         if(this.main is Main)
         {
            Main(this.main).profileScreen.loadProfile(this.teamBName);
         }
      }
      
      private function closeCard(evt:Event) : void
      {
         this.showCard = false;
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function update(evt:Event) : void
      {
         var sign:String = null;
         var difference:int = 0;
         ++this.frameCount;
         if(this.frameCount % 3 == 0)
         {
            if(this.currentRating != this.newRating)
            {
               this.currentRating += Util.sgn(this.newRating - this.currentRating);
            }
            sign = "+";
            difference = Math.abs(this.currentRating - this.oldRating);
            if(this.currentRating < this.oldRating)
            {
               sign = "-";
            }
            if(this.newRating != this.oldRating)
            {
               this.mc.ratingA.text = this.currentRating + " (" + sign + difference + ")";
            }
            else
            {
               this.mc.ratingA.text = "" + this.currentRating;
            }
         }
         if(this.showCard)
         {
            this.mc.unlockCard.alpha += (1 - this.mc.unlockCard.alpha) * 0.2;
         }
         else if(this.mc.unlockCard.visible == true)
         {
            this.mc.unlockCard.alpha += (0 - this.mc.unlockCard.alpha) * 0.3;
            if(this.mc.unlockCard.alpha < 0.01)
            {
               this.showNextUnitUnlocked();
            }
         }
      }
      
      override public function leave() : void
      {
         this.mc.exit.removeEventListener(MouseEvent.CLICK,this.btnConnectLogin);
         removeEventListener(Event.ENTER_FRAME,this.update);
         this.mc.unlockCard.okButton.removeEventListener(MouseEvent.CLICK,this.closeCard);
         this.mc.userAButton.removeEventListener(MouseEvent.CLICK,this.hitUserA);
         this.mc.userBButton.removeEventListener(MouseEvent.CLICK,this.hitUserB);
         this.mc.tip.okButton.removeEventListener(MouseEvent.CLICK,this.closeTipCard);
         this.mc.replayViewer.copy.removeEventListener(MouseEvent.CLICK,this.copyReplay);
         this.mc.replayViewer.exit.removeEventListener(MouseEvent.CLICK,this.exit);
         this.mc.replayViewer.view.removeEventListener(MouseEvent.CLICK,this.viewReplay);
      }
      
      public function setReplayFile(s:String) : void
      {
         this.mc.replay.text = s;
         this.mc.saveReplay.visible = true;
      }
      
      public function setTipText(s:String) : void
      {
         if(s != "")
         {
            this.mc.tip.tip.text = s;
            this.mc.tip.visible = true;
         }
      }
      
      public function receiveProfile(data:SFSObject) : void
      {
         var username:String = data.getUtfString("username");
         var rating:int = data.getDouble("rating");
         var ratingA:int = int(this.mc.ratingA.text);
         var ratingB:int = int(this.mc.ratingB.text);
         if(this.mc.userA.text.toLowerCase() == username.toLowerCase())
         {
            if(this.mc.ratingA.text != "" && ratingA != rating)
            {
               this.startRatingAnimationA(rating);
            }
         }
      }
      
      private function startRatingAnimationA(newRating:int) : void
      {
         this.newRating = newRating;
         trace(newRating);
      }
      
      public function setWinner(id:int, race:int, userAName:String, userBName:String, myId:int) : void
      {
         var s:String = "";
         if(race == Team.T_GOOD)
         {
            s += "order";
         }
         else
         {
            s += "chaos";
         }
         if(myId != -1)
         {
            if(myId == id)
            {
               s += "Victory";
               this.wasWin = true;
               this.main.soundManager.playSoundInBackground("OrderVictory");
            }
            else
            {
               this.wasWin = false;
               s += "Defeat";
               this.main.soundManager.playSoundInBackground("OrderDefeat");
            }
         }
         this.mc.userA.text = userAName;
         this.mc.userB.text = userBName;
         this.teamAName = userAName;
         this.teamBName = userBName;
         this.mc.gameStatus.gotoAndStop(s);
         this.id = id;
      }
      
      public function get economyRecords() : Array
      {
         return this._economyRecords;
      }
      
      public function set economyRecords(value:Array) : void
      {
         this._economyRecords = value;
      }
      
      public function get militaryRecords() : Array
      {
         return this._militaryRecords;
      }
      
      public function set militaryRecords(value:Array) : void
      {
         this._militaryRecords = value;
      }
   }
}
