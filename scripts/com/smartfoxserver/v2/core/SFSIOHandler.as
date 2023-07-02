package com.smartfoxserver.v2.core
{
   import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.bitswarm.IoHandler;
   import com.smartfoxserver.v2.bitswarm.PacketReadState;
   import com.smartfoxserver.v2.bitswarm.PendingPacket;
   import com.smartfoxserver.v2.exceptions.SFSCodecError;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.logging.Logger;
   import com.smartfoxserver.v2.protocol.IProtocolCodec;
   import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
   import flash.errors.IOError;
   import flash.utils.ByteArray;
   
   public class SFSIOHandler implements IoHandler
   {
      
      public static const SHORT_BYTE_SIZE:int = 2;
      
      public static const INT_BYTE_SIZE:int = 4;
       
      
      private var bitSwarm:BitSwarmClient;
      
      private var log:Logger;
      
      private var readState:int;
      
      private var pendingPacket:PendingPacket;
      
      private var protocolCodec:IProtocolCodec;
      
      private var fullPacketDump:Boolean = false;
      
      private const EMPTY_BUFFER:ByteArray = new ByteArray();
      
      public function SFSIOHandler(bitSwarm:BitSwarmClient)
      {
         super();
         this.bitSwarm = bitSwarm;
         this.log = Logger.getInstance();
         this.readState = PacketReadState.WAIT_NEW_PACKET;
         this.protocolCodec = new SFSProtocolCodec(this,bitSwarm);
      }
      
      public function enableFullPacketDump(b:Boolean) : void
      {
         this.fullPacketDump = b;
      }
      
      public function get codec() : IProtocolCodec
      {
         return this.protocolCodec;
      }
      
      public function set codec(codec:IProtocolCodec) : void
      {
         this.protocolCodec = codec;
      }
      
      public function onDataRead(data:ByteArray) : void
      {
         if(data.length == 0)
         {
            throw new SFSError("Unexpected empty packet data: no readable bytes available!");
         }
         if(this.bitSwarm != null && this.bitSwarm.sfs.debug)
         {
            if(data.length > 1024 && this.fullPacketDump == false)
            {
               this.log.info("Data Read: Size > 1024, dump omitted");
            }
            else
            {
               this.log.info("Data Read: " + DefaultObjectDumpFormatter.hexDump(data));
            }
         }
         data.position = 0;
         while(data.length > 0)
         {
            if(this.readState == PacketReadState.WAIT_NEW_PACKET)
            {
               data = this.handleNewPacket(data);
            }
            if(this.readState == PacketReadState.WAIT_DATA_SIZE)
            {
               data = this.handleDataSize(data);
            }
            if(this.readState == PacketReadState.WAIT_DATA_SIZE_FRAGMENT)
            {
               data = this.handleDataSizeFragment(data);
            }
            if(this.readState == PacketReadState.WAIT_DATA)
            {
               data = this.handlePacketData(data);
            }
         }
      }
      
      private function handleNewPacket(data:ByteArray) : ByteArray
      {
         this.log.debug("Handling New Packet");
         var headerByte:int = data.readByte();
         if(!(headerByte & 128) > 0)
         {
            throw new SFSError("Unexpected header byte: " + headerByte,0,DefaultObjectDumpFormatter.hexDump(data));
         }
         var header:PacketHeader = PacketHeader.fromBinary(headerByte);
         this.pendingPacket = new PendingPacket(header);
         this.readState = PacketReadState.WAIT_DATA_SIZE;
         return this.resizeByteArray(data,1,length - 1);
      }
      
      private function handleDataSize(data:ByteArray) : ByteArray
      {
         this.log.debug("Handling Header Size. Size: " + data.length + " (" + (this.pendingPacket.header.bigSized ? "big" : "small") + ")");
         var dataSize:int = -1;
         var sizeBytes:int = 2;
         if(this.pendingPacket.header.bigSized)
         {
            if(data.length >= 4)
            {
               dataSize = int(data.readUnsignedInt());
            }
            sizeBytes = 4;
         }
         else if(data.length >= 2)
         {
            dataSize = int(data.readUnsignedShort());
         }
         if(dataSize != -1)
         {
            this.pendingPacket.header.expectedLen = dataSize;
            data = this.resizeByteArray(data,sizeBytes,data.length - sizeBytes);
            this.readState = PacketReadState.WAIT_DATA;
         }
         else
         {
            this.readState = PacketReadState.WAIT_DATA_SIZE_FRAGMENT;
            this.pendingPacket.buffer.writeBytes(data);
            data = this.EMPTY_BUFFER;
         }
         return data;
      }
      
      private function handleDataSizeFragment(data:ByteArray) : ByteArray
      {
         var dataSize:int = 0;
         this.log.debug("Handling Size fragment. Data: " + data.length);
         var remaining:int = this.pendingPacket.header.bigSized ? 4 - this.pendingPacket.buffer.position : 2 - this.pendingPacket.buffer.position;
         if(data.length >= remaining)
         {
            this.pendingPacket.buffer.writeBytes(data,0,remaining);
            this.pendingPacket.buffer.position = 0;
            dataSize = this.pendingPacket.header.bigSized ? this.pendingPacket.buffer.readInt() : this.pendingPacket.buffer.readShort();
            this.log.debug("DataSize is ready:",dataSize,"bytes");
            this.pendingPacket.header.expectedLen = dataSize;
            this.pendingPacket.buffer = new ByteArray();
            this.readState = PacketReadState.WAIT_DATA;
            if(data.length > remaining)
            {
               data = this.resizeByteArray(data,remaining,data.length - remaining);
            }
            else
            {
               data = this.EMPTY_BUFFER;
            }
         }
         else
         {
            this.pendingPacket.buffer.writeBytes(data);
            data = this.EMPTY_BUFFER;
         }
         return data;
      }
      
      private function handlePacketData(data:ByteArray) : ByteArray
      {
         var remaining:int = this.pendingPacket.header.expectedLen - this.pendingPacket.buffer.length;
         var isThereMore:Boolean = data.length > remaining;
         this.log.debug("Handling Data: " + data.length + ", previous state: " + this.pendingPacket.buffer.length + "/" + this.pendingPacket.header.expectedLen);
         if(data.length >= remaining)
         {
            this.pendingPacket.buffer.writeBytes(data,0,remaining);
            this.log.debug("<<< Packet Complete >>>");
            if(this.pendingPacket.header.compressed)
            {
               this.pendingPacket.buffer.uncompress();
            }
            this.protocolCodec.onPacketRead(this.pendingPacket.buffer);
            this.readState = PacketReadState.WAIT_NEW_PACKET;
         }
         else
         {
            this.pendingPacket.buffer.writeBytes(data);
         }
         if(isThereMore)
         {
            data = this.resizeByteArray(data,remaining,data.length - remaining);
         }
         else
         {
            data = this.EMPTY_BUFFER;
         }
         return data;
      }
      
      private function resizeByteArray(array:ByteArray, pos:int, len:int) : ByteArray
      {
         var newArray:ByteArray = new ByteArray();
         newArray.writeBytes(array,pos,len);
         newArray.position = 0;
         return newArray;
      }
      
      public function onDataWrite(message:IMessage) : void
      {
         var writeBuffer:ByteArray = new ByteArray();
         var binData:ByteArray = message.content.toBinary();
         var isCompressed:Boolean = false;
         if(binData.length > this.bitSwarm.compressionThreshold)
         {
            binData.compress();
            isCompressed = true;
         }
         if(binData.length > this.bitSwarm.maxMessageSize)
         {
            throw new SFSCodecError("Message size is too big: " + binData.length + ", the server limit is: " + this.bitSwarm.maxMessageSize);
         }
         var sizeBytes:int = SHORT_BYTE_SIZE;
         if(binData.length > 65535)
         {
            sizeBytes = INT_BYTE_SIZE;
         }
         var packetHeader:PacketHeader = new PacketHeader(message.isEncrypted,isCompressed,false,sizeBytes == INT_BYTE_SIZE);
         writeBuffer.writeByte(packetHeader.encode());
         if(sizeBytes > SHORT_BYTE_SIZE)
         {
            writeBuffer.writeInt(binData.length);
         }
         else
         {
            writeBuffer.writeShort(binData.length);
         }
         writeBuffer.writeBytes(binData);
         if(this.bitSwarm.useBlueBox)
         {
            this.bitSwarm.httpSocket.send(writeBuffer);
         }
         else if(this.bitSwarm.socket.connected)
         {
            if(message.isUDP)
            {
               this.writeUDP(message,writeBuffer);
            }
            else
            {
               this.writeTCP(message,writeBuffer);
            }
         }
      }
      
      private function writeTCP(message:IMessage, writeBuffer:ByteArray) : void
      {
         try
         {
            this.bitSwarm.socket.writeBytes(writeBuffer);
            this.bitSwarm.socket.flush();
            if(this.bitSwarm.sfs.debug)
            {
               this.log.info("Data written: " + message.content.getHexDump());
            }
         }
         catch(error:IOError)
         {
            log.warn("WriteTCP operation failed due to I/O Error: " + error.toString());
         }
      }
      
      private function writeUDP(message:IMessage, writeBuffer:ByteArray) : void
      {
         this.bitSwarm.udpManager.send(writeBuffer);
      }
   }
}
