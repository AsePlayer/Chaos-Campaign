package com.brockw.stickwar
{
   import com.brockw.game.ScreenManager;
   import com.brockw.game.XMLLoader;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.multiplayer.*;
   import com.brockw.stickwar.engine.replay.*;
   import com.brockw.stickwar.market.*;
   import com.brockw.stickwar.singleplayer.*;
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   
   [SWF(frameRate="30",width="550",height="590")]
   public class RegisterMain extends ScreenManager
   {
       
      
      protected var _sfs:SmartFox;
      
      private var _lobby:Room;
      
      private var signUpScreen:SignUpScreen;
      
      private var _mainIp:String;
      
      private var connectRetryTimer:Timer;
      
      public function RegisterMain()
      {
         super();
         var xmlLoader:XMLLoader = new XMLLoader();
         this._sfs = new SmartFox();
         this._sfs.debug = false;
         this.sfs.addEventListener(SFSEvent.CONNECTION,this.onConnection);
         this._sfs.addEventListener(SFSEvent.CONNECTION_LOST,this.onConnectionLost);
         this._sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
         this._sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
         addScreen("login",this.signUpScreen = new SignUpScreen(this));
         this.signUpScreen.signUpForm.playButton.addEventListener(MouseEvent.CLICK,this.playButton);
         showScreen("login");
         this.sfs.useBlueBox = true;
         this.mainIp = xmlLoader.xml.mainServer;
         this._sfs.connect(this.mainIp,9933);
         this.sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.extensionResponse);
         this.connectRetryTimer = new Timer(5000);
         this.connectRetryTimer.addEventListener(TimerEvent.TIMER,this.connectRetry);
         trace("Register MAIN STUFF");
      }
      
      private function playButton(evt:Event) : void
      {
         var url:URLRequest = new URLRequest("http://www.stickempires.com");
         navigateToURL(url,"_self");
      }
      
      private function onConnection(evt:SFSEvent) : void
      {
         if(Boolean(evt.params.success))
         {
            trace("Connection Success!");
            this.connectRetryTimer.stop();
            this.sfs.send(new LoginRequest("register" + Math.random(),"","StickEmpiresRegister"));
         }
         else
         {
            trace("Connection Failure: " + evt.params.errorMessage);
            this.connectRetryTimer.start();
         }
      }
      
      private function onConnectionLost(evt:SFSEvent) : void
      {
         if(this.currentScreen() == "singleplayerGame" || this.currentScreen() == "replayGame")
         {
         }
         trace("Connection was lost. Reason: " + evt.params.reason);
         trace("Try to reconnect...");
         this.connectRetryTimer.start();
      }
      
      private function connectRetry(evt:Event) : void
      {
         trace("try to connect");
         this._sfs.connect(this.mainIp,9933);
      }
      
      public function extensionResponse(evt:SFSEvent) : void
      {
         var extParams:SFSObject = evt.params.params;
         switch(evt.params.cmd)
         {
            case "checkAvailability":
               trace("Received availability data");
               trace(extParams.getUtfString("username")," - ",extParams.getBool("available"));
               this.signUpScreen.signUpForm.usernameAvailable(extParams.getUtfString("username"),extParams.getBool("available"));
               break;
            case "registerUser":
               trace("Register user response: ",extParams.getBool("success"));
               this.signUpScreen.signUpForm.registerResponse(extParams.getBool("success"),extParams.getBool("usernameUnique"),extParams.getBool("emailUnique"),extParams.getBool("emailValid"));
         }
      }
      
      private function onConfigLoadSuccess(evt:SFSEvent) : void
      {
         trace("Config load success!");
         trace("Server settings: " + this._sfs.config.host + ":" + this._sfs.config.port);
      }
      
      private function onConfigLoadFailure(evt:SFSEvent) : void
      {
         trace("Config load failure!!!");
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
   }
}
