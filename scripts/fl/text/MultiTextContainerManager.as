package fl.text
{
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.engine.RenderingMode;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.conversion.ConversionType;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.CompositionCompleteEvent;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.events.TextLayoutEvent;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   [ExcludeClass]
   class MultiTextContainerManager extends CommonTextContainerManager implements IContainerManager
   {
       
      
      private var _textFlow:TextFlow;
      
      private var _hostFormat:TextLayoutFormat;
      
      function MultiTextContainerManager(container:Sprite, ownerField:TLFTextField, controller:ContainerController = null)
      {
         super();
         _container = container;
         _ownerField = ownerField;
         this._hostFormat = new TextLayoutFormat();
         _controller = controller != null ? controller : ownerField.initController(_container);
         _ownerField.addEventListener(FocusEvent.FOCUS_IN,_controller.focusInHandler);
      }
      
      public function get contentHeight() : Number
      {
         return _controller.contentHeight;
      }
      
      public function get firstBaselineOffset() : Object
      {
         return _controller.firstBaselineOffset;
      }
      
      public function setCompositionSize(width:Number, height:Number) : void
      {
         _controller.setCompositionSize(width,height);
      }
      
      public function set paddingRight(value:Object) : void
      {
         _controller.paddingRight = value;
      }
      
      public function get columnWidth() : Object
      {
         return _controller.columnWidth;
      }
      
      public function get numLines() : int
      {
         return this._textFlow.flowComposer.numLines;
      }
      
      public function removeListeners() : void
      {
         this.textFlow.removeEventListener(TextLayoutEvent.SCROLL,_ownerField.textFlow_ScrollHandler);
         this.textFlow.removeEventListener(MouseEvent.CLICK,_ownerField.linkClick);
         this.textFlow.removeEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,_ownerField.textFlow_flowOperationBeginHandler);
         this.textFlow.removeEventListener(FlowOperationEvent.FLOW_OPERATION_END,_ownerField.textFlow_flowOperationEndHandler);
         this.textFlow.removeEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,_ownerField.composeComplete);
         _ownerField.removeEventListener(FocusEvent.FOCUS_IN,_controller.focusInHandler);
      }
      
      public function set columnWidth(value:Object) : void
      {
         _controller.columnWidth = value;
      }
      
      public function get contentTop() : Number
      {
         return _controller.contentTop;
      }
      
      override public function isTextStringAndFormat() : Boolean
      {
         return false;
      }
      
      public function set paddingTop(value:Object) : void
      {
         _controller.paddingTop = value;
      }
      
      public function get verticalScrollPosition() : Number
      {
         return _controller.verticalScrollPosition;
      }
      
      public function get contentLeft() : Number
      {
         return _controller.contentLeft;
      }
      
      public function set firstBaselineOffset(value:Object) : void
      {
         _controller.firstBaselineOffset = value;
      }
      
      public function get text() : String
      {
         if(!this._textFlow)
         {
            return "";
         }
         var temp:String = TextConverter.export(this._textFlow,TextConverter.PLAIN_TEXT_FORMAT,ConversionType.STRING_TYPE) as String;
         _ownerField.generationID = this.textFlow.generation;
         return temp;
      }
      
      public function get absoluteStart() : int
      {
         return _controller.absoluteStart;
      }
      
      public function get compositionWidth() : Number
      {
         return _controller.compositionWidth;
      }
      
      public function set antialiasType(value:String) : void
      {
         if(this._textFlow)
         {
            this._textFlow.renderingMode = value == AntiAliasType.ADVANCED ? RenderingMode.CFF : RenderingMode.NORMAL;
         }
      }
      
      public function set paddingBottom(value:Object) : void
      {
         _controller.paddingBottom = value;
      }
      
      public function set columnGap(value:Object) : void
      {
         _controller.columnGap = value;
      }
      
      public function get verticalAlign() : Object
      {
         return _controller.verticalAlign;
      }
      
      public function set verticalScrollPosition(value:Number) : void
      {
         _controller.verticalScrollPosition = value;
      }
      
      public function get columnCount() : Object
      {
         return _controller.columnCount;
      }
      
      public function getLineIndexBounds(index:int) : Rectangle
      {
         var tl:TextFlowLine = this.textFlow.flowComposer.getLineAt(index);
         return tl.getBounds();
      }
      
      public function set verticalAlign(value:Object) : void
      {
         _controller.verticalAlign = value;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return _controller.horizontalScrollPosition;
      }
      
      public function set paddingLeft(value:Object) : void
      {
         _controller.paddingLeft = value;
      }
      
      override public function get textLength() : int
      {
         return _controller.textLength - 1;
      }
      
      public function get compositionHeight() : Number
      {
         return _controller.compositionHeight;
      }
      
      public function get paddingTop() : Object
      {
         return _controller.paddingTop;
      }
      
      public function set hostFormat(value:ITextLayoutFormat) : void
      {
         var oldGeneration:uint = 0;
         this._hostFormat = TextLayoutFormat(value);
         if(this._textFlow)
         {
            oldGeneration = this._textFlow.generation;
            this._textFlow.hostFormat = value;
            this._textFlow.setGeneration(oldGeneration);
         }
      }
      
      public function set editModeNoInteraction(value:String) : void
      {
         this.editMode = value;
      }
      
      override public function compose() : void
      {
         this._textFlow.flowComposer.composeToPosition();
      }
      
      public function addListeners() : void
      {
         this.textFlow.addEventListener(TextLayoutEvent.SCROLL,_ownerField.textFlow_ScrollHandler,false,0,true);
         this.textFlow.addEventListener(MouseEvent.CLICK,_ownerField.linkClick,false,0,true);
         this.textFlow.addEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,_ownerField.textFlow_flowOperationBeginHandler,false,0,true);
         this.textFlow.addEventListener(FlowOperationEvent.FLOW_OPERATION_END,_ownerField.textFlow_flowOperationEndHandler,false,0,true);
         this.textFlow.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,_ownerField.composeComplete,false,0,true);
         _ownerField.addEventListener(FocusEvent.FOCUS_IN,_controller.focusInHandler,false,0,true);
      }
      
      public function get columnGap() : Object
      {
         return _controller.columnGap;
      }
      
      public function set editMode(value:String) : void
      {
         var interactionMgr:ISelectionManager = this._textFlow.interactionManager;
         if(value == EditingMode.READ_WRITE)
         {
            if(!(interactionMgr is EditManager))
            {
               this._textFlow.interactionManager = new EditManager();
            }
         }
         else if(value == EditingMode.READ_SELECT)
         {
            if(interactionMgr == null || interactionMgr is EditManager)
            {
               this._textFlow.interactionManager = new SelectionManager();
            }
         }
         else
         {
            this._textFlow.interactionManager = null;
         }
      }
      
      public function get controller() : ContainerController
      {
         return _controller;
      }
      
      public function get antialiasType() : String
      {
         if(this._textFlow)
         {
            return this._textFlow.renderingMode == RenderingMode.NORMAL ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
         }
         return AntiAliasType.NORMAL;
      }
      
      public function get paddingRight() : Object
      {
         return _controller.paddingRight;
      }
      
      public function set columnCount(value:Object) : void
      {
         _controller.columnCount = value;
      }
      
      public function convert(cls:Class) : IContainerManager
      {
         if(this is cls)
         {
            return this;
         }
         var singleTCM:SingleTextContainerManager = new SingleTextContainerManager(_container,_ownerField,_controller);
         singleTCM.textFlow = this._textFlow;
         singleTCM.setCompositionSize(this.compositionWidth,this.compositionHeight);
         singleTCM.hostFormat = this.hostFormat;
         singleTCM.paddingBottom = this.paddingBottom;
         singleTCM.paddingLeft = this.paddingLeft;
         singleTCM.paddingRight = this.paddingRight;
         singleTCM.paddingTop = this.paddingTop;
         singleTCM.columnCount = this.columnCount;
         singleTCM.columnGap = this.columnGap;
         singleTCM.columnWidth = this.columnWidth;
         singleTCM.firstBaselineOffset = this.firstBaselineOffset;
         singleTCM.verticalAlign = this.verticalAlign;
         singleTCM.horizontalScrollPosition = this.horizontalScrollPosition;
         singleTCM.verticalScrollPosition = this.verticalScrollPosition;
         _ownerField = null;
         _container = null;
         _controller = null;
         return singleTCM;
      }
      
      public function get paddingLeft() : Object
      {
         return _controller.paddingLeft;
      }
      
      public function set horizontalScrollPosition(value:Number) : void
      {
         _controller.horizontalScrollPosition = value;
      }
      
      public function get paddingBottom() : Object
      {
         return _controller.paddingBottom;
      }
      
      override public function get hostFormat() : ITextLayoutFormat
      {
         return this._textFlow.hostFormat;
      }
      
      public function get contentWidth() : Number
      {
         return _controller.contentWidth;
      }
      
      override public function update() : void
      {
         if(this._textFlow)
         {
            this._textFlow.flowComposer.updateAllControllers();
         }
      }
      
      override public function get textFlow() : TextFlow
      {
         return this._textFlow;
      }
      
      override public function set textFlow(theFlow:TextFlow) : void
      {
         this._textFlow = theFlow;
      }
   }
}
