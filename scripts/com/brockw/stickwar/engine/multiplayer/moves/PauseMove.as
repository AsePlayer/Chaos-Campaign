package com.brockw.stickwar.engine.multiplayer.moves
{
     import com.brockw.simulationSync.Move;
     import com.brockw.simulationSync.Simulation;
     import com.brockw.stickwar.engine.StickWar;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     
     public class PauseMove extends Move
     {
           
          
          public function PauseMove()
          {
               type = Commands.PAUSE;
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
               if(b.teamA.id == this.owner)
               {
                    ++b.teamA.pauseCount;
                    if(b.teamA.pauseCount > 6)
                    {
                         return;
                    }
               }
               else if(b.teamB.id == this.owner)
               {
                    ++b.teamB.pauseCount;
                    if(b.teamB.pauseCount > 6)
                    {
                         return;
                    }
               }
               b.gameScreen.isPaused = !b.gameScreen.isPaused;
          }
     }
}
