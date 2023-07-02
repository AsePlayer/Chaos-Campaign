package com.brockw.stickwar.engine
{
   import com.brockw.game.*;
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.multiplayer.MultiplayerGameScreen;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.smartfoxserver.v2.entities.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.*;
   import flash.text.StyleSheet;
   
   public class Chat extends InGameChatMc
   {
       
      
      private var gameScreen:GameScreen;
      
      private var _isInput:Boolean;
      
      private var lastMessageCount:int;
      
      public function Chat(gameScreen:GameScreen)
      {
         var styleObj:Object = null;
         super();
         this.gameScreen = gameScreen;
         this.lastMessageCount = 10000;
         this.isInput = false;
         chatInput.alpha = 0;
         this.backOfChat.alpha = 0;
         backBox.alpha = 0;
         alpha = 0;
         var style:StyleSheet = new StyleSheet();
         styleObj = new Object();
         styleObj.color = "#FFFFFF";
         style.setStyle(".myText",styleObj);
         styleObj = new Object();
         styleObj.color = "#FF0000";
         style.setStyle(".theirText",styleObj);
         chatOutput.styleSheet = style;
         chatOutput.htmlText = "";
      }
      
      public function messageReceived(message:String, sender:String) : void
      {
         var newLine:String = sender + ": " + message;
         newLine = newLine.replace("\n","");
         newLine = newLine.replace("\r","");
         newLine = newLine.replace("<","");
         newLine = newLine.replace(">","");
         if(sender == this.gameScreen.team.realName)
         {
            chatOutput.htmlText += "<span class=\'myText\'>" + newLine + "</span><br>";
         }
         else
         {
            chatOutput.htmlText += "<span class=\'theirText\'>" + newLine + "</span><br>";
         }
         this.lastMessageCount = 0;
      }
      
      public function update() : void
      {
         chatOutput.scrollV = chatOutput.numLines;
         ++this.lastMessageCount;
         if(this.lastMessageCount > 30 * 6 && !this._isInput)
         {
            this.alpha = 0;
            if(chatInput.alpha == 1)
            {
               this.sendInput();
            }
            chatInput.alpha = 0;
            backBox.alpha = 0;
            this.backOfChat.alpha = 0;
         }
         else
         {
            this.alpha = 1;
         }
         if(this._isInput)
         {
            stage.focus = chatInput;
         }
         var isDisabledState:Boolean = this.gameScreen.userInterface.keyBoardState.isDisabled;
         this.gameScreen.userInterface.keyBoardState.isDisabled = false;
         if(this.gameScreen.userInterface.keyBoardState.isPressed(13) && this.gameScreen is MultiplayerGameScreen)
         {
            if(this.isInput)
            {
               this.sendInput();
            }
            else
            {
               this.activateInput();
            }
         }
         this.gameScreen.userInterface.keyBoardState.isDisabled = isDisabledState;
      }
      
      private function activateInput() : void
      {
         if(this.isInput == false)
         {
            this.gameScreen.userInterface.actionInterface.clear();
            chatInput.selectable = false;
            stage.focus = chatInput;
            chatInput.text = "";
            addChild(chatInput);
            this.isInput = true;
            this.lastMessageCount = 0;
            chatInput.alpha = 1;
            backBox.alpha = 1;
            this.backOfChat.alpha = 1;
         }
      }
      
      private function sendInput() : void
      {
         var chatMove:ChatMove = null;
         if(this.contains(chatInput))
         {
            if(chatInput.text != "" && chatInput.text.charAt(0) != "\n" && chatInput.text.charAt(0) != "\r")
            {
               chatMove = new ChatMove();
               chatMove.message = chatInput.text;
               this.gameScreen.doMove(chatMove,this.gameScreen.team.id);
            }
            stage.focus = stage;
            this.isInput = false;
         }
         chatInput.alpha = 0;
         backBox.alpha = 0;
         this.backOfChat.alpha = 0;
      }
      
      public function get isInput() : Boolean
      {
         return this._isInput;
      }
      
      public function set isInput(value:Boolean) : void
      {
         this._isInput = value;
      }
   }
}
