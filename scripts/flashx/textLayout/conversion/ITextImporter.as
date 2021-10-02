package flashx.textLayout.conversion
{
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.TextFlow;
   
   public interface ITextImporter
   {
       
      
      function importToFlow(source:Object) : TextFlow;
      
      function get errors() : Vector.<String>;
      
      function get throwOnError() : Boolean;
      
      function set throwOnError(value:Boolean) : void;
      
      function get useClipboardAnnotations() : Boolean;
      
      function set useClipboardAnnotations(value:Boolean) : void;
      
      function get configuration() : IConfiguration;
      
      function set configuration(value:IConfiguration) : void;
   }
}
