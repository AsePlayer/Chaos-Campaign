package com.brockw.stickwar.engine
{
     import com.brockw.game.Util;
     import com.brockw.stickwar.engine.Team.Team;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.*;
     
     public class Hill extends Entity
     {
          
          private static const scale:Number = 1;
          
          private static const statueArea:Number = 300;
           
          
          private var teamBar:Number;
          
          private var lastTeamBar:Number;
          
          private var hillMc:_hillMc;
          
          private var hillControlBar:com.brockw.stickwar.engine.HillControlBar;
          
          private var teamAThisTurn:int;
          
          private var teamBThisTurn:int;
          
          private var collectionFrequency:int;
          
          private var collectionRate:int;
          
          private var hillCaptureTime:int;
          
          public function Hill(game:StickWar)
          {
               super();
               this.addChild(this.hillMc = new _hillMc());
               this.hillControlBar = new com.brockw.stickwar.engine.HillControlBar();
               addChild(this.hillControlBar);
               this.lastTeamBar = this.teamBar = 50;
               this.collectionRate = game.xml.xml.hill.goldCollectionRate;
               this.collectionFrequency = game.xml.xml.hill.frequency;
               this.hillCaptureTime = game.xml.xml.towerCaptureTime;
               this.hillMc.stop();
          }
          
          public function init(x:int, y:int, game:StickWar) : void
          {
               this.x = x;
               this.y = y;
               this.px = x;
               this.py = y;
               var mapHeight:Number = Number(game.xml.xml.battlefieldHeight);
               this.hillMc.scaleX = scale * (game.backScale + y / mapHeight * (game.frontScale - game.backScale));
               this.hillMc.scaleY = scale * (game.backScale + y / mapHeight * (game.frontScale - game.backScale));
               this.hillControlBar.y = -this.hillMc.height * 1.1;
               this.hillControlBar.scaleX *= 2;
               this.hillControlBar.scaleY *= 2;
          }
          
          public function registerUnit(unit:Unit) : void
          {
               unit.team.register = 1;
          }
          
          public function getControllingTeam(game:StickWar) : Team
          {
               if(this.teamBar == 0)
               {
                    return game.teamA;
               }
               if(this.teamBar == 100)
               {
                    return game.teamB;
               }
               return null;
          }
          
          public function update(game:StickWar) : void
          {
               var rate:Number = NaN;
               var scale:Number = NaN;
               game.teamA.register = game.teamB.register = 0;
               game.spatialHash.mapInArea(px - statueArea / 2,py - statueArea / 2,px + statueArea / 2,py + statueArea / 2,this.registerUnit,false);
               if((game.teamA.register == 1 || game.teamB.register == 1) && game.teamA.register + game.teamB.register != 2)
               {
                    rate = 50 / this.hillCaptureTime;
                    if(game.teamA.register != 0)
                    {
                         rate *= -1;
                    }
                    this.teamBar += rate;
                    if(this.teamBar < 0)
                    {
                         this.teamBar = 0;
                    }
                    if(this.teamBar > 100)
                    {
                         this.teamBar = 100;
                    }
               }
               if(this.teamBar == 50)
               {
                    this.hillMc.flame.visible = false;
               }
               else if(this.teamBar < 50 && game.team == game.teamA || this.teamBar > 50 && game.team == game.teamB)
               {
                    this.hillMc.flame.transform.colorTransform.redOffset = 0;
                    scale = this.teamBar;
                    if(scale > 50)
                    {
                         scale = 100 - scale;
                    }
                    this.hillMc.flame.alpha = (50 - scale) / 50;
                    this.hillMc.flame.visible = true;
               }
               else
               {
                    scale = this.teamBar;
                    if(scale > 50)
                    {
                         scale = 100 - scale;
                    }
                    this.hillMc.flame.alpha = (50 - scale) / 50;
                    this.hillMc.flame.transform.colorTransform.redOffset = 255;
                    this.hillMc.flame.visible = true;
               }
               Util.animateMovieClip(this.hillMc);
               if(game.frame % this.collectionFrequency == 0)
               {
                    if(this.teamBar == 0)
                    {
                         game.teamA.gold += this.collectionRate;
                         if(game.team == game.teamA)
                         {
                              game.incomeDisplay.addDisplay(game,"+ " + this.collectionRate,65280,this.x,this.y - this.height - 10);
                         }
                    }
                    else if(this.teamBar == 100)
                    {
                         game.teamB.gold += this.collectionRate;
                         if(game.team == game.teamB)
                         {
                              game.incomeDisplay.addDisplay(game,"+ " + this.collectionRate,65280,this.x,this.y - this.height - 10);
                         }
                    }
               }
               if(this.teamBar == 0 || this.teamBar == 50 || this.teamBar == 100)
               {
                    this.hillControlBar.visible = false;
                    if(this.lastTeamBar != 0 && this.teamBar == 0)
                    {
                         if(game.teamA == game.team)
                         {
                              game.soundManager.playSoundFullVolume("SelectRaceSound");
                         }
                    }
                    else if(this.lastTeamBar != 100 && this.teamBar == 100)
                    {
                         if(game.teamB == game.team)
                         {
                              game.soundManager.playSoundFullVolume("SelectRaceSound");
                         }
                    }
               }
               else
               {
                    this.hillControlBar.visible = true;
               }
               this.hillControlBar.update((this.teamBar - 50) / 100,16711680);
               this.lastTeamBar = this.teamBar;
          }
     }
}
