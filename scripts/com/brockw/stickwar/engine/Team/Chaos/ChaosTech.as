package com.brockw.stickwar.engine.Team.Chaos
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.Team.TechItem;
   import flash.display.Bitmap;
   import flash.utils.Dictionary;
   
   public class ChaosTech extends Tech
   {
       
      
      private var game:StickWar;
      
      public function ChaosTech(game:StickWar, team:TeamChaos)
      {
         this.game = game;
         this.team = team;
         this.initTech(game);
         this.initUpgrades(game,team);
         super(game,team);
      }
      
      public function initTech(game:StickWar) : void
      {
      }
      
      private function addNewUpgrade(updgradeType:int, upgrade:XMLList, button:Bitmap, hotKey:int) : void
      {
         upgrades[updgradeType] = new TechItem(upgrade,button);
      }
      
      public function initUpgrades(game:StickWar, team:TeamChaos) : void
      {
         researchingMap = new Object();
         upgrades = new Dictionary();
         this.addNewUpgrade(CASTLE_ARCHER_1,game.xml.xml.Chaos.Tech.castleArchers1,new Bitmap(new castleArcherLevel1Bitmap()),81);
         this.addNewUpgrade(CASTLE_ARCHER_2,game.xml.xml.Chaos.Tech.castleArchers2,new Bitmap(new castleArcherLevel2Bitmap()),81);
         this.addNewUpgrade(CASTLE_ARCHER_3,game.xml.xml.Chaos.Tech.castleArchers3,new Bitmap(new castleArcherLevel3Bitmap()),81);
         this.addNewUpgrade(DEAD_POISON,game.xml.xml.Chaos.Tech.deadPoison,new Bitmap(new poisonGutsBitmap()),81);
         this.addNewUpgrade(CAT_PACK,game.xml.xml.Chaos.Tech.catPack,new Bitmap(new packMentalityBitmap()),81);
         this.addNewUpgrade(MEDUSA_POISON,game.xml.xml.Chaos.Tech.medusaPoison,new Bitmap(new poisonPoolBitmap()),81);
         this.addNewUpgrade(KNIGHT_CHARGE,game.xml.xml.Chaos.Tech.knightCharge,new Bitmap(new knightChargeBitmap()),81);
         this.addNewUpgrade(SKELETON_FIST_ATTACK,game.xml.xml.Chaos.Tech.skeletonFistAttack,new Bitmap(new skeletalFistBitmap()),81);
         this.addNewUpgrade(STATUE_HEALTH,game.xml.xml.Chaos.Tech.statueHealth,new Bitmap(new statueHealthBitmap()),81);
         this.addNewUpgrade(BANK_PASSIVE_1,game.xml.xml.Order.Tech.passiveIncomeGold1,new Bitmap(new passiveIncomeBitmap()),89);
         this.addNewUpgrade(BANK_PASSIVE_2,game.xml.xml.Order.Tech.passiveIncomeGold2,new Bitmap(new passiveIncomeBitmap()),89);
         this.addNewUpgrade(BANK_PASSIVE_3,game.xml.xml.Order.Tech.passiveIncomeGold3,new Bitmap(new passiveIncomeBitmap()),89);
         this.addNewUpgrade(MINER_SPEED,game.xml.xml.Order.Tech.minerSpeed,new Bitmap(new minerBagBitmap()),81);
         this.addNewUpgrade(CHAOS_GIANT_GROWTH_I,game.xml.xml.Chaos.Tech.giantSize1,new Bitmap(new giantLevel1Bitmap()),81);
         this.addNewUpgrade(CHAOS_GIANT_GROWTH_II,game.xml.xml.Chaos.Tech.giantSize2,new Bitmap(new giantLevel2Bitmap()),81);
         this.addNewUpgrade(MINER_TOWER,game.xml.xml.Chaos.Tech.minerTower,new Bitmap(new ChaosTowerBitmap()),87);
         this.addNewUpgrade(CAT_SPEED,game.xml.xml.Chaos.Tech.catSpeed,new Bitmap(new CrawlerSpeedBitmap()),87);
         this.addNewUpgrade(TOWER_SPAWN_I,game.xml.xml.Chaos.Tech.towerSpawnI,new Bitmap(new towerUpgradeI()),89);
         this.addNewUpgrade(TOWER_SPAWN_II,game.xml.xml.Chaos.Tech.towerSpawnII,new Bitmap(new towerUpgradeII()),89);
      }
      
      override public function update(game:StickWar) : void
      {
         super.update(game);
      }
      
      override public function isResearching(type:int) : Boolean
      {
         return type in researchingMap;
      }
      
      override public function getResearchCooldown(type:int) : Number
      {
         return researchingMap[type] / upgrades[type].researchTime;
      }
   }
}
