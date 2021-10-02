package com.brockw.stickwar.market
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Archer;
   import com.brockw.stickwar.engine.units.Bomber;
   import com.brockw.stickwar.engine.units.Cat;
   import com.brockw.stickwar.engine.units.Dead;
   import com.brockw.stickwar.engine.units.EnslavedGiant;
   import com.brockw.stickwar.engine.units.FlyingCrossbowman;
   import com.brockw.stickwar.engine.units.Giant;
   import com.brockw.stickwar.engine.units.Knight;
   import com.brockw.stickwar.engine.units.Magikill;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Miner;
   import com.brockw.stickwar.engine.units.MinerChaos;
   import com.brockw.stickwar.engine.units.Monk;
   import com.brockw.stickwar.engine.units.Ninja;
   import com.brockw.stickwar.engine.units.Skelator;
   import com.brockw.stickwar.engine.units.Spearton;
   import com.brockw.stickwar.engine.units.Swordwrath;
   import com.brockw.stickwar.engine.units.Unit;
   import com.brockw.stickwar.engine.units.Wingidon;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class ArmoryScreen extends Screen
   {
       
      
      var main:Main;
      
      private var _mc:armoryScreenMc;
      
      private var currentCard:ArmoryUnitCard;
      
      private var team:int;
      
      private var unitCards:Array;
      
      private var isMouseDown:Boolean;
      
      private var itemToBuyId:int;
      
      private var itemPreview:MovieClip;
      
      var hasWeapon:Boolean;
      
      var hasArmor:Boolean;
      
      var hasMisc:Boolean;
      
      private var currentEditMarketItem:MarketItem;
      
      public var empirePointsToShow:Number;
      
      private var scrollIndex:int;
      
      private var _isEditMode:Boolean;
      
      private var visibleCount:int;
      
      public function ArmoryScreen(main:Main)
      {
         super();
         this.main = main;
         this.itemPreview = null;
         this.mc = new armoryScreenMc();
         addChild(this.mc);
         this.unitCards = [];
         this.currentCard = null;
         this.team = Team.T_GOOD;
         this.hasWeapon = this.hasArmor = this.hasMisc = true;
         this.empirePointsToShow = 0;
         this.isEditMode = false;
         this.scrollIndex = 0;
         this.visibleCount = 0;
         this.mc.bottomPanel.mouseEnabled = false;
      }
      
      public static function openPayment(type:String, main:Main) : void
      {
         var url:URLRequest = null;
         var result:uint = 0;
         var payment_URL:String = "http://www.stickempires.com/paypal/checkout.php?item=" + type + "&userId=" + main.sfs.mySelf.getVariable("dbid").getIntValue();
         if(type == "membership")
         {
            url = new URLRequest(payment_URL);
            navigateToURL(url,"_blank");
         }
         else if(ExternalInterface.available)
         {
            result = ExternalInterface.call("dg.startFlow",payment_URL);
         }
      }
      
      private function initUnitCard(team:int, unitType:int, mc:MovieClip, c:Class, card:MovieClip) : void
      {
         this.unitCards.push(new ArmoryUnitCard(this.main,team,unitType,mc,c,card));
         this.currentCard = this.unitCards[0];
         this.currentCard.setSelected();
      }
      
      public function initUnitCards() : void
      {
         var unitCard:ArmoryUnitCard = null;
         if(this.currentCard != null)
         {
            this.currentCard.removeUnitProfile(this.mc.unitDisplayBox);
         }
         for each(unitCard in this.unitCards)
         {
            if(this.mc.cardContainer.contains(unitCard))
            {
               this.mc.cardContainer.removeChild(unitCard);
            }
            else
            {
               trace("Would not have cleaned");
            }
         }
         this.unitCards = [];
         this.mc.unlockChaosScreen.visible = false;
         if(this.team == Team.T_GOOD)
         {
            this.initUnitCard(Team.T_GOOD,Unit.U_SWORDWRATH,new _swordwrath(),Swordwrath,new Armory_Swordwrath());
            this.initUnitCard(Team.T_GOOD,Unit.U_ARCHER,new _archer(),Archer,new Armory_Archidon());
            this.initUnitCard(Team.T_GOOD,Unit.U_SPEARTON,new _speartonMc(),Spearton,new Armory_Speartan());
            this.initUnitCard(Team.T_GOOD,Unit.U_MINER,new _miner(),Miner,new Armory_Miner());
            this.initUnitCard(Team.T_GOOD,Unit.U_NINJA,new _ninja(),Ninja,new Armory_Ninja());
            this.initUnitCard(Team.T_GOOD,Unit.U_FLYING_CROSSBOWMAN,new _flyingcrossbowmanMc(),FlyingCrossbowman,new Armory_Flyer());
            this.initUnitCard(Team.T_GOOD,Unit.U_ENSLAVED_GIANT,new _giantMc(),EnslavedGiant,new Armory_Slave_Giant());
            this.initUnitCard(Team.T_GOOD,Unit.U_MAGIKILL,new _magikill(),Magikill,new Armory_Wizard());
            this.initUnitCard(Team.T_GOOD,Unit.U_MONK,new _cleric(),Monk,new Armory_Priest());
         }
         else if(this.team == Team.T_CHAOS)
         {
            if(this.main.isMember)
            {
               this.initUnitCard(Team.T_CHAOS,Unit.U_CAT,new _cat(),Cat,new Armory_Cat());
               this.initUnitCard(Team.T_CHAOS,Unit.U_BOMBER,new _bomber(),Bomber,new Armory_Suicide());
               this.initUnitCard(Team.T_CHAOS,Unit.U_DEAD,new _dead(),Dead,new Armory_Deads());
               this.initUnitCard(Team.T_CHAOS,Unit.U_CHAOS_MINER,new _chaosminer(),MinerChaos,new Armory_Slave_Miner());
               this.initUnitCard(Team.T_CHAOS,Unit.U_KNIGHT,new _knight(),Knight,new Armory_Knight());
               this.initUnitCard(Team.T_CHAOS,Unit.U_WINGIDON,new _wingidon(),Wingidon,new Armory_Wingadon());
               this.initUnitCard(Team.T_CHAOS,Unit.U_GIANT,new _giant(),Giant,new Armory_Giant());
               this.initUnitCard(Team.T_CHAOS,Unit.U_MEDUSA,new _medusaMc(),Medusa,new Armory_Medusa());
               this.initUnitCard(Team.T_CHAOS,Unit.U_SKELATOR,new _skelator(),Skelator,new Armory_Mage());
            }
            else
            {
               this.mc.unlockChaosScreen.visible = true;
            }
         }
         this.updateUnitCards();
         if(this.currentCard != null)
         {
            this.currentCard.setUnitProfile(this.mc.unitDisplayBox);
            this.currentCard.currentItemType = this.currentCard.currentItemType;
         }
      }
      
      private function updateUnitCards(slide:Boolean = false) : void
      {
         var unitCard:ArmoryUnitCard = null;
         var rate:Number = NaN;
         var i:int = 0;
         this.visibleCount = 0;
         for each(unitCard in this.unitCards)
         {
            if(!this.mc.cardContainer.contains(unitCard))
            {
               this.mc.cardContainer.addChild(unitCard);
            }
            if(unitCard.currentItems.length != 0)
            {
               unitCard.x = 111;
               rate = 1;
               if(slide)
               {
                  rate = 0.3;
               }
               unitCard.y += (143 + (this.visibleCount++ - this.scrollIndex) * 147 - unitCard.y) * rate;
               unitCard.visible = true;
            }
            else
            {
               unitCard.visible = false;
               unitCard.y = 900;
            }
            i++;
         }
      }
      
      public function update(evt:Event) : void
      {
         var _loc3_:ArmoryUnitCard = null;
         var _loc4_:int = 0;
         var _loc5_:ArmoryUnitCard = null;
         var _loc2_:int = 0;
         this.mc.downButton.enabled = true;
         this.mc.upButton.enabled = true;
         this.mc.upButton.mouseEnabled = true;
         this.mc.downButton.mouseEnabled = true;
         this.mc.downButton.visible = true;
         this.mc.upButton.visible = true;
         this.mc.upDisabled.visible = false;
         this.mc.downDisabled.visible = false;
         _loc2_ = this.scrollIndex + 2;
         _loc2_ = Math.min(this.visibleCount - 3,_loc2_);
         _loc2_ = Math.max(_loc2_,0);
         if(_loc2_ == this.scrollIndex)
         {
            this.mc.downButton.enabled = false;
            this.mc.downButton.mouseEnabled = false;
            this.mc.downButton.visible = false;
            this.mc.downDisabled.visible = true;
         }
         _loc2_ = this.scrollIndex - 2;
         _loc2_ = Math.max(_loc2_,0);
         if(_loc2_ == this.scrollIndex)
         {
            this.mc.upButton.enabled = false;
            this.mc.upButton.mouseEnabled = false;
            this.mc.upButton.visible = false;
            this.mc.upDisabled.visible = true;
         }
         this.mc.empiresPoints.text = "" + Math.round(this.empirePointsToShow);
         this.empirePointsToShow += (this.main.empirePoints - this.empirePointsToShow) * 0.1;
         this.updateUnitCards(true);
         if(!this.isUnlocking())
         {
            if(this.team == Team.T_GOOD)
            {
               this.mc.teamBanner.gotoAndStop(1);
            }
            else
            {
               this.mc.teamBanner.gotoAndStop(2);
            }
            this.mc.orderButton.gotoAndStop(1);
            this.mc.chaosButton.gotoAndStop(1);
            if(this.mc.orderButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
            {
               this.mc.orderButton.gotoAndStop(2);
               if(this.isMouseDown)
               {
                  this.team = Team.T_GOOD;
                  this.initUnitCards();
               }
            }
            else if(this.mc.chaosButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
            {
               this.mc.chaosButton.gotoAndStop(2);
               if(this.isMouseDown)
               {
                  this.team = Team.T_CHAOS;
                  this.initUnitCards();
               }
            }
            if(this.team == Team.T_GOOD)
            {
               this.mc.orderButton.gotoAndStop(3);
            }
            else if(this.team == Team.T_CHAOS)
            {
               this.mc.chaosButton.gotoAndStop(3);
            }
            if(this.currentCard != null)
            {
               _loc4_ = this.currentCard.currentItemType;
               if(this.mc.weaponButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
               {
                  if(this.isMouseDown && this.hasWeapon)
                  {
                     for each(_loc5_ in this.unitCards)
                     {
                        _loc5_.currentItemType = MarketItem.T_WEAPON;
                     }
                     this.scrollIndex = 0;
                     this.updateUnitCards();
                  }
                  this.mc.weaponButton.gotoAndStop(2);
               }
               else
               {
                  this.mc.weaponButton.gotoAndStop(1);
               }
               if(this.mc.armorButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
               {
                  if(this.isMouseDown && this.hasArmor)
                  {
                     for each(_loc5_ in this.unitCards)
                     {
                        _loc5_.currentItemType = MarketItem.T_ARMOR;
                     }
                     this.scrollIndex = 0;
                     this.updateUnitCards();
                  }
                  this.mc.armorButton.gotoAndStop(2);
               }
               else
               {
                  this.mc.armorButton.gotoAndStop(1);
               }
               if(this.mc.miscButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
               {
                  if(this.isMouseDown && this.hasMisc)
                  {
                     for each(_loc5_ in this.unitCards)
                     {
                        _loc5_.currentItemType = MarketItem.T_MISC;
                     }
                     this.scrollIndex = 0;
                     this.updateUnitCards();
                  }
                  this.mc.miscButton.gotoAndStop(2);
               }
               else
               {
                  this.mc.miscButton.gotoAndStop(1);
               }
               if(_loc4_ == MarketItem.T_WEAPON)
               {
                  this.mc.weaponButton.gotoAndStop(3);
               }
               else if(_loc4_ == MarketItem.T_ARMOR)
               {
                  this.mc.armorButton.gotoAndStop(3);
               }
               else if(_loc4_ == MarketItem.T_MISC)
               {
                  this.mc.miscButton.gotoAndStop(3);
               }
            }
            if(this.main.isMember)
            {
               this._mc.paymentScreen.membershipButton.alpha = 0.2;
               this._mc.paymentScreen.membershipButton.enabled = false;
            }
            else
            {
               this._mc.paymentScreen.membershipButton.alpha = 1;
               this._mc.paymentScreen.membershipButton.enabled = true;
            }
         }
         for each(_loc3_ in this.unitCards)
         {
            if(!this.isUnlocking())
            {
               if(_loc3_.isSelected)
               {
                  _loc3_.setSelected();
                  if(_loc3_.hitTestPoint(stage.mouseX,stage.mouseY,true))
                  {
                     _loc3_.setHover();
                  }
               }
               else if(_loc3_.hitTestPoint(stage.mouseX,stage.mouseY,true))
               {
                  if(this.isMouseDown)
                  {
                     this.currentCard.setNotSelected();
                     this.currentCard.removeUnitProfile(this.mc.unitDisplayBox);
                     _loc3_.setSelected();
                     this.currentCard = _loc3_;
                     this.currentCard.setUnitProfile(this.mc.unitDisplayBox);
                     _loc3_.setHover();
                  }
                  else
                  {
                     _loc3_.setHover();
                  }
               }
               else
               {
                  _loc3_.setNotSelected();
               }
            }
            _loc3_.update();
         }
         this.isMouseDown = false;
      }
      
      private function mouseDown(evt:Event) : void
      {
         this.isMouseDown = true;
      }
      
      public function receiveEmpirePoints(points:int, isMember:Boolean, justBought:Boolean) : void
      {
         trace("received empiresPoints",isMember,justBought);
         this.main.empirePoints = points;
         this.main.isMember = isMember;
         if(justBought)
         {
            this.mc.paymentScreen.visible = false;
            this.main.soundManager.playSoundFullVolume("newEmpirePoints");
         }
         else
         {
            this.empirePointsToShow = this.main.empirePoints;
         }
         this.initUnitCards();
      }
      
      override public function enter() : void
      {
         this.main.setOverlayScreen("chatOverlay");
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("paymentCompleteExt",this.paymentComplete);
         }
         this.mc.pillar.mouseEnabled = false;
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.addEventListener(Event.ENTER_FRAME,this.update);
         this.mc.unlockMc.closeButton.addEventListener(MouseEvent.CLICK,this.closeUnlock);
         this.mc.unlockMc.unlockButton.addEventListener(MouseEvent.CLICK,this.unlockButton);
         this.mc.itemUnlockResult.doneButton.addEventListener(MouseEvent.CLICK,this.closeItemResult);
         this.mc.editCard.closeButton.addEventListener(MouseEvent.CLICK,this.closeEditCard);
         this.mc.editCard.updateButton.addEventListener(MouseEvent.CLICK,this.updateEditCard);
         this.mc.paymentScreen.closeButton.addEventListener(MouseEvent.CLICK,this.closePaymentScreen);
         this.mc.addPointsButton.addEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.mc.upButton.addEventListener(MouseEvent.CLICK,this.upButton);
         this.mc.downButton.addEventListener(MouseEvent.CLICK,this.downButton);
         this.mc.unlockChaosScreen.membershipButton.addEventListener(MouseEvent.CLICK,this.membershipButton);
         this.initUnitCards();
         stage.frameRate = 30;
         this.main.sfs.send(new ExtensionRequest("getLoadout",null));
         this.main.sfs.send(new ExtensionRequest("getEmpirePoints",null));
         this.mc.unlockMc.visible = false;
         this.mc.itemUnlockResult.visible = false;
         this.mc.editCard.visible = false;
         this.mc.paymentScreen.visible = false;
      }
      
      private function downButton(evt:Event) : void
      {
         this.scrollIndex += 2;
         this.scrollIndex = Math.min(this.visibleCount - 3,this.scrollIndex);
         this.scrollIndex = Math.max(this.scrollIndex,0);
      }
      
      private function upButton(evt:Event) : void
      {
         this.scrollIndex -= 2;
         this.scrollIndex = Math.max(this.scrollIndex,0);
      }
      
      public function openPaymentScreen(evt:Event) : void
      {
         this.mc.paymentScreen.visible = true;
         this.mc.paymentScreen.paymentButton1.addEventListener(MouseEvent.CLICK,this.paymentButton1);
         this.mc.paymentScreen.paymentButton2.addEventListener(MouseEvent.CLICK,this.paymentButton2);
         this.mc.paymentScreen.paymentButton3.addEventListener(MouseEvent.CLICK,this.paymentButton3);
         this.mc.paymentScreen.membershipButton.addEventListener(MouseEvent.CLICK,this.membershipButton);
      }
      
      public function paymentComplete(responseText:*) : void
      {
         this.mc.paymentScreen.visible = false;
         this.mc.itemUnlockResult.visible = true;
         this.mc.itemUnlockResult.resultText.text = responseText;
      }
      
      private function membershipButton(evt:Event) : void
      {
         if(!this.main.isMember)
         {
            openPayment("membership",this.main);
         }
      }
      
      private function paymentButton1(evt:Event) : void
      {
         openPayment("ep1",this.main);
      }
      
      private function paymentButton2(evt:Event) : void
      {
         openPayment("ep2",this.main);
      }
      
      private function paymentButton3(evt:Event) : void
      {
         openPayment("ep3",this.main);
      }
      
      private function closePaymentScreen(evt:Event) : void
      {
         this.mc.paymentScreen.visible = false;
         this.mc.paymentScreen.paymentButton1.removeEventListener(MouseEvent.CLICK,this.paymentButton1);
      }
      
      private function updateEditCard(evt:Event) : void
      {
         var s:SFSObject = new SFSObject();
         s.putUtfString("name",this.currentEditMarketItem.name);
         s.putInt("id",this.currentEditMarketItem.id);
         s.putUtfString("unit",this.currentEditMarketItem.unit);
         s.putUtfString("description",this.mc.editCard.description.text);
         s.putInt("price",int(this.mc.editCard.price.text));
         s.putInt("type",this.currentEditMarketItem.type);
         s.putUtfString("displayName",this.mc.editCard.displayName.text);
         this.main.sfs.send(new ExtensionRequest("setMarketItem",s));
         this.mc.editCard.visible = false;
      }
      
      public function openEditCard(m:MarketItem) : void
      {
         this.mc.editCard.visible = true;
         this.mc.editCard.nameText.text = m.name;
         this.mc.editCard.id.text = "" + m.id;
         this.mc.editCard.unitType.text = m.unit;
         this.mc.editCard.description.text = m.description;
         this.mc.editCard.price.text = "" + m.price;
         this.mc.editCard.displayName.text = "" + m.displayName;
         if(m.type == MarketItem.T_ARMOR)
         {
            this.mc.editCard.itemType.text = "Armour";
         }
         else if(m.type == MarketItem.T_WEAPON)
         {
            this.mc.editCard.itemType.text = "Weapon";
         }
         else if(m.type == MarketItem.T_MISC)
         {
            this.mc.editCard.itemType.text = "Misc";
         }
         this.mc.removeChild(this.mc.editCard);
         this.mc.addChild(this.mc.editCard);
         this.currentEditMarketItem = m;
      }
      
      private function closeEditCard(e:Event) : void
      {
         this.mc.editCard.visible = false;
      }
      
      private function closeItemResult(evt:MouseEvent) : void
      {
         this.mc.itemUnlockResult.visible = false;
      }
      
      public function buyResponse(result:int) : void
      {
         this.mc.itemUnlockResult.visible = true;
         if(result == 1)
         {
            this.mc.itemUnlockResult.resultText.text = "Item Unlocked!";
            this.mc.itemUnlockResult.description.text = "";
         }
         else
         {
            this.mc.itemUnlockResult.resultText.text = "Item Unlock Failed";
            this.mc.itemUnlockResult.description.text = "Not enough Empire Coins to purchase item!";
         }
         this.mc.removeChild(this.mc.itemUnlockResult);
         this.mc.addChild(this.mc.itemUnlockResult);
      }
      
      public function isUnlocking() : Boolean
      {
         return this.mc.unlockMc.visible == true || this.mc.itemUnlockResult.visible == true || this.mc.editCard.visible == true || this.mc.paymentScreen.visible == true;
      }
      
      public function showUnlock(empirePoints:int, cost:int, unit:int, itemId:int, type:int, weaponName:String) : void
      {
         this.mc.unlockMc.visible = true;
         this.mc.unlockMc.current.text = "" + empirePoints;
         this.mc.unlockMc.cost.text = "" + cost;
         this.mc.unlockMc.empiresPoints.text = "" + cost;
         this.mc.unlockMc.balance.text = "" + (empirePoints - cost);
         if(this.itemPreview != null)
         {
            this.mc.unlockMc.removeChild(this.itemPreview);
         }
         this.itemPreview = ItemMap.getWeaponMcFromId(type,unit);
         this.itemPreview.gotoAndStop(weaponName);
         this.mc.unlockMc.addChild(this.itemPreview);
         var b1:Rectangle = this.itemPreview.getBounds(this.mc.unlockMc);
         this.itemPreview.x += this.mc.unlockMc.displayBox.x - b1.left;
         this.itemPreview.y += this.mc.unlockMc.displayBox.y - b1.top;
         this.itemPreview.x += (this.mc.unlockMc.displayBox.width - this.itemPreview.width) / 2;
         this.itemPreview.y += (this.mc.unlockMc.displayBox.height - this.itemPreview.height) / 2;
         this.itemToBuyId = itemId;
         var unlockMc:MovieClip = this.mc.unlockMc;
         this.mc.removeChild(unlockMc);
         this.mc.addChild(unlockMc);
      }
      
      private function unlockButton(evt:Event) : void
      {
         var s:SFSObject = new SFSObject();
         s.putInt("itemId",this.itemToBuyId);
         this.main.sfs.send(new ExtensionRequest("buy",s));
         this.mc.unlockMc.visible = false;
      }
      
      private function closeUnlock(evt:Event) : void
      {
         this.mc.unlockMc.visible = false;
      }
      
      override public function leave() : void
      {
         this.mc.paymentScreen.closeButton.removeEventListener(MouseEvent.CLICK,this.closePaymentScreen);
         this.mc.addPointsButton.removeEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.removeEventListener(Event.ENTER_FRAME,this.update);
         this.mc.unlockMc.closeButton.removeEventListener(MouseEvent.CLICK,this.closeUnlock);
         this.mc.unlockMc.unlockButton.removeEventListener(MouseEvent.CLICK,this.unlockButton);
         this.mc.itemUnlockResult.doneButton.removeEventListener(MouseEvent.CLICK,this.closeItemResult);
         this.mc.editCard.closeButton.removeEventListener(MouseEvent.CLICK,this.closeEditCard);
         this.mc.editCard.updateButton.removeEventListener(MouseEvent.CLICK,this.updateEditCard);
         this.mc.upButton.removeEventListener(MouseEvent.CLICK,this.upButton);
         this.mc.downButton.removeEventListener(MouseEvent.CLICK,this.downButton);
         this.mc.unlockChaosScreen.membershipButton.removeEventListener(MouseEvent.CLICK,this.membershipButton);
      }
      
      public function saveLoadout() : void
      {
         var s:SFSObject = this.main.loadout.toSFSObject();
         this.main.sfs.send(new ExtensionRequest("saveLoadout",s));
      }
      
      public function get mc() : armoryScreenMc
      {
         return this._mc;
      }
      
      public function set mc(value:armoryScreenMc) : void
      {
         this._mc = value;
      }
      
      public function get isEditMode() : Boolean
      {
         return this._isEditMode;
      }
      
      public function set isEditMode(value:Boolean) : void
      {
         this._isEditMode = value;
      }
   }
}
