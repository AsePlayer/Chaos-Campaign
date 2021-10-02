package as3reflect
{
   public class MetaData
   {
      
      public static const TRANSIENT:String = "Transient";
      
      public static const BINDABLE:String = "Bindable";
       
      
      private var _arguments:Array;
      
      private var _name:String;
      
      public function MetaData(name:String, arguments:Array = null)
      {
         super();
         _name = name;
         _arguments = arguments == null ? [] : arguments;
      }
      
      public function hasArgumentWithKey(key:String) : Boolean
      {
         return getArgument(key) != null;
      }
      
      public function getArgument(key:String) : MetaDataArgument
      {
         var result:MetaDataArgument = null;
         for(var i:int = 0; i < _arguments.length; i++)
         {
            if(_arguments[i].key == key)
            {
               result = _arguments[i];
               break;
            }
         }
         return result;
      }
      
      public function get arguments() : Array
      {
         return _arguments;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[MetaData(" + name + ", " + arguments + ")]";
      }
   }
}
