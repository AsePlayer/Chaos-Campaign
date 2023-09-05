package com.brockw.stickwar.engine
{
     import flash.display.Shape;
     
     public class Box extends Shape
     {
           
          
          private var startX:int;
          
          private var startY:int;
          
          private var _isOn:Boolean;
          
          private var endX:int;
          
          private var endY:int;
          
          public function Box()
          {
               super();
               this.startX = 0;
               this.startY = 0;
               this.isOn = false;
          }
          
          public function get isOn() : Boolean
          {
               return this._isOn;
          }
          
          public function set isOn(value:Boolean) : void
          {
               this._isOn = value;
          }
          
          public function start(x:int, y:int) : void
          {
               this.isOn = true;
               this.endX = this.startX = x;
               this.endY = this.startY = y;
               this.update(this.endX,this.endY);
          }
          
          public function update(endX:int, endY:int) : void
          {
               if(this.isOn)
               {
                    this.graphics.clear();
                    this.graphics.lineStyle(2,65280,0.75);
                    this.graphics.moveTo(this.startX,this.startY);
                    this.graphics.beginFill(65280,0.2);
                    this.graphics.lineTo(endX,this.startY);
                    this.graphics.lineTo(endX,endY);
                    this.graphics.lineTo(this.startX,endY);
                    this.graphics.lineTo(this.startX,this.startY);
                    this.endX = endX;
                    this.endY = endY;
               }
          }
          
          public function end() : void
          {
               this.isOn = false;
          }
          
          public function isInside(x:int, y:int, height:int, width:int) : Boolean
          {
               var sx:int = Math.min(this.endX,this.startX);
               var sy:int = Math.min(this.endY,this.startY);
               var ex:int = Math.max(this.endX,this.startX);
               var ey:int = Math.max(this.endY,this.startY);
               return x > sx && x < ex && sy < y && y - height < ey;
          }
     }
}
