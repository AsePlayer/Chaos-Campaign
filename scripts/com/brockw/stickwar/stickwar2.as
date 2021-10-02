package com.brockw.stickwar
{
   import com.brockw.game.XMLLoader;
   import com.brockw.stickwar.campaign.Campaign;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.campaign.CampaignMenuScreen;
   import com.brockw.stickwar.campaign.CampaignScreen;
   import com.brockw.stickwar.campaign.CampaignUpgradeScreen;
   import com.brockw.stickwar.campaign.EndOfGameSummary;
   import com.brockw.stickwar.engine.multiplayer.PostGameScreen;
   import com.google.analytics.GATracker;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.system.Security;
   
   [Frame(factoryClass="com.brockw.stickwar.CampaignPreloader")]
   [SWF(frameRate="30",width="850",height="700")]
   public class stickwar2 extends BaseMain
   {
       
      
      private var campaignMenuScreen:CampaignMenuScreen;
      
      private var campaignUpgradeScreen:CampaignUpgradeScreen;
      
      private var _postGameScreen:PostGameScreen;
      
      public function stickwar2()
      {
         super();
         var xmlLoader:XMLLoader = new XMLLoader();
         this.xml = xmlLoader;
         isCampaignDebug = xmlLoader.xml.campaignDebug == 1;
         postGameScreen = new PostGameScreen(this);
         addScreen("postGame",postGameScreen);
         addScreen("campaignMap",new CampaignScreen(this));
         addScreen("campaignGameScreen",new CampaignGameScreen(this));
         addScreen("campaignUpgradeScreen",this.campaignUpgradeScreen = new CampaignUpgradeScreen(this));
         addScreen("summary",new EndOfGameSummary(this));
         addScreen("mainMenu",this.campaignMenuScreen = new CampaignMenuScreen(this));
         this.campaign = new Campaign(0,0);
         this.addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      private function addedToStage(evt:Event) : void
      {
         var paramObj:Object = null;
         var apiPath:String = null;
         var request:URLRequest = null;
         var loader:Loader = null;
         showScreen("mainMenu");
         tracker = null;
         if(ExternalInterface.available)
         {
            tracker = new GATracker(this,"UA-36522838-2","AS3",false);
            tracker.trackPageview("/play");
            tracker.trackEvent("hostname","url",stage.loaderInfo.url);
         }
         if(xml.xml.isKongregate == 1)
         {
            paramObj = LoaderInfo(stage.root.loaderInfo).parameters;
            apiPath = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
            isKongregate = true;
            Security.allowDomain(apiPath);
            request = new URLRequest(apiPath);
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete);
            loader.load(request);
            this.addChild(loader);
         }
      }
      
      function loadComplete(event:Event) : void
      {
         kongregate = event.target.content;
         kongregate.services.connect();
      }
   }
}
