package com.brockw.simulationSync
{
   import com.brockw.stickwar.engine.multiplayer.moves.Commands;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class EndOfTurnMove extends Move
   {
       
      
      private var _expectedNumberOfMoves:int;
      
      private var _frameRate:int;
      
      private var _turnSize:int;
      
      private var _ping:Number;
      
      public function EndOfTurnMove()
      {
         type = Commands.END_OF_TURN;
         super();
      }
      
      override public function readFromSFSObject(o:SFSObject) : void
      {
         readBasicsSFSObject(o);
         this._expectedNumberOfMoves = o.getInt("n");
         this._frameRate = o.getInt("f");
         this._turnSize = o.getInt("t");
         this._ping = o.getFloat("p");
      }
      
      override public function toString() : String
      {
         var s:String = super.toString();
         s += String(this._expectedNumberOfMoves) + " ";
         s += String(this._frameRate) + " ";
         return s + String(this._turnSize);
      }
      
      override public function fromString(s:Array) : Boolean
      {
         super.fromString(s);
         this._expectedNumberOfMoves = int(s.shift());
         this._frameRate = int(s.shift());
         this._turnSize = int(s.shift());
         return true;
      }
      
      override public function writeToSFSObject(o:SFSObject) : void
      {
         writeBasicsSFSObject(o);
         o.putInt("f",this._frameRate);
         o.putInt("t",this._turnSize);
         o.putInt("n",this._expectedNumberOfMoves);
      }
      
      override public function execute(game:Simulation) : void
      {
      }
      
      public function get expectedNumberOfMoves() : int
      {
         return this._expectedNumberOfMoves;
      }
      
      public function set expectedNumberOfMoves(value:int) : void
      {
         this._expectedNumberOfMoves = value;
      }
      
      public function get frameRate() : int
      {
         return this._frameRate;
      }
      
      public function set frameRate(value:int) : void
      {
         this._frameRate = value;
      }
      
      public function get turnSize() : int
      {
         return this._turnSize;
      }
      
      public function set turnSize(value:int) : void
      {
         this._turnSize = value;
      }
      
      public function get ping() : Number
      {
         return this._ping;
      }
      
      public function set ping(value:Number) : void
      {
         this._ping = value;
      }
   }
}
