package com.brockw.stickwar.engine.multiplayer
{
     import com.brockw.stickwar.BaseMain;
     import com.smartfoxserver.v2.core.SFSEvent;
     import com.smartfoxserver.v2.entities.*;
     import com.smartfoxserver.v2.entities.data.*;
     import com.smartfoxserver.v2.requests.*;
     import com.smartfoxserver.v2.requests.buddylist.*;
     import flash.events.*;
     
     public class ForgotPasswordForm extends forgotPasswordForm
     {
           
          
          private var tryingToConnect:Boolean;
          
          private var main:BaseMain;
          
          private var hasSubmitted:Boolean;
          
          public function ForgotPasswordForm(main:BaseMain)
          {
               super();
               this.main = main;
          }
          
          private function close(evt:MouseEvent) : void
          {
               this.leave();
          }
          
          public function enter() : void
          {
               this.closeButton.addEventListener(MouseEvent.CLICK,this.close);
               this.addEventListener(Event.ENTER_FRAME,this.update);
               gotoAndStop(1);
               this.hasSubmitted = false;
               this.visible = true;
               this.tryingToConnect = true;
               this.main.sfs.send(new LoginRequest("register","","StickEmpiresRegister"));
               this.main.sfs.addEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
               this.main.sfs.addEventListener(SFSEvent.LOGIN,this.SFSLogin);
               this.emailField.text.restrict = "^\n";
               submitButton.addEventListener(MouseEvent.CLICK,this.submit);
               emailField.text.text = "";
          }
          
          public function submitResponse(success:Boolean, message:String) : void
          {
               gotoAndStop(2);
               this.forgotPasswordStatus.text = message;
               continueButton.addEventListener(MouseEvent.CLICK,this.continueClick);
          }
          
          private function continueClick(evt:Event) : void
          {
               continueButton.removeEventListener(MouseEvent.CLICK,this.continueClick);
               gotoAndStop(1);
               this.leave();
          }
          
          private function submit(evt:Event) : void
          {
               var params:SFSObject = new SFSObject();
               params.putUtfString("email",emailField.text.text);
               var r:ExtensionRequest = new ExtensionRequest("forgotPassword",params);
               this.main.sfs.send(r);
          }
          
          public function leave() : void
          {
               gotoAndStop(1);
               this.closeButton.removeEventListener(MouseEvent.CLICK,this.close);
               this.removeEventListener(Event.ENTER_FRAME,this.update);
               this.visible = false;
               this.main.sfs.removeEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
               this.main.sfs.removeEventListener(SFSEvent.LOGIN,this.SFSLogin);
               this.main.sfs.send(new LogoutRequest());
               submitButton.removeEventListener(MouseEvent.CLICK,this.submit);
          }
          
          private function SFSLoginError(evt:SFSEvent) : void
          {
          }
          
          private function SFSLogin(evt:SFSEvent) : void
          {
               this.tryingToConnect = false;
               if(this.main.sfs.currentZone == "StickEmpiresRegister")
               {
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
