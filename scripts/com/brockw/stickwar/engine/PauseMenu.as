package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.GameScreen;
   import flash.display.Sprite;
   
   public class PauseMenu extends Sprite
   {
       
      
      protected var isShowing:Boolean;
      
      protected var backingMc:Sprite;
      
      protected var gameScreen:GameScreen;
      
      public function PauseMenu(gameScreen:GameScreen)
      {
         super();
         this.backingMc = new Sprite();
         this.backingMc.graphics.beginFill(0,0.7);
         this.backingMc.graphics.drawRect(0,0,850,700);
         addChild(this.backingMc);
         this.hideMenu();
         this.gameScreen = gameScreen;
      }
      
      public function cleanUp() : void
      {
      }
      
      public function update() : void
      {
         if(this.isShowing)
         {
            this.backingMc.visible = true;
         }
         else
         {
            this.backingMc.visible = false;
         }
      }
      
      public function toggleMenu() : Boolean
      {
         if(this.isShowing)
         {
            this.hideMenu();
         }
         else
         {
            this.showMenu();
         }
         return this.isShowing;
      }
      
      public function showMenu() : void
      {
         this.isShowing = true;
         this.mouseChildren = true;
         this.mouseEnabled = true;
         if(this.gameScreen.contains(this))
         {
            this.gameScreen.removeChild(this);
            this.gameScreen.addChild(this);
         }
      }
      
      public function hideMenu() : void
      {
         this.isShowing = false;
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
   }
}
