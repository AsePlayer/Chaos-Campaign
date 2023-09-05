package com.brockw.stickwar.engine.multiplayer.moves
{
     import com.brockw.simulationSync.EndOfTurnMove;
     import com.brockw.simulationSync.Move;
     import com.smartfoxserver.v2.entities.data.SFSObject;
     
     public class MoveFactory
     {
           
          
          public function MoveFactory()
          {
               super();
          }
          
          public static function createMove(o:SFSObject) : Move
          {
               var c:UnitCreateMove = null;
               var e:EndOfTurnMove = null;
               var u:UnitMove = null;
               var endOfGameMove:EndOfGameMove = null;
               var forfeitMove:ForfeitMove = null;
               var pauseMove:PauseMove = null;
               var screenPositionUpdateMove:ScreenPositionUpdateMove = null;
               var globalMove:GlobalMove = null;
               var chatMove:ChatMove = null;
               if(o.getInt("type") == Commands.UNIT_CREATE_MOVE)
               {
                    c = new UnitCreateMove();
                    c.readFromSFSObject(o);
                    return c;
               }
               if(o.getInt("type") == Commands.END_OF_TURN)
               {
                    e = new EndOfTurnMove();
                    e.readFromSFSObject(o);
                    return e;
               }
               if(o.getInt("type") == Commands.UNIT_MOVE)
               {
                    u = new UnitMove();
                    u.readFromSFSObject(o);
                    return u;
               }
               if(o.getInt("type") == Commands.END_OF_GAME)
               {
                    endOfGameMove = new EndOfGameMove();
                    endOfGameMove.readFromSFSObject(o);
                    return endOfGameMove;
               }
               if(o.getInt("type") == Commands.FORFEIT)
               {
                    forfeitMove = new ForfeitMove();
                    forfeitMove.readFromSFSObject(o);
                    return forfeitMove;
               }
               if(o.getInt("type") == Commands.PAUSE)
               {
                    pauseMove = new PauseMove();
                    pauseMove.readFromSFSObject(o);
                    return pauseMove;
               }
               if(o.getInt("type") == Commands.SCREEN_POSITION_UPDATE)
               {
                    screenPositionUpdateMove = new ScreenPositionUpdateMove();
                    screenPositionUpdateMove.readFromSFSObject(o);
                    return screenPositionUpdateMove;
               }
               if(o.getInt("type") == Commands.GLOBAL_MOVE)
               {
                    globalMove = new GlobalMove();
                    globalMove.readFromSFSObject(o);
                    return globalMove;
               }
               if(o.getInt("type") == Commands.CHAT_MOVE)
               {
                    chatMove = new ChatMove();
                    chatMove.readFromSFSObject(o);
                    return chatMove;
               }
               throw new Error("No type of move!!: " + o.getInt("type"));
          }
          
          public static function createMoveFromString(type:int, data:Array) : Move
          {
               var c:UnitCreateMove = null;
               var e:EndOfTurnMove = null;
               var u:UnitMove = null;
               var endOfGameMove:EndOfGameMove = null;
               var forefeitMove:ForfeitMove = null;
               var pauseMove:PauseMove = null;
               var screenPositionUpdateMove:ScreenPositionUpdateMove = null;
               var globalMove:GlobalMove = null;
               var chatMove:ChatMove = null;
               var replayMove:ReplaySyncCheckMove = null;
               if(type == Commands.UNIT_CREATE_MOVE)
               {
                    c = new UnitCreateMove();
                    c.fromString(data);
                    return c;
               }
               if(type == Commands.END_OF_TURN)
               {
                    e = new EndOfTurnMove();
                    e.fromString(data);
                    return e;
               }
               if(type == Commands.UNIT_MOVE)
               {
                    u = new UnitMove();
                    u.fromString(data);
                    return u;
               }
               if(type == Commands.END_OF_GAME)
               {
                    endOfGameMove = new EndOfGameMove();
                    endOfGameMove.fromString(data);
                    return endOfGameMove;
               }
               if(type == Commands.FORFEIT)
               {
                    forefeitMove = new ForfeitMove();
                    forefeitMove.fromString(data);
                    return forefeitMove;
               }
               if(type == Commands.PAUSE)
               {
                    pauseMove = new PauseMove();
                    pauseMove.fromString(data);
                    return pauseMove;
               }
               if(type == Commands.SCREEN_POSITION_UPDATE)
               {
                    screenPositionUpdateMove = new ScreenPositionUpdateMove();
                    screenPositionUpdateMove.fromString(data);
                    return screenPositionUpdateMove;
               }
               if(type == Commands.GLOBAL_MOVE)
               {
                    globalMove = new GlobalMove();
                    globalMove.fromString(data);
                    return globalMove;
               }
               if(type == Commands.CHAT_MOVE)
               {
                    chatMove = new ChatMove();
                    chatMove.fromString(data);
                    return chatMove;
               }
               if(type == Commands.REPLAY_SYNC_CHECK)
               {
                    replayMove = new ReplaySyncCheckMove();
                    replayMove.fromString(data);
                    return replayMove;
               }
               throw new Error("No type of move!!: " + type);
          }
     }
}
