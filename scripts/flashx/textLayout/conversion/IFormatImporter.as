package flashx.textLayout.conversion
{
   [ExcludeClass]
   public interface IFormatImporter
   {
       
      
      function reset() : void;
      
      function get result() : Object;
      
      function importOneFormat(key:String, val:String) : Boolean;
   }
}
