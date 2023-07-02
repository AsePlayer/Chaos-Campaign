package fl.text.container
{
   import fl.text.TLFTextField;
   import flash.desktop.Clipboard;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.IME;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   public class TLFContainerController extends ContainerController
   {
       
      
      private var _transparentBGButton:SimpleButton;
      
      private var _transparentBGButtonX:Number;
      
      private var _transparentBGButtonY:Number;
      
      private var _transparentBGButtonHeight:Number;
      
      private var _owner:TLFTextField;
      
      private var _transparentBGButtonWidth:Number;
      
      public function TLFContainerController(container:Sprite, owner:TLFTextField)
      {
         this._transparentBGButton = null;
         this._transparentBGButtonX = NaN;
         this._transparentBGButtonY = NaN;
         this._transparentBGButtonWidth = NaN;
         this._transparentBGButtonHeight = NaN;
         this._owner = owner;
         super(container);
      }
      
      override public function editHandler(evt:Event) : void
      {
         if((evt.type == Event.COPY || evt.type == Event.CUT) && this._owner.displayAsPassword)
         {
            return;
         }
         super.editHandler(evt);
         if((evt.type == Event.COPY || evt.type == Event.CUT) && !this._owner.useRichTextClipboard)
         {
            Clipboard.generalClipboard.clearData("TEXT_LAYOUT_MARKUP");
         }
      }
      
      override tlf_internal function attachTransparentBackgroundForHit(justClear:Boolean) : void
      {
         var s:Sprite = null;
         var bgwidth:Number = NaN;
         var bgheight:Number = NaN;
         var adjustHorizontalScroll:Boolean = false;
         var bgx:Number = NaN;
         var bgy:Number = NaN;
         var g:Graphics = null;
         if(attachTransparentBackground)
         {
            s = container;
            if(s != null)
            {
               if(justClear)
               {
                  if(this._transparentBGButton != null)
                  {
                     Shape(this._transparentBGButton.hitTestState).graphics.clear();
                     this._transparentBGButtonX = this._transparentBGButtonY = this._transparentBGButtonWidth = this._transparentBGButtonHeight = NaN;
                  }
               }
               else
               {
                  if(this._transparentBGButton == null)
                  {
                     this._transparentBGButton = new SimpleButton();
                     this._transparentBGButton.focusRect = false;
                     this._transparentBGButton.tabEnabled = false;
                     this._transparentBGButton.addEventListener(MouseEvent.MOUSE_DOWN,this.abandonComposition,false,0,true);
                     this._transparentBGButton.useHandCursor = false;
                     this._transparentBGButton.hitTestState = new Shape();
                     s.addChildAt(this._transparentBGButton,0);
                  }
                  bgwidth = !!tlf_internal::measureWidth ? Number(tlf_internal::contentWidth) : compositionWidth;
                  bgheight = !!tlf_internal::measureHeight ? Number(tlf_internal::contentHeight) : compositionHeight;
                  adjustHorizontalScroll = tlf_internal::effectiveBlockProgression == BlockProgression.RL && horizontalScrollPolicy != ScrollPolicy.OFF;
                  bgx = adjustHorizontalScroll ? horizontalScrollPosition - bgwidth : horizontalScrollPosition;
                  bgy = verticalScrollPosition;
                  if(bgx != this._transparentBGButtonX || bgy != this._transparentBGButtonY || bgwidth != this._transparentBGButtonWidth || bgheight != this._transparentBGButtonHeight)
                  {
                     g = Shape(this._transparentBGButton.hitTestState).graphics;
                     g.clear();
                     if(bgwidth != 0 && bgheight != 0)
                     {
                        g.beginFill(0);
                        g.drawRect(bgx,bgy,bgwidth,bgheight);
                        g.endFill();
                     }
                     this._transparentBGButtonX = bgx;
                     this._transparentBGButtonY = bgy;
                     this._transparentBGButtonWidth = bgwidth;
                     this._transparentBGButtonHeight = bgheight;
                  }
               }
            }
         }
      }
      
      public function get ownerField() : TLFTextField
      {
         return this._owner;
      }
      
      override public function softKeyboardActivatingHandler(event:Event) : void
      {
         if(Configuration.tlf_internal::playerEnablesSpicyFeatures)
         {
            container.softKeyboardInputAreaOfInterest = this._owner.getBounds(this._owner.stage);
         }
         super.softKeyboardActivatingHandler(event);
      }
      
      private function has3D(dispObj:DisplayObject) : Boolean
      {
         var i:int = 0;
         if(dispObj.transform.matrix3D != null)
         {
            return true;
         }
         var container:DisplayObjectContainer = dispObj as DisplayObjectContainer;
         if(container != null)
         {
            for(i = 0; i < container.numChildren; i++)
            {
               if(this.has3D(container.getChildAt(i)))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      override public function mouseWheelHandler(evt:MouseEvent) : void
      {
         if(!this._owner.mouseWheelEnabled)
         {
            return;
         }
         super.mouseWheelHandler(evt);
      }
      
      private function abandonComposition(evt:MouseEvent) : void
      {
         var imeCompositionAbandoned:Function = IME["compositionAbandoned"];
         if(IME["compositionAbandoned"] !== undefined)
         {
            imeCompositionAbandoned();
         }
      }
      
      override protected function addInlineGraphicElement(parent:DisplayObjectContainer, inlineGraphicElement:DisplayObject, index:int) : void
      {
         var ilg:InlineGraphicElement = null;
         var r:Rectangle = null;
         var sdo:DisplayObject = DisplayObject(Sprite(inlineGraphicElement).getChildAt(0));
         if(sdo.hasOwnProperty("ilg"))
         {
            ilg = sdo["ilg"];
            r = sdo.getBounds(inlineGraphicElement);
            if(this.has3D(sdo))
            {
               if(ilg.tlf_internal::elementWidth != r.width || ilg.tlf_internal::elementHeight != r.height)
               {
                  ilg.tlf_internal::elementWidth = Math.max(1,r.width);
                  ilg.tlf_internal::elementHeight = Math.max(1,r.height);
               }
            }
            sdo.x -= r.x;
            sdo.y -= r.y;
         }
         super.addInlineGraphicElement(parent,inlineGraphicElement,index);
      }
   }
}
