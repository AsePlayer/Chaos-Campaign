package com.smartfoxserver.v2.protocol.serialization
{
     import as3reflect.ClassUtils;
     import as3reflect.Field;
     import as3reflect.Type;
     import com.smartfoxserver.v2.entities.data.ISFSArray;
     import com.smartfoxserver.v2.entities.data.ISFSObject;
     import com.smartfoxserver.v2.entities.data.SFSArray;
     import com.smartfoxserver.v2.entities.data.SFSDataType;
     import com.smartfoxserver.v2.entities.data.SFSDataWrapper;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     import com.smartfoxserver.v2.exceptions.SFSCodecError;
     import flash.utils.ByteArray;
     
     public class DefaultSFSDataSerializer implements ISFSDataSerializer
     {
          
          private static const CLASS_MARKER_KEY:String = "$C";
          
          private static const CLASS_FIELDS_KEY:String = "$F";
          
          private static const FIELD_NAME_KEY:String = "N";
          
          private static const FIELD_VALUE_KEY:String = "V";
          
          private static var _instance:com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer;
          
          private static var _lock:Boolean = true;
           
          
          public function DefaultSFSDataSerializer()
          {
               super();
               if(_lock)
               {
                    throw new Error("Can\'t use constructor, please use getInstance() method");
               }
          }
          
          public static function getInstance() : com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer
          {
               if(_instance == null)
               {
                    _lock = false;
                    _instance = new com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer();
                    _lock = true;
               }
               return _instance;
          }
          
          public function object2binary(obj:ISFSObject) : ByteArray
          {
               var buffer:ByteArray = new ByteArray();
               buffer.writeByte(SFSDataType.SFS_OBJECT);
               buffer.writeShort(obj.size());
               return this.obj2bin(obj,buffer);
          }
          
          private function obj2bin(obj:ISFSObject, buffer:ByteArray) : ByteArray
          {
               var wrapper:SFSDataWrapper = null;
               var key:String = null;
               var keys:Array = obj.getKeys();
               for each(key in keys)
               {
                    wrapper = obj.getData(key);
                    buffer = this.encodeSFSObjectKey(buffer,key);
                    buffer = this.encodeObject(buffer,wrapper.type,wrapper.data);
               }
               return buffer;
          }
          
          public function array2binary(array:ISFSArray) : ByteArray
          {
               var buffer:ByteArray = new ByteArray();
               buffer.writeByte(SFSDataType.SFS_ARRAY);
               buffer.writeShort(array.size());
               return this.arr2bin(array,buffer);
          }
          
          private function arr2bin(array:ISFSArray, buffer:ByteArray) : ByteArray
          {
               var wrapper:SFSDataWrapper = null;
               for(var i:int = 0; i < array.size(); i++)
               {
                    wrapper = array.getWrappedElementAt(i);
                    buffer = this.encodeObject(buffer,wrapper.type,wrapper.data);
               }
               return buffer;
          }
          
          public function binary2object(data:ByteArray) : ISFSObject
          {
               if(data.length < 3)
               {
                    throw new SFSCodecError("Can\'t decode an SFSObject. Byte data is insufficient. Size: " + data.length + " byte(s)");
               }
               data.position = 0;
               return this.decodeSFSObject(data);
          }
          
          private function decodeSFSObject(buffer:ByteArray) : ISFSObject
          {
               var size:int;
               var i:int = 0;
               var key:String = null;
               var decodedObject:SFSDataWrapper = null;
               var sfsObject:SFSObject = SFSObject.newInstance();
               var headerByte:int = buffer.readByte();
               if(headerByte != SFSDataType.SFS_OBJECT)
               {
                    throw new SFSCodecError("Invalid SFSDataType. Expected: " + SFSDataType.SFS_OBJECT + ", found: " + headerByte);
               }
               size = buffer.readShort();
               if(size < 0)
               {
                    throw new SFSCodecError("Can\'t decode SFSObject. Size is negative: " + size);
               }
               try
               {
                    for(i = 0; i < size; i++)
                    {
                         key = buffer.readUTF();
                         decodedObject = this.decodeObject(buffer);
                         if(decodedObject == null)
                         {
                              throw new SFSCodecError("Could not decode value for SFSObject with key: " + key);
                         }
                         sfsObject.put(key,decodedObject);
                    }
               }
               catch(err:SFSCodecError)
               {
                    throw err;
               }
               return sfsObject;
          }
          
          public function binary2array(data:ByteArray) : ISFSArray
          {
               if(data.length < 3)
               {
                    throw new SFSCodecError("Can\'t decode an SFSArray. Byte data is insufficient. Size: " + data.length + " byte(s)");
               }
               data.position = 0;
               return this.decodeSFSArray(data);
          }
          
          private function decodeSFSArray(buffer:ByteArray) : ISFSArray
          {
               var size:int;
               var i:int = 0;
               var decodedObject:SFSDataWrapper = null;
               var sfsArray:ISFSArray = SFSArray.newInstance();
               var headerByte:int = buffer.readByte();
               if(headerByte != SFSDataType.SFS_ARRAY)
               {
                    throw new SFSCodecError("Invalid SFSDataType. Expected: " + SFSDataType.SFS_ARRAY + ", found: " + headerByte);
               }
               size = buffer.readShort();
               if(size < 0)
               {
                    throw new SFSCodecError("Can\'t decode SFSArray. Size is negative: " + size);
               }
               try
               {
                    for(i = 0; i < size; i++)
                    {
                         decodedObject = this.decodeObject(buffer);
                         if(decodedObject == null)
                         {
                              throw new SFSCodecError("Could not decode SFSArray item at index: " + i);
                         }
                         sfsArray.add(decodedObject);
                    }
               }
               catch(err:SFSCodecError)
               {
                    throw err;
               }
               return sfsArray;
          }
          
          private function decodeObject(buffer:ByteArray) : SFSDataWrapper
          {
               var decodedObject:SFSDataWrapper = null;
               var sfsObj:ISFSObject = null;
               var type:int = 0;
               var finalSfsObj:* = undefined;
               var headerByte:int = buffer.readByte();
               if(headerByte == SFSDataType.NULL)
               {
                    decodedObject = this.binDecode_NULL(buffer);
               }
               else if(headerByte == SFSDataType.BOOL)
               {
                    decodedObject = this.binDecode_BOOL(buffer);
               }
               else if(headerByte == SFSDataType.BOOL_ARRAY)
               {
                    decodedObject = this.binDecode_BOOL_ARRAY(buffer);
               }
               else if(headerByte == SFSDataType.BYTE)
               {
                    decodedObject = this.binDecode_BYTE(buffer);
               }
               else if(headerByte == SFSDataType.BYTE_ARRAY)
               {
                    decodedObject = this.binDecode_BYTE_ARRAY(buffer);
               }
               else if(headerByte == SFSDataType.SHORT)
               {
                    decodedObject = this.binDecode_SHORT(buffer);
               }
               else if(headerByte == SFSDataType.SHORT_ARRAY)
               {
                    decodedObject = this.binDecode_SHORT_ARRAY(buffer);
               }
               else if(headerByte == SFSDataType.INT)
               {
                    decodedObject = this.binDecode_INT(buffer);
               }
               else if(headerByte == SFSDataType.INT_ARRAY)
               {
                    decodedObject = this.binDecode_INT_ARRAY(buffer);
               }
               else if(headerByte == SFSDataType.LONG)
               {
                    decodedObject = this.binDecode_LONG(buffer);
               }
               else if(headerByte == SFSDataType.LONG_ARRAY)
               {
                    decodedObject = this.binDecode_LONG_ARRAY(buffer);
               }
               else if(headerByte == SFSDataType.FLOAT)
               {
                    decodedObject = this.binDecode_FLOAT(buffer);
               }
               else if(headerByte == SFSDataType.FLOAT_ARRAY)
               {
                    decodedObject = this.binDecode_FLOAT_ARRAY(buffer);
               }
               else if(headerByte == SFSDataType.DOUBLE)
               {
                    decodedObject = this.binDecode_DOUBLE(buffer);
               }
               else if(headerByte == SFSDataType.DOUBLE_ARRAY)
               {
                    decodedObject = this.binDecode_DOUBLE_ARRAY(buffer);
               }
               else if(headerByte == SFSDataType.UTF_STRING)
               {
                    decodedObject = this.binDecode_UTF_STRING(buffer);
               }
               else if(headerByte == SFSDataType.UTF_STRING_ARRAY)
               {
                    decodedObject = this.binDecode_UTF_STRING_ARRAY(buffer);
               }
               else if(headerByte == SFSDataType.SFS_ARRAY)
               {
                    buffer.position -= 1;
                    decodedObject = new SFSDataWrapper(SFSDataType.SFS_ARRAY,this.decodeSFSArray(buffer));
               }
               else
               {
                    if(headerByte != SFSDataType.SFS_OBJECT)
                    {
                         throw new Error("Unknow SFSDataType ID: " + headerByte);
                    }
                    buffer.position -= 1;
                    sfsObj = this.decodeSFSObject(buffer);
                    type = SFSDataType.SFS_OBJECT;
                    finalSfsObj = sfsObj;
                    if(Boolean(sfsObj.containsKey(CLASS_MARKER_KEY)) && Boolean(sfsObj.containsKey(CLASS_FIELDS_KEY)))
                    {
                         type = SFSDataType.CLASS;
                         finalSfsObj = this.sfs2as(sfsObj);
                    }
                    decodedObject = new SFSDataWrapper(type,finalSfsObj);
               }
               return decodedObject;
          }
          
          private function encodeObject(buffer:ByteArray, typeId:int, data:*) : ByteArray
          {
               switch(typeId)
               {
                    case SFSDataType.NULL:
                         buffer = this.binEncode_NULL(buffer);
                         break;
                    case SFSDataType.BOOL:
                         buffer = this.binEncode_BOOL(buffer,data as Boolean);
                         break;
                    case SFSDataType.BYTE:
                         buffer = this.binEncode_BYTE(buffer,data as int);
                         break;
                    case SFSDataType.SHORT:
                         buffer = this.binEncode_SHORT(buffer,data as int);
                         break;
                    case SFSDataType.INT:
                         buffer = this.binEncode_INT(buffer,data as int);
                         break;
                    case SFSDataType.LONG:
                         buffer = this.binEncode_LONG(buffer,data as Number);
                         break;
                    case SFSDataType.FLOAT:
                         buffer = this.binEncode_FLOAT(buffer,data as Number);
                         break;
                    case SFSDataType.DOUBLE:
                         buffer = this.binEncode_DOUBLE(buffer,data as Number);
                         break;
                    case SFSDataType.UTF_STRING:
                         buffer = this.binEncode_UTF_STRING(buffer,data as String);
                         break;
                    case SFSDataType.BOOL_ARRAY:
                         buffer = this.binEncode_BOOL_ARRAY(buffer,data as Array);
                         break;
                    case SFSDataType.BYTE_ARRAY:
                         buffer = this.binEncode_BYTE_ARRAY(buffer,data as ByteArray);
                         break;
                    case SFSDataType.SHORT_ARRAY:
                         buffer = this.binEncode_SHORT_ARRAY(buffer,data as Array);
                         break;
                    case SFSDataType.INT_ARRAY:
                         buffer = this.binEncode_INT_ARRAY(buffer,data as Array);
                         break;
                    case SFSDataType.LONG_ARRAY:
                         buffer = this.binEncode_LONG_ARRAY(buffer,data as Array);
                         break;
                    case SFSDataType.FLOAT_ARRAY:
                         buffer = this.binEncode_FLOAT_ARRAY(buffer,data as Array);
                         break;
                    case SFSDataType.DOUBLE_ARRAY:
                         buffer = this.binEncode_DOUBLE_ARRAY(buffer,data as Array);
                         break;
                    case SFSDataType.UTF_STRING_ARRAY:
                         buffer = this.binEncode_UTF_STRING_ARRAY(buffer,data as Array);
                         break;
                    case SFSDataType.SFS_ARRAY:
                         buffer = this.addData(buffer,this.array2binary(data as SFSArray));
                         break;
                    case SFSDataType.SFS_OBJECT:
                         buffer = this.addData(buffer,this.object2binary(data as SFSObject));
                         break;
                    case SFSDataType.CLASS:
                         buffer = this.addData(buffer,this.object2binary(this.as2sfs(data)));
                         break;
                    default:
                         throw new SFSCodecError("Unrecognized type in SFSObject serialization: " + typeId);
               }
               return buffer;
          }
          
          private function binDecode_NULL(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.NULL,null);
          }
          
          private function binDecode_BOOL(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.BOOL,buffer.readBoolean());
          }
          
          private function binDecode_BYTE(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.BYTE,buffer.readByte());
          }
          
          private function binDecode_SHORT(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.SHORT,buffer.readShort());
          }
          
          private function binDecode_INT(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.INT,buffer.readInt());
          }
          
          private function binDecode_LONG(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.LONG,this.decodeLongValue(buffer));
          }
          
          private function decodeLongValue(buffer:ByteArray) : Number
          {
               var hi32:int = buffer.readInt();
               var lo32:uint = buffer.readUnsignedInt();
               return hi32 * Math.pow(2,32) + lo32;
          }
          
          private function encodeLongValue(long:Number, buffer:ByteArray) : void
          {
               var absVal:Number = NaN;
               var negLong:Number = NaN;
               var hi32:int = 0;
               var lo32:int = 0;
               if(long > -1)
               {
                    hi32 = long / Math.pow(2,32);
                    lo32 = long % Math.pow(2,32);
               }
               else
               {
                    absVal = Math.abs(long);
                    negLong = absVal - 1;
                    hi32 = negLong / Math.pow(2,32);
                    lo32 = negLong % Math.pow(2,32);
                    hi32 = ~hi32;
                    lo32 = ~lo32;
               }
               buffer.writeUnsignedInt(hi32);
               buffer.writeUnsignedInt(lo32);
          }
          
          private function binDecode_FLOAT(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.FLOAT,buffer.readFloat());
          }
          
          private function binDecode_DOUBLE(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.DOUBLE,buffer.readDouble());
          }
          
          private function binDecode_UTF_STRING(buffer:ByteArray) : SFSDataWrapper
          {
               return new SFSDataWrapper(SFSDataType.UTF_STRING,buffer.readUTF());
          }
          
          private function binDecode_BOOL_ARRAY(buffer:ByteArray) : SFSDataWrapper
          {
               var size:int = this.getTypedArraySize(buffer);
               var array:Array = [];
               for(var j:int = 0; j < size; j++)
               {
                    array.push(buffer.readBoolean());
               }
               return new SFSDataWrapper(SFSDataType.BOOL_ARRAY,array);
          }
          
          private function binDecode_BYTE_ARRAY(buffer:ByteArray) : SFSDataWrapper
          {
               var size:int = buffer.readInt();
               if(size < 0)
               {
                    throw new SFSCodecError("Array negative size: " + size);
               }
               var array:ByteArray = new ByteArray();
               buffer.readBytes(array,0,size);
               return new SFSDataWrapper(SFSDataType.BYTE_ARRAY,array);
          }
          
          private function binDecode_SHORT_ARRAY(buffer:ByteArray) : SFSDataWrapper
          {
               var size:int = this.getTypedArraySize(buffer);
               var array:Array = [];
               for(var j:int = 0; j < size; j++)
               {
                    array.push(buffer.readShort());
               }
               return new SFSDataWrapper(SFSDataType.SHORT_ARRAY,array);
          }
          
          private function binDecode_INT_ARRAY(buffer:ByteArray) : SFSDataWrapper
          {
               var size:int = this.getTypedArraySize(buffer);
               var array:Array = [];
               for(var j:int = 0; j < size; j++)
               {
                    array.push(buffer.readInt());
               }
               return new SFSDataWrapper(SFSDataType.INT_ARRAY,array);
          }
          
          private function binDecode_LONG_ARRAY(buffer:ByteArray) : SFSDataWrapper
          {
               var size:int = this.getTypedArraySize(buffer);
               var array:Array = [];
               for(var j:int = 0; j < size; j++)
               {
                    array.push(this.decodeLongValue(buffer));
               }
               return new SFSDataWrapper(SFSDataType.LONG_ARRAY,array);
          }
          
          private function binDecode_FLOAT_ARRAY(buffer:ByteArray) : SFSDataWrapper
          {
               var size:int = this.getTypedArraySize(buffer);
               var array:Array = [];
               for(var j:int = 0; j < size; j++)
               {
                    array.push(buffer.readFloat());
               }
               return new SFSDataWrapper(SFSDataType.FLOAT_ARRAY,array);
          }
          
          private function binDecode_DOUBLE_ARRAY(buffer:ByteArray) : SFSDataWrapper
          {
               var size:int = this.getTypedArraySize(buffer);
               var array:Array = [];
               for(var j:int = 0; j < size; j++)
               {
                    array.push(buffer.readDouble());
               }
               return new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY,array);
          }
          
          private function binDecode_UTF_STRING_ARRAY(buffer:ByteArray) : SFSDataWrapper
          {
               var size:int = this.getTypedArraySize(buffer);
               var array:Array = [];
               for(var j:int = 0; j < size; j++)
               {
                    array.push(buffer.readUTF());
               }
               return new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY,array);
          }
          
          private function getTypedArraySize(buffer:ByteArray) : int
          {
               var size:int = buffer.readShort();
               if(size < 0)
               {
                    throw new SFSCodecError("Array negative size: " + size);
               }
               return size;
          }
          
          private function binEncode_NULL(buffer:ByteArray) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(0);
               return this.addData(buffer,data);
          }
          
          private function binEncode_BOOL(buffer:ByteArray, value:Boolean) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.BOOL);
               data.writeBoolean(value);
               return this.addData(buffer,data);
          }
          
          private function binEncode_BYTE(buffer:ByteArray, value:int) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.BYTE);
               data.writeByte(value);
               return this.addData(buffer,data);
          }
          
          private function binEncode_SHORT(buffer:ByteArray, value:int) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.SHORT);
               data.writeShort(value);
               return this.addData(buffer,data);
          }
          
          private function binEncode_INT(buffer:ByteArray, value:int) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.INT);
               data.writeInt(value);
               return this.addData(buffer,data);
          }
          
          private function binEncode_LONG(buffer:ByteArray, value:Number) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.LONG);
               this.encodeLongValue(value,data);
               return this.addData(buffer,data);
          }
          
          private function binEncode_FLOAT(buffer:ByteArray, value:Number) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.FLOAT);
               data.writeFloat(value);
               return this.addData(buffer,data);
          }
          
          private function binEncode_DOUBLE(buffer:ByteArray, value:Number) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.DOUBLE);
               data.writeDouble(value);
               return this.addData(buffer,data);
          }
          
          private function binEncode_UTF_STRING(buffer:ByteArray, value:String) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.UTF_STRING);
               data.writeUTF(value);
               return this.addData(buffer,data);
          }
          
          private function binEncode_BOOL_ARRAY(buffer:ByteArray, value:Array) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.BOOL_ARRAY);
               data.writeShort(value.length);
               for(var i:int = 0; i < value.length; i++)
               {
                    data.writeBoolean(value[i]);
               }
               return this.addData(buffer,data);
          }
          
          private function binEncode_BYTE_ARRAY(buffer:ByteArray, value:ByteArray) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.BYTE_ARRAY);
               data.writeInt(value.length);
               data.writeBytes(value,0,value.length);
               return this.addData(buffer,data);
          }
          
          private function binEncode_SHORT_ARRAY(buffer:ByteArray, value:Array) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.SHORT_ARRAY);
               data.writeShort(value.length);
               for(var i:int = 0; i < value.length; i++)
               {
                    data.writeShort(value[i]);
               }
               return this.addData(buffer,data);
          }
          
          private function binEncode_INT_ARRAY(buffer:ByteArray, value:Array) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.INT_ARRAY);
               data.writeShort(value.length);
               for(var i:int = 0; i < value.length; i++)
               {
                    data.writeInt(value[i]);
               }
               return this.addData(buffer,data);
          }
          
          private function binEncode_LONG_ARRAY(buffer:ByteArray, value:Array) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.LONG_ARRAY);
               data.writeShort(value.length);
               for(var i:int = 0; i < value.length; i++)
               {
                    this.encodeLongValue(value[i],data);
               }
               return this.addData(buffer,data);
          }
          
          private function binEncode_FLOAT_ARRAY(buffer:ByteArray, value:Array) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.FLOAT_ARRAY);
               data.writeShort(value.length);
               for(var i:int = 0; i < value.length; i++)
               {
                    data.writeFloat(value[i]);
               }
               return this.addData(buffer,data);
          }
          
          private function binEncode_DOUBLE_ARRAY(buffer:ByteArray, value:Array) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.DOUBLE_ARRAY);
               data.writeShort(value.length);
               for(var i:int = 0; i < value.length; i++)
               {
                    data.writeDouble(value[i]);
               }
               return this.addData(buffer,data);
          }
          
          private function binEncode_UTF_STRING_ARRAY(buffer:ByteArray, value:Array) : ByteArray
          {
               var data:ByteArray = new ByteArray();
               data.writeByte(SFSDataType.UTF_STRING_ARRAY);
               data.writeShort(value.length);
               for(var i:int = 0; i < value.length; i++)
               {
                    data.writeUTF(value[i]);
               }
               return this.addData(buffer,data);
          }
          
          private function encodeSFSObjectKey(buffer:ByteArray, value:String) : ByteArray
          {
               buffer.writeUTF(value);
               return buffer;
          }
          
          private function addData(buffer:ByteArray, newData:ByteArray) : ByteArray
          {
               buffer.writeBytes(newData,0,newData.length);
               return buffer;
          }
          
          public function as2sfs(asObj:*) : ISFSObject
          {
               var sfsObj:ISFSObject = SFSObject.newInstance();
               this.convertAsObj(asObj,sfsObj);
               return sfsObj;
          }
          
          private function encodeClassName(name:String) : String
          {
               return name.replace("::",".");
          }
          
          private function convertAsObj(asObj:*, sfsObj:ISFSObject) : void
          {
               var field:Field = null;
               var fieldName:String = null;
               var fieldValue:* = undefined;
               var fieldDescriptor:ISFSObject = null;
               var type:Type = Type.forInstance(asObj);
               var classFullName:String = this.encodeClassName(ClassUtils.getFullyQualifiedName(type.clazz));
               if(classFullName == null)
               {
                    throw new SFSCodecError("Cannot detect class name: " + sfsObj);
               }
               if(!(asObj is SerializableSFSType))
               {
                    throw new SFSCodecError("Cannot serialize object: " + asObj + ", type: " + classFullName + " -- It doesn\'t implement the SerializableSFSType interface");
               }
               var fieldList:ISFSArray = SFSArray.newInstance();
               sfsObj.putUtfString(CLASS_MARKER_KEY,classFullName);
               sfsObj.putSFSArray(CLASS_FIELDS_KEY,fieldList);
               for each(field in type.fields)
               {
                    if(!field.isStatic)
                    {
                         fieldName = field.name;
                         fieldValue = asObj[fieldName];
                         if(fieldName.charAt(0) != "$")
                         {
                              fieldDescriptor = SFSObject.newInstance();
                              fieldDescriptor.putUtfString(FIELD_NAME_KEY,fieldName);
                              fieldDescriptor.put(FIELD_VALUE_KEY,this.wrapASField(fieldValue));
                              fieldList.addSFSObject(fieldDescriptor);
                         }
                    }
               }
          }
          
          private function wrapASField(value:*) : SFSDataWrapper
          {
               var wrapper:SFSDataWrapper = null;
               if(value == null)
               {
                    return new SFSDataWrapper(SFSDataType.NULL,null);
               }
               var type:String = Type.forInstance(value).name;
               if(value is Boolean)
               {
                    wrapper = new SFSDataWrapper(SFSDataType.BOOL,value);
               }
               else if(value is int || value is uint)
               {
                    wrapper = new SFSDataWrapper(SFSDataType.INT,value);
               }
               else if(value is Number)
               {
                    if(value == Math.floor(value))
                    {
                         wrapper = new SFSDataWrapper(SFSDataType.LONG,value);
                    }
                    else
                    {
                         wrapper = new SFSDataWrapper(SFSDataType.DOUBLE,value);
                    }
               }
               else if(value is String)
               {
                    wrapper = new SFSDataWrapper(SFSDataType.UTF_STRING,value);
               }
               else if(value is Array)
               {
                    wrapper = new SFSDataWrapper(SFSDataType.SFS_ARRAY,this.unrollArray(value));
               }
               else if(value is SerializableSFSType)
               {
                    wrapper = new SFSDataWrapper(SFSDataType.SFS_OBJECT,this.as2sfs(value));
               }
               else if(value is Object)
               {
                    wrapper = new SFSDataWrapper(SFSDataType.SFS_OBJECT,this.unrollDictionary(value));
               }
               return wrapper;
          }
          
          private function unrollArray(arr:Array) : ISFSArray
          {
               var sfsArray:ISFSArray = SFSArray.newInstance();
               for(var j:int = 0; j < arr.length; j++)
               {
                    sfsArray.add(this.wrapASField(arr[j]));
               }
               return sfsArray;
          }
          
          private function unrollDictionary(dict:Object) : ISFSObject
          {
               var key:String = null;
               var sfsObj:ISFSObject = SFSObject.newInstance();
               for(key in dict)
               {
                    sfsObj.put(key,this.wrapASField(dict[key]));
               }
               return sfsObj;
          }
          
          public function sfs2as(sfsObj:ISFSObject) : *
          {
               var asObj:* = undefined;
               if(!sfsObj.containsKey(CLASS_MARKER_KEY) && !sfsObj.containsKey(CLASS_FIELDS_KEY))
               {
                    throw new SFSCodecError("The SFSObject passed does not represent any serialized class.");
               }
               var className:String = String(sfsObj.getUtfString(CLASS_MARKER_KEY));
               var theClass:Class = ClassUtils.forName(className);
               asObj = new theClass();
               if(!(asObj is SerializableSFSType))
               {
                    throw new SFSCodecError("Cannot deserialize object: " + asObj + ", type: " + className + " -- It doesn\'t implement the SerializableSFSType interface");
               }
               this.convertSFSObject(sfsObj.getSFSArray(CLASS_FIELDS_KEY),asObj);
               return asObj;
          }
          
          private function convertSFSObject(fieldList:ISFSArray, asObj:*) : void
          {
               var fieldDescriptor:ISFSObject = null;
               var fieldName:String = null;
               var fieldValue:* = undefined;
               for(var j:int = 0; j < fieldList.size(); j++)
               {
                    fieldDescriptor = fieldList.getSFSObject(j);
                    fieldName = String(fieldDescriptor.getUtfString(FIELD_NAME_KEY));
                    fieldValue = this.unwrapAsField(fieldDescriptor.getData(FIELD_VALUE_KEY));
                    asObj[fieldName] = fieldValue;
               }
          }
          
          private function unwrapAsField(wrapper:SFSDataWrapper) : *
          {
               var obj:* = undefined;
               var type:int = wrapper.type;
               if(type <= SFSDataType.UTF_STRING)
               {
                    obj = wrapper.data;
               }
               else if(type == SFSDataType.SFS_ARRAY)
               {
                    obj = this.rebuildArray(wrapper.data as ISFSArray);
               }
               else if(type == SFSDataType.SFS_OBJECT)
               {
                    obj = this.rebuildDict(wrapper.data as ISFSObject);
               }
               else if(type == SFSDataType.CLASS)
               {
                    obj = wrapper.data;
               }
               return obj;
          }
          
          private function rebuildArray(sfsArr:ISFSArray) : Array
          {
               var arr:Array = [];
               for(var j:int = 0; j < sfsArr.size(); j++)
               {
                    arr.push(this.unwrapAsField(sfsArr.getWrappedElementAt(j)));
               }
               return arr;
          }
          
          private function rebuildDict(sfsObj:ISFSObject) : Object
          {
               var key:String = null;
               var dict:Object = {};
               for each(key in sfsObj.getKeys())
               {
                    dict[key] = this.unwrapAsField(sfsObj.getData(key));
               }
               return dict;
          }
          
          public function genericObjectToSFSObject(obj:Object, forceToNumber:Boolean = false) : SFSObject
          {
               var sfso:SFSObject = new SFSObject();
               this._scanGenericObject(obj,sfso,forceToNumber);
               return sfso;
          }
          
          private function _scanGenericObject(obj:Object, sfso:ISFSObject, forceToNumber:Boolean = false) : void
          {
               var key:String = null;
               var item:* = undefined;
               var subSfso:ISFSObject = null;
               for(key in obj)
               {
                    item = obj[key];
                    if(item == null)
                    {
                         sfso.putNull(key);
                    }
                    else if(item.toString() == "[object Object]" && !(item is Array))
                    {
                         subSfso = new SFSObject();
                         sfso.putSFSObject(key,subSfso);
                         this._scanGenericObject(item,subSfso,forceToNumber);
                    }
                    else if(item is Array)
                    {
                         sfso.putSFSArray(key,this.genericArrayToSFSArray(item,forceToNumber));
                    }
                    else if(item is Boolean)
                    {
                         sfso.putBool(key,item);
                    }
                    else if(item is int && !forceToNumber)
                    {
                         sfso.putInt(key,item);
                    }
                    else if(item is Number)
                    {
                         sfso.putDouble(key,item);
                    }
                    else if(item is String)
                    {
                         sfso.putUtfString(key,item);
                    }
               }
          }
          
          public function sfsObjectToGenericObject(sfso:ISFSObject) : Object
          {
               var obj:Object = {};
               this._scanSFSObject(sfso,obj);
               return obj;
          }
          
          private function _scanSFSObject(sfso:ISFSObject, obj:Object) : void
          {
               var key:String = null;
               var item:SFSDataWrapper = null;
               var subObj:Object = null;
               var keys:Array = sfso.getKeys();
               for each(key in keys)
               {
                    item = sfso.getData(key);
                    if(item.type == SFSDataType.NULL)
                    {
                         obj[key] = null;
                    }
                    else if(item.type == SFSDataType.SFS_OBJECT)
                    {
                         subObj = {};
                         obj[key] = subObj;
                         this._scanSFSObject(item.data as ISFSObject,subObj);
                    }
                    else if(item.type == SFSDataType.SFS_ARRAY)
                    {
                         obj[key] = (item.data as SFSArray).toArray();
                    }
                    else if(item.type != SFSDataType.CLASS)
                    {
                         obj[key] = item.data;
                    }
               }
          }
          
          public function genericArrayToSFSArray(arr:Array, forceToNumber:Boolean = false) : SFSArray
          {
               var sfsa:SFSArray = new SFSArray();
               this._scanGenericArray(arr,sfsa,forceToNumber);
               return sfsa;
          }
          
          private function _scanGenericArray(arr:Array, sfsa:ISFSArray, forceToNumber:Boolean = false) : void
          {
               var item:* = undefined;
               var subSfsa:ISFSArray = null;
               for(var ii:int = 0; ii < arr.length; ii++)
               {
                    item = arr[ii];
                    if(item == null)
                    {
                         sfsa.addNull();
                    }
                    else if(item.toString() == "[object Object]" && !(item is Array))
                    {
                         sfsa.addSFSObject(this.genericObjectToSFSObject(item,forceToNumber));
                    }
                    else if(item is Array)
                    {
                         subSfsa = new SFSArray();
                         sfsa.addSFSArray(subSfsa);
                         this._scanGenericArray(item,subSfsa,forceToNumber);
                    }
                    else if(item is Boolean)
                    {
                         sfsa.addBool(item);
                    }
                    else if(item is int && !forceToNumber)
                    {
                         sfsa.addInt(item);
                    }
                    else if(item is Number)
                    {
                         sfsa.addDouble(item);
                    }
                    else if(item is String)
                    {
                         sfsa.addUtfString(item);
                    }
               }
          }
          
          public function sfsArrayToGenericArray(sfsa:ISFSArray) : Array
          {
               var arr:Array = [];
               this._scanSFSArray(sfsa,arr);
               return arr;
          }
          
          private function _scanSFSArray(sfsa:ISFSArray, arr:Array) : void
          {
               var item:SFSDataWrapper = null;
               var subArr:Array = null;
               for(var ii:int = 0; ii < sfsa.size(); ii++)
               {
                    item = sfsa.getWrappedElementAt(ii);
                    if(item.type == SFSDataType.NULL)
                    {
                         arr[ii] = null;
                    }
                    else if(item.type == SFSDataType.SFS_OBJECT)
                    {
                         arr[ii] = (item.data as SFSObject).toObject();
                    }
                    else if(item.type == SFSDataType.SFS_ARRAY)
                    {
                         subArr = [];
                         arr[ii] = subArr;
                         this._scanSFSArray(item.data as ISFSArray,subArr);
                    }
                    else if(item.type != SFSDataType.CLASS)
                    {
                         arr[ii] = item.data;
                    }
               }
          }
     }
}
