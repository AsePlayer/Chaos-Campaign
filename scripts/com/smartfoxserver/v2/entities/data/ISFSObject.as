package com.smartfoxserver.v2.entities.data
{
   import flash.utils.ByteArray;
   
   public interface ISFSObject
   {
       
      
      function isNull(key:String) : Boolean;
      
      function containsKey(key:String) : Boolean;
      
      function removeElement(key:String) : void;
      
      function getKeys() : Array;
      
      function size() : int;
      
      function toBinary() : ByteArray;
      
      function toObject() : Object;
      
      function getDump(format:Boolean = true) : String;
      
      function getHexDump() : String;
      
      function getData(key:String) : SFSDataWrapper;
      
      function getBool(key:String) : Boolean;
      
      function getByte(key:String) : int;
      
      function getUnsignedByte(key:String) : int;
      
      function getShort(key:String) : int;
      
      function getInt(key:String) : int;
      
      function getLong(key:String) : Number;
      
      function getFloat(key:String) : Number;
      
      function getDouble(key:String) : Number;
      
      function getUtfString(key:String) : String;
      
      function getBoolArray(key:String) : Array;
      
      function getByteArray(key:String) : ByteArray;
      
      function getUnsignedByteArray(key:String) : Array;
      
      function getShortArray(key:String) : Array;
      
      function getIntArray(key:String) : Array;
      
      function getLongArray(key:String) : Array;
      
      function getFloatArray(key:String) : Array;
      
      function getDoubleArray(key:String) : Array;
      
      function getUtfStringArray(key:String) : Array;
      
      function getSFSArray(key:String) : ISFSArray;
      
      function getSFSObject(key:String) : ISFSObject;
      
      function getClass(key:String) : *;
      
      function putNull(key:String) : void;
      
      function putBool(key:String, value:Boolean) : void;
      
      function putByte(key:String, value:int) : void;
      
      function putShort(key:String, value:int) : void;
      
      function putInt(key:String, value:int) : void;
      
      function putLong(key:String, value:Number) : void;
      
      function putFloat(key:String, value:Number) : void;
      
      function putDouble(key:String, value:Number) : void;
      
      function putUtfString(key:String, value:String) : void;
      
      function putBoolArray(key:String, value:Array) : void;
      
      function putByteArray(key:String, value:ByteArray) : void;
      
      function putShortArray(key:String, value:Array) : void;
      
      function putIntArray(key:String, value:Array) : void;
      
      function putLongArray(key:String, value:Array) : void;
      
      function putFloatArray(key:String, value:Array) : void;
      
      function putDoubleArray(key:String, value:Array) : void;
      
      function putUtfStringArray(key:String, value:Array) : void;
      
      function putSFSArray(key:String, value:ISFSArray) : void;
      
      function putSFSObject(key:String, value:ISFSObject) : void;
      
      function putClass(key:String, value:*) : void;
      
      function put(key:String, value:SFSDataWrapper) : void;
   }
}
