package com.brockw.stickwar.engine.multiplayer
{
   import AS.encryption.MD5;
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ProfileScreen extends Screen
   {
      
      private static const BAR_LENGTH:int = 280;
       
      
      private var main:Main;
      
      private var mc:profileScreenMc;
      
      private var wins:int;
      
      private var loses:int;
      
      private var totalGames:int;
      
      private var isChanging:Boolean;
      
      private var isChangingPassword:Boolean;
      
      public function ProfileScreen(main:Main)
      {
         super();
         this.main = main;
         this.mc = new profileScreenMc();
         addChild(this.mc);
         this.mc.winsBar.width = 0;
         this.mc.losesBar.width = 0;
         this.isChanging = false;
      }
      
      public function loadProfile(userName:String) : void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("name",userName);
         var r:ExtensionRequest = new ExtensionRequest("getProfile",params);
         this.main.sfs.send(r);
         this.mc.username.text = "";
         this.mc.rating.text = "";
         this.mc.winsBar.width = 0;
         this.mc.losesBar.width = 0;
         this.mc.winsCount.text = "";
         this.mc.losesCount.text = "";
         this.wins = 0;
         this.loses = 0;
         this.totalGames = 0;
         this.mc.raceType.visible = false;
         this.mc.changeEmailButton.visible = false;
         this.mc.changePasswordButton.visible = false;
         this.mc.addToFriendsButton.visible = false;
         this.mc.isAMember.visible = false;
         this.mc.isAMember.visible = false;
      }
      
      public function receiveProfile(data:SFSObject) : void
      {
         if(this.main.sfs.mySelf.name == data.getUtfString("username"))
         {
            this.mc.changeEmailButton.visible = true;
            this.mc.changePasswordButton.visible = true;
            this.mc.addToFriendsButton.visible = false;
         }
         else
         {
            this.mc.changeEmailButton.visible = false;
            this.mc.changePasswordButton.visible = false;
            this.mc.addToFriendsButton.visible = true;
         }
         this.mc.username.text = "" + data.getUtfString("username");
         this.mc.rating.text = "" + Math.floor(data.getDouble("rating"));
         this.mc.raceType.visible = true;
         this.wins = data.getInt("wins");
         this.totalGames = data.getInt("wins") + data.getInt("loses");
         this.loses = data.getInt("loses");
         var order:int = data.getInt("orderCount");
         var chaos:int = data.getInt("chaosCount");
         var random:int = data.getInt("randomCount");
         if(order > chaos && order > random)
         {
            this.mc.raceType.gotoAndStop("Order");
         }
         else if(chaos > order && chaos > random)
         {
            this.mc.raceType.gotoAndStop("Chaos");
         }
         else
         {
            this.mc.raceType.gotoAndStop("Random");
         }
         if(data.containsKey("isMember"))
         {
            this.mc.isAMember.visible = data.getInt("isMember") == 1;
         }
      }
      
      public function update(evt:Event) : void
      {
         if(this.totalGames > 0)
         {
            this.mc.winsBar.width += (BAR_LENGTH * this.wins / this.totalGames - this.mc.winsBar.width) * 0.1;
            this.mc.losesBar.width += (BAR_LENGTH * this.loses / this.totalGames - this.mc.losesBar.width) * 0.1;
            this.mc.winsCount.text = "" + this.wins;
            this.mc.losesCount.text = "" + this.loses;
            this.mc.winsCount.x = BAR_LENGTH * this.wins / this.totalGames + this.mc.winsBar.x + this.mc.winsCount.width / 2;
            this.mc.losesCount.x = BAR_LENGTH * this.loses / this.totalGames + this.mc.losesBar.x + this.mc.losesCount.width / 2;
         }
         if(this.isChanging)
         {
            this.mc.changeItemMc.visible = true;
            if(this.mc.changeItemMc.firstInput.text != this.mc.changeItemMc.secondInput.text)
            {
               if(this.isChangingPassword)
               {
                  this.mc.changeItemMc.matchingText.text = "Passwords must match";
               }
               else
               {
                  this.mc.changeItemMc.matchingText.text = "Emails must match";
               }
            }
            else
            {
               this.mc.changeItemMc.matchingText.text = "";
            }
            this.mc.winsBar.visible = false;
            this.mc.winsText.visible = false;
            this.mc.winsCount.visible = false;
            this.mc.losesBar.visible = false;
            this.mc.losesText.visible = false;
            this.mc.losesCount.visible = false;
         }
         else
         {
            this.mc.changeItemMc.visible = false;
            this.mc.winsBar.visible = true;
            this.mc.winsText.visible = true;
            this.mc.winsCount.visible = true;
            this.mc.losesBar.visible = true;
            this.mc.losesText.visible = true;
            this.mc.losesCount.visible = true;
         }
      }
      
      override public function enter() : void
      {
         this.main.setOverlayScreen("chatOverlay");
         addEventListener(Event.ENTER_FRAME,this.update);
         this.mc.changeEmailButton.addEventListener(MouseEvent.CLICK,this.changeEmail);
         this.mc.changePasswordButton.addEventListener(MouseEvent.CLICK,this.changePassword);
         this.mc.changeItemMc.cancelButton.addEventListener(MouseEvent.CLICK,this.cancelButtonEvent);
         this.mc.changeItemMc.changeButton.addEventListener(MouseEvent.CLICK,this.changeButtonEvent);
         this.mc.changeMessage.okButton.addEventListener(MouseEvent.CLICK,this.okButton);
         this.mc.addToFriendsButton.addEventListener(MouseEvent.CLICK,this.addToFriends);
         this.mc.changeMessage.visible = false;
      }
      
      private function addToFriends(evt:Event) : void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("buddy",this.mc.username.text);
         params.putInt("permission",1);
         this.main.sfs.send(new ExtensionRequest("buddyAdd",params));
      }
      
      private function okButton(evt:Event) : void
      {
         this.mc.changeMessage.visible = false;
      }
      
      private function cancelButtonEvent(evt:Event) : void
      {
         this.isChanging = false;
      }
      
      private function changeButtonEvent(evt:Event) : void
      {
         this.isChanging = false;
         var params:SFSObject = new SFSObject();
         if(this.isChangingPassword)
         {
            params.putUtfString("currentPassword",MD5.hash(this.mc.changeItemMc.currentPassword.text));
            params.putUtfString("newPassword",MD5.hash(this.mc.changeItemMc.firstInput.text));
            params.putUtfString("repeatPassword",MD5.hash(this.mc.changeItemMc.secondInput.text));
            this.main.sfs.send(new ExtensionRequest("changePassword",params));
         }
         else
         {
            params.putUtfString("currentPassword",MD5.hash(this.mc.changeItemMc.currentPassword.text));
            params.putUtfString("newEmail",this.mc.changeItemMc.firstInput.text);
            params.putUtfString("repeatEmail",this.mc.changeItemMc.secondInput.text);
            this.main.sfs.send(new ExtensionRequest("changeEmail",params));
         }
      }
      
      public function receiveChangeMessage(message:String) : void
      {
         this.mc.changeMessage.messageText.text = message;
         this.mc.changeMessage.visible = true;
      }
      
      private function changeEmail(evt:Event) : void
      {
         if(this.mc.changeItemMc.firstInput.text != this.mc.changeItemMc.secondInput.text)
         {
            return;
         }
         this.isChanging = true;
         this.isChangingPassword = false;
         this.mc.changeItemMc.firstText.text = "Email";
         this.mc.changeItemMc.secondText.text = "Repeat Email";
         this.mc.changeItemMc.currentPassword.text = "";
         TextField(this.mc.changeItemMc.firstInput).displayAsPassword = false;
         TextField(this.mc.changeItemMc.secondInput).displayAsPassword = false;
         this.mc.changeItemMc.firstInput.text = "";
         this.mc.changeItemMc.secondInput.text = "";
      }
      
      private function changePassword(evt:Event) : void
      {
         if(this.mc.changeItemMc.firstInput.text != this.mc.changeItemMc.secondInput.text)
         {
            return;
         }
         this.isChanging = true;
         this.isChangingPassword = true;
         this.mc.changeItemMc.firstInput.text = "";
         this.mc.changeItemMc.secondInput.text = "";
         this.mc.changeItemMc.currentPassword.text = "";
         this.mc.changeItemMc.firstText.text = "Passsword";
         this.mc.changeItemMc.secondText.text = "Repeat Password";
         TextField(this.mc.changeItemMc.firstInput).displayAsPassword = true;
         TextField(this.mc.changeItemMc.secondInput).displayAsPassword = true;
      }
      
      override public function leave() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.update);
         this.mc.changeEmailButton.removeEventListener(MouseEvent.CLICK,this.changeEmail);
         this.mc.changePasswordButton.removeEventListener(MouseEvent.CLICK,this.changePassword);
         this.mc.changeItemMc.cancelButton.removeEventListener(MouseEvent.CLICK,this.cancelButtonEvent);
         this.mc.changeItemMc.changeButton.removeEventListener(MouseEvent.CLICK,this.changeButtonEvent);
         this.mc.changeMessage.okButton.removeEventListener(MouseEvent.CLICK,this.okButton);
         this.mc.addToFriendsButton.removeEventListener(MouseEvent.CLICK,this.addToFriends);
      }
   }
}
