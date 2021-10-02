package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.multiplayer.adds.AddManager;
   import com.liamr.ui.dropDown.DropDown;
   import com.liamr.ui.dropDown.Events.DropDownEvent;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import com.smartfoxserver.v2.requests.LogoutRequest;
   import fl.controls.ScrollPolicy;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class ChatOverlayScreen extends Screen
   {
       
      
      var main:Main;
      
      var chatOverlay:chatOverlayMc;
      
      var timer:Timer;
      
      private var population:int;
      
      private var _buddyList:BuddyList;
      
      private var isUserListDisplayed:Boolean;
      
      private var _isBuddyListInited:Boolean;
      
      private var statusSelect:DropDown;
      
      private var frame:int;
      
      private var queueStartTimer:int;
      
      private var queueTimer:Timer;
      
      private var currentTerms:int;
      
      private var _addManager:AddManager;
      
      public function ChatOverlayScreen(main:Main)
      {
         super();
         this.currentTerms = 0;
         this.frame = 0;
         this.population = 0;
         this.chatOverlay = new chatOverlayMc();
         addChild(this.chatOverlay);
         this.main = main;
         this._isBuddyListInited = false;
         this._buddyList = new BuddyList(this.chatOverlay,main);
         var s:Array = Buddy.getStatuses();
         this.statusSelect = new DropDown(s,"Select status",true,100);
         this.statusSelect.x = 12;
         this.statusSelect.y = 10;
         this.statusSelect.scaleX *= 0.7;
         this.statusSelect.scaleY *= 0.7;
         this.chatOverlay.chatBoxMc.addChild(this.statusSelect);
         this.isUserListDisplayed = false;
         this.chatOverlay.chatBoxMc.visible = false;
         this.timer = new Timer(1000 / 30,0);
         this.queueStartTimer = 0;
         this.queueTimer = new Timer(500,0);
         this.updateQueueTimer(null);
         this.chatOverlay.termsScreen.visible = false;
         this.chatOverlay.termsScreen.scrollPane.source = this.chatOverlay.termsScreen.terms;
         this.chatOverlay.termsScreen.scrollPane.setSize(this.chatOverlay.termsScreen.scrollPane.width,this.chatOverlay.termsScreen.scrollPane.height);
         this.chatOverlay.termsScreen.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.addManager = new AddManager(main);
         addChild(this.addManager);
      }
      
      public function showTerms(params:SFSObject) : void
      {
         trace("SHOW TERMS");
         this.chatOverlay.termsScreen.visible = true;
         this.chatOverlay.termsScreen.terms.text = params.getUtfString("terms");
         this.chatOverlay.termsScreen.terms.mouseWheelEnabled = false;
         this.chatOverlay.termsScreen.terms.height = this.chatOverlay.termsScreen.terms.textHeight + 100;
         this.currentTerms = params.getInt("id");
      }
      
      private function updateQueueTimer(evt:Event) : void
      {
         if(this.main.inQueue)
         {
            this.chatOverlay.cancelButton.visible = true;
            this.chatOverlay.matchTimerText.visible = true;
            this.chatOverlay.matchTimerText.text.text = "In matchmaking queue: " + int((getTimer() - this.queueStartTimer) / 1000);
         }
         else
         {
            this.chatOverlay.cancelButton.visible = false;
            this.chatOverlay.matchTimerText.text.text = this.population + " users online";
         }
      }
      
      public function startQueueCount() : void
      {
         this.queueStartTimer = getTimer();
      }
      
      public function stopQueueCount() : void
      {
      }
      
      public function addUserResponse(message:String, oneButton:Boolean = false) : void
      {
         this.chatOverlay.gameInviteWindow.visible = true;
         this.chatOverlay.gameInviteWindow.invitationText.text = message;
         this.chatOverlay.gameInviteWindow.acceptButton.addEventListener(MouseEvent.CLICK,this.closeAddUserResponse);
         this.chatOverlay.gameInviteWindow.rejectButton.addEventListener(MouseEvent.CLICK,this.closeAddUserResponse);
         this.chatOverlay.gameInviteWindow.okButton.addEventListener(MouseEvent.CLICK,this.closeAddUserResponse);
         this.chatOverlay.gameInviteWindow.rejectButton.visible = false;
         this.chatOverlay.gameInviteWindow.acceptButton.visible = false;
         this.chatOverlay.gameInviteWindow.okButton.visible = true;
      }
      
      private function closeAddUserResponse(evt:Event) : void
      {
         this.chatOverlay.gameInviteWindow.acceptButton.removeEventListener(MouseEvent.CLICK,this.closeAddUserResponse);
         this.chatOverlay.gameInviteWindow.visible = false;
      }
      
      private function statusChange(e:DropDownEvent) : void
      {
         var c:int = Buddy.codeFromStatus(e.selectedLabel);
         var s:SFSObject = new SFSObject();
         s.putInt("s",c);
         this.main.sfs.send(new ExtensionRequest("buddyStatus",s));
      }
      
      public function cleanUp() : void
      {
         this._buddyList.cleanUp();
      }
      
      private function leaderboardButton(evt:Event) : void
      {
      }
      
      private function profileButton(evt:Event) : void
      {
      }
      
      private function acceptTerms(evt:Event) : void
      {
         var s:SFSObject = new SFSObject();
         s.putInt("id",this.currentTerms);
         this.main.sfs.send(new ExtensionRequest("setTermsOfServiceRead",s));
         this.chatOverlay.termsScreen.visible = false;
      }
      
      private function rejectTerms(evt:Event) : void
      {
         this.main.sfs.send(new LogoutRequest());
      }
      
      override public function leave() : void
      {
         this.chatOverlay.musicToggle.removeEventListener(MouseEvent.CLICK,this.toggleMusic);
         this.chatOverlay.termsScreen.acceptButton.removeEventListener(MouseEvent.CLICK,this.acceptTerms);
         this.statusSelect.removeEventListener(DropDown.ITEM_SELECTED,this.statusChange);
         this.timer.removeEventListener(TimerEvent.TIMER,this.update);
         this.timer.stop();
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.chatOverlay.friendOnlineButton.removeEventListener(MouseEvent.CLICK,this.revealUserList);
         this.chatOverlay.chatBoxMc.minimizeButton.removeEventListener(MouseEvent.CLICK,this.revealUserList);
         this.chatOverlay.chatBoxMc.userAddBox.removeEventListener(Event.CHANGE,this.addUser);
         this.chatOverlay.chatBoxMc.userCodeBox.removeEventListener(Event.CHANGE,this.addUser);
         this.chatOverlay.chatBoxMc.addUserButton.removeEventListener(MouseEvent.CLICK,this.addUser);
         this.chatOverlay.chatBoxMc.userAddBox.removeEventListener(MouseEvent.CLICK,this.clearFieldOnClick);
         this.chatOverlay.chatBoxMc.userCodeBox.removeEventListener(MouseEvent.CLICK,this.clearFieldOnClick);
         this.queueTimer.removeEventListener(TimerEvent.TIMER,this.updateQueueTimer);
         this.chatOverlay.cancelButton.removeEventListener(MouseEvent.CLICK,this.cancelMatch);
         this.chatOverlay.logOff.removeEventListener(MouseEvent.CLICK,this.logout);
      }
      
      override public function enter() : void
      {
         this.timer.start();
         stage.frameRate = 30;
         this.statusSelect.addEventListener(DropDown.ITEM_SELECTED,this.statusChange);
         this.chatOverlay.chatOverlayHeader.mouseEnabled = false;
         this.chatOverlay.chatOverlayHeader.mouseChildren = false;
         this.chatOverlay.mouseEnabled = false;
         this.mouseEnabled = false;
         this.timer.addEventListener(TimerEvent.TIMER,this.update);
         this.chatOverlay.chatBoxMc.userAddBox.text = "Add User";
         this.chatOverlay.chatBoxMc.userCodeBox.text = "###";
         this.buddyList.updateScrollOnTabs();
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.chatOverlay.friendOnlineButton.addEventListener(MouseEvent.CLICK,this.revealUserList);
         this.chatOverlay.chatBoxMc.minimizeButton.addEventListener(MouseEvent.CLICK,this.revealUserList);
         this.chatOverlay.chatBoxMc.userAddBox.addEventListener(Event.CHANGE,this.addUser);
         this.chatOverlay.chatBoxMc.userCodeBox.addEventListener(Event.CHANGE,this.addUser);
         this.chatOverlay.chatBoxMc.addUserButton.addEventListener(MouseEvent.CLICK,this.addUser);
         this.chatOverlay.chatBoxMc.userAddBox.addEventListener(MouseEvent.CLICK,this.clearFieldOnClick);
         this.chatOverlay.chatBoxMc.userCodeBox.addEventListener(MouseEvent.CLICK,this.clearFieldOnClick);
         this.chatOverlay.termsScreen.acceptButton.addEventListener(MouseEvent.CLICK,this.acceptTerms);
         this.chatOverlay.lobbyButton.gotoAndStop(1);
         this.chatOverlay.armourButton.gotoAndStop(1);
         this.chatOverlay.leaderboardButton.gotoAndStop(1);
         this.chatOverlay.profileButton.gotoAndStop(1);
         this.chatOverlay.faqButton.gotoAndStop(1);
         this.queueTimer.addEventListener(TimerEvent.TIMER,this.updateQueueTimer);
         this.queueTimer.start();
         this.chatOverlay.friendOnlineButton.usernameText.text = this.main.sfs.mySelf.name;
         if(this.main.sfs.mySelf.containsVariable("code"))
         {
            this.chatOverlay.friendOnlineButton.codeText.text = this.main.sfs.mySelf.getVariable("code").getStringValue();
         }
         this.chatOverlay.cancelButton.addEventListener(MouseEvent.CLICK,this.cancelMatch);
         this.chatOverlay.logOff.addEventListener(MouseEvent.CLICK,this.logout);
         var data:SFSObject = new SFSObject();
         this.main.sfs.send(new ExtensionRequest("getPopulation",data));
         this.main.soundManager.playSoundInBackground("lobbyMusic");
         this.chatOverlay.musicToggle.addEventListener(MouseEvent.CLICK,this.toggleMusic);
      }
      
      public function setPopulation(p:int) : void
      {
         this.population = p;
      }
      
      private function logout(evt:Event) : void
      {
         this.main.sfs.send(new LogoutRequest());
      }
      
      private function cancelMatch(evt:Event) : void
      {
         var s:SFSObject = new SFSObject();
         this.main.sfs.send(new ExtensionRequest("cancelMatch",s));
         this.main.soundManager.playSoundFullVolume("CancelMatchmakingSound");
      }
      
      private function clearFieldOnClick(evt:Event) : void
      {
         var t:TextField = TextField(evt.target);
         t.text = "";
      }
      
      private function addUser(evt:Event) : void
      {
         var params:SFSObject = null;
         var txt:String = this.chatOverlay.chatBoxMc.userAddBox.text;
         var txtCode:String = this.chatOverlay.chatBoxMc.userCodeBox.text;
         var someoneHitEnter:Boolean = false;
         if(evt.target == this.chatOverlay.chatBoxMc.addUserButton)
         {
            someoneHitEnter = true;
         }
         if(txt.charCodeAt(txt.length - 1) == 13)
         {
            txt = txt.slice(0,txt.length - 1);
            someoneHitEnter = true;
         }
         if(txtCode.charCodeAt(txtCode.length - 1) == 13)
         {
            txtCode = txtCode.slice(0,txtCode.length - 1);
            someoneHitEnter = true;
         }
         if(someoneHitEnter)
         {
            trace("Try to add buddy: " + txt);
            params = new SFSObject();
            params.putUtfString("buddy",txt);
            params.putUtfString("code",txtCode);
            params.putInt("permission",0);
            this.main.sfs.send(new ExtensionRequest("buddyAdd",params));
            this.chatOverlay.chatBoxMc.userAddBox.text = "";
            this.chatOverlay.chatBoxMc.userCodeBox.text = "";
         }
      }
      
      private function revealUserList(evt:Event) : void
      {
         this.isUserListDisplayed = !this.isUserListDisplayed;
         if(this.isUserListDisplayed)
         {
            this.chatOverlay.chatBoxMc.visible = true;
         }
         else
         {
            this.chatOverlay.chatBoxMc.visible = false;
         }
      }
      
      private function mouseDown(evt:MouseEvent) : void
      {
         if(this.chatOverlay.lobbyButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.main.showScreen("lobby");
            this.main.soundManager.playSoundFullVolume("MenuTab");
         }
         if(this.chatOverlay.armourButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            if(evt.ctrlKey && this.main.sfs.mySelf.getVariable("isAdmin").getIntValue() == 1)
            {
               this.main.armourScreen.isEditMode = true;
            }
            else
            {
               this.main.armourScreen.isEditMode = false;
            }
            this.main.armourScreen.initUnitCards();
            if(this.main.xml.xml.hasArmory == 1)
            {
               this.main.showScreen("armoury");
               this.main.soundManager.playSoundFullVolume("MenuTab");
            }
         }
         if(this.chatOverlay.leaderboardButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.main.showScreen("leaderboard");
            this.main.soundManager.playSoundFullVolume("MenuTab");
         }
         if(this.chatOverlay.profileButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.main.showScreen("profile");
            this.main.soundManager.playSoundFullVolume("MenuTab");
            this.main.profileScreen.loadProfile(this.main.sfs.mySelf.name);
         }
         if(this.chatOverlay.faqButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.main.showScreen("faq");
            this.main.soundManager.playSoundFullVolume("MenuTab");
         }
      }
      
      private function toggleMusic(evt:Event) : void
      {
         this.main.soundManager.isMusic = !this.main.soundManager.isMusic;
         this.main.soundManager.isSound = this.main.soundManager.isMusic;
      }
      
      public function update(evt:Event) : void
      {
         var data:SFSObject = null;
         if(this.main.soundManager.isMusic)
         {
            this.chatOverlay.musicToggle.gotoAndStop(1);
         }
         else
         {
            this.chatOverlay.musicToggle.gotoAndStop(2);
         }
         this.chatOverlay.termsScreen.scrollPane.update();
         var todaysDate:Date = new Date();
         this.chatOverlay.timeText.text.text = todaysDate.hours + ":" + todaysDate.minutes;
         this.chatOverlay.lobbyButton.gotoAndStop(1);
         this.chatOverlay.armourButton.gotoAndStop(1);
         this.chatOverlay.leaderboardButton.gotoAndStop(1);
         this.chatOverlay.profileButton.gotoAndStop(1);
         this.chatOverlay.faqButton.gotoAndStop(1);
         var label:String = this.main.currentScreen();
         if(label == "lobby" || this.chatOverlay.lobbyButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.chatOverlay.lobbyButton.gotoAndStop(2);
         }
         if(label == "armoury" || this.chatOverlay.armourButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.chatOverlay.armourButton.gotoAndStop(2);
         }
         if(label == "leaderboard" || this.chatOverlay.leaderboardButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.chatOverlay.leaderboardButton.gotoAndStop(2);
         }
         if(label == "profile" || this.chatOverlay.profileButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.chatOverlay.profileButton.gotoAndStop(2);
         }
         if(label == "faq" || this.chatOverlay.faqButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.chatOverlay.faqButton.gotoAndStop(2);
         }
         ++this.frame;
         if(this.frame > 30 * 10)
         {
            data = new SFSObject();
            this.main.sfs.send(new ExtensionRequest("getPopulation",data));
            this.frame = 0;
         }
         this.addManager.update();
      }
      
      public function get buddyList() : BuddyList
      {
         return this._buddyList;
      }
      
      public function set buddyList(value:BuddyList) : void
      {
         this._buddyList = value;
      }
      
      public function get addManager() : AddManager
      {
         return this._addManager;
      }
      
      public function set addManager(value:AddManager) : void
      {
         this._addManager = value;
      }
   }
}
