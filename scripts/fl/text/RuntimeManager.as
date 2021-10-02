package fl.text
{
   import fl.timeline.TimelineManager;
   import fl.timeline.timelineManager.InstanceInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.text.TextFieldType;
   import flash.utils.getDefinitionByName;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.InlineGraphicElementStatus;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.StatusChangeEvent;
   import flashx.textLayout.formats.BackgroundColor;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   [ExcludeClass]
   public class RuntimeManager extends TimelineManager
   {
      
      private static var singleton:RuntimeManager = new RuntimeManager();
      
      private static var globalConfig:Object;
       
      
      public function RuntimeManager()
      {
         super();
         _supportNextPrevAcrossFrames = true;
      }
      
      public static function checkTLFFontsLoaded(e:Event, fontName:String = null, fn:Function = null) : Boolean
      {
         var fontClass:Class = null;
         if(fontName == null && e != null)
         {
            try
            {
               if(e.target.hasOwnProperty("__checkFontName_"))
               {
                  var fontName:String = e.target["__checkFontName_"];
               }
            }
            catch(te1:TypeError)
            {
               fontName = null;
            }
         }
         if(fontName == null)
         {
            if(e != null)
            {
               e.target.removeEventListener(Event.FRAME_CONSTRUCTED,checkTLFFontsLoaded,false);
            }
            return false;
         }
         var loaded:Boolean = true;
         try
         {
            fontClass = Class(getDefinitionByName(fontName));
            if(new fontClass()["fontName"] == null)
            {
               loaded = false;
            }
         }
         catch(re:ReferenceError)
         {
            loaded = false;
         }
         catch(te2:TypeError)
         {
            loaded = false;
         }
         if(loaded)
         {
            if(fn != null)
            {
               fn();
            }
            else if(e != null)
            {
               e.target.removeEventListener(Event.FRAME_CONSTRUCTED,checkTLFFontsLoaded,false);
               if(e.target.hasOwnProperty("__registerTLFFonts"))
               {
                  try
                  {
                     e.target["__registerTLFFonts"]();
                  }
                  catch(te3:TypeError)
                  {
                  }
               }
            }
         }
         return loaded;
      }
      
      private static function getGlobalConfig() : Object
      {
         if(globalConfig != null)
         {
            return globalConfig;
         }
         globalConfig = new Configuration(true);
         globalConfig.inlineGraphicResolverFunction = resolveInlines;
         return globalConfig;
      }
      
      public static function getSingleton() : RuntimeManager
      {
         return singleton;
      }
      
      public static function ColorStringToUint(inColorString:String) : uint
      {
         if(inColorString.substr(0,1) == "#")
         {
            inColorString = "0x" + inColorString.substr(1);
         }
         return uint(inColorString);
      }
      
      private static function recomposeOnLoadComplete(plainEvent:Event) : void
      {
         var e:StatusChangeEvent = plainEvent as StatusChangeEvent;
         if(e == null)
         {
            return;
         }
         var flow:TextFlow = e.element.getTextFlow();
         if(flow && (e.status == InlineGraphicElementStatus.SIZE_PENDING || e.status == InlineGraphicElementStatus.READY))
         {
            flow.flowComposer.updateAllControllers();
            flow.removeEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,recomposeOnLoadComplete);
         }
      }
      
      private static function resolveInlines(incomingILG:Object) : DisplayObject
      {
         var customSource:Object = null;
         var inlineInfo:* = undefined;
         var tf:TextFlow = null;
         var cls:Class = null;
         var bm:Bitmap = null;
         var ilg:InlineGraphicElement = incomingILG as InlineGraphicElement;
         if(ilg == null)
         {
            return null;
         }
         var customFormats:Object = ilg.userStyles;
         var sdo:* = null;
         if(customFormats != null)
         {
            customSource = customFormats["customSource"];
            inlineInfo = customFormats["extraInfo"];
            tf = ilg.getTextFlow();
            if(inlineInfo != undefined)
            {
               cls = inlineInfo[customSource];
               sdo = new cls();
               if(sdo is BitmapData)
               {
                  bm = new Bitmap(sdo);
                  sdo = new DynamicSprite();
                  sdo.addChild(bm);
               }
            }
            if(sdo)
            {
               sdo["ilg"] = ilg;
               tf.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,recomposeOnLoadComplete,false,0,true);
            }
         }
         return sdo as DisplayObject;
      }
      
      public function configureInstance(drawSprite:TLFTextField, ii:InstanceInfo) : void
      {
         var textFlow:TextFlow = null;
         var styles:Object = null;
         var customSource:Object = null;
         var tempII:InstanceInfo = null;
         var found:Boolean = false;
         var computedFormat:ITextLayoutFormat = null;
         TLFRuntimeTabManager.InitTabHandler(drawSprite);
         GlobalSettings.fontMapperFunction = RuntimeFontMapper.fontMapper;
         drawSprite.contentWidth = 0;
         drawSprite.contentHeight = 0;
         var xmlTree:XML = ii.data;
         var typeTextStr:String = xmlTree.@type;
         var editPolicy:String = xmlTree.@editPolicy;
         if(editPolicy == "selectable")
         {
            editPolicy = EditingMode.READ_SELECT;
         }
         if(editPolicy == null || editPolicy.length == 0)
         {
            editPolicy = EditingMode.READ_WRITE;
         }
         var containerIndex:int = 0;
         var setEditManager:Boolean = false;
         var firstII:InstanceInfo = ii;
         while(firstII.prev != null)
         {
            containerIndex++;
            firstII = firstII.prev;
         }
         if(ii.prev != null)
         {
            textFlow = TextFlow(TLFTextField(firstII.content).textFlow);
            TLFTextField(ii.prev.content).addNextField(drawSprite);
         }
         else
         {
            textFlow = TextConverter.importToFlow(ii.data,TextConverter.TEXT_LAYOUT_FORMAT,IConfiguration(getGlobalConfig()));
            setEditManager = true;
         }
         var leaf:FlowLeafElement = textFlow.getFirstLeaf();
         while(leaf)
         {
            if(leaf as InlineGraphicElement)
            {
               styles = leaf.userStyles;
               customSource = styles["customSource"];
               tempII = firstII;
               found = false;
               while(tempII && !found)
               {
                  if(tempII.extraInfo != undefined && tempII.extraInfo[customSource] != null)
                  {
                     found = true;
                     styles["extraInfo"] = tempII.extraInfo;
                     leaf.userStyles = styles;
                  }
                  tempII = tempII.next;
               }
            }
            leaf = leaf.getNextLeaf();
         }
         var linkedContainers:Boolean = ii.prev || ii.next;
         var hasTCY:Boolean = false;
         var hasAnchor:Boolean = false;
         var hasILG:Boolean = false;
         var firstFormat:ITextLayoutFormat = textFlow.getFirstLeaf().computedFormat;
         var multipleFormats:Boolean = textFlow.direction == undefined ? Boolean(firstFormat.direction == Direction.RTL) : Boolean(textFlow.direction != firstFormat.direction);
         var curLeaf:FlowLeafElement = textFlow.getFirstLeaf();
         var p:ParagraphElement = textFlow.getChildAt(0) as ParagraphElement;
         var multipleParagraphs:Boolean = p.getNextParagraph() != null;
         if(!multipleFormats && !linkedContainers && !multipleParagraphs)
         {
            while(curLeaf)
            {
               computedFormat = curLeaf.computedFormat;
               multipleFormats = !TextLayoutFormat.isEqual(computedFormat,firstFormat) || computedFormat.backgroundColor != undefined && computedFormat.backgroundColor != BackgroundColor.TRANSPARENT;
               hasTCY = curLeaf.getParentByType(TCYElement) as TCYElement != null;
               hasAnchor = curLeaf.getParentByType(LinkElement) as LinkElement != null;
               hasILG = curLeaf.getParentByType(InlineGraphicElement) as InlineGraphicElement != null;
               if(multipleFormats || hasTCY || hasAnchor || hasILG)
               {
                  break;
               }
               curLeaf = curLeaf.getNextLeaf();
            }
         }
         if(linkedContainers || multipleFormats || multipleParagraphs || hasTCY || hasAnchor || hasILG)
         {
            drawSprite.textFlow = textFlow;
         }
         else
         {
            drawSprite.text = textFlow.getText(0,-1,"\n");
            drawSprite.hostFormat = textFlow.getFirstLeaf().computedFormat;
            drawSprite.wordWrap = textFlow.computedFormat.lineBreak == LineBreak.TO_FIT ? Boolean(true) : Boolean(false);
         }
         if(setEditManager)
         {
            drawSprite.type = TextFieldType.DYNAMIC;
            drawSprite.selectable = false;
            switch(editPolicy)
            {
               case EditingMode.READ_WRITE:
                  drawSprite.type = TextFieldType.INPUT;
                  drawSprite.selectable = true;
                  break;
               case EditingMode.READ_SELECT:
                  drawSprite.type = TextFieldType.DYNAMIC;
                  drawSprite.selectable = true;
            }
         }
         if(typeTextStr == "Paragraph")
         {
            drawSprite.isPointText = false;
            drawSprite.width = ii.bounds.width;
            drawSprite.height = ii.bounds.height;
            drawSprite.setCompositionSize(ii.bounds.width,ii.bounds.height);
         }
         else
         {
            drawSprite.isPointText = true;
            drawSprite.setCompositionSize(NaN,NaN);
         }
         drawSprite.direction = textFlow.direction;
         var attr:String = xmlTree.@columnCount;
         if(attr != null && attr.length > 0)
         {
            drawSprite.columnCount = attr;
         }
         attr = xmlTree.@columnGap;
         if(attr != null && attr.length > 0)
         {
            drawSprite.columnGap = Number(attr);
         }
         attr = xmlTree.@verticalAlign;
         if(attr != null && attr.length > 0)
         {
            drawSprite.verticalAlign = attr;
         }
         attr = xmlTree.@background;
         if(attr != null && attr.length > 0)
         {
            drawSprite.background = attr.toLowerCase() == "true";
         }
         attr = xmlTree.@backgroundColor;
         if(attr != null && attr.length > 0)
         {
            drawSprite.backgroundColor = ColorStringToUint(attr);
         }
         attr = xmlTree.@backgroundAlpha;
         if(attr != null && attr.length > 0)
         {
            drawSprite.backgroundAlpha = Number(attr);
         }
         attr = xmlTree.@border;
         if(attr != null && attr.length > 0)
         {
            drawSprite.border = attr.toLowerCase() == "true";
         }
         attr = xmlTree.@borderColor;
         if(attr != null && attr.length > 0)
         {
            drawSprite.borderColor = ColorStringToUint(attr);
         }
         attr = xmlTree.@borderAlpha;
         if(attr != null && attr.length > 0)
         {
            drawSprite.borderAlpha = Number(attr);
         }
         attr = xmlTree.@borderWidth;
         if(attr != null && attr.length > 0)
         {
            drawSprite.borderWidth = Number(attr);
         }
         attr = xmlTree.@paddingLock;
         if(attr != null && attr.length > 0)
         {
            drawSprite.paddingLock = attr.toLowerCase() == "true";
         }
         attr = xmlTree.@paddingLeft;
         if(attr != null && attr.length > 0)
         {
            drawSprite.paddingLeft = Number(attr);
         }
         attr = xmlTree.@paddingTop;
         if(attr != null && attr.length > 0)
         {
            drawSprite.paddingTop = Number(attr);
         }
         attr = xmlTree.@paddingRight;
         if(attr != null && attr.length > 0)
         {
            drawSprite.paddingRight = Number(attr);
         }
         attr = xmlTree.@paddingBottom;
         if(attr != null && attr.length > 0)
         {
            drawSprite.paddingBottom = Number(attr);
         }
         attr = xmlTree.@firstBaselineOffset;
         if(attr != null && attr.length > 0)
         {
            drawSprite.firstBaselineOffset = attr;
         }
         attr = xmlTree.@multiline;
         if(attr != null && attr.length > 0)
         {
            drawSprite.multiline = attr.toLowerCase() == "true";
         }
         attr = xmlTree.@antiAliasType;
         if(attr != null && attr.length > 0)
         {
            drawSprite.antiAliasType = attr;
         }
         attr = xmlTree.@embedFonts;
         if(attr != null && attr.length > 0)
         {
            drawSprite.embedFonts = attr.toLowerCase() == "true";
         }
         attr = xmlTree.@maxChars;
         if(attr != null && attr.length > 0)
         {
            drawSprite.maxChars = int(attr);
         }
         attr = xmlTree.@displayAsPassword;
         if(attr != null && attr.length > 0)
         {
            drawSprite.displayAsPassword = attr.toLowerCase() == "true";
         }
         attr = xmlTree.@text;
         if(attr != null && attr.length > 0)
         {
            drawSprite.text = attr;
         }
         drawSprite.alwaysShowSelection = false;
         drawSprite.repaint();
      }
      
      override protected function getInstanceForInfo(ii:InstanceInfo, instance:DisplayObject = null) : DisplayObject
      {
         try
         {
            if(getDefinitionByName("flashx.textLayout.elements.TextFlow") == null || getDefinitionByName("fl.text.container.TLFContainerController") == null)
            {
               return null;
            }
         }
         catch(re:ReferenceError)
         {
            return null;
         }
         var drawSprite:TLFTextField = instance == null ? new TLFTextField() : TLFTextField(instance);
         this.configureInstance(drawSprite,ii);
         return drawSprite;
      }
   }
}
