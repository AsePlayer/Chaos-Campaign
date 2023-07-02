package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class CampaignCutScene1 extends CampaignController
   {
      
      private static const S_BEFORE_CUTSCENE:int = -1;
      
      private static const S_FADE_OUT:int = 0;
      
      private static const S_FADE_IN:int = 1;
      
      private static const S_MEDUSA_LEAVES:int = 3;
      
      private static const S_ENTER_REBELS:int = 4;
      
      private static const S_END:int = 6;
      
      private static const S_MEDUSA_TALKS_1:int = 2;
      
      private static const S_MEDUSA_TALKS_2:int = 7;
      
      private static const S_MEDUSA_TALKS_3:int = 8;
      
      private static const S_MEDUSA_TALKS_4:int = 9;
      
      private static const S_REBELS_TALK_1:int = 5;
      
      private static const S_REBELS_TALK_2:int = 10;
      
      private static const S_REBELS_TALK_3:int = 11;
      
      private static const S_REBELS_TALK_4:int = 12;
       
      
      private var state:int;
      
      private var counter:int;
      
      private var overlay:MovieClip;
      
      private var medusa:Unit;
      
      private var message:InGameMessage;
      
      private var rebelsAreEvil:Boolean;
      
      private var rebels:Array;
      
      public function CampaignCutScene1(gameScreen:GameScreen)
      {
         super(gameScreen);
         this.state = S_BEFORE_CUTSCENE;
         this.counter = 0;
         this.overlay = new MovieClip();
         this.overlay.graphics.beginFill(0,1);
         this.overlay.graphics.drawRect(0,0,850,750);
         this.rebels = [];
         this.rebelsAreEvil = true;
      }
      
      override public function update(gameScreen:GameScreen) : void
      {
         var unit:Unit = null;
         var c:ColorTransform = null;
         var numGiants:int = 0;
         var giant:Giant = null;
         var game:StickWar = null;
         var u1:Unit = null;
         var frontPosition:Number = NaN;
         var m:MoveCommand = null;
         var r:int = 0;
         if(Boolean(this.message))
         {
            this.message.update();
         }
         gameScreen.team.enemyTeam.statue.health = 180;
         gameScreen.team.enemyTeam.gold = 0;
         if(Boolean(this.medusa))
         {
            this.medusa.faceDirection(-1);
         }
         if(!this.rebelsAreEvil)
         {
            for each(unit in this.rebels)
            {
               c = unit.mc.transform.colorTransform;
               c.redOffset = 0;
               c.blueOffset = 0;
               c.greenOffset = 0;
               unit.mc.transform.colorTransform = c;
            }
         }
         if(this.state != S_BEFORE_CUTSCENE)
         {
            gameScreen.isFastForward = false;
            gameScreen.userInterface.hud.hud.fastForward.visible = false;
         }
         else
         {
            gameScreen.userInterface.hud.hud.fastForward.visible = true;
         }
         if(this.state != S_BEFORE_CUTSCENE)
         {
            for each(unit in gameScreen.game.team.units)
            {
               unit.ai.mayAttack = false;
            }
            for each(unit in gameScreen.game.team.enemyTeam.units)
            {
               unit.ai.mayAttack = false;
            }
            gameScreen.userInterface.selectedUnits.clear();
            CampaignGameScreen(gameScreen).doAiUpdates = false;
            gameScreen.userInterface.isGlobalsEnabled = false;
         }
         if(this.state == S_BEFORE_CUTSCENE)
         {
            numGiants = 0;
            if(Boolean(gameScreen.team.enemyTeam.unitGroups[Unit.U_GIANT]))
            {
               numGiants = 1;
               giant = gameScreen.team.enemyTeam.unitGroups[Unit.U_GIANT][0];
               if(giant == null || giant.health == 0)
               {
                  numGiants = 0;
               }
            }
            if(numGiants == 0)
            {
               this.state = S_FADE_OUT;
               this.counter = 0;
               gameScreen.addChild(this.overlay);
               this.overlay.alpha = 0;
               gameScreen.main.kongregateReportStatistic("killAGiant",1);
               trace("Report Kill a giant");
            }
         }
         else if(this.state == S_FADE_OUT)
         {
            ++this.counter;
            this.overlay.alpha = this.counter / 60;
            if(this.counter > 45)
            {
               gameScreen.game.team.cleanUpUnits();
               gameScreen.game.team.enemyTeam.cleanUpUnits();
               gameScreen.game.team.gold = gameScreen.game.team.mana = 0;
               gameScreen.game.team.enemyTeam.gold = gameScreen.game.team.enemyTeam.mana = 0;
            }
            if(this.counter > 60)
            {
               this.state = S_FADE_IN;
               this.counter = 0;
               game = gameScreen.game;
               u1 = EnslavedGiant(game.unitFactory.getUnit(Unit.U_ENSLAVED_GIANT));
               gameScreen.team.spawn(u1,game);
               u1.px = gameScreen.team.enemyTeam.statue.x - 200;
               u1.py = game.map.height / 2;
               u1.ai.setCommand(game,new HoldCommand(game));
               u1.ai.mayAttack = false;
               u1 = Swordwrath(game.unitFactory.getUnit(Unit.U_SWORDWRATH));
               gameScreen.team.spawn(u1,game);
               u1.px = gameScreen.team.enemyTeam.statue.x - 200 + 50;
               u1.py = game.map.height / 4;
               u1.ai.setCommand(game,new HoldCommand(game));
               u1 = Swordwrath(game.unitFactory.getUnit(Unit.U_SWORDWRATH));
               gameScreen.team.spawn(u1,game);
               u1.px = gameScreen.team.enemyTeam.statue.x - 200 + 50;
               u1.py = 3 * game.map.height / 4;
               u1.ai.setCommand(game,new HoldCommand(game));
               u1 = Spearton(game.unitFactory.getUnit(Unit.U_SPEARTON));
               gameScreen.team.spawn(u1,game);
               u1.px = gameScreen.team.enemyTeam.statue.x - 200 - 50;
               u1.py = game.map.height / 4;
               u1.ai.setCommand(game,new HoldCommand(game));
               u1 = Spearton(game.unitFactory.getUnit(Unit.U_SPEARTON));
               gameScreen.team.spawn(u1,game);
               u1.px = gameScreen.team.enemyTeam.statue.x - 200 - 50;
               u1.py = 3 * game.map.height / 4;
               u1.ai.setCommand(game,new HoldCommand(game));
               u1 = Medusa(game.unitFactory.getUnit(Unit.U_MEDUSA));
               gameScreen.team.enemyTeam.spawn(u1,game);
               this.medusa = u1;
               u1.ai.setCommand(game,new HoldCommand(game));
               u1.flyingHeight = 380;
               u1.pz = -u1.flyingHeight;
               u1.py = game.map.height / 2;
               u1.y = 0;
               u1.px = gameScreen.team.enemyTeam.homeX + gameScreen.team.enemyTeam.direction * 100;
               u1.x = u1.px;
               u1.faceDirection(-1);
            }
         }
         else if(this.state == S_FADE_IN)
         {
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 350;
            gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 350;
            ++this.counter;
            this.overlay.alpha = (60 - this.counter) / 60;
            if(this.counter > 60)
            {
               this.state = S_MEDUSA_TALKS_1;
               gameScreen.removeChild(this.overlay);
               this.counter = 0;
               this.message = new InGameMessage("",gameScreen.game);
               this.message.x = gameScreen.game.stage.stageWidth / 2;
               this.message.y = gameScreen.game.stage.stageHeight / 4 - 75;
               this.message.scaleX *= 1.3;
               this.message.scaleY *= 1.3;
               gameScreen.addChild(this.message);
            }
         }
         else if(this.state == S_MEDUSA_TALKS_1)
         {
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 350;
            gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 350;
            this.message.setMessage("You fools thought Inamorta belonged to you!","",0,"medusaVoice1");
            ++this.counter;
            if(this.counter > 150)
            {
               this.state = S_MEDUSA_TALKS_2;
               this.counter = 0;
            }
         }
         else if(this.state == S_MEDUSA_TALKS_2)
         {
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 350;
            gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 350;
            this.message.setMessage("We\'ve been here all along biding our time growing with power while your armys destroy themselves in battles over land that belongs to me!","",0,"medusaVoice2");
            ++this.counter;
            if(this.message.hasFinishedPlayingSound())
            {
               this.state = S_MEDUSA_TALKS_3;
               this.counter = 0;
            }
         }
         else if(this.state == S_MEDUSA_TALKS_3)
         {
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 350;
            gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 350;
            this.message.setMessage("But now you have enslaved my babies and I will wait no more... now you will feel the wrath of the Chaos Empire!","",0,"medusaVoice3");
            ++this.counter;
            if(this.message.hasFinishedPlayingSound())
            {
               this.state = S_MEDUSA_LEAVES;
               this.counter = 0;
               gameScreen.team.enemyTeam.garrison(true);
            }
         }
         else if(this.state == S_MEDUSA_LEAVES)
         {
            ++this.counter;
            if(this.message.hasFinishedPlayingSound())
            {
               this.state = S_ENTER_REBELS;
               for each(unit in gameScreen.game.team.units)
               {
                  unit.forceFaceDirection(-1);
               }
               frontPosition = gameScreen.team.enemyTeam.statue.x - 600 - 400;
               game = gameScreen.game;
               u1 = game.unitFactory.getUnit(Unit.U_NINJA);
               gameScreen.team.spawn(u1,game);
               u1.px = frontPosition - 75;
               u1.py = 3 * game.map.height / 4;
               m = new MoveCommand(game);
               m.realX = m.goalX = u1.px + 400;
               m.realY = m.goalY = u1.py;
               u1.ai.setCommand(game,m);
               u1.ai.mayAttack = false;
               u1.ai.mayMoveToAttack = false;
               this.rebels.push(u1);
               u1 = game.unitFactory.getUnit(Unit.U_MAGIKILL);
               gameScreen.team.spawn(u1,game);
               u1.px = frontPosition;
               u1.py = game.map.height / 2;
               m = new MoveCommand(game);
               m.goalX = u1.px + 400;
               m.goalY = u1.py;
               u1.ai.setCommand(game,m);
               u1.ai.mayAttack = false;
               u1.ai.mayMoveToAttack = false;
               this.rebels.push(u1);
               u1 = game.unitFactory.getUnit(Unit.U_MONK);
               gameScreen.team.spawn(u1,game);
               u1.px = frontPosition - 75;
               u1.py = game.map.height / 4;
               m = new MoveCommand(game);
               m.goalX = u1.px + 400;
               m.goalY = u1.py;
               u1.ai.setCommand(game,m);
               u1.ai.mayAttack = false;
               u1.ai.mayMoveToAttack = false;
               this.rebels.push(u1);
               u1 = game.unitFactory.getUnit(Unit.U_ARCHER);
               gameScreen.team.spawn(u1,game);
               u1.px = frontPosition - 75;
               u1.py = 0;
               m = new MoveCommand(game);
               m.goalX = u1.px + 400;
               m.goalY = u1.py;
               u1.ai.setCommand(game,m);
               u1.ai.mayAttack = false;
               u1.ai.mayMoveToAttack = false;
               this.rebels.push(u1);
               u1 = game.unitFactory.getUnit(Unit.U_SPEARTON);
               gameScreen.team.spawn(u1,game);
               u1.px = frontPosition - 75;
               u1.py = game.map.height;
               m = new MoveCommand(game);
               m.goalX = u1.px + 400;
               m.goalY = u1.py;
               u1.ai.setCommand(game,m);
               u1.ai.mayAttack = false;
               u1.ai.mayMoveToAttack = false;
               this.rebels.push(u1);
               for each(unit in this.rebels)
               {
                  c = unit.mc.transform.colorTransform;
                  r = game.random.nextInt();
                  c.redOffset = 75;
                  c.blueOffset = 0;
                  c.greenOffset = 0;
                  unit.mc.transform.colorTransform = c;
               }
               this.counter = 0;
            }
         }
         else if(this.state == S_ENTER_REBELS)
         {
            gameScreen.userInterface.isSlowCamera = true;
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 900;
            for each(unit in gameScreen.game.team.units)
            {
               unit.ai.mayAttack = false;
               unit.ai.mayMoveToAttack = false;
            }
            ++this.counter;
            if(this.counter > 100)
            {
               this.state = S_REBELS_TALK_1;
               this.counter = 0;
            }
         }
         else if(this.state == S_REBELS_TALK_1)
         {
            gameScreen.userInterface.isSlowCamera = true;
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 900;
            for each(unit in gameScreen.game.team.units)
            {
               unit.ai.mayAttack = false;
               unit.ai.mayMoveToAttack = false;
            }
            this.message.setMessage("Today we come together representing each of the rebel nations to offer a truce.","",0,"wizardVoiceOver1");
            if(this.message.hasFinishedPlayingSound())
            {
               this.state = S_REBELS_TALK_2;
            }
         }
         else if(this.state == S_REBELS_TALK_2)
         {
            gameScreen.userInterface.isSlowCamera = true;
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 900;
            for each(unit in gameScreen.game.team.units)
            {
               unit.ai.mayAttack = false;
               unit.ai.mayMoveToAttack = false;
            }
            this.message.setMessage("We wish to join your Order Empire. Clearly there is a bigger threat that we can not face alone.","",0,"wizardVoiceOver2");
            if(this.message.hasFinishedPlayingSound())
            {
               this.state = S_REBELS_TALK_3;
            }
         }
         else if(this.state == S_REBELS_TALK_3)
         {
            gameScreen.userInterface.isSlowCamera = true;
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 900;
            for each(unit in gameScreen.game.team.units)
            {
               unit.ai.mayAttack = false;
               unit.ai.mayMoveToAttack = false;
            }
            this.message.setMessage("That monster was right, all we\'ve been doing for years is making ourselves weak!","",0,"wizardVoiceOver3");
            if(this.message.hasFinishedPlayingSound())
            {
               this.state = S_REBELS_TALK_4;
               this.rebelsAreEvil = false;
               for each(unit in this.rebels)
               {
                  unit.team.game.projectileManager.initTowerSpawn(unit.px,unit.py,unit.team);
               }
            }
         }
         else if(this.state == S_REBELS_TALK_4)
         {
            gameScreen.userInterface.isSlowCamera = true;
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 900;
            for each(unit in gameScreen.game.team.units)
            {
               unit.ai.mayAttack = false;
               unit.ai.mayMoveToAttack = false;
            }
            this.message.setMessage("Today we can unite and share this new land so none shall live as rebels again!","",0,"wizardVoiceOver4");
            if(this.message.hasFinishedPlayingSound())
            {
               gameScreen.team.enemyTeam.statue.health = 0;
            }
         }
         super.update(gameScreen);
      }
   }
}
