package com.brockw.stickwar.engine.replay
{
   import com.brockw.game.Screen;
   import com.brockw.simulationSync.SimulationSyncronizer;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.StickWar;
   import com.smartfoxserver.v2.requests.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.*;
   
   public class ReplayLoaderScreen extends Screen
   {
       
      
      private var main:Main;
      
      public var mc:replayLoaderMc;
      
      internal var txtReplayInput:GenericTextInput;
      
      public function ReplayLoaderScreen(main:Main)
      {
         super();
         this.main = main;
         this.mc = new replayLoaderMc();
         addChild(this.mc);
      }
      
      override public function enter() : void
      {
         this.main.setOverlayScreen("chatOverlay");
         this.mc.viewReplay.addEventListener(MouseEvent.CLICK,this.startReplay);
         this.mc.broken.visible = false;
         this.mc.broken.continueButton.addEventListener(MouseEvent.CLICK,this.continueButton);
      }
      
      private function continueButton(e:Event) : void
      {
         this.mc.broken.visible = false;
      }
      
      private function startReplay(ext:Event) : void
      {
         if(!this.main.stickWar)
         {
            this.main.stickWar = new StickWar(this.main,this.main.replayGameScreen);
         }
         var simulation:SimulationSyncronizer = new SimulationSyncronizer(this.main.stickWar,this.main,null,null);
         var isWellFormed:Boolean = simulation.gameReplay.fromString(this.mc.replayText.text.text);
         if(isWellFormed)
         {
            this.main.replayGameScreen.replayString = this.mc.replayText.text.text;
            this.main.showScreen("replayGame");
         }
         else
         {
            this.mc.broken.visible = true;
         }
      }
      
      override public function leave() : void
      {
         this.mc.viewReplay.removeEventListener(MouseEvent.CLICK,this.startReplay);
         this.mc.broken.continueButton.removeEventListener(MouseEvent.CLICK,this.continueButton);
      }
   }
}
