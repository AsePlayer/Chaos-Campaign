package com.brockw.stickwar.campaign.controllers
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.campaign.InGameMessage;
     
     public class CampaignKnight extends CampaignController
     {
           
          
          private var message:InGameMessage;
          
          private var frames:int;
          
          public function CampaignKnight(gameScreen:GameScreen)
          {
               super(gameScreen);
          }
          
          override public function update(gameScreen:GameScreen) : void
          {
               if(Boolean(this.message) && gameScreen.contains(this.message))
               {
                    this.message.update();
                    if(this.frames++ > 30 * 5)
                    {
                         gameScreen.removeChild(this.message);
                    }
               }
               else if(!this.message)
               {
                    if(Boolean(gameScreen.team.forwardUnit) && gameScreen.team.forwardUnit.px > gameScreen.game.map.width / 2)
                    {
                         this.message = new InGameMessage("",gameScreen.game);
                         this.message.x = gameScreen.game.stage.stageWidth / 2;
                         this.message.y = gameScreen.game.stage.stageHeight / 4 - 75;
                         this.message.scaleX *= 1.3;
                         this.message.scaleY *= 1.3;
                         gameScreen.addChild(this.message);
                         this.message.setMessage("Press SPACE to select all of your attacking units","");
                         this.frames = 0;
                    }
               }
          }
     }
}
