package com.smartfoxserver.v2.entities.variables
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   
   public class SFSRoomVariable extends SFSUserVariable implements RoomVariable
   {
       
      
      private var _isPersistent:Boolean;
      
      private var _isPrivate:Boolean;
      
      public function SFSRoomVariable(name:String, value:*, type:int = -1)
      {
         super(name,value,type);
      }
      
      public static function fromSFSArray(sfsa:ISFSArray) : RoomVariable
      {
         var roomVariable:RoomVariable = new SFSRoomVariable(sfsa.getUtfString(0),sfsa.getElementAt(2),sfsa.getByte(1));
         roomVariable.isPrivate = sfsa.getBool(3);
         roomVariable.isPersistent = sfsa.getBool(4);
         return roomVariable;
      }
      
      public function get isPrivate() : Boolean
      {
         return this._isPrivate;
      }
      
      public function get isPersistent() : Boolean
      {
         return this._isPersistent;
      }
      
      public function set isPrivate(value:Boolean) : void
      {
         this._isPrivate = value;
      }
      
      public function set isPersistent(value:Boolean) : void
      {
         this._isPersistent = value;
      }
      
      override public function toString() : String
      {
         return "[RVar: " + _name + ", type: " + _type + ", value: " + _value + ", isPriv: " + this.isPrivate + "]";
      }
      
      override public function toSFSArray() : ISFSArray
      {
         var arr:ISFSArray = super.toSFSArray();
         arr.addBool(this._isPrivate);
         arr.addBool(this._isPersistent);
         return arr;
      }
   }
}
