package com.brockw.stickwar.engine
{
     import flash.display.Sprite;
     
     public class HealthBar extends Sprite
     {
          
          private static const BAR_WIDTH:Number = 30;
          
          private static const BAR_HEIGHT:Number = 7.5;
          
          private static const BOX_SIZE:Number = 75;
           
          
          private var _totalHealth:Number;
          
          private var _actualHealth:Number;
          
          private var _health:Number;
          
          private var _totalMana:Number;
          
          private var _mana:Number;
          
          private var blackBars:Sprite;
          
          private var redBar:Sprite;
          
          private var isFirst:Boolean;
          
          public function HealthBar()
          {
               super();
               this.blackBars = new Sprite();
               this.redBar = new Sprite();
               addChild(this.redBar);
               addChild(this.blackBars);
               this.isFirst = true;
          }
          
          public function reset() : void
          {
               this._actualHealth = this._totalHealth;
               this.isFirst = true;
          }
          
          public function setStatus(status:int) : void
          {
          }
          
          public function update() : void
          {
               this._actualHealth += (this._health - this._actualHealth) * 0.035;
               if(Math.abs(this._health - this._actualHealth) > 1 || this.isFirst)
               {
                    this.redBar.graphics.clear();
                    this.redBar.graphics.moveTo(-BAR_WIDTH / 2,-BAR_HEIGHT / 2);
                    this.redBar.graphics.beginFill(65280,1);
                    this.redBar.graphics.lineTo(-BAR_WIDTH / 2 + BAR_WIDTH * this._health / this._totalHealth,-BAR_HEIGHT / 2);
                    this.redBar.graphics.lineTo(-BAR_WIDTH / 2 + BAR_WIDTH * this._health / this._totalHealth,BAR_HEIGHT / 2);
                    this.redBar.graphics.lineTo(-BAR_WIDTH / 2,BAR_HEIGHT / 2);
                    this.redBar.graphics.lineTo(-BAR_WIDTH / 2,-BAR_HEIGHT / 2);
                    this.redBar.graphics.moveTo(-BAR_WIDTH / 2 + BAR_WIDTH * this._health / this._totalHealth,-BAR_HEIGHT / 2);
                    this.redBar.graphics.beginFill(16711680,1);
                    this.redBar.graphics.lineStyle(0,0,0.5);
                    this.redBar.graphics.lineTo(-BAR_WIDTH / 2 + BAR_WIDTH * this._actualHealth / this._totalHealth,-BAR_HEIGHT / 2);
                    this.redBar.graphics.lineTo(-BAR_WIDTH / 2 + BAR_WIDTH * this._actualHealth / this._totalHealth,BAR_HEIGHT / 2);
                    this.redBar.graphics.lineTo(-BAR_WIDTH / 2 + BAR_WIDTH * this._health / this._totalHealth,BAR_HEIGHT / 2);
                    this.redBar.graphics.lineTo(-BAR_WIDTH / 2 + BAR_WIDTH * this._health / this._totalHealth,-BAR_HEIGHT / 2);
               }
          }
          
          public function get totalHealth() : Number
          {
               return this._totalHealth;
          }
          
          public function set totalHealth(value:Number) : void
          {
               var numBoxes:int = 0;
               var i:int = 0;
               this._actualHealth = this._totalHealth = value;
               this.blackBars.graphics.clear();
               this.blackBars.graphics.lineStyle(0.75,0,1);
               this.blackBars.graphics.moveTo(-BAR_WIDTH / 2,-BAR_HEIGHT / 2);
               this.blackBars.graphics.lineTo(BAR_WIDTH / 2,-BAR_HEIGHT / 2);
               this.blackBars.graphics.lineTo(BAR_WIDTH / 2,BAR_HEIGHT / 2);
               this.blackBars.graphics.lineTo(-BAR_WIDTH / 2,BAR_HEIGHT / 2);
               this.blackBars.graphics.lineTo(-BAR_WIDTH / 2,-BAR_HEIGHT / 2);
               if(this._totalHealth < 1600)
               {
                    numBoxes = Math.ceil(this._totalHealth / BOX_SIZE);
                    this.blackBars.graphics.lineStyle(0.75,0,1);
                    for(i = 0; i < numBoxes; i++)
                    {
                         this.blackBars.graphics.moveTo(i * BAR_WIDTH / numBoxes - BAR_WIDTH / 2,-BAR_HEIGHT / 2);
                         this.blackBars.graphics.lineTo(i * BAR_WIDTH / numBoxes - BAR_WIDTH / 2,BAR_HEIGHT / 2);
                    }
               }
          }
          
          public function get health() : Number
          {
               return this._health;
          }
          
          public function set health(value:Number) : void
          {
               this._health = value;
          }
          
          public function get totalMana() : Number
          {
               return this._totalMana;
          }
          
          public function set totalMana(value:Number) : void
          {
               this._totalMana = value;
          }
          
          public function get mana() : Number
          {
               return this._mana;
          }
          
          public function set mana(value:Number) : void
          {
               this._mana = value;
          }
     }
}
