package com.brockw.stickwar.engine.Team
{
   import flash.display.Bitmap;
   
   public class TechItem
   {
       
      
      public var researchTime:int;
      
      public var cost:int;
      
      public var mc:Bitmap;
      
      public var f:Function;
      
      public var hotKey:int;
      
      public var tip:String;
      
      public var mana:int;
      
      public var xmlInfo:XMLList;
      
      public var name:String;
      
      public function TechItem(info:XMLList, mc:Bitmap)
      {
         super();
         this.xmlInfo = info;
         this.mana = this.xmlInfo.mana;
         this.researchTime = this.xmlInfo.time;
         this.cost = this.xmlInfo.cost;
         this.mc = mc;
         this.f = this.f;
         this.hotKey = this.xmlInfo.hotKey;
         this.tip = this.xmlInfo.tip;
         this.name = this.xmlInfo.name;
      }
      
      public function upgrade() : void
      {
         this.f();
      }
   }
}
