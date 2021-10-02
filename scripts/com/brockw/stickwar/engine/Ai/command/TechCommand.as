package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class TechCommand extends UnitCommand
   {
       
      
      public function TechCommand(game:StickWar)
      {
         super();
         type = UnitCommand.TECH;
         _hasCoolDown = true;
         _intendedEntityType = Unit.B_ORDER_BANK;
      }
      
      override public function prepareNetworkedMove(gameScreen:GameScreen) : *
      {
         var unit:* = null;
         var u:UnitMove = new UnitMove();
         u.moveType = this.type;
         for(unit in gameScreen.team.units)
         {
            if(Unit(gameScreen.team.units[unit]).selected)
            {
               if(this.intendedEntityType == -1 || this.intendedEntityType == gameScreen.team.units[unit].type)
               {
                  u.units.push(gameScreen.team.units[unit].id);
               }
            }
         }
         u.arg0 = goalX;
         u.arg1 = goalY;
         gameScreen.doMove(u,team.id);
      }
   }
}
