package com.brockw.stickwar.market
{
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.units.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.Dictionary;
   
   public class ArmoryUnitCard extends armoryCardMc
   {
      
      private static var hasChanged:Boolean = false;
       
      
      private var _unitMc:MovieClip;
      
      private var team:int;
      
      private var unitClass:Class;
      
      private var _unitType:int;
      
      private var _currentItemType:int;
      
      private var _main:Main;
      
      private var _isSelected:Boolean;
      
      private var _currentItems:Array;
      
      private var profileMc:MovieClip;
      
      private var itemPositionX:Number;
      
      private var itemPositionXReal:Number;
      
      private var hoverOverCard:Boolean;
      
      private var itemMap:Dictionary;
      
      private var viewingIndex:int;
      
      private var lastSentCount:int;
      
      public function ArmoryUnitCard(main:Main, team:int, unitType:int, unitMc:MovieClip, c:Class, unitProfileMc:MovieClip)
      {
         super();
         this.main = main;
         this.unitType = unitType;
         this.team = team;
         this._unitMc = unitMc;
         this.addChild(unitProfileMc);
         this.profileMc = unitProfileMc;
         unitProfileMc.x = 79.5;
         unitProfileMc.y = 72;
         this.itemPositionXReal = this.itemPositionX = 0;
         this.unitClass = c;
         this.currentItemType = MarketItem.T_WEAPON;
         x += width / 2;
         y += height / 2;
         this.isSelected = false;
         this.unitName.visible = false;
         this.currentItems = [];
         this.setNotSelected();
         this._unitMc.scaleX *= -1;
         this.hoverOverCard = false;
         this.changeItemList();
         this.itemMap = new Dictionary();
         this.itemMap[MarketItem.T_WEAPON] = "";
         this.itemMap[MarketItem.T_ARMOR] = "";
         this.itemMap[MarketItem.T_MISC] = "";
         this.addEventListener(MouseEvent.CLICK,this.click);
         leftArrow.addEventListener(MouseEvent.CLICK,this.leftArrowClick,false,0,true);
         rightArrow.addEventListener(MouseEvent.CLICK,this.rightArrowClick,false,0,true);
         this.viewingIndex = 0;
         this.lastSentCount = 1000;
      }
      
      private function leftArrowClick(evt:Event) : void
      {
         this.viewingIndex -= 2;
         this.viewingIndex = Math.max(this.viewingIndex,0);
      }
      
      private function rightArrowClick(evt:Event) : void
      {
         this.viewingIndex += 2;
         this.viewingIndex = Math.min(this.currentItems.length - 4,this.viewingIndex);
         this.viewingIndex = Math.max(this.viewingIndex,0);
      }
      
      public function cleanUp() : void
      {
         var marketItem:MarketItem = null;
         this.removeEventListener(MouseEvent.CLICK,this.click);
         leftArrow.removeEventListener(MouseEvent.CLICK,this.leftArrowClick);
         rightArrow.removeEventListener(MouseEvent.CLICK,this.rightArrowClick);
         for each(marketItem in this.currentItems)
         {
            if(this.displayContainer.contains(marketItem))
            {
               displayContainer.removeChild(marketItem);
            }
            marketItem.cleanUp();
         }
      }
      
      public function click(evt:MouseEvent) : void
      {
      }
      
      public function unlockPrompt(unit:int, type:int, name:String) : void
      {
      }
      
      public function equip(unit:int, type:int, name:String) : void
      {
         this.main.loadout.setItem(unit,type,name);
         this.updateUnitProfile();
         this.main.armourScreen.saveLoadout();
         this.main.soundManager.playSoundFullVolume("ArmoryEquipSound");
      }
      
      public function setUnitProfile(armorScreen:MovieClip) : void
      {
         if(!armorScreen.contains(this._unitMc))
         {
            armorScreen.addChild(this._unitMc);
         }
         this._unitMc.x = 0;
         this._unitMc.y = 0;
         this.updateUnitProfile();
      }
      
      public function updateUnitProfile() : void
      {
         if(this.currentItems.length != 0)
         {
            if(this.unitType == Unit.U_SWORDWRATH)
            {
               Swordwrath.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_NINJA)
            {
               Ninja.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_SPEARTON)
            {
               Spearton.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_KNIGHT)
            {
               Knight.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_ENSLAVED_GIANT)
            {
               EnslavedGiant.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_MAGIKILL)
            {
               Magikill.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_MONK)
            {
               Monk.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_BOMBER)
            {
               Bomber.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_CAT)
            {
               Cat.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_GIANT)
            {
               Giant.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_MEDUSA)
            {
               Medusa.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_SKELATOR)
            {
               Skelator.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_ARCHER)
            {
               Archer.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_FLYING_CROSSBOWMAN)
            {
               FlyingCrossbowman.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_WINGIDON)
            {
               Wingidon.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_DEAD)
            {
               Dead.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
            }
            else if(this.unitType == Unit.U_MINER)
            {
               Miner.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
               this._unitMc.x = -80;
            }
            else if(this.unitType == Unit.U_CHAOS_MINER)
            {
               MinerChaos.setItem(this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
               this._unitMc.x = -80;
            }
         }
      }
      
      public function removeUnitProfile(armorScreen:MovieClip) : void
      {
         if(armorScreen.contains(this._unitMc))
         {
            armorScreen.removeChild(this._unitMc);
         }
      }
      
      public function changeType(type:int) : void
      {
         this.viewingIndex = 0;
         if(this.currentItemType != type)
         {
            this.currentItemType = type;
         }
      }
      
      private function sortOnCost(m1:MarketItem, m2:MarketItem) : int
      {
         return m1.price - m2.price;
      }
      
      private function includeMisc() : Boolean
      {
         if(this.unitType == Unit.U_SPEARTON && this.currentItemType == MarketItem.T_ARMOR)
         {
            return true;
         }
         if(this.unitType == Unit.U_KNIGHT && this.currentItemType == MarketItem.T_ARMOR)
         {
            return true;
         }
         if(this.unitType == Unit.U_NINJA && this.currentItemType == MarketItem.T_WEAPON)
         {
            return true;
         }
         return false;
      }
      
      private function dontShowMisc() : Boolean
      {
         if(this.unitType == Unit.U_SPEARTON)
         {
            return true;
         }
         if(this.unitType == Unit.U_KNIGHT)
         {
            return true;
         }
         if(this.unitType == Unit.U_NINJA)
         {
            return true;
         }
         return false;
      }
      
      private function changeItemList() : void
      {
         var m:MarketItem = null;
         var labels:Array = null;
         var mc:MovieClip = null;
         var label:FrameLabel = null;
         var s:SFSObject = null;
         this.viewingIndex = 0;
         this.lastSentCount = 1000;
         for each(m in this.currentItems)
         {
            if(this.displayContainer.contains(m))
            {
               displayContainer.removeChild(m);
            }
         }
         this.currentItems = [];
         labels = [];
         if(this.currentItemType != MarketItem.T_MISC || !this.dontShowMisc())
         {
            for each(m in this.main.itemMap.getItems(this.unitType,this.currentItemType))
            {
               this.currentItems.push(m);
               labels.push(m.name);
               m.setCard(this);
            }
         }
         var miscLabels:Array = [];
         if(this.includeMisc())
         {
            for each(m in this.main.itemMap.getItems(this.unitType,MarketItem.T_MISC))
            {
               this.currentItems.push(m);
               miscLabels.push(m.name);
               m.setCard(this);
            }
         }
         this.currentItems.sort(this.sortOnCost);
         if(this.currentItemType != MarketItem.T_MISC || !this.dontShowMisc())
         {
            mc = ItemMap.getWeaponMcFromId(this._currentItemType,this.unitType);
            if(mc != null && this.main.sfs.mySelf.getVariable("isAdmin").getIntValue() == 1 && this.main.armourScreen.isEditMode)
            {
               for each(label in mc.currentLabels)
               {
                  if(labels.indexOf(label.name) == -1)
                  {
                     s = new SFSObject();
                     s.putInt("id",-1);
                     s.putUtfString("unit",ItemMap.unitTypeToName(this.unitType));
                     s.putUtfString("name",label.name);
                     s.putInt("type",this.currentItemType);
                     s.putUtfString("description","");
                     s.putUtfString("displayName",label.name);
                     s.putInt("price",-1);
                     trace(ItemMap.unitTypeToName(this.unitType),label.name);
                     m = new MarketItem(s);
                     this.currentItems.unshift(m);
                     m.setCard(this);
                  }
               }
            }
         }
         if(this.includeMisc())
         {
            mc = ItemMap.getWeaponMcFromId(MarketItem.T_MISC,this.unitType);
            if(mc != null && this.main.sfs.mySelf.getVariable("isAdmin").getIntValue() == 1 && this.main.armourScreen.isEditMode)
            {
               for each(label in mc.currentLabels)
               {
                  if(miscLabels.indexOf(label.name) == -1)
                  {
                     s = new SFSObject();
                     s.putInt("id",-1);
                     s.putUtfString("unit",ItemMap.unitTypeToName(this.unitType));
                     s.putUtfString("name",label.name);
                     s.putInt("type",MarketItem.T_MISC);
                     s.putUtfString("description","");
                     s.putUtfString("displayName",label.name);
                     s.putInt("price",-1);
                     m = new MarketItem(s);
                     this.currentItems.unshift(m);
                     m.setCard(this);
                  }
               }
            }
         }
         this.itemPositionX = 0;
         this.itemPositionXReal = 600;
      }
      
      public function update() : void
      {
         var m:MarketItem = null;
         var item:MarketItem = null;
         var s:SFSObject = null;
         if(this.main.hasReceivedPurchases && this.lastSentCount++ > 1000)
         {
            for each(item in this.currentItems)
            {
               if(item.price == 0 && this.main.purchases.indexOf(item.id) == -1)
               {
                  s = new SFSObject();
                  s.putInt("itemId",item.id);
                  this.main.sfs.send(new ExtensionRequest("buy",s));
               }
            }
            this.lastSentCount = 0;
         }
         this.itemMap[MarketItem.T_WEAPON] = this.main.loadout.getItem(this.unitType,MarketItem.T_WEAPON);
         this.itemMap[MarketItem.T_ARMOR] = this.main.loadout.getItem(this.unitType,MarketItem.T_ARMOR);
         this.itemMap[MarketItem.T_MISC] = this.main.loadout.getItem(this.unitType,MarketItem.T_MISC);
         this._unitMc.gotoAndStop(1);
         this.itemPositionX = -this.viewingIndex * 100;
         this.itemPositionXReal += (this.itemPositionX - this.itemPositionXReal) * 0.3;
         var i:int = 0;
         var isHover:Boolean = false;
         for each(m in this.currentItems)
         {
            m.update(this.main);
            if(!this.main.armourScreen.isUnlocking())
            {
               if(m.hitTestPoint(stage.mouseX,stage.mouseY,false))
               {
                  this.itemMap[m.type] = m.name;
                  isHover = true;
               }
            }
            if(!this.displayContainer.contains(m))
            {
               displayContainer.addChild(m);
               this.itemPositionXReal += (this.itemPositionX - this.itemPositionXReal) * 1;
            }
            m.x = this.itemPositionXReal + 123 + i * 100;
            m.y = 10;
            i++;
         }
         this.updateUnitProfile();
         if(this.hoverOverCard)
         {
            this.leftArrow.visible = true;
            this.rightArrow.visible = true;
         }
         else
         {
            this.leftArrow.visible = false;
            this.rightArrow.visible = false;
         }
         this.hoverOverCard = false;
      }
      
      public function select() : void
      {
         var m:MarketItem = null;
         this.isSelected = true;
         var s:String = this.main.loadout.getItem(this.unitType,this._currentItemType);
         for each(m in this.currentItems)
         {
            if(m.name == s)
            {
               this.itemMap[this.currentItemType] = m.name;
               this.updateUnitProfile();
            }
         }
      }
      
      public function setSelected() : void
      {
         this.background.gotoAndStop(3);
         this.profileMc.gotoAndStop(3);
         this.select();
      }
      
      public function setHover() : void
      {
         this.hoverOverCard = true;
         this.background.gotoAndStop(2);
         this.profileMc.gotoAndStop(2);
      }
      
      public function setNotSelected() : void
      {
         this.background.gotoAndStop(1);
         this.profileMc.gotoAndStop(1);
         this.isSelected = false;
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(value:Boolean) : void
      {
         this._isSelected = value;
      }
      
      public function get currentItemType() : int
      {
         return this._currentItemType;
      }
      
      public function set currentItemType(value:int) : void
      {
         this._currentItemType = value;
         this.changeItemList();
      }
      
      public function get unitType() : int
      {
         return this._unitType;
      }
      
      public function set unitType(value:int) : void
      {
         this._unitType = value;
      }
      
      public function get main() : Main
      {
         return this._main;
      }
      
      public function set main(value:Main) : void
      {
         this._main = value;
      }
      
      public function get currentItems() : Array
      {
         return this._currentItems;
      }
      
      public function set currentItems(value:Array) : void
      {
         this._currentItems = value;
      }
   }
}
