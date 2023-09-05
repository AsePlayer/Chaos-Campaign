package com.brockw.stickwar.engine
{
     public class IncomeDisplay
     {
          
          private static const NUM_DISPLAYS:int = 20;
           
          
          private var displayTime:int;
          
          private var displays:Array;
          
          private var pool:Array;
          
          public function IncomeDisplay(game:StickWar)
          {
               super();
               this.displayTime = game.xml.xml.incomeDisplay.time;
               this.pool = [];
               for(var i:int = 0; i < NUM_DISPLAYS; i++)
               {
                    this.pool.push(new DisplayClip());
               }
               this.displays = [];
          }
          
          public function addDisplay(game:StickWar, t:String, colour:int, x:int, y:int) : void
          {
               var c:DisplayClip = DisplayClip(this.pool.pop());
               c.mc.textColor = colour;
               c.mc.text.text = t;
               c.x = c.px = x;
               c.y = y;
               c.py = game.map.height;
               c.alpha = 1;
               game.battlefield.addChild(c);
               this.displays.push([this.displayTime,c]);
          }
          
          public function update(game:StickWar) : void
          {
               var d:Array = null;
               for each(d in this.displays)
               {
                    DisplayClip(d[1]).y = DisplayClip(d[1]).y - 0.5;
                    d[0] -= 1;
                    DisplayClip(d[1]).alpha = DisplayClip(d[1]).alpha - 0.005;
               }
               while(this.displays.length != 0)
               {
                    if(this.displays[0][0] > 0)
                    {
                         break;
                    }
                    this.pool.push(this.displays.shift()[1]);
               }
          }
     }
}
