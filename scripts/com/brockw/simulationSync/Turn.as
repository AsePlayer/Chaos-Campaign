package com.brockw.simulationSync
{
     import com.brockw.ds.Heap;
     
     public class Turn
     {
           
          
          private var _frameRate:int;
          
          private var _turnSize:int;
          
          private var _ready:Boolean;
          
          private var _ping:Number;
          
          private var _moves:Heap;
          
          private var isEndOfTurn:Boolean;
          
          private var expectedNumberOfMoves:int;
          
          public function Turn()
          {
               super();
               this.moves = new Heap(10000);
               this.turnSize = 5;
               this.frameRate = 30;
               this.ping = 0;
          }
          
          public function init() : void
          {
               this._ready = false;
               this.moves.clear();
               this.isEndOfTurn = false;
          }
          
          public function processMove(move:Move) : void
          {
               var e:EndOfTurnMove = null;
               if(move.type == Move.END_OF_TURN)
               {
                    e = EndOfTurnMove(move);
                    this.isEndOfTurn = true;
                    this.expectedNumberOfMoves = e.expectedNumberOfMoves;
                    this.turnSize = e.turnSize;
                    this.frameRate = e.frameRate;
                    this.ping = e.ping;
               }
               else
               {
                    this.moves.insert(move);
               }
               if(this.isEndOfTurn && this.moves.size() == this.expectedNumberOfMoves)
               {
                    this.ready = true;
               }
          }
          
          public function getNumberOfMoves() : int
          {
               return this.moves.size();
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
          
          public function get ready() : Boolean
          {
               return this._ready;
          }
          
          public function set ready(value:Boolean) : void
          {
               this._ready = value;
          }
          
          public function get moves() : Heap
          {
               return this._moves;
          }
          
          public function set moves(value:Heap) : void
          {
               this._moves = value;
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
