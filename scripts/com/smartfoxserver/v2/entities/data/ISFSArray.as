package com.smartfoxserver.v2.entities.data
{
   import flash.utils.ByteArray;
   
   public interface ISFSArray
   {
       
      
      function contains(obj:*) : Boolean;
      
      function getElementAt(index:int) : *;
      
      function getWrappedElementAt(index:int) : SFSDataWrapper;
      
      function removeElementAt(index:int) : *;
      
      function size() : int;
      
      function toBinary() : ByteArray;
      
      function getDump(format:Boolean = true) : String;
      
      function getHexDump() : String;
      
      function addNull() : void;
      
      function addBool(value:Boolean) : void;
      
      function addByte(value:int) : void;
      
      function addShort(value:int) : void;
      
      function addInt(value:int) : void;
      
      function addLong(value:Number) : void;
      
      function addFloat(value:Number) : void;
      
      function addDouble(value:Number) : void;
      
      function addUtfString(value:String) : void;
      
      function addBoolArray(value:Array) : void;
      
      function addByteArray(value:ByteArray) : void;
      
      function addShortArray(value:Array) : void;
      
      function addIntArray(value:Array) : void;
      
      function addLongArray(value:Array) : void;
      
      function addFloatArray(value:Array) : void;
      
      function addDoubleArray(value:Array) : void;
      
      function addUtfStringArray(value:Array) : void;
      
      function addSFSArray(value:ISFSArray) : void;
      
      function addSFSObject(value:ISFSObject) : void;
      
      function addClass(value:*) : void;
      
      function add(wrappedObject:SFSDataWrapper) : void;
      
      function isNull(index:int) : Boolean;
      
      function getBool(index:int) : Boolean;
      
      function getByte(index:int) : int;
      
      function getUnsignedByte(index:int) : int;
      
      function getShort(index:int) : int;
      
      function getInt(index:int) : int;
      
      function getLong(index:int) : Number;
      
      function getFloat(index:int) : Number;
      
      function getDouble(index:int) : Number;
      
      function getUtfString(index:int) : String;
      
      function getBoolArray(index:int) : Array;
      
      function getByteArray(index:int) : ByteArray;
      
      function getUnsignedByteArray(index:int) : Array;
      
      function getShortArray(index:int) : Array;
      
      function getIntArray(index:int) : Array;
      
      function getLongArray(index:int) : Array;
      
      function getFloatArray(index:int) : Array;
      
      function getDoubleArray(index:int) : Array;
      
      function getUtfStringArray(index:int) : Array;
      
      function getSFSArray(index:int) : ISFSArray;
      
      function getSFSObject(index:int) : ISFSObject;
      
      function getClass(index:int) : *;
   }
}
