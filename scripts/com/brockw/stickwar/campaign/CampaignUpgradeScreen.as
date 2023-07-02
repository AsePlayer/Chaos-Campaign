package com.brockw.stickwar.campaign
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.BaseMain;
   import com.brockw.stickwar.engine.Team.Order.TeamGood;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.Team.TechItem;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class CampaignUpgradeScreen extends Screen
   {
       
      
      private var main:BaseMain;
      
      private var mc:campaignUpgradeScreenMc;
      
      private var buttonMap:Dictionary;
      
      private var clicked:Boolean;
      
      private var team:Team;
      
      private var timeOfLastUpdate:int;
      
      internal var good:Team;
      
      public function CampaignUpgradeScreen(main:BaseMain)
      {
         super();
         this.main = main;
         this.mc = new campaignUpgradeScreenMc();
         addChild(this.mc);
         this.timeOfLastUpdate = getTimer();
         this.initButtonMap();
      }
      
      private function setUpButton(txt:String, button:MovieClip) : void
      {
         this.buttonMap[txt] = button;
         button.buttonMode = true;
         button.mouseChildren = false;
         button.gotoAndStop(1);
      }
      
      private function initButtonMap() : void
      {
         this.buttonMap = new Dictionary();
         this.setUpButton("Castle Archer I",this.mc.button1);
         this.setUpButton("Rage",this.mc.button2);
         this.setUpButton("Passive Income I",this.mc.button3);
         this.setUpButton("Block",this.mc.button4);
         this.setUpButton("Miner Speed",this.mc.button5);
         this.setUpButton("Castle Archer II",this.mc.button6);
         this.setUpButton("Shield Bash",this.mc.button7);
         this.setUpButton("Cure",this.mc.button8);
         this.setUpButton("Passive Income II",this.mc.button9);
         this.setUpButton("Castle Archer III",this.mc.button10);
         this.setUpButton("Fire Arrow",this.mc.button11);
         this.setUpButton("Cloak",this.mc.button12);
         this.setUpButton("Electric Wall",this.mc.button13);
         this.setUpButton("Miner Wall",this.mc.button14);
         this.setUpButton("Statue Health",this.mc.button15);
         this.setUpButton("Giant Growth I",this.mc.button16);
         this.setUpButton("Giant Growth II",this.mc.button20);
         this.setUpButton("Tower Spawn II",this.mc.button18);
         this.setUpButton("Tower Spawn I",this.mc.button19);
      }
      
      private function update(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:CampaignUpgrade = null;
         var _loc4_:TechItem = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         if(this.mc.confirmTech.visible)
         {
            return;
         }
         this.mc.campaignPoints.text = "" + this.main.campaign.campaignPoints;
         if(this.main.campaign.campaignPoints == 0)
         {
            this.mc.campaignPoints.text = "0";
         }
         for(_loc2_ in this.buttonMap)
         {
            _loc3_ = CampaignUpgrade(this.main.campaign.upgradeMap[_loc2_]);
            _loc4_ = this.good.tech.upgrades[this.main.campaign.upgradeMap[_loc2_].tech];
            if(_loc4_ && this.buttonMap[_loc2_].hitTestPoint(stage.mouseX,stage.mouseY,false))
            {
               this.mc.infoBox.text.text = _loc4_.tip;
            }
            _loc5_ = true;
            if(this.main.campaign.upgradeMap[_loc2_].upgraded)
            {
               _loc5_ = false;
               this.buttonMap[_loc2_].gotoAndStop(3);
            }
            for each(_loc6_ in this.main.campaign.upgradeMap[_loc2_].parents)
            {
               if(!this.main.campaign.upgradeMap[_loc6_].upgraded)
               {
                  _loc5_ = false;
               }
            }
            if(_loc5_)
            {
               this.buttonMap[_loc2_].gotoAndStop(2);
               this.buttonMap[_loc2_].alpha = 1;
            }
            else if(!this.main.campaign.upgradeMap[_loc2_].upgraded)
            {
               this.buttonMap[_loc2_].alpha = 0.5;
            }
            if(this.main.campaign.campaignPoints == 0)
            {
               _loc5_ = false;
            }
            if(_loc5_ && MovieClip(this.buttonMap[_loc2_]).hitTestPoint(stage.mouseX,stage.mouseY,false) && this.clicked)
            {
               this.main.campaign.upgradeMap[_loc2_].upgraded = true;
               _loc3_ = CampaignUpgrade(this.main.campaign.upgradeMap[_loc2_]);
               this.main.campaign.techAllowed[_loc3_.tech] = 1;
               --this.main.campaign.campaignPoints;
               this.main.soundManager.playSoundFullVolume("ArmoryEquipSound");
            }
         }
         this.clicked = false;
      }
      
      override public function maySwitchOnDisconnect() : Boolean
      {
         return false;
      }
      
      private function mapButton(evt:Event) : void
      {
         if(this.main.campaign.campaignPoints != 0)
         {
            this.mc.confirmTech.visible = true;
         }
         else
         {
            this.main.showScreen("campaignMap",false,true);
         }
         this.main.soundManager.playSoundFullVolume("clickButton");
      }
      
      private function click(evt:Event) : void
      {
         this.clicked = true;
      }
      
      private function yesButton(evt:Event) : void
      {
         this.mc.confirmTech.visible = false;
         this.main.showScreen("campaignMap",false,true);
      }
      
      private function noButton(evt:Event) : void
      {
         this.mc.confirmTech.visible = false;
      }
      
      override public function enter() : void
      {
         this.good = new TeamGood(this.main.stickWar,10);
         this.main.soundManager.playSoundInBackground("loginMusic");
         stage.frameRate = 30;
         addEventListener(Event.ENTER_FRAME,this.update);
         addEventListener(MouseEvent.CLICK,this.click);
         this.mc.start.addEventListener(MouseEvent.CLICK,this.mapButton);
         this.mc.confirmTech.visible = false;
         this.mc.confirmTech.yesButton.addEventListener(MouseEvent.CLICK,this.yesButton);
         this.mc.confirmTech.noButton.addEventListener(MouseEvent.CLICK,this.noButton);
         if(this.main.campaign.campaignPoints == 0)
         {
            this.main.showScreen("campaignMap",false,true);
         }
      }
      
      override public function leave() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.update);
         removeEventListener(MouseEvent.CLICK,this.click);
         this.mc.start.removeEventListener(MouseEvent.CLICK,this.mapButton);
         this.mc.confirmTech.yesButton.removeEventListener(MouseEvent.CLICK,this.yesButton);
         this.mc.confirmTech.noButton.removeEventListener(MouseEvent.CLICK,this.noButton);
      }
   }
}
