package com.brockw.stickwar.engine.multiplayer.moves
{
   public final class Commands
   {
      
      public static const END_OF_TURN:int = 0;
      
      public static const UNIT_CREATE_MOVE:int = 1;
      
      public static const UNIT_MOVE:int = 2;
      
      public static const END_OF_GAME:int = 3;
      
      public static const FORFEIT:int = 4;
      
      public static const PAUSE:int = 5;
      
      public static const SCREEN_POSITION_UPDATE:int = 6;
      
      public static const GLOBAL_MOVE:int = 7;
      
      public static const CHAT_MOVE:int = 8;
      
      public static const REPLAY_SYNC_CHECK:int = 9;
       
      
      public function Commands()
      {
         super();
      }
   }
}
