package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.RegisterMain;
   
   public class SignUpScreen extends Screen
   {
       
      
      public var signUpForm:com.brockw.stickwar.engine.multiplayer.SignUpForm;
      
      public function SignUpScreen(main:RegisterMain)
      {
         super();
         addChild(this.signUpForm = new com.brockw.stickwar.engine.multiplayer.SignUpForm(main));
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
