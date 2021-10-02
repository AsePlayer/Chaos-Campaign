package as3reflect
{
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   
   public class Type extends MetaDataContainer
   {
      
      public static const UNTYPED:Type = new Type();
      
      public static const PRIVATE:Type = new Type();
      
      public static const VOID:Type = new Type();
      
      private static var _cache:Object = {};
       
      
      private var _class:Class;
      
      private var _accessors:Array;
      
      private var _isStatic:Boolean;
      
      private var _fullName:String;
      
      private var _isFinal:Boolean;
      
      private var _isDynamic:Boolean;
      
      private var _staticConstants:Array;
      
      private var _constants:Array;
      
      private var _fields:Array;
      
      private var _name:String;
      
      private var _methods:Array;
      
      private var _variables:Array;
      
      private var _staticVariables:Array;
      
      public function Type()
      {
         super();
         _methods = new Array();
         _accessors = new Array();
         _staticConstants = new Array();
         _constants = new Array();
         _staticVariables = new Array();
         _variables = new Array();
         _fields = new Array();
      }
      
      public static function forName(name:String) : Type
      {
         var result:Type = null;
         switch(name)
         {
            case "void":
               result = Type.VOID;
               break;
            case "*":
               result = Type.UNTYPED;
               break;
            default:
               try
               {
                  result = Type.forClass(Class(getDefinitionByName(name)));
               }
               catch(e:ReferenceError)
               {
                  trace("Type.forName error: " + e.message + " The class \'" + name + "\' is probably an internal class or it may not have been compiled.");
               }
         }
         return result;
      }
      
      public static function forInstance(instance:*) : Type
      {
         var result:Type = null;
         var clazz:Class = ClassUtils.forInstance(instance);
         if(clazz != null)
         {
            result = Type.forClass(clazz);
         }
         return result;
      }
      
      public static function forClass(clazz:Class) : Type
      {
         var result:Type = null;
         var description:XML = null;
         var fullyQualifiedClassName:String = ClassUtils.getFullyQualifiedName(clazz);
         if(_cache[fullyQualifiedClassName])
         {
            result = _cache[fullyQualifiedClassName];
         }
         else
         {
            description = describeType(clazz);
            result = new Type();
            _cache[fullyQualifiedClassName] = result;
            result.fullName = fullyQualifiedClassName;
            result.name = ClassUtils.getNameFromFullyQualifiedName(fullyQualifiedClassName);
            result.clazz = clazz;
            result.isDynamic = description.@isDynamic;
            result.isFinal = description.@isFinal;
            result.isStatic = description.@isStatic;
            result.accessors = TypeXmlParser.parseAccessors(result,description);
            result.methods = TypeXmlParser.parseMethods(result,description);
            result.staticConstants = TypeXmlParser.parseMembers(Constant,description.constant,result,true);
            result.constants = TypeXmlParser.parseMembers(Constant,description.factory.constant,result,false);
            result.staticVariables = TypeXmlParser.parseMembers(Variable,description.variable,result,true);
            result.variables = TypeXmlParser.parseMembers(Variable,description.factory.variable,result,false);
            TypeXmlParser.parseMetaData(description.factory[0].metadata,result);
         }
         return result;
      }
      
      public function get staticConstants() : Array
      {
         return _staticConstants;
      }
      
      public function set staticConstants(value:Array) : void
      {
         _staticConstants = value;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get accessors() : Array
      {
         return _accessors;
      }
      
      public function set name(value:String) : void
      {
         _name = value;
      }
      
      public function set accessors(value:Array) : void
      {
         _accessors = value;
      }
      
      public function set constants(value:Array) : void
      {
         _constants = value;
      }
      
      public function get staticVariables() : Array
      {
         return _staticVariables;
      }
      
      public function get methods() : Array
      {
         return _methods;
      }
      
      public function get isDynamic() : Boolean
      {
         return _isDynamic;
      }
      
      public function set clazz(value:Class) : void
      {
         _class = value;
      }
      
      public function get isStatic() : Boolean
      {
         return _isStatic;
      }
      
      public function get fullName() : String
      {
         return _fullName;
      }
      
      public function get fields() : Array
      {
         return accessors.concat(staticConstants).concat(constants).concat(staticVariables).concat(variables);
      }
      
      public function getField(name:String) : Field
      {
         var result:Field = null;
         var field:Field = null;
         for each(field in fields)
         {
            if(field.name == name)
            {
               result = field;
               break;
            }
         }
         return result;
      }
      
      public function get constants() : Array
      {
         return _constants;
      }
      
      public function set staticVariables(value:Array) : void
      {
         _staticVariables = value;
      }
      
      public function getMethod(name:String) : Method
      {
         var result:Method = null;
         var method:Method = null;
         for each(method in methods)
         {
            if(method.name == name)
            {
               result = method;
               break;
            }
         }
         return result;
      }
      
      public function get clazz() : Class
      {
         return _class;
      }
      
      public function set methods(value:Array) : void
      {
         _methods = value;
      }
      
      public function set isFinal(value:Boolean) : void
      {
         _isFinal = value;
      }
      
      public function set isDynamic(value:Boolean) : void
      {
         _isDynamic = value;
      }
      
      public function set variables(value:Array) : void
      {
         _variables = value;
      }
      
      public function set isStatic(value:Boolean) : void
      {
         _isStatic = value;
      }
      
      public function set fullName(value:String) : void
      {
         _fullName = value;
      }
      
      public function get isFinal() : Boolean
      {
         return _isFinal;
      }
      
      public function get variables() : Array
      {
         return _variables;
      }
   }
}

import as3reflect.Accessor;
import as3reflect.AccessorAccess;
import as3reflect.IMember;
import as3reflect.IMetaDataContainer;
import as3reflect.MetaData;
import as3reflect.MetaDataArgument;
import as3reflect.Method;
import as3reflect.Parameter;
import as3reflect.Type;

class TypeXmlParser
{
    
   
   function TypeXmlParser()
   {
      super();
   }
   
   public static function parseMetaData(metaDataNodes:XMLList, metaData:IMetaDataContainer) : void
   {
      var metaDataXML:XML = null;
      var metaDataArgs:Array = null;
      var metaDataArgNode:XML = null;
      for each(metaDataXML in metaDataNodes)
      {
         metaDataArgs = [];
         for each(metaDataArgNode in metaDataXML.arg)
         {
            metaDataArgs.push(new MetaDataArgument(metaDataArgNode.@key,metaDataArgNode.@value));
         }
         metaData.addMetaData(new MetaData(metaDataXML.@name,metaDataArgs));
      }
   }
   
   public static function parseMembers(memberClass:Class, members:XMLList, declaringType:Type, isStatic:Boolean) : Array
   {
      var m:XML = null;
      var member:IMember = null;
      var result:Array = [];
      for each(m in members)
      {
         member = new memberClass(m.@name,Type.forName(m.@type),declaringType,isStatic);
         parseMetaData(m.metadata,member);
         result.push(member);
      }
      return result;
   }
   
   private static function parseAccessorsByModifier(type:Type, accessorsXML:XMLList, isStatic:Boolean) : Array
   {
      var accessorXML:XML = null;
      var accessor:Accessor = null;
      var result:Array = [];
      for each(accessorXML in accessorsXML)
      {
         accessor = new Accessor(accessorXML.@name,AccessorAccess.fromString(accessorXML.@access),Type.forName(accessorXML.@type),type,isStatic);
         parseMetaData(accessorXML.metadata,accessor);
         result.push(accessor);
      }
      return result;
   }
   
   public static function parseAccessors(type:Type, xml:XML) : Array
   {
      var classAccessors:Array = parseAccessorsByModifier(type,xml.accessor,true);
      var instanceAccessors:Array = parseAccessorsByModifier(type,xml.factory.accessor,false);
      return classAccessors.concat(instanceAccessors);
   }
   
   private static function parseMethodsByModifier(type:Type, methodsXML:XMLList, isStatic:Boolean) : Array
   {
      var methodXML:XML = null;
      var params:Array = null;
      var paramXML:XML = null;
      var method:Method = null;
      var paramType:Type = null;
      var param:Parameter = null;
      var result:Array = [];
      for each(methodXML in methodsXML)
      {
         params = [];
         for each(paramXML in methodXML.parameter)
         {
            paramType = Type.forName(paramXML.@type);
            param = new Parameter(paramXML.@index,paramType,paramXML.@optional);
            params.push(param);
         }
         method = new Method(type,methodXML.@name,isStatic,params,Type.forName(methodXML.@returnType));
         parseMetaData(methodXML.metadata,method);
         result.push(method);
      }
      return result;
   }
   
   public static function parseMethods(type:Type, xml:XML) : Array
   {
      var classMethods:Array = parseMethodsByModifier(type,xml.method,true);
      var instanceMethods:Array = parseMethodsByModifier(type,xml.factory.method,false);
      return classMethods.concat(instanceMethods);
   }
}
