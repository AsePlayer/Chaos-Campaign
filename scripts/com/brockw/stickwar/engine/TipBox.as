package com.brockw.stickwar.engine
{
   import flash.display.*;
   import flash.text.TextField;
   
   public class TipBox extends Sprite
   {
       
      
      private var _toolBox:toolBoxMc;
      
      private var showCount:int;
      
      private var toolBoxShowTime:int;
      
      private var isShowing:Boolean;
      
      public function TipBox(game:StickWar)
      {
         super();
         this.toolBox = new toolBoxMc();
         this.showCount = 0;
         this.toolBoxShowTime = game.xml.xml.toolBoxShowTime;
         this.isShowing = false;
      }
      
      public function update(game:StickWar) : void
      {
         if(this.isShowing)
         {
            ++this.showCount;
            if(this.showCount > this.toolBoxShowTime && !game.gameScreen.isFastForwardFrame)
            {
               removeChild(this.toolBox);
               this.isShowing = false;
            }
         }
      }
      
      private function setField(data:String, field:TextField) : void
      {
         field.text = data;
         field.visible = true;
      }
      
      public function displayTip(title:String, info:String, time:int = 0, gold:int = 0, mana:int = 0, population:int = 0, hideStats:Boolean = false) : void
      {
         this.setField(info,this.toolBox.textBox.text);
         this.setField(title,this.toolBox.title);
         if(!hideStats)
         {
            this.toolBox.statDisplay.visible = true;
            this.toolBox.textBox.y = 497.6;
            this.setField("" + gold,this.toolBox.statDisplay.gold);
            this.setField("" + Math.round(time / 30) + "s",this.toolBox.statDisplay.time);
            this.setField("" + mana,this.toolBox.statDisplay.mana);
            if(population == 0)
            {
               this.toolBox.statDisplay.population.visible = false;
               this.toolBox.statDisplay.populationSymbol.visible = false;
            }
            else
            {
               this.toolBox.statDisplay.population.visible = true;
               this.toolBox.statDisplay.populationSymbol.visible = true;
               this.setField("" + population,this.toolBox.statDisplay.population);
            }
         }
         else
         {
            this.toolBox.statDisplay.visible = false;
            this.toolBox.textBox.y = 421.6;
         }
         if(!this.contains(this.toolBox))
         {
            addChild(this.toolBox);
         }
         this.showCount = 0;
         this.isShowing = true;
      }
      
      public function get toolBox() : toolBoxMc
      {
         return this._toolBox;
      }
      
      public function set toolBox(value:toolBoxMc) : void
      {
         this._toolBox = value;
      }
   }
}
