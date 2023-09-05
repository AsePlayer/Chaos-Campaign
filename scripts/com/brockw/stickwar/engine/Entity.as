package com.brockw.stickwar.engine
{
     import com.brockw.ds.Comparable;
     import com.brockw.stickwar.engine.Ai.command.*;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.MovieClip;
     import flash.display.Sprite;
     import flash.filters.*;
     
     public class Entity extends Sprite implements Comparable
     {
           
          
          public var px:Number;
          
          public var pz:Number;
          
          public var py:Number;
          
          private var _pheight:Number;
          
          private var _pwidth:Number;
          
          protected var _type:int;
          
          protected var _isArmoured:Boolean;
          
          protected var _damageToArmour:Number;
          
          protected var _damageToNotArmour:Number;
          
          protected var selectedFilter:GlowFilter;
          
          protected var nonSelectedFilter:GlowFilter;
          
          protected var _mouseIsOver;
          
          private var _selected:Boolean;
          
          private var _id:int;
          
          public function Entity()
          {
               super();
               this.selected = this.mouseIsOver = false;
               this.selectedFilter = new GlowFilter();
               this.selectedFilter.color = 39168;
               this.selectedFilter.blurX = 3;
               this.selectedFilter.blurY = 3;
               this.nonSelectedFilter = new GlowFilter();
               this.nonSelectedFilter.color = 16777215;
               this.nonSelectedFilter.blurX = 3;
               this.nonSelectedFilter.blurY = 3;
          }
          
          public function getDamageToUnit(target:Unit) : int
          {
               return target.isArmoured ? int(this.damageToArmour) : int(this.damageToNotArmour);
          }
          
          public function drawOnHud(canvas:MovieClip, game:StickWar) : void
          {
               var x:Number = canvas.width * this.px / game.map.width;
               var y:Number = canvas.height * this.py / game.map.height;
               if(this.selected)
               {
                    MovieClip(canvas).graphics.lineStyle(2,65280,1);
               }
               else
               {
                    MovieClip(canvas).graphics.lineStyle(2,0,1);
               }
               MovieClip(canvas).graphics.drawRect(x,y,1,1);
          }
          
          public function damage(type:int, amount:int, inflictor:Entity, modifier:Number = 1) : void
          {
          }
          
          public function cleanUp() : void
          {
          }
          
          public function onMap(game:StickWar) : Boolean
          {
               return true;
          }
          
          public function onScreen(game:StickWar) : Boolean
          {
               return this.px + width / 2 - game.screenX > 0 && this.px - width / 2 - game.screenX < game.map.screenWidth;
          }
          
          public function setActionInterface(a:ActionInterface) : void
          {
               a.clear();
          }
          
          public function compare(other:Object) : int
          {
               return this.py - other.py;
          }
          
          public function get type() : int
          {
               return this._type;
          }
          
          public function set type(value:int) : void
          {
               this._type = value;
          }
          
          public function get pwidth() : Number
          {
               return this._pwidth;
          }
          
          public function set pwidth(value:Number) : void
          {
               this._pwidth = value;
          }
          
          public function get pheight() : Number
          {
               return this._pheight;
          }
          
          public function set pheight(value:Number) : void
          {
               this._pheight = value;
          }
          
          public function get isArmoured() : Boolean
          {
               return this._isArmoured;
          }
          
          public function set isArmoured(value:Boolean) : void
          {
               this._isArmoured = value;
          }
          
          public function get damageToArmour() : Number
          {
               return this._damageToArmour;
          }
          
          public function set damageToArmour(value:Number) : void
          {
               this._damageToArmour = value;
          }
          
          public function get damageToNotArmour() : Number
          {
               return this._damageToNotArmour;
          }
          
          public function set damageToNotArmour(value:Number) : void
          {
               this._damageToNotArmour = value;
          }
          
          public function get selected() : Boolean
          {
               return this._selected;
          }
          
          public function set selected(value:Boolean) : void
          {
               this._selected = value;
          }
          
          public function get mouseIsOver() : *
          {
               return this._mouseIsOver;
          }
          
          public function set mouseIsOver(value:*) : void
          {
               this._mouseIsOver = value;
          }
          
          public function get id() : int
          {
               return this._id;
          }
          
          public function set id(value:int) : void
          {
               this._id = value;
          }
     }
}
