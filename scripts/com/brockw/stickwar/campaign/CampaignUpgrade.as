package com.brockw.stickwar.campaign
{
   public class CampaignUpgrade
   {
       
      
      public var parents:Array;
      
      public var children:Array;
      
      public var tech:int;
      
      public var name:String;
      
      public var upgraded:Boolean;
      
      public function CampaignUpgrade(name:String, parents:Array, children:Array, tech:int)
      {
         super();
         this.name = name;
         this.parents = parents;
         this.children = children;
         this.tech = tech;
         this.upgraded = false;
      }
   }
}
