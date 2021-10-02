package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.InGameMessage;
   import com.brockw.stickwar.engine.Ai.command.StandCommand;
   import com.brockw.stickwar.engine.units.Bomber;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Statue;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class CampaignCutScene2 extends CampaignController
   {
      
      private static const S_BEFORE_CUTSCENE:int = -1;
      
      private static const S_ENTER_MEDUSA:int = 0;
      
      private static const S_MEDUSA_YOU_MUST_ALL_DIE:int = 1;
      
      private static const S_SCROLLING_STONE:int = 2;
      
      private static const S_DONE:int = 3;
      
      private static const S_WAIT_FOR_END:int = 4;
       
      
      private var state:int;
      
      private var counter:int = 0;
      
      private var message:InGameMessage;
      
      private var scrollingStoneX:Number;
      
      private var gameScreen:GameScreen;
      
      private var medusa:Unit;
      
      private var spawnNumber:int;
      
      public function CampaignCutScene2(gameScreen:GameScreen)
      {
         super(gameScreen);
         this.gameScreen = gameScreen;
         this.state = S_BEFORE_CUTSCENE;
         this.counter = 0;
         this.medusa = null;
         this.spawnNumber = 0;
      }
      
      override public function update(gameScreen:GameScreen) : void
      {
         var _loc2_:Unit = null;
         var _loc3_:StandCommand = null;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.message)
         {
            this.message.update();
         }
         if(this.state != S_BEFORE_CUTSCENE)
         {
            gameScreen.team.enemyTeam.statue.health = 750;
            gameScreen.team.enemyTeam.gold = 0;
            gameScreen.team.enemyTeam.mana = 200;
            gameScreen.userInterface.hud.hud.fastForward.visible = false;
            gameScreen.isFastForward = false;
         }
         else
         {
            gameScreen.userInterface.hud.hud.fastForward.visible = true;
         }
         if(this.state == S_BEFORE_CUTSCENE)
         {
            if(gameScreen.team.enemyTeam.statue.health < 750)
            {
               gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 325;
               gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 325;
               gameScreen.userInterface.isSlowCamera = true;
               _loc2_ = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
               this.medusa = _loc2_;
               gameScreen.team.enemyTeam.spawn(_loc2_,gameScreen.game);
               Medusa(_loc2_).enableSuperMedusa();
               _loc2_.pz = 0;
               _loc2_.y = gameScreen.game.map.height / 2;
               _loc2_.px = gameScreen.team.enemyTeam.homeX - 200;
               _loc2_.x = _loc2_.px;
               _loc3_ = new StandCommand(gameScreen.game);
               _loc2_.ai.setCommand(gameScreen.game,_loc3_);
               this.state = S_ENTER_MEDUSA;
               this.counter = 0;
            }
         }
         else if(this.state == S_ENTER_MEDUSA)
         {
            _loc3_ = new StandCommand(gameScreen.game);
            this.medusa.ai.setCommand(gameScreen.game,_loc3_);
            gameScreen.game.fogOfWar.isFogOn = false;
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 325;
            gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 325;
            if(this.counter++ > 20)
            {
               this.state = S_MEDUSA_YOU_MUST_ALL_DIE;
               this.counter = 0;
               gameScreen.game.soundManager.playSoundFullVolume("youMustAllDie");
            }
         }
         else if(this.state == S_MEDUSA_YOU_MUST_ALL_DIE)
         {
            gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 325;
            gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 325;
            if(this.counter == 75)
            {
               Medusa(this.medusa).stone(null);
            }
            if(this.counter++ > 100)
            {
               this.state = S_SCROLLING_STONE;
               this.scrollingStoneX = gameScreen.game.team.enemyTeam.statue.x - 325;
            }
         }
         else if(this.state == S_SCROLLING_STONE)
         {
            gameScreen.game.targetScreenX = this.scrollingStoneX;
            gameScreen.game.screenX = this.scrollingStoneX;
            if(gameScreen.game.targetScreenX < gameScreen.game.team.statue.px - 300)
            {
               gameScreen.game.targetScreenX = gameScreen.game.team.statue.px - 300;
            }
            this.scrollingStoneX -= 20;
            _loc4_ = this.scrollingStoneX + gameScreen.game.map.screenWidth / 2;
            gameScreen.game.spatialHash.mapInArea(_loc4_ - 100,0,_loc4_ + 100,gameScreen.game.map.height,this.freezeUnit);
            if(_loc4_ < gameScreen.team.homeX)
            {
               this.state = S_DONE;
               _loc5_ = [];
               _loc5_.push(Unit.U_MINER);
               _loc5_.push(Unit.U_MINER);
               _loc5_.push(Unit.U_SPEARTON);
               _loc5_.push(Unit.U_SPEARTON);
               _loc5_.push(Unit.U_SPEARTON);
               _loc5_.push(Unit.U_SPEARTON);
               _loc5_.push(Unit.U_MAGIKILL);
               _loc5_.push(Unit.U_MONK);
               _loc5_.push(Unit.U_ENSLAVED_GIANT);
               gameScreen.team.spawnUnitGroup(_loc5_);
               gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
               gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
               gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
               gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
            }
         }
         if(this.state == S_DONE)
         {
            if(!this.medusa.isAlive())
            {
               this.state = S_WAIT_FOR_END;
               this.counter = 0;
            }
            else
            {
               gameScreen.game.team.enemyTeam.attack(true);
               if(gameScreen.game.frame % (30 * 10) == 0)
               {
                  _loc6_ = Math.min(this.spawnNumber / 2,4);
                  for(_loc7_ = 0; _loc7_ < _loc6_; _loc7_++)
                  {
                     _loc2_ = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                     gameScreen.team.enemyTeam.spawn(_loc2_,gameScreen.game);
                     _loc2_.px = this.medusa.px + 100;
                     _loc2_.py = gameScreen.game.map.height / (_loc6_ * 2) + _loc7_ / _loc6_ * gameScreen.game.map.height;
                     _loc2_.ai.setCommand(gameScreen.game,new StandCommand(gameScreen.game));
                     gameScreen.team.enemyTeam.population += 1;
                     gameScreen.game.projectileManager.initTowerSpawn(this.medusa.px + 100,_loc2_.py,gameScreen.game.team.enemyTeam,0.6);
                  }
                  ++this.spawnNumber;
               }
            }
         }
         else if(this.state == S_WAIT_FOR_END)
         {
            if(this.counter++ == 30 * 4)
            {
               gameScreen.team.enemyTeam.statue.health = 0;
            }
         }
         super.update(gameScreen);
      }
      
      private function freezeUnit(u:Unit) : void
      {
         if(u.team == this.gameScreen.team && !(u is Statue))
         {
            u.stoneAttack(10000);
         }
      }
   }
}
