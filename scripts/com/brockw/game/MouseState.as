package com.brockw.game
{
     import flash.display.Sprite;
     import flash.display.Stage;
     import flash.events.Event;
     import flash.events.MouseEvent;
     
     public class MouseState extends Sprite
     {
          
          private static const CLICK_FRAMES:int = 10;
          
          private static const DOUBLE_CLICK_FRAMES:int = 10;
           
          
          private var _mouseDown:Boolean;
          
          private var _oldMouseDown:Boolean;
          
          private var mouseDownFrames:int;
          
          private var _clicked:Boolean;
          
          private var lastMouseX:int;
          
          private var lastMouseY:int;
          
          private var _mouseDownX:int;
          
          private var _mouseDownY:int;
          
          private var currentMouseX:int;
          
          private var currentMouseY:int;
          
          private var lastClickTime:int;
          
          private var _doubleClicked:Boolean;
          
          private var _mouseIn:Boolean;
          
          private var _target:Stage;
          
          private var _isRightClick:Boolean;
          
          public function MouseState(target:Stage)
          {
               super();
               this._target = target;
               this.oldMouseDown = this.mouseDown = false;
               this._clicked = false;
               this.mouseDownFrames = 0;
               this.lastClickTime = -DOUBLE_CLICK_FRAMES;
               this.lastMouseX = this.mouseX;
               this.lastMouseY = this.mouseY;
               this.mouseIn = true;
               this._isRightClick = false;
               target.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownEvent);
               target.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpEvent);
               target.stage.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveEvent);
               target.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseEnterEvent);
               target.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.mouseDownEventRight);
               this._target.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.mouseUpEventRight);
               this._mouseDownX = 0;
               this._mouseDownY = 0;
          }
          
          public function cleanUp() : void
          {
               this._target.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownEvent);
               this._target.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpEvent);
               this._target.stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveEvent);
               this._target.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseEnterEvent);
               this._target.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.mouseDownEventRight);
               this._target.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,this.mouseUpEventRight);
          }
          
          private function mouseUpEventRight(evt:Event) : void
          {
               this.isRightClick = false;
               this.mouseDown = false;
          }
          
          public function isDrag() : Boolean
          {
               return Math.sqrt(Math.pow(this.currentMouseX - this.lastMouseX,2) + Math.pow(this.currentMouseY - this.lastMouseY,2)) > 50;
          }
          
          public function update() : void
          {
               if(this.oldMouseDown == true && this.mouseDown == false && this.mouseDownFrames < CLICK_FRAMES && !this.isDrag())
               {
                    this._clicked = true;
                    if(this.lastClickTime < DOUBLE_CLICK_FRAMES)
                    {
                         this._doubleClicked = true;
                    }
                    this.lastClickTime = 0;
               }
               else
               {
                    this._doubleClicked = false;
                    this._clicked = false;
               }
               ++this.lastClickTime;
               ++this.mouseDownFrames;
               this.oldMouseDown = this.mouseDown;
          }
          
          private function mouseLeaveEvent(evt:Event) : void
          {
               this.mouseIn = false;
          }
          
          private function mouseEnterEvent(evt:MouseEvent) : void
          {
               this.mouseIn = true;
          }
          
          private function mouseDownEventRight(evt:MouseEvent) : void
          {
               this.isRightClick = true;
               if(this.mouseDown == false)
               {
                    this.mouseDownX = evt.stageX;
                    this.mouseDownY = evt.stageY;
               }
               this.mouseDown = true;
               this.mouseDownFrames = 0;
               this.currentMouseX = this.lastMouseX = evt.stageX;
               this.currentMouseY = this.lastMouseY = evt.stageY;
          }
          
          private function mouseDownEvent(evt:MouseEvent) : void
          {
               this.isRightClick = false;
               if(this.mouseDown == false)
               {
                    this.mouseDownX = evt.stageX;
                    this.mouseDownY = evt.stageY;
               }
               this.mouseDown = true;
               this.mouseDownFrames = 0;
               this.currentMouseX = this.lastMouseX = evt.stageX;
               this.currentMouseY = this.lastMouseY = evt.stageY;
          }
          
          public function mouseJustDown() : Boolean
          {
               return this.mouseDownFrames <= 1 && this.mouseDown == true;
          }
          
          private function mouseUpEvent(evt:MouseEvent) : void
          {
               this.mouseDown = false;
               this.currentMouseX = evt.stageX;
               this.currentMouseY = evt.stageY;
          }
          
          public function get clicked() : Boolean
          {
               return this._clicked;
          }
          
          public function set clicked(value:Boolean) : void
          {
               this._clicked = value;
          }
          
          public function get doubleClicked() : Boolean
          {
               return this._doubleClicked;
          }
          
          public function set doubleClicked(value:Boolean) : void
          {
               this._doubleClicked = value;
          }
          
          public function get mouseDown() : Boolean
          {
               return this._mouseDown;
          }
          
          public function set mouseDown(value:Boolean) : void
          {
               this._mouseDown = value;
          }
          
          public function get mouseIn() : Boolean
          {
               return this._mouseIn;
          }
          
          public function set mouseIn(value:Boolean) : void
          {
               this._mouseIn = value;
          }
          
          public function get mouseDownX() : int
          {
               return this._mouseDownX;
          }
          
          public function set mouseDownX(value:int) : void
          {
               this._mouseDownX = value;
          }
          
          public function get mouseDownY() : int
          {
               return this._mouseDownY;
          }
          
          public function set mouseDownY(value:int) : void
          {
               this._mouseDownY = value;
          }
          
          public function get oldMouseDown() : Boolean
          {
               return this._oldMouseDown;
          }
          
          public function set oldMouseDown(value:Boolean) : void
          {
               this._oldMouseDown = value;
          }
          
          public function get isRightClick() : Boolean
          {
               return this._isRightClick;
          }
          
          public function set isRightClick(value:Boolean) : void
          {
               this._isRightClick = value;
          }
     }
}
