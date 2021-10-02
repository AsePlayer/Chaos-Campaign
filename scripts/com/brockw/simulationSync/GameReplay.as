package com.brockw.simulationSync
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.Commands;
   import com.brockw.stickwar.engine.multiplayer.moves.MoveFactory;
   import com.brockw.stickwar.engine.multiplayer.moves.ReplaySyncCheckMove;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class GameReplay
   {
      
      public static const checkSumFrequency:int = 1;
       
      
      private var moves:Array;
      
      private var index:int;
      
      private var _isPlaying:Boolean;
      
      private var tempSFSObject:SFSObject;
      
      private var _teamAId:int;
      
      private var _teamBId:int;
      
      private var _teamAType:int;
      
      private var _teamBType:int;
      
      private var _teamAName:String;
      
      private var _teamBName:String;
      
      private var _teamALoadout:String;
      
      private var _teamBLoadout:String;
      
      private var _mapId:int;
      
      public function GameReplay()
      {
         super();
         this.moves = [];
         this.index = 0;
         this.isPlaying = false;
         this.tempSFSObject = new SFSObject();
         this._teamBLoadout = this._teamALoadout = "";
      }
      
      public function isFinished() : Boolean
      {
         return this.moves.length == 0;
      }
      
      public function play(simulation:SimulationSyncronizer) : void
      {
         var _loc2_:Move = null;
         while(this.moves.length != 0)
         {
            _loc2_ = this.moves[0];
            if(_loc2_.turn != simulation.turn - 1)
            {
               break;
            }
            simulation.processMove(_loc2_);
            this.moves.shift();
            if(_loc2_.type == Move.END_OF_TURN)
            {
               _loc2_ = this.moves[0];
               if(_loc2_ != null && _loc2_.type == Commands.REPLAY_SYNC_CHECK)
               {
                  trace("replay check");
                  simulation.processMove(_loc2_);
                  this.moves.shift();
               }
               break;
            }
         }
      }
      
      public function addSyncCheck(simSync:SimulationSyncronizer) : void
      {
         var checkMove:ReplaySyncCheckMove = null;
         var game:Simulation = simSync.game;
         if(simSync.turn % checkSumFrequency == 0)
         {
            checkMove = new ReplaySyncCheckMove();
            checkMove.checkSum = game.getCheckSum();
            checkMove.turn = simSync.turn - 1;
            checkMove.frame = simSync.frame;
            Util.clearSFSObject(this.tempSFSObject);
            checkMove.writeToSFSObject(this.tempSFSObject);
            this.moves.push(checkMove);
         }
      }
      
      public function addMove(move:Move, simSync:SimulationSyncronizer) : void
      {
         if(move != null)
         {
            Util.clearSFSObject(this.tempSFSObject);
            move.writeToSFSObject(this.tempSFSObject);
            this.moves.push(move);
         }
      }
      
      public function toString(game:StickWar) : String
      {
         var m:Move = null;
         var s:String = "";
         s += String(game.mapId) + "&" + String(game.teamA.id) + "&" + String(game.teamA.originalType) + "&" + String(game.teamA.realName) + "&" + game.teamA.loadout.toString() + "&" + String(game.teamB.id) + "&" + String(game.teamB.originalType) + "&" + String(game.teamB.realName) + "&" + game.teamB.loadout.toString() + "$";
         for(var i:* = 0; i < this.moves.length; i++)
         {
            m = this.moves[i];
            s += String(m.type) + ";" + m.toString() + ":";
         }
         return s.length + "#" + s;
      }
      
      public function fromString(s:String) : Boolean
      {
         var _loc8_:Move = null;
         var _loc9_:Array = null;
         var _loc2_:* = s.split("#");
         var _loc3_:int = _loc2_[0];
         if(_loc2_.length != 2)
         {
            return false;
         }
         if(_loc3_ != _loc2_[1].length)
         {
            trace("Replay broken",_loc3_,_loc2_[1].length);
            return false;
         }
         var _loc4_:Array = _loc2_[1].split("$");
         var _loc5_:Array = _loc4_[0].split("&");
         this.mapId = _loc5_.shift();
         this.teamAId = _loc5_.shift();
         this._teamAType = _loc5_.shift();
         this._teamAName = _loc5_.shift();
         this._teamALoadout = _loc5_.shift();
         this.teamBId = _loc5_.shift();
         this._teamBType = _loc5_.shift();
         this._teamBName = _loc5_.shift();
         this._teamBLoadout = _loc5_.shift();
         if(_loc4_.length != 2)
         {
            return false;
         }
         var _loc6_:Array = _loc4_[1].split(":");
         for(var _loc7_:* = 0; _loc7_ < _loc6_.length - 1; _loc7_++)
         {
            _loc9_ = _loc6_[_loc7_].split(";");
            _loc8_ = MoveFactory.createMoveFromString(_loc9_[0],_loc9_[1].split(" "));
            this.moves.push(_loc8_);
         }
         this.moves.sort(this.turnOrder);
         for each(_loc8_ in this.moves)
         {
         }
         return true;
      }
      
      private function turnOrder(a:Move, b:Move) : int
      {
         if(a.turn == b.turn)
         {
            if(a.type == Commands.END_OF_TURN)
            {
               return -1;
            }
            if(b.type == Commands.END_OF_TURN)
            {
               return 1;
            }
            if(a.type == Commands.REPLAY_SYNC_CHECK)
            {
               return 1;
            }
            if(b.type == Commands.REPLAY_SYNC_CHECK)
            {
               return -1;
            }
         }
         return a.turn - b.turn;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function set isPlaying(value:Boolean) : void
      {
         this._isPlaying = value;
      }
      
      public function get teamAId() : int
      {
         return this._teamAId;
      }
      
      public function set teamAId(value:int) : void
      {
         this._teamAId = value;
      }
      
      public function get teamBId() : int
      {
         return this._teamBId;
      }
      
      public function set teamBId(value:int) : void
      {
         this._teamBId = value;
      }
      
      public function get teamAType() : int
      {
         return this._teamAType;
      }
      
      public function set teamAType(value:int) : void
      {
         this._teamAType = value;
      }
      
      public function get teamBType() : int
      {
         return this._teamBType;
      }
      
      public function set teamBType(value:int) : void
      {
         this._teamBType = value;
      }
      
      public function get teamAName() : String
      {
         return this._teamAName;
      }
      
      public function set teamAName(value:String) : void
      {
         this._teamAName = value;
      }
      
      public function get teamBName() : String
      {
         return this._teamBName;
      }
      
      public function set teamBName(value:String) : void
      {
         this._teamBName = value;
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function set mapId(value:int) : void
      {
         this._mapId = value;
      }
      
      public function get teamBLoadout() : String
      {
         return this._teamBLoadout;
      }
      
      public function set teamBLoadout(value:String) : void
      {
         this._teamBLoadout = value;
      }
      
      public function get teamALoadout() : String
      {
         return this._teamALoadout;
      }
      
      public function set teamALoadout(value:String) : void
      {
         this._teamALoadout = value;
      }
   }
}
