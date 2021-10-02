package com.brockw.stickwar.engine.multiplayer
{
   import fl.controls.ScrollPolicy;
   
   public class NewsPanel extends newsPanelMc
   {
       
      
      public var index:int;
      
      public var id:int;
      
      public function NewsPanel(title:String, message:String, date:String, type:int, index:int, youtubeId:String, id:int)
      {
         super();
         this.title.text = title;
         var messageBox:messageContainer = new messageContainer();
         messageBox.y += 5;
         messageBox.message.htmlText = message;
         messageBox.message.mouseWheelEnabled = false;
         this.dateBox.text = date;
         messageBox.message.height = messageBox.message.textHeight + 5;
         scrollPane.source = messageBox;
         scrollPane.setSize(scrollPane.width,scrollPane.height);
         scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
         scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
         scrollPane.update();
         this.index = index;
         this.id = id;
         this.gotoAndStop(getNewsTypeById(type));
      }
      
      public static function getNewsTypeById(id:int) : String
      {
         if(id == 1)
         {
            return "News";
         }
         if(id == 2)
         {
            return "Patch";
         }
         if(id == 3)
         {
            return "Art";
         }
         if(id == 4)
         {
            return "Community";
         }
         return "News";
      }
      
      public function update() : void
      {
         scrollPane.update();
      }
   }
}
