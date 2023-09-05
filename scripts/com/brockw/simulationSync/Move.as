package com.brockw.simulationSync
{
     import com.brockw.ds.Comparable;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     
     public class Move implements Comparable
     {
          
          public static const END_OF_TURN:int = 0;
           
          
          private var _type:int;
          
          private var _frame:int;
          
          private var _owner:int;
          
          private var _turn:int;
          
          public var position:int;
          
          public function Move()
          {
               super();
          }
          
          public function init(owner:int, frame:int, turn:int) : void
          {
               this._owner = owner;
               this._frame = frame;
               this._turn = turn;
          }
          
          public function compare(other:Object) : int
          {
               if(this.frame == other.frame)
               {
                    return this.owner - other.owner;
               }
               return this.frame - other.frame;
          }
          
          public function readFromSFSObject(o:SFSObject) : void
          {
          }
          
          public function writeToSFSObject(o:SFSObject) : void
          {
          }
          
          public function toString() : String
          {
               var s:String = "";
               s += String(this._owner) + " ";
               s += String(this._frame) + " ";
               s += String(this._turn) + " ";
               return s + (String(this.type) + " ");
          }
          
          public function fromString(s:Array) : Boolean
          {
               this._owner = int(s.shift());
               this._frame = int(s.shift());
               this._turn = int(s.shift());
               this.type = int(s.shift());
               return true;
          }
          
          protected function writeBasicsSFSObject(o:SFSObject) : void
          {
               o.putInt("owner",this._owner);
               o.putInt("frame",this._frame);
               o.putInt("turn",this._turn);
               o.putInt("type",this.type);
          }
          
          protected function readBasicsSFSObject(o:SFSObject) : void
          {
               this._owner = o.getInt("owner");
               this._frame = o.getInt("frame");
               this._turn = o.getInt("turn");
               this._type = o.getInt("type");
          }
          
          public function execute(game:Simulation) : void
          {
          }
          
          public function get frame() : int
          {
               return this._frame;
          }
          
          public function set frame(value:int) : void
          {
               this._frame = value;
          }
          
          public function get type() : int
          {
               return this._type;
          }
          
          public function set type(value:int) : void
          {
               this._type = value;
          }
          
          public function get owner() : int
          {
               return this._owner;
          }
          
          public function set owner(value:int) : void
          {
               this._owner = value;
          }
          
          public function get turn() : int
          {
               return this._turn;
          }
          
          public function set turn(value:int) : void
          {
               this._turn = value;
          }
     }
}
