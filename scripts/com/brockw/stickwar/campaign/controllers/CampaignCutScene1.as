package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.campaign.InGameMessage;
   import com.brockw.stickwar.engine.Ai.command.HoldCommand;
   import com.brockw.stickwar.engine.Ai.command.MoveCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.EnslavedGiant;
   import com.brockw.stickwar.engine.units.Giant;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Spearton;
   import com.brockw.stickwar.engine.units.Swordwrath;
   import com.brockw.stickwar.engine.units.Unit;
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
         var _loc2_:Unit = null;
         var _loc3_:ColorTransform = null;
         var _loc4_:int = 0;
         var _loc5_:Giant = null;
         var _loc6_:StickWar = null;
         var _loc7_:Unit = null;
         var _loc8_:Number = NaN;
         var _loc9_:MoveCommand = null;
         var _loc10_:int = 0;
         if(this.message)
         {
            this.message.update();
         }
         gameScreen.team.enemyTeam.statue.health = 180;
         gameScreen.team.enemyTeam.gold = 0;
         if(this.medusa)
         {
            this.medusa.faceDirection(-1);
         }
         if(!this.rebelsAreEvil)
         {
            for each(_loc2_ in this.rebels)
            {
               _loc3_ = _loc2_.mc.transform.colorTransform;
               _loc3_.redOffset = 0;
               _loc3_.blueOffset = 0;
               _loc3_.greenOffset = 0;
               _loc2_.mc.transform.colorTransform = _loc3_;
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
            for each(_loc2_ in gameScreen.game.team.units)
            {
               _loc2_.ai.mayAttack = false;
            }
            for each(_loc2_ in gameScreen.game.team.enemyTeam.units)
            {
               _loc2_.ai.mayAttack = false;
            }
            gameScreen.userInterface.selectedUnits.clear();
            CampaignGameScreen(gameScreen).doAiUpdates = false;
            gameScreen.userInterface.isGlobalsEnabled = false;
         }
         if(this.state == S_BEFORE_CUTSCENE)
         {
            _loc4_ = 0;
            if(gameScreen.team.enemyTeam.unitGroups[Unit.U_GIANT])
            {
               _loc4_ = 1;
               _loc5_ = gameScreen.team.enemyTeam.unitGroups[Unit.U_GIANT][0];
               if(_loc5_ == null || _loc5_.health == 0)
               {
                  _loc4_ = 0;
               }
            }
            if(_loc4_ == 0)
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
               _loc6_ = gameScreen.game;
               _loc7_ = EnslavedGiant(_loc6_.unitFactory.getUnit(Unit.U_ENSLAVED_GIANT));
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = gameScreen.team.enemyTeam.statue.x - 200;
               _loc7_.py = _loc6_.map.height / 2;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_.ai.mayAttack = false;
               _loc7_ = Swordwrath(_loc6_.unitFactory.getUnit(Unit.U_SWORDWRATH));
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = gameScreen.team.enemyTeam.statue.x - 200 + 50;
               _loc7_.py = _loc6_.map.height / 4;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_ = Swordwrath(_loc6_.unitFactory.getUnit(Unit.U_SWORDWRATH));
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = gameScreen.team.enemyTeam.statue.x - 200 + 50;
               _loc7_.py = 3 * _loc6_.map.height / 4;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_ = Spearton(_loc6_.unitFactory.getUnit(Unit.U_SPEARTON));
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = gameScreen.team.enemyTeam.statue.x - 200 - 50;
               _loc7_.py = _loc6_.map.height / 4;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_ = Spearton(_loc6_.unitFactory.getUnit(Unit.U_SPEARTON));
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = gameScreen.team.enemyTeam.statue.x - 200 - 50;
               _loc7_.py = 3 * _loc6_.map.height / 4;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_ = Medusa(_loc6_.unitFactory.getUnit(Unit.U_MEDUSA));
               gameScreen.team.enemyTeam.spawn(_loc7_,_loc6_);
               this.medusa = _loc7_;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_.flyingHeight = 380;
               _loc7_.pz = -_loc7_.flyingHeight;
               _loc7_.py = _loc6_.map.height / 2;
               _loc7_.y = 0;
               _loc7_.px = gameScreen.team.enemyTeam.homeX + gameScreen.team.enemyTeam.direction * 100;
               _loc7_.x = _loc7_.px;
               _loc7_.faceDirection(-1);
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
               for each(_loc2_ in gameScreen.game.team.units)
               {
                  _loc2_.forceFaceDirection(-1);
               }
               _loc8_ = gameScreen.team.enemyTeam.statue.x - 600 - 400;
               _loc6_ = gameScreen.game;
               _loc7_ = _loc6_.unitFactory.getUnit(Unit.U_NINJA);
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = _loc8_ - 75;
               _loc7_.py = 3 * _loc6_.map.height / 4;
               _loc9_ = new MoveCommand(_loc6_);
               _loc9_.realX = _loc9_.goalX = _loc7_.px + 400;
               _loc9_.realY = _loc9_.goalY = _loc7_.py;
               _loc7_.ai.setCommand(_loc6_,_loc9_);
               _loc7_.ai.mayAttack = false;
               _loc7_.ai.mayMoveToAttack = false;
               this.rebels.push(_loc7_);
               _loc7_ = _loc6_.unitFactory.getUnit(Unit.U_MAGIKILL);
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = _loc8_;
               _loc7_.py = _loc6_.map.height / 2;
               _loc9_ = new MoveCommand(_loc6_);
               _loc9_.goalX = _loc7_.px + 400;
               _loc9_.goalY = _loc7_.py;
               _loc7_.ai.setCommand(_loc6_,_loc9_);
               _loc7_.ai.mayAttack = false;
               _loc7_.ai.mayMoveToAttack = false;
               this.rebels.push(_loc7_);
               _loc7_ = _loc6_.unitFactory.getUnit(Unit.U_MONK);
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = _loc8_ - 75;
               _loc7_.py = _loc6_.map.height / 4;
               _loc9_ = new MoveCommand(_loc6_);
               _loc9_.goalX = _loc7_.px + 400;
               _loc9_.goalY = _loc7_.py;
               _loc7_.ai.setCommand(_loc6_,_loc9_);
               _loc7_.ai.mayAttack = false;
               _loc7_.ai.mayMoveToAttack = false;
               this.rebels.push(_loc7_);
               _loc7_ = _loc6_.unitFactory.getUnit(Unit.U_ARCHER);
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = _loc8_ - 75;
               _loc7_.py = 0;
               _loc9_ = new MoveCommand(_loc6_);
               _loc9_.goalX = _loc7_.px + 400;
               _loc9_.goalY = _loc7_.py;
               _loc7_.ai.setCommand(_loc6_,_loc9_);
               _loc7_.ai.mayAttack = false;
               _loc7_.ai.mayMoveToAttack = false;
               this.rebels.push(_loc7_);
               _loc7_ = _loc6_.unitFactory.getUnit(Unit.U_SPEARTON);
               gameScreen.team.spawn(_loc7_,_loc6_);
               _loc7_.px = _loc8_ - 75;
               _loc7_.py = _loc6_.map.height;
               _loc9_ = new MoveCommand(_loc6_);
               _loc9_.goalX = _loc7_.px + 400;
               _loc9_.goalY = _loc7_.py;
               _loc7_.ai.setCommand(_loc6_,_loc9_);
               _loc7_.ai.mayAttack = false;
               _loc7_.ai.mayMoveToAttack = false;
               this.rebels.push(_loc7_);
               for each(_loc2_ in this.rebels)
               {
                  _loc3_ = _loc2_.mc.transform.colorTransform;
                  _loc10_ = _loc6_.random.nextInt();
                  _loc3_.redOffset = 75;
                  _loc3_.blueOffset = 0;
                  _loc3_.greenOffset = 0;
                  _loc2_.mc.transform.colorTransform = _loc3_;
               }
               this.counter = 0;
            }
         }
         else if(this.state == S_ENTER_REBELS)
         {
            gameScreen.userInterface.isSlowCamera = true;
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 900;
            for each(_loc2_ in gameScreen.game.team.units)
            {
               _loc2_.ai.mayAttack = false;
               _loc2_.ai.mayMoveToAttack = false;
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
            for each(_loc2_ in gameScreen.game.team.units)
            {
               _loc2_.ai.mayAttack = false;
               _loc2_.ai.mayMoveToAttack = false;
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
            for each(_loc2_ in gameScreen.game.team.units)
            {
               _loc2_.ai.mayAttack = false;
               _loc2_.ai.mayMoveToAttack = false;
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
            for each(_loc2_ in gameScreen.game.team.units)
            {
               _loc2_.ai.mayAttack = false;
               _loc2_.ai.mayMoveToAttack = false;
            }
            this.message.setMessage("That monster was right, all we\'ve been doing for years is making ourselves weak!","",0,"wizardVoiceOver3");
            if(this.message.hasFinishedPlayingSound())
            {
               this.state = S_REBELS_TALK_4;
               this.rebelsAreEvil = false;
               for each(_loc2_ in this.rebels)
               {
                  _loc2_.team.game.projectileManager.initTowerSpawn(_loc2_.px,_loc2_.py,_loc2_.team);
               }
            }
         }
         else if(this.state == S_REBELS_TALK_4)
         {
            gameScreen.userInterface.isSlowCamera = true;
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 900;
            for each(_loc2_ in gameScreen.game.team.units)
            {
               _loc2_.ai.mayAttack = false;
               _loc2_.ai.mayMoveToAttack = false;
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
