package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class GlobalMove extends Move
   {
       
      
      public var globalMoveType:int;
      
      public function GlobalMove()
      {
         type = Commands.GLOBAL_MOVE;
         this.globalMoveType = 0;
         super();
      }
      
      override public function toString() : String
      {
         var s:String = super.toString();
         return s + (String(this.globalMoveType) + " ");
      }
      
      override public function fromString(s:Array) : Boolean
      {
         super.fromString(s);
         this.globalMoveType = int(s.shift());
         return true;
      }
      
      override public function readFromSFSObject(o:SFSObject) : void
      {
         readBasicsSFSObject(o);
         this.globalMoveType = o.getInt("pos");
      }
      
      override public function writeToSFSObject(o:SFSObject) : void
      {
         writeBasicsSFSObject(o);
         o.putInt("pos",this.globalMoveType);
      }
      
      override public function execute(game:Simulation) : void
      {
         var stickwar:StickWar = StickWar(game);
         var team:Team = null;
         if(stickwar.teamA.id == owner)
         {
            team = stickwar.teamA;
         }
         else if(stickwar.teamB.id == owner)
         {
            team = stickwar.teamB;
         }
         if(this.globalMoveType == Team.G_GARRISON)
         {
            team.garrison(true);
         }
         else if(this.globalMoveType == Team.G_DEFEND)
         {
            team.defend(true);
         }
         else if(this.globalMoveType == Team.G_GARRISON_MINER)
         {
            team.garrisonMiner(true);
         }
         else if(this.globalMoveType == Team.G_UNGARRISON_MINER)
         {
            team.unGarrisonMiner(true);
         }
         else
         {
            team.attack(true);
         }
      }
   }
}
