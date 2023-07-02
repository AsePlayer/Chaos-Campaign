package fl.text
{
   import flash.display.Sprite;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.RenderingMode;
   import flash.text.engine.TabAlignment;
   import flash.text.engine.TextLine;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.CompositionCompleteEvent;
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
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   internal class SingleTextContainerManager extends CommonTextContainerManager implements IContainerManager
   {
      
      private static var _alwaysShowOffConfiguration:Configuration;
      
      private static var initConfiguration:Boolean = true;
      
      private static var _alwaysShowOnConfiguration:Configuration;
       
      
      private var _tcm:fl.text.TLFTextContainerManager;
      
      public function SingleTextContainerManager(container:Sprite, ownerField:TLFTextField, controller:ContainerController = null)
      {
         super();
         _controller = controller;
         _container = container;
         _ownerField = ownerField;
         if(initConfiguration)
         {
            _alwaysShowOffConfiguration = Configuration(Configuration(TextContainerManager.defaultConfiguration).clone());
            _alwaysShowOffConfiguration.focusedSelectionFormat = TLFTextField.tlf_internal::focusedSelectionFormat;
            _alwaysShowOffConfiguration.inactiveSelectionFormat = TLFTextField.tlf_internal::inactiveSelectionFormat;
            _alwaysShowOffConfiguration.unfocusedSelectionFormat = TLFTextField.tlf_internal::alwaysShowSelectionOffFormat;
            _alwaysShowOnConfiguration = Configuration(Configuration(TextContainerManager.defaultConfiguration).clone());
            _alwaysShowOnConfiguration.focusedSelectionFormat = TLFTextField.tlf_internal::focusedSelectionFormat;
            _alwaysShowOnConfiguration.inactiveSelectionFormat = TLFTextField.tlf_internal::inactiveSelectionFormat;
            _alwaysShowOnConfiguration.unfocusedSelectionFormat = TLFTextField.tlf_internal::alwaysShowSelectionOnFormat;
            initConfiguration = false;
         }
         this._tcm = new fl.text.TLFTextContainerManager(_container,!!ownerField.tlf_internal::_alwaysShowSelection ? _alwaysShowOnConfiguration : _alwaysShowOffConfiguration);
         this.addListeners();
         this._tcm.compositionHeight = int.MAX_VALUE;
         this._tcm.compositionWidth = int.MAX_VALUE;
      }
      
      public function get contentHeight() : Number
      {
         return this._tcm.getContentBounds().height;
      }
      
      override public function get textFlow() : TextFlow
      {
         var fmt:TextLayoutFormat = this.isTextStringAndFormat() ? TextLayoutFormat(this.hostFormat) : null;
         this._tcm.tlf_internal::convertToTextFlowWithComposer();
         this.ConvertHostFormatToController(fmt);
         return this._tcm.getTextFlow();
      }
      
      override public function set direction(value:String) : void
      {
         var fmt:TextLayoutFormat = null;
         if(!this.isTextStringAndFormat())
         {
            super.direction = value;
         }
         else
         {
            fmt = Boolean(this.hostFormat) ? TextLayoutFormat(this.hostFormat) : new TextLayoutFormat();
            switch(value)
            {
               case Direction.LTR:
               case Direction.RTL:
               case FormatValue.INHERIT:
                  fmt.direction = value;
                  break;
               default:
                  fmt.direction = Direction.LTR;
            }
            this.hostFormat = fmt;
         }
      }
      
      override public function replaceText(beginIndex:int, endIndex:int, newText:String) : void
      {
         if(this.isTextStringAndFormat() && newText.search(/[\n\r]/g) == -1)
         {
            _ownerField.text = this.text.slice(0,beginIndex) + newText + this.text.slice(endIndex + 1);
         }
         else
         {
            super.replaceText(beginIndex,endIndex,newText);
         }
      }
      
      public function setCompositionSize(width:Number, height:Number) : void
      {
         this._tcm.compositionWidth = width;
         this._tcm.compositionHeight = height;
         if(Boolean(this.controller))
         {
            this.controller.setCompositionSize(width,height);
         }
      }
      
      public function set paddingTop(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.paddingTop = this.isTextStringAndFormat() ? value : 0;
         this._tcm.hostFormat = fmt;
         if(!this.isTextStringAndFormat())
         {
            this.controller.paddingTop = value;
         }
      }
      
      public function set paddingRight(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.paddingRight = this.isTextStringAndFormat() ? value : 0;
         this._tcm.hostFormat = fmt;
         if(!this.isTextStringAndFormat())
         {
            this.controller.paddingRight = value;
         }
      }
      
      public function get numLines() : int
      {
         return this._tcm.tlf_internal::getActualNumLines();
      }
      
      public function removeListeners() : void
      {
         this._tcm.removeEventListener(TextLayoutEvent.SCROLL,_ownerField.tlf_internal::textFlow_ScrollHandler);
         this._tcm.removeEventListener(MouseEvent.CLICK,_ownerField.tlf_internal::linkClick);
         this._tcm.removeEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,_ownerField.tlf_internal::textFlow_flowOperationBeginHandler);
         this._tcm.removeEventListener(FlowOperationEvent.FLOW_OPERATION_END,_ownerField.tlf_internal::textFlow_flowOperationEndHandler);
         this._tcm.removeEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,_ownerField.tlf_internal::composeComplete);
         this._tcm.removeEventListener(UpdateCompleteEvent.UPDATE_COMPLETE,_ownerField.tlf_internal::updateComplete);
         _ownerField.removeEventListener(FocusEvent.FOCUS_IN,this._tcm.focusInHandler);
      }
      
      public function get contentTop() : Number
      {
         return this._tcm.getContentBounds().top;
      }
      
      override public function isTextStringAndFormat() : Boolean
      {
         return this._tcm.tlf_internal::composeState == TextContainerManager.tlf_internal::COMPOSE_FACTORY && this._tcm.tlf_internal::sourceState == TextContainerManager.tlf_internal::SOURCE_STRING;
      }
      
      public function get contentLeft() : Number
      {
         return this._tcm.getContentBounds().left;
      }
      
      public function get columnWidth() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return FormatValue.AUTO;
         }
         return this._tcm.hostFormat.columnWidth == FormatValue.INHERIT ? FormatValue.AUTO : this._tcm.hostFormat.columnWidth;
      }
      
      public function get firstBaselineOffset() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return VerticalAlign.TOP;
         }
         return this._tcm.hostFormat.firstBaselineOffset == FormatValue.INHERIT ? FormatValue.AUTO : this._tcm.hostFormat.firstBaselineOffset;
      }
      
      public function get absoluteStart() : int
      {
         return 0;
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._tcm.verticalScrollPosition;
      }
      
      public function get text() : String
      {
         return this._tcm.getText("\n");
      }
      
      override public function get textColor() : uint
      {
         if(!this.isTextStringAndFormat())
         {
            return super.textColor;
         }
         if(this.hostFormat != null)
         {
            return uint(this.hostFormat.color);
         }
         return 0;
      }
      
      public function set paddingBottom(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.paddingBottom = this.isTextStringAndFormat() ? value : 0;
         this._tcm.hostFormat = fmt;
         if(!this.isTextStringAndFormat())
         {
            this.controller.paddingBottom = value;
         }
      }
      
      public function set columnGap(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.columnGap = value;
         this._tcm.hostFormat = fmt;
      }
      
      public function set columnWidth(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.columnWidth = value;
         this._tcm.hostFormat = fmt;
      }
      
      public function get compositionWidth() : Number
      {
         return this._tcm.compositionWidth;
      }
      
      private function ConvertHostFormatToController(fmt:TextLayoutFormat) : void
      {
         if(!fmt)
         {
            return;
         }
         this.controller.paddingLeft = fmt.paddingLeft;
         this.controller.paddingTop = fmt.paddingTop;
         this.controller.paddingRight = fmt.paddingRight;
         this.controller.paddingBottom = fmt.paddingBottom;
         this.controller.verticalAlign = fmt.verticalAlign;
         this.controller.columnCount = fmt.columnCount;
         this.controller.columnGap = fmt.columnGap;
         this.controller.columnWidth = fmt.columnWidth;
      }
      
      public function get verticalAlign() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return FormatValue.AUTO;
         }
         return this._tcm.hostFormat.verticalAlign;
      }
      
      public function set verticalScrollPosition(value:Number) : void
      {
         this._tcm.verticalScrollPosition = value;
      }
      
      override public function set text(value:String) : void
      {
         var tempFmt:TextLayoutFormat = null;
         if(value.search(/[\r\n]/g) != -1)
         {
            super.text = value;
         }
         else
         {
            if(this.isTextStringAndFormat())
            {
               tempFmt = TextLayoutFormat(this.hostFormat);
            }
            else
            {
               tempFmt = TextLayoutFormat(this.textFlow.getFirstLeaf().computedFormat);
               this.ConvertContainerValuesToHostFormat(tempFmt);
            }
            if(!_ownerField.displayAsPassword)
            {
               this._tcm.setText(value);
            }
            else
            {
               this._tcm.setText(TLFTextField.tlf_internal::repeat(_ownerField.tlf_internal::passwordCharacter,value));
            }
            this.hostFormat = tempFmt;
         }
      }
      
      public function getLineIndexBounds(index:int) : Rectangle
      {
         var tl:TextLine = this._tcm.getLineAt(index);
         if(tl == null)
         {
            return new Rectangle();
         }
         return TextFlowLine(tl.userData).getBounds();
      }
      
      public function set verticalAlign(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.verticalAlign = value;
         this._tcm.hostFormat = fmt;
         if(Boolean(this.controller))
         {
            this.controller.verticalAlign = value;
         }
      }
      
      public function get columnCount() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return FormatValue.AUTO;
         }
         return this._tcm.hostFormat.columnCount == FormatValue.INHERIT ? FormatValue.AUTO : this._tcm.hostFormat.columnCount;
      }
      
      override public function appendText(newText:String) : void
      {
         if(this.isTextStringAndFormat() && newText.search(/[\n\r]/g) == -1)
         {
            _ownerField.text = this.text + newText;
         }
         else
         {
            super.appendText(newText);
         }
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._tcm.horizontalScrollPosition;
      }
      
      override public function set textColor(value:uint) : void
      {
         var fmt:TextLayoutFormat = null;
         if(this.isTextStringAndFormat())
         {
            fmt = Boolean(this.hostFormat) ? TextLayoutFormat(this.hostFormat) : new TextLayoutFormat();
            fmt.color = value;
            this.hostFormat = fmt;
         }
         else
         {
            super.textColor = value;
         }
      }
      
      public function set paddingLeft(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.paddingLeft = this.isTextStringAndFormat() ? value : 0;
         this._tcm.hostFormat = fmt;
         if(!this.isTextStringAndFormat())
         {
            this.controller.paddingLeft = value;
         }
      }
      
      public function get compositionHeight() : Number
      {
         return this._tcm.compositionHeight;
      }
      
      override public function get lineBreak() : String
      {
         if(!this.isTextStringAndFormat())
         {
            return super.lineBreak;
         }
         if(Boolean(this.hostFormat))
         {
            return this.hostFormat.lineBreak;
         }
         return LineBreak.EXPLICIT;
      }
      
      override public function get textLength() : int
      {
         return this._tcm.getText().length;
      }
      
      public function set hostFormat(value:ITextLayoutFormat) : void
      {
         this._tcm.hostFormat = value;
         if(!this.isTextStringAndFormat())
         {
            this.textFlow.hostFormat = value;
            this.ConvertHostFormatToController(value as TextLayoutFormat);
         }
      }
      
      public function get paddingTop() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return this.controller.paddingTop;
         }
         if(this._tcm.hostFormat == null)
         {
            return 2;
         }
         return this._tcm.hostFormat.paddingTop;
      }
      
      override public function getTextFormat(beginIndex:int, endIndex:int) : TextFormat
      {
         var leading:Number = NaN;
         var str:String = null;
         var leafFontSize:Number = NaN;
         var arrLength:int = 0;
         var i:int = 0;
         var tabStopFmt:TabStopFormat = null;
         if(!this.isTextStringAndFormat())
         {
            return super.getTextFormat(beginIndex,endIndex);
         }
         var textFormat:TextFormat = new TextFormat();
         var curFormat:TextLayoutFormat = Boolean(this.hostFormat) ? TextLayoutFormat(this.hostFormat) : new TextLayoutFormat();
         if(curFormat.textAlign == TextFormatAlign.LEFT || curFormat.textAlign == TextFormatAlign.CENTER || curFormat.textAlign == TextFormatAlign.RIGHT || curFormat.textAlign == TextFormatAlign.JUSTIFY)
         {
            textFormat.align = curFormat.textAlign;
         }
         textFormat.bold = curFormat.fontWeight == FontWeight.BOLD;
         textFormat.color = curFormat.color;
         var arrFontFamily:Array = String(curFormat.fontFamily).split(",");
         textFormat.font = arrFontFamily[0];
         textFormat.indent = curFormat.textIndent;
         textFormat.italic = curFormat.fontStyle == FontPosture.ITALIC;
         textFormat.kerning = curFormat.kerning == Kerning.ON || curFormat.kerning == Kerning.AUTO;
         if(curFormat.lineHeight == undefined || curFormat.lineHeight < -720)
         {
            textFormat.leading = null;
         }
         else
         {
            leading = Number.NaN;
            str = curFormat.lineHeight;
            if(Boolean(str))
            {
               if(str.indexOf("%") == -1)
               {
                  leading = Number(str);
               }
               else
               {
                  leafFontSize = curFormat.fontSize;
                  leading = Number(str.replace(/%/,"")) * leafFontSize / 100;
               }
            }
            if(!isNaN(leading))
            {
               textFormat.leading = leading;
            }
         }
         textFormat.leftMargin = curFormat.paragraphStartIndent;
         textFormat.letterSpacing = curFormat.trackingRight;
         textFormat.rightMargin = curFormat.paragraphEndIndent;
         textFormat.size = curFormat.fontSize;
         var arrTabStops:Array = [];
         if(curFormat.tabStops != null)
         {
            arrLength = int(curFormat.tabStops.length);
            for(i = 0; i < arrLength; i++)
            {
               tabStopFmt = curFormat.tabStops[i];
               if(tabStopFmt.alignment == TabAlignment.DECIMAL)
               {
                  arrTabStops.push(tabStopFmt.position);
               }
            }
            arrTabStops.sort(Array.NUMERIC);
         }
         textFormat.tabStops = arrTabStops;
         textFormat.underline = curFormat.textDecoration == TextDecoration.UNDERLINE;
         return textFormat;
      }
      
      override public function setTextFormat(format:TextFormat, beginIndex:int, endIndex:int, charFormat:TextLayoutFormat, paraFormat:TextLayoutFormat) : void
      {
         var arrTabStops:Array = null;
         var tabStop:String = null;
         var tabStopFmt:TabStopFormat = null;
         if(!this.isTextStringAndFormat() || format.url != null || format.target != null)
         {
            super.setTextFormat(format,beginIndex,endIndex,charFormat,paraFormat);
            return;
         }
         var newFormat:TextLayoutFormat = new TextLayoutFormat();
         if(format.align != null)
         {
            if(format.align == TextFormatAlign.CENTER || format.align == TextFormatAlign.JUSTIFY || format.align == TextFormatAlign.LEFT || format.align == TextFormatAlign.RIGHT)
            {
               newFormat.textAlign = format.align;
            }
            else
            {
               newFormat.textAlign = TextFormatAlign.RIGHT;
            }
         }
         if(format.blockIndent != null && format.leftMargin != null)
         {
            newFormat.paragraphStartIndent = format.blockIndent + format.leftMargin;
         }
         else if(format.blockIndent != null)
         {
            newFormat.paragraphStartIndent = format.blockIndent;
         }
         else if(format.leftMargin != null)
         {
            newFormat.paragraphStartIndent = format.leftMargin;
         }
         if(format.indent != null)
         {
            newFormat.textIndent = format.indent;
         }
         if(format.leading != null)
         {
            newFormat.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
            newFormat.lineHeight = format.leading;
         }
         if(format.rightMargin != null)
         {
            newFormat.paragraphEndIndent = format.rightMargin;
         }
         if(format.tabStops != null)
         {
            arrTabStops = new Array();
            format.tabStops.sort(Array.NUMERIC);
            for each(tabStop in format.tabStops)
            {
               tabStopFmt = new TabStopFormat();
               tabStopFmt.alignment = TabAlignment.DECIMAL;
               tabStopFmt.position = int(tabStop);
               arrTabStops.push(tabStopFmt);
            }
            newFormat.tabStops = arrTabStops;
         }
         if(format.bold != null)
         {
            newFormat.fontWeight = Boolean(format.bold) ? FontWeight.BOLD : FontWeight.NORMAL;
         }
         if(format.color != null)
         {
            newFormat.color = format.color;
         }
         if(format.font != null)
         {
            newFormat.fontFamily = format.font;
         }
         if(format.italic != null)
         {
            newFormat.fontStyle = Boolean(format.italic) ? FontPosture.ITALIC : FontPosture.NORMAL;
         }
         if(format.kerning != null)
         {
            newFormat.kerning = Boolean(format.kerning) ? Kerning.ON : Kerning.OFF;
         }
         if(format.letterSpacing != null)
         {
            newFormat.trackingRight = format.letterSpacing;
         }
         if(format.size != null)
         {
            newFormat.fontSize = format.size;
         }
         if(format.underline != null)
         {
            newFormat.textDecoration = Boolean(format.underline) ? TextDecoration.UNDERLINE : TextDecoration.NONE;
         }
         var combinedHostFormat:TextLayoutFormat = TextLayoutFormat(this.hostFormat);
         combinedHostFormat.apply(newFormat);
         this.hostFormat = combinedHostFormat;
      }
      
      override public function get direction() : String
      {
         if(!this.isTextStringAndFormat())
         {
            return super.direction;
         }
         if(Boolean(this.hostFormat) && Boolean(this.hostFormat.direction))
         {
            return this.hostFormat.direction;
         }
         return Direction.LTR;
      }
      
      public function set editModeNoInteraction(value:String) : void
      {
         if(this._tcm.editingMode == value)
         {
            return;
         }
         if(value == EditingMode.READ_WRITE)
         {
            this._tcm.editingMode = EditingMode.READ_WRITE;
         }
         else if(value == EditingMode.READ_SELECT)
         {
            this._tcm.editingMode = EditingMode.READ_SELECT;
         }
         else
         {
            this._tcm.editingMode = EditingMode.READ_ONLY;
         }
      }
      
      override public function compose() : void
      {
         this._tcm.compose();
         _ownerField.tlf_internal::composeComplete(null);
      }
      
      public function set firstBaselineOffset(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.firstBaselineOffset = value;
         this._tcm.hostFormat = fmt;
         if(Boolean(this.controller))
         {
            this.controller.firstBaselineOffset = value;
         }
      }
      
      public function set editMode(value:String) : void
      {
         if(this._tcm.editingMode == value)
         {
            return;
         }
         if(value == EditingMode.READ_WRITE)
         {
            if(this._tcm.editingMode != EditingMode.READ_ONLY)
            {
               this._tcm.endInteraction();
            }
            this._tcm.editingMode = EditingMode.READ_WRITE;
            this._tcm.beginInteraction();
         }
         else if(value == EditingMode.READ_SELECT)
         {
            if(this._tcm.editingMode != EditingMode.READ_ONLY)
            {
               this._tcm.endInteraction();
            }
            this._tcm.editingMode = EditingMode.READ_SELECT;
            this._tcm.beginInteraction();
         }
         else
         {
            this._tcm.editingMode = EditingMode.READ_ONLY;
            this._tcm.endInteraction();
         }
      }
      
      public function get controller() : ContainerController
      {
         if(this.isTextStringAndFormat() || this._tcm.getTextFlow().flowComposer == null)
         {
            return null;
         }
         return this._tcm.getTextFlow().flowComposer.numControllers > 0 ? this._tcm.getTextFlow().flowComposer.getControllerAt(0) : null;
      }
      
      public function addListeners() : void
      {
         this._tcm.addEventListener(TextLayoutEvent.SCROLL,_ownerField.tlf_internal::textFlow_ScrollHandler,false,0,true);
         this._tcm.addEventListener(MouseEvent.CLICK,_ownerField.tlf_internal::linkClick,false,0,true);
         this._tcm.addEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,_ownerField.tlf_internal::textFlow_flowOperationBeginHandler,false,0,true);
         this._tcm.addEventListener(FlowOperationEvent.FLOW_OPERATION_END,_ownerField.tlf_internal::textFlow_flowOperationEndHandler,false,0,true);
         this._tcm.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,_ownerField.tlf_internal::composeComplete,false,0,true);
         this._tcm.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE,_ownerField.tlf_internal::updateComplete,false,0,true);
         _ownerField.addEventListener(FocusEvent.FOCUS_IN,this._tcm.focusInHandler,false,0,true);
      }
      
      override public function setFormatForAllElements(flowGroupElem:FlowGroupElement, format:TextLayoutFormat) : void
      {
         var fmt:TextLayoutFormat = null;
         if(this.isTextStringAndFormat())
         {
            fmt = Boolean(this.hostFormat) ? TextLayoutFormat(this.hostFormat) : new TextLayoutFormat();
            fmt.apply(format);
            this.hostFormat = fmt;
         }
         else
         {
            super.setFormatForAllElements(flowGroupElem,format);
         }
      }
      
      public function get columnGap() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return 20;
         }
         return this._tcm.hostFormat.columnGap == FormatValue.INHERIT ? 20 : this._tcm.hostFormat.columnGap;
      }
      
      private function ConvertContainerValuesToHostFormat(fmt:TextLayoutFormat) : void
      {
         if(fmt != null && this.controller != null)
         {
            fmt.paddingLeft = this.controller.paddingLeft;
            fmt.paddingTop = this.controller.paddingTop;
            fmt.paddingRight = this.controller.paddingRight;
            fmt.paddingBottom = this.controller.paddingBottom;
            fmt.verticalAlign = this.controller.verticalAlign;
            fmt.columnCount = this.controller.columnCount;
            fmt.columnGap = this.controller.columnGap;
            fmt.columnWidth = this.controller.columnWidth;
         }
      }
      
      public function get paddingRight() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return this.controller.paddingRight;
         }
         if(this._tcm.hostFormat == null)
         {
            return 2;
         }
         return this._tcm.hostFormat.paddingRight;
      }
      
      public function set columnCount(value:Object) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.columnCount = value;
         this._tcm.hostFormat = fmt;
         if(Boolean(this.controller))
         {
            this.controller.columnCount = value;
         }
      }
      
      public function convert(cls:Class) : IContainerManager
      {
         var hostFmt:TextLayoutFormat = null;
         if(this is cls)
         {
            return this;
         }
         if(this.textFlow && this.textFlow.flowComposer && !this.textFlow.flowComposer.composing)
         {
            this.update();
         }
         var multiTCM:MultiTextContainerManager = new MultiTextContainerManager(_container,_ownerField,_controller);
         multiTCM.textFlow = this.textFlow;
         multiTCM.editMode = this._tcm.editingMode;
         multiTCM.setCompositionSize(this.compositionWidth,this.compositionHeight);
         multiTCM.paddingBottom = this.paddingBottom;
         multiTCM.paddingLeft = this.paddingLeft;
         multiTCM.paddingRight = this.paddingRight;
         multiTCM.paddingTop = this.paddingTop;
         multiTCM.columnCount = this.columnCount;
         if(Boolean(this.hostFormat))
         {
            hostFmt = this.hostFormat as TextLayoutFormat;
            hostFmt.paddingBottom = 0;
            hostFmt.paddingLeft = 0;
            hostFmt.paddingRight = 0;
            hostFmt.paddingTop = 0;
            multiTCM.hostFormat = hostFmt;
         }
         multiTCM.columnGap = this.columnGap;
         multiTCM.columnWidth = this.columnWidth;
         multiTCM.firstBaselineOffset = this.firstBaselineOffset;
         multiTCM.verticalAlign = this.verticalAlign;
         multiTCM.horizontalScrollPosition = this.horizontalScrollPosition;
         multiTCM.verticalScrollPosition = this.verticalScrollPosition;
         multiTCM.direction = this.direction;
         this._tcm.tlf_internal::convertToTextFlowWithComposer();
         if(Boolean(this.textFlow))
         {
            if(this.textFlow.flowComposer == null)
            {
               this.textFlow.flowComposer = new this.textFlow.configuration.flowComposerClass();
            }
            this.textFlow.flowComposer.removeAllControllers();
            this.textFlow.flowComposer.addController(multiTCM.controller);
         }
         _container.removeEventListener(MouseEvent.MOUSE_OVER,this._tcm.tlf_internal::requiredMouseOverHandler);
         _container.removeEventListener(FocusEvent.FOCUS_IN,this._tcm.tlf_internal::requiredFocusInHandler);
         _container.removeEventListener(MouseEvent.MOUSE_OVER,this._tcm.tlf_internal::requiredMouseOverHandler);
         _container.removeEventListener(MouseEvent.MOUSE_DOWN,this._tcm.mouseDownHandler);
         _container.removeEventListener(MouseEvent.MOUSE_OUT,this._tcm.mouseOutHandler);
         _container.removeEventListener(MouseEvent.MOUSE_WHEEL,this._tcm.mouseWheelHandler);
         _container.removeEventListener("imeStartComposition",this._tcm.imeStartCompositionHandler);
         if(Boolean(_container.contextMenu))
         {
            _container.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT,this._tcm.menuSelectHandler);
         }
         _container.removeEventListener(Event.SELECT_ALL,this._tcm.editHandler);
         this.removeListeners();
         multiTCM.addListeners();
         this._tcm = null;
         _ownerField = null;
         _container = null;
         return multiTCM;
      }
      
      public function get antialiasType() : String
      {
         if(Boolean(this._tcm.hostFormat))
         {
            return this._tcm.hostFormat.renderingMode == RenderingMode.NORMAL ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
         }
         return AntiAliasType.NORMAL;
      }
      
      public function get paddingLeft() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return this.controller.paddingLeft;
         }
         if(this._tcm.hostFormat == null)
         {
            return 2;
         }
         return this._tcm.hostFormat.paddingLeft;
      }
      
      public function set horizontalScrollPosition(value:Number) : void
      {
         this._tcm.horizontalScrollPosition = value;
      }
      
      public function get paddingBottom() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return this.controller.paddingBottom;
         }
         if(this._tcm.hostFormat == null)
         {
            return 2;
         }
         return this._tcm.hostFormat.paddingBottom;
      }
      
      override public function get hostFormat() : ITextLayoutFormat
      {
         var hostFmt:TextLayoutFormat = null;
         if(this.isTextStringAndFormat())
         {
            hostFmt = this._tcm.hostFormat as TextLayoutFormat;
         }
         else
         {
            hostFmt = this._tcm.getTextFlow().hostFormat as TextLayoutFormat;
            this.ConvertContainerValuesToHostFormat(hostFmt);
         }
         return hostFmt;
      }
      
      public function get contentWidth() : Number
      {
         return this._tcm.getContentBounds().width;
      }
      
      override public function update() : void
      {
         this._tcm.updateContainer();
         _ownerField.tlf_internal::composeComplete(null);
      }
      
      override public function get embedFonts() : Boolean
      {
         if(!this.isTextStringAndFormat())
         {
            return super.embedFonts;
         }
         if(Boolean(this.hostFormat))
         {
            return this.hostFormat.fontLookup == FontLookup.EMBEDDED_CFF;
         }
         return false;
      }
      
      override public function set embedFonts(value:Boolean) : void
      {
         var fmt:TextLayoutFormat = null;
         if(!this.isTextStringAndFormat())
         {
            super.embedFonts = value;
         }
         else
         {
            fmt = Boolean(this.hostFormat) ? TextLayoutFormat(this.hostFormat) : new TextLayoutFormat();
            fmt.fontLookup = value ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
            this.hostFormat = fmt;
         }
      }
      
      override public function set lineBreak(value:String) : void
      {
         var format:TextLayoutFormat = null;
         if(!this.isTextStringAndFormat())
         {
            super.lineBreak = value;
         }
         else
         {
            format = Boolean(this.hostFormat) ? TextLayoutFormat(this.hostFormat) : new TextLayoutFormat();
            format.lineBreak = value;
            this.hostFormat = format;
         }
      }
      
      public function set antialiasType(value:String) : void
      {
         var fmt:TextLayoutFormat = Boolean(this._tcm.hostFormat) ? TextLayoutFormat(this._tcm.hostFormat) : new TextLayoutFormat();
         fmt.renderingMode = value == AntiAliasType.ADVANCED ? RenderingMode.CFF : RenderingMode.NORMAL;
         this._tcm.hostFormat = fmt;
      }
      
      override public function set blockProgression(value:Object) : void
      {
         if(!this.isTextStringAndFormat())
         {
            super.blockProgression = value;
            return;
         }
         var fmt:TextLayoutFormat = Boolean(this.hostFormat) ? TextLayoutFormat(this.hostFormat) : new TextLayoutFormat();
         switch(value)
         {
            case BlockProgression.RL:
            case BlockProgression.TB:
            case FormatValue.INHERIT:
               fmt.blockProgression = value;
               break;
            default:
               fmt.blockProgression = BlockProgression.TB;
         }
         this.hostFormat = fmt;
      }
      
      override public function get blockProgression() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return super.blockProgression;
         }
         if(Boolean(this.hostFormat) && Boolean(this.hostFormat.blockProgression))
         {
            return this.hostFormat.blockProgression;
         }
         return BlockProgression.TB;
      }
      
      override public function set textFlow(theFlow:TextFlow) : void
      {
         this._tcm.setTextFlow(theFlow);
      }
   }
}
