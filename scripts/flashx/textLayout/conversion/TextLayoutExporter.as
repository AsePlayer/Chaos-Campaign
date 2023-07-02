package flashx.textLayout.conversion
{
   import flashx.textLayout.elements.DivElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ListElement;
   import flashx.textLayout.elements.SubParagraphGroupElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ListMarkerFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   internal class TextLayoutExporter extends BaseTextLayoutExporter
   {
      
      private static var _formatDescription:Object = TextLayoutFormat.tlf_internal::description;
      
      private static const brTabRegEx:RegExp = new RegExp("[" + " " + "\t" + "]");
       
      
      public function TextLayoutExporter()
      {
         super(new Namespace("http://ns.adobe.com/textLayout/2008"),null,TextLayoutImporter.defaultConfiguration);
      }
      
      public static function exportImage(exporter:BaseTextLayoutExporter, image:InlineGraphicElement) : XMLList
      {
         var output:XMLList = exportFlowElement(exporter,image);
         if(image.height !== undefined)
         {
            output.@height = image.height;
         }
         if(image.width !== undefined)
         {
            output.@width = image.width;
         }
         if(image.source != null)
         {
            output.@source = image.source;
         }
         if(image.float != undefined)
         {
            output.@float = image.float;
         }
         return output;
      }
      
      public static function exportLink(exporter:BaseTextLayoutExporter, link:LinkElement) : XMLList
      {
         var output:XMLList = exportFlowGroupElement(exporter,link);
         if(Boolean(link.href))
         {
            output.@href = link.href;
         }
         if(Boolean(link.target))
         {
            output.@target = link.target;
         }
         return output;
      }
      
      public static function exportDiv(exporter:BaseTextLayoutExporter, div:DivElement) : XMLList
      {
         return exportContainerFormattedElement(exporter,div);
      }
      
      public static function exportSPGE(exporter:BaseTextLayoutExporter, elem:SubParagraphGroupElement) : XMLList
      {
         return exportFlowGroupElement(exporter,elem);
      }
      
      public static function exportTCY(exporter:BaseTextLayoutExporter, tcy:TCYElement) : XMLList
      {
         return exportFlowGroupElement(exporter,tcy);
      }
      
      override protected function get spanTextReplacementRegex() : RegExp
      {
         return brTabRegEx;
      }
      
      override protected function getSpanTextReplacementXML(ch:String) : XML
      {
         var replacementXML:XML = null;
         if(ch == " ")
         {
            replacementXML = <br/>;
         }
         else
         {
            if(ch != "\t")
            {
               return null;
            }
            replacementXML = <tab/>;
         }
         replacementXML.setNamespace(flowNS);
         return replacementXML;
      }
      
      tlf_internal function createStylesFromDescription(styles:Object, description:Object, includeUserStyles:Boolean, exclusions:Array) : Array
      {
         var key:String = null;
         var val:Object = null;
         var prop:Property = null;
         var customDictProp:XMLList = null;
         var sortableStyles:Array = [];
         for(key in styles)
         {
            val = styles[key];
            if(!(Boolean(exclusions) && exclusions.indexOf(val) != -1))
            {
               prop = description[key];
               if(!prop)
               {
                  if(includeUserStyles)
                  {
                     if(val is String || val.hasOwnProperty("toString"))
                     {
                        sortableStyles.push({
                           "xmlName":key,
                           "xmlVal":val
                        });
                     }
                  }
               }
               else if(val is TextLayoutFormat)
               {
                  customDictProp = this.tlf_internal::exportObjectAsTextLayoutFormat(key,(val as TextLayoutFormat).tlf_internal::getStyles());
                  if(Boolean(customDictProp))
                  {
                     sortableStyles.push({
                        "xmlName":key,
                        "xmlVal":customDictProp
                     });
                  }
               }
               else
               {
                  sortableStyles.push({
                     "xmlName":key,
                     "xmlVal":prop.toXMLString(val)
                  });
               }
            }
         }
         return sortableStyles;
      }
      
      tlf_internal function exportObjectAsTextLayoutFormat(key:String, styleDict:Object) : XMLList
      {
         var elementName:String = null;
         var description:Object = null;
         if(key == LinkElement.tlf_internal::LINK_NORMAL_FORMAT_NAME || key == LinkElement.tlf_internal::LINK_ACTIVE_FORMAT_NAME || key == LinkElement.tlf_internal::LINK_HOVER_FORMAT_NAME)
         {
            elementName = "TextLayoutFormat";
            description = TextLayoutFormat.tlf_internal::description;
         }
         else if(key == ListElement.tlf_internal::LIST_MARKER_FORMAT_NAME)
         {
            elementName = "ListMarkerFormat";
            description = ListMarkerFormat.tlf_internal::description;
         }
         if(elementName == null)
         {
            return null;
         }
         var formatXML:XML = new XML("<" + elementName + "/>");
         formatXML.setNamespace(flowNS);
         var sortableStyles:Array = this.tlf_internal::createStylesFromDescription(styleDict,description,true,null);
         exportStyles(XMLList(formatXML),sortableStyles);
         var propertyXML:XMLList = XMLList(new XML("<" + key + "/>"));
         propertyXML.appendChild(formatXML);
         return propertyXML;
      }
      
      override protected function exportFlowElement(flowElement:FlowElement) : XMLList
      {
         var sortableStyles:Array = null;
         var rslt:XMLList = super.exportFlowElement(flowElement);
         var allStyles:Object = flowElement.styles;
         if(Boolean(allStyles))
         {
            delete allStyles[TextLayoutFormat.whiteSpaceCollapseProperty.name];
            sortableStyles = this.tlf_internal::createStylesFromDescription(allStyles,this.formatDescription,true,Boolean(flowElement.parent) ? null : [FormatValue.INHERIT]);
            exportStyles(rslt,sortableStyles);
         }
         if(flowElement.id != null)
         {
            rslt["id"] = flowElement.id;
         }
         if(flowElement.typeName != flowElement.tlf_internal::defaultTypeName)
         {
            rslt["typeName"] = flowElement.typeName;
         }
         return rslt;
      }
      
      override protected function get formatDescription() : Object
      {
         return _formatDescription;
      }
   }
}
