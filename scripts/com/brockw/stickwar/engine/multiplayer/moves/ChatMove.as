package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class ChatMove extends Move
   {
       
      
      public var message:String;
      
      public function ChatMove()
      {
         type = Commands.CHAT_MOVE;
         this.message = "";
         super();
      }
      
      override public function toString() : String
      {
         var s:String = super.toString();
         return s + (String(this.message) + " ");
      }
      
      override public function fromString(s:Array) : Boolean
      {
         super.fromString(s);
         this.message = String(s.shift());
         return true;
      }
      
      override public function readFromSFSObject(o:SFSObject) : void
      {
         readBasicsSFSObject(o);
         this.message = o.getUtfString("message");
      }
      
      override public function writeToSFSObject(o:SFSObject) : void
      {
         writeBasicsSFSObject(o);
         o.putUtfString("message",this.message);
      }
      
      override public function execute(game:Simulation) : void
      {
         var stickwar:StickWar = StickWar(game);
         var team:Team = stickwar.teamA;
         if(owner != team.name)
         {
            team = stickwar.teamB;
         }
         stickwar.gameScreen.userInterface.chat.messageReceived(this.message,team.realName);
      }
   }
}
