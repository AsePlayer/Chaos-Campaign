package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.SmartFox;
   import flash.utils.ByteArray;
   
   public interface IUDPManager
   {
       
      
      function initialize(udpAddr:String, udpPort:int) : void;
      
      function get inited() : Boolean;
      
      function set sfs(sfs:SmartFox) : void;
      
      function nextUdpPacketId() : Number;
      
      function send(binaryData:ByteArray) : void;
      
      function reset() : void;
   }
}
