package com.smartfoxserver.v2.bitswarm
{
   public interface IController
   {
       
      
      function get id() : int;
      
      function set id(value:int) : void;
      
      function handleMessage(message:IMessage) : void;
   }
}
