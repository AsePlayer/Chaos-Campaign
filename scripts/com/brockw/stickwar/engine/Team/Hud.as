package com.brockw.stickwar.engine.Team
{
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.*;
   import flash.events.*;
   
   public class Hud extends MovieClip
   {
       
      
      public var hud:MovieClip;
      
      public function Hud(h:MovieClip)
      {
         super();
         this.hud = h;
         addChild(this.hud);
         this.hud.tabChildren = false;
         this.hud.tabEnabled = false;
         this.hud.garrisonButton.tabEnabled = false;
         this.hud.defendButton.tabEnabled = false;
         this.hud.attackButton.tabEnabled = false;
      }
      
      public function mapClear() : void
      {
         MovieClip(this.hud.map).graphics.clear();
      }
      
      public function mapDrawFocus(game:StickWar) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var u:String = null;
         var w:Number = NaN;
         var sx:Number = NaN;
         var width:Number = MovieClip(this.hud.map).width;
         var height:Number = MovieClip(this.hud.map).height;
         for(u in game.units)
         {
            if(Boolean(game.units[u].onMap(game)))
            {
               game.units[u].drawOnHud(this.hud.map,game);
            }
         }
         MovieClip(this.hud.map).graphics.lineStyle(0.5,0,1);
         MovieClip(this.hud.map).graphics.drawRect(width * game.screenX / game.map.width,0,width * game.map.screenWidth / game.map.width,height);
         if(game.fogOfWar.isFogOn)
         {
            w = width * game.team.getVisionRange() / game.map.width;
            sx = 0;
            if(game.team == game.teamA)
            {
               sx = w;
               w = width - w;
            }
            MovieClip(this.hud.map).graphics.beginFill(0,0.8);
            MovieClip(this.hud.map).graphics.drawRect(sx,0,w,height);
         }
      }
      
      public function update(game:StickWar, team:Team) : void
      {
         this.mapClear();
         this.mapDrawFocus(game);
         var seconds:int = Math.floor(game.frame / 30);
         var minutes:int = Math.floor(seconds / 60);
         seconds %= 60;
         if(minutes < 10)
         {
            this.hud.clockMinutes.text = "0 " + minutes;
         }
         else
         {
            this.hud.clockMinutes.text = Math.floor(minutes / 10) + " " + minutes % 10;
         }
         if(seconds < 10)
         {
            this.hud.clockSeconds.text = "0 " + seconds;
         }
         else
         {
            this.hud.clockSeconds.text = Math.floor(seconds / 10) + " " + seconds % 10;
         }
         if(game.isReplay == false)
         {
            this.hud.replayHud.visible = false;
            if(game.gameScreen.userInterface.keyBoardState.isDown(79) && !game.gameScreen.userInterface.keyBoardState.isDisabled)
            {
               this.hud.fps.text = "FPS: " + Math.floor(game.gameScreen.simulation.fps);
               this.hud.ping.text = "Ping: " + int(game.gameScreen.simulation.ping);
               this.hud.turnSize.text = "Turn Size: " + game.gameScreen.simulation.turnSize;
               this.hud.fps.visible = true;
               this.hud.ping.visible = true;
               this.hud.turnSize.visible = true;
            }
            else
            {
               this.hud.fps.visible = false;
               this.hud.ping.visible = false;
               this.hud.turnSize.visible = false;
            }
            this.hud.economicDisplay.visible = true;
            this.hud.economicDisplay.population.text = "" + Math.floor(team.population);
            this.hud.economicDisplay.gold.text = "" + Math.floor(team.gold);
            this.hud.economicDisplay.mana.text = "" + Math.floor(team.mana);
         }
         else
         {
            this.hud.replayHud.visible = true;
            this.hud.economicDisplay.visible = false;
            this.hud.fps.visible = false;
            this.hud.ping.visible = false;
            this.hud.turnSize.visible = false;
            this.hud.replayHud.economicDisplay.population.text = "" + Math.floor(game.teamB.population);
            this.hud.replayHud.economicDisplay.gold.text = "" + Math.floor(game.teamB.gold);
            this.hud.replayHud.economicDisplay.mana.text = "" + Math.floor(game.teamB.mana);
            this.hud.replayHud.economicDisplay2.visible = true;
            this.hud.replayHud.economicDisplay2.population.text = "" + Math.floor(game.teamA.population);
            this.hud.replayHud.economicDisplay2.gold.text = "" + Math.floor(game.teamA.gold);
            this.hud.replayHud.economicDisplay2.mana.text = "" + Math.floor(game.teamA.mana);
            this.hud.replayHud.player1Name.text.text = game.teamB.realName;
            this.hud.replayHud.player2Name.text.text = game.teamA.realName;
         }
      }
   }
}
