package as3reflect
{
   public interface IMetaDataContainer
   {
       
      
      function addMetaData(metaData:MetaData) : void;
      
      function hasMetaData(key:String) : Boolean;
      
      function getMetaData(key:String) : Array;
      
      function get metaData() : Array;
   }
}
