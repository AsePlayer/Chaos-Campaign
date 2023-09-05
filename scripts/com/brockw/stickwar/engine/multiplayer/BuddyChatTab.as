package com.brockw.stickwar.engine.multiplayer
{
     import com.brockw.stickwar.Main;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     import com.smartfoxserver.v2.requests.ExtensionRequest;
     import fl.controls.ScrollPolicy;
     import flash.events.Event;
     import flash.events.MouseEvent;
     
     public class BuddyChatTab extends buddyChatMc
     {
           
          
          public var id:int;
          
          private var _isMinimized:Boolean;
          
          internal var main:Main;
          
          private var _buddy:com.brockw.stickwar.engine.multiplayer.Buddy;
          
          public function BuddyChatTab(id:int, main:Main)
          {
               super();
               this.main = main;
               this._isMinimized = false;
               this.id = id;
               this.chatWindow.visible = true;
               this.chatWindow.chatInput.addEventListener(Event.CHANGE,this.sendChatMessage);
               this.chatWindow.chatInput.text = "";
               this.chatWindow.chatOutput.text = "";
               this.buddyText.mouseEnabled = false;
               this.buddy = null;
               this.chatWindow.chatOutput.mouseWheelEnabled = false;
               this.chatWindow.scroll.source = this.chatWindow.chatOutput;
               this.chatWindow.scroll.setSize(this.chatWindow.scroll.width,this.chatWindow.scroll.height);
               this.chatWindow.scroll.verticalScrollPolicy = ScrollPolicy.AUTO;
               this.chatWindow.scroll.horizontalScrollPolicy = ScrollPolicy.OFF;
               this.chatWindow.scroll.update();
               chatWindow.blockingFrame.mouseEnabled = false;
               chatWindow.blockingFrame.mouseChildren = false;
               chatWindow.sendButton.addEventListener(MouseEvent.CLICK,this.sendChat,false,0,true);
          }
          
          public function minimize() : void
          {
               this.chatWindow.visible = false;
               this._isMinimized = true;
          }
          
          public function toggleChat() : void
          {
               if(this._isMinimized)
               {
                    this.chatWindow.visible = true;
               }
               else
               {
                    this.chatWindow.visible = false;
               }
               this._isMinimized = !this._isMinimized;
               if(!this._isMinimized)
               {
                    stage.focus = chatWindow.chatInput;
               }
          }
          
          private function sendChat(evt:Event) : void
          {
               chatWindow.chatInput.text += "\n";
               this.sendChatMessage(evt);
          }
          
          private function sendChatMessage(evt:Event) : void
          {
               var params:SFSObject = null;
               var txt:String = this.chatWindow.chatInput.text;
               if(txt.charCodeAt(txt.length - 1) == 13)
               {
                    txt = txt.slice(0,txt.length - 1);
                    if(txt == "" || txt.charAt(0) == "\n" || txt.charAt(0) == "\r")
                    {
                         chatWindow.chatInput.text = "";
                         return;
                    }
                    params = new SFSObject();
                    params.putInt("id",this.id);
                    params.putUtfString("m",txt);
                    params.putUtfString("n",this.main.sfs.mySelf.name);
                    this.main.sfs.send(new ExtensionRequest("buddyChat",params));
                    this.chatWindow.chatInput.text = "";
               }
          }
          
          public function get buddy() : com.brockw.stickwar.engine.multiplayer.Buddy
          {
               return this._buddy;
          }
          
          public function set buddy(value:com.brockw.stickwar.engine.multiplayer.Buddy) : void
          {
               this._buddy = value;
          }
     }
}
