package com.google.analytics.debug
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   
   public class UISprite extends Sprite
   {
       
      
      private var _forcedWidth:uint;
      
      public var margin:Margin;
      
      protected var alignTarget:DisplayObject;
      
      protected var listenResize:Boolean;
      
      public var alignement:Align;
      
      private var _forcedHeight:uint;
      
      public function UISprite(alignTarget:DisplayObject = null)
      {
         super();
         listenResize = false;
         alignement = Align.none;
         this.alignTarget = alignTarget;
         margin = new Margin();
         addEventListener(Event.ADDED_TO_STAGE,_onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,_onRemovedFromStage);
      }
      
      public function get forcedHeight() : uint
      {
         if(_forcedHeight)
         {
            return _forcedHeight;
         }
         return height;
      }
      
      private function _onAddedToStage(event:Event) : void
      {
         layout();
         resize();
      }
      
      protected function dispose() : void
      {
         var d:DisplayObject = null;
         for(var i:int = 0; i < numChildren; i++)
         {
            d = getChildAt(i);
            if(d)
            {
               removeChild(d);
            }
         }
      }
      
      public function set forcedHeight(value:uint) : void
      {
         _forcedHeight = value;
      }
      
      public function set forcedWidth(value:uint) : void
      {
         _forcedWidth = value;
      }
      
      protected function layout() : void
      {
      }
      
      public function get forcedWidth() : uint
      {
         if(_forcedWidth)
         {
            return _forcedWidth;
         }
         return width;
      }
      
      public function alignTo(alignement:Align, target:DisplayObject = null) : void
      {
         var H:uint = 0;
         var W:uint = 0;
         var X:uint = 0;
         var Y:uint = 0;
         var t:UISprite = null;
         if(target == null)
         {
            if(parent is Stage)
            {
               target = this.stage;
            }
            else
            {
               target = parent;
            }
         }
         if(target == this.stage)
         {
            if(this.stage == null)
            {
               return;
            }
            H = this.stage.stageHeight;
            W = this.stage.stageWidth;
            X = 0;
            Y = 0;
         }
         else
         {
            t = target as UISprite;
            if(t.forcedHeight)
            {
               H = t.forcedHeight;
            }
            else
            {
               H = t.height;
            }
            if(t.forcedWidth)
            {
               W = t.forcedWidth;
            }
            else
            {
               W = t.width;
            }
            X = 0;
            Y = 0;
         }
         switch(alignement)
         {
            case Align.top:
               x = W / 2 - forcedWidth / 2;
               y = Y + margin.top;
               break;
            case Align.bottom:
               x = W / 2 - forcedWidth / 2;
               y = Y + H - forcedHeight - margin.bottom;
               break;
            case Align.left:
               x = X + margin.left;
               y = H / 2 - forcedHeight / 2;
               break;
            case Align.right:
               x = X + W - forcedWidth - margin.right;
               y = H / 2 - forcedHeight / 2;
               break;
            case Align.center:
               x = W / 2 - forcedWidth / 2;
               y = H / 2 - forcedHeight / 2;
               break;
            case Align.topLeft:
               x = X + margin.left;
               y = Y + margin.top;
               break;
            case Align.topRight:
               x = X + W - forcedWidth - margin.right;
               y = Y + margin.top;
               break;
            case Align.bottomLeft:
               x = X + margin.left;
               y = Y + H - forcedHeight - margin.bottom;
               break;
            case Align.bottomRight:
               x = X + W - forcedWidth - margin.right;
               y = Y + H - forcedHeight - margin.bottom;
         }
         if(!listenResize && alignement != Align.none)
         {
            target.addEventListener(Event.RESIZE,onResize,false,0,true);
            listenResize = true;
         }
         this.alignement = alignement;
         this.alignTarget = target;
      }
      
      private function _onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,_onAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,_onRemovedFromStage);
         dispose();
      }
      
      public function resize() : void
      {
         if(alignement != Align.none)
         {
            alignTo(alignement,alignTarget);
         }
      }
      
      protected function onResize(event:Event) : void
      {
         resize();
      }
   }
}
