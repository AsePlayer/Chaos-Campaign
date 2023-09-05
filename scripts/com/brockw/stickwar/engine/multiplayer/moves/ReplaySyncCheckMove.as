package com.brockw.stickwar.engine.multiplayer.moves
{
     import com.brockw.simulationSync.Move;
     import com.brockw.simulationSync.Simulation;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     
     public class ReplaySyncCheckMove extends Move
     {
           
          
          public var checkSum:int;
          
          public function ReplaySyncCheckMove()
          {
               type = Commands.REPLAY_SYNC_CHECK;
               this.checkSum = 0;
               super();
          }
          
          override public function toString() : String
          {
               var s:String = super.toString();
               return s + (String(this.checkSum) + " ");
          }
          
          override public function fromString(s:Array) : Boolean
          {
               super.fromString(s);
               this.checkSum = int(s.shift());
               return true;
          }
          
          override public function readFromSFSObject(o:SFSObject) : void
          {
               readBasicsSFSObject(o);
               this.checkSum = o.getInt("checkSum");
          }
          
          override public function writeToSFSObject(o:SFSObject) : void
          {
               writeBasicsSFSObject(o);
               o.putInt("checkSum",this.checkSum);
          }
          
          override public function execute(game:Simulation) : void
          {
               trace(this.frame,this.turn,game.getCheckSum(),this.checkSum);
          }
     }
}
