package as3reflect
{
   import flash.utils.Proxy;
   
   public class Method extends MetaDataContainer
   {
       
      
      private var _declaringType:as3reflect.Type;
      
      private var _parameters:Array;
      
      private var _name:String;
      
      private var _returnType:as3reflect.Type;
      
      private var _isStatic:Boolean;
      
      public function Method(declaringType:as3reflect.Type, name:String, isStatic:Boolean, parameters:Array, returnType:*, metaData:Array = null)
      {
         super(metaData);
         _declaringType = declaringType;
         _name = name;
         _isStatic = isStatic;
         _parameters = parameters;
         _returnType = returnType;
      }
      
      public function get declaringType() : as3reflect.Type
      {
         return _declaringType;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[Method(name:\'" + name + "\', isStatic:" + isStatic + ")]";
      }
      
      public function get returnType() : as3reflect.Type
      {
         return _returnType;
      }
      
      public function invoke(target:*, args:Array) : *
      {
         var result:* = undefined;
         if(!(target is Proxy))
         {
            result = target[name].apply(target,args);
         }
         return result;
      }
      
      public function get parameters() : Array
      {
         return _parameters;
      }
      
      public function get fullName() : String
      {
         var p:Parameter = null;
         var result:String = "public ";
         if(isStatic)
         {
            result += "static ";
         }
         result += name + "(";
         for(var i:int = 0; i < parameters.length; i++)
         {
            p = parameters[i] as Parameter;
            result += p.type.name;
            result += i < parameters.length - 1 ? ", " : "";
         }
         return result + ("):" + returnType.name);
      }
      
      public function get isStatic() : Boolean
      {
         return _isStatic;
      }
   }
}
