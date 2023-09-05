package com.brockw.stickwar.engine.multiplayer
{
     import com.brockw.game.Screen;
     import com.brockw.stickwar.Main;
     import com.brockw.stickwar.engine.Team.Team;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     import com.smartfoxserver.v2.requests.ExtensionRequest;
     import flash.events.Event;
     import flash.events.MouseEvent;
     
     public class RaceSelectionScreen extends Screen
     {
           
          
          private var main:Main;
          
          private var mouseIsIn:int;
          
          private var mc:lobbyScreenMc;
          
          public function RaceSelectionScreen(main:Main)
          {
               super();
               this.main = main;
               addChild(this.mc = new lobbyScreenMc());
               this.mc.orderButton.stop();
               this.mc.chaosButton.stop();
               this.mc.randomButton.stop();
               this.mouseIsIn = 0;
          }
          
          private function mouseDown(evt:Event) : void
          {
               var d:Number = Math.sqrt(Math.pow(this.mc.orderButton.mouseX,2) + Math.pow(this.mc.orderButton.mouseY + 100,2));
               if(d < 150)
               {
                    this.main.raceSelected = Team.T_GOOD;
                    this.raceChange();
               }
               d = Math.sqrt(Math.pow(this.mc.chaosButton.mouseX,2) + Math.pow(this.mc.chaosButton.mouseY + 100,2));
               if(d < 150)
               {
                    this.main.raceSelected = Team.T_CHAOS;
                    this.raceChange();
               }
               d = Math.sqrt(Math.pow(this.mc.randomButton.mouseX,2) + Math.pow(this.mc.randomButton.mouseY,2));
               if(d < 75)
               {
                    this.main.raceSelected = Team.T_RANDOM;
                    this.raceChange();
               }
               this.update(evt);
          }
          
          private function update(evt:Event) : void
          {
               if(this.main.raceSelected == Team.T_GOOD)
               {
                    this.mc.orderButton.gotoAndStop(3);
               }
               else if(Math.sqrt(Math.pow(this.mc.orderButton.mouseX,2) + Math.pow(this.mc.orderButton.mouseY + 100,2)) < 150)
               {
                    this.mc.orderButton.gotoAndStop(2);
               }
               else
               {
                    this.mc.orderButton.gotoAndStop(1);
               }
               if(this.main.raceSelected == Team.T_CHAOS)
               {
                    this.mc.chaosButton.gotoAndStop(3);
               }
               else if(Math.sqrt(Math.pow(this.mc.chaosButton.mouseX,2) + Math.pow(this.mc.chaosButton.mouseY + 100,2)) < 150)
               {
                    this.mc.chaosButton.gotoAndStop(2);
               }
               else
               {
                    this.mc.chaosButton.gotoAndStop(1);
               }
               if(this.main.raceSelected == Team.T_RANDOM)
               {
                    this.mc.randomButton.gotoAndStop(3);
               }
               else if(this.mc.randomButton.hitTestPoint(stage.mouseX,stage.mouseY))
               {
                    this.mc.randomButton.gotoAndStop(2);
               }
               else
               {
                    this.mc.randomButton.gotoAndStop(1);
               }
          }
          
          private function raceChange() : void
          {
               var id:int = this.main.raceSelected;
               var params:SFSObject = new SFSObject();
               params.putInt("race",id);
               this.main.sfs.send(new ExtensionRequest("changeRace",params));
          }
          
          public function leaveQueueCount() : void
          {
          }
          
          override public function enter() : void
          {
               this.main.setOverlayScreen("");
               this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
               this.addEventListener(Event.ENTER_FRAME,this.update);
               stage.frameRate = 30;
          }
          
          override public function leave() : void
          {
               this.removeEventListener(MouseEvent.CLICK,this.mouseDown);
               this.removeEventListener(Event.ENTER_FRAME,this.update);
          }
     }
}
