package flashx.textLayout.conversion
{
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   public class ImportExportConfiguration
   {
       
      
      tlf_internal var flowElementInfoList:Object;
      
      tlf_internal var flowElementClassList:Object;
      
      tlf_internal var classToNameMap:Object;
      
      public function ImportExportConfiguration()
      {
         this.tlf_internal::flowElementInfoList = {};
         this.tlf_internal::flowElementClassList = {};
         this.tlf_internal::classToNameMap = {};
         super();
      }
      
      public function addIEInfo(name:String, flowClass:Class, parser:Function, exporter:Function) : void
      {
         var info:FlowElementInfo = new FlowElementInfo(flowClass,parser,exporter);
         if(Boolean(name))
         {
            this.tlf_internal::flowElementInfoList[name] = info;
         }
         if(Boolean(flowClass))
         {
            this.tlf_internal::flowElementClassList[info.flowClassName] = info;
         }
         if(Boolean(name) && Boolean(flowClass))
         {
            this.tlf_internal::classToNameMap[info.flowClassName] = name;
         }
      }
      
      public function lookup(name:String) : FlowElementInfo
      {
         return this.tlf_internal::flowElementInfoList[name];
      }
      
      public function lookupName(classToMatch:String) : String
      {
         return this.tlf_internal::classToNameMap[classToMatch];
      }
      
      public function lookupByClass(classToMatch:String) : FlowElementInfo
      {
         return this.tlf_internal::flowElementClassList[classToMatch];
      }
   }
}
