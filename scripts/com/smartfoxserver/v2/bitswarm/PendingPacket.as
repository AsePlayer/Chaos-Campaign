package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.core.PacketHeader;
   import flash.utils.ByteArray;
   
   public class PendingPacket
   {
       
      
      private var _header:PacketHeader;
      
      private var _buffer:ByteArray;
      
      public function PendingPacket(header:PacketHeader)
      {
         super();
         this._header = header;
         this._buffer = new ByteArray();
      }
      
      public function get header() : PacketHeader
      {
         return this._header;
      }
      
      public function get buffer() : ByteArray
      {
         return this._buffer;
      }
      
      public function set buffer(buffer:ByteArray) : void
      {
         this._buffer = buffer;
      }
   }
}
