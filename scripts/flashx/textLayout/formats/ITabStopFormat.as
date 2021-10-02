package flashx.textLayout.formats
{
   public interface ITabStopFormat
   {
       
      
      function getStyle(styleName:String) : *;
      
      function get position() : *;
      
      function get alignment() : *;
      
      function get decimalAlignmentToken() : *;
   }
}
