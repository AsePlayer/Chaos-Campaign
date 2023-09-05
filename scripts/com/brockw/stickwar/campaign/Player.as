package com.brockw.stickwar.campaign
{
     import com.brockw.stickwar.engine.units.*;
     import com.brockw.stickwar.market.ItemMap;
     import flash.utils.Dictionary;
     
     public class Player
     {
           
          
          private var _unitsAvailable:Dictionary;
          
          private var _statue:String;
          
          private var _race:String;
          
          private var _statueHealth:int;
          
          private var _startingUnits:Array;
          
          private var _castleArcherLevel:int;
          
          private var _gold:int;
          
          private var _mana:int;
          
          private var _raceName:String;
          
          public function Player(xml:XMLList)
          {
               var x:* = undefined;
               super();
               this.unitsAvailable = new Dictionary();
               this.race = xml.attribute("race");
               this._statueHealth = xml.attribute("statueHealth");
               this._startingUnits = [];
               for each(x in xml.startingUnit)
               {
                    this._startingUnits.push(ItemMap.unitNameToType(x));
               }
               for each(x in xml.unit)
               {
                    this.unitsAvailable[ItemMap.unitNameToType(x)] = 1;
               }
               this._castleArcherLevel = 0;
               for each(x in xml.castleArcher)
               {
                    this._castleArcherLevel = x;
               }
               if(this.race == "Chaos")
               {
                    this.unitsAvailable[Unit.U_CHAOS_MINER] = 1;
               }
               if(this.race == "Order")
               {
                    this.unitsAvailable[Unit.U_MINER] = 1;
               }
               this.statue = "default";
               this.statue = xml.statue;
               if(this.statue == "")
               {
                    this.statue = "default";
               }
               this._mana = 0;
               this._gold = 500;
               for each(x in xml.mana)
               {
                    this._mana = x;
               }
               for each(x in xml.gold)
               {
                    this._gold = x;
               }
               this.raceName = "Order";
               for each(x in xml.raceName)
               {
                    this.raceName = x;
               }
          }
          
          public function toString() : String
          {
               return this.race;
          }
          
          public function get race() : String
          {
               return this._race;
          }
          
          public function set race(value:String) : void
          {
               this._race = value;
          }
          
          public function get statueHealth() : int
          {
               return this._statueHealth;
          }
          
          public function set statueHealth(value:int) : void
          {
               this._statueHealth = value;
          }
          
          public function get unitsAvailable() : Dictionary
          {
               return this._unitsAvailable;
          }
          
          public function set unitsAvailable(value:Dictionary) : void
          {
               this._unitsAvailable = value;
          }
          
          public function get startingUnits() : Array
          {
               return this._startingUnits;
          }
          
          public function set startingUnits(value:Array) : void
          {
               this._startingUnits = value;
          }
          
          public function get castleArcherLevel() : int
          {
               return this._castleArcherLevel;
          }
          
          public function set castleArcherLevel(value:int) : void
          {
               this._castleArcherLevel = value;
          }
          
          public function get statue() : String
          {
               return this._statue;
          }
          
          public function set statue(value:String) : void
          {
               this._statue = value;
          }
          
          public function get mana() : int
          {
               return this._mana;
          }
          
          public function set mana(value:int) : void
          {
               this._mana = value;
          }
          
          public function get gold() : int
          {
               return this._gold;
          }
          
          public function set gold(value:int) : void
          {
               this._gold = value;
          }
          
          public function get raceName() : String
          {
               return this._raceName;
          }
          
          public function set raceName(value:String) : void
          {
               this._raceName = value;
          }
     }
}
