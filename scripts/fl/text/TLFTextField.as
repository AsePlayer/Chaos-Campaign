package fl.text
{
   import fl.text.container.TLFContainerController;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.FontStyle;
   import flash.text.GridFitType;
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flash.text.engine.CFFHinting;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.TabAlignment;
   import flash.text.engine.TextLine;
   import flash.utils.getDefinitionByName;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.*;
   import flashx.textLayout.conversion.ConversionType;
   import flashx.textLayout.conversion.ITextImporter;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionFormat;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.IFormatResolver;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.CompositionCompleteEvent;
   import flashx.textLayout.events.FlowElementMouseEvent;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.events.TextLayoutEvent;
   import flashx.textLayout.events.UpdateCompleteEvent;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.VerticalAlign;
   import flashx.textLayout.formats.WhiteSpaceCollapse;
   import flashx.textLayout.operations.CutOperation;
   import flashx.textLayout.operations.DeleteTextOperation;
   import flashx.textLayout.operations.FlowOperation;
   import flashx.textLayout.operations.FlowTextOperation;
   import flashx.textLayout.operations.InsertTextOperation;
   import flashx.textLayout.operations.PasteOperation;
   import flashx.textLayout.operations.SplitParagraphOperation;
   import flashx.textLayout.tlf_internal;
   
   [Event(name="textInput",type="flash.events.TextEvent")]
   [Event(name="scroll",type="flash.events.Event")]
   [Event(name="link",type="flash.events.TextEvent")]
   [Event(name="change",type="flash.events.Event")]
   public class TLFTextField extends Sprite
   {
      
      tlf_internal static const INVALID_SELECTION:uint = 16;
      
      tlf_internal static const INVALID_BORDER:uint = 4;
      
      tlf_internal static const INVALID_TEXT:uint = 1;
      
      tlf_internal static var alwaysShowSelectionOnFormat:SelectionFormat = new SelectionFormat(14937852,1,"normal",0,0,"normal",0);
      
      tlf_internal static var _initialDefaultTextFormat:TextFormat = new TextFormat("Times New Roman",12,0,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,null);
      
      tlf_internal static const INVALID_NONE:uint = 0;
      
      tlf_internal static const INVALID_AUTO_SIZE:uint = 32;
      
      private static var noCondenseWhiteConfig:Configuration;
      
      tlf_internal static const INVALID_TYPE:uint = 64;
      
      tlf_internal static var focusedSelectionFormat:SelectionFormat = new SelectionFormat(12047870,1,"normal",0,1,"normal",500);
      
      tlf_internal static const INVALID_DIMENSIONS:uint = 2;
      
      tlf_internal static var inactiveSelectionFormat:SelectionFormat = new SelectionFormat(12047870,0,"normal",0,0,"normal",0);
      
      private static var condenseWhiteConfig:Configuration;
      
      protected static var useTCM:Boolean = true;
      
      protected static var textImporter:ITextImporter;
      
      protected static var htmlNoCondenseWhite:ITextImporter;
      
      protected static var noCondenseWhiteFormat:TextLayoutFormat;
      
      protected static var condenseWhiteFormat:TextLayoutFormat;
      
      tlf_internal static var alwaysShowSelectionOffFormat:SelectionFormat = new SelectionFormat(12047870,0,"normal",0,0,"normal",0);
      
      protected static var htmlCondenseWhite:ITextImporter;
      
      tlf_internal static var genericFonts:Array = ["_sans","_serif","_typewriter","_gothic","_gothicMono","_mincho","_ゴシック","_等幅","_明朝"];
      
      protected static var xmlNoCondenseWhite:ITextImporter;
      
      protected static var xmlCondenseWhite:ITextImporter;
      
      tlf_internal static const INVALID_WORD_WRAP:uint = 8;
      
      tlf_internal static const INVALID_ALL:uint = tlf_internal::INVALID_TEXT | tlf_internal::INVALID_DIMENSIONS | tlf_internal::INVALID_BORDER | tlf_internal::INVALID_WORD_WRAP | tlf_internal::INVALID_SELECTION | tlf_internal::INVALID_AUTO_SIZE | tlf_internal::INVALID_TYPE;
       
      
      private var _generationID:int;
      
      protected var _text:String;
      
      private var _type:String;
      
      private var _restrict:String;
      
      private var _defaultTextFormat:TextFormat;
      
      private var _mouseWheelEnabled:Boolean;
      
      private var _maxChars:int;
      
      private var _embedFonts:Boolean;
      
      protected var _containerManager:IContainerManager;
      
      private var _passwordCharacter:String;
      
      private var _maxScrollVFirstLineIndex:int;
      
      private var originalHeight:Number = 0;
      
      private var _maxScrollVFirstLineRect:Rectangle;
      
      protected var _invalidTextLayoutFormat:TextLayoutFormat;
      
      private var _antiAliasType:String;
      
      private var originalWidth:Number = 0;
      
      tlf_internal var _alwaysShowSelection:Boolean;
      
      private var _inlineInfo;
      
      private var _priorSelectionBeginIndex:int = 0;
      
      private var _backgroundAlpha:Number;
      
      private var _backgroundColor:uint;
      
      private var objInit:Boolean;
      
      private var _htmlTextGenerationID:int;
      
      private var _contentWidth:Number = 0;
      
      private var _bgShape2:Shape;
      
      protected var _invalidState:uint;
      
      private var _maxScrollV:int;
      
      private var _background:Boolean;
      
      protected var _displayAsPassword:Boolean;
      
      private var _borderAlpha:Number;
      
      private var _htmlText:String;
      
      private var _borderColor:uint;
      
      private var _contentHeight:Number = 0;
      
      private var _gridFitType:String;
      
      private var _tlfMarkupGenerationID:int;
      
      private var _maxScrollVCached:Boolean;
      
      private var _isPointText:Boolean;
      
      private var _paddingLock:Boolean;
      
      protected var _multiline:Boolean;
      
      private var _bgShape:Shape;
      
      private var _tlfMarkup:String;
      
      private var _borderWidth:Number;
      
      private var _border:Boolean;
      
      private var _condenseWhite:Boolean;
      
      private var _prevAutoSize:String;
      
      private var _useRichTextClipboard:Boolean;
      
      private var _maxScrollVLastLineRect:Rectangle;
      
      protected var _inRepaint:Boolean;
      
      private var _autoSize:String;
      
      protected var _wordWrap:Boolean;
      
      private var _priorSelectionEndIndex:int = 0;
      
      private var _selectable:Boolean;
      
      public function TLFTextField()
      {
         var tlfStage:Sprite;
         var container:DisplayObjectContainer = null;
         var rtMgr:Class = null;
         super();
         this._bgShape = new Shape();
         tlfStage = new Sprite();
         addChild(this._bgShape);
         addChild(tlfStage);
         tlfStage.tabEnabled = true;
         tlfStage.focusRect = false;
         this._containerManager = useTCM ? new SingleTextContainerManager(tlfStage,this) : new MultiTextContainerManager(tlfStage,this);
         doubleClickEnabled = true;
         tabEnabled = false;
         focusRect = false;
         this.tlf_internal::_alwaysShowSelection = false;
         this._antiAliasType = AntiAliasType.NORMAL;
         this._autoSize = TextFieldAutoSize.NONE;
         this._background = false;
         this._backgroundAlpha = 1;
         this._backgroundColor = 16777215;
         this._border = false;
         this._borderAlpha = 1;
         this._borderColor = 0;
         this._borderWidth = 1;
         this._condenseWhite = false;
         this._defaultTextFormat = tlf_internal::_initialDefaultTextFormat;
         this._containerManager.hostFormat = tlf_internal::createTextLayoutFormat(tlf_internal::_initialDefaultTextFormat);
         this._containerManager.antialiasType = AntiAliasType.NORMAL;
         this._containerManager.columnCount = FormatValue.AUTO;
         this._containerManager.columnWidth = FormatValue.AUTO;
         this._containerManager.columnGap = 20;
         this._containerManager.firstBaselineOffset = FormatValue.AUTO;
         this._containerManager.verticalAlign = VerticalAlign.TOP;
         this._displayAsPassword = false;
         this._embedFonts = false;
         this._gridFitType = GridFitType.PIXEL;
         this._maxChars = 0;
         this._mouseWheelEnabled = true;
         this._multiline = false;
         this._paddingLock = false;
         this._passwordCharacter = "*";
         this._restrict = null;
         this._text = "";
         this._htmlText = "";
         this._tlfMarkup = "";
         this._useRichTextClipboard = false;
         this._selectable = true;
         this._type = TextFieldType.DYNAMIC;
         this._wordWrap = false;
         this._containerManager.paddingLeft = 2;
         this._containerManager.paddingRight = 2;
         this._containerManager.paddingTop = 2;
         this._containerManager.paddingBottom = 2;
         this._generationID = -1;
         this._htmlTextGenerationID = -1;
         this._tlfMarkupGenerationID = -1;
         this._isPointText = false;
         this._containerManager.setCompositionSize(100,100);
         this.originalWidth = int.MAX_VALUE;
         this.originalHeight = int.MAX_VALUE;
         this.objInit = true;
         this._invalidState = tlf_internal::INVALID_ALL;
         try
         {
            if(this.parent != null)
            {
               container = parent as DisplayObjectContainer;
               if(container != null)
               {
                  rtMgr = Class(getDefinitionByName("fl.text.RuntimeManager"));
                  rtMgr["getSingleton"]().initInstance(this,container);
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      tlf_internal static function repeat(str:String, txtString:String) : String
      {
         var s:String = "";
         for(var i:int = 0; i < txtString.length; i++)
         {
            if(txtString.substr(i,1) == String.fromCharCode(10))
            {
               s += txtString.substr(i,1);
            }
            else
            {
               s += str;
            }
         }
         return s;
      }
      
      private static function testCharacter(charCode:uint, restrict:String) : Boolean
      {
         var code:uint = 0;
         var acceptCode:Boolean = false;
         var allowIt:Boolean = false;
         var inBackSlash:Boolean = false;
         var inRange:Boolean = false;
         var setFlag:Boolean = true;
         var lastCode:uint = 0;
         var n:int = restrict.length;
         if(n > 0)
         {
            code = restrict.charCodeAt(0);
            if(code == 94)
            {
               allowIt = true;
            }
         }
         for(var i:int = 0; i < n; i++)
         {
            code = restrict.charCodeAt(i);
            acceptCode = false;
            if(!inBackSlash)
            {
               if(code == 45)
               {
                  inRange = true;
               }
               else if(code == 94)
               {
                  setFlag = !setFlag;
               }
               else if(code == 92)
               {
                  inBackSlash = true;
               }
               else
               {
                  acceptCode = true;
               }
            }
            else
            {
               acceptCode = true;
               inBackSlash = false;
            }
            if(acceptCode)
            {
               if(inRange)
               {
                  if(lastCode <= charCode && charCode <= code)
                  {
                     allowIt = setFlag;
                  }
                  inRange = false;
                  lastCode = 0;
               }
               else
               {
                  if(charCode == code)
                  {
                     allowIt = setFlag;
                  }
                  lastCode = code;
               }
            }
         }
         return allowIt;
      }
      
      tlf_internal static function createTextLayoutFormat(format:TextFormat) : TextLayoutFormat
      {
         var arrTabStops:Array = null;
         var tabStop:String = null;
         var tabStopFmt:TabStopFormat = null;
         var txtLayoutFormat:TextLayoutFormat = new TextLayoutFormat();
         if(format.align != null)
         {
            if(format.align == TextFormatAlign.CENTER || format.align == TextFormatAlign.JUSTIFY || format.align == TextFormatAlign.LEFT || format.align == TextFormatAlign.RIGHT)
            {
               txtLayoutFormat.textAlign = format.align;
            }
            else
            {
               txtLayoutFormat.textAlign = TextFormatAlign.RIGHT;
            }
         }
         if(format.blockIndent != null && format.leftMargin != null)
         {
            txtLayoutFormat.paragraphStartIndent = format.blockIndent + format.leftMargin;
         }
         else if(format.blockIndent != null)
         {
            txtLayoutFormat.paragraphStartIndent = format.blockIndent;
         }
         else if(format.leftMargin != null)
         {
            txtLayoutFormat.paragraphStartIndent = format.leftMargin;
         }
         if(format.indent != null)
         {
            txtLayoutFormat.textIndent = format.indent;
         }
         if(format.leading != null)
         {
            txtLayoutFormat.lineHeight = format.leading;
            txtLayoutFormat.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
         }
         if(format.rightMargin != null)
         {
            txtLayoutFormat.paragraphEndIndent = format.rightMargin;
         }
         if(format.tabStops != null)
         {
            arrTabStops = new Array();
            format.tabStops.sort(Array.NUMERIC);
            for each(tabStop in format.tabStops)
            {
               tabStopFmt = new TabStopFormat();
               tabStopFmt.alignment = TabAlignment.START;
               tabStopFmt.position = int(tabStop);
               arrTabStops.push(tabStopFmt);
            }
            txtLayoutFormat.tabStops = arrTabStops;
         }
         if(format.bold != null)
         {
            txtLayoutFormat.fontWeight = Boolean(format.bold) ? FontWeight.BOLD : FontWeight.NORMAL;
         }
         if(format.color != null)
         {
            txtLayoutFormat.color = format.color;
         }
         if(format.font != null)
         {
            txtLayoutFormat.fontFamily = format.font;
         }
         if(format.italic != null)
         {
            txtLayoutFormat.fontStyle = Boolean(format.italic) ? FontPosture.ITALIC : FontPosture.NORMAL;
         }
         if(format.kerning != null)
         {
            txtLayoutFormat.kerning = Boolean(format.kerning) ? Kerning.ON : Kerning.OFF;
         }
         if(format.letterSpacing != null)
         {
            txtLayoutFormat.trackingRight = format.letterSpacing;
         }
         if(format.size != null)
         {
            txtLayoutFormat.fontSize = format.size;
         }
         if(format.underline != null)
         {
            txtLayoutFormat.textDecoration = Boolean(format.underline) ? TextDecoration.UNDERLINE : TextDecoration.NONE;
         }
         return txtLayoutFormat;
      }
      
      private static function restrictChar(str:String, restrictVal:String) : String
      {
         var charCode:uint = 0;
         if(restrictVal == null)
         {
            return str;
         }
         if(restrictVal == "")
         {
            return "";
         }
         var charCodes:Array = [];
         var n:int = str.length;
         for(var i:int = 0; i < n; i++)
         {
            charCode = str.charCodeAt(i);
            if(testCharacter(charCode,restrictVal))
            {
               charCodes.push(charCode);
            }
         }
         return String.fromCharCode.apply(null,charCodes);
      }
      
      private static function splice(str:String, start:int, end:int, strToInsert:String) : String
      {
         return str.substring(0,start) + strToInsert + str.substring(end,str.length);
      }
      
      tlf_internal function set contentHeight(n:Number) : void
      {
         this._contentHeight = n;
      }
      
      public function replaceText(beginIndex:int, endIndex:int, newText:String) : void
      {
         this._containerManager.replaceText(beginIndex,endIndex,newText);
      }
      
      public function get firstBaselineOffset() : Object
      {
         return this._containerManager.firstBaselineOffset;
      }
      
      tlf_internal function setCompositionSize(w:Number, h:Number) : void
      {
         this._containerManager.setCompositionSize(w,h);
      }
      
      tlf_internal function repaint(e:Event = null) : void
      {
         var wmode:String = null;
         var format:TextLayoutFormat = null;
         var tf:TextFlow = null;
         if(this._inRepaint)
         {
            return;
         }
         try
         {
            this._inRepaint = true;
            if(e != null)
            {
               if(e.type == Event.ADDED && e.target != this)
               {
                  this._inRepaint = false;
                  return;
               }
               removeEventListener(Event.ADDED,this.tlf_internal::repaint);
               removeEventListener(Event.ADDED_TO_STAGE,this.tlf_internal::repaint);
               removeEventListener(Event.FRAME_CONSTRUCTED,this.tlf_internal::repaint);
               try
               {
                  if(stage != null)
                  {
                     stage.removeEventListener(Event.RENDER,this.tlf_internal::repaint);
                  }
                  else if(e.type == Event.RENDER)
                  {
                     e.target.removeEventListener(Event.RENDER,this.tlf_internal::repaint);
                  }
               }
               catch(se:SecurityError)
               {
               }
            }
            if(this._invalidState == tlf_internal::INVALID_NONE)
            {
               return;
            }
            wmode = this.blockProgression as String;
            if(this.tlf_internal::TCMUsesTextStringAndFormat || Boolean(this._containerManager.textFlow))
            {
               if(Boolean(this._invalidState & (tlf_internal::INVALID_AUTO_SIZE | tlf_internal::INVALID_WORD_WRAP)))
               {
                  if(this._prevAutoSize != null && this.originalWidth != int.MAX_VALUE)
                  {
                     if(this._prevAutoSize != TextFieldAutoSize.NONE)
                     {
                        if(this._wordWrap)
                        {
                           if(wmode != BlockProgression.RL)
                           {
                              if(isNaN(this._containerManager.compositionWidth))
                              {
                                 this.originalWidth = this._containerManager.contentWidth;
                              }
                              else
                              {
                                 this.originalWidth = this._containerManager.compositionWidth;
                              }
                              this.originalHeight = this._containerManager.contentHeight;
                           }
                           else
                           {
                              this.originalWidth = this._containerManager.contentWidth;
                              if(isNaN(this._containerManager.compositionWidth))
                              {
                                 this.originalHeight = this._containerManager.contentHeight;
                              }
                              else
                              {
                                 this.originalHeight = this._containerManager.compositionHeight;
                              }
                           }
                        }
                        else
                        {
                           this.originalWidth = this._containerManager.contentWidth;
                           this.originalHeight = this._containerManager.contentHeight;
                        }
                     }
                     else
                     {
                        this.originalWidth = this._containerManager.compositionWidth;
                        this.originalHeight = this._containerManager.compositionHeight;
                     }
                  }
                  if(Boolean(this._invalidState & tlf_internal::INVALID_WORD_WRAP))
                  {
                     if(this._prevAutoSize == null)
                     {
                        if(this._autoSize != TextFieldAutoSize.NONE)
                        {
                           if(!this._wordWrap)
                           {
                              if(wmode != BlockProgression.RL)
                              {
                                 if(isNaN(this._containerManager.compositionWidth))
                                 {
                                    this.originalWidth = this._containerManager.contentWidth;
                                 }
                                 else
                                 {
                                    this.originalWidth = this._containerManager.compositionWidth;
                                 }
                                 this.originalHeight = this._containerManager.contentHeight;
                              }
                              else
                              {
                                 this.originalWidth = this._containerManager.contentWidth;
                                 if(isNaN(this._containerManager.compositionHeight))
                                 {
                                    this.originalHeight = this._containerManager.contentHeight;
                                 }
                                 else
                                 {
                                    this.originalHeight = this._containerManager.compositionHeight;
                                 }
                              }
                           }
                           else
                           {
                              this.originalWidth = this._containerManager.contentWidth;
                              this.originalHeight = this._containerManager.contentHeight;
                           }
                        }
                        else
                        {
                           this.originalWidth = this._containerManager.compositionWidth;
                           this.originalHeight = this._containerManager.compositionHeight;
                        }
                     }
                     this._containerManager.lineBreak = this._wordWrap ? LineBreak.TO_FIT : LineBreak.EXPLICIT;
                  }
                  else
                  {
                     this._wordWrap = this._containerManager.lineBreak == LineBreak.TO_FIT;
                  }
                  if(this.originalWidth == int.MAX_VALUE)
                  {
                     this.originalWidth = 0;
                     this.originalHeight = 0;
                  }
                  if(this._autoSize != TextFieldAutoSize.NONE)
                  {
                     if(this._wordWrap)
                     {
                        if(wmode != BlockProgression.RL)
                        {
                           if(isNaN(this._containerManager.compositionWidth))
                           {
                              this._containerManager.setCompositionSize(this._containerManager.contentWidth,NaN);
                           }
                           else
                           {
                              this._containerManager.setCompositionSize(this._containerManager.compositionWidth,NaN);
                           }
                        }
                        else if(isNaN(this._containerManager.compositionHeight))
                        {
                           this._containerManager.setCompositionSize(NaN,this._containerManager.contentHeight);
                        }
                        else
                        {
                           this._containerManager.setCompositionSize(NaN,this._containerManager.compositionHeight);
                        }
                     }
                     else
                     {
                        this._containerManager.setCompositionSize(NaN,NaN);
                     }
                  }
                  else if(this._invalidState & tlf_internal::INVALID_AUTO_SIZE && this._prevAutoSize != null && this._prevAutoSize != this._autoSize)
                  {
                     if(!this.objInit)
                     {
                        if(this._wordWrap)
                        {
                           if(wmode != BlockProgression.RL)
                           {
                              this._containerManager.setCompositionSize(this._containerManager.compositionWidth,this._containerManager.contentHeight);
                           }
                           else
                           {
                              this._containerManager.setCompositionSize(this._containerManager.contentWidth,this._containerManager.compositionHeight);
                           }
                        }
                        else
                        {
                           this._containerManager.setCompositionSize(this._containerManager.contentWidth,this._containerManager.contentHeight);
                        }
                     }
                  }
                  this.objInit = false;
                  this._prevAutoSize = null;
               }
               else
               {
                  this._wordWrap = this._containerManager.lineBreak == LineBreak.TO_FIT;
               }
               if(Boolean(this._invalidState & tlf_internal::INVALID_TEXT) && this._invalidTextLayoutFormat != null)
               {
                  format = this._invalidTextLayoutFormat;
                  this._invalidTextLayoutFormat = null;
                  tf = this.tlf_internal::TCMUsesTextStringAndFormat ? null : this.textFlow;
                  this._containerManager.setFormatForAllElements(tf,format);
               }
            }
            if(Boolean(this._invalidState & (tlf_internal::INVALID_TEXT | tlf_internal::INVALID_DIMENSIONS | tlf_internal::INVALID_WORD_WRAP | tlf_internal::INVALID_AUTO_SIZE)))
            {
               this._containerManager.update();
            }
            if(Boolean(this._invalidState & (tlf_internal::INVALID_TEXT | tlf_internal::INVALID_DIMENSIONS | tlf_internal::INVALID_BORDER | tlf_internal::INVALID_WORD_WRAP | tlf_internal::INVALID_AUTO_SIZE)))
            {
               this.drawBorder(wmode);
            }
            this._invalidState = tlf_internal::INVALID_NONE;
         }
         finally
         {
            this._inRepaint = false;
         }
      }
      
      tlf_internal function doImport(importType:String, value:String) : void
      {
         var cacheAutoSize:String;
         var cacheEmbedFonts:Boolean;
         var cacheSelectable:Boolean;
         var tf:TextFlow;
         var txtFormat:ITextLayoutFormat = null;
         var cacheAntiAliasType:String = null;
         var cacheEmbedFontsSet:Boolean = false;
         var cacheGridFitType:String = null;
         var resolver:IFormatResolver = null;
         var dataImporter:ITextImporter = null;
         var tmpTextFlow:TextFlow = null;
         var errMsg:String = null;
         var errorString:String = null;
         var i:int = 0;
         var cacheDefaultTextFormat:TextFormat = null;
         if(condenseWhiteConfig == null)
         {
            condenseWhiteConfig = new Configuration();
            condenseWhiteFormat = new TextLayoutFormat();
            condenseWhiteFormat.whiteSpaceCollapse = WhiteSpaceCollapse.COLLAPSE;
            condenseWhiteConfig.textFlowInitialFormat = condenseWhiteFormat;
            noCondenseWhiteConfig = new Configuration();
            noCondenseWhiteFormat = new TextLayoutFormat();
            noCondenseWhiteFormat.whiteSpaceCollapse = WhiteSpaceCollapse.PRESERVE;
            noCondenseWhiteConfig.textFlowInitialFormat = noCondenseWhiteFormat;
            htmlNoCondenseWhite = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT,noCondenseWhiteConfig);
            htmlCondenseWhite = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT,condenseWhiteConfig);
            xmlNoCondenseWhite = TextConverter.getImporter(TextConverter.TEXT_LAYOUT_FORMAT,noCondenseWhiteConfig);
            xmlCondenseWhite = TextConverter.getImporter(TextConverter.TEXT_LAYOUT_FORMAT,condenseWhiteConfig);
            textImporter = TextConverter.getImporter(TextConverter.PLAIN_TEXT_FORMAT);
         }
         cacheEmbedFonts = this._embedFonts;
         tf = this._containerManager.textFlow;
         if(Boolean(tf))
         {
            this.tlf_internal::removeTextFlowEventListeners();
            txtFormat = this._containerManager.hostFormat;
            cacheAntiAliasType = this.antiAliasType;
            cacheEmbedFonts = this.embedFonts;
            cacheEmbedFontsSet = true;
            cacheGridFitType = this.gridFitType;
            this._prevAutoSize = this._autoSize;
            resolver = tf.formatResolver;
         }
         if(importType == TextConverter.TEXT_FIELD_HTML_FORMAT)
         {
            if(this._condenseWhite)
            {
               dataImporter = htmlCondenseWhite;
            }
            else
            {
               dataImporter = htmlNoCondenseWhite;
            }
         }
         else if(importType == TextConverter.TEXT_LAYOUT_FORMAT)
         {
            if(this._condenseWhite)
            {
               dataImporter = xmlCondenseWhite;
            }
            else
            {
               dataImporter = xmlNoCondenseWhite;
            }
         }
         else if(importType == TextConverter.PLAIN_TEXT_FORMAT)
         {
            dataImporter = textImporter;
         }
         dataImporter.throwOnError = false;
         try
         {
            if(this.canUseTCMForTextFlow(tf) && importType == TextConverter.PLAIN_TEXT_FORMAT && value.search(/[\r\n]/g) == -1)
            {
               this._containerManager = this._containerManager.convert(SingleTextContainerManager);
               this._containerManager.text = value;
            }
            else
            {
               tmpTextFlow = dataImporter.importToFlow(value);
            }
            if(Boolean(dataImporter.errors))
            {
               for each(errorString in dataImporter.errors)
               {
                  errMsg += "Error: " + errorString + "\n";
               }
            }
            if(Boolean(tmpTextFlow))
            {
               tmpTextFlow.flowComposer.removeAllControllers();
               for(i = 0; i < tf.flowComposer.numControllers; i++)
               {
                  tmpTextFlow.flowComposer.addController(tf.flowComposer.getControllerAt(i));
               }
               this.textFlow = tmpTextFlow;
            }
         }
         catch(e:Error)
         {
            dataImporter = textImporter;
            textFlow = dataImporter.importToFlow("");
         }
         if(Boolean(resolver))
         {
            this.textFlow.formatResolver = resolver;
         }
         if(Boolean(txtFormat))
         {
            this._containerManager.hostFormat = txtFormat;
         }
         else
         {
            cacheDefaultTextFormat = this._defaultTextFormat;
            this.defaultTextFormat = null;
            this.defaultTextFormat = cacheDefaultTextFormat;
         }
         this.tlf_internal::addTextFlowEventListeners();
         if(cacheAntiAliasType != null)
         {
            this.antiAliasType = cacheAntiAliasType;
         }
         else
         {
            this.antiAliasType = this._antiAliasType;
         }
         this.embedFonts = cacheEmbedFonts;
         if(cacheGridFitType != null)
         {
            this.gridFitType = cacheGridFitType;
         }
         else
         {
            this.gridFitType = this._gridFitType;
         }
         this.wordWrap = this._wordWrap;
         cacheAutoSize = this._autoSize;
         this._autoSize = "NA";
         this.autoSize = cacheAutoSize;
         cacheSelectable = this._selectable;
         this._selectable = !this._selectable;
         this.selectable = cacheSelectable;
         this.tlf_internal::invalidate(tlf_internal::INVALID_ALL);
         this.scrollV = 0;
      }
      
      public function get columnWidth() : Object
      {
         return this._containerManager.columnWidth;
      }
      
      public function set firstBaselineOffset(value:Object) : void
      {
         var n:Number = NaN;
         try
         {
            this._containerManager.firstBaselineOffset = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.firstBaselineOffset = "auto";
            }
            else if(n < 0)
            {
               _containerManager.firstBaselineOffset = 0;
            }
            else if(n > 1000)
            {
               _containerManager.firstBaselineOffset = 1000;
            }
            else
            {
               _containerManager.firstBaselineOffset = "auto";
            }
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function set columnWidth(value:Object) : void
      {
         var n:Number = NaN;
         if(this._containerManager.columnWidth == value)
         {
            return;
         }
         try
         {
            this._containerManager.columnWidth = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(n < 0 || isNaN(n))
            {
               _containerManager.columnWidth = 0;
            }
            else if(n > 8000)
            {
               _containerManager.columnWidth = 8000;
            }
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      tlf_internal function getEditingMode(manager:ISelectionManager) : String
      {
         return Boolean(manager) ? String(manager.editingMode) : EditingMode.READ_ONLY;
      }
      
      tlf_internal function get firstField() : TLFTextField
      {
         var firstController:TLFContainerController = null;
         var tf:TextFlow = this.tlf_internal::TCMUsesTextStringAndFormat ? null : this._containerManager.textFlow;
         if(Boolean(tf))
         {
            if(tf.flowComposer == null || tf.flowComposer.numControllers == 0)
            {
               return this;
            }
            firstController = tf.flowComposer.getControllerAt(0) as TLFContainerController;
            if(Boolean(firstController))
            {
               return firstController.ownerField;
            }
            if(Boolean(tf.flowComposer.getControllerAt(0)))
            {
               return this;
            }
         }
         return null;
      }
      
      tlf_internal function addNextField(theNextTextField:TLFTextField) : void
      {
         this._containerManager = this._containerManager.convert(MultiTextContainerManager);
         theNextTextField._containerManager = theNextTextField._containerManager.convert(MultiTextContainerManager);
         var flowComp:IFlowComposer = this.textFlow.flowComposer;
         if(flowComp.getControllerIndex(this.controller) < 0)
         {
            flowComp.addControllerAt(this.controller,0);
         }
         if(flowComp.getControllerIndex(theNextTextField.controller) < 0)
         {
            flowComp.addControllerAt(theNextTextField.controller,flowComp.getControllerIndex(this.controller) + 1);
         }
         theNextTextField.textFlow = this.textFlow;
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
         theNextTextField.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function get styleSheet() : StyleSheet
      {
         var resolver:CSSFormatResolver = null;
         if(!this.tlf_internal::TCMUsesTextStringAndFormat && Boolean(this.textFlow))
         {
            resolver = this.textFlow.formatResolver as CSSFormatResolver;
            if(Boolean(resolver))
            {
               return resolver.styleSheet;
            }
         }
         return null;
      }
      
      public function getFirstCharInParagraph(charIndex:int) : int
      {
         var txtFlowLine:TextFlowLine = this.textFlow.flowComposer.findLineAtPosition(charIndex);
         if(Boolean(txtFlowLine))
         {
            return txtFlowLine.paragraph.getAbsoluteStart();
         }
         throw new RangeError("The character index specified is out of range.");
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set scrollH(value:int) : void
      {
         var blockProg:String = this.tlf_internal::TCMUsesTextStringAndFormat ? String(this.tlf_internal::hostFormat.blockProgression) : String(this.textFlow.computedFormat.blockProgression);
         var direction:String = this.tlf_internal::TCMUsesTextStringAndFormat ? String(this.tlf_internal::hostFormat.direction) : String(this.textFlow.computedFormat.direction);
         if(value < 0)
         {
            value = 0;
         }
         if(value > this.maxScrollH)
         {
            value = this.maxScrollH;
         }
         if(direction == Direction.RTL)
         {
            value = -value;
         }
         if(blockProg == BlockProgression.RL)
         {
            this._containerManager.verticalScrollPosition = value;
         }
         else
         {
            this._containerManager.horizontalScrollPosition = value;
         }
      }
      
      public function get textColor() : uint
      {
         return this._containerManager.textColor;
      }
      
      public function isFontCompatible(fontName:String, fontStyle:String) : Boolean
      {
         var fntWeight:String = null;
         var fntPosture:String = null;
         if(fontStyle == FontStyle.REGULAR)
         {
            fntWeight = FontWeight.NORMAL;
            fntPosture = FontPosture.NORMAL;
         }
         else if(fontStyle == FontStyle.BOLD)
         {
            fntWeight = FontWeight.BOLD;
            fntPosture = FontPosture.NORMAL;
         }
         else if(fontStyle == FontStyle.ITALIC)
         {
            fntWeight = FontWeight.NORMAL;
            fntPosture = FontPosture.ITALIC;
         }
         else
         {
            if(fontStyle != FontStyle.BOLD_ITALIC)
            {
               throw new ArgumentError("The fontStyle specified is not a member of flash.text.FontStyle.");
            }
            fntWeight = FontWeight.BOLD;
            fntPosture = FontPosture.ITALIC;
         }
         return FontDescription.isFontCompatible(fontName,fntWeight,fntPosture);
      }
      
      override public function set height(value:Number) : void
      {
         if(value != this._containerManager.compositionHeight)
         {
            this._containerManager.setCompositionSize(this._containerManager.compositionWidth,value);
            this.tlf_internal::invalidate(tlf_internal::INVALID_DIMENSIONS);
         }
      }
      
      public function get autoSize() : String
      {
         return this._autoSize;
      }
      
      public function get selectionBeginIndex() : int
      {
         if(Boolean(this.textFlow.interactionManager))
         {
            return this.textFlow.interactionManager.absoluteStart < 0 ? 0 : int(this.textFlow.interactionManager.absoluteStart);
         }
         return this._priorSelectionBeginIndex;
      }
      
      public function get selectable() : Boolean
      {
         var master:TLFTextField = this.tlf_internal::firstField;
         return Boolean(master) ? master._selectable : this._selectable;
      }
      
      public function set scrollV(value:int) : void
      {
         var tf:TextFlow = this._containerManager.textFlow;
         if(tf == null)
         {
            return;
         }
         if(this._maxScrollVCached && this._maxScrollV == 0)
         {
            return;
         }
         this.tlf_internal::repaint();
         if(this._containerManager.container.scrollRect == null)
         {
            return;
         }
         if(!this._maxScrollVCached)
         {
            this.maxScrollV;
            if(!this._maxScrollVCached || this._maxScrollV == 0)
            {
               return;
            }
         }
         if(value < 0)
         {
            value = 0;
         }
         else if(value > this._maxScrollV)
         {
            value = this._maxScrollV;
         }
         if(value == 0)
         {
            if(tf.blockProgression == BlockProgression.RL)
            {
               this._containerManager.horizontalScrollPosition = Math.max(0,this._maxScrollVFirstLineRect.right);
            }
            else
            {
               this._containerManager.verticalScrollPosition = Math.min(0,this._maxScrollVFirstLineRect.top);
            }
            return;
         }
         if(value == this._maxScrollV)
         {
            if(tf.blockProgression == BlockProgression.RL)
            {
               this._containerManager.horizontalScrollPosition = Math.min(this._containerManager.contentLeft,this._maxScrollVLastLineRect.left);
            }
            else
            {
               this._containerManager.verticalScrollPosition = Math.max(this._containerManager.contentHeight,this._maxScrollVLastLineRect.bottom);
            }
            return;
         }
         var topRect:Rectangle = this._containerManager.getLineIndexBounds(value + this._maxScrollVFirstLineIndex - 1);
         if(tf.blockProgression == BlockProgression.RL)
         {
            if(Math.abs(this._containerManager.contentLeft - topRect.right) < this._containerManager.compositionWidth)
            {
               this._containerManager.horizontalScrollPosition = Math.max(this._containerManager.contentLeft,this._maxScrollVLastLineRect.left);
            }
            else
            {
               this._containerManager.horizontalScrollPosition = topRect.right;
            }
         }
         else if(this._containerManager.contentHeight - topRect.top < this._containerManager.compositionHeight)
         {
            this._containerManager.verticalScrollPosition = Math.max(this._containerManager.contentHeight,this._maxScrollVLastLineRect.bottom);
         }
         else
         {
            this._containerManager.verticalScrollPosition = topRect.top;
         }
      }
      
      public function get pixelMaxScrollV() : int
      {
         var blockProg:String = this.tlf_internal::TCMUsesTextStringAndFormat ? String(this.tlf_internal::hostFormat.blockProgression) : String(this.textFlow.computedFormat.blockProgression);
         var maxScroll:int = blockProg == BlockProgression.RL ? int(this._containerManager.contentWidth - this._containerManager.compositionWidth) : int(this._containerManager.contentHeight - this._containerManager.compositionHeight);
         return maxScroll > 0 ? maxScroll : 0;
      }
      
      public function set verticalAlign(value:String) : void
      {
         this._containerManager.verticalAlign = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      tlf_internal function textFlow_ScrollHandler(event:TextLayoutEvent) : void
      {
         this.tlf_internal::invalidate(TLFTextField.tlf_internal::INVALID_BORDER);
         this.tlf_internal::repaint();
         dispatchEvent(new Event(Event.SCROLL,false,false));
      }
      
      public function set text(value:String) : void
      {
         if(value == null)
         {
            value = "";
         }
         this._text = value;
         this._containerManager.text = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_ALL);
         this.scrollH = 0;
         this.pixelScrollV = 0;
      }
      
      public function set background(value:Boolean) : void
      {
         if(this._background == value)
         {
            return;
         }
         this._background = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_BORDER);
      }
      
      public function set border(value:Boolean) : void
      {
         if(this._border == value)
         {
            return;
         }
         this._border = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_BORDER);
      }
      
      public function get antiAliasType() : String
      {
         return this._containerManager.antialiasType;
      }
      
      public function get selectionEndIndex() : int
      {
         if(Boolean(this.textFlow.interactionManager))
         {
            return this.textFlow.interactionManager.absoluteEnd < 0 ? 0 : int(this.textFlow.interactionManager.absoluteEnd);
         }
         return this._priorSelectionEndIndex;
      }
      
      public function set styleSheet(value:StyleSheet) : void
      {
         var resolver:IFormatResolver = value != null ? new CSSFormatResolver(value) : null;
         if(Boolean(this.textFlow))
         {
            this.textFlow.formatResolver = resolver;
            this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
         }
      }
      
      public function set textColor(value:uint) : void
      {
         value &= 16777215;
         var textFormat:TextFormat = this.defaultTextFormat;
         textFormat.color = value;
         this.defaultTextFormat = textFormat;
         this._containerManager.textColor = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      tlf_internal function set generationID(value:int) : void
      {
         this._generationID = value;
      }
      
      tlf_internal function get usesTCM() : Boolean
      {
         return this._containerManager is SingleTextContainerManager;
      }
      
      tlf_internal function textFlow_flowOperationEndHandler(event:FlowOperationEvent) : void
      {
         var op:FlowOperation = event.operation;
         if(op is PasteOperation)
         {
            this.handlePasteOperation(PasteOperation(op));
         }
         dispatchEvent(new Event(Event.CHANGE,false,false));
      }
      
      public function set type(value:String) : void
      {
         if(value != TextFieldType.INPUT && value != TextFieldType.DYNAMIC)
         {
            throw new ArgumentError("The type specified is not a member of flash.text.TextFieldType.");
         }
         var master:TLFTextField = this.tlf_internal::firstField;
         if(!master)
         {
            master = this;
         }
         master._type = value;
         this.doTypeSet(master);
      }
      
      tlf_internal function get minScrollV() : int
      {
         var tf:TextFlow = this._containerManager.textFlow;
         if(tf == null)
         {
            return 0;
         }
         if(!this._maxScrollVCached)
         {
            this.maxScrollV;
            if(!this._maxScrollVCached)
            {
               return 0;
            }
         }
         if(tf.blockProgression == BlockProgression.RL)
         {
            return this._maxScrollVFirstLineRect.right >= 0 ? 1 : 0;
         }
         return this._maxScrollVFirstLineRect.top <= 0 ? 1 : 0;
      }
      
      public function get wordWrap() : Boolean
      {
         if(Boolean(this._invalidState & tlf_internal::INVALID_WORD_WRAP))
         {
            return this._wordWrap;
         }
         return this._containerManager.lineBreak == LineBreak.TO_FIT;
      }
      
      public function getLineIndexOfChar(charIndex:int) : int
      {
         var txtFlowLine:TextFlowLine = this.textFlow.flowComposer.findLineAtPosition(charIndex);
         if(Boolean(txtFlowLine))
         {
            return this.textFlow.flowComposer.findLineIndexAtPosition(charIndex);
         }
         throw new RangeError("Character index out of range.");
      }
      
      public function get bottomScrollV() : int
      {
         var curLine:TextFlowLine = null;
         var curRect:Rectangle = null;
         this.tlf_internal::repaint();
         var flowComp:IFlowComposer = this.textFlow.flowComposer;
         var firstLine:int = int(flowComp.findLineIndexAtPosition(this._containerManager.absoluteStart));
         var lastLine:int = this.numLines - 1;
         if(lastLine < 1)
         {
            return 1;
         }
         var tf:TextFlow = this._containerManager.textFlow;
         if(tf.blockProgression == BlockProgression.RL)
         {
            if(this._containerManager.compositionWidth > this._containerManager.contentWidth)
            {
               return lastLine + 1;
            }
         }
         else if(this._containerManager.compositionHeight > this._containerManager.contentHeight)
         {
            return lastLine + 1;
         }
         var lastVisibleLine:int = 1;
         for(var lineIndex:int = lastLine; lineIndex >= firstLine; lineIndex--)
         {
            curLine = flowComp.getLineAt(lineIndex);
            curRect = curLine.getBounds();
            if(curLine.textLineExists && Boolean(curLine.getTextLine().parent))
            {
               if(this._containerManager.textFlow.computedFormat.blockProgression == BlockProgression.RL)
               {
                  if(int(curLine.x) >= this._containerManager.container.scrollRect.x)
                  {
                     lastVisibleLine = lineIndex + 1;
                     break;
                  }
               }
               else if(int(curRect.bottom) <= this._containerManager.container.scrollRect.bottom)
               {
                  lastVisibleLine = lineIndex + 1;
                  break;
               }
            }
         }
         return lastVisibleLine;
      }
      
      public function set alwaysShowSelection(value:Boolean) : void
      {
         var newSelectionFormat:SelectionFormat = null;
         if(this.alwaysShowSelection == value || this.selectable == false)
         {
            return;
         }
         var master:TLFTextField = this.tlf_internal::firstField;
         if(!master)
         {
            master = this;
         }
         master.tlf_internal::_alwaysShowSelection = value;
         var interactionMgr:ISelectionManager = master.textFlow.interactionManager;
         if(interactionMgr != null)
         {
            if(interactionMgr.focusedSelectionFormat != tlf_internal::focusedSelectionFormat)
            {
               interactionMgr.focusedSelectionFormat = tlf_internal::focusedSelectionFormat;
            }
            if(interactionMgr.inactiveSelectionFormat != tlf_internal::inactiveSelectionFormat)
            {
               interactionMgr.inactiveSelectionFormat = tlf_internal::inactiveSelectionFormat;
            }
            newSelectionFormat = this.alwaysShowSelection ? tlf_internal::alwaysShowSelectionOnFormat : tlf_internal::alwaysShowSelectionOffFormat;
            if(interactionMgr.unfocusedSelectionFormat != newSelectionFormat)
            {
               interactionMgr.unfocusedSelectionFormat = newSelectionFormat;
            }
         }
      }
      
      public function set sharpness(value:Number) : void
      {
      }
      
      tlf_internal function get prevField() : TLFTextField
      {
         var index:int = 0;
         var prevController:TLFContainerController = null;
         if(Boolean(this.textFlow) && Boolean(this.textFlow.flowComposer))
         {
            index = int(this.textFlow.flowComposer.getControllerIndex(this.controller));
            if(index > 0)
            {
               prevController = this.textFlow.flowComposer.getControllerAt(index - 1) as TLFContainerController;
               if(Boolean(prevController))
               {
                  return prevController.ownerField;
               }
            }
         }
         return null;
      }
      
      private function handlePasteOperation(op:PasteOperation) : void
      {
         if(!this._restrict && !this._maxChars && !this._displayAsPassword)
         {
            return;
         }
         var pastedText:String = TextConverter.export(op.textScrap.textFlow,TextConverter.PLAIN_TEXT_FORMAT,ConversionType.STRING_TYPE) as String;
         if(this._displayAsPassword)
         {
            this._text = splice(this._text,op.absoluteStart,op.absoluteStart,pastedText);
         }
         var editManager:EditManager = EditManager(this.textFlow.interactionManager);
         var selectionState:SelectionState = new SelectionState(op.textFlow,op.absoluteStart,op.absoluteStart + pastedText.length);
         editManager.deleteText(selectionState);
         this.replaceText(op.absoluteStart,op.absoluteStart + 1,pastedText);
      }
      
      public function get paddingRight() : Object
      {
         return this._containerManager.paddingRight;
      }
      
      protected function drawBorder(wmode:String) : void
      {
         var borderOrigin:Number = NaN;
         var theGraphics:Graphics = this._bgShape.graphics;
         theGraphics.clear();
         var borderRect:Rectangle = null;
         if(this._border && this._borderWidth > 0)
         {
            borderOrigin = this._borderWidth / 2 - this._borderWidth;
            if(this._background)
            {
               theGraphics.beginFill(this._backgroundColor,this._backgroundAlpha);
            }
            theGraphics.lineStyle(this._borderWidth,this._borderColor,this._borderAlpha,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,10);
            if(this.tlf_internal::isPointText || this._autoSize != TextFieldAutoSize.NONE)
            {
               if(this._wordWrap)
               {
                  if(wmode != BlockProgression.RL)
                  {
                     if(!isNaN(this._containerManager.compositionWidth))
                     {
                        borderRect = new Rectangle(borderOrigin,borderOrigin,this._containerManager.compositionWidth + this.borderWidth,this._containerManager.contentHeight + this.borderWidth);
                     }
                  }
                  else if(!isNaN(this._containerManager.compositionHeight))
                  {
                     borderRect = new Rectangle(borderOrigin,borderOrigin,this._containerManager.contentWidth + this.borderWidth,this._containerManager.compositionHeight + this.borderWidth);
                  }
               }
               else
               {
                  borderRect = new Rectangle(borderOrigin,borderOrigin,this._containerManager.contentWidth + this.borderWidth,this._containerManager.contentHeight + this.borderWidth);
               }
            }
            else if(!isNaN(this._containerManager.compositionWidth) && !isNaN(this._containerManager.compositionHeight))
            {
               borderRect = new Rectangle(borderOrigin,borderOrigin,this._containerManager.compositionWidth + this.borderWidth,this._containerManager.compositionHeight + this.borderWidth);
            }
            if(borderRect != null)
            {
               theGraphics.drawRect(borderRect.x,borderRect.y,borderRect.width,borderRect.height);
            }
            if(this._background)
            {
               theGraphics.endFill();
               if(this._bgShape2 != null)
               {
                  removeChild(this._bgShape2);
                  this._bgShape2 = null;
               }
            }
            else
            {
               if(this._bgShape2 == null)
               {
                  this._bgShape2 = new Shape();
                  this._bgShape2.visible = false;
                  addChildAt(this._bgShape2,0);
               }
               theGraphics = this._bgShape2.graphics;
               theGraphics.clear();
               theGraphics.beginFill(0);
               if(borderRect != null)
               {
                  theGraphics.drawRect(borderRect.x,borderRect.y,borderRect.width,borderRect.height);
               }
               else
               {
                  theGraphics.drawRect(this._bgShape.x,this._bgShape.y,this._bgShape.width,this._bgShape.height);
               }
               theGraphics.endFill();
            }
            this._bgShape.visible = true;
         }
         else
         {
            if(this._bgShape2 != null)
            {
               removeChild(this._bgShape2);
               this._bgShape2 = null;
            }
            theGraphics.beginFill(this._backgroundColor,this._backgroundAlpha);
            if(this.tlf_internal::isPointText || this._autoSize != TextFieldAutoSize.NONE)
            {
               theGraphics.drawRect(0,0,this._containerManager.contentWidth,this._containerManager.contentHeight);
            }
            else if(!isNaN(this._containerManager.compositionWidth) && !isNaN(this._containerManager.compositionHeight))
            {
               theGraphics.drawRect(0,0,this._containerManager.compositionWidth,this._containerManager.compositionHeight);
            }
            theGraphics.endFill();
            this._bgShape.visible = this._background;
         }
      }
      
      public function get borderAlpha() : Number
      {
         return this._borderAlpha;
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set condenseWhite(value:Boolean) : void
      {
         this._condenseWhite = value;
      }
      
      public function get textWidth() : Number
      {
         this.tlf_internal::repaint();
         this._containerManager.compose();
         var leftPadding:Number = isNaN(Number(this.paddingLeft)) ? 0 : Number(this.paddingLeft);
         var rightPadding:Number = isNaN(Number(this.paddingRight)) ? 0 : Number(this.paddingRight);
         return this._containerManager.contentWidth - (leftPadding + rightPadding);
      }
      
      public function set autoSize(value:String) : void
      {
         if(this._autoSize == value)
         {
            return;
         }
         if(value != TextFieldAutoSize.NONE && value != TextFieldAutoSize.LEFT && value != TextFieldAutoSize.RIGHT && value != TextFieldAutoSize.CENTER)
         {
            throw new ArgumentError("The autoSize specified is not a member of flash.text.TextFieldAutoSize.");
         }
         if(this._prevAutoSize == null)
         {
            this._prevAutoSize = this._autoSize;
         }
         this._autoSize = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_AUTO_SIZE);
      }
      
      public function get useRichTextClipboard() : Boolean
      {
         return this._useRichTextClipboard;
      }
      
      public function get embedFonts() : Boolean
      {
         return this._containerManager.embedFonts;
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set columnCount(value:Object) : void
      {
         var n:Number = NaN;
         if(this._containerManager.columnCount == value)
         {
            return;
         }
         try
         {
            this._containerManager.columnCount = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(n < 1 || isNaN(n))
            {
               _containerManager.columnCount = 1;
            }
            else if(n > 50)
            {
               _containerManager.columnCount = 50;
            }
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function set selectable(value:Boolean) : void
      {
         if(this.selectable == value)
         {
            return;
         }
         var master:TLFTextField = this.tlf_internal::firstField;
         if(!master)
         {
            master = this;
         }
         master._selectable = value;
         this.doTypeSet(master);
      }
      
      public function get defaultTextFormat() : TextFormat
      {
         if(this._defaultTextFormat == tlf_internal::_initialDefaultTextFormat)
         {
            this._defaultTextFormat = this.duplicateTextFormat(this._defaultTextFormat);
         }
         return this._defaultTextFormat;
      }
      
      public function set displayAsPassword(value:Boolean) : void
      {
         if(this._displayAsPassword == value)
         {
            return;
         }
         if(value)
         {
            this._text = this.text;
         }
         this._displayAsPassword = value;
         this.replaceText(0,this._containerManager.textLength,this._text);
      }
      
      public function getLineText(lineIndex:int) : String
      {
         if(lineIndex < 0 || lineIndex >= this.numLines)
         {
            throw new RangeError("The line number specified is out of range.");
         }
         var txtFlowLine:TextFlowLine = this.getValidTextFlowLine(lineIndex);
         var offsetIntoTextBlock:int = txtFlowLine.absoluteStart - txtFlowLine.paragraph.getAbsoluteStart();
         return txtFlowLine.paragraph.getText().substr(offsetIntoTextBlock,txtFlowLine.textLength);
      }
      
      public function get mouseWheelEnabled() : Boolean
      {
         return this._mouseWheelEnabled;
      }
      
      public function get textHeight() : Number
      {
         this.tlf_internal::repaint();
         this._containerManager.compose();
         var topPadding:Number = isNaN(Number(this.paddingTop)) ? 0 : Number(this.paddingTop);
         var botPadding:Number = isNaN(Number(this.paddingBottom)) ? 0 : Number(this.paddingBottom);
         return this._containerManager.contentHeight - (topPadding + botPadding);
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function get tlfMarkup() : String
      {
         if(this.textFlow.generation != this._tlfMarkupGenerationID || this._tlfMarkup == "")
         {
            this._tlfMarkup = TextConverter.export(this.textFlow,TextConverter.TEXT_LAYOUT_FORMAT,ConversionType.STRING_TYPE) as String;
            this._tlfMarkupGenerationID = this.textFlow.generation;
         }
         return this._tlfMarkup;
      }
      
      private function canUseTCMForTextFlow(theFlow:TextFlow) : Boolean
      {
         return useTCM && this.hasSingleContainer(theFlow);
      }
      
      public function get gridFitType() : String
      {
         if(!this.tlf_internal::TCMUsesTextStringAndFormat && this.textFlow.cffHinting == CFFHinting.NONE || this.tlf_internal::TCMUsesTextStringAndFormat && this.tlf_internal::hostFormat && this.tlf_internal::hostFormat.cffHinting == CFFHinting.NONE)
         {
            this._gridFitType = GridFitType.NONE;
         }
         else if(this._gridFitType != GridFitType.SUBPIXEL)
         {
            this._gridFitType = GridFitType.PIXEL;
         }
         return this._gridFitType;
      }
      
      private function getValidTextFlowLineFromCharIndex(charIndex:int) : TextFlowLine
      {
         if(charIndex >= 0 && charIndex < this._containerManager.textLength)
         {
            return this.textFlow.flowComposer.findLineAtPosition(charIndex);
         }
         throw new RangeError("The character index specified is out of range.");
      }
      
      tlf_internal function get passwordCharacter() : String
      {
         return this._passwordCharacter;
      }
      
      tlf_internal function get contentWidth() : Number
      {
         return this._contentWidth;
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function get maxChars() : int
      {
         var master:TLFTextField = this.tlf_internal::firstField;
         if(!master)
         {
            master = this;
         }
         return Boolean(master) ? master._maxChars : 0;
      }
      
      tlf_internal function get isPointText() : Boolean
      {
         return this._isPointText && (this.tlf_internal::TCMUsesTextStringAndFormat || this.textFlow != null);
      }
      
      tlf_internal function initController(container:Sprite) : TLFContainerController
      {
         this._containerManager.addListeners();
         return new TLFContainerController(container,this);
      }
      
      tlf_internal function get paddingLock() : Boolean
      {
         return this._paddingLock;
      }
      
      public function set antiAliasType(value:String) : void
      {
         if(this.antiAliasType == value)
         {
            return;
         }
         if(this._invalidTextLayoutFormat == null)
         {
            this._invalidTextLayoutFormat = new TextLayoutFormat();
         }
         this._invalidTextLayoutFormat.renderingMode = FormatValue.INHERIT;
         this._containerManager.antialiasType = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function get length() : int
      {
         return this.text.length;
      }
      
      tlf_internal function get inlineInfo() : *
      {
         return this._inlineInfo;
      }
      
      public function get backgroundAlpha() : Number
      {
         return this._backgroundAlpha;
      }
      
      tlf_internal function composeComplete(event:CompositionCompleteEvent) : void
      {
         var increaseX:Number = NaN;
         var increaseY:Number = NaN;
         if(event && !this.tlf_internal::TCMUsesTextStringAndFormat && event.target as TextFlow != this.textFlow)
         {
            return;
         }
         this._maxScrollVCached = false;
         if(this.originalWidth == int.MAX_VALUE || this.originalHeight == int.MAX_VALUE)
         {
            this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
            this.tlf_internal::repaint();
         }
         var wmode:String = this.tlf_internal::TCMUsesTextStringAndFormat ? String(this.tlf_internal::hostFormat.blockProgression) : String(this.textFlow.computedFormat.blockProgression);
         if(this._autoSize != TextFieldAutoSize.NONE)
         {
            increaseX = 0;
            increaseY = 0;
            if(wmode != BlockProgression.RL)
            {
               if(!this._wordWrap)
               {
                  if(this._autoSize == TextFieldAutoSize.RIGHT)
                  {
                     increaseX = this.originalWidth - this._containerManager.contentWidth;
                  }
                  else if(this._autoSize == TextFieldAutoSize.CENTER)
                  {
                     increaseX = (this.originalWidth - this._containerManager.contentWidth) / 2;
                  }
               }
            }
            else
            {
               increaseX = this.tlf_internal::contentWidth - this.tlf_internal::contentWidth;
               if(!this._wordWrap)
               {
                  if(this._autoSize == TextFieldAutoSize.RIGHT)
                  {
                     increaseY = this.originalHeight - this._containerManager.contentHeight;
                  }
                  else if(this._autoSize == TextFieldAutoSize.CENTER)
                  {
                     increaseY = (this.originalHeight - this._containerManager.contentHeight) / 2;
                  }
               }
            }
            if(increaseX != 0)
            {
               this.x += increaseX;
            }
            if(increaseY != 0)
            {
               this.y += increaseY;
            }
            this.tlf_internal::contentWidth = this.tlf_internal::contentWidth;
            this.tlf_internal::contentHeight = this.tlf_internal::contentHeight;
         }
         this.originalWidth = this._containerManager.contentWidth;
         this.originalHeight = this._containerManager.contentHeight;
         if(this.tlf_internal::isPointText || this._autoSize != TextFieldAutoSize.NONE)
         {
            this.drawBorder(wmode);
         }
      }
      
      private function duplicateTextFormat(inFormat:TextFormat) : TextFormat
      {
         var prop:String = null;
         var retVal:TextFormat = new TextFormat();
         for(prop in inFormat)
         {
            retVal[prop] = inFormat[prop];
         }
         return retVal;
      }
      
      public function set htmlText(value:String) : void
      {
         var leaf:FlowLeafElement = null;
         if(value == "")
         {
            this.text = "";
            this.tlf_internal::hostFormat = tlf_internal::createTextLayoutFormat(tlf_internal::_initialDefaultTextFormat);
            return;
         }
         var tf:TextFlow = this._containerManager.textFlow;
         if(this.styleSheet == null)
         {
            leaf = tf.getFirstLeaf();
            if(Boolean(leaf))
            {
               tf.hostFormat = leaf.computedFormat;
            }
         }
         this.tlf_internal::doImport(TextConverter.TEXT_FIELD_HTML_FORMAT,value);
         this._htmlText = this.htmlText;
      }
      
      public function set thickness(value:Number) : void
      {
      }
      
      public function getLineMetrics(lineIndex:int) : TextLineMetrics
      {
         var textFlowLineHeight:Number = NaN;
         if(lineIndex < 0 || lineIndex >= this.numLines)
         {
            throw new RangeError("The line number specified is out of range.");
         }
         var txtFlowLine:TextFlowLine = this.getValidTextFlowLine(lineIndex);
         if(Boolean(txtFlowLine))
         {
            textFlowLineHeight = txtFlowLine.height;
            if(textFlowLineHeight < txtFlowLine.ascent + txtFlowLine.descent)
            {
               textFlowLineHeight = txtFlowLine.ascent + txtFlowLine.descent;
            }
            if(lineIndex == 0)
            {
               return new TextLineMetrics(txtFlowLine.x,txtFlowLine.unjustifiedTextWidth,textFlowLineHeight,txtFlowLine.ascent,txtFlowLine.descent,0);
            }
            return new TextLineMetrics(txtFlowLine.x,txtFlowLine.unjustifiedTextWidth,textFlowLineHeight,txtFlowLine.ascent,txtFlowLine.descent,txtFlowLine.height - (txtFlowLine.ascent + txtFlowLine.descent));
         }
         return null;
      }
      
      public function get borderWidth() : Number
      {
         return this._borderWidth;
      }
      
      public function set direction(value:String) : void
      {
         this._containerManager.direction = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_ALL);
      }
      
      tlf_internal function get contentHeight() : Number
      {
         return this._contentHeight;
      }
      
      public function set paddingTop(value:Object) : void
      {
         var n:Number = NaN;
         if(this._containerManager.paddingTop == value)
         {
            return;
         }
         try
         {
            this._containerManager.paddingTop = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.paddingTop = value = "auto";
            }
            else if(n < -1000)
            {
               _containerManager.paddingTop = value = -8000;
            }
            else if(n > 1000)
            {
               _containerManager.paddingTop = value = 8000;
            }
            else
            {
               _containerManager.paddingTop = value = "auto";
            }
         }
         if(this._paddingLock)
         {
            this._containerManager.paddingLeft = value;
            this._containerManager.paddingRight = value;
            this._containerManager.paddingBottom = value;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function get caretIndex() : int
      {
         if(Boolean(this.textFlow.interactionManager))
         {
            return this.textFlow.interactionManager.activePosition < 0 ? 0 : int(this.textFlow.interactionManager.activePosition);
         }
         return this._priorSelectionBeginIndex;
      }
      
      tlf_internal function switchToEditingMode(textFlow:TextFlow, editingMode:String, updateContainers:Boolean = true) : void
      {
         if(editingMode == null || this.tlf_internal::getEditingMode(textFlow.interactionManager) == editingMode)
         {
            return;
         }
         if(textFlow.interactionManager != null)
         {
            this._priorSelectionBeginIndex = textFlow.interactionManager.anchorPosition;
            this._priorSelectionEndIndex = textFlow.interactionManager.activePosition;
         }
         this._containerManager.editMode = editingMode;
         if(Boolean(textFlow.interactionManager))
         {
            this.setSelection(this._priorSelectionBeginIndex,this._priorSelectionEndIndex);
            textFlow.interactionManager.focusedSelectionFormat = tlf_internal::focusedSelectionFormat;
            textFlow.interactionManager.inactiveSelectionFormat = tlf_internal::inactiveSelectionFormat;
            if(this.alwaysShowSelection)
            {
               textFlow.interactionManager.unfocusedSelectionFormat = tlf_internal::alwaysShowSelectionOnFormat;
            }
            else
            {
               textFlow.interactionManager.unfocusedSelectionFormat = tlf_internal::alwaysShowSelectionOffFormat;
            }
         }
         if(updateContainers)
         {
            this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
         }
      }
      
      public function set wordWrap(value:Boolean) : void
      {
         this._wordWrap = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_WORD_WRAP);
      }
      
      public function set paddingRight(value:Object) : void
      {
         var n:Number = NaN;
         if(this._containerManager.paddingRight == value)
         {
            return;
         }
         try
         {
            this._containerManager.paddingRight = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.paddingRight = value = "auto";
            }
            else if(n < -1000)
            {
               _containerManager.paddingRight = value = -8000;
            }
            else if(n > 1000)
            {
               _containerManager.paddingRight = value = 8000;
            }
            else
            {
               _containerManager.paddingRight = value = "auto";
            }
         }
         if(this._paddingLock)
         {
            this._containerManager.paddingLeft = value;
            this._containerManager.paddingTop = value;
            this._containerManager.paddingBottom = value;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function get maxScrollH() : int
      {
         var blockProg:String = this.tlf_internal::TCMUsesTextStringAndFormat ? String(this.tlf_internal::hostFormat.blockProgression) : String(this.textFlow.computedFormat.blockProgression);
         var maxScroll:int = blockProg == BlockProgression.RL ? int(this._containerManager.contentHeight - this._containerManager.compositionHeight) : int(this._containerManager.contentWidth - this._containerManager.compositionWidth);
         return maxScroll > 0 ? maxScroll : 0;
      }
      
      public function get numLines() : int
      {
         this.tlf_internal::repaint();
         return this._containerManager.numLines;
      }
      
      private function hasSingleContainer(theFlow:TextFlow) : Boolean
      {
         if(theFlow == null)
         {
            return true;
         }
         if(theFlow.flowComposer == null)
         {
            return true;
         }
         return theFlow.flowComposer.numControllers <= 1;
      }
      
      public function get maxScrollV() : int
      {
         var lastLinePos:Number = NaN;
         var tf:TextFlow = this._containerManager.textFlow;
         if(tf == null)
         {
            return 0;
         }
         if(this._maxScrollVCached)
         {
            return this._maxScrollV;
         }
         this.tlf_internal::repaint();
         this._containerManager.compose();
         var flowComp:IFlowComposer = tf.flowComposer;
         if(flowComp.numControllers > 0 && flowComp.getControllerIndex(this._containerManager.controller) < flowComp.numControllers - 1)
         {
            this._maxScrollVCached = true;
            this._maxScrollV = 0;
            return this._maxScrollV;
         }
         var totalLines:int = int(this._containerManager.numLines);
         var colCount:int = !this._containerManager.columnCount || this._containerManager.columnCount == FormatValue.AUTO ? 1 : int(this._containerManager.columnCount);
         var lastColIndex:int = colCount - 1;
         this._maxScrollVFirstLineIndex = flowComp.findLineIndexAtPosition(this._containerManager.absoluteStart);
         var firstLine:TextFlowLine = flowComp.getLineAt(this._maxScrollVFirstLineIndex);
         if(firstLine == null)
         {
            this._maxScrollVCached = true;
            this._maxScrollV = 0;
            return this._maxScrollV;
         }
         while(firstLine.columnIndex != lastColIndex)
         {
            ++this._maxScrollVFirstLineIndex;
            if(this._maxScrollVFirstLineIndex >= totalLines)
            {
               this._maxScrollVCached = true;
               this._maxScrollV = 0;
               return this._maxScrollV;
            }
            firstLine = flowComp.getLineAt(this._maxScrollVFirstLineIndex);
         }
         this._maxScrollVFirstLineRect = firstLine.getBounds();
         var i:int = totalLines - 1;
         var curLine:TextFlowLine = flowComp.getLineAt(i);
         this._maxScrollVLastLineRect = curLine.getBounds();
         var rl:Boolean = tf.blockProgression == BlockProgression.RL;
         if(rl)
         {
            lastLinePos = Math.round(Math.min(this._maxScrollVLastLineRect.left,this._containerManager.contentLeft) + this._containerManager.compositionWidth);
            if(lastLinePos >= 0)
            {
               this._maxScrollVCached = true;
               this._maxScrollV = 0;
               return this._maxScrollV;
            }
         }
         else
         {
            lastLinePos = Math.round(Math.max(this._maxScrollVLastLineRect.bottom,this._containerManager.contentHeight) - this._containerManager.compositionHeight);
            if(lastLinePos <= 0)
            {
               this._maxScrollVCached = true;
               this._maxScrollV = 0;
               return this._maxScrollV;
            }
         }
         i--;
         while(i > this._maxScrollVFirstLineIndex)
         {
            curLine = flowComp.getLineAt(i);
            if(rl)
            {
               if(Math.round(curLine.getBounds().right) > lastLinePos)
               {
                  break;
               }
            }
            else if(Math.round(curLine.getBounds().top) < lastLinePos)
            {
               break;
            }
            i--;
         }
         this._maxScrollV = i - this._maxScrollVFirstLineIndex + 2;
         this._maxScrollVCached = true;
         return this._maxScrollV;
      }
      
      public function getImageReference(id:String) : DisplayObject
      {
         var graphicElement:InlineGraphicElement = null;
         var leaf:FlowLeafElement = this.textFlow.getFirstLeaf();
         while(Boolean(leaf))
         {
            if(leaf is InlineGraphicElement)
            {
               graphicElement = InlineGraphicElement(leaf);
               if(String(graphicElement.id).toUpperCase() == id.toUpperCase())
               {
                  return graphicElement.graphic;
               }
            }
            leaf = leaf.getNextLeaf();
         }
         return null;
      }
      
      override public function get height() : Number
      {
         this.tlf_internal::repaint();
         return super.height;
      }
      
      public function get scrollV() : int
      {
         var curRect:Rectangle = null;
         var hsp:Number = NaN;
         var vsp:Number = NaN;
         var tf:TextFlow = this._containerManager.textFlow;
         this.tlf_internal::repaint();
         this._containerManager.compose();
         if(!this._maxScrollVCached)
         {
            this.maxScrollV;
            if(!this._maxScrollVCached || this._maxScrollV == 0)
            {
               return 0;
            }
         }
         var totalLines:int = int(this._containerManager.numLines);
         for(var i:int = this._maxScrollVFirstLineIndex; i < totalLines; i++)
         {
            curRect = this._containerManager.getLineIndexBounds(i);
            if(!curRect.isEmpty())
            {
               if(tf.blockProgression == BlockProgression.RL)
               {
                  hsp = Math.round(this._containerManager.horizontalScrollPosition);
                  if(hsp <= Math.round(curRect.right) && hsp >= Math.round(curRect.left))
                  {
                     return i + 1;
                  }
               }
               else
               {
                  vsp = Math.round(this._containerManager.verticalScrollPosition);
                  if(vsp <= Math.round(curRect.bottom) && vsp >= Math.round(curRect.top))
                  {
                     return i + 1;
                  }
               }
            }
         }
         return 0;
      }
      
      public function get scrollH() : int
      {
         var blockProg:String = this.tlf_internal::TCMUsesTextStringAndFormat ? String(this.tlf_internal::hostFormat.blockProgression) : String(this.textFlow.computedFormat.blockProgression);
         return blockProg == BlockProgression.RL ? int(Math.abs(this._containerManager.verticalScrollPosition)) : int(Math.abs(this._containerManager.horizontalScrollPosition));
      }
      
      public function set borderAlpha(value:Number) : void
      {
         if(this._borderAlpha == value)
         {
            return;
         }
         this._borderAlpha = value;
         if(this._borderAlpha < 0)
         {
            this._borderAlpha = 0;
         }
         else if(this._borderAlpha > 1)
         {
            this._borderAlpha = 1;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_BORDER);
      }
      
      public function get text() : String
      {
         if(this._displayAsPassword || !this.tlf_internal::TCMUsesTextStringAndFormat && this.textFlow && this.textFlow.generation == this._generationID)
         {
            return this._text;
         }
         if(this._text == "" || this.tlf_internal::TCMUsesTextStringAndFormat || this.textFlow && this.textFlow.generation != this._generationID)
         {
            this._text = this._containerManager.text;
            return this._text;
         }
         return "";
      }
      
      public function get verticalAlign() : String
      {
         return String(this._containerManager.verticalAlign);
      }
      
      tlf_internal function updateComplete(event:UpdateCompleteEvent) : void
      {
         this.tlf_internal::composeComplete(null);
         dispatchEvent(new Event(Event.CHANGE,false,false));
      }
      
      public function getCharBoundaries(charIndex:int) : Rectangle
      {
         var atomBounds:Rectangle = null;
         var tmpPoint1:Point = null;
         var tmpPoint:Point = null;
         this.tlf_internal::repaint();
         var line:TextFlowLine = this.textFlow.flowComposer.findLineAtPosition(charIndex);
         var textLine:TextLine = line.getTextLine(true);
         var atomIdx:int = textLine.getAtomIndexAtCharIndex(charIndex - line.paragraph.getAbsoluteStart());
         if(atomIdx > -1)
         {
            atomBounds = textLine.getAtomBounds(atomIdx);
         }
         var txtFlowLine:TextFlowLine = this.getValidTextFlowLine(this.getLineIndexOfChar(charIndex));
         var bounds:Rectangle = txtFlowLine.getBounds();
         var bp:String = String(this.textFlow.computedFormat.blockProgression);
         var isTTB:Boolean = bp == BlockProgression.RL;
         if(!isTTB)
         {
            atomBounds.x += bounds.x;
            atomBounds.y = bounds.y;
            tmpPoint1 = this._containerManager.container.localToGlobal(new Point(atomBounds.x,atomBounds.y));
            tmpPoint = this.globalToLocal(tmpPoint1);
            atomBounds.x = tmpPoint.x;
            atomBounds.y = tmpPoint.y;
         }
         else
         {
            atomBounds.x += bounds.x;
            atomBounds.y += bounds.y;
            tmpPoint1 = this._containerManager.container.localToGlobal(new Point(atomBounds.x,atomBounds.y));
            tmpPoint = this.globalToLocal(tmpPoint1);
            atomBounds.x = tmpPoint.x;
            atomBounds.y = tmpPoint.y;
         }
         return atomBounds;
      }
      
      public function set paddingBottom(value:Object) : void
      {
         var n:Number = NaN;
         if(this._containerManager.paddingBottom == value)
         {
            return;
         }
         try
         {
            this._containerManager.paddingBottom = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.paddingBottom = value = "auto";
            }
            else if(n < -1000)
            {
               _containerManager.paddingBottom = value = -8000;
            }
            else if(n > 1000)
            {
               _containerManager.paddingBottom = value = 8000;
            }
            else
            {
               _containerManager.paddingBottom = value = "auto";
            }
         }
         if(this._paddingLock)
         {
            this._containerManager.paddingLeft = value;
            this._containerManager.paddingTop = value;
            this._containerManager.paddingRight = value;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function get type() : String
      {
         var master:TLFTextField = this.tlf_internal::firstField;
         return Boolean(master) ? master._type : this._type;
      }
      
      public function replaceSelectedText(value:String) : void
      {
         if(Boolean(this.textFlow) && this.textFlow.formatResolver != null)
         {
            throw new Error("This method cannot be used on a text field with a style sheet.");
         }
         var priorEditingMode:String = this.tlf_internal::getEditingMode(this.textFlow.interactionManager);
         if(priorEditingMode != EditingMode.READ_WRITE)
         {
            this.tlf_internal::switchToEditingMode(this.textFlow,EditingMode.READ_WRITE);
         }
         var editManager:EditManager = EditManager(this.textFlow.interactionManager);
         editManager.beginCompositeOperation();
         if(!editManager.hasSelection())
         {
            editManager.selectRange(int.MAX_VALUE,int.MAX_VALUE);
         }
         var selStart:Number = editManager.anchorPosition;
         this.tlf_internal::insertWithParagraphs(editManager,value);
         this._containerManager.update();
         if(this._defaultTextFormat != null)
         {
            this.setTextFormat(this._defaultTextFormat,selStart,selStart + value.length);
         }
         editManager.endCompositeOperation();
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
         if(priorEditingMode != EditingMode.READ_WRITE)
         {
            this.tlf_internal::switchToEditingMode(this.textFlow,priorEditingMode);
         }
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function get alwaysShowSelection() : Boolean
      {
         var master:TLFTextField = this.tlf_internal::firstField;
         return Boolean(master) ? master.tlf_internal::_alwaysShowSelection : this.tlf_internal::_alwaysShowSelection;
      }
      
      public function get sharpness() : Number
      {
         return 0;
      }
      
      tlf_internal function invalidate(type:uint) : void
      {
         this._maxScrollVCached = false;
         this._invalidState |= type;
         if(stage != null)
         {
            try
            {
               stage.addEventListener(Event.RENDER,this.tlf_internal::repaint,false,0,true);
               stage.invalidate();
            }
            catch(se:SecurityError)
            {
               addEventListener(Event.FRAME_CONSTRUCTED,tlf_internal::repaint,false,0,true);
            }
         }
         else if(parent == null)
         {
            addEventListener(Event.ADDED,this.tlf_internal::repaint,false,0,true);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.tlf_internal::repaint,false,0,true);
            addEventListener(Event.FRAME_CONSTRUCTED,this.tlf_internal::repaint,false,0,true);
         }
      }
      
      tlf_internal function insertWithParagraphs(editManager:EditManager, newText:String) : void
      {
         var arrNewText:Array = null;
         var iStart:Number = NaN;
         var tmpString:String = null;
         newText = newText.replace(/\r/g,"");
         if(newText == "")
         {
            editManager.insertText("");
         }
         else
         {
            arrNewText = newText.split("\n");
            iStart = editManager.absoluteStart;
            tmpString = arrNewText.shift();
            while(tmpString != null)
            {
               if(Boolean(tmpString.length))
               {
                  editManager.insertText(tmpString);
               }
               iStart += tmpString.length;
               if(arrNewText.length > 0 && !this._displayAsPassword)
               {
                  editManager.selectRange(iStart,iStart);
                  editManager.splitParagraph();
                  iStart++;
               }
               tmpString = arrNewText.shift();
            }
         }
      }
      
      public function set borderColor(value:uint) : void
      {
         if(this._borderColor == value)
         {
            return;
         }
         this._borderColor = value;
         if(this._borderColor > 16777215)
         {
            this._borderColor = 16777215;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_BORDER);
      }
      
      public function set columnGap(value:Object) : void
      {
         var n:Number = NaN;
         if(this._containerManager.columnGap == value)
         {
            return;
         }
         try
         {
            this._containerManager.columnGap = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(n < 0 || isNaN(n))
            {
               _containerManager.columnGap = 0;
            }
            else if(n > 1000)
            {
               _containerManager.columnGap = 1000;
            }
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function set defaultTextFormat(value:TextFormat) : void
      {
         var master:TLFTextField = null;
         if(!this.tlf_internal::TCMUsesTextStringAndFormat && this.textFlow && this.textFlow.formatResolver != null)
         {
            throw new Error("This method cannot be used on a text field with a style sheet.");
         }
         if(this._defaultTextFormat == value)
         {
            return;
         }
         this._defaultTextFormat = value;
         if(Boolean(value))
         {
            if(this._defaultTextFormat.font == null)
            {
               this._defaultTextFormat.font = "Times New Roman";
            }
            master = this.tlf_internal::firstField;
            if(!master)
            {
               master = this;
            }
            master._containerManager.hostFormat = tlf_internal::createTextLayoutFormat(value);
         }
      }
      
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function setSelection(begIdx:int, endIdx:int) : void
      {
         if(begIdx < 0)
         {
            begIdx = 0;
         }
         else if(begIdx > this._containerManager.textLength + 1)
         {
            begIdx = this.length + 1;
         }
         if(endIdx < 0)
         {
            endIdx = 0;
         }
         else if(endIdx > this._containerManager.textLength + 1)
         {
            endIdx = this.length + 1;
         }
         if(Boolean(this.textFlow.interactionManager))
         {
            this.textFlow.interactionManager.selectRange(begIdx,endIdx);
            this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
         }
         else
         {
            this._priorSelectionBeginIndex = begIdx;
            this._priorSelectionEndIndex = endIdx;
         }
      }
      
      public function set useRichTextClipboard(value:Boolean) : void
      {
         this._useRichTextClipboard = value;
      }
      
      public function set embedFonts(value:Boolean) : void
      {
         if(this.embedFonts == value)
         {
            return;
         }
         this._containerManager.embedFonts = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function get columnCount() : Object
      {
         return this._containerManager.columnCount;
      }
      
      public function set multiline(value:Boolean) : void
      {
         this._multiline = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      tlf_internal function removeTextFlowEventListeners() : void
      {
         this._containerManager.removeListeners();
      }
      
      public function set mouseWheelEnabled(value:Boolean) : void
      {
         this._mouseWheelEnabled = value;
      }
      
      public function appendText(newText:String) : void
      {
         this._containerManager.appendText(newText);
      }
      
      public function set tlfMarkup(value:String) : void
      {
         if(value == "")
         {
            this.text = "";
            this.tlf_internal::hostFormat = new TextLayoutFormat();
            return;
         }
         this.tlf_internal::doImport(TextConverter.TEXT_LAYOUT_FORMAT,value);
         this._tlfMarkup = this.tlfMarkup;
      }
      
      public function set paddingLeft(value:Object) : void
      {
         var n:Number = NaN;
         if(this._containerManager.paddingLeft == value)
         {
            return;
         }
         try
         {
            this._containerManager.paddingLeft = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.paddingLeft = value = "auto";
            }
            else if(n < -1000)
            {
               _containerManager.paddingLeft = value = -8000;
            }
            else if(n > 1000)
            {
               _containerManager.paddingLeft = value = 8000;
            }
            else
            {
               _containerManager.paddingLeft = value = "auto";
            }
         }
         if(this._paddingLock)
         {
            this._containerManager.paddingTop = value;
            this._containerManager.paddingRight = value;
            this._containerManager.paddingBottom = value;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function get thickness() : Number
      {
         return 0;
      }
      
      public function getLineIndexAtPoint(x:Number, y:Number) : int
      {
         return this.getLineIndexOfChar(this.getCharIndexAtPoint(x,y));
      }
      
      public function get htmlText() : String
      {
         if(this.textFlow.generation != this._htmlTextGenerationID || this._htmlText == "")
         {
            this._htmlText = TextConverter.export(this.textFlow,TextConverter.TEXT_FIELD_HTML_FORMAT,ConversionType.STRING_TYPE) as String;
            this._htmlTextGenerationID = this.textFlow.generation;
         }
         return this._htmlText;
      }
      
      public function getTextFormat(beginIndex:int = -1, endIndex:int = -1) : TextFormat
      {
         if(beginIndex > this._containerManager.textLength || beginIndex < -1 || endIndex > this._containerManager.textLength || endIndex < -1)
         {
            throw new RangeError("The beginIndex or endIndex specified is out of range.");
         }
         return this._containerManager.getTextFormat(beginIndex,endIndex);
      }
      
      tlf_internal function set hostFormat(newFormat:ITextLayoutFormat) : void
      {
         this._containerManager.hostFormat = newFormat;
      }
      
      public function get direction() : String
      {
         return this._containerManager.direction;
      }
      
      public function get paddingTop() : Object
      {
         return this._containerManager.paddingTop;
      }
      
      public function set pixelScrollV(value:int) : void
      {
         var blockProg:String = this.tlf_internal::TCMUsesTextStringAndFormat ? String(this.tlf_internal::hostFormat.blockProgression) : String(this.textFlow.computedFormat.blockProgression);
         if(value < 0)
         {
            value = 0;
         }
         else if(value > this.pixelMaxScrollV)
         {
            value = this.pixelMaxScrollV;
         }
         if(blockProg == BlockProgression.RL)
         {
            this._containerManager.horizontalScrollPosition = -value;
         }
         else
         {
            this._containerManager.verticalScrollPosition = value;
         }
      }
      
      public function set restrict(value:String) : void
      {
         this._restrict = value;
      }
      
      public function set gridFitType(value:String) : void
      {
         var fmt:TextLayoutFormat = null;
         if(this.gridFitType == value)
         {
            return;
         }
         if(value != GridFitType.NONE && value != GridFitType.PIXEL && value != GridFitType.SUBPIXEL)
         {
            value = GridFitType.PIXEL;
         }
         this._gridFitType = value;
         if(this._invalidTextLayoutFormat == null)
         {
            this._invalidTextLayoutFormat = new TextLayoutFormat();
         }
         this._invalidTextLayoutFormat.cffHinting = FormatValue.INHERIT;
         if(this.tlf_internal::TCMUsesTextStringAndFormat)
         {
            fmt = Boolean(this.tlf_internal::hostFormat) ? TextLayoutFormat(this.tlf_internal::hostFormat) : new TextLayoutFormat();
            fmt.cffHinting = value == GridFitType.NONE ? CFFHinting.NONE : CFFHinting.HORIZONTAL_STEM;
            this.tlf_internal::hostFormat = fmt;
         }
         else
         {
            this.textFlow.cffHinting = value == GridFitType.NONE ? CFFHinting.NONE : CFFHinting.HORIZONTAL_STEM;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      override public function set width(value:Number) : void
      {
         if(value != this._containerManager.compositionWidth)
         {
            this._containerManager.setCompositionSize(value,this._containerManager.compositionHeight);
            this.tlf_internal::invalidate(tlf_internal::INVALID_DIMENSIONS);
         }
      }
      
      public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1) : void
      {
         var newFmt:TextLayoutFormat = null;
         if(beginIndex > this._containerManager.textLength || beginIndex < -1 || endIndex > this._containerManager.textLength || endIndex < -1)
         {
            throw new RangeError("The beginIndex or endIndex specified is out of range.");
         }
         var charFormat:TextLayoutFormat = new TextLayoutFormat();
         var paraFormat:TextLayoutFormat = new TextLayoutFormat();
         this._containerManager.setTextFormat(format,beginIndex,endIndex,charFormat,paraFormat);
         if(this.canUseTCMForTextFlow(this.textFlow))
         {
            this._containerManager = this._containerManager.convert(SingleTextContainerManager);
            if((beginIndex == -1 || beginIndex == 0) && (endIndex == -1 || endIndex == this._containerManager.textLength))
            {
               newFmt = new TextLayoutFormat(this._containerManager.hostFormat);
               newFmt.concat(paraFormat);
               newFmt.concat(charFormat);
               this._containerManager.hostFormat = newFmt;
               this._containerManager.text = this.text;
            }
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      tlf_internal function textFlow_flowOperationBeginHandler(event:FlowOperationEvent) : void
      {
         var originalSelectionState:SelectionState = null;
         var numToDel:int = 0;
         var begLen:int = 0;
         var inputLen:int = 0;
         var insertTextOperation:InsertTextOperation = null;
         var textToInsert:String = null;
         var delSelOp:SelectionState = null;
         var delLen:int = 0;
         var allTabs:RegExp = null;
         var length1:int = 0;
         var length2:int = 0;
         var flowTextOperation:FlowTextOperation = null;
         var op:FlowOperation = event.operation;
         if(op is SplitParagraphOperation && !this._multiline)
         {
            event.preventDefault();
            dispatchEvent(new Event("Enter"));
            return;
         }
         if(op is SplitParagraphOperation)
         {
            originalSelectionState = (op as SplitParagraphOperation).originalSelectionState;
            numToDel = originalSelectionState == null ? 0 : originalSelectionState.absoluteEnd - originalSelectionState.absoluteStart;
            if(this.maxChars != 0)
            {
               begLen = this._containerManager.textLength - numToDel;
               inputLen = 1;
               if(begLen + inputLen > this.maxChars)
               {
                  event.preventDefault();
                  return;
               }
            }
         }
         if(op is InsertTextOperation)
         {
            insertTextOperation = InsertTextOperation(op);
            textToInsert = insertTextOperation.text;
            if(this._displayAsPassword)
            {
               allTabs = /\t/g;
               textToInsert = textToInsert.replace(allTabs,"");
            }
            if(this._restrict != null)
            {
               textToInsert = restrictChar(textToInsert,this.restrict);
            }
            delSelOp = insertTextOperation.deleteSelectionState;
            delLen = delSelOp == null ? 0 : delSelOp.absoluteEnd - delSelOp.absoluteStart;
            if(this.maxChars != 0)
            {
               length1 = this._containerManager.textLength - delLen;
               length2 = textToInsert.length;
               if(length1 + length2 > this.maxChars)
               {
                  textToInsert = textToInsert.substr(0,this.maxChars - length1);
               }
            }
            if(this._displayAsPassword)
            {
               if(delLen > 0)
               {
                  this._text = splice(this._text,delSelOp.absoluteStart,delSelOp.absoluteEnd,"");
               }
               this._text = splice(this._text,insertTextOperation.absoluteStart,insertTextOperation.absoluteEnd,textToInsert);
               textToInsert = tlf_internal::repeat(this._passwordCharacter,textToInsert);
            }
            insertTextOperation.text = textToInsert;
         }
         else if(!(op is PasteOperation))
         {
            if(op is DeleteTextOperation || op is CutOperation)
            {
               flowTextOperation = FlowTextOperation(op);
               if(flowTextOperation.absoluteStart == flowTextOperation.absoluteEnd)
               {
                  event.preventDefault();
                  return;
               }
               if(this._displayAsPassword)
               {
                  this._text = splice(this._text,flowTextOperation.absoluteStart,flowTextOperation.absoluteEnd,"");
               }
            }
         }
      }
      
      public function get controller() : ContainerController
      {
         return ContainerController(this._containerManager.controller);
      }
      
      tlf_internal function get pixelMinScrollV() : int
      {
         return 0;
      }
      
      tlf_internal function set contentWidth(n:Number) : void
      {
         this._contentWidth = n;
      }
      
      public function get paddingBottom() : Object
      {
         return this._containerManager.paddingBottom;
      }
      
      public function getLineOffset(lineIndex:int) : int
      {
         if(lineIndex < 0 || lineIndex >= this.numLines)
         {
            throw new RangeError("The line number specified is out of range.");
         }
         var txtFlowLine:TextFlowLine = this.getValidTextFlowLine(lineIndex);
         return txtFlowLine.absoluteStart;
      }
      
      tlf_internal function addTextFlowEventListeners() : void
      {
         this._containerManager.addListeners();
      }
      
      public function set backgroundColor(value:uint) : void
      {
         if(this._backgroundColor == value)
         {
            return;
         }
         if(value > 16777215)
         {
            value = 16777215;
         }
         this._backgroundColor = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_BORDER);
      }
      
      public function set maxChars(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         var master:TLFTextField = this.tlf_internal::firstField;
         if(!master)
         {
            master = this;
         }
         master._maxChars = value;
      }
      
      tlf_internal function set isPointText(pointText:Boolean) : void
      {
         if(this._isPointText == pointText)
         {
            return;
         }
         this._isPointText = pointText;
         this._autoSize = pointText ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
         this.tlf_internal::invalidate(tlf_internal::INVALID_AUTO_SIZE);
      }
      
      public function set backgroundAlpha(value:Number) : void
      {
         if(this._backgroundAlpha == value)
         {
            return;
         }
         this._backgroundAlpha = value;
         if(this._backgroundAlpha < 0)
         {
            this._backgroundAlpha = 0;
         }
         else if(this._backgroundAlpha > 1)
         {
            this._backgroundAlpha = 1;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_BORDER);
      }
      
      private function doTypeSet(master:TLFTextField) : void
      {
         var newSelectionFormat:SelectionFormat = null;
         var interactionMgr:ISelectionManager = master.tlf_internal::TCMUsesTextStringAndFormat ? null : master.textFlow.interactionManager;
         if(interactionMgr != null)
         {
            this._priorSelectionBeginIndex = interactionMgr.absoluteStart;
            this._priorSelectionEndIndex = interactionMgr.absoluteEnd;
         }
         var mode:String = EditingMode.READ_ONLY;
         if(this.type == TextFieldType.INPUT)
         {
            mode = EditingMode.READ_WRITE;
         }
         else if(this.selectable)
         {
            mode = EditingMode.READ_SELECT;
         }
         master._containerManager.editModeNoInteraction = mode;
         interactionMgr = master.tlf_internal::TCMUsesTextStringAndFormat ? null : master.textFlow.interactionManager;
         if(interactionMgr != null)
         {
            this.setSelection(this._priorSelectionBeginIndex,this._priorSelectionEndIndex);
            if(interactionMgr.focusedSelectionFormat != tlf_internal::focusedSelectionFormat)
            {
               interactionMgr.focusedSelectionFormat = tlf_internal::focusedSelectionFormat;
            }
            if(interactionMgr.inactiveSelectionFormat != tlf_internal::inactiveSelectionFormat)
            {
               interactionMgr.inactiveSelectionFormat = tlf_internal::inactiveSelectionFormat;
            }
            newSelectionFormat = this.alwaysShowSelection ? tlf_internal::alwaysShowSelectionOnFormat : tlf_internal::alwaysShowSelectionOffFormat;
            if(interactionMgr.unfocusedSelectionFormat != newSelectionFormat)
            {
               interactionMgr.unfocusedSelectionFormat = newSelectionFormat;
            }
         }
      }
      
      tlf_internal function get TCMUsesTextStringAndFormat() : Boolean
      {
         return this._containerManager.isTextStringAndFormat();
      }
      
      tlf_internal function get hostFormat() : ITextLayoutFormat
      {
         return this._containerManager.hostFormat;
      }
      
      public function get columnGap() : Object
      {
         return this._containerManager.columnGap;
      }
      
      public function get pixelScrollV() : int
      {
         var blockProg:String = this.tlf_internal::TCMUsesTextStringAndFormat ? String(this.tlf_internal::hostFormat.blockProgression) : String(this.textFlow.computedFormat.blockProgression);
         return blockProg == BlockProgression.RL ? int(Math.abs(this._containerManager.horizontalScrollPosition)) : int(Math.abs(this._containerManager.verticalScrollPosition));
      }
      
      public function getParagraphLength(charIndex:int) : int
      {
         var paragraphLength:int = 0;
         var txtFlowLine:TextFlowLine = null;
         if(charIndex > this._containerManager.textLength || charIndex < 0)
         {
            throw new RangeError("The character index specified is out of range.");
         }
         paragraphLength = -1;
         txtFlowLine = this.getValidTextFlowLineFromCharIndex(charIndex);
         if(Boolean(txtFlowLine))
         {
            paragraphLength = txtFlowLine.paragraph.textLength;
         }
         return paragraphLength;
      }
      
      override public function get width() : Number
      {
         this.tlf_internal::repaint();
         return super.width;
      }
      
      tlf_internal function get nextField() : TLFTextField
      {
         var index:int = 0;
         var nextController:TLFContainerController = null;
         if(Boolean(this.textFlow) && Boolean(this.textFlow.flowComposer))
         {
            index = int(this.textFlow.flowComposer.getControllerIndex(this.controller));
            if(index + 1 < this.textFlow.flowComposer.numControllers)
            {
               nextController = this.textFlow.flowComposer.getControllerAt(index + 1) as TLFContainerController;
               if(Boolean(nextController))
               {
                  return nextController.ownerField;
               }
            }
         }
         return null;
      }
      
      tlf_internal function set inlineInfo(info:*) : void
      {
         this._inlineInfo = info;
      }
      
      tlf_internal function set paddingLock(value:Boolean) : void
      {
         this._paddingLock = value;
         if(this._paddingLock)
         {
            this._containerManager.paddingTop = this.paddingLeft;
            this._containerManager.paddingRight = this.paddingLeft;
            this._containerManager.paddingBottom = this.paddingLeft;
            this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
         }
      }
      
      public function getCharIndexAtPoint(x:Number, y:Number) : int
      {
         var newPoint:Point = null;
         var idx:int = 0;
         var rect:Rectangle = null;
         var tf:TextFlow = this._containerManager.textFlow;
         if(Boolean(tf))
         {
            newPoint = globalToLocal(new Point(x,y));
            idx = int(SelectionManager.tlf_internal::computeSelectionIndex(tf,this,null,newPoint.x,newPoint.y));
            rect = this.getCharBoundaries(idx);
            return rect.containsPoint(newPoint) ? idx : (idx > 0 ? idx - 1 : idx);
         }
         return -1;
      }
      
      public function get paddingLeft() : Object
      {
         return this._containerManager.paddingLeft;
      }
      
      tlf_internal function linkClick(evtObj:FlowElementMouseEvent) : void
      {
         var href:String = LinkElement(evtObj.flowElement).href;
         var iIndex:int = href.search("event:");
         if(iIndex >= 0)
         {
            href = href.substring(iIndex + 6,href.length - iIndex + 5);
            dispatchEvent(new TextEvent(TextEvent.LINK,false,false,href));
         }
      }
      
      public function set blockProgression(value:Object) : void
      {
         this._containerManager.blockProgression = value;
         this.tlf_internal::invalidate(tlf_internal::INVALID_TEXT);
      }
      
      public function get blockProgression() : Object
      {
         return this._containerManager.blockProgression;
      }
      
      public function getLineLength(lineIndex:int) : int
      {
         if(lineIndex < 0 || lineIndex >= this.numLines)
         {
            throw new RangeError("The line number specified is out of range.");
         }
         var txtFlowLine:TextFlowLine = this.getValidTextFlowLine(lineIndex);
         if(Boolean(txtFlowLine))
         {
            return txtFlowLine.textLength - 1;
         }
         return 0;
      }
      
      public function set borderWidth(value:Number) : void
      {
         if(this._borderWidth == value)
         {
            return;
         }
         this._borderWidth = value;
         if(this._borderWidth < 1)
         {
            this._borderWidth = 1;
         }
         else if(this._borderWidth > 100)
         {
            this._borderWidth = 100;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_BORDER);
      }
      
      public function set textFlow(theFlow:TextFlow) : void
      {
         var tf:TextFlow = this._containerManager.textFlow;
         if(theFlow == tf)
         {
            return;
         }
         this.tlf_internal::invalidate(tlf_internal::INVALID_ALL);
         if(tf != null)
         {
            this.tlf_internal::removeTextFlowEventListeners();
         }
         this._containerManager.textFlow = theFlow;
         if(this._containerManager.textFlow != null)
         {
            this._wordWrap = theFlow.computedFormat.lineBreak == LineBreak.TO_FIT;
            this.tlf_internal::addTextFlowEventListeners();
         }
      }
      
      public function get textFlow() : TextFlow
      {
         if(!this._containerManager.textFlow)
         {
            this.text = "";
            this._containerManager.textFlow.lineBreak = this._wordWrap ? LineBreak.TO_FIT : LineBreak.EXPLICIT;
         }
         return this._containerManager.textFlow;
      }
      
      private function getValidTextFlowLine(lineIndex:int) : TextFlowLine
      {
         var txtFlowLine:TextFlowLine = null;
         if(lineIndex >= 0 && lineIndex < this.numLines)
         {
            return this.textFlow.flowComposer.getLineAt(lineIndex);
         }
         throw new RangeError("The line number specified is out of range.");
      }
   }
}
