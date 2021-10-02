package com.smartfoxserver.v2.util
{
   public class SFSErrorCodes
   {
      
      private static var errorsByCode:Array = ["Client API version is obsolete: {0}; required version: {1}","Requested Zone {0} does not exist","User name {0} is not recognized","Wrong password for user {0}","User {0} is banned","Zone {0} is full","User {0} is already logged in Zone {1}","The server is full","Zone {0} is currently inactive","User name {0} contains bad words; filtered: {1}","Guest users not allowed in Zone {0}","IP address {0} is banned","A Room with the same name already exists: {0}","Requested Group is not available - Room: {0}; Group: {1}","Bad Room name length -  Min: {0}; max: {1}; passed name length: {2}","Room name contains bad words: {0}","Zone is full; can\'t add Rooms anymore","You have exceeded the number of Rooms that you can create per session: {0}","Room creation failed, wrong parameter: {0}","User {0} already joined in Room","Room {0} is full","Wrong password for Room {0}","Requested Room does not exist","Room {0} is locked","Group {0} is already subscribed","Group {0} does not exist","Group {0} is not subscribed","Group {0} does not exist","{0}","Room permission error; Room {0} cannot be renamed","Room permission error; Room {0} cannot change password state","Room permission error; Room {0} cannot change capacity","Switch user error; no player slots available in Room {0}","Switch user error; no spectator slots available in Room {0}","Switch user error; Room {0} is not a Game Room","Switch user error; you are not joined in Room {0}","Buddy Manager initialization error, could not load buddy list: {0}","Buddy Manager error, your buddy list is full; size is {0}","Buddy Manager error, was not able to block buddy {0} because offline","Buddy Manager error, you are attempting to set too many Buddy Variables; limit is {0}","Game {0} access denied, user does not match access criteria","QuickJoinGame action failed: no matching Rooms were found","Your previous invitation reply was invalid or arrived too late"];
       
      
      public function SFSErrorCodes()
      {
         super();
         throw new Error("This class cannot be instantiated. Please check the documentation for more details on its usage");
      }
      
      public static function setErrorMessage(code:int, message:String) : void
      {
         errorsByCode[code] = message;
      }
      
      public static function getErrorMessage(code:int, params:Array = null) : String
      {
         return stringFormat(errorsByCode[code],params);
      }
      
      private static function stringFormat(ss:String, params:Array) : String
      {
         var j:int = 0;
         var src:String = null;
         if(ss == null)
         {
            return "";
         }
         if(params != null)
         {
            for(j = 0; j < params.length; j++)
            {
               src = "{" + j + "}";
               ss = ss.replace(src,params[j]);
            }
         }
         return ss;
      }
   }
}
