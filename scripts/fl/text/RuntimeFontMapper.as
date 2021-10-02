package fl.text
{
   import flash.text.engine.FontDescription;
   import flash.utils.Dictionary;
   
   [ExcludeClass]
   public class RuntimeFontMapper
   {
      
      private static var fontMapDict:Dictionary = new Dictionary();
       
      
      public function RuntimeFontMapper()
      {
         super();
      }
      
      public static function fontMapper(fd:FontDescription) : void
      {
         var key:String = "[\'" + fd.fontName + "\',\'" + fd.fontWeight + "\',\'" + fd.fontPosture + "\']";
         var mappingArray:Array = fontMapDict[key];
         if(mappingArray != null)
         {
            fd.fontName = mappingArray[0];
            fd.fontWeight = mappingArray[1];
            fd.fontPosture = mappingArray[2];
         }
      }
      
      public static function addFontMapEntry(key:String, value:Array) : void
      {
         fontMapDict[key] = value;
      }
   }
}
