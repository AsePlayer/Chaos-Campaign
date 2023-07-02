package fl.text
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   public class TLFTextContainerManager extends TextContainerManager
   {
       
      
      private var _transparentBGButton:SimpleButton;
      
      private var _transparentBGButtonX:Number;
      
      private var _transparentBGButtonHeight:Number;
      
      private var _transparentBGButtonY:Number;
      
      private var _transparentBGButtonWidth:Number;
      
      public function TLFTextContainerManager(container:Sprite, config:Configuration = null)
      {
         this._transparentBGButton = null;
         this._transparentBGButtonX = NaN;
         this._transparentBGButtonY = NaN;
         this._transparentBGButtonWidth = NaN;
         this._transparentBGButtonHeight = NaN;
         super(container,config);
         container.mouseChildren = true;
      }
      
      override public function softKeyboardActivatingHandler(event:Event) : void
      {
         if(Configuration.tlf_internal::playerEnablesSpicyFeatures)
         {
            container.softKeyboardInputAreaOfInterest = container.parent.getBounds(container.stage);
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
      
      override tlf_internal function factoryUpdateContainerChildren() : void
      {
         super.tlf_internal::factoryUpdateContainerChildren();
         if(this._transparentBGButton != null)
         {
            container.addChildAt(this._transparentBGButton,0);
         }
      }
      
      override public function setText(text:String) : void
      {
         super.setText(text);
         container.mouseChildren = true;
      }
      
      override public function drawBackgroundAndSetScrollRect(scrollX:Number, scrollY:Number) : Boolean
      {
         var contentBounds:Rectangle = null;
         var g:Graphics = null;
         var hasScrollRect:Boolean = super.drawBackgroundAndSetScrollRect(scrollX,scrollY);
         container.graphics.clear();
         if(this._transparentBGButton == null)
         {
            this._transparentBGButton = new SimpleButton();
            this._transparentBGButton.focusRect = false;
            this._transparentBGButton.tabEnabled = false;
            this._transparentBGButton.useHandCursor = false;
            this._transparentBGButton.hitTestState = new Shape();
            container.addChildAt(this._transparentBGButton,0);
         }
         if(hasScrollRect)
         {
            contentBounds = container.scrollRect;
         }
         else
         {
            contentBounds = getContentBounds();
            if(!isNaN(compositionWidth))
            {
               contentBounds.width = compositionWidth;
            }
            if(!isNaN(compositionHeight))
            {
               contentBounds.height = compositionHeight;
            }
         }
         if(contentBounds.x != this._transparentBGButtonX || contentBounds.y != this._transparentBGButtonY || contentBounds.width != this._transparentBGButtonWidth || contentBounds.height != this._transparentBGButtonHeight)
         {
            g = Shape(this._transparentBGButton.hitTestState).graphics;
            g.clear();
            if(contentBounds.width != 0 && contentBounds.height != 0)
            {
               g.beginFill(0);
               g.drawRect(contentBounds.x,contentBounds.y,contentBounds.width,contentBounds.height);
               g.endFill();
            }
            this._transparentBGButtonX = contentBounds.x;
            this._transparentBGButtonY = contentBounds.y;
            this._transparentBGButtonWidth = contentBounds.width;
            this._transparentBGButtonHeight = contentBounds.height;
         }
         return hasScrollRect;
      }
      
      override tlf_internal function clearContainerChildren(recycle:Boolean) : void
      {
         super.tlf_internal::clearContainerChildren(recycle);
         if(this._transparentBGButton != null)
         {
            container.addChildAt(this._transparentBGButton,0);
         }
      }
      
      override public function mouseWheelHandler(event:MouseEvent) : void
      {
         var tlf:Object = event.target.parent.parent;
         if(tlf && tlf.hasOwnProperty("mouseWheelEnabled") && !tlf["mouseWheelEnabled"])
         {
            return;
         }
         super.mouseWheelHandler(event);
      }
      
      override tlf_internal function addInlineGraphicElement(parent:DisplayObjectContainer, inlineGraphicElement:DisplayObject, index:int) : void
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
         super.tlf_internal::addInlineGraphicElement(parent,inlineGraphicElement,index);
      }
   }
}
