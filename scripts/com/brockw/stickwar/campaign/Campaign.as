package com.brockw.stickwar.campaign
{
   import com.brockw.stickwar.engine.Team.Tech;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class Campaign
   {
      
      public static const CampaignConstants:Class = Campaign_CampaignConstants;
      
      public static const D_NORMAL:int = 1;
      
      public static const D_HARD:int = 2;
      
      public static const D_INSANE:int = 3;
       
      
      public var xml:XML;
      
      private var _levels:Array;
      
      private var _currentLevel:int;
      
      public var upgradeMap:Dictionary;
      
      private var _justTutorial:Boolean;
      
      public var campaignPoints:int;
      
      public var techAllowed:Dictionary;
      
      public var difficultyLevel:int;
      
      public var isAutoSaveEnabled:Boolean;
      
      public var techTreeFix:Boolean;
      
      public function Campaign(skipToLevel:int, difficulty:int)
      {
         var x:* = undefined;
         super();
         this.levels = [];
         this.techAllowed = new Dictionary();
         this.campaignPoints = 0;
         var file:ByteArray = new Campaign.CampaignConstants();
         var str:String = file.readUTFBytes(file.length);
         this.xml = new XML(str);
         for each(x in this.xml.level)
         {
            this.levels.push(new Level(x));
         }
         this.currentLevel = skipToLevel;
         this.campaignPoints = skipToLevel;
         this.initUpgradeTree();
         this.difficultyLevel = difficulty;
         this.justTutorial = false;
         this.isAutoSaveEnabled = false;
      }
      
      private function getDifficultyDescription() : String
      {
         if(this.difficultyLevel == Campaign.D_NORMAL)
         {
            return "normal";
         }
         if(this.difficultyLevel == Campaign.D_HARD)
         {
            return "hard";
         }
         if(this.difficultyLevel == Campaign.D_INSANE)
         {
            return "insane";
         }
         return "";
      }
      
      public function getLevelDescription() : String
      {
         return "level" + this.currentLevel + "_" + this.getDifficultyDescription();
      }
      
      public function isGameFinished() : Boolean
      {
         return this.currentLevel >= this.levels.length;
      }
      
      private function initUpgradeTree() : void
      {
         var u:CampaignUpgrade = null;
         this.upgradeMap = new Dictionary();
         u = new CampaignUpgrade("Castle Archer I",[],["Rage"],Tech.CASTLE_ARCHER_1);
         this.upgradeMap[u.name] = u;
         u.upgraded = true;
         this.techAllowed[u.tech] = 1;
         u = new CampaignUpgrade("Rage",["Castle Archer I"],["Block","Passive Income I"],Tech.MEDUSA_POISON);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Block",["Rage"],["Shield Bash"],Tech.MINER_SPEED);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Shield Bash",["Block"],["Fire Arrow","Cloak"],Tech.CAT_SPEED);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Fire Arrow",["Shield Bash"],["Giant Growth I"],Tech.MINER_TOWER);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Giant Growth I",["Fire Arrow"],["Giant Growth II"],Tech.CHAOS_GIANT_GROWTH_I);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Giant Growth II",["Giant Growth I"],[],Tech.CHAOS_GIANT_GROWTH_II);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Cloak_BASIC",["Shield Bash"],[],Tech.CLOAK);
         this.upgradeMap[u.name] = u;
         u.upgraded = true;
         u = new CampaignUpgrade("Cloak",["Shield Bash"],[],Tech.CAT_PACK);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Passive Income I",["Rage"],["Miner Speed","Castle Archer II"],Tech.KNIGHT_CHARGE);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Miner Speed",["Passive Income I"],["Passive Income II","Cure"],Tech.BANK_PASSIVE_1);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Passive Income II",["Miner Speed"],["Tower Spawn I"],Tech.TOWER_SPAWN_I);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Tower Spawn I",["Passive Income II"],["Tower Spawn II"],Tech.TOWER_SPAWN_II);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Tower Spawn II",["Tower Spawn I"],[],Tech.SKELETON_FIST_ATTACK);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Castle Archer II",["Passive Income I"],["Castle Archer III"],Tech.CASTLE_ARCHER_2);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Castle Archer III",["Castle Archer II"],["Miner Wall"],Tech.CASTLE_ARCHER_3);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Miner Wall",["Castle Archer III"],["Statue Health"],Tech.DEAD_POISON);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Statue Health",["Miner Wall"],["Castle Archer IV"],Tech.STATUE_HEALTH);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Cure",["Miner Speed"],["Electric Wall"],Tech.BANK_PASSIVE_2);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Electric Wall",["Cure"],["Poison Spray"],Tech.BANK_PASSIVE_3);
         this.upgradeMap[u.name] = u;
         u = new CampaignUpgrade("Poison Spray",["Electric Wall"],[],Tech.MAGIKILL_POISON);
         this.upgradeMap[u.name] = u;
      }
      
      public function toString() : String
      {
         return "Camapign: " + this.currentLevel;
      }
      
      public function XMLLoader() : void
      {
      }
      
      public function getCurrentLevel() : Level
      {
         return this.levels[this._currentLevel];
      }
      
      public function get currentLevel() : int
      {
         return this._currentLevel;
      }
      
      public function set currentLevel(value:int) : void
      {
         this._currentLevel = value;
      }
      
      public function setDifficulty(n:int) : void
      {
         this.difficultyLevel = n;
      }
      
      public function save() : void
      {
         var u:CampaignUpgrade = null;
         var levels:Array = null;
         var l:Level = null;
         var level:Object = null;
         var cookie:SharedObject = SharedObject.getLocal("stickempiresSave");
         cookie.data.currentLevel = this.currentLevel;
         cookie.data.campaignPoints = this.campaignPoints;
         cookie.data.difficultyLevel = this.difficultyLevel;
         var tech:Array = new Array();
         trace("techs");
         for each(u in this.upgradeMap)
         {
            if(u.upgraded)
            {
               tech.push(u.name);
            }
         }
         levels = new Array();
         for each(l in this.levels)
         {
            level = new Object();
            level["bestTime"] = l.bestTime;
            level["totalTime"] = l.totalTime;
            level["retries"] = l.retries;
            levels.push(level);
         }
         cookie.data.levels = levels;
         cookie.data.techAllowed = tech;
         cookie.flush();
         trace("Saved the game");
      }
      
      public function saveGameExists() : Boolean
      {
         var cookie:SharedObject = SharedObject.getLocal("stickempiresSave");
         return cookie.data.currentLevel > 0;
      }
      
      public function load() : void
      {
         var t:String = null;
         var i:int = 0;
         var level:Object = null;
         var l:Level = null;
         var cookie:SharedObject = SharedObject.getLocal("stickempiresSave");
         if(cookie.data.currentLevel <= 0)
         {
            return;
         }
         this.currentLevel = cookie.data.currentLevel;
         this.campaignPoints = int(int(int(int(int(int(int(int(int(int(int(cookie.data.campaignPoints)))))))))));
         this.difficultyLevel = int(int(int(int(int(int(int(int(int(int(int(cookie.data.difficultyLevel)))))))))));
         var tech:Array = new Array();
         for each(t in cookie.data.techAllowed)
         {
            this.upgradeMap[t].upgraded = 1;
            this.techAllowed[this.upgradeMap[t].tech] = 1;
         }
         i = 0;
         for each(level in cookie.data.levels)
         {
            l = Level(this.levels[i]);
            l.retries = int(int(int(int(int(int(int(int(int(int(int(level["retries"])))))))))));
            l.totalTime = int(int(int(int(int(int(int(int(int(int(int(level["totalTime"])))))))))));
            l.bestTime = int(int(int(int(int(int(int(int(int(int(int(level["bestTime"])))))))))));
            i++;
         }
         cookie.data.levels = this.levels;
         trace("Loaded campaign at level ",this.currentLevel);
         this.techTreeFix = true;
      }
      
      public function get justTutorial() : Boolean
      {
         return this._justTutorial;
      }
      
      public function set justTutorial(value:Boolean) : void
      {
         this._justTutorial = value;
      }
      
      public function get levels() : Array
      {
         return this._levels;
      }
      
      public function set levels(value:Array) : void
      {
         this._levels = value;
      }
   }
}
