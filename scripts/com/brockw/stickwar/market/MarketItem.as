package com.brockw.stickwar.market
{
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   
   public class MarketItem extends MovieClip
   {
      
      public static const T_WEAPON:int = 0;
      
      public static const T_ARMOR:int = 1;
      
      public static const T_MISC:int = 2;
      
      private static const W_WIDTH:Number = 93.95;
      
      private static const W_HEIGHT:Number = 100;
       
      
      public var unit:String;
      
      public var type:int;
      
      public var price:int;
      
      public var description:String;
      
      public var mc:MovieClip;
      
      public var id:int;
      
      public var marketMc:marketBox;
      
      public var isOwned:Boolean;
      
      public var displayName:String;
      
      private var card:ArmoryUnitCard;
      
      public function MarketItem(s:SFSObject)
      {
         super();
         this.marketMc = new marketBox();
         this.readFromSFSObject(s);
         this.isOwned = false;
         this.card = this.card;
         this.marketMc.unlockDisplay.unlockButton.addEventListener(MouseEvent.CLICK,this.unlock,false,0,true);
         this.marketMc.useDisplay.useButton.addEventListener(MouseEvent.CLICK,this.useButton,false,0,true);
         this.marketMc.editButton.addEventListener(MouseEvent.CLICK,this.editButton,false,0,true);
      }
      
      public function cleanUp() : void
      {
         this.marketMc.unlockDisplay.unlockButton.removeEventListener(MouseEvent.CLICK,this.unlock);
         this.marketMc.useDisplay.useButton.removeEventListener(MouseEvent.CLICK,this.useButton);
         this.marketMc.editButton.removeEventListener(MouseEvent.CLICK,this.editButton);
      }
      
      private function editButton(evt:Event) : void
      {
         this.card.main.armourScreen.openEditCard(this);
      }
      
      public function setCard(card:ArmoryUnitCard) : void
      {
         this.card = card;
      }
      
      private function unlock(evt:Event) : void
      {
         if(!this.card.main.armourScreen.isUnlocking())
         {
            this.card.main.armourScreen.showUnlock(this.card.main.empirePoints,this.price,ItemMap.unitNameToType(this.unit),this.id,this.type,this.mc.currentFrameLabel);
         }
      }
      
      private function useButton(evt:Event) : void
      {
         if(!this.card.main.armourScreen.isUnlocking())
         {
            this.card.equip(ItemMap.unitNameToType(this.unit),this.type,name);
         }
      }
      
      public function update(main:Main) : void
      {
         if(main.armourScreen.isEditMode)
         {
            this.marketMc.editButton.visible = true;
         }
         else
         {
            this.marketMc.editButton.visible = false;
         }
         if(this.id == -1)
         {
            this.marketMc.useDisplay.visible = false;
            this.marketMc.armedDisplay.visible = false;
            this.marketMc.unlockDisplay.visible = false;
         }
         else if(main.purchases.indexOf(this.id) == -1)
         {
            this.marketMc.useDisplay.visible = false;
            this.marketMc.armedDisplay.visible = false;
            this.marketMc.unlockDisplay.visible = true;
            this.marketMc.unlockDisplay.empiresPoints.text = "" + this.price;
         }
         else if(main.loadout.getItem(ItemMap.unitNameToType(this.unit),this.type) == name)
         {
            this.marketMc.useDisplay.visible = false;
            this.marketMc.armedDisplay.visible = true;
            this.marketMc.unlockDisplay.visible = false;
         }
         else
         {
            this.marketMc.useDisplay.visible = true;
            this.marketMc.armedDisplay.visible = false;
            this.marketMc.unlockDisplay.visible = false;
         }
      }
      
      public function readFromSFSObject(s:SFSObject) : void
      {
         var frame:FrameLabel = null;
         this.id = s.getInt("id");
         this.unit = s.getUtfString("unit");
         name = s.getUtfString("name");
         this.type = s.getInt("type");
         this.description = s.getUtfString("description");
         this.price = s.getInt("price");
         this.displayName = s.getUtfString("displayName");
         this.mc = ItemMap.getWeaponMcFromString(this.type,this.unit);
         var found:Boolean = false;
         for each(frame in this.mc.currentLabels)
         {
            if(frame.name == name)
            {
               found = true;
            }
         }
         if(!found)
         {
            name = "Default";
         }
         var glowColor:Number = 0;
         var glowAlpha:Number = 0.5;
         var glowBlurX:Number = 14;
         var glowBlurY:Number = 14;
         var glowStrength:Number = 1;
         var glowQuality:Number = BitmapFilterQuality.LOW;
         var glowInner:Boolean = false;
         var glowKnockout:Boolean = false;
         var gf:GlowFilter = new GlowFilter(glowColor,glowAlpha,glowBlurX,glowBlurY,glowStrength,glowQuality,glowInner,glowKnockout);
         this.mc.filters = [gf];
         this.marketMc.displayBox.addChild(this.mc);
         this.mc.gotoAndStop(name);
         var scale:Number = 0.8;
         if(Math.abs(W_WIDTH / this.mc.width) < Math.abs(W_HEIGHT / this.mc.height))
         {
            scale = W_WIDTH / this.mc.width;
         }
         else
         {
            scale = W_HEIGHT / this.mc.height;
         }
         this.mc.scaleX = scale;
         this.mc.scaleY = scale;
         var b1:Rectangle = this.mc.getBounds(this.marketMc);
         this.mc.x -= b1.left;
         this.mc.y -= b1.top;
         this.mc.x += (W_WIDTH - b1.width) / 2;
         this.mc.y += (W_HEIGHT - b1.height) / 2;
         addChild(this.marketMc);
      }
      
      override public function toString() : String
      {
         return String(name) + " for " + String(this.unit);
      }
   }
}
