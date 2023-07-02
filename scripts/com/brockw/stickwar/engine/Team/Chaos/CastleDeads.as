package com.brockw.stickwar.engine.Team.Chaos
{
   import com.brockw.stickwar.engine.Ai.DeadAi;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.Dead;
   
   public class CastleDeads extends CastleDefence
   {
       
      
      public function CastleDeads(game:StickWar, team:Team)
      {
         super(game,team);
         units = [];
      }
      
      override public function update(game:StickWar) : void
      {
         var nArchers:int = 0;
         if(team.tech.isResearched(Tech.CASTLE_ARCHER_3))
         {
            nArchers = 3;
         }
         else if(team.tech.isResearched(Tech.CASTLE_ARCHER_2))
         {
            nArchers = 2;
         }
         else if(team.tech.isResearched(Tech.CASTLE_ARCHER_1))
         {
            nArchers = 1;
         }
         if(units.length < nArchers)
         {
            this.addUnit();
         }
         for(var i:int = 0; i < units.length; i++)
         {
            units[i].faceDirection(team.direction);
         }
         super.update(game);
      }
      
      override public function addUnit() : void
      {
         var newArcher:Dead = null;
         newArcher = new Dead(game);
         newArcher.ai = new DeadAi(newArcher);
         newArcher.team = team;
         newArcher.isCastleArcher = true;
         newArcher.init(game);
         newArcher.flyingHeight = 390;
         newArcher.pz = -newArcher.flyingHeight;
         newArcher.ai.init();
         newArcher.py = -game.map.height / 5 + 3 * game.map.height / 4 * units.length / game.xml.xml.Order.Tech.castleArchers.num;
         newArcher.y = 0;
         newArcher.px = team.homeX + team.direction * 110 - team.direction * units.length * 8;
         newArcher.x = newArcher.px;
         var m:HoldCommand = new HoldCommand(game);
         newArcher.ai.setCommand(game,m);
         units.push(newArcher);
         game.battlefield.addChild(newArcher);
      }
   }
}
