package com.brockw.stickwar.engine.multiplayer
{
     import com.brockw.game.Screen;
     import com.brockw.stickwar.BaseMain;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     import com.smartfoxserver.v2.requests.ExtensionRequest;
     import fl.controls.ScrollPolicy;
     import flash.events.Event;
     import flash.events.MouseEvent;
     import flash.net.URLRequest;
     import flash.net.navigateToURL;
     import flash.text.StyleSheet;
     
     public class FAQScreen extends Screen
     {
           
          
          internal var mc:faqScreenMc;
          
          internal var main:BaseMain;
          
          internal var faqText:Object;
          
          public function FAQScreen(main:BaseMain)
          {
               var styleObj:Object = null;
               super();
               this.main = main;
               this.mc = new faqScreenMc();
               addChild(this.mc);
               var style:StyleSheet = new StyleSheet();
               styleObj = new Object();
               styleObj.color = "#ebb73a";
               style.setStyle(".question",styleObj);
               styleObj = new Object();
               styleObj.color = "#FFFFFF";
               style.setStyle(".answer",styleObj);
               this.mc.faq.styleSheet = style;
               this.mc.faq.htmlText = "";
               this.faqText = this.mc.faq;
               this.mc.faq.mouseWheelEnabled = false;
               this.mc.scrollPane.source = this.mc.faq;
               this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
               this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
          }
          
          public function loadFAQ(data:SFSObject) : void
          {
               this.faqText.htmlText = data.getUtfString("faq");
          }
          
          override public function enter() : void
          {
               this.main.sfs.send(new ExtensionRequest("getFAQ"));
               addEventListener(Event.ENTER_FRAME,this.update);
               this.mc.playButton.addEventListener(MouseEvent.CLICK,this.gameGuide);
          }
          
          private function gameGuide(evt:Event) : void
          {
               var url:URLRequest = new URLRequest("http://www.stickpage.com/stickempiresguide.shtml");
               if(Boolean(this.main.tracker))
               {
                    this.main.tracker.trackEvent("link","http://www.stickpage.com/stickempiresguide.shtml");
               }
               navigateToURL(url,"_blank");
          }
          
          public function update(evt:Event) : void
          {
               this.mc.scrollPane.update();
               this.faqText.height = this.faqText.textHeight + 100;
          }
          
          override public function leave() : void
          {
               removeEventListener(MouseEvent.CLICK,this.update);
          }
     }
}
