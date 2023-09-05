package com.brockw.stickwar.campaign.controllers
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.campaign.InGameMessage;
     import com.brockw.stickwar.engine.units.Knight;
     import com.brockw.stickwar.engine.units.Medusa;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     
     public class CampaignDeads extends CampaignController
     {
           
          
          private var mcD:MovieClip;
          
          private var spellBook:String = "Spellbook";
          
          private var message:InGameMessage;
          
          private var frames:int;
          
          private var queenMedusa:Medusa;
          
          private var medusaQueened:Boolean = false;
          
          private var knight:Knight;
          
          private var bruh:int = 0;
          
          private var bruh2:int = 0;
          
          public function CampaignDeads(gameScreen:GameScreen)
          {
               super(gameScreen);
          }
          
          override public function update(gameScreen:GameScreen) : void
          {
               var u:Unit = null;
               ++this.bruh;
               if(!this.medusaQueened)
               {
                    this.queenMedusa = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
                    gameScreen.team.spawn(this.queenMedusa,gameScreen.game);
                    this.queenMedusa.px = gameScreen.team.enemyTeam.statue.px - 1200;
                    gameScreen.team.population += 10;
                    this.medusaQueened = true;
               }
               if(this.bruh % 60 == 0)
               {
                    this.knight = Knight(gameScreen.game.unitFactory.getUnit(Unit.U_KNIGHT));
                    gameScreen.team.enemyTeam.spawn(this.knight,gameScreen.game);
                    ++this.bruh2;
                    if(this.bruh2 % 3 == 0)
                    {
                         this.knight.shield = "Riot Shield";
                    }
                    else if(this.bruh2 % 3 == 1)
                    {
                         this.knight.shield = "Skull Shield";
                    }
                    else
                    {
                         this.knight.shield = "";
                    }
               }
               for each(u in gameScreen.team.enemyTeam.units)
               {
                    if(u.px < gameScreen.team.enemyTeam.statue.px - 600)
                    {
                         u.damage(0,999,null);
                    }
               }
               gameScreen.team.enemyTeam.attack(true);
          }
     }
}
