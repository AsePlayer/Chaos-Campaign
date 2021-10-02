package flashx.textLayout.conversion
{
   public interface IPlainTextExporter extends ITextExporter
   {
       
      
      function get paragraphSeparator() : String;
      
      function set paragraphSeparator(value:String) : void;
      
      function get stripDiscretionaryHyphens() : Boolean;
      
      function set stripDiscretionaryHyphens(value:Boolean) : void;
   }
}
