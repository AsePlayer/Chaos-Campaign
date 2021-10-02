package com.brockw.stickwar.engine
{
   public class HelpMessage extends helpMessageMc
   {
       
      
      private var changeFrame:int;
      
      private var game:StickWar;
      
      public function HelpMessage(game:StickWar)
      {
         super();
         this.game = game;
         this.changeFrame = -1000;
      }
      
      public function showMessage(message:String) : void
      {
         text.alpha = 1;
         text.text = message;
         this.changeFrame = this.game.frame;
      }
      
      public function update(game:StickWar) : void
      {
         if(game.frame - this.changeFrame > 30 * 2.5)
         {
            text.alpha = 0;
         }
         else if(game.frame - this.changeFrame > 30 * 1.5)
         {
            text.alpha += (0 - text.alpha) * 0.1;
         }
      }
   }
}
