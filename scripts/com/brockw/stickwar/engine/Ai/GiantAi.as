package com.brockw.stickwar.engine.Ai
{
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.Giant;
     
     public class GiantAi extends UnitAi
     {
           
          
          public function GiantAi(s:Giant)
          {
               super();
               unit = s;
          }
          
          override public function update(game:StickWar) : void
          {
               baseUpdate(game);
          }
     }
}
