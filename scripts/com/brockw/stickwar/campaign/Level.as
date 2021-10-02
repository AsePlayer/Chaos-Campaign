package com.brockw.stickwar.campaign
{
   import com.brockw.stickwar.campaign.controllers.CampaignArcher;
   import com.brockw.stickwar.campaign.controllers.CampaignBomber;
   import com.brockw.stickwar.campaign.controllers.CampaignCutScene1;
   import com.brockw.stickwar.campaign.controllers.CampaignCutScene2;
   import com.brockw.stickwar.campaign.controllers.CampaignDeads;
   import com.brockw.stickwar.campaign.controllers.CampaignKnight;
   import com.brockw.stickwar.campaign.controllers.CampaignShadow;
   import com.brockw.stickwar.campaign.controllers.CampaignTutorial;
   import com.brockw.stickwar.market.ItemMap;
   
   public class Level
   {
       
      
      public var title:String;
      
      public var mapName:int;
      
      public var storyName:String;
      
      public var player:Player;
      
      public var oponent:Player;
      
      public var controller:Class;
      
      public var points:int;
      
      private var _normalDamageModifier:Number;
      
      private var _normalModifier:Number;
      
      private var _hardModifier:Number;
      
      private var _insaneModifier:Number;
      
      private var _normalHealthModifier:Number;
      
      private var _tip:String;
      
      private var _unlocks:Array;
      
      private var _levelXml:XML;
      
      private var _hasInsaneWall:Boolean;
      
      public var totalTime:int;
      
      public var bestTime:int;
      
      public var retries:int;
      
      public function Level(xml:XML)
      {
         var _loc3_:* = undefined;
         super();
         this.title = xml.attribute("title");
         this.mapName = xml.attribute("map");
         this.storyName = xml.attribute("story");
         this.points = xml.attribute("points");
         this._levelXml = xml;
         var _loc2_:* = xml.attribute("controller");
         if(_loc2_ == "CampaignTutorial")
         {
            this.controller = CampaignTutorial;
         }
         else if(_loc2_ == "CampaignCutScene1")
         {
            this.controller = CampaignCutScene1;
         }
         else if(_loc2_ == "CampaignCutScene2")
         {
            this.controller = CampaignCutScene2;
         }
         else if(_loc2_ == "CampaignBomber")
         {
            this.controller = CampaignBomber;
         }
         else if(_loc2_ == "CampaignShadow")
         {
            this.controller = CampaignShadow;
         }
         else if(_loc2_ == "CampaignDeads")
         {
            this.controller = CampaignDeads;
         }
         else if(_loc2_ == "CampaignKnight")
         {
            this.controller = CampaignKnight;
         }
         else if(_loc2_ == "CampaignArcher")
         {
            this.controller = CampaignArcher;
         }
         this.unlocks = [];
         for each(_loc3_ in xml.unlock)
         {
            this.unlocks.push(int(ItemMap.unitNameToType(_loc3_)));
         }
         this.player = new Player(xml.player);
         this.oponent = new Player(xml.oponent);
         this.normalModifier = xml.normal;
         this.hardModifier = xml.hard;
         this.insaneModifier = xml.insane;
         this.normalHealthScale = xml.normalHealthScale;
         this.normalDamageModifier = 1;
         for each(_loc3_ in xml.normalDamageScale)
         {
            this.normalDamageModifier = _loc3_;
         }
         this.tip = xml.tip;
         this.totalTime = 0;
         this.bestTime = -1;
         this.retries = 0;
         this.hasInsaneWall = xml.hasInsaneWall == true;
      }
      
      public function get normalDamageModifier() : Number
      {
         return this._normalDamageModifier;
      }
      
      public function set normalDamageModifier(value:Number) : void
      {
         this._normalDamageModifier = value;
      }
      
      public function get hasInsaneWall() : Boolean
      {
         return this._hasInsaneWall;
      }
      
      public function set hasInsaneWall(value:Boolean) : void
      {
         this._hasInsaneWall = value;
      }
      
      public function updateTime(time:Number) : void
      {
         if(this.bestTime == -1)
         {
            this.bestTime = time;
         }
         else if(time < this.bestTime)
         {
            this.bestTime = time;
         }
         this.totalTime += time;
         ++this.retries;
      }
      
      public function toString() : String
      {
         var s:String = "Level: " + this.title + " (" + this.mapName + ")";
         s += "\nPlayer: " + this.player;
         return s + ("\nOponent: " + this.oponent);
      }
      
      public function get normalModifier() : Number
      {
         return this._normalModifier;
      }
      
      public function set normalModifier(value:Number) : void
      {
         this._normalModifier = value;
      }
      
      public function get hardModifier() : Number
      {
         return this._hardModifier;
      }
      
      public function set hardModifier(value:Number) : void
      {
         this._hardModifier = value;
      }
      
      public function get insaneModifier() : Number
      {
         return this._insaneModifier;
      }
      
      public function set insaneModifier(value:Number) : void
      {
         this._insaneModifier = value;
      }
      
      public function get normalHealthScale() : Number
      {
         return this._normalHealthModifier;
      }
      
      public function set normalHealthScale(value:Number) : void
      {
         this._normalHealthModifier = value;
      }
      
      public function get tip() : String
      {
         return this._tip;
      }
      
      public function set tip(value:String) : void
      {
         this._tip = value;
      }
      
      public function get unlocks() : Array
      {
         return this._unlocks;
      }
      
      public function set unlocks(value:Array) : void
      {
         this._unlocks = value;
      }
      
      public function get levelXml() : XML
      {
         return this._levelXml;
      }
      
      public function set levelXml(value:XML) : void
      {
         this._levelXml = value;
      }
   }
}
