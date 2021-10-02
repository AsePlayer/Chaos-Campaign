package as3reflect
{
   public class MetaDataContainer implements IMetaDataContainer
   {
       
      
      private var _metaData:Array;
      
      public function MetaDataContainer(metaData:Array = null)
      {
         super();
         _metaData = metaData == null ? [] : metaData;
      }
      
      public function addMetaData(metaData:MetaData) : void
      {
         _metaData.push(metaData);
      }
      
      public function getMetaData(key:String) : Array
      {
         var result:Array = [];
         for(var i:int = 0; i < _metaData.length; i++)
         {
            if(MetaData(_metaData[i]).name == key)
            {
               result.push(_metaData[i]);
            }
         }
         return result;
      }
      
      public function get metaData() : Array
      {
         return _metaData.concat();
      }
      
      public function hasMetaData(key:String) : Boolean
      {
         return getMetaData(key) != null;
      }
   }
}
