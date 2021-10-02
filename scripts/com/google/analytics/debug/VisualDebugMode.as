package com.google.analytics.debug
{
   public class VisualDebugMode
   {
      
      public static const advanced:VisualDebugMode = new VisualDebugMode(1,"advanced");
      
      public static const geek:VisualDebugMode = new VisualDebugMode(2,"geek");
      
      public static const basic:VisualDebugMode = new VisualDebugMode(0,"basic");
       
      
      private var _value:int;
      
      private var _name:String;
      
      public function VisualDebugMode(value:int = 0, name:String = "")
      {
         super();
         _value = value;
         _name = name;
      }
      
      public function valueOf() : int
      {
         return _value;
      }
      
      public function toString() : String
      {
         return _name;
      }
   }
}
