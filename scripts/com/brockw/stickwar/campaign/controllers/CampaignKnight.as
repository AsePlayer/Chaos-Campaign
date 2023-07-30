package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.campaign.InGameMessage;
   import com.brockw.stickwar.engine.units.FlyingCrossbowman;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Ninja;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class CampaignKnight extends CampaignController
   {
       
      
      private var message:InGameMessage;
      
      private var frames:int;
      
      private var currentLevelTitle:String;
      
      private var medusaOneLiner:String;
      
      private var medusaQueened:Boolean;
      
      private var difficulty:int;
      
      private var queenMedusa:Medusa;
      
      private var sneakyNinjas:int;
      
      private var explodingAlbows:int;
      
      private var levelSetupComplete:Boolean;
      
      private var openingMessageSent:Boolean;
      
      private var messageOpening:InGameMessage;
      
      private var gameOver:Boolean;
      
      private var timeUntilEnd:int;
      
      private var timeUntilNextAlbow:int;
      
      private var sneakyNinjaWarning:Boolean;
      
      private var poisonCheck:Boolean = false;
      
      private var tpSpawnOffset:int;
      
      private var tpWallOffset:int;
      
      private var tpBackWallOffset:int;
      
      private var sceneCounter:int;
      
      internal var albowUnit:FlyingCrossbowman;
      
      internal var ninjaUnit:Ninja;
      
      public function CampaignKnight(gameScreen:GameScreen)
      {
         super(gameScreen);
         this.currentLevelTitle = gameScreen.main.campaign.getCurrentLevel().title;
         var randomNumber:int = Math.floor(Math.random() * 7) + 1;
         switch(randomNumber)
         {
            case 1:
               this.medusaOneLiner = "voiceTutorial1";
               break;
            case 2:
               this.medusaOneLiner = "voiceTutorial2";
               break;
            case 3:
               this.medusaOneLiner = "voiceTutorial3";
               break;
            case 4:
               this.medusaOneLiner = "voiceTutorial4";
               break;
            case 5:
               this.medusaOneLiner = "voiceTutorial5";
               break;
            case 6:
               this.medusaOneLiner = "voiceTutorial6";
               break;
            case 7:
               this.medusaOneLiner = "voiceTutorial7";
               break;
            default:
               this.medusaOneLiner = "voiceTutorial5";
         }
      }
      
      override public function update(gameScreen:GameScreen) : void
      {
         var u:Unit = null;
         if(!this.medusaQueened)
         {
            this.queenMedusa = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
            gameScreen.team.spawn(this.queenMedusa,gameScreen.game);
            this.queenMedusa.px = 420 * 2;
            this.queenMedusa.medusaTrueQueen = true;
            gameScreen.team.population += 10;
            this.medusaQueened = true;
            this.difficulty = gameScreen.team.game.main.campaign.difficultyLevel;
         }
         if(!this.openingMessageSent)
         {
            this.messageOpening = new InGameMessage("",gameScreen.game);
            this.messageOpening.x = gameScreen.game.stage.stageWidth / 2;
            this.messageOpening.y = gameScreen.game.stage.stageHeight / 4 - 75;
            this.messageOpening.scaleX *= 1.3;
            this.messageOpening.scaleY *= 1.3;
            gameScreen.addChild(this.messageOpening);
            if(this.currentLevelTitle == "Scouting Party: Unexpected Guests")
            {
               this.messageOpening.setMessage("Queen Medusa: No tolerance for espionage... their fate is sealed.","",0,this.medusaOneLiner);
            }
            else if(this.currentLevelTitle == "Scouting Party: Unexpected Guests2")
            {
               this.messageOpening.setMessage("Queen Medusa: I shall grace the local towns with my presence... let\'s give them something to write home about!","",0,this.medusaOneLiner);
            }
            else if(this.difficulty == 1)
            {
               this.messageOpening.setMessage("That\'s all the levels for now! Replay on HARD Mode for a tougher challenge.","",0,"Pain14");
            }
            else if(this.difficulty == 2)
            {
               this.messageOpening.setMessage("That\'s all the levels for now! Replay on INSANE Mode for the toughest challenge.","",0,"Pain14");
            }
            else if(this.difficulty == 3)
            {
               this.messageOpening.setMessage("That\'s all the levels for now! Congrats on beating INSANE Mode!","",0,"Pain14");
            }
            this.frames = 0;
            this.openingMessageSent = true;
         }
         if(this.messageOpening && gameScreen.contains(this.messageOpening) && !gameScreen.isPaused)
         {
            this.messageOpening.update();
            if(this.frames > 5)
            {
               this.messageOpening.visible = true;
            }
            if(this.frames == -1)
            {
               this.messageOpening.visible = false;
            }
            else if(this.frames++ > 30 * 8)
            {
               this.messageOpening.visible = false;
               this.frames = -1;
            }
         }
         if(this.currentLevelTitle == "Scouting Party: Unexpected Guests")
         {
            if(!this.levelSetupComplete)
            {
               CampaignGameScreen(gameScreen).enemyTeamAi.setRespectForEnemy(0.1);
               this.sneakyNinjas = 3 * this.difficulty - 1;
               this.explodingAlbows = 2.5 * (this.difficulty + 1) - this.difficulty;
               this.levelSetupComplete = true;
               gameScreen.game.team.enemyTeam.statue.x += 10000;
               gameScreen.game.team.enemyTeam.statue.px += 10000;
               gameScreen.team.enemyTeam.population += 1;
            }
            if(this.explodingAlbows > 0)
            {
               for each(u in gameScreen.team.enemyTeam.unitGroups[Unit.U_FLYING_CROSSBOWMAN])
               {
                  if(u.isExploder && u.isNormal)
                  {
                     u.isNormal = false;
                     gameScreen.team.enemyTeam.population += u.population;
                     this.explodingAlbows--;
                  }
                  else if(u.isNormal)
                  {
                     u.isNormal = false;
                  }
               }
            }
            if(!this.gameOver && (gameScreen.game.team.enemyTeam.population <= 0 || gameScreen.game.team.enemyTeam.statue && gameScreen.game.team.enemyTeam.statue.health == 0))
            {
               this.timeUntilEnd = gameScreen.game.frame + 60;
               this.gameOver = true;
               gameScreen.game.team.enemyTeam.statue.px -= 10000;
               this.messageOpening.setMessage("Queen Medusa: The Scouting have become the SCOUTED...","");
               this.frames = 0;
            }
            if(!this.sneakyNinjaWarning && this.albowUnit && this.albowUnit.isExploder && this.albowUnit.isDead)
            {
               if(gameScreen.team.unitGroups[Unit.U_SKELATOR][0])
               {
                  this.messageOpening.setMessage("Marrowkai: That explosion rattled my bones all the way from here! Surrounding scouts must have heard that...","");
               }
               else
               {
                  this.messageOpening.setMessage("Queen Medusa: I felt the force of that detonation all the way from here! Surrounding scouts must have heard that...","");
               }
               this.frames = 0;
               this.sneakyNinjaWarning = true;
            }
            if(this.queenMedusa.isPoisoned() && !this.poisonCheck && gameScreen.team.unitGroups[Unit.U_SKELATOR][0])
            {
               this.poisonCheck = true;
               this.messageOpening.setMessage("Marrowkai: My reap ability can thwart any assassin\'s plan, just give me your command!","");
               this.frames = 0;
            }
            if(this.gameOver && gameScreen.game.team.enemyTeam.statue && gameScreen.game.frame > this.timeUntilEnd)
            {
               gameScreen.game.team.enemyTeam.statue.health = 0;
            }
            if(this.albowUnit && this.albowUnit.isDead)
            {
               this.albowUnit = null;
            }
            if(gameScreen.game.frame > this.timeUntilNextAlbow)
            {
               if((!this.albowUnit || this.albowUnit.isDead) && this.explodingAlbows > 0)
               {
                  this.albowUnit = FlyingCrossbowman(gameScreen.game.unitFactory.getUnit(Unit.U_FLYING_CROSSBOWMAN));
                  gameScreen.team.enemyTeam.spawn(this.albowUnit,gameScreen.game);
                  if(this.explodingAlbows != 1)
                  {
                     this.albowUnit.isExploder = true;
                  }
                  else
                  {
                     gameScreen.team.enemyTeam.spawn(Ninja(gameScreen.game.unitFactory.getUnit(Unit.U_NINJA)),gameScreen.game);
                     gameScreen.team.enemyTeam.population += 4;
                  }
                  this.explodingAlbows--;
                  gameScreen.team.enemyTeam.gold += 300;
                  gameScreen.team.enemyTeam.mana += 20;
               }
               this.timeUntilNextAlbow = gameScreen.game.frame + Math.floor(Math.random() * 200) + 400;
            }
            if(this.explodingAlbows <= 0 && gameScreen.team.enemyTeam.population == 1)
            {
               --gameScreen.team.enemyTeam.population;
            }
            if(this.albowUnit && !this.albowUnit.isDead)
            {
               this.timeUntilNextAlbow = gameScreen.game.frame + Math.floor(Math.random() * 200) + 400;
            }
         }
         if(this.currentLevelTitle == "Scouting Party: Unexpected Guests2")
         {
            if(!this.levelSetupComplete)
            {
               gameScreen.team.enemyTeam.addWall(gameScreen.team.enemyTeam.homeX - 1900).setConstructionAmount(1);
               gameScreen.team.instaQueue = true;
               this.levelSetupComplete = true;
            }
            if(this.sceneCounter == 0 && this.frames == -1)
            {
               this.messageOpening.setMessage("Queen Medusa: The Deads shall lay waste to a small camp, as the Marrowkai spearheads a raid on another. I shall tackle the main castle.","");
               this.frames = 0;
               this.sceneCounter++;
            }
         }
      }
   }
}
