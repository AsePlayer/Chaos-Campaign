package fl.text
{
   import flash.text.StyleSheet;
   import flash.text.engine.*;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.IFormatResolver;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   [ExcludeClass]
   internal class CSSFormatResolver implements IFormatResolver
   {
      
      private static const textFieldToTLFStyleMap:Object = {
         "leading":"lineHeight",
         "letterSpacing":"trackingRight",
         "marginLeft":"paragraphStartIndent",
         "marginRight":"paragraphEndIndent"
      };
      
      private static const tlfToTextFieldStyleMap:Object = {
         "lineHeight":"leading",
         "trackingRight":"letterSpacing",
         "paragraphStartIndent":"marginLeft",
         "paragraphEndIndent":"marginRight"
      };
       
      
      private var _styleSheet:StyleSheet;
      
      public function CSSFormatResolver(styleSheet:StyleSheet)
      {
         super();
         this._styleSheet = styleSheet;
      }
      
      public function getResolverForNewFlow(oldFlow:TextFlow, newFlow:TextFlow) : IFormatResolver
      {
         return this;
      }
      
      public function invalidate(target:Object) : void
      {
      }
      
      public function resolveFormat(elem:Object) : ITextLayoutFormat
      {
         var attr:TextLayoutFormat = null;
         var attrName:String = null;
         if(elem is FlowElement)
         {
            try
            {
               if(Boolean(elem.typeName))
               {
                  switch(elem.typeName)
                  {
                     case "TextFlow":
                        attr = this.addStyleAttributes(attr,"body");
                        break;
                     default:
                        attr = this.addStyleAttributes(attr,String(elem.typeName));
                  }
               }
               if(elem.styleName != null)
               {
                  attr = this.addStyleAttributes(attr,"." + elem.styleName);
               }
            }
            catch(e:Error)
            {
               for(attrName in tlfToTextFieldStyleMap)
               {
                  e.message = String(e.message).replace(attrName,tlfToTextFieldStyleMap[attrName]);
               }
               trace("Error (CSS Style Name - " + elem.styleName + "): " + e.message);
               return null;
            }
         }
         return attr;
      }
      
      public function invalidateAll(tf:TextFlow) : void
      {
      }
      
      private function addStyleAttributes(attr:TextLayoutFormat, styleSelector:String) : TextLayoutFormat
      {
         var p:* = undefined;
         var propStyle:Object = null;
         var tlfProp:String = null;
         var color:String = null;
         var foundStyle:Object = this._styleSheet.getStyle(styleSelector);
         if(foundStyle != null)
         {
            for(p in foundStyle)
            {
               propStyle = foundStyle[p];
               if(attr == null)
               {
                  attr = new TextLayoutFormat();
               }
               if(Boolean(textFieldToTLFStyleMap[p]))
               {
                  tlfProp = String(textFieldToTLFStyleMap[p]);
                  attr[tlfProp] = propStyle;
               }
               else if(p == "color" || p == "backgroundColor")
               {
                  color = String(propStyle);
                  if(Boolean(color) && color.charAt(0) == "#")
                  {
                     attr[p] = "0x" + color.substring(1);
                  }
               }
               else if(p != "display")
               {
                  if(p == "kerning")
                  {
                     if(String(propStyle).toLowerCase() == "true")
                     {
                        attr.kerning = Kerning.ON;
                     }
                     else
                     {
                        attr.kerning = Kerning.OFF;
                     }
                  }
                  else if(String(p).toLowerCase() == "textdecoration")
                  {
                     if(String(propStyle).toLowerCase() == "line-through")
                     {
                        attr.lineThrough = true;
                     }
                     else
                     {
                        attr[p] = propStyle;
                     }
                  }
                  else
                  {
                     attr[p] = propStyle;
                  }
               }
            }
         }
         return attr;
      }
      
      public function resolveUserFormat(elem:Object, userStyle:String) : *
      {
         var attr:TextLayoutFormat = null;
         var attrName:String = null;
         var flowElem:FlowElement = elem as FlowElement;
         if(Boolean(flowElem))
         {
            try
            {
               if(flowElem.styleName)
               {
                  attr = this.addStyleAttributes(null,"." + flowElem.styleName);
               }
               else if(flowElem is LinkElement)
               {
                  if(userStyle == "linkNormalFormat")
                  {
                     attr = this.addStyleAttributes(null,"a:link");
                  }
                  else if(userStyle == "linkHoverFormat")
                  {
                     attr = this.addStyleAttributes(null,"a:hover");
                  }
                  else if(userStyle == "linkActiveFormat")
                  {
                     attr = this.addStyleAttributes(null,"a:active");
                  }
               }
               else
               {
                  attr = this.addStyleAttributes(null,userStyle);
               }
            }
            catch(e:Error)
            {
               for(attrName in tlfToTextFieldStyleMap)
               {
                  e.message = String(e.message).replace(attrName,tlfToTextFieldStyleMap[attrName]);
               }
               trace("Error (CSS Style Name - " + elem.styleName + "): " + e.message);
               return null;
            }
         }
         return attr != null ? attr : undefined;
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
   }
}
