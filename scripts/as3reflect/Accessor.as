package as3reflect
{
   public class Accessor extends Field
   {
       
      
      private var _access:AccessorAccess;
      
      public function Accessor(name:String, access:AccessorAccess, type:Type, declaringType:Type, isStatic:Boolean, metaData:Array = null)
      {
         super(name,type,declaringType,isStatic,metaData);
         _access = access;
      }
      
      public function get access() : AccessorAccess
      {
         return _access;
      }
   }
}
