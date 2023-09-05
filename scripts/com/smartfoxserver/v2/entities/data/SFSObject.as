package com.smartfoxserver.v2.entities.data
{
     import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
     import com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer;
     import com.smartfoxserver.v2.protocol.serialization.ISFSDataSerializer;
     import flash.utils.ByteArray;
     
     public class SFSObject implements ISFSObject
     {
           
          
          private var dataHolder:Object;
          
          private var serializer:ISFSDataSerializer;
          
          public function SFSObject()
          {
               super();
               this.dataHolder = {};
               this.serializer = DefaultSFSDataSerializer.getInstance();
          }
          
          public static function newFromObject(o:Object, forceToNumber:Boolean = false) : SFSObject
          {
               return DefaultSFSDataSerializer.getInstance().genericObjectToSFSObject(o,forceToNumber);
          }
          
          public static function newFromBinaryData(ba:ByteArray) : SFSObject
          {
               return DefaultSFSDataSerializer.getInstance().binary2object(ba) as SFSObject;
          }
          
          public static function newInstance() : SFSObject
          {
               return new SFSObject();
          }
          
          public function isNull(key:String) : Boolean
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key];
               if(wrapper == null)
               {
                    return true;
               }
               return wrapper.data == null;
          }
          
          public function containsKey(key:String) : Boolean
          {
               var j:String = null;
               var found:Boolean = false;
               for(j in this.dataHolder)
               {
                    if(j == key)
                    {
                         found = true;
                         break;
                    }
               }
               return found;
          }
          
          public function removeElement(key:String) : void
          {
               delete this.dataHolder[key];
          }
          
          public function getKeys() : Array
          {
               var j:String = null;
               var keyList:Array = [];
               for(j in this.dataHolder)
               {
                    keyList.push(j);
               }
               return keyList;
          }
          
          public function size() : int
          {
               var j:String = null;
               var count:int = 0;
               for(j in this.dataHolder)
               {
                    count++;
               }
               return count;
          }
          
          public function toBinary() : ByteArray
          {
               return this.serializer.object2binary(this);
          }
          
          public function toObject() : Object
          {
               return DefaultSFSDataSerializer.getInstance().sfsObjectToGenericObject(this);
          }
          
          public function getDump(format:Boolean = true) : String
          {
               var prettyDump:String = null;
               if(!format)
               {
                    return this.dump();
               }
               try
               {
                    prettyDump = DefaultObjectDumpFormatter.prettyPrintDump(this.dump());
               }
               catch(err:Error)
               {
                    prettyDump = "Unable to provide a dump of this object";
               }
               return prettyDump;
          }
          
          private function dump() : String
          {
               var wrapper:SFSDataWrapper = null;
               var type:int = 0;
               var key:String = null;
               var strDump:String = DefaultObjectDumpFormatter.TOKEN_INDENT_OPEN;
               for(key in this.dataHolder)
               {
                    wrapper = this.getData(key);
                    type = wrapper.type;
                    strDump += "(" + SFSDataType.fromId(wrapper.type).toLowerCase() + ")";
                    strDump += " " + key + ": ";
                    if(type == SFSDataType.SFS_OBJECT)
                    {
                         strDump += (wrapper.data as SFSObject).getDump(false);
                    }
                    else if(type == SFSDataType.SFS_ARRAY)
                    {
                         strDump += (wrapper.data as SFSArray).getDump(false);
                    }
                    else if(type == SFSDataType.BYTE_ARRAY)
                    {
                         strDump += DefaultObjectDumpFormatter.prettyPrintByteArray(wrapper.data as ByteArray);
                    }
                    else if(type > SFSDataType.UTF_STRING && type < SFSDataType.CLASS)
                    {
                         strDump += "[" + wrapper.data + "]";
                    }
                    else
                    {
                         strDump += wrapper.data;
                    }
                    strDump += DefaultObjectDumpFormatter.TOKEN_DIVIDER;
               }
               if(this.size() > 0)
               {
                    strDump = strDump.slice(0,strDump.length - 1);
               }
               return strDump + DefaultObjectDumpFormatter.TOKEN_INDENT_CLOSE;
          }
          
          public function getHexDump() : String
          {
               return DefaultObjectDumpFormatter.hexDump(this.toBinary());
          }
          
          public function getData(key:String) : SFSDataWrapper
          {
               return this.dataHolder[key];
          }
          
          public function getBool(key:String) : Boolean
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data as Boolean;
               }
               return undefined;
          }
          
          public function getByte(key:String) : int
          {
               return this.getInt(key);
          }
          
          public function getUnsignedByte(key:String) : int
          {
               return this.getInt(key) & 255;
          }
          
          public function getShort(key:String) : int
          {
               return this.getInt(key);
          }
          
          public function getInt(key:String) : int
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data as int;
               }
               return undefined;
          }
          
          public function getLong(key:String) : Number
          {
               return this.getDouble(key);
          }
          
          public function getFloat(key:String) : Number
          {
               return this.getDouble(key);
          }
          
          public function getDouble(key:String) : Number
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data as Number;
               }
               return undefined;
          }
          
          public function getUtfString(key:String) : String
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data as String;
               }
               return null;
          }
          
          private function getArray(key:String) : Array
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data as Array;
               }
               return null;
          }
          
          public function getBoolArray(key:String) : Array
          {
               return this.getArray(key);
          }
          
          public function getByteArray(key:String) : ByteArray
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data as ByteArray;
               }
               return null;
          }
          
          public function getUnsignedByteArray(key:String) : Array
          {
               var ba:ByteArray = this.getByteArray(key);
               if(ba == null)
               {
                    return null;
               }
               ba.position = 0;
               var unsignedBytes:Array = [];
               for(var i:int = 0; i < ba.length; i++)
               {
                    unsignedBytes.push(ba.readByte() & 255);
               }
               return unsignedBytes;
          }
          
          public function getShortArray(key:String) : Array
          {
               return this.getArray(key);
          }
          
          public function getIntArray(key:String) : Array
          {
               return this.getArray(key);
          }
          
          public function getLongArray(key:String) : Array
          {
               return this.getArray(key);
          }
          
          public function getFloatArray(key:String) : Array
          {
               return this.getArray(key);
          }
          
          public function getDoubleArray(key:String) : Array
          {
               return this.getArray(key);
          }
          
          public function getUtfStringArray(key:String) : Array
          {
               return this.getArray(key);
          }
          
          public function getSFSArray(key:String) : ISFSArray
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data as ISFSArray;
               }
               return null;
          }
          
          public function getSFSObject(key:String) : ISFSObject
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data as ISFSObject;
               }
               return null;
          }
          
          public function getClass(key:String) : *
          {
               var wrapper:SFSDataWrapper = this.dataHolder[key] as SFSDataWrapper;
               if(wrapper != null)
               {
                    return wrapper.data;
               }
               return null;
          }
          
          public function putNull(key:String) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.NULL,null);
          }
          
          public function putBool(key:String, value:Boolean) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.BOOL,value);
          }
          
          public function putByte(key:String, value:int) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.BYTE,value);
          }
          
          public function putShort(key:String, value:int) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.SHORT,value);
          }
          
          public function putInt(key:String, value:int) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.INT,value);
          }
          
          public function putLong(key:String, value:Number) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.LONG,value);
          }
          
          public function putFloat(key:String, value:Number) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.FLOAT,value);
          }
          
          public function putDouble(key:String, value:Number) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.DOUBLE,value);
          }
          
          public function putUtfString(key:String, value:String) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.UTF_STRING,value);
          }
          
          public function putBoolArray(key:String, value:Array) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.BOOL_ARRAY,value);
          }
          
          public function putByteArray(key:String, value:ByteArray) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.BYTE_ARRAY,value);
          }
          
          public function putShortArray(key:String, value:Array) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.SHORT_ARRAY,value);
          }
          
          public function putIntArray(key:String, value:Array) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.INT_ARRAY,value);
          }
          
          public function putLongArray(key:String, value:Array) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.LONG_ARRAY,value);
          }
          
          public function putFloatArray(key:String, value:Array) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.FLOAT_ARRAY,value);
          }
          
          public function putDoubleArray(key:String, value:Array) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY,value);
          }
          
          public function putUtfStringArray(key:String, value:Array) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY,value);
          }
          
          public function putSFSArray(key:String, value:ISFSArray) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.SFS_ARRAY,value);
          }
          
          public function putSFSObject(key:String, value:ISFSObject) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.SFS_OBJECT,value);
          }
          
          public function putClass(key:String, value:*) : void
          {
               this.dataHolder[key] = new SFSDataWrapper(SFSDataType.CLASS,value);
          }
          
          public function put(key:String, value:SFSDataWrapper) : void
          {
               this.dataHolder[key] = value;
          }
     }
}
