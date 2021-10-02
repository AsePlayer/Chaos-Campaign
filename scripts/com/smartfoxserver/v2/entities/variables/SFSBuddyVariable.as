package com.smartfoxserver.v2.entities.variables
{
   import as3reflect.Type;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.exceptions.SFSError;
   
   public class SFSBuddyVariable implements BuddyVariable
   {
      
      public static const OFFLINE_PREFIX:String = "$";
       
      
      protected var _name:String;
      
      protected var _type:String;
      
      protected var _value;
      
      public function SFSBuddyVariable(name:String, value:*, type:int = -1)
      {
         super();
         this._name = name;
         if(type > -1)
         {
            this._value = value;
            this._type = VariableType.getTypeName(type);
         }
         else
         {
            this.setValue(value);
         }
      }
      
      public static function fromSFSArray(sfsa:ISFSArray) : BuddyVariable
      {
         return new SFSBuddyVariable(sfsa.getUtfString(0),sfsa.getElementAt(2),sfsa.getByte(1));
      }
      
      public function get isOffline() : Boolean
      {
         return this._name.charAt(0) == "$";
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function getValue() : *
      {
         return this._value;
      }
      
      public function getBoolValue() : Boolean
      {
         return this._value as Boolean;
      }
      
      public function getIntValue() : int
      {
         return this._value as int;
      }
      
      public function getDoubleValue() : Number
      {
         return this._value as Number;
      }
      
      public function getStringValue() : String
      {
         return this._value as String;
      }
      
      public function getSFSObjectValue() : ISFSObject
      {
         return this._value as ISFSObject;
      }
      
      public function getSFSArrayValue() : ISFSArray
      {
         return this._value as ISFSArray;
      }
      
      public function isNull() : Boolean
      {
         return this.type == VariableType.getTypeName(VariableType.NULL);
      }
      
      public function toSFSArray() : ISFSArray
      {
         var sfsa:ISFSArray = SFSArray.newInstance();
         sfsa.addUtfString(this._name);
         sfsa.addByte(VariableType.getTypeFromName(this._type));
         this.populateArrayWithValue(sfsa);
         return sfsa;
      }
      
      public function toString() : String
      {
         return "[BuddyVar: " + this._name + ", type: " + this._type + ", value: " + this._value + "]";
      }
      
      private function populateArrayWithValue(arr:ISFSArray) : void
      {
         var typeId:int = VariableType.getTypeFromName(this._type);
         switch(typeId)
         {
            case VariableType.NULL:
               arr.addNull();
               break;
            case VariableType.BOOL:
               arr.addBool(this.getBoolValue());
               break;
            case VariableType.INT:
               arr.addInt(this.getIntValue());
               break;
            case VariableType.DOUBLE:
               arr.addDouble(this.getDoubleValue());
               break;
            case VariableType.STRING:
               arr.addUtfString(this.getStringValue());
               break;
            case VariableType.OBJECT:
               arr.addSFSObject(this.getSFSObjectValue());
               break;
            case VariableType.ARRAY:
               arr.addSFSArray(this.getSFSArrayValue());
         }
      }
      
      private function setValue(value:*) : void
      {
         var typeName:String = null;
         var className:String = null;
         this._value = value;
         if(value == null)
         {
            this._type = VariableType.getTypeName(VariableType.NULL);
         }
         else
         {
            typeName = typeof value;
            if(typeName == "boolean")
            {
               this._type = VariableType.getTypeName(VariableType.BOOL);
            }
            else if(typeName == "number")
            {
               if(int(value) == value)
               {
                  this._type = VariableType.getTypeName(VariableType.INT);
               }
               else
               {
                  this._type = VariableType.getTypeName(VariableType.DOUBLE);
               }
            }
            else if(typeName == "string")
            {
               this._type = VariableType.getTypeName(VariableType.STRING);
            }
            else if(typeName == "object")
            {
               className = Type.forInstance(value).name;
               if(className == "SFSObject")
               {
                  this._type = VariableType.getTypeName(VariableType.OBJECT);
               }
               else
               {
                  if(className != "SFSArray")
                  {
                     throw new SFSError("Unsupport SFS Variable type: " + className);
                  }
                  this._type = VariableType.getTypeName(VariableType.ARRAY);
               }
            }
         }
      }
   }
}
