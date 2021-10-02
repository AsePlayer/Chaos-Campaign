package com.brockw.stickwar.engine.multiplayer.adds
{
   import flash.display.MovieClip;
   
   public class Add extends MovieClip
   {
       
      
      var manager:AddManager;
      
      public function Add(manager:*)
      {
         this.manager = manager;
         super();
      }
      
      public function update() : void
      {
      }
      
      public function enter() : void
      {
      }
      
      public function leave() : void
      {
      }
   }
}
