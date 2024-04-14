package com.brockw.stickwar.engine
{
     import com.brockw.game.Pool;
     
     public class Rain extends Entity
     {
           
          
          internal var game:StickWar;
          
          internal var rain:Array;
          
          internal var numParticles:int;
          
          internal var rainDropPool:Pool;
          
          public function Rain(game:StickWar, n:int)
          {
               super();
               this.rain = [];
               this.game = game;
               this.numParticles = n;
               this.rainDropPool = new Pool(n,RainDrop,game);
               this.init(game);
               py = game.map.height;
          }
          
          public function init(game:StickWar) : void
          {
               var r:RainDrop = null;
               var i:* = 0;
               while(i < this.numParticles)
               {
                    r = RainDrop(this.rainDropPool.getItem());
                    addChild(r);
                    this.rain.push(r);
                    i++;
               }
          }
          
          public function update(game:StickWar) : void
          {
               x = game.battlefield.x + 50;
               var i:* = 0;
               while(i < this.numParticles)
               {
                    this.rain[i].update(game);
                    if(this.rain[i].pz >= 0)
                    {
                         this.rainDropPool.returnItem(this.rain[i]);
                         this.rain[i] = RainDrop(this.rainDropPool.getItem());
                         addChild(this.rain[i]);
                    }
                    i++;
               }
          }
     }
}
