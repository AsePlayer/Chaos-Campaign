package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class UnitCreateMove extends Move
   {
       
      
      private var _unitType:int;
      
      public function UnitCreateMove()
      {
         type = Commands.UNIT_CREATE_MOVE;
         this._unitType = Unit.U_SWORDWRATH;
         super();
      }
      
      override public function toString() : String
      {
         var s:String = super.toString();
         return s + (String(this._unitType) + " ");
      }
      
      override public function fromString(s:Array) : Boolean
      {
         super.fromString(s);
         this._unitType = int(s.shift());
         return true;
      }
      
      override public function readFromSFSObject(o:SFSObject) : void
      {
         readBasicsSFSObject(o);
         this._unitType = o.getInt("u");
      }
      
      override public function writeToSFSObject(o:SFSObject) : void
      {
         writeBasicsSFSObject(o);
         o.putInt("u",this._unitType);
      }
      
      override public function execute(game:Simulation) : void
      {
         var b:StickWar = StickWar(game);
         b.requestToSpawn(this.owner,this._unitType);
      }
      
      public function get unitType() : int
      {
         return this._unitType;
      }
      
      public function set unitType(value:int) : void
      {
         this._unitType = value;
      }
   }
}
