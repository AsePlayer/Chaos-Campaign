package com.liamr.ui.dropDown
{
   import com.liamr.ui.dropDown.Events.DropDownEvent;
   import flash.display.Sprite;
   import flash.events.*;
   import gs.TweenLite;
   import gs.easing.*;
   
   public class DropDown extends DropDownMc
   {
      
      public static var ITEM_SELECTED:String = "itemSelected";
       
      
      public var dropDownArray:Array;
      
      private var listHolder:Sprite;
      
      private var listScroller:Sprite;
      
      private var masker:Sprite;
      
      private var listBg:Sprite;
      
      private var listHeight:Number;
      
      private var listOpen:Boolean = false;
      
      private var scrollable:Boolean;
      
      public var selectedId:int;
      
      public var selectedLabel:String;
      
      public var selectedData;
      
      public function DropDown(_array:Array, _message:String = "Please choose...", _scrollable:Boolean = false, _listHeight:Number = 100)
      {
         this.dropDownArray = [];
         super();
         this.dropDownArray = _array;
         this.listHeight = _listHeight;
         this.scrollable = _scrollable;
         selectedItem_txt.text = _message;
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function init(e:Event) : void
      {
         hit.addEventListener(MouseEvent.CLICK,this.openClose);
         hit.buttonMode = true;
         stage.addEventListener(MouseEvent.CLICK,this.stageClose);
         this.buildList();
      }
      
      private function buildList() : void
      {
         var i:int = 0;
         var listItem:DropDownItem = null;
         this.listHolder = new Sprite();
         addChildAt(this.listHolder,0);
         this.listScroller = new Sprite();
         this.listHolder.addChildAt(this.listScroller,0);
         this.listHolder.y = 10;
         for(i = 0; i < this.dropDownArray.length; i++)
         {
            listItem = new DropDownItem();
            listItem._id = i;
            listItem.item_txt.text = this.dropDownArray[i];
            listItem.y = this.listScroller.height;
            listItem.mouseChildren = false;
            listItem.buttonMode = true;
            listItem.addEventListener(MouseEvent.MOUSE_OVER,this.itemOver);
            listItem.addEventListener(MouseEvent.MOUSE_OUT,this.itemOut);
            listItem.addEventListener(MouseEvent.CLICK,this.selectItem);
            this.listScroller.addChild(listItem);
            if(i == 0)
            {
               this.selectItemWithTarget(listItem);
            }
         }
         if(this.listScroller.height < this.listHeight)
         {
            this.listHeight = this.listScroller.height;
         }
         this.listBg = new Sprite();
         this.listBg.graphics.beginFill(0,0);
         this.listBg.graphics.drawRoundRect(0,-10,this.listScroller.width,this.listScroller.height + 10,11);
         this.listBg.graphics.endFill();
         this.listScroller.addChildAt(this.listBg,0);
         this.masker = new Sprite();
         this.masker.graphics.beginFill(0);
         this.masker.graphics.drawRoundRect(0,-10,this.listScroller.width,this.listHeight + 10,11);
         this.masker.graphics.endFill();
         this.listHolder.addChild(this.masker);
         this.masker.y = -int(this.listHeight - 10);
         this.listScroller.mask = this.masker;
         if(this.scrollable)
         {
            this.initScrolling();
         }
      }
      
      public function openClose(e:Event = null) : void
      {
         if(this.listOpen)
         {
            this.close();
         }
         else
         {
            this.open();
         }
      }
      
      public function stageClose(e:Event) : void
      {
         if(e.target.name != "hit")
         {
            this.close();
         }
      }
      
      public function open(e:Event = null) : void
      {
         this.listOpen = true;
         trace(Strong.easeOut,hit.height);
         TweenLite.to(this.masker,0.5,{
            "y":0,
            "ease":Strong.easeOut
         });
         TweenLite.to(this.listHolder,0.5,{
            "y":hit.height,
            "ease":Strong.easeOut
         });
      }
      
      public function close(e:Event = null) : void
      {
         this.listOpen = false;
         TweenLite.to(this.masker,0.5,{
            "y":-int(this.listHeight - 10),
            "ease":Strong.easeOut
         });
         TweenLite.to(this.listHolder,0.5,{
            "y":10,
            "ease":Strong.easeOut
         });
         TweenLite.to(this.listScroller,0.1,{
            "y":0,
            "ease":Strong.easeOut
         });
      }
      
      private function itemOver(e:Event) : void
      {
         TweenLite.to(e.target,0.5,{
            "alpha":0.8,
            "ease":Strong.easeOut
         });
      }
      
      private function itemOut(e:Event) : void
      {
         TweenLite.to(e.target,0.5,{
            "alpha":1,
            "ease":Strong.easeOut
         });
      }
      
      private function selectItemWithTarget(target:Object) : void
      {
         this.selectedId = target._id;
         this.selectedLabel = target.item_txt.text;
         this.selectedData = target._data;
         selectedItem_txt.text = target.item_txt.text;
         this.close();
         dispatchEvent(new DropDownEvent(ITEM_SELECTED,this.selectedId,this.selectedLabel,this.selectedData));
      }
      
      private function selectItem(e:Event) : void
      {
         this.selectItemWithTarget(e.target);
      }
      
      private function initScrolling() : void
      {
         this.addEventListener(MouseEvent.ROLL_OVER,this.startScroll);
         this.addEventListener(MouseEvent.ROLL_OUT,this.stopScroll);
         addEventListener(Event.ENTER_FRAME,this.listScroll);
      }
      
      private function startScroll(e:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.listScroll);
      }
      
      private function stopScroll(e:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.listScroll);
      }
      
      private function listScroll(e:Event) : void
      {
         var scrollDistance:int = this.masker.height;
         if(this.listOpen)
         {
            if(this.listScroller.height > scrollDistance)
            {
               this.listScroller.y += Math.cos(-this.masker.mouseY / scrollDistance * Math.PI) * 3;
               if(this.listScroller.y > 0)
               {
                  this.listScroller.y = 0;
               }
               if(-this.listScroller.y > this.listScroller.height - scrollDistance)
               {
                  this.listScroller.y = -(this.listScroller.height - scrollDistance);
               }
            }
            else
            {
               this.listScroller.y = 0;
            }
         }
      }
   }
}
