package com.smartfoxserver.v2.core
{
   import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
   import com.smartfoxserver.v2.bitswarm.IController;
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.bitswarm.IoHandler;
   import com.smartfoxserver.v2.bitswarm.Message;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.exceptions.SFSCodecError;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.logging.Logger;
   import com.smartfoxserver.v2.protocol.IProtocolCodec;
   import flash.utils.ByteArray;
   
   public class SFSProtocolCodec implements IProtocolCodec
   {
      
      private static const CONTROLLER_ID:String = "c";
      
      private static const ACTION_ID:String = "a";
      
      private static const PARAM_ID:String = "p";
      
      private static const USER_ID:String = "u";
      
      private static const UDP_PACKET_ID:String = "i";
       
      
      private var _ioHandler:IoHandler;
      
      private var log:Logger;
      
      private var bitSwarm:BitSwarmClient;
      
      public function SFSProtocolCodec(ioHandler:IoHandler, bitSwarm:BitSwarmClient)
      {
         super();
         this._ioHandler = ioHandler;
         this.log = Logger.getInstance();
         this.bitSwarm = bitSwarm;
      }
      
      public function onPacketRead(packet:*) : void
      {
         var sfsObj:ISFSObject = null;
         if(packet is ByteArray)
         {
            sfsObj = SFSObject.newFromBinaryData(packet);
         }
         else
         {
            sfsObj = packet as ISFSObject;
         }
         this.dispatchRequest(sfsObj);
      }
      
      public function onPacketWrite(message:IMessage) : void
      {
         var sfsObj:ISFSObject = null;
         if(message.isUDP)
         {
            sfsObj = this.prepareUDPPacket(message);
         }
         else
         {
            sfsObj = this.prepareTCPPacket(message);
         }
         message.content = sfsObj;
         if(this.bitSwarm.sfs.debug)
         {
            this.log.info("Object going out: " + message.content.getDump());
         }
         this.ioHandler.onDataWrite(message);
      }
      
      private function prepareTCPPacket(message:IMessage) : ISFSObject
      {
         var sfsObj:ISFSObject = new SFSObject();
         sfsObj.putByte(CONTROLLER_ID,message.targetController);
         sfsObj.putShort(ACTION_ID,message.id);
         sfsObj.putSFSObject(PARAM_ID,message.content);
         return sfsObj;
      }
      
      private function prepareUDPPacket(message:IMessage) : ISFSObject
      {
         var sfsObj:ISFSObject = new SFSObject();
         sfsObj.putByte(CONTROLLER_ID,message.targetController);
         sfsObj.putInt(USER_ID,this.bitSwarm.sfs.mySelf != null ? int(this.bitSwarm.sfs.mySelf.id) : -1);
         sfsObj.putLong(UDP_PACKET_ID,this.bitSwarm.nextUdpPacketId());
         sfsObj.putSFSObject(PARAM_ID,message.content);
         return sfsObj;
      }
      
      public function get ioHandler() : IoHandler
      {
         return this._ioHandler;
      }
      
      public function set ioHandler(handler:IoHandler) : void
      {
         if(this._ioHandler != null)
         {
            throw new SFSError("IOHandler is already defined for thir ProtocolHandler instance: " + this);
         }
         this._ioHandler = this.ioHandler;
      }
      
      private function dispatchRequest(requestObject:ISFSObject) : void
      {
         var message:IMessage = new Message();
         if(requestObject.isNull(CONTROLLER_ID))
         {
            throw new SFSCodecError("Request rejected: No Controller ID in request!");
         }
         if(requestObject.isNull(ACTION_ID))
         {
            throw new SFSCodecError("Request rejected: No Action ID in request!");
         }
         message.id = requestObject.getByte(ACTION_ID);
         message.content = requestObject.getSFSObject(PARAM_ID);
         message.isUDP = requestObject.containsKey(UDP_PACKET_ID);
         if(message.isUDP)
         {
            message.packetId = requestObject.getLong(UDP_PACKET_ID);
         }
         var controllerId:int = int(requestObject.getByte(CONTROLLER_ID));
         var controller:IController = this.bitSwarm.getController(controllerId);
         if(controller == null)
         {
            throw new SFSError("Cannot handle server response. Unknown controller, id: " + controllerId);
         }
         controller.handleMessage(message);
      }
   }
}
