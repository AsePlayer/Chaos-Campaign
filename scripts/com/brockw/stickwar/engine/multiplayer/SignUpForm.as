package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.stickwar.RegisterMain;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import com.smartfoxserver.v2.requests.buddylist.*;
   import flash.events.*;
   import flash.text.TextField;
   
   public class SignUpForm extends signUpScreenMc
   {
       
      
      private var tryingToConnect:Boolean;
      
      private var main:RegisterMain;
      
      private var hasRegistered:Boolean;
      
      public function SignUpForm(main:RegisterMain)
      {
         super();
         this.main = main;
         this.addEventListener(Event.ENTER_FRAME,this.update);
         this.hasRegistered = false;
         this.visible = true;
         this.y = -700;
         this.tryingToConnect = true;
         main.sfs.addEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
         main.sfs.addEventListener(SFSEvent.LOGIN,this.SFSLogin);
         form.usernameField.text.addEventListener(Event.CHANGE,this.usernameChanged);
         TextField(this.form.passwordField.text).displayAsPassword = true;
         TextField(this.form.confirmPasswordField.text).displayAsPassword = true;
         form.confirmEmailField.text.addEventListener(Event.CHANGE,this.emailChanged);
         form.confirmPasswordField.text.addEventListener(Event.CHANGE,this.passwordChanged);
         this.form.emailConfirm.text = "";
         form.passwordConfirm.text = "";
         form.usernameField.text.restrict = "A-Za-z0-9";
         TextField(this.form.usernameField.text).maxChars = 15;
         this.form.firstField.text.restrict = "A-Za-z ";
         this.form.lastField.text.restrict = "A-Za-z ";
         this.form.emailField.text.restrict = "^\n";
         this.form.confirmEmailField.text.restrict = "^\n";
         this.form.passwordField.text.restrict = "^\n";
         this.form.confirmPasswordField.text.restrict = "^\n";
         form.usernameField.text.tabIndex = 1;
         this.form.firstField.text.tabIndex = 2;
         this.form.lastField.text.tabIndex = 3;
         this.form.emailField.text.tabIndex = 4;
         this.form.confirmEmailField.text.tabIndex = 5;
         this.form.passwordField.text.tabIndex = 6;
         this.form.confirmPasswordField.text.tabIndex = 7;
         this.form.registerButton.tabIndex = 8;
         form.availability.text = "";
         form.firstSanity.text = "";
         form.lastSanity.text = "";
         form.emailConfirm.text = "";
         form.passwordConfirm.text = "";
         this.form.usernameBacking.visible = false;
         this.form.firstBacking.visible = false;
         this.form.lastBacking.visible = false;
         this.form.emailBacking.visible = false;
         this.form.confirmBacking.visible = false;
         form.registerButton.addEventListener(MouseEvent.CLICK,this.register);
      }
      
      private function close(evt:MouseEvent) : void
      {
         this.leave();
      }
      
      public function enter() : void
      {
      }
      
      public function registerResponse(success:Boolean, userUnique:Boolean, emailUnique:Boolean, emailValid:Boolean) : void
      {
         if(success)
         {
            gotoAndStop(2);
         }
         else
         {
            if(!userUnique)
            {
               form.availability.text = "Username is already taken";
               this.form.usernameBacking.visible = true;
            }
            if(!emailUnique)
            {
               form.emailConfirm.text = "Email address already in use";
               this.form.emailBacking.visible = true;
            }
            if(!emailValid)
            {
               form.emailConfirm.text = "Email address is not valid";
               this.form.emailBacking.visible = true;
            }
         }
      }
      
      private function continueClick(evt:Event) : void
      {
         gotoAndStop(1);
         this.leave();
      }
      
      private function performSanityChecks() : Boolean
      {
         form.availability.text = "";
         form.firstSanity.text = "";
         form.lastSanity.text = "";
         form.emailConfirm.text = "";
         form.passwordConfirm.text = "";
         this.form.usernameBacking.visible = false;
         this.form.firstBacking.visible = false;
         this.form.lastBacking.visible = false;
         this.form.emailBacking.visible = false;
         this.form.confirmBacking.visible = false;
         var success:Boolean = true;
         if(form.usernameField.text.text.length < 3)
         {
            form.availability.text = "Username must be atleast 3 characters";
            this.form.usernameBacking.visible = true;
            success = false;
         }
         if(form.firstField.text.text.length < 1)
         {
            form.firstSanity.text = "You must enter a first name";
            this.form.firstBacking.visible = true;
            success = false;
         }
         if(form.lastField.text.text.length < 1)
         {
            form.lastSanity.text = "You must enter a last name";
            this.form.lastBacking.visible = true;
            success = false;
         }
         if(form.confirmEmailField.text.text.length < 1)
         {
            this.form.emailBacking.visible = true;
            form.emailConfirm.text = "You must enter an email address";
            success = false;
         }
         else if(form.confirmEmailField.text.text != form.emailField.text.text)
         {
            form.emailConfirm.text = "Email address must match";
            success = false;
         }
         if(form.confirmPasswordField.text.text.length < 8)
         {
            form.passwordConfirm.text = "Password must be alteast 8 characters";
            this.form.confirmBacking.visible = true;
            success = false;
         }
         else if(form.confirmPasswordField.text.text != form.passwordField.text.text)
         {
            form.passwordConfirm.text = "Passwords must match";
            this.form.confirmBacking.visible = true;
            success = false;
         }
         return success;
      }
      
      private function register(evt:Event) : void
      {
         var params:SFSObject = null;
         var r:ExtensionRequest = null;
         if(this.performSanityChecks())
         {
            params = new SFSObject();
            params.putUtfString("username",form.usernameField.text.text);
            params.putUtfString("firstName",form.firstField.text.text);
            params.putUtfString("lastName",form.lastField.text.text);
            params.putUtfString("password",form.passwordField.text.text);
            params.putUtfString("email",form.emailField.text.text);
            r = new ExtensionRequest("registerUser",params);
            this.main.sfs.send(r);
         }
      }
      
      private function emailChanged(evt:Event) : void
      {
         if(form.confirmEmailField.text.text != form.emailField.text.text)
         {
            form.emailConfirm.text = "Emails do not match";
            this.form.emailBacking.visible = true;
         }
         else
         {
            form.emailConfirm.text = "";
            this.form.emailBacking.visible = false;
         }
      }
      
      private function passwordChanged(evt:Event) : void
      {
         if(form.confirmPasswordField.text.text != form.passwordField.text.text)
         {
            form.passwordConfirm.text = "Passwords do not match";
            this.form.confirmBacking.visible = true;
         }
         else
         {
            form.passwordConfirm.text = "";
            this.form.confirmBacking.visible = false;
         }
      }
      
      private function usernameChanged(evt:Event) : void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("username",form.usernameField.text.text);
         var r:ExtensionRequest = new ExtensionRequest("checkAvailability",params);
         this.main.sfs.send(r);
         this.form.availability.text = "";
         this.form.usernameBacking.visible = false;
      }
      
      public function usernameAvailable(username:String, available:Boolean) : void
      {
         if(form.usernameField.text.text == username)
         {
            if(!available)
            {
               this.form.availability.text = "Not Available";
               this.form.usernameBacking.visible = true;
            }
         }
      }
      
      public function leave() : void
      {
      }
      
      private function SFSLoginError(evt:SFSEvent) : void
      {
      }
      
      private function SFSLogin(evt:SFSEvent) : void
      {
         this.tryingToConnect = false;
         trace("logged in");
         if(this.main.sfs.currentZone == "StickEmpiresRegister")
         {
            this.usernameChanged(null);
         }
      }
      
      public function update(evt:Event) : void
      {
         y += (0 - this.y) * 1;
         if(this.tryingToConnect)
         {
         }
      }
   }
}
