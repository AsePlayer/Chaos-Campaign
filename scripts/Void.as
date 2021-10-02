package
{
   import flash.Boot;
   
   public final class Void
   {
      
      public static const __isenum:Boolean = true;
      
      public static var __constructs__ = [];
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function Void(tag:String, index:int, params:*)
      {
         tag = tag;
         index = index;
         params = params;
      }
      
      public final function toString() : String
      {
         return Boot.enum_to_string(this);
      }
   }
}
