package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Unit;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class UnitMove extends Move
   {
      
      private static const MAX_PER_COLUMN = 6;
       
      
      private var _type:int;
      
      private var _units:Array;
      
      private var _moveType:int;
      
      public var arg0:int;
      
      public var arg1:int;
      
      public var arg2:int;
      
      public var arg3:int;
      
      public var arg4:int;
      
      public var queued:Boolean;
      
      private var game:StickWar;
      
      public function UnitMove()
      {
         type = Commands.UNIT_MOVE;
         this.units = new Array();
         this.moveType = 0;
         this.queued = false;
         super();
         this.arg0 = 0;
         this.arg1 = 0;
         this.arg2 = 0;
         this.arg3 = -1;
         this.arg4 = -1;
      }
      
      public function get moveType() : int
      {
         return this._moveType;
      }
      
      public function set moveType(value:int) : void
      {
         this._moveType = value;
      }
      
      public function get units() : Array
      {
         return this._units;
      }
      
      public function set units(value:Array) : void
      {
         this._units = value;
      }
      
      override public function toString() : String
      {
         var unit:* = null;
         var s:String = super.toString();
         s += String(this.units.length) + " ";
         for(unit in this._units)
         {
            s += String(this._units[unit]) + " ";
         }
         s += String(this.moveType) + " ";
         s += String(this.arg0) + " ";
         s += String(this.arg1) + " ";
         s += String(this.arg2) + " ";
         s += String(this.arg3) + " ";
         s += String(this.arg4) + " ";
         if(this.queued)
         {
            s += String(1) + " ";
         }
         else
         {
            s += String(0) + " ";
         }
         return s;
      }
      
      override public function fromString(s:Array) : Boolean
      {
         var i:* = undefined;
         super.fromString(s);
         var num:int = int(s.shift());
         i = 0;
         while(i < num)
         {
            this.units.push(int(s.shift()));
            i++;
         }
         this.moveType = int(s.shift());
         this.arg0 = Number(s.shift());
         this.arg1 = Number(s.shift());
         this.arg2 = Number(s.shift());
         this.arg3 = Number(s.shift());
         this.arg4 = Number(s.shift());
         this.queued = Boolean(int(s.shift()));
         return true;
      }
      
      override public function readFromSFSObject(o:SFSObject) : void
      {
         var unit:int = 0;
         readBasicsSFSObject(o);
         this.moveType = o.getInt("m");
         var s:ISFSArray = o.getSFSArray("u");
         unit = 0;
         while(unit < s.size())
         {
            this.units.push(s.getElementAt(unit));
            unit++;
         }
         this.arg0 = o.getInt("0");
         this.arg1 = o.getInt("1");
         this.arg2 = o.getInt("2");
         this.arg3 = o.getInt("3");
         this.arg4 = o.getInt("4");
         this.queued = o.getBool("q");
      }
      
      override public function writeToSFSObject(o:SFSObject) : void
      {
         var unit:* = null;
         writeBasicsSFSObject(o);
         var s:SFSArray = new SFSArray();
         for(unit in this._units)
         {
            s.addInt(this._units[unit]);
         }
         o.putSFSArray("u",s);
         o.putInt("m",this.moveType);
         o.putInt("0",this.arg0);
         o.putInt("1",this.arg1);
         o.putInt("2",this.arg2);
         o.putInt("3",this.arg3);
         o.putInt("4",this.arg4);
         o.putBool("q",this.queued);
      }
      
      private function formationOrder(a:int, b:int) : Number
      {
         if(Unit(this.game.units[a]) == null)
         {
            return -1;
         }
         if(Unit(this.game.units[b]) == null)
         {
            return 1;
         }
         if(Unit(this.game.units[a]).type != Unit(this.game.units[b]).type)
         {
            return Unit(this.game.units[b]).type - Unit(this.game.units[a]).type;
         }
         return Unit(this.game.units[a]).id - Unit(this.game.units[b]).id;
      }
      
      private function mapRowsToInside(p:int, numInColumn:int) : int
      {
         return Math.floor((numInColumn - 1) / 2) + (p % 2 * 2 - 1) * Math.ceil(p / 2);
      }
      
      override public function execute(game:Simulation) : void
      {
         var t:Team = null;
         var num:int = 0;
         var ROW_OFFSET:int = 0;
         var frontX:Number = NaN;
         var i:int = 0;
         var col:int = 0;
         var row:int = 0;
         var yMousePosition:* = undefined;
         var numInColumn:int = 0;
         var goalRow:int = 0;
         var middle:* = undefined;
         var offset:* = undefined;
         var height:int = 0;
         var actualHeight:* = 0;
         var g:StickWar = null;
         var goalX:Number = NaN;
         var goalY:Number = NaN;
         var unit:* = null;
         var b:StickWar = StickWar(game);
         if(this.moveType == UnitCommand.TECH)
         {
            t = StickWar(game).teamA;
            if(t.id != this.arg1)
            {
               t = t.enemyTeam;
            }
            if(!t.tech.isResearching(this.arg0))
            {
               t.tech.startResearching(this.arg0);
            }
         }
         else if(this.moveType == UnitCommand.MOVE || this.moveType == UnitCommand.ATTACK_MOVE)
         {
            this.game = StickWar(game);
            this._units.sort(this.formationOrder);
            num = int(this._units.length);
            ROW_OFFSET = 50;
            frontX = this.arg0;
            i = 0;
            while(i < this._units.length)
            {
               if(this._units[i] in b.units)
               {
                  col = i / MAX_PER_COLUMN;
                  row = i % MAX_PER_COLUMN;
                  yMousePosition = Math.min(StickWar(game).map.height,Math.max(0,this.arg1));
                  numInColumn = Math.min(MAX_PER_COLUMN,this._units.length - Math.floor(i / MAX_PER_COLUMN) * MAX_PER_COLUMN);
                  row = this.mapRowsToInside(row,numInColumn);
                  goalRow = Math.round(yMousePosition / (StickWar(game).map.height / MAX_PER_COLUMN));
                  middle = Math.floor((numInColumn + 1) / 2);
                  offset = goalRow - middle;
                  if(offset < 0)
                  {
                     offset = 0;
                  }
                  if(offset + numInColumn > MAX_PER_COLUMN)
                  {
                     offset = MAX_PER_COLUMN - numInColumn;
                  }
                  row += offset;
                  height = StickWar(game).map.height;
                  actualHeight = height;
                  g = StickWar(game);
                  goalX = -Unit(b.units[this._units[i]]).team.direction * row * 8 + -col * ROW_OFFSET * Unit(b.units[this._units[i]]).team.direction + frontX;
                  if(goalX < g.teamA.homeX || goalX > g.teamB.homeX || b.units[this._units[i]].px < g.teamA.homeX || b.units[this._units[i]].px > g.teamB.homeX)
                  {
                     actualHeight /= 3;
                  }
                  goalY = (height - actualHeight) / 2 + actualHeight / (2 * MAX_PER_COLUMN) + row * actualHeight / MAX_PER_COLUMN;
                  if(this._units.length == 1)
                  {
                     goalY = yMousePosition;
                  }
                  goalY = Math.min((height - actualHeight) / 2 + actualHeight,Math.max((height - actualHeight) / 2,goalY));
                  if(!(b.units[this._units[i]] is Unit && Unit(b.units[this._units[i]]).isTowerSpawned))
                  {
                     if(this.queued)
                     {
                        Unit(b.units[this._units[i]]).ai.appendCommand(StickWar(game),StickWar(game).commandFactory.createCommand(b,this.moveType,goalX,goalY,this.arg0,this.arg1,this.arg2,this.arg3,this.arg4,this._units.length > 1 ? Boolean(true) : Boolean(false)));
                     }
                     else
                     {
                        Unit(b.units[this._units[i]]).ai.setCommand(StickWar(game),StickWar(game).commandFactory.createCommand(b,this.moveType,goalX,goalY,this.arg0,this.arg1,this.arg2,this.arg3,this.arg4,this._units.length > 1 ? Boolean(true) : Boolean(false)));
                     }
                  }
               }
               i++;
            }
         }
         else
         {
            for(unit in this._units)
            {
               if(this._units[unit] in b.units)
               {
                  if(!(b.units[this._units[unit]] is Unit && Unit(b.units[this._units[unit]]).isTowerSpawned))
                  {
                     if(this.queued)
                     {
                        Unit(b.units[this._units[unit]]).ai.appendCommand(StickWar(game),StickWar(game).commandFactory.createCommand(b,this.moveType,goalX,goalY,this.arg0,this.arg1,this.arg2,this.arg3,this.arg4));
                     }
                     else
                     {
                        Unit(b.units[this._units[unit]]).ai.setCommand(StickWar(game),StickWar(game).commandFactory.createCommand(b,this.moveType,goalX,goalY,this.arg0,this.arg1,this.arg2,this.arg3,this.arg4));
                     }
                  }
               }
            }
         }
      }
   }
}
