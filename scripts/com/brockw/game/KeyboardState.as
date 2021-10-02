package com.brockw.game
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   
   public class KeyboardState
   {
       
      
      private var keysVector:Vector.<Boolean>;
      
      private var pressedVector:Vector.<Boolean>;
      
      private var downVector:Vector.<Boolean>;
      
      private var _isShift:Boolean;
      
      private var _isCtrl:Boolean;
      
      private var _target:Stage;
      
      private var _isDisabled:Boolean;
      
      public function KeyboardState(param1:Stage)
      {
         super();
         this._isDisabled = false;
         this._target = param1;
         this.keysVector = new Vector.<Boolean>(255,false);
         this.pressedVector = new Vector.<Boolean>(255,false);
         this.downVector = new Vector.<Boolean>(255,false);
         var _loc2_:int = 0;
         while(_loc2_ < 256)
         {
            this.keysVector[_loc2_] = this.pressedVector[_loc2_] = this.downVector[_loc2_] = false;
            _loc2_++;
         }
         param1.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
         param1.addEventListener(KeyboardEvent.KEY_UP,this.keyUp);
         this._isCtrl = this._isShift = false;
      }
      
      public function get isCtrl() : Boolean
      {
         return this._isCtrl;
      }
      
      public function set isCtrl(param1:Boolean) : void
      {
         this._isCtrl = param1;
      }
      
      public function cleanUp() : void
      {
         this._target.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
         this._target.removeEventListener(KeyboardEvent.KEY_UP,this.keyUp);
      }
      
      public function isDown(param1:int) : Boolean
      {
         return this.keysVector[param1];
      }
      
      public function isPressed(param1:int) : Boolean
      {
         if(this._isDisabled)
         {
            return false;
         }
         var _loc2_:Boolean = this.pressedVector[param1];
         this.pressedVector[param1] = false;
         return _loc2_;
      }
      
      public function isDownForAction(param1:int) : Boolean
      {
         if(this._isDisabled)
         {
            return false;
         }
         if(this.downVector[param1])
         {
            this.downVector[param1] = false;
            return true;
         }
         return false;
      }
      
      private function keyUp(param1:KeyboardEvent) : void
      {
         this._isShift = param1.shiftKey;
         this._isCtrl = param1.ctrlKey;
         this.keysVector[param1.keyCode] = false;
         this.pressedVector[param1.keyCode] = false;
         this.downVector[param1.keyCode] = false;
      }
      
      private function keyDown(param1:KeyboardEvent) : void
      {
         if(this.keysVector[param1.keyCode] == false)
         {
            this.pressedVector[param1.keyCode] = true;
            this.downVector[param1.keyCode] = true;
         }
         this._isCtrl = param1.ctrlKey;
         this._isShift = param1.shiftKey;
         this.keysVector[param1.keyCode] = true;
      }
      
      public function get isShift() : Boolean
      {
         return this._isShift;
      }
      
      public function set isShift(param1:Boolean) : void
      {
         this._isShift = param1;
      }
      
      public function get isDisabled() : Boolean
      {
         return this._isDisabled;
      }
      
      public function set isDisabled(param1:Boolean) : void
      {
         this._isDisabled = param1;
      }
   }
}
