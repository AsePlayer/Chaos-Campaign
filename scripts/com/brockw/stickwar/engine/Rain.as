package com.brockw.stickwar.engine
{
   public class Rain extends Entity
   {
       
      
      var game:StickWar;
      
      var rain:Array;
      
      var numParticles:int;
      
      public function Rain(game:StickWar, n:int)
      {
         super();
         this.rain = [];
         this.game = game;
         this.numParticles = n;
         this.init(game);
         py = game.map.height;
      }
      
      public function init(game:StickWar) : void
      {
         var r:RainDrop = null;
         for(var i:* = 0; i < this.numParticles; i++)
         {
            r = new RainDrop(game);
            addChild(r);
            this.rain.push(r);
         }
      }
      
      public function update(game:StickWar) : void
      {
         x = game.battlefield.x;
         for(var i:* = 0; i < this.numParticles; i++)
         {
            this.rain[i].update(game);
         }
      }
   }
}
