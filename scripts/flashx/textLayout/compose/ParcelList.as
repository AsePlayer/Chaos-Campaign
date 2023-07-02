package flashx.textLayout.compose
{
   import flash.geom.Rectangle;
   import flash.text.engine.TextLine;
   import flashx.textLayout.container.ColumnState;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   public class ParcelList
   {
      
      private static const MAX_HEIGHT:Number = 900000000;
      
      private static const MAX_WIDTH:Number = 900000000;
      
      private static var _sharedParcelList:flashx.textLayout.compose.ParcelList;
       
      
      protected var _flowComposer:flashx.textLayout.compose.IFlowComposer;
      
      protected var _totalDepth:Number;
      
      protected var _hasContent:Boolean;
      
      protected var _parcelArray:Array;
      
      protected var _numParcels:int;
      
      protected var _singleParcel:flashx.textLayout.compose.Parcel;
      
      protected var _currentParcelIndex:int;
      
      protected var _currentParcel:flashx.textLayout.compose.Parcel;
      
      protected var _insideListItemMargin:Number;
      
      protected var _leftMargin:Number;
      
      protected var _rightMargin:Number;
      
      protected var _explicitLineBreaks:Boolean;
      
      protected var _verticalText:Boolean;
      
      public function ParcelList()
      {
         super();
         this._numParcels = 0;
      }
      
      tlf_internal static function getParcelList() : flashx.textLayout.compose.ParcelList
      {
         var rslt:flashx.textLayout.compose.ParcelList = Boolean(_sharedParcelList) ? _sharedParcelList : new flashx.textLayout.compose.ParcelList();
         _sharedParcelList = null;
         return rslt;
      }
      
      tlf_internal static function releaseParcelList(list:flashx.textLayout.compose.ParcelList) : void
      {
         if(_sharedParcelList == null)
         {
            _sharedParcelList = list as ParcelList;
            if(Boolean(_sharedParcelList))
            {
               _sharedParcelList.tlf_internal::releaseAnyReferences();
            }
         }
      }
      
      tlf_internal function releaseAnyReferences() : void
      {
         this._flowComposer = null;
         this._numParcels = 0;
         this._parcelArray = null;
         if(Boolean(this._singleParcel))
         {
            this._singleParcel.tlf_internal::releaseAnyReferences();
         }
      }
      
      public function getParcelAt(idx:int) : flashx.textLayout.compose.Parcel
      {
         return this._numParcels <= 1 ? this._singleParcel : this._parcelArray[idx];
      }
      
      public function get currentParcelIndex() : int
      {
         return this._currentParcelIndex;
      }
      
      public function get explicitLineBreaks() : Boolean
      {
         return this._explicitLineBreaks;
      }
      
      private function get measureLogicalWidth() : Boolean
      {
         if(this._explicitLineBreaks)
         {
            return true;
         }
         if(!this._currentParcel)
         {
            return false;
         }
         var controller:ContainerController = this._currentParcel.controller;
         return this._verticalText ? Boolean(controller.tlf_internal::measureHeight) : Boolean(controller.tlf_internal::measureWidth);
      }
      
      private function get measureLogicalHeight() : Boolean
      {
         if(!this._currentParcel)
         {
            return false;
         }
         var controller:ContainerController = this._currentParcel.controller;
         return this._verticalText ? Boolean(controller.tlf_internal::measureWidth) : Boolean(controller.tlf_internal::measureHeight);
      }
      
      public function get totalDepth() : Number
      {
         return this._totalDepth;
      }
      
      public function addTotalDepth(value:Number) : Number
      {
         this._totalDepth += value;
         return this._totalDepth;
      }
      
      protected function reset() : void
      {
         this._totalDepth = 0;
         this._hasContent = false;
         this._currentParcelIndex = -1;
         this._currentParcel = null;
         this._leftMargin = 0;
         this._rightMargin = 0;
         this._insideListItemMargin = 0;
      }
      
      private function addParcel(column:Rectangle, controller:ContainerController, columnIndex:int) : void
      {
         var newParcel:flashx.textLayout.compose.Parcel = this._numParcels == 0 && Boolean(this._singleParcel) ? this._singleParcel.initialize(this._verticalText,column.x,column.y,column.width,column.height,controller,columnIndex) : new flashx.textLayout.compose.Parcel(this._verticalText,column.x,column.y,column.width,column.height,controller,columnIndex);
         if(this._numParcels == 0)
         {
            this._singleParcel = newParcel;
         }
         else if(this._numParcels == 1)
         {
            this._parcelArray = [this._singleParcel,newParcel];
         }
         else
         {
            this._parcelArray.push(newParcel);
         }
         ++this._numParcels;
      }
      
      protected function addOneControllerToParcelList(controllerToInitialize:ContainerController) : void
      {
         var column:Rectangle = null;
         var columnState:ColumnState = controllerToInitialize.columnState;
         for(var columnIndex:int = 0; columnIndex < columnState.columnCount; columnIndex++)
         {
            column = columnState.getColumnAt(columnIndex);
            if(!column.isEmpty())
            {
               this.addParcel(column,controllerToInitialize,columnIndex);
            }
         }
      }
      
      public function beginCompose(composer:flashx.textLayout.compose.IFlowComposer, controllerStartIndex:int, controllerEndIndex:int, composeToPosition:Boolean) : void
      {
         var idx:int = 0;
         this._flowComposer = composer;
         var rootFormat:ITextLayoutFormat = composer.rootElement.computedFormat;
         this._explicitLineBreaks = rootFormat.lineBreak == LineBreak.EXPLICIT;
         this._verticalText = rootFormat.blockProgression == BlockProgression.RL;
         if(composer.numControllers != 0)
         {
            if(controllerEndIndex < 0)
            {
               controllerEndIndex = composer.numControllers - 1;
            }
            else
            {
               controllerEndIndex = Math.min(controllerEndIndex,composer.numControllers - 1);
            }
            idx = controllerStartIndex;
            do
            {
               this.addOneControllerToParcelList(ContainerController(composer.getControllerAt(idx)));
            }
            while(idx++ != controllerEndIndex);
            
            if(controllerEndIndex == composer.numControllers - 1)
            {
               this.adjustForScroll(composer.getControllerAt(composer.numControllers - 1),composeToPosition);
            }
         }
         this.reset();
      }
      
      private function adjustForScroll(containerToInitialize:ContainerController, composeToPosition:Boolean) : void
      {
         var horizontalPaddingAmount:Number = NaN;
         var right:Number = NaN;
         var p:flashx.textLayout.compose.Parcel = null;
         var verticalPaddingAmount:Number = NaN;
         if(this._verticalText)
         {
            if(containerToInitialize.horizontalScrollPolicy != ScrollPolicy.OFF)
            {
               p = this.getParcelAt(this._numParcels - 1);
               if(Boolean(p))
               {
                  horizontalPaddingAmount = containerToInitialize.tlf_internal::getTotalPaddingRight() + containerToInitialize.tlf_internal::getTotalPaddingLeft();
                  right = p.right;
                  p.x = containerToInitialize.horizontalScrollPosition - p.width - horizontalPaddingAmount;
                  p.width = right - p.x;
                  p.fitAny = true;
                  p.composeToPosition = composeToPosition;
               }
            }
         }
         else if(containerToInitialize.verticalScrollPolicy != ScrollPolicy.OFF)
         {
            p = this.getParcelAt(this._numParcels - 1);
            if(Boolean(p))
            {
               verticalPaddingAmount = containerToInitialize.tlf_internal::getTotalPaddingBottom() + containerToInitialize.tlf_internal::getTotalPaddingTop();
               p.height = containerToInitialize.verticalScrollPosition + p.height + verticalPaddingAmount - p.y;
               p.fitAny = true;
               p.composeToPosition = composeToPosition;
            }
         }
      }
      
      public function get leftMargin() : Number
      {
         return this._leftMargin;
      }
      
      public function pushLeftMargin(leftMargin:Number) : void
      {
         this._leftMargin += leftMargin;
      }
      
      public function popLeftMargin(leftMargin:Number) : void
      {
         this._leftMargin -= leftMargin;
      }
      
      public function get rightMargin() : Number
      {
         return this._rightMargin;
      }
      
      public function pushRightMargin(rightMargin:Number) : void
      {
         this._rightMargin += rightMargin;
      }
      
      public function popRightMargin(rightMargin:Number) : void
      {
         this._rightMargin -= rightMargin;
      }
      
      public function pushInsideListItemMargin(margin:Number) : void
      {
         this._insideListItemMargin += margin;
      }
      
      public function popInsideListItemMargin(margin:Number) : void
      {
         this._insideListItemMargin -= margin;
      }
      
      public function get insideListItemMargin() : Number
      {
         return this._insideListItemMargin;
      }
      
      public function getComposeXCoord(o:Rectangle) : Number
      {
         return this._verticalText ? o.right : o.left;
      }
      
      public function getComposeYCoord(o:Rectangle) : Number
      {
         return o.top;
      }
      
      public function getComposeWidth(o:Rectangle) : Number
      {
         if(this.measureLogicalWidth)
         {
            return TextLine.MAX_LINE_WIDTH;
         }
         return this._verticalText ? o.height : o.width;
      }
      
      public function getComposeHeight(o:Rectangle) : Number
      {
         if(this.measureLogicalHeight)
         {
            return TextLine.MAX_LINE_WIDTH;
         }
         return this._verticalText ? o.width : o.height;
      }
      
      public function atLast() : Boolean
      {
         return this._numParcels == 0 || this._currentParcelIndex == this._numParcels - 1;
      }
      
      public function atEnd() : Boolean
      {
         return this._numParcels == 0 || this._currentParcelIndex >= this._numParcels;
      }
      
      public function next() : Boolean
      {
         var nextController:ContainerController = null;
         var nextParcelIsValid:Boolean = this._currentParcelIndex + 1 < this._numParcels;
         this._currentParcelIndex += 1;
         this._totalDepth = 0;
         if(nextParcelIsValid)
         {
            this._currentParcel = this.getParcelAt(this._currentParcelIndex);
            nextController = this._currentParcel.controller;
         }
         else
         {
            this._currentParcel = null;
         }
         return nextParcelIsValid;
      }
      
      public function get currentParcel() : flashx.textLayout.compose.Parcel
      {
         return this._currentParcel;
      }
      
      public function getLineSlug(slug:Slug, height:Number, minWidth:Number, textIndent:Number, directionLTR:Boolean) : Boolean
      {
         if(this.currentParcel.getLineSlug(slug,this._totalDepth,height,minWidth,this.currentParcel.fitAny ? 1 : int(height),this._leftMargin,this._rightMargin,textIndent + this._insideListItemMargin,directionLTR,this._explicitLineBreaks))
         {
            if(this.totalDepth != slug.depth)
            {
               this._totalDepth = slug.depth;
            }
            return true;
         }
         return false;
      }
      
      public function fitFloat(slug:Slug, totalDepth:Number, width:Number, height:Number) : Boolean
      {
         return this.currentParcel.getLineSlug(slug,totalDepth,height,width,this.currentParcel.fitAny ? 1 : int(height),this._leftMargin,this._rightMargin,0,true,this._explicitLineBreaks);
      }
   }
}
