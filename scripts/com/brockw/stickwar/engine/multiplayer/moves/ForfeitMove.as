package com.brockw.stickwar.engine.multiplayer.moves
{
     import com.brockw.simulationSync.Move;
     import com.brockw.simulationSync.Simulation;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.Team.Team;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     
     public class ForfeitMove extends Move
     {
           
          
          public function ForfeitMove()
          {
               type = Commands.FORFEIT;
               super();
          }
          
          override public function toString() : String
          {
               return super.toString();
          }
          
          override public function fromString(s:Array) : Boolean
          {
               super.fromString(s);
               return true;
          }
          
          override public function readFromSFSObject(o:SFSObject) : void
          {
               readBasicsSFSObject(o);
          }
          
          override public function writeToSFSObject(o:SFSObject) : void
          {
               writeBasicsSFSObject(o);
          }
          
          override public function execute(game:Simulation) : void
          {
               var b:StickWar = StickWar(game);
               b.gameScreen.isPaused = false;
               var t:Team = b.getTeamFromId(owner);
               t.statue.health = 0;
          }
     }
}
