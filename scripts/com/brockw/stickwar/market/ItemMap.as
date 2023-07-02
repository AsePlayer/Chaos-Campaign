package com.brockw.stickwar.market
{
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.units.*;
   import com.smartfoxserver.v2.entities.data.*;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class ItemMap
   {
      
      private static const races = ["Order","Chaos","Elementals"];
      
      private static const orderUnits = ["Miner","Swordwrath","Archidon","Spearton","Monk","Magikill","Ninja","Flying Crossbowman","Enslaved Giant"];
       
      
      private var _data:Dictionary;
      
      public function ItemMap()
      {
         super();
         this.data = new Dictionary();
      }
      
      public static function getWeaponMcFromString(type:int, unit:String) : MovieClip
      {
         var unitType:int = unitNameToType(unit);
         return getWeaponMcFromId(type,unitType);
      }
      
      public static function getWeaponMcFromId(type:int, unit:int) : MovieClip
      {
         var spear:spearton_spear = null;
         var unitType:int = unit;
         if(unitType == Unit.U_SWORDWRATH)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new itemSword();
            }
         }
         if(unitType == Unit.U_SPEARTON)
         {
            if(type == MarketItem.T_WEAPON)
            {
               spear = new spearton_spear();
               spear.rotation -= 65;
               return spear;
            }
            if(type == MarketItem.T_ARMOR)
            {
               return new spearton_helmet();
            }
            if(type == MarketItem.T_MISC)
            {
               return new spearton_shield();
            }
         }
         if(unitType == Unit.U_KNIGHT)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new knight_weapon();
            }
            if(type == MarketItem.T_ARMOR)
            {
               return new knight_helmet();
            }
            if(type == MarketItem.T_MISC)
            {
               return new knight_shield();
            }
         }
         if(unitType == Unit.U_MINER)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new miner_pickaxe();
            }
            if(type == MarketItem.T_ARMOR)
            {
               return null;
            }
            if(type == MarketItem.T_MISC)
            {
               return new miner_bag();
            }
         }
         if(unitType == Unit.U_CHAOS_MINER)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new chaosminer_pickaxe();
            }
            if(type == MarketItem.T_ARMOR)
            {
               return null;
            }
            if(type == MarketItem.T_MISC)
            {
               return new chaosminer_bag();
            }
         }
         if(unitType == Unit.U_NINJA)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new ninja_bostaff();
            }
            if(type == MarketItem.T_ARMOR)
            {
               return new ninja_head();
            }
            if(type == MarketItem.T_MISC)
            {
               return new ninja_katana();
            }
         }
         if(unitType == Unit.U_MAGIKILL)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new magikill_staff();
            }
            if(type == MarketItem.T_ARMOR)
            {
               return new magikill_hat();
            }
            if(type == MarketItem.T_MISC)
            {
               return new magikill_beard();
            }
         }
         if(unitType == Unit.U_ENSLAVED_GIANT)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new giant_bag();
            }
         }
         if(unitType == Unit.U_MONK)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new cleric_wand();
            }
         }
         if(unitType == Unit.U_BOMBER)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new bomber_dynamite();
            }
            if(type == MarketItem.T_ARMOR)
            {
               return new bombers_head();
            }
         }
         if(unitType == Unit.U_CAT)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new crawler_head();
            }
         }
         if(unitType == Unit.U_GIANT)
         {
            if(type == MarketItem.T_WEAPON)
            {
               return new giant_weapon();
            }
         }
         if(unitType == Unit.U_MEDUSA)
         {
            if(type == MarketItem.T_ARMOR)
            {
               return new medusa_cape();
            }
            if(type == MarketItem.T_MISC)
            {
               return new medusa_crown();
            }
         }
         if(unitType == Unit.U_SKELATOR)
         {
            if(type == MarketItem.T_ARMOR)
            {
               return new skeletor_head();
            }
            if(type == MarketItem.T_WEAPON)
            {
               return new skeletor_staff();
            }
         }
         if(unitType == Unit.U_DEAD)
         {
            if(type == MarketItem.T_ARMOR)
            {
               return new dead_head();
            }
         }
         if(unitType == Unit.U_ARCHER)
         {
            if(type == MarketItem.T_ARMOR)
            {
               return new archidon_head();
            }
            if(type == MarketItem.T_MISC)
            {
               return new archidon_sleve();
            }
         }
         if(unitType == Unit.U_WINGIDON)
         {
            if(type == MarketItem.T_ARMOR)
            {
               return new eclipsor_head();
            }
            if(type == MarketItem.T_MISC)
            {
               return new eclipsor_sleve();
            }
         }
         if(unitType == Unit.U_FLYING_CROSSBOWMAN)
         {
            if(type == MarketItem.T_ARMOR)
            {
               return new allbowtross_head();
            }
            if(type == MarketItem.T_MISC)
            {
               return new allbowtross_frontwing();
            }
            if(type == MarketItem.T_WEAPON)
            {
               return new allbowtross_sleve();
            }
         }
         return null;
      }
      
      public static function unitNameToType(name:String) : int
      {
         if(name == "Miner")
         {
            return Unit.U_MINER;
         }
         if(name == "Swordwrath")
         {
            return Unit.U_SWORDWRATH;
         }
         if(name == "Archidon")
         {
            return Unit.U_ARCHER;
         }
         if(name == "Spearton")
         {
            return Unit.U_SPEARTON;
         }
         if(name == "Ninja")
         {
            return Unit.U_NINJA;
         }
         if(name == "FlyingCrossbowman")
         {
            return Unit.U_FLYING_CROSSBOWMAN;
         }
         if(name == "Monk")
         {
            return Unit.U_MONK;
         }
         if(name == "Magikill")
         {
            return Unit.U_MAGIKILL;
         }
         if(name == "EnslavedGiant")
         {
            return Unit.U_ENSLAVED_GIANT;
         }
         if(name == "ChaosMiner")
         {
            return Unit.U_CHAOS_MINER;
         }
         if(name == "Bomber")
         {
            return Unit.U_BOMBER;
         }
         if(name == "Wingadon")
         {
            return Unit.U_WINGIDON;
         }
         if(name == "SkelatalMage")
         {
            return Unit.U_SKELATOR;
         }
         if(name == "Dead")
         {
            return Unit.U_DEAD;
         }
         if(name == "Cat")
         {
            return Unit.U_CAT;
         }
         if(name == "Knight")
         {
            return Unit.U_KNIGHT;
         }
         if(name == "Medusa")
         {
            return Unit.U_MEDUSA;
         }
         if(name == "Giant")
         {
            return Unit.U_GIANT;
         }
         return -1;
      }
      
      public static function unitTypeToName(type:int) : String
      {
         if(type == Unit.U_MINER)
         {
            return "Miner";
         }
         if(type == Unit.U_SWORDWRATH)
         {
            return "Swordwrath";
         }
         if(type == Unit.U_ARCHER)
         {
            return "Archidon";
         }
         if(type == Unit.U_SPEARTON)
         {
            return "Spearton";
         }
         if(type == Unit.U_NINJA)
         {
            return "Ninja";
         }
         if(type == Unit.U_FLYING_CROSSBOWMAN)
         {
            return "FlyingCrossbowman";
         }
         if(type == Unit.U_MONK)
         {
            return "Monk";
         }
         if(type == Unit.U_MAGIKILL)
         {
            return "Magikill";
         }
         if(type == Unit.U_ENSLAVED_GIANT)
         {
            return "EnslavedGiant";
         }
         if(type == Unit.U_CHAOS_MINER)
         {
            return "ChaosMiner";
         }
         if(type == Unit.U_BOMBER)
         {
            return "Bomber";
         }
         if(type == Unit.U_WINGIDON)
         {
            return "Wingadon";
         }
         if(type == Unit.U_SKELATOR)
         {
            return "SkelatalMage";
         }
         if(type == Unit.U_DEAD)
         {
            return "Dead";
         }
         if(type == Unit.U_CAT)
         {
            return "Cat";
         }
         if(type == Unit.U_KNIGHT)
         {
            return "Knight";
         }
         if(type == Unit.U_MEDUSA)
         {
            return "Medusa";
         }
         if(type == Unit.U_GIANT)
         {
            return "Giant";
         }
         return "";
      }
      
      public static function getUnitsInRace(race:String) : Array
      {
         if(race == "Order")
         {
            return orderUnits;
         }
         return null;
      }
      
      public static function getRaces() : Array
      {
         return races;
      }
      
      public function loadItems(main:Main) : void
      {
         var m:MarketItem = null;
         this._data = new Dictionary();
         for(var i:int = 0; i < main.marketItems.length; i++)
         {
            m = main.marketItems[i];
            this.setItem(unitNameToType(m.unit),m.type,m);
         }
      }
      
      public function getItems(unit:int, part:int) : Array
      {
         if(!(unit in this._data))
         {
            return [];
         }
         if(!(part in this._data[unit]))
         {
            return [];
         }
         return this._data[unit][part];
      }
      
      public function setItem(unit:int, part:int, item:MarketItem) : void
      {
         if(!(unit in this._data))
         {
            this._data[unit] = new Dictionary();
         }
         if(!(part in this._data[unit]))
         {
            this._data[unit][part] = [];
         }
         this._data[unit][part].push(item);
      }
      
      public function get data() : Dictionary
      {
         return this._data;
      }
      
      public function set data(value:Dictionary) : void
      {
         this._data = value;
      }
   }
}
