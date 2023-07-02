package as3reflect
{
   public class Accessor extends Field
   {
       
      
      private var _access:as3reflect.AccessorAccess;
      
      public function Accessor(name:String, access:as3reflect.AccessorAccess, type:Type, declaringType:Type, isStatic:Boolean, metaData:Array = null)
      {
         super(name,type,declaringType,isStatic,metaData);
         _access = access;
      }
      
      public function get access() : as3reflect.AccessorAccess
      {
         return _access;
      }
   }
}
