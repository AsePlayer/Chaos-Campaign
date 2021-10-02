package flashx.textLayout.conversion
{
   public interface ITextLayoutImporter extends ITextImporter
   {
       
      
      function get imageSourceResolveFunction() : Function;
      
      function set imageSourceResolveFunction(resolver:Function) : void;
   }
}
