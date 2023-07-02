package com.brockw.stickwar.singleplayer
{
   import com.brockw.stickwar.BaseMain;
   import com.brockw.stickwar.campaign.Campaign;
   import com.brockw.stickwar.engine.Ai.RangedAi;
   import com.brockw.stickwar.engine.Ai.command.FistAttackCommand;
   import com.brockw.stickwar.engine.Ai.command.PoisonPoolCommand;
   import com.brockw.stickwar.engine.Ai.command.ReaperCommand;
   import com.brockw.stickwar.engine.Ai.command.StoneCommand;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.Team.TechItem;
   import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
   import com.brockw.stickwar.engine.units.Dead;
   import com.brockw.stickwar.engine.units.Giant;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Skelator;
   import com.brockw.stickwar.engine.units.Unit;
   import com.brockw.stickwar.engine.units.Wingidon;
   import flash.utils.Dictionary;
   
   public class EnemyChaosTeamAi extends EnemyTeamAi
   {
       
      
      private var buildOrder:Array;
      
      private var fistAttackSpell:FistAttackCommand;
      
      private var reaperSpell:ReaperCommand;
      
      private var poisonPoolSpell:PoisonPoolCommand;
      
      private var stoneSpell:StoneCommand;
      
      private var giantGrowth:int = 0;
      
      private var giantGrowthTimer = -1;
      
      private var determineWingMoveAt = 60;
      
      private var wingCounter = 0;
      
      private var comment:String = "";
      
      public function EnemyChaosTeamAi(team:Team, main:BaseMain, game:StickWar, isCreatingUnits:* = true)
      {
         var key:int = 0;
         this.fistAttackSpell = new FistAttackCommand(game);
         this.reaperSpell = new ReaperCommand(game);
         this.poisonPoolSpell = new PoisonPoolCommand(game);
         this.stoneSpell = new StoneCommand(game);
         unitComposition = new Dictionary();
         unitComposition[Unit.U_CHAOS_MINER] = main.campaign.xml.Chaos.UnitComposition.ChaosMiner;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.ChaosMiner) != "")
         {
            unitComposition[Unit.U_CHAOS_MINER] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.ChaosMiner);
         }
         unitComposition[Unit.U_BOMBER] = main.campaign.xml.Chaos.UnitComposition.Bomber;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Bomber) != "")
         {
            unitComposition[Unit.U_BOMBER] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Bomber);
         }
         unitComposition[Unit.U_WINGIDON] = main.campaign.xml.Chaos.UnitComposition.Wingadon;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Wingadon) != "")
         {
            unitComposition[Unit.U_WINGIDON] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Wingadon);
         }
         unitComposition[Unit.U_SKELATOR] = main.campaign.xml.Chaos.UnitComposition.SkelatalMage;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.SkelatalMage) != "")
         {
            unitComposition[Unit.U_SKELATOR] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.SkelatalMage);
         }
         unitComposition[Unit.U_DEAD] = main.campaign.xml.Chaos.UnitComposition.Dead;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Dead) != "")
         {
            unitComposition[Unit.U_DEAD] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Dead);
         }
         unitComposition[Unit.U_CAT] = main.campaign.xml.Chaos.UnitComposition.Cat;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Cat) != "")
         {
            unitComposition[Unit.U_CAT] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Cat);
         }
         unitComposition[Unit.U_KNIGHT] = main.campaign.xml.Chaos.UnitComposition.Knight;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Knight) != "")
         {
            unitComposition[Unit.U_KNIGHT] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Knight);
         }
         unitComposition[Unit.U_MEDUSA] = main.campaign.xml.Chaos.UnitComposition.Medusa;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Medusa) != "")
         {
            unitComposition[Unit.U_MEDUSA] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Medusa);
         }
         unitComposition[Unit.U_GIANT] = main.campaign.xml.Chaos.UnitComposition.Giant;
         if(String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Giant) != "")
         {
            unitComposition[Unit.U_GIANT] = String(main.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Giant);
         }
         var theoriticalBuildOrder:* = [Unit.U_GIANT,Unit.U_MEDUSA,Unit.U_KNIGHT,Unit.U_CAT,Unit.U_DEAD,Unit.U_SKELATOR,Unit.U_WINGIDON,Unit.U_BOMBER];
         this.buildOrder = [];
         for each(key in theoriticalBuildOrder)
         {
            if(team.unitsAvailable == null || key in team.unitsAvailable)
            {
               this.buildOrder.push(key);
            }
         }
         super(team,main,game,isCreatingUnits);
      }
      
      override public function update(game:StickWar) : void
      {
         super.update(game);
      }
      
      override protected function updateUnitCreation(param1:StickWar) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TechItem = null;
         _loc4_ = int(team.unitGroups[Unit.U_CHAOS_MINER].length);
         if(!enemyIsAttacking() && (team.population < 16 || this.enemyAtHome() || this.enemyAtMiddle()))
         {
            if((_loc4_ = int(team.unitGroups[Unit.U_CHAOS_MINER].length)) < unitComposition[Unit.U_CHAOS_MINER] && team.unitProductionQueue[team.unitInfo[Unit.U_CHAOS_MINER][2]].length == 0)
            {
               param1.requestToSpawn(team.id,Unit.U_CHAOS_MINER);
            }
         }
         var _loc2_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.buildOrder.length)
         {
            _loc4_ = int(team.unitGroups[this.buildOrder[_loc3_]].length);
            if(!(this.buildOrder[_loc3_] == Unit.U_BOMBER && team.attackingForcePopulation < 6))
            {
               if(_loc4_ >= unitComposition[this.buildOrder[_loc3_]])
               {
                  _loc2_++;
               }
               else if(team.unitProductionQueue[team.unitInfo[this.buildOrder[_loc3_]][2]].length == 0)
               {
                  param1.requestToSpawn(team.id,this.buildOrder[_loc3_]);
               }
            }
            _loc3_++;
         }
         if(_loc2_ >= this.buildOrder.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.buildOrder.length)
            {
               _loc4_ = int(team.unitGroups[this.buildOrder[_loc3_]].length);
               if(team.unitProductionQueue[team.unitInfo[this.buildOrder[_loc3_]][2]].length == 0)
               {
                  param1.requestToSpawn(team.id,this.buildOrder[_loc3_]);
               }
               _loc3_++;
            }
         }
         if(!team.tech.isResearched(Tech.CHAOS_GIANT_GROWTH_I) && team.game.main.campaign.difficultyLevel > Campaign.D_NORMAL && this.giantGrowth == 0)
         {
            _loc5_ = team.tech.upgrades[Tech.CHAOS_GIANT_GROWTH_I];
            if(_loc5_ == null)
            {
               return;
            }
            if(_loc5_.cost < team.gold && _loc5_.mana < team.mana)
            {
               team.tech.startResearching(Tech.CHAOS_GIANT_GROWTH_I);
               this.giantGrowthTimer = 1200;
               this.giantGrowth = 1;
            }
         }
         else if(!team.tech.isResearched(Tech.CHAOS_GIANT_GROWTH_II) && team.game.main.campaign.difficultyLevel > Campaign.D_HARD && this.giantGrowth == 1)
         {
            _loc5_ = team.tech.upgrades[Tech.CHAOS_GIANT_GROWTH_II];
            if(_loc5_ == null)
            {
               return;
            }
            if(_loc5_.cost < team.gold && _loc5_.mana < team.mana)
            {
               team.tech.startResearching(Tech.CHAOS_GIANT_GROWTH_II);
               this.giantGrowthTimer = 1800;
               this.giantGrowth = 2;
            }
         }
         if(!team.tech.isResearched(Tech.CASTLE_ARCHER_1))
         {
            _loc5_ = team.tech.upgrades[Tech.CASTLE_ARCHER_1];
            if(_loc5_ == null)
            {
               return;
            }
            if(_loc5_.cost < team.gold && _loc5_.mana < team.mana)
            {
               team.tech.startResearching(Tech.CASTLE_ARCHER_1);
            }
         }
         else if(!team.tech.isResearched(Tech.CASTLE_ARCHER_2) && team.game.main.campaign.difficultyLevel > Campaign.D_NORMAL)
         {
            _loc5_ = team.tech.upgrades[Tech.CASTLE_ARCHER_2];
            if(_loc5_ == null)
            {
               return;
            }
            if(_loc5_.cost + 200 < team.gold && _loc5_.mana + 400 < team.mana)
            {
               team.tech.startResearching(Tech.CASTLE_ARCHER_2);
            }
         }
      }
      
      override protected function updateSpellCasters(game:StickWar) : void
      {
         var manaBefore:Number = team.mana;
         team.mana = 1000;
         this.updateDeads(game);
         this.updateSkelator(game);
         this.updateMedusa(game);
         this.updateWingidon(game);
         if(game.main.campaign.difficultyLevel == Campaign.D_INSANE)
         {
            team.tech.isResearchedMap[Tech.CAT_SPEED] = true;
            team.tech.isResearchedMap[Tech.CAT_PACK] = true;
            team.tech.isResearchedMap[Tech.TOWER_SPAWN_I] = true;
            team.tech.isResearchedMap[Tech.TOWER_SPAWN_II] = true;
            team.tech.isResearchedMap[Tech.MINER_SPEED] = true;
            team.tech.isResearchedMap[Tech.DEAD_POISON] = true;
            team.tech.isResearchedMap[Tech.CASTLE_ARCHER_1] = true;
            team.tech.isResearchedMap[Tech.CHAOS_GIANT_GROWTH_I] = true;
         }
         if(game.main.campaign.difficultyLevel == Campaign.D_HARD)
         {
            team.tech.isResearchedMap[Tech.TOWER_SPAWN_I] = true;
            team.tech.isResearchedMap[Tech.TOWER_SPAWN_II] = true;
            team.tech.isResearchedMap[Tech.MINER_SPEED] = true;
            team.tech.isResearchedMap[Tech.CAT_SPEED] = true;
            team.tech.isResearchedMap[Tech.CAT_PACK] = true;
            team.tech.isResearchedMap[Tech.DEAD_POISON] = true;
         }
         if(game.main.campaign.difficultyLevel == Campaign.D_NORMAL)
         {
            team.tech.isResearchedMap[Tech.TOWER_SPAWN_I] = true;
            team.tech.isResearchedMap[Tech.CAT_SPEED] = true;
            team.tech.isResearchedMap[Tech.CAT_PACK] = true;
            team.tech.isResearchedMap[Tech.MINER_SPEED] = true;
            team.tech.isResearchedMap[Tech.DEAD_POISON] = true;
         }
         if(this.giantGrowthTimer > 0)
         {
            --this.giantGrowthTimer;
         }
         if(team.tech.isResearched(Tech.CHAOS_GIANT_GROWTH_I) && !team.tech.isResearched(Tech.CHAOS_GIANT_GROWTH_II) && this.giantGrowth == 0)
         {
            this.giantGrowth = 1;
         }
         if(this.giantGrowth == 1 && this.giantGrowth <= 0)
         {
            team.tech.isResearchedMap[Tech.CHAOS_GIANT_GROWTH_I] = true;
         }
         else if(this.giantGrowth == 2 && this.giantGrowth <= 0)
         {
            team.tech.isResearchedMap[Tech.CHAOS_GIANT_GROWTH_I] = true;
            team.tech.isResearchedMap[Tech.CHAOS_GIANT_GROWTH_II] = true;
         }
         team.mana = manaBefore;
      }
      
      private function updateDeads(game:StickWar) : void
      {
         var dead:Dead = null;
         team.tech.isResearchedMap[Tech.DEAD_POISON] = true;
         for each(dead in team.unitGroups[Unit.U_DEAD])
         {
            if(!dead.isPoisonedToggled)
            {
               dead.togglePoison();
            }
            if(dead.ai.currentTarget != null)
            {
               RangedAi(dead.ai).mayKite = true;
            }
         }
      }
      
      private function updateGiants(game:StickWar) : void
      {
         var giant:Giant = null;
         for each(giant in team.unitGroups[Unit.U_GIANT])
         {
            if(giant.ai.currentTarget != null)
            {
               if(Math.abs(team.enemyTeam.statue.px - giant.px) < 200)
               {
                  giant.ai.currentTarget = team.enemyTeam.statue;
               }
               else if(team.direction * giant.ai.currentTarget.px < team.direction * (giant.px + -team.direction * 150))
               {
                  giant.ai.currentTarget = null;
                  giant.walk(team.direction,0,team.direction);
               }
            }
         }
      }
      
      private function updateMedusa(game:StickWar) : void
      {
         var medusa:Medusa = null;
         var target:Unit = null;
         team.tech.isResearchedMap[Tech.MEDUSA_POISON] = true;
         for each(medusa in team.unitGroups[Unit.U_MEDUSA])
         {
            target = medusa.ai.getClosestTarget();
            if(target)
            {
               if(medusa.stoneCooldown() == 0)
               {
                  this.stoneSpell.realX = target.px;
                  this.stoneSpell.realY = target.py;
                  this.stoneSpell.targetId = target.id;
                  if(this.stoneSpell.inRange(medusa))
                  {
                     medusa.stone(target);
                  }
               }
               else if(medusa.poisonPoolCooldown() == 0)
               {
                  this.poisonPoolSpell.realX = target.px;
                  this.poisonPoolSpell.realY = target.py;
                  if(this.poisonPoolSpell.inRange(medusa))
                  {
                     medusa.poisonSpray();
                  }
               }
            }
         }
      }
      
      private function updateSkelator(game:StickWar) : void
      {
         var skelator:Skelator = null;
         var target:Unit = null;
         team.tech.isResearchedMap[Tech.SKELETON_FIST_ATTACK] = true;
         for each(skelator in team.unitGroups[Unit.U_SKELATOR])
         {
            target = skelator.ai.getClosestTarget();
            if(target)
            {
               if(skelator.fistAttackCooldown() == 0)
               {
                  this.fistAttackSpell.realX = target.px;
                  this.fistAttackSpell.realY = target.py;
                  if(this.fistAttackSpell.inRange(skelator))
                  {
                     skelator.fistAttack(target.px,target.py);
                  }
               }
               else if(skelator.reaperCooldown() == 0)
               {
                  this.reaperSpell.targetId = target.id;
                  this.reaperSpell.realX = target.px;
                  this.reaperSpell.realY = target.py;
                  if(this.reaperSpell.inRange(skelator))
                  {
                     skelator.reaperAttack(target);
                  }
               }
            }
         }
      }
      
      public function updateWingidon(game:StickWar) : void
      {
         var _loc7_:UnitMove = null;
         var wingidon:Wingidon = null;
         var closestEnemyUnit:Unit = null;
         var moving:Boolean = false;
         var randomNumber:int = int(null);
         for each(wingidon in team.unitGroups[Unit.U_WINGIDON])
         {
            randomNumber = Math.floor(Math.random() * 100) + 25;
            closestEnemyUnit = wingidon.ai.getClosestTarget();
            if(closestEnemyUnit)
            {
               if(wingidon.speedSpellCooldown() == 0)
               {
                  if(Math.abs(wingidon.prevpx - wingidon.px) > 4 && !wingidon.isIncapacitated())
                  {
                     if(Math.abs(wingidon.ai.getIntendedX() - wingidon.px) > 200)
                     {
                        wingidon.speedSpell();
                     }
                  }
               }
               else if(1 == 2 && wingidon.isWingSpell && Math.abs(closestEnemyUnit.px - wingidon.px) < 800 && Math.abs(closestEnemyUnit.px - wingidon.px) > 200)
               {
                  this.comment = "inactive code ------------------------------------------------------------------------------------------------------------------------";
                  wingidon.forceFaceDirection(wingidon.px - closestEnemyUnit.px);
                  _loc7_ = new UnitMove();
                  _loc7_.owner = game.team.enemyTeam.id;
                  _loc7_.moveType = UnitCommand.MOVE;
                  _loc7_.arg0 = wingidon.px + wingidon.getDirection() * 100;
                  _loc7_.arg1 = wingidon.py;
                  _loc7_.units.push(wingidon.id);
                  _loc7_.execute(game);
               }
               else if(wingidon.isWingSpell)
               {
                  _loc7_ = new UnitMove();
                  _loc7_.owner = game.team.enemyTeam.id;
                  _loc7_.moveType = UnitCommand.MOVE;
                  this.comment = "check how close enemy is before letting wingidon run right into them like an idiot.";
                  if(Math.abs(closestEnemyUnit.px - wingidon.px) < 200 && true == false)
                  {
                     wingidon.forceFaceDirection(wingidon.px - closestEnemyUnit.px);
                     _loc7_.arg0 = wingidon.px + wingidon.getDirection() * 100;
                  }
                  else
                  {
                     _loc7_.arg0 = wingidon.ai.getIntendedX();
                  }
                  _loc7_.arg1 = wingidon.py;
                  _loc7_.units.push(wingidon.id);
                  _loc7_.execute(game);
               }
            }
         }
         this.wingCounter++;
      }
   }
}
