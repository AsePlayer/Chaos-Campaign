package fl.text
{
   import flash.display.CapsStyle;
   import flash.display.DisplayObjectContainer;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   [ExcludeClass]
   public class TCMText extends Sprite
   {
      
      tlf_internal static var genericFonts:Array = ["_sans","_serif","_typewriter","_gothic","_gothicMono","_mincho","_ゴシック","_等幅","_明朝"];
       
      
      private var _border:Boolean;
      
      private var _background:Boolean;
      
      private var _backgroundAlpha:Number;
      
      private var _borderAlpha:Number;
      
      private var _borderColor:uint;
      
      private var _bgShape:Shape;
      
      private var _tcmStage:Sprite;
      
      private var _backgroundColor:uint;
      
      private var _inRepaint:Boolean;
      
      private var _tcm:TextContainerManager;
      
      private var _invalid:Boolean;
      
      private var _borderWidth:Number;
      
      public function TCMText()
      {
         var container:DisplayObjectContainer = null;
         super();
         tabEnabled = false;
         focusRect = false;
         this._bgShape = new Shape();
         this._tcmStage = new Sprite();
         addChild(this._bgShape);
         addChild(this._tcmStage);
         this._tcmStage.tabEnabled = true;
         this._tcm = new TLFTextContainerManager(this._tcmStage,Configuration(TCMRuntimeManager.getGlobalConfig()));
         try
         {
            if(this.parent != null)
            {
               container = parent as DisplayObjectContainer;
               if(container != null)
               {
                  TCMRuntimeManager.getSingleton().initInstance(this,container);
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function set border(value:Boolean) : void
      {
         if(this._border != value)
         {
            this._border = value;
            this.invalidate();
         }
      }
      
      private function invalidate() : void
      {
         if(this._invalid)
         {
            return;
         }
         if(stage != null)
         {
            try
            {
               stage.addEventListener(Event.RENDER,this.repaint,false,0,true);
               stage.invalidate();
            }
            catch(se:SecurityError)
            {
               addEventListener(Event.FRAME_CONSTRUCTED,repaint,false,0,true);
            }
         }
         else if(parent == null)
         {
            addEventListener(Event.ADDED,this.repaint,false,0,true);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.repaint,false,0,true);
            addEventListener(Event.FRAME_CONSTRUCTED,this.repaint,false,0,true);
         }
         this._invalid = true;
      }
      
      public function set borderWidth(value:Number) : void
      {
         if(this._borderWidth != value)
         {
            this._borderWidth = value;
            if(this._borderWidth < 1)
            {
               this.borderWidth = 1;
            }
            else if(this._borderWidth > 100)
            {
               this._borderWidth = 100;
            }
            this.invalidate();
         }
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set borderColor(value:uint) : void
      {
         if(this._borderColor != value)
         {
            this._borderColor = value & 16777215;
            this.invalidate();
         }
      }
      
      public function get borderWidth() : Number
      {
         return this._borderWidth;
      }
      
      public function get backgroundAlpha() : Number
      {
         return this._backgroundAlpha;
      }
      
      public function set scrollV(value:int) : void
      {
         var blockProg:String = !!this.UsingTextFlow() ? this._tcm.getTextFlow().blockProgression : this._tcm.hostFormat.blockProgression;
         if(value < 0)
         {
            value = 0;
         }
         else if(value > this.maxScrollV)
         {
            value = this.maxScrollV;
         }
         if(blockProg == BlockProgression.RL)
         {
            this._tcm.horizontalScrollPosition = -value;
         }
         else
         {
            this._tcm.verticalScrollPosition = value;
         }
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function get maxScrollH() : int
      {
         var blockProg:String = !!this.UsingTextFlow() ? this._tcm.getTextFlow().blockProgression : this._tcm.hostFormat.blockProgression;
         var bounds:Rectangle = this._tcm.getContentBounds();
         var maxScroll:int = blockProg == BlockProgression.RL ? int(bounds.height - this._tcm.compositionHeight) : int(bounds.width - this._tcm.compositionWidth);
         return maxScroll > 0 ? int(maxScroll) : int(0);
      }
      
      public function get borderAlpha() : Number
      {
         return this._borderAlpha;
      }
      
      public function get scrollH() : int
      {
         var blockProg:String = !!this.UsingTextFlow() ? this._tcm.getTextFlow().blockProgression : this._tcm.hostFormat.blockProgression;
         return blockProg == BlockProgression.RL ? int(Math.abs(this._tcm.verticalScrollPosition)) : int(Math.abs(this._tcm.horizontalScrollPosition));
      }
      
      public function set background(value:Boolean) : void
      {
         if(this._background != value)
         {
            this._background = value;
            this.invalidate();
         }
      }
      
      public function get tcm() : TextContainerManager
      {
         return this._tcm;
      }
      
      public function set backgroundAlpha(value:Number) : void
      {
         if(this._backgroundAlpha != value)
         {
            this._backgroundAlpha = value;
            if(this._backgroundAlpha < 0)
            {
               this._backgroundAlpha = 0;
            }
            else if(this._backgroundAlpha > 1)
            {
               this._backgroundAlpha = 1;
            }
            this.invalidate();
         }
      }
      
      tlf_internal function repaint(e:Event) : void
      {
         var contHeight:Number = NaN;
         var contWidth:Number = NaN;
         if(this._inRepaint)
         {
            return;
         }
         this._inRepaint = true;
         if(e != null)
         {
            if(e.type == Event.ADDED && e.target != this)
            {
               this._inRepaint = false;
               return;
            }
            removeEventListener(Event.ADDED,this.repaint);
            removeEventListener(Event.ADDED_TO_STAGE,this.repaint);
            removeEventListener(Event.FRAME_CONSTRUCTED,this.repaint);
            try
            {
               if(stage != null)
               {
                  stage.removeEventListener(Event.RENDER,this.repaint);
               }
               else if(e.type == Event.RENDER)
               {
                  e.target.removeEventListener(Event.RENDER,this.repaint);
               }
            }
            catch(se:SecurityError)
            {
            }
         }
         this._tcm.updateContainer();
         var origin:Number = !!this._border ? Number(-this._borderWidth / 2) : Number(0);
         if(this._background || this._border)
         {
            graphics.clear();
            if(this._background)
            {
               graphics.beginFill(this._backgroundColor,this._backgroundAlpha);
            }
            if(this._border)
            {
               graphics.lineStyle(this._borderWidth,this._borderColor,this._borderAlpha,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,10);
            }
            contHeight = this._tcm.compositionHeight;
            if(isNaN(contHeight))
            {
               contHeight = this._tcm.getContentBounds().height;
            }
            if(this._border)
            {
               contHeight += this._borderWidth;
            }
            contWidth = this._tcm.compositionWidth;
            if(isNaN(contWidth))
            {
               contWidth = this._tcm.getContentBounds().width;
            }
            if(this._border)
            {
               contWidth += this._borderWidth;
            }
            graphics.drawRect(origin,origin,contWidth,contHeight);
            if(this._background)
            {
               graphics.endFill();
            }
         }
         else
         {
            contHeight = this._tcm.compositionHeight;
            if(isNaN(contHeight))
            {
               contHeight = this._tcm.getContentBounds().height;
            }
            contWidth = this._tcm.compositionWidth;
            if(isNaN(contWidth))
            {
               contWidth = this._tcm.getContentBounds().width;
            }
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(0,0);
            this._bgShape.graphics.drawRect(0,0,contWidth,contHeight);
            this._bgShape.visible = false;
         }
         this._invalid = false;
         this._inRepaint = false;
      }
      
      public function set borderAlpha(value:Number) : void
      {
         if(this._borderAlpha != value)
         {
            this._borderAlpha = value;
            if(this._borderAlpha < 0)
            {
               this._borderAlpha = 0;
            }
            else if(this._borderAlpha > 1)
            {
               this._borderAlpha = 1;
            }
            this.invalidate();
         }
      }
      
      public function get scrollV() : int
      {
         var blockProg:String = !!this.UsingTextFlow() ? this._tcm.getTextFlow().blockProgression : this._tcm.hostFormat.blockProgression;
         return blockProg == BlockProgression.RL ? int(Math.abs(this._tcm.horizontalScrollPosition)) : int(Math.abs(this._tcm.verticalScrollPosition));
      }
      
      public function set backgroundColor(value:uint) : void
      {
         if(this._backgroundColor != value)
         {
            this._backgroundColor = value & 16777215;
            this.invalidate();
         }
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function get maxScrollV() : int
      {
         var blockProg:String = !!this.UsingTextFlow() ? this._tcm.getTextFlow().blockProgression : this._tcm.hostFormat.blockProgression;
         var bounds:Rectangle = this._tcm.getContentBounds();
         var maxScroll:int = blockProg == BlockProgression.RL ? int(bounds.width - this._tcm.compositionWidth) : int(bounds.height - this._tcm.compositionHeight);
         return maxScroll > 0 ? int(maxScroll) : int(0);
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set scrollH(value:int) : void
      {
         var blockProg:String = !!this.UsingTextFlow() ? this._tcm.getTextFlow().blockProgression : this._tcm.hostFormat.blockProgression;
         var direction:String = !!this.UsingTextFlow() ? this._tcm.getTextFlow().direction : this._tcm.hostFormat.direction;
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
            this._tcm.verticalScrollPosition = value;
         }
         else
         {
            this._tcm.horizontalScrollPosition = value;
         }
      }
      
      private function UsingTextFlow() : Boolean
      {
         return !(this._tcm.composeState == TextContainerManager.COMPOSE_FACTORY && this._tcm.sourceState == TextContainerManager.SOURCE_STRING);
      }
   }
}
