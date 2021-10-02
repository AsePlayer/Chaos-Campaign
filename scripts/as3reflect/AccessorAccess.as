package as3reflect
{
   public final class AccessorAccess
   {
      
      private static const READ_ONLY_VALUE:String = "readonly";
      
      private static const READ_WRITE_VALUE:String = "readwrite";
      
      public static const READ_ONLY:AccessorAccess = new AccessorAccess(READ_ONLY_VALUE);
      
      public static const READ_WRITE:AccessorAccess = new AccessorAccess(READ_WRITE_VALUE);
      
      private static const WRITE_ONLY_VALUE:String = "writeonly";
      
      public static const WRITE_ONLY:AccessorAccess = new AccessorAccess(WRITE_ONLY_VALUE);
       
      
      private var _name:String;
      
      public function AccessorAccess(name:String)
      {
         super();
         _name = name;
      }
      
      public static function fromString(access:String) : AccessorAccess
      {
         var result:AccessorAccess = null;
         switch(access)
         {
            case READ_ONLY_VALUE:
               result = READ_ONLY;
               break;
            case WRITE_ONLY_VALUE:
               result = WRITE_ONLY;
               break;
            case READ_WRITE_VALUE:
               result = READ_WRITE;
         }
         return result;
      }
      
      public function get name() : String
      {
         return _name;
      }
   }
}
