package com.brockw.stickwar.campaign
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.Security;
   
   public class YoutubeLoader extends MovieClip
   {
       
      
      private var my_player:Object;
      
      private var hadError:Boolean;
      
      private var ready:Boolean;
      
      public function YoutubeLoader(link:String)
      {
         var my_loader:Loader = null;
         var onLoaderInit:Function = null;
         var onError:Function = null;
         var onPlayerReady:Function = null;
         onLoaderInit = function(e:Event):void
         {
            addChild(my_loader);
            my_player = my_loader.content;
            my_player.addEventListener("onReady",onPlayerReady);
            my_player.addEventListener("onError",onError);
         };
         onError = function(e:Event):void
         {
            hadError = true;
            trace("YOUTUBE LOADER HAD ERROR");
         };
         onPlayerReady = function(e:Event):void
         {
            my_player.setSize(640,360);
            my_player.loadVideoById(link,0);
            my_player.stopVideo();
            ready = true;
         };
         super();
         Security.allowDomain("www.youtube.com");
         this.ready = false;
         my_loader = new Loader();
         my_loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
         my_loader.contentLoaderInfo.addEventListener(Event.INIT,onLoaderInit);
         this.hadError = false;
      }
      
      public function isWorking() : Boolean
      {
         return !this.hadError && this.ready;
      }
      
      public function playVideo() : void
      {
         if(this.ready)
         {
            this.my_player.playVideo();
         }
      }
      
      public function stopVideo() : void
      {
         if(this.ready)
         {
            this.my_player.stopVideo();
         }
      }
      
      public function pauseVideo() : void
      {
         if(this.ready)
         {
            this.my_player.pauseVideo();
         }
      }
      
      public function getTimePlayed() : Number
      {
         if(this.ready)
         {
            return this.my_player.getCurrentTime();
         }
         return 0;
      }
   }
}
