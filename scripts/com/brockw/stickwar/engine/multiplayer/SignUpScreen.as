package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.RegisterMain;
   
   public class SignUpScreen extends Screen
   {
       
      
      public var signUpForm:SignUpForm;
      
      public function SignUpScreen(main:RegisterMain)
      {
         super();
         addChild(this.signUpForm = new SignUpForm(main));
      }
      
      override public function enter() : void
      {
         this.signUpForm.enter();
      }
      
      override public function leave() : void
      {
         this.signUpForm.leave();
      }
   }
}
