package com.brockw.stickwar.engine.multiplayer
{
   import AS.encryption.MD5;
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.JoinRoomRequest;
   import com.smartfoxserver.v2.requests.LoginRequest;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class LoginScreen extends Screen
   {
       
      
      private var main:Main;
      
      private var inputText:GenericTextInput;
      
      var btnConnect:GenericButton;
      
      var btnSingleplayer:GenericButton;
      
      var btnReplay:GenericButton;
      
      var loginMc:loginMenuMc;
      
      public var forgotPasswordForm:ForgotPasswordForm;
      
      private var justFailed:Boolean;
      
      private var _isConnecting:Boolean;
      
      public function LoginScreen(main:Main)
      {
         super();
         this.main = main;
         this.loginMc = new loginMenuMc();
         addChild(this.loginMc);
         this.forgotPasswordForm = new ForgotPasswordForm(main);
         this.addChild(this.forgotPasswordForm);
         this.forgotPasswordForm.visible = false;
         this.loginMc.versionText.text = main.version;
      }
      
      private function toggleMusic(evt:Event) : void
      {
         this.main.soundManager.isMusic = !this.main.soundManager.isMusic;
         this.main.soundManager.isSound = this.main.soundManager.isMusic;
      }
      
      private function update(evt:Event) : void
      {
         if(this.loginMc.connectingMc.currentFrame == this.loginMc.connectingMc.totalFrames)
         {
            this.loginMc.connectingMc.stop();
         }
         if(this.main.soundManager.isMusic)
         {
            this.loginMc.musicToggle.gotoAndStop(1);
         }
         else
         {
            this.loginMc.musicToggle.gotoAndStop(2);
         }
      }
      
      override public function enter() : void
      {
         this.loginMc.musicToggle.buttonMode = true;
         this.loginMc.musicToggle.addEventListener(MouseEvent.CLICK,this.toggleMusic);
         this.main.sfs.addEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
         this.main.sfs.addEventListener(SFSEvent.LOGIN,this.SFSLogin);
         this.main.sfs.addEventListener(SFSEvent.ROOM_JOIN,this.SFSRoomJoin);
         this.main.sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
         this.loginMc.loginBox.usernameInput.text.addEventListener(Event.CHANGE,this.loginUserEnterButton);
         this.loginMc.loginBox.passwordInput.text.addEventListener(Event.CHANGE,this.loginUserEnterButton);
         this.loginMc.signIn.addEventListener(MouseEvent.CLICK,this.btnConnectLogin);
         this.loginMc.loginBox.usernameInput.text.text = "";
         this.loginMc.loginBox.passwordInput.text.text = "";
         stage.frameRate = 30;
         this.loginMc.loginBox.passwordInput.text.displayAsPassword = true;
         this.loginMc.failBox.tryAgain.addEventListener(MouseEvent.CLICK,this.tryAgain);
         this.justFailed = false;
         this.addEventListener(Event.ENTER_FRAME,this.update);
         this.loginMc.failBox.visible = false;
         this.loginMc.loginBox.visible = true;
         this.loginMc.connectingMc.visible = false;
         this.loginMc.loginBox.forgotPasswordButton.addEventListener(MouseEvent.CLICK,this.openForgotPassword);
         this.loginMc.loginBox.usernameInput.addEventListener(MouseEvent.CLICK,this.inputClick);
         this.loginMc.register.addEventListener(MouseEvent.CLICK,this.btnSingleplayerClick);
         this.loginMc.guest.addEventListener(MouseEvent.CLICK,this.btnReplayClick);
         this.main.soundManager.playSoundInBackground("loginMusic");
      }
      
      private function openForgotPassword(evt:Event) : void
      {
         this.forgotPasswordForm.enter();
      }
      
      private function tryAgain(evt:Event) : void
      {
         this.loginMc.failBox.visible = false;
         this.loginMc.loginBox.visible = true;
         this.justFailed = false;
      }
      
      override public function leave() : void
      {
         this.main.sfs.removeEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
         this.main.sfs.removeEventListener(SFSEvent.LOGIN,this.SFSLogin);
         this.main.sfs.removeEventListener(SFSEvent.ROOM_JOIN,this.SFSRoomJoin);
         this.main.sfs.removeEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
         this.loginMc.musicToggle.removeEventListener(MouseEvent.CLICK,this.toggleMusic);
         this.loginMc.loginBox.usernameInput.text.removeEventListener(Event.CHANGE,this.loginUserEnterButton);
         this.loginMc.loginBox.passwordInput.text.removeEventListener(Event.CHANGE,this.loginUserEnterButton);
         this.loginMc.failBox.tryAgain.addEventListener(MouseEvent.CLICK,this.tryAgain);
         this.removeEventListener(Event.ENTER_FRAME,this.update);
         this.loginMc.signIn.removeEventListener(MouseEvent.CLICK,this.btnConnectLogin);
         this.loginMc.loginBox.forgotPasswordButton.removeEventListener(MouseEvent.CLICK,this.openForgotPassword);
         this.loginMc.loginBox.usernameInput.removeEventListener(MouseEvent.CLICK,this.inputClick);
         this.loginMc.register.removeEventListener(MouseEvent.CLICK,this.btnSingleplayerClick);
         this.loginMc.guest.removeEventListener(MouseEvent.CLICK,this.btnReplayClick);
      }
      
      public function inputClick(evt:MouseEvent) : void
      {
         this.loginMc.loginBox.usernameInput.text.text = "";
      }
      
      public function btnSingleplayerClick(evt:MouseEvent) : void
      {
         var url:URLRequest = null;
         if(evt.ctrlKey)
         {
            this.main.showScreen("singleplayerGame");
         }
         else
         {
            url = new URLRequest("http://www.stickempires.com/index.php");
            navigateToURL(url,"_blank");
         }
      }
      
      public function btnReplayClick(evt:MouseEvent) : void
      {
         if(evt.ctrlKey)
         {
            this.main.showScreen("campaignMap");
         }
      }
      
      public function btnConnectLogin(evt:MouseEvent) : void
      {
         var params:SFSObject = new SFSObject();
         var enc:String = MD5.hash(this.loginMc.loginBox.passwordInput.text.text);
         this.main.passwordEncrypted = enc;
         params.putUtfString("password",enc);
         params.putUtfString("version",this.main.version);
         this.main.sfs.send(new LoginRequest(this.loginMc.loginBox.usernameInput.text.text,this.loginMc.loginBox.passwordInput.text.text,"stickwar",params));
         this.loginMc.loginBox.usernameInput.buttonMode = false;
      }
      
      public function SFSLoginError(evt:SFSEvent) : void
      {
         trace("Can not login: ",evt.params.errorMessage,evt.params.errorCode);
         if(evt.params.errorCode == 8)
         {
            this.main.showScreen("versionMismatch");
         }
         if(evt.params.errorCode == 7)
         {
            this.loginMc.failBox.loginError.text = "Server is full";
         }
         else if(evt.params.errorCode == 10)
         {
            this.loginMc.failBox.loginError.text = "Please check your email to complete the signup process";
         }
         else
         {
            this.loginMc.failBox.loginError.text = "Error logging in";
         }
         this.loginMc.loginBox.usernameInput.buttonMode = true;
         this.justFailed = true;
         this.loginMc.loginBox.visible = false;
         this.loginMc.failBox.visible = true;
      }
      
      public function SFSLogin(evt:SFSEvent) : void
      {
         trace("Logged into: " + this.main.sfs.currentZone);
         if(this.main.sfs.currentZone == "stickwar")
         {
            this.loginMc.loginBox.usernameInput.text.text = "Joining Main Lobby...";
            this.main.sfs.send(new JoinRoomRequest("Lobby"));
            this.main.soundManager.playSoundFullVolume("LoginSound");
         }
      }
      
      private function loginUserEnterButton(evt:Event) : void
      {
         var txt:String = evt.target.text;
         if(txt.charCodeAt(txt.length - 1) == 13)
         {
            txt = txt.slice(0,txt.length - 1);
            evt.target.text = txt;
            if(evt.target == this.loginMc.loginBox.usernameInput.text)
            {
               stage.focus = this.loginMc.loginBox.passwordInput.text;
            }
            else
            {
               this.btnConnectLogin(null);
            }
         }
      }
      
      public function SFSRoomJoin(evt:SFSEvent) : void
      {
         if(evt.params.room.name == "Lobby")
         {
            this.main.lobby = evt.params.room;
            this.main.showScreen("lobby");
         }
         else
         {
            this.SFSRoomJoinError(evt);
         }
      }
      
      public function SFSRoomJoinError(evt:SFSEvent) : void
      {
         trace("Can not join Lobby");
         this.btnConnect.text.text = "Login";
         this.btnConnect.buttonMode = true;
      }
      
      public function get isConnecting() : Boolean
      {
         return this._isConnecting;
      }
      
      public function set isConnecting(value:Boolean) : void
      {
         if(value)
         {
            this.loginMc.failBox.visible = false;
            this.loginMc.loginBox.visible = false;
            this.loginMc.connectingMc.visible = true;
            this.loginMc.connectingMc.gotoAndPlay(1);
         }
         else
         {
            if(!this.justFailed)
            {
               this.loginMc.failBox.visible = false;
               this.loginMc.loginBox.visible = true;
            }
            else
            {
               this.loginMc.failBox.visible = true;
               this.loginMc.loginBox.visible = false;
            }
            this.loginMc.connectingMc.visible = false;
         }
         this._isConnecting = value;
      }
   }
}
