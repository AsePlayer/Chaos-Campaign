package com.brockw.stickwar.market
{
   import com.smartfoxserver.v2.entities.data.*;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class Loadout
   {
       
      
      private var _data:Dictionary;
      
      public function Loadout()
      {
         super();
         this.data = new Dictionary();
      }
      
      public function toString() : String
      {
         var unit:String = null;
         var part:String = null;
         var loadoutString:String = "";
         for(unit in this.data)
         {
            loadoutString += unit + ":";
            for(part in this.data[unit])
            {
               loadoutString += part + ";" + this.data[unit][part] + "-";
            }
            loadoutString += "|";
         }
         return loadoutString;
      }
      
      public function toSFSObject() : SFSObject
      {
         var s:SFSObject = new SFSObject();
         var loadoutString:String = this.toString();
         s.putUtfString("loadout",loadoutString);
         return s;
      }
      
      public function fromSFSObject(s:SFSObject) : void
      {
         var l:String = s.getUtfString("loadout");
         this.fromString(l);
      }
      
      public function fromString(s:String) : void
      {
         var unitData:Array = null;
         var unit:int = 0;
         var weaponString:* = undefined;
         var weaponArray:* = undefined;
         var j:int = 0;
         var weaponData:Array = null;
         var weapon:MovieClip = null;
         var hasLabel:Boolean = false;
         var f:FrameLabel = null;
         var l:String = s;
         var units:Array = l.split("|");
         this._data = new Dictionary();
         for(var i:int = 0; i < units.length; i++)
         {
            if(units[i] != "")
            {
               unitData = units[i].split(":");
               if(unitData.length != 0)
               {
                  unit = int(unitData[0]);
                  weaponString = unitData[1];
                  weaponArray = weaponString.split("-");
                  for(j = 0; j < weaponArray.length; j++)
                  {
                     if(weaponArray[j] != "")
                     {
                        weaponData = weaponArray[j].split(";");
                        if(weaponData.length != 0)
                        {
                           trace(unit,int(weaponData[0]));
                           weapon = ItemMap.getWeaponMcFromId(int(weaponData[0]),unit);
                           hasLabel = false;
                           for each(f in weapon.currentLabels)
                           {
                              if(f.name == weaponData[1])
                              {
                                 hasLabel = true;
                              }
                           }
                           if(hasLabel)
                           {
                              trace("HAS LABEL");
                              this.setItem(unit,int(weaponData[0]),weaponData[1]);
                           }
                           else
                           {
                              trace("DOES NOT HAVE LABEL");
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function unitHasDefaultLoadout(unit:int) : Boolean
      {
         return this.getItem(unit,MarketItem.T_WEAPON) == "Default" && this.getItem(unit,MarketItem.T_ARMOR) == "Default" && this.getItem(unit,MarketItem.T_MISC) == "Default";
      }
      
      public function getItem(unit:int, part:int) : String
      {
         if(!(unit in this._data))
         {
            return "Default";
         }
         if(!(part in this._data[unit]))
         {
            return "Default";
         }
         return this._data[unit][part];
      }
      
      public function setItem(unit:int, part:int, name:String) : void
      {
         if(!(unit in this._data))
         {
            this._data[unit] = new Dictionary();
         }
         if(!(part in this._data[unit]))
         {
            this._data[unit][part] = new Dictionary();
         }
         this._data[unit][part] = name;
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
