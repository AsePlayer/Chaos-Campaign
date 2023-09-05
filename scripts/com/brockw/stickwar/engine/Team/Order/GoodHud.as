package com.brockw.stickwar.engine.Team.Order
{
     import com.brockw.stickwar.engine.Team.Hud;
     import flash.display.MovieClip;
     
     public class GoodHud extends Hud
     {
           
          
          public function GoodHud()
          {
               var hud:MovieClip = new _hud();
               super(hud);
          }
     }
}
