package com.brockw.stickwar.engine.multiplayer.moves
{
     import com.brockw.simulationSync.Move;
     import com.brockw.simulationSync.Simulation;
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.replay.ReplayGameScreen;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     
     public class ScreenPositionUpdateMove extends Move
     {
           
          
          public var pos:int;
          
          public function ScreenPositionUpdateMove()
          {
               type = Commands.SCREEN_POSITION_UPDATE;
               this.pos = 0;
               super();
          }
          
          override public function toString() : String
          {
               var s:String = super.toString();
               return s + (String(this.pos) + " ");
          }
          
          override public function fromString(s:Array) : Boolean
          {
               super.fromString(s);
               this.pos = int(s.shift());
               return true;
          }
          
          override public function readFromSFSObject(o:SFSObject) : void
          {
               readBasicsSFSObject(o);
               this.pos = o.getInt("pos");
          }
          
          override public function writeToSFSObject(o:SFSObject) : void
          {
               writeBasicsSFSObject(o);
               o.putInt("pos",this.pos);
          }
          
          override public function execute(game:Simulation) : void
          {
               if(!game.isReplay)
               {
                    return;
               }
               var stickwar:StickWar = StickWar(game);
               if(stickwar.gameScreen is ReplayGameScreen)
               {
                    if(ReplayGameScreen(stickwar.gameScreen).hasFreeCamera)
                    {
                         return;
                    }
               }
               if(stickwar.teamA.id == owner)
               {
                    stickwar.teamA.lastScreenLookPosition = this.pos;
               }
               else if(stickwar.teamB.id == owner)
               {
                    stickwar.teamB.lastScreenLookPosition = this.pos;
               }
               if(this.owner == stickwar.team.id)
               {
                    stickwar.gameScreen.userInterface.isSlowCamera = true;
                    stickwar.targetScreenX = this.pos;
                    if(Math.abs(stickwar.targetScreenX - stickwar.screenX) > stickwar.map.screenWidth)
                    {
                         stickwar.gameScreen.userInterface.isSlowCamera = false;
                    }
               }
          }
     }
}
