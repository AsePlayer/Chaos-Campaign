package com.smartfoxserver.v2.entities.data
{
     import com.smartfoxserver.v2.exceptions.SFSError;
     import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
     import com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer;
     import com.smartfoxserver.v2.protocol.serialization.ISFSDataSerializer;
     import flash.utils.ByteArray;
     
     public class SFSArray implements ISFSArray
     {
           
          
          private var serializer:ISFSDataSerializer;
          
          private var dataHolder:Array;
          
          public function SFSArray()
          {
               super();
               this.dataHolder = [];
               this.serializer = DefaultSFSDataSerializer.getInstance();
          }
          
          public static function newFromArray(arr:Array, forceToNumber:Boolean = false) : SFSArray
          {
               return DefaultSFSDataSerializer.getInstance().genericArrayToSFSArray(arr,forceToNumber);
          }
          
          public static function newFromBinaryData(ba:ByteArray) : SFSArray
          {
               return DefaultSFSDataSerializer.getInstance().binary2array(ba) as SFSArray;
          }
          
          public static function newInstance() : SFSArray
          {
               return new SFSArray();
          }
          
          public function contains(obj:*) : Boolean
          {
               var element:* = undefined;
               if(obj is ISFSArray || obj is ISFSObject)
               {
                    throw new SFSError("ISFSArray and ISFSObject are not supported by this method.");
               }
               var found:Boolean = false;
               for(var j:int = 0; j < this.size(); j++)
               {
                    element = this.getElementAt(j);
                    if(element != null && element == obj)
                    {
                         found = true;
                         break;
                    }
               }
               return found;
          }
          
          public function getWrappedElementAt(index:int) : SFSDataWrapper
          {
               return this.dataHolder[index];
          }
          
          public function getElementAt(index:int) : *
          {
               var obj:* = null;
               if(this.dataHolder[index] != null)
               {
                    obj = this.dataHolder[index].data;
               }
               return obj;
          }
          
          public function removeElementAt(index:int) : *
          {
               this.dataHolder.splice(index,1);
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
               return this.serializer.array2binary(this);
          }
          
          public function toArray() : Array
          {
               return DefaultSFSDataSerializer.getInstance().sfsArrayToGenericArray(this);
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
               var objDump:String = null;
               var type:int = 0;
               var key:String = null;
               var strDump:String = DefaultObjectDumpFormatter.TOKEN_INDENT_OPEN;
               for(key in this.dataHolder)
               {
                    wrapper = this.dataHolder[key];
                    type = wrapper.type;
                    if(type == SFSDataType.SFS_OBJECT)
                    {
                         objDump = (wrapper.data as SFSObject).getDump(false);
                    }
                    else if(type == SFSDataType.SFS_ARRAY)
                    {
                         objDump = (wrapper.data as SFSArray).getDump(false);
                    }
                    else if(type > SFSDataType.UTF_STRING && type < SFSDataType.CLASS)
                    {
                         objDump = "[" + wrapper.data + "]";
                    }
                    else if(type == SFSDataType.BYTE_ARRAY)
                    {
                         objDump = DefaultObjectDumpFormatter.prettyPrintByteArray(wrapper.data as ByteArray);
                    }
                    else
                    {
                         objDump = wrapper.data;
                    }
                    strDump += "(" + SFSDataType.fromId(wrapper.type).toLowerCase() + ") ";
                    strDump += objDump;
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
          
          public function addNull() : void
          {
               this.addObject(null,SFSDataType.NULL);
          }
          
          public function addBool(value:Boolean) : void
          {
               this.addObject(value,SFSDataType.BOOL);
          }
          
          public function addByte(value:int) : void
          {
               this.addObject(value,SFSDataType.BYTE);
          }
          
          public function addShort(value:int) : void
          {
               this.addObject(value,SFSDataType.SHORT);
          }
          
          public function addInt(value:int) : void
          {
               this.addObject(value,SFSDataType.INT);
          }
          
          public function addLong(value:Number) : void
          {
               this.addObject(value,SFSDataType.LONG);
          }
          
          public function addFloat(value:Number) : void
          {
               this.addObject(value,SFSDataType.FLOAT);
          }
          
          public function addDouble(value:Number) : void
          {
               this.addObject(value,SFSDataType.DOUBLE);
          }
          
          public function addUtfString(value:String) : void
          {
               this.addObject(value,SFSDataType.UTF_STRING);
          }
          
          public function addBoolArray(value:Array) : void
          {
               this.addObject(value,SFSDataType.BOOL_ARRAY);
          }
          
          public function addByteArray(value:ByteArray) : void
          {
               this.addObject(value,SFSDataType.BYTE_ARRAY);
          }
          
          public function addShortArray(value:Array) : void
          {
               this.addObject(value,SFSDataType.SHORT_ARRAY);
          }
          
          public function addIntArray(value:Array) : void
          {
               this.addObject(value,SFSDataType.INT_ARRAY);
          }
          
          public function addLongArray(value:Array) : void
          {
               this.addObject(value,SFSDataType.LONG_ARRAY);
          }
          
          public function addFloatArray(value:Array) : void
          {
               this.addObject(value,SFSDataType.FLOAT_ARRAY);
          }
          
          public function addDoubleArray(value:Array) : void
          {
               this.addObject(value,SFSDataType.DOUBLE_ARRAY);
          }
          
          public function addUtfStringArray(value:Array) : void
          {
               this.addObject(value,SFSDataType.UTF_STRING_ARRAY);
          }
          
          public function addSFSArray(value:ISFSArray) : void
          {
               this.addObject(value,SFSDataType.SFS_ARRAY);
          }
          
          public function addSFSObject(value:ISFSObject) : void
          {
               this.addObject(value,SFSDataType.SFS_OBJECT);
          }
          
          public function addClass(value:*) : void
          {
               this.addObject(value,SFSDataType.CLASS);
          }
          
          public function add(wrappedObject:SFSDataWrapper) : void
          {
               this.dataHolder.push(wrappedObject);
          }
          
          private function addObject(value:*, type:int) : void
          {
               this.add(new SFSDataWrapper(type,value));
          }
          
          public function isNull(index:int) : Boolean
          {
               var isNull:Boolean = false;
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               if(wrapper == null || wrapper.type == SFSDataType.NULL)
               {
                    isNull = true;
               }
               return isNull;
          }
          
          public function getBool(index:int) : Boolean
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data as Boolean : Boolean(undefined);
          }
          
          public function getByte(index:int) : int
          {
               return this.getInt(index);
          }
          
          public function getUnsignedByte(index:int) : int
          {
               return this.getInt(index) & 255;
          }
          
          public function getShort(index:int) : int
          {
               return this.getInt(index);
          }
          
          public function getInt(index:int) : int
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data as int : int(undefined);
          }
          
          public function getLong(index:int) : Number
          {
               return this.getDouble(index);
          }
          
          public function getFloat(index:int) : Number
          {
               return this.getDouble(index);
          }
          
          public function getDouble(index:int) : Number
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data as Number : Number(undefined);
          }
          
          public function getUtfString(index:int) : String
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data as String : null;
          }
          
          private function getArray(index:int) : Array
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data as Array : null;
          }
          
          public function getBoolArray(index:int) : Array
          {
               return this.getArray(index);
          }
          
          public function getByteArray(index:int) : ByteArray
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data as ByteArray : null;
          }
          
          public function getUnsignedByteArray(index:int) : Array
          {
               var ba:ByteArray = this.getByteArray(index);
               if(ba == null)
               {
                    return null;
               }
               var unsignedBytes:Array = [];
               ba.position = 0;
               for(var i:int = 0; i < ba.length; i++)
               {
                    unsignedBytes.push(ba.readByte() & 255);
               }
               return unsignedBytes;
          }
          
          public function getShortArray(index:int) : Array
          {
               return this.getArray(index);
          }
          
          public function getIntArray(index:int) : Array
          {
               return this.getArray(index);
          }
          
          public function getLongArray(index:int) : Array
          {
               return this.getArray(index);
          }
          
          public function getFloatArray(index:int) : Array
          {
               return this.getArray(index);
          }
          
          public function getDoubleArray(index:int) : Array
          {
               return this.getArray(index);
          }
          
          public function getUtfStringArray(index:int) : Array
          {
               return this.getArray(index);
          }
          
          public function getSFSArray(index:int) : ISFSArray
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data as ISFSArray : null;
          }
          
          public function getClass(index:int) : *
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data : null;
          }
          
          public function getSFSObject(index:int) : ISFSObject
          {
               var wrapper:SFSDataWrapper = this.dataHolder[index];
               return wrapper != null ? wrapper.data as ISFSObject : null;
          }
     }
}
