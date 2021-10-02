package com.google.analytics.core
{
   public class DomainNameMode
   {
      
      public static const custom:DomainNameMode = new DomainNameMode(2,"custom");
      
      public static const none:DomainNameMode = new DomainNameMode(0,"none");
      
      public static const auto:DomainNameMode = new DomainNameMode(1,"auto");
       
      
      private var _value:int;
      
      private var _name:String;
      
      public function DomainNameMode(value:int = 0, name:String = "")
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
