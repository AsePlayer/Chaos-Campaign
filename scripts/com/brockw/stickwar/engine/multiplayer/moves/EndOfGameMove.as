package com.brockw.stickwar.engine.multiplayer.moves
{
     import com.brockw.simulationSync.Move;
     import com.brockw.simulationSync.Simulation;
     import com.brockw.stickwar.engine.StickWar;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     
     public class EndOfGameMove extends Move
     {
           
          
          private var _winner:int;
          
          public function EndOfGameMove()
          {
               type = Commands.END_OF_GAME;
               this._winner = -1;
               super();
          }
          
          override public function toString() : String
          {
               var s:String = super.toString();
               return s + (String(this._winner) + " ");
          }
          
          override public function fromString(s:Array) : Boolean
          {
               super.fromString(s);
               this._winner = int(s.shift());
               return true;
          }
          
          override public function readFromSFSObject(o:SFSObject) : void
          {
               readBasicsSFSObject(o);
               this._winner = o.getInt("winner");
          }
          
          override public function writeToSFSObject(o:SFSObject) : void
          {
               writeBasicsSFSObject(o);
               o.putInt("winner",this._winner);
          }
          
          override public function execute(game:Simulation) : void
          {
               var b:StickWar = StickWar(game);
               b.gameOver = true;
          }
          
          public function get winner() : int
          {
               return this._winner;
          }
          
          public function set winner(value:int) : void
          {
               this._winner = value;
          }
     }
}
