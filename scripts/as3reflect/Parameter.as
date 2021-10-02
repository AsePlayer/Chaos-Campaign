package as3reflect
{
   public class Parameter
   {
       
      
      private var _type:Type;
      
      private var _index:int;
      
      private var _isOptional:Boolean;
      
      public function Parameter(index:int, type:Type, isOptional:Boolean = false)
      {
         super();
         _index = index;
         _type = type;
         _isOptional = isOptional;
      }
      
      public function get index() : int
      {
         return _index;
      }
      
      public function get isOptional() : Boolean
      {
         return _isOptional;
      }
      
      public function get type() : Type
      {
         return _type;
      }
   }
}
