package com.brockw.game
{
   import flash.utils.ByteArray;
   
   public class XMLLoader
   {
      
      public static const GameConstants:Class = XMLLoader_GameConstants;
       
      
      public var xml:XML;
      
      public function XMLLoader()
      {
         super();
         var file:ByteArray = new XMLLoader.GameConstants();
         var str:String = file.readUTFBytes(file.length);
         this.xml = new XML(str);
      }
   }
}
