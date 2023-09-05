package com.brockw.stickwar.engine.multiplayer
{
     import com.brockw.game.Screen;
     import com.brockw.stickwar.BaseMain;
     import com.smartfoxserver.v2.core.SFSEvent;
     
     public class ConnectionScreen extends Screen
     {
           
          
          private var main:BaseMain;
          
          public var txtWelcome:GenericText;
          
          public function ConnectionScreen(main:BaseMain)
          {
               super();
               this.main = main;
               this.txtWelcome = new GenericText();
               this.txtWelcome.text.text = "Connecting!";
               this.txtWelcome.width *= 2;
               this.txtWelcome.height *= 2;
               this.txtWelcome.x = main.stage.stageWidth / 2 - this.txtWelcome.width / 2;
               this.txtWelcome.y = main.stage.stageHeight / 2 - this.txtWelcome.height / 2 - 200;
               addChild(this.txtWelcome);
          }
          
          override public function enter() : void
          {
               this.main.sfs.addEventListener(SFSEvent.CONNECTION,this.onConnection);
          }
          
          override public function leave() : void
          {
               this.main.sfs.removeEventListener(SFSEvent.CONNECTION,this.onConnection);
          }
          
          private function onConfigLoadSuccess(evt:SFSEvent) : void
          {
               trace("Config load success!");
               trace("Server settings: " + this.main.sfs.config.host + ":" + this.main.sfs.config.port);
               this.txtWelcome.text.text = "Config load success!";
          }
          
          private function onConfigLoadFailure(evt:SFSEvent) : void
          {
               trace("Config load failure!!!");
               this.txtWelcome.text.text = "Config load failure!!!";
          }
          
          private function onConnection(evt:SFSEvent) : void
          {
               if(Boolean(evt.params.success))
               {
                    trace("Connection Success!");
                    this.main.showScreen("login");
               }
               else
               {
                    this.main.showScreen("singleplayerGame");
                    trace("Connection Failure: " + evt.params.errorMessage);
               }
          }
     }
}
