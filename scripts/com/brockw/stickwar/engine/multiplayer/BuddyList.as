package com.brockw.stickwar.engine.multiplayer
{
     import com.brockw.stickwar.Main;
     import com.smartfoxserver.v2.entities.data.*;
     import com.smartfoxserver.v2.requests.*;
     import fl.controls.ScrollPolicy;
     import flash.display.Sprite;
     import flash.events.Event;
     import flash.events.FocusEvent;
     import flash.events.MouseEvent;
     import flash.events.TimerEvent;
     import flash.utils.Dictionary;
     import flash.utils.Timer;
     import flash.utils.getTimer;
     
     public class BuddyList
     {
          
          private static const GAME_INVITE_TIME_LIMIT:int = 30 + 1;
           
          
          private var _buddyMap:Dictionary;
          
          private var _buddyList:Array;
          
          private var canvas:Sprite;
          
          private var _chatTabs:Array;
          
          private var chatOverlay:chatOverlayMc;
          
          private var main:Main;
          
          private var currentInviteId:int;
          
          private var currentInviteName:String;
          
          private var currentInviteTime:int;
          
          private var inviteWindowTimer:Timer;
          
          private var chatContainerX:int;
          
          private var chatContainerXReal:Number;
          
          public function BuddyList(chatOverlay:chatOverlayMc, main:Main)
          {
               super();
               this.main = main;
               this.chatOverlay = chatOverlay;
               chatOverlay.chatBoxMc.scroll.source = this.canvas = chatOverlay.chatBoxMc.userDisplayListMc;
               chatOverlay.chatBoxMc.scroll.setSize(chatOverlay.chatBoxMc.scroll.width,chatOverlay.chatBoxMc.scroll.height);
               chatOverlay.chatBoxMc.scroll.horizontalScrollPolicy = ScrollPolicy.OFF;
               chatOverlay.chatBoxMc.scroll.verticalScrollPolicy = ScrollPolicy.AUTO;
               chatOverlay.chatBoxMc.scroll.update();
               this.canvas = chatOverlay.chatBoxMc.userDisplayListMc;
               this._buddyList = [];
               this._buddyMap = new Dictionary();
               this._chatTabs = [];
               this.canvas = this.canvas;
               chatOverlay.gameInviteWindow.visible = false;
               this.currentInviteId = -1;
               this.currentInviteTime = 0;
               this.currentInviteName = "";
               this.chatContainerX = 0;
               this.chatContainerXReal = 0;
               this.inviteWindowTimer = new Timer(1000,0);
               chatOverlay.addEventListener(Event.ENTER_FRAME,this.showArrows);
               chatOverlay.leftArrow.addEventListener(MouseEvent.CLICK,this.leftArrow);
               chatOverlay.rightArrow.addEventListener(MouseEvent.CLICK,this.rightArrow);
               chatOverlay.chatBoxMc.userCodeBox.addEventListener(FocusEvent.FOCUS_IN,this.enterCodeBox);
          }
          
          private function enterCodeBox(f:FocusEvent) : void
          {
               this.chatOverlay.chatBoxMc.userCodeBox.text = "";
          }
          
          private function showArrows(evt:Event) : void
          {
               var width:Number = NaN;
               var limit:Number = NaN;
               this.chatContainerXReal += (this.chatContainerX - this.chatContainerXReal) * 0.2;
               this.chatOverlay.leftArrow.visible = false;
               this.chatOverlay.rightArrow.visible = false;
               if(this.chatContainerX > 0)
               {
                    this.chatOverlay.rightArrow.visible = true;
               }
               if(this._chatTabs.length > 0)
               {
                    width = Number(this._chatTabs[0].width);
                    limit = width * this._chatTabs.length - 655;
                    if(limit - this.chatContainerX > 0)
                    {
                         this.chatOverlay.leftArrow.visible = true;
                    }
               }
               this.updateChatContainer();
          }
          
          private function updateChatContainer() : void
          {
               var width:Number = NaN;
               var limit:Number = NaN;
               if(this.chatContainerX < 0)
               {
                    this.chatContainerX = 0;
               }
               if(this._chatTabs.length > 0)
               {
                    width = Number(this._chatTabs[0].width);
                    limit = width * this._chatTabs.length - 655;
                    if(this.chatContainerX > limit)
                    {
                         this.chatContainerX = limit;
                    }
               }
               if(this._chatTabs.length <= 3)
               {
                    this.chatContainerX = 0;
               }
               this.updateChatTabs();
          }
          
          private function leftArrow(evt:Event) : void
          {
               var width:Number = NaN;
               if(this._chatTabs.length > 0)
               {
                    width = Number(this._chatTabs[0].width);
                    this.chatContainerX += width;
               }
               this.updateChatContainer();
          }
          
          private function rightArrow(evt:Event) : void
          {
               var width:Number = NaN;
               if(this._chatTabs.length > 0)
               {
                    width = Number(this._chatTabs[0].width);
                    this.chatContainerX -= width;
               }
               this.updateChatContainer();
          }
          
          public function cleanUp() : void
          {
               var tab:BuddyChatTab = null;
               for each(tab in this._chatTabs)
               {
                    tab.chatWindow.closeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeChat);
                    tab.maximizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat);
                    tab.chatWindow.minimizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat2);
                    if(this._chatTabs.indexOf(tab) >= 0)
                    {
                         this.chatOverlay.chatContainer.removeChild(tab);
                    }
               }
               this._chatTabs = [];
               this.updateChatTabs();
          }
          
          private function closeChat(evt:MouseEvent) : void
          {
               var tab:BuddyChatTab = BuddyChatTab(evt.currentTarget.parent.parent);
               tab.chatWindow.closeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeChat);
               tab.maximizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat);
               tab.chatWindow.minimizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat2);
               if(this._chatTabs.indexOf(tab) >= 0)
               {
                    this._chatTabs.splice(this._chatTabs.indexOf(tab),1);
                    this.chatOverlay.chatContainer.removeChild(tab);
               }
               this.updateChatTabs();
          }
          
          private function toggleChat2(evt:MouseEvent) : void
          {
               var tab:BuddyChatTab = BuddyChatTab(evt.currentTarget.parent.parent);
               tab.toggleChat();
          }
          
          private function toggleChat(evt:MouseEvent) : void
          {
               var tab:BuddyChatTab = BuddyChatTab(evt.currentTarget.parent);
               tab.toggleChat();
          }
          
          public function startGameInvite(friend:int, userName:String) : void
          {
               this.currentInviteTime = getTimer();
               var timeRemaining:int = GAME_INVITE_TIME_LIMIT - 1;
               this.chatOverlay.gameInviteWindow.visible = true;
               this.chatOverlay.gameInviteWindow.invitationText.text = userName + " has invited you to play a game. (" + timeRemaining + ")";
               this.chatOverlay.gameInviteWindow.acceptButton.addEventListener(MouseEvent.CLICK,this.acceptGameInvite);
               this.chatOverlay.gameInviteWindow.rejectButton.addEventListener(MouseEvent.CLICK,this.rejectGameInvite);
               this.chatOverlay.gameInviteWindow.okButton.visible = false;
               this.chatOverlay.gameInviteWindow.rejectButton.visible = true;
               this.chatOverlay.gameInviteWindow.acceptButton.visible = true;
               this.inviteWindowTimer.addEventListener(TimerEvent.TIMER,this.updateInviteTimer);
               this.inviteWindowTimer.start();
               this.currentInviteId = friend;
               this.currentInviteName = userName;
          }
          
          private function updateInviteTimer(evt:Event) : void
          {
               var params:SFSObject = null;
               var timeRemaining:int = GAME_INVITE_TIME_LIMIT - (getTimer() - this.currentInviteTime) / 1000;
               this.chatOverlay.gameInviteWindow.invitationText.text = this.currentInviteName + " has invited you to play a game. (" + timeRemaining + ")";
               if(timeRemaining <= 0)
               {
                    params = new SFSObject();
                    params.putInt("inviter",this.currentInviteId);
                    params.putInt("response",0);
                    this.main.sfs.send(new ExtensionRequest("buddyGameInviteResponse",params));
                    this.cleanUpGameInviteWindow();
               }
          }
          
          private function acceptGameInvite(evt:Event) : void
          {
               var params:SFSObject = new SFSObject();
               params.putInt("inviter",this.currentInviteId);
               params.putInt("response",1);
               this.main.sfs.send(new ExtensionRequest("buddyGameInviteResponse",params));
               this.cleanUpGameInviteWindow();
          }
          
          private function rejectGameInvite(evt:Event) : void
          {
               var params:SFSObject = new SFSObject();
               params.putInt("inviter",this.currentInviteId);
               params.putInt("response",0);
               this.main.sfs.send(new ExtensionRequest("buddyGameInviteResponse",params));
               this.cleanUpGameInviteWindow();
          }
          
          private function cleanUpGameInviteWindow() : void
          {
               this.chatOverlay.gameInviteWindow.acceptButton.removeEventListener(MouseEvent.CLICK,this.acceptGameInvite);
               this.chatOverlay.gameInviteWindow.rejectButton.removeEventListener(MouseEvent.CLICK,this.rejectGameInvite);
               this.chatOverlay.gameInviteWindow.visible = false;
               this.inviteWindowTimer.stop();
               this.inviteWindowTimer.removeEventListener(TimerEvent.TIMER,this.updateInviteTimer);
          }
          
          public function receiveChat(friend:int, userName:String, message:String) : void
          {
               var i:int = 0;
               var b:Buddy = null;
               var buddy:Buddy = null;
               for(i = 0; i < this._buddyList.length; i++)
               {
                    b = this._buddyMap[this._buddyList[i]];
                    if(b.id == friend)
                    {
                         buddy = b;
                         break;
                    }
               }
               if(buddy == null)
               {
                    buddy = new Buddy();
                    buddy.id = friend;
                    buddy.name = userName;
                    buddy.statusType = 0;
                    buddy.isTemp = true;
                    this.addBuddy(buddy);
               }
               var isAlreadyInChat:Boolean = false;
               for(i = 0; i < this._chatTabs.length; i++)
               {
                    if(BuddyChatTab(this._chatTabs[i]).id == buddy.id)
                    {
                         isAlreadyInChat = true;
                    }
               }
               if(!isAlreadyInChat)
               {
                    this.createChatWindow(buddy);
               }
               for(i = 0; i < this._chatTabs.length; i++)
               {
                    if(BuddyChatTab(this._chatTabs[i]).id == buddy.id && BuddyChatTab(this._chatTabs[i]).chatWindow != null)
                    {
                         BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.text = BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.text + (userName + ": " + message + "\n");
                         BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.height = BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.textHeight + 20;
                         BuddyChatTab(this._chatTabs[i]).chatWindow.scroll.update();
                         if(this.main.getOverlayScreen() == "chatOverlay")
                         {
                              BuddyChatTab(this._chatTabs[i]).chatWindow.scroll.verticalScrollPosition = BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.height;
                         }
                         buddy.chatHistory = BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.text;
                    }
               }
          }
          
          private function createChatWindow(b:Buddy) : void
          {
               for(var i:int = 0; i < this._chatTabs.length; i++)
               {
                    if(BuddyChatTab(this._chatTabs[i]).id == b.id)
                    {
                         return;
                    }
               }
               var newTab:BuddyChatTab = new BuddyChatTab(b.id,this.main);
               newTab.chatWindow.closeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.closeChat);
               newTab.maximizeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat);
               newTab.chatWindow.minimizeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat2);
               this._chatTabs.unshift(newTab);
               newTab.chatWindow.chatOutput.text = b.chatHistory;
               newTab.buddyText.text = b.name;
               newTab.status.gotoAndStop(Buddy.statusFromCode(b.statusType));
               newTab.buddy = b;
               this.updateChatTabs();
               this.main.stage.focus = newTab.chatWindow.chatInput;
          }
          
          private function startChat(evt:MouseEvent) : void
          {
               var b:Buddy = Buddy(evt.currentTarget.parent);
               this.createChatWindow(b);
          }
          
          public function updateChatTabs() : void
          {
               var b:BuddyChatTab = null;
               for(var i:int = 0; i < this._chatTabs.length; i++)
               {
                    b = this._chatTabs[i];
                    if(!this.chatOverlay.chatContainer.contains(b))
                    {
                         this.chatOverlay.chatContainer.addChild(b);
                    }
                    b.x = this.chatContainerXReal + 655 - b.width * (i + 1);
                    b.y = 15;
                    b.status.gotoAndStop(Buddy.statusFromCode(b.buddy.statusType));
                    if(b.x + b.width / 2 > 655)
                    {
                         b.minimize();
                    }
               }
          }
          
          public function updateScrollOnTabs() : void
          {
               for(var i:int = 0; i < this._chatTabs.length; i++)
               {
                    BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.height = BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.textHeight;
                    BuddyChatTab(this._chatTabs[i]).chatWindow.scroll.update();
                    if(this.main.getOverlayScreen() == "chatOverlay")
                    {
                         BuddyChatTab(this._chatTabs[i]).chatWindow.scroll.verticalScrollPosition = BuddyChatTab(this._chatTabs[i]).chatWindow.chatOutput.height;
                    }
               }
          }
          
          public function addBuddy(b:Buddy) : void
          {
               var temp:* = undefined;
               if(!(b.id in this._buddyMap))
               {
                    this._buddyList.push(b.id);
                    this._buddyMap[b.id] = b;
                    b.startChat.addEventListener(MouseEvent.CLICK,this.startChat);
                    b.removeUser.addEventListener(MouseEvent.CLICK,this.removeBuddyFromFriendsList);
                    b.startGame.addEventListener(MouseEvent.CLICK,this.inviteToGame);
               }
               else
               {
                    temp = b;
                    b = this._buddyMap[b.id];
                    b.name = temp.name;
                    b.statusType = temp.statusType;
                    if(!b.isTemp || !temp.isTemp)
                    {
                         b.isTemp = false;
                    }
                    else
                    {
                         b.isTemp = true;
                    }
               }
               this.updateChatTabs();
               this.update();
          }
          
          private function inviteToGame(evt:Event) : void
          {
               var tab:Buddy = Buddy(evt.currentTarget.parent);
               var params:SFSObject = new SFSObject();
               params.putInt("invitee",tab.id);
               this.main.sfs.send(new ExtensionRequest("buddyGameInvite",params));
          }
          
          private function removeBuddyFromFriendsList(evt:Event) : void
          {
               var tab:Buddy = Buddy(evt.currentTarget.parent);
               var params:SFSObject = new SFSObject();
               params.putUtfString("buddy",tab.name);
               this.main.sfs.send(new ExtensionRequest("buddyRemove",params));
          }
          
          public function removeBuddy(b:Buddy) : void
          {
               if(b.id in this._buddyMap)
               {
                    delete this._buddyMap[b.id];
                    b.startChat.removeEventListener(MouseEvent.CLICK,this.startChat);
                    b.removeUser.removeEventListener(MouseEvent.CLICK,this.removeBuddyFromFriendsList);
                    b.startGame.removeEventListener(MouseEvent.CLICK,this.inviteToGame);
                    if(this.canvas.contains(b))
                    {
                         this.canvas.removeChild(b);
                    }
                    this._buddyList.splice(this._buddyList.indexOf(b.id),1);
               }
               this.update();
          }
          
          private function sortOnNames(a:int, b:int) : int
          {
               if(Boolean(this._buddyMap[a].isTemp))
               {
                    return 1;
               }
               if(Boolean(this._buddyMap[b].isTemp))
               {
                    return -1;
               }
               var buddyA:Buddy = this._buddyMap[a];
               var buddyB:Buddy = this._buddyMap[b];
               if(buddyA.name.toLowerCase() < buddyB.name.toLowerCase())
               {
                    return -1;
               }
               return 1;
          }
          
          public function update() : void
          {
               var b:Buddy = null;
               this._buddyList.sort(this.sortOnNames);
               this.canvas.scaleX = 1;
               this.canvas.scaleY = 1;
               for(var i:int = 0; i < this._buddyList.length; i++)
               {
                    b = this._buddyMap[this._buddyList[i]];
                    if(!this.canvas.contains(b))
                    {
                         this.canvas.addChild(b);
                    }
                    b.displayName.text = b.toString();
                    if(b.isTemp)
                    {
                         b.alpha = 0.3;
                    }
                    else
                    {
                         b.alpha = 1;
                    }
                    b.y = b.height * i;
               }
               this.chatOverlay.chatBoxMc.scroll.update();
          }
          
          public function receiveBuddyList(params:SFSObject) : void
          {
               var i:int = 0;
               var b:Buddy = null;
               var buddys:ISFSArray = params.getSFSArray("buddys");
               var temps:Array = [];
               trace("\nLoading the buddy list");
               for(i = 0; i < this._buddyList.length; i++)
               {
                    b = this._buddyMap[this._buddyList[i]];
                    if(b.isTemp)
                    {
                         temps.push(b);
                    }
               }
               while(this._buddyList.length != 0)
               {
                    this.removeBuddy(this._buddyMap[this._buddyList[0]]);
               }
               for(i = 0; i < temps.length; i++)
               {
                    this.addBuddy(temps[i]);
               }
               for(i = 0; i < buddys.size(); i++)
               {
                    b = new Buddy();
                    b.fromSFSObject(buddys.getSFSObject(i));
                    this.addBuddy(b);
               }
          }
          
          public function receiveUpdate(params:SFSObject) : void
          {
               var buddy:ISFSObject = params;
               var b:Buddy = new Buddy();
               b.fromSFSObject(buddy);
               this.addBuddy(b);
               trace("\nUpdating buddy: " + b);
          }
     }
}
