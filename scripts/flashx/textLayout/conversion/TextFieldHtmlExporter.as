package flashx.textLayout.conversion
{
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.TabAlignment;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.elements.*;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.Float;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   public class TextFieldHtmlExporter extends ConverterBase implements ITextExporter
   {
      
      tlf_internal static var _config:flashx.textLayout.conversion.ImportExportConfiguration;
      
      tlf_internal static const brRegEx:RegExp = / /;
       
      
      public function TextFieldHtmlExporter()
      {
         super();
         if(!tlf_internal::_config)
         {
            tlf_internal::_config = new flashx.textLayout.conversion.ImportExportConfiguration();
            tlf_internal::_config.addIEInfo(null,DivElement,null,this.tlf_internal::exportDiv);
            tlf_internal::_config.addIEInfo(null,ParagraphElement,null,this.tlf_internal::exportParagraph);
            tlf_internal::_config.addIEInfo(null,LinkElement,null,this.tlf_internal::exportLink);
            tlf_internal::_config.addIEInfo(null,TCYElement,null,this.tlf_internal::exportTCY);
            tlf_internal::_config.addIEInfo(null,SubParagraphGroupElement,null,this.tlf_internal::exportSPGE);
            tlf_internal::_config.addIEInfo(null,SpanElement,null,this.tlf_internal::exportSpan);
            tlf_internal::_config.addIEInfo(null,InlineGraphicElement,null,this.tlf_internal::exportImage);
            tlf_internal::_config.addIEInfo(null,TabElement,null,this.tlf_internal::exportTab);
            tlf_internal::_config.addIEInfo(null,BreakElement,null,this.tlf_internal::exportBreak);
            tlf_internal::_config.addIEInfo(null,ListElement,null,this.tlf_internal::exportList);
            tlf_internal::_config.addIEInfo(null,ListItemElement,null,this.tlf_internal::exportListItem);
         }
      }
      
      tlf_internal static function makeTaggedTypeName(elem:FlowElement, defaultTag:String) : XML
      {
         if(elem.typeName == elem.tlf_internal::defaultTypeName)
         {
            return new XML("<" + defaultTag + "/>");
         }
         return new XML("<" + elem.typeName.toUpperCase() + "/>");
      }
      
      tlf_internal static function exportStyling(elem:FlowElement, xml:XML) : void
      {
         if(elem.id != null)
         {
            xml["id"] = elem.id;
         }
         if(elem.styleName != null)
         {
            xml["class"] = elem.styleName;
         }
      }
      
      tlf_internal static function getSpanTextReplacementXML(ch:String) : XML
      {
         return <BR/>;
      }
      
      tlf_internal static function nest(parent:XML, children:Object) : XML
      {
         parent.setChildren(children);
         return parent;
      }
      
      public function export(source:TextFlow, conversionType:String) : Object
      {
         var result:XML = this.tlf_internal::exportToXML(source);
         return conversionType == ConversionType.STRING_TYPE ? BaseTextLayoutExporter.tlf_internal::convertXMLToString(result) : result;
      }
      
      tlf_internal function exportToXML(textFlow:TextFlow) : XML
      {
         var body:XML = null;
         var html:XML = <HTML/>;
         if(textFlow.numChildren != 0)
         {
            if(textFlow.getChildAt(0).typeName != "BODY")
            {
               body = <BODY/>;
               html.appendChild(body);
               this.tlf_internal::exportChildren(textFlow,body);
            }
            else
            {
               this.tlf_internal::exportChildren(textFlow,html);
            }
         }
         return html;
      }
      
      tlf_internal function exportChildren(elem:FlowGroupElement, parentXML:XML) : void
      {
         var child:FlowElement = null;
         for(var idx:int = 0; idx < elem.numChildren; idx++)
         {
            child = elem.getChildAt(idx);
            this.tlf_internal::exportElement(child,parentXML);
         }
      }
      
      tlf_internal function exportList(list:ListElement, parentXML:XML) : void
      {
         var xml:XML = null;
         var typeNameXML:XML = null;
         if(list.tlf_internal::isNumberedList())
         {
            xml = <OL/>;
         }
         else
         {
            xml = <UL/>;
         }
         tlf_internal::exportStyling(list,xml);
         this.tlf_internal::exportChildren(list,xml);
         if(list.typeName != list.tlf_internal::defaultTypeName)
         {
            typeNameXML = new XML("<" + list.typeName + "/>");
            typeNameXML.appendChild(xml);
            parentXML.appendChild(typeNameXML);
         }
         else
         {
            parentXML.appendChild(xml);
         }
      }
      
      tlf_internal function exportListItem(li:ListItemElement, parentXML:XML) : void
      {
         var child:XML = null;
         var paraChildren:XMLList = null;
         var xml:XML = <LI/>;
         tlf_internal::exportStyling(li,xml);
         this.tlf_internal::exportChildren(li,xml);
         var children:XMLList = xml.children();
         if(children.length() == 1)
         {
            child = children[0];
            if(child.name().localName == "P")
            {
               paraChildren = child.children();
               if(paraChildren.length() == 1)
               {
                  xml = <LI/>;
                  xml.appendChild(paraChildren[0]);
               }
            }
         }
         parentXML.appendChild(xml);
      }
      
      tlf_internal function exportDiv(div:DivElement, parentXML:XML) : void
      {
         var xml:XML = tlf_internal::makeTaggedTypeName(div,"DIV");
         tlf_internal::exportStyling(div,xml);
         this.tlf_internal::exportChildren(div,xml);
         parentXML.appendChild(xml);
      }
      
      tlf_internal function exportParagraph(para:ParagraphElement, parentXML:XML) : void
      {
         var xml:XML = tlf_internal::makeTaggedTypeName(para,"P");
         tlf_internal::exportStyling(para,xml);
         var fontXML:XML = this.tlf_internal::exportFont(para.computedFormat);
         this.tlf_internal::exportSubParagraphChildren(para,fontXML);
         tlf_internal::nest(xml,fontXML);
         parentXML.appendChild(this.tlf_internal::exportParagraphFormat(xml,para));
      }
      
      tlf_internal function exportLink(link:LinkElement, parentXML:XML) : void
      {
         var xml:XML = <A/>;
         if(Boolean(link.href))
         {
            xml.@HREF = link.href;
         }
         if(Boolean(link.target))
         {
            xml.@TARGET = link.target;
         }
         else
         {
            xml.@TARGET = "_blank";
         }
         this.tlf_internal::exportSubParagraphElement(link,xml,parentXML);
      }
      
      tlf_internal function exportTCY(tcy:TCYElement, parentXML:XML) : void
      {
         var xml:XML = <TCY/>;
         this.tlf_internal::exportSubParagraphElement(tcy,xml,parentXML);
      }
      
      tlf_internal function exportSPGE(spge:SubParagraphGroupElement, parentXML:XML) : void
      {
         var xml:XML = spge.typeName != spge.tlf_internal::defaultTypeName ? new XML("<" + spge.typeName + "/>") : <SPAN/>;
         this.tlf_internal::exportSubParagraphElement(spge,xml,parentXML,false);
      }
      
      tlf_internal function exportSubParagraphElement(elem:SubParagraphGroupElementBase, xml:XML, parentXML:XML, checkTypeName:Boolean = true) : void
      {
         var typeNameXML:XML = null;
         tlf_internal::exportStyling(elem,xml);
         this.tlf_internal::exportSubParagraphChildren(elem,xml);
         var format:ITextLayoutFormat = elem.computedFormat;
         var ifDifferentFromFormat:ITextLayoutFormat = elem.parent.computedFormat;
         var font:XML = this.tlf_internal::exportFont(format,ifDifferentFromFormat);
         var childXML:XML = Boolean(font) ? tlf_internal::nest(font,xml) : xml;
         if(checkTypeName && elem.typeName != elem.tlf_internal::defaultTypeName)
         {
            typeNameXML = new XML("<" + elem.typeName + "/>");
            typeNameXML.appendChild(childXML);
            parentXML.appendChild(typeNameXML);
         }
         else
         {
            parentXML.appendChild(childXML);
         }
      }
      
      tlf_internal function exportSpan(span:SpanElement, parentXML:XML) : void
      {
         var children:Object = null;
         var xml:XML = tlf_internal::makeTaggedTypeName(span,"SPAN");
         tlf_internal::exportStyling(span,xml);
         BaseTextLayoutExporter.exportSpanText(xml,span,tlf_internal::brRegEx,tlf_internal::getSpanTextReplacementXML);
         if(span.id == null && span.styleName == null && span.typeName == span.tlf_internal::defaultTypeName)
         {
            children = xml.children();
            if(children.length() == 1 && children[0].nodeKind() == "text")
            {
               children = xml.text()[0];
            }
            parentXML.appendChild(this.tlf_internal::exportSpanFormat(children,span));
         }
         else
         {
            parentXML.appendChild(this.tlf_internal::exportSpanFormat(xml,span));
         }
      }
      
      tlf_internal function exportImage(image:InlineGraphicElement, parentXML:XML) : void
      {
         var typeNameXML:XML = null;
         var xml:XML = <IMG/>;
         tlf_internal::exportStyling(image,xml);
         if(Boolean(image.source))
         {
            xml.@SRC = image.source;
         }
         if(image.width !== undefined && image.width != FormatValue.AUTO)
         {
            xml.@WIDTH = image.width;
         }
         if(image.height !== undefined && image.height != FormatValue.AUTO)
         {
            xml.@HEIGHT = image.height;
         }
         if(image.tlf_internal::computedFloat != Float.NONE)
         {
            xml.@ALIGN = image.float;
         }
         if(image.typeName != image.tlf_internal::defaultTypeName)
         {
            typeNameXML = new XML("<" + image.typeName + "/>");
            typeNameXML.appendChild(xml);
            parentXML.appendChild(typeNameXML);
         }
         else
         {
            parentXML.appendChild(xml);
         }
      }
      
      tlf_internal function exportBreak(breakElement:BreakElement, parentXML:XML) : void
      {
         parentXML.appendChild(<BR/>);
      }
      
      tlf_internal function exportTab(tabElement:TabElement, parentXML:XML) : void
      {
         this.tlf_internal::exportSpan(tabElement,parentXML);
      }
      
      tlf_internal function exportTextFormatAttribute(textFormatXML:XML, attrName:String, attrVal:*) : XML
      {
         if(!textFormatXML)
         {
            textFormatXML = <TEXTFORMAT/>;
         }
         textFormatXML[attrName] = attrVal;
         return textFormatXML;
      }
      
      tlf_internal function exportParagraphFormat(xml:XML, para:ParagraphElement) : XML
      {
         var textAlignment:String = null;
         var textFormat:XML = null;
         var firstLeaf:FlowLeafElement = null;
         var lineHeight:Number = NaN;
         var tabStopsString:String = null;
         var tabStop:TabStopFormat = null;
         var paraFormat:ITextLayoutFormat = para.computedFormat;
         switch(paraFormat.textAlign)
         {
            case TextAlign.START:
               textAlignment = paraFormat.direction == Direction.LTR ? TextAlign.LEFT : TextAlign.RIGHT;
               break;
            case TextAlign.END:
               textAlignment = paraFormat.direction == Direction.LTR ? TextAlign.RIGHT : TextAlign.LEFT;
               break;
            default:
               textAlignment = String(paraFormat.textAlign);
         }
         xml.@ALIGN = textAlignment;
         if(paraFormat.paragraphStartIndent != 0)
         {
            textFormat = this.tlf_internal::exportTextFormatAttribute(textFormat,paraFormat.direction == Direction.LTR ? "LEFTMARGIN" : "RIGHTMARGIN",paraFormat.paragraphStartIndent);
         }
         if(paraFormat.paragraphEndIndent != 0)
         {
            textFormat = this.tlf_internal::exportTextFormatAttribute(textFormat,paraFormat.direction == Direction.LTR ? "RIGHTMARGIN" : "LEFTMARGIN",paraFormat.paragraphEndIndent);
         }
         if(paraFormat.textIndent != 0)
         {
            textFormat = this.tlf_internal::exportTextFormatAttribute(textFormat,"INDENT",paraFormat.textIndent);
         }
         if(paraFormat.leadingModel == LeadingModel.APPROXIMATE_TEXT_FIELD)
         {
            firstLeaf = para.getFirstLeaf();
            if(Boolean(firstLeaf))
            {
               lineHeight = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(firstLeaf.computedFormat.lineHeight,firstLeaf.tlf_internal::getEffectiveFontSize());
               if(lineHeight != 0)
               {
                  textFormat = this.tlf_internal::exportTextFormatAttribute(textFormat,"LEADING",lineHeight);
               }
            }
         }
         var tabStops:Array = paraFormat.tabStops;
         if(Boolean(tabStops))
         {
            tabStopsString = "";
            for each(tabStop in tabStops)
            {
               if(tabStop.alignment != TabAlignment.START)
               {
                  break;
               }
               if(Boolean(tabStopsString.length))
               {
                  tabStopsString += ", ";
               }
               tabStopsString += tabStop.position;
            }
            if(Boolean(tabStopsString.length))
            {
               textFormat = this.tlf_internal::exportTextFormatAttribute(textFormat,"TABSTOPS",tabStopsString);
            }
         }
         return Boolean(textFormat) ? tlf_internal::nest(textFormat,xml) : xml;
      }
      
      tlf_internal function exportSpanFormat(xml:Object, span:SpanElement) : Object
      {
         var format:ITextLayoutFormat = span.computedFormat;
         var outerElement:Object = xml;
         if(format.textDecoration.toString() == TextDecoration.UNDERLINE)
         {
            outerElement = tlf_internal::nest(<U/>,outerElement);
         }
         if(format.fontStyle.toString() == FontPosture.ITALIC)
         {
            outerElement = tlf_internal::nest(<I/>,outerElement);
         }
         if(format.fontWeight.toString() == FontWeight.BOLD)
         {
            outerElement = tlf_internal::nest(<B/>,outerElement);
         }
         var exportedParent:FlowElement = span.getParentByType(LinkElement);
         if(!exportedParent)
         {
            exportedParent = span.getParagraph();
         }
         var font:XML = this.tlf_internal::exportFont(format,exportedParent.computedFormat);
         if(Boolean(font))
         {
            outerElement = tlf_internal::nest(font,outerElement);
         }
         return outerElement;
      }
      
      tlf_internal function exportFontAttribute(fontXML:XML, attrName:String, attrVal:*) : XML
      {
         if(!fontXML)
         {
            fontXML = <FONT/>;
         }
         fontXML[attrName] = attrVal;
         return fontXML;
      }
      
      tlf_internal function exportFont(format:ITextLayoutFormat, ifDifferentFromFormat:ITextLayoutFormat = null) : XML
      {
         var font:XML = null;
         var rgb:String = null;
         if(!ifDifferentFromFormat || ifDifferentFromFormat.fontFamily != format.fontFamily)
         {
            font = this.tlf_internal::exportFontAttribute(font,"FACE",format.fontFamily);
         }
         if(!ifDifferentFromFormat || ifDifferentFromFormat.fontSize != format.fontSize)
         {
            font = this.tlf_internal::exportFontAttribute(font,"SIZE",format.fontSize);
         }
         if(!ifDifferentFromFormat || ifDifferentFromFormat.color != format.color)
         {
            rgb = String(format.color.toString(16));
            while(rgb.length < 6)
            {
               rgb = "0" + rgb;
            }
            rgb = "#" + rgb;
            font = this.tlf_internal::exportFontAttribute(font,"COLOR",rgb);
         }
         if(!ifDifferentFromFormat || ifDifferentFromFormat.trackingRight != format.trackingRight)
         {
            font = this.tlf_internal::exportFontAttribute(font,"LETTERSPACING",format.trackingRight);
         }
         if(!ifDifferentFromFormat || ifDifferentFromFormat.kerning != format.kerning)
         {
            font = this.tlf_internal::exportFontAttribute(font,"KERNING",format.kerning == Kerning.OFF ? "0" : "1");
         }
         return font;
      }
      
      tlf_internal function exportElement(flowElement:FlowElement, parentXML:XML) : void
      {
         var xml:XML = null;
         var className:String = getQualifiedClassName(flowElement);
         var info:FlowElementInfo = tlf_internal::_config.lookupByClass(className);
         if(Boolean(info))
         {
            info.exporter(flowElement,parentXML);
         }
         else
         {
            xml = new XML("<" + flowElement.typeName.toUpperCase() + "/>");
            this.tlf_internal::exportChildren(flowElement as FlowGroupElement,xml);
            parentXML.appendChild(xml);
         }
      }
      
      tlf_internal function exportSubParagraphChildren(flowGroupElement:FlowGroupElement, parentXML:XML) : void
      {
         for(var i:int = 0; i < flowGroupElement.numChildren; i++)
         {
            this.tlf_internal::exportElement(flowGroupElement.getChildAt(i),parentXML);
         }
      }
   }
}
