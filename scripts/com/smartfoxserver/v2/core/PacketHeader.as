package com.smartfoxserver.v2.core
{
   public class PacketHeader
   {
       
      
      private var _expectedLen:int;
      
      private var _binary:Boolean;
      
      private var _compressed:Boolean;
      
      private var _encrypted:Boolean;
      
      private var _blueBoxed:Boolean;
      
      private var _bigSized:Boolean;
      
      public function PacketHeader(encrypted:Boolean, compressed:Boolean = false, blueBoxed:Boolean = false, bigSized:Boolean = false)
      {
         super();
         this._expectedLen = -1;
         this._binary = true;
         this._compressed = compressed;
         this._encrypted = encrypted;
         this._blueBoxed = blueBoxed;
         this._bigSized = bigSized;
      }
      
      public static function fromBinary(headerByte:int) : PacketHeader
      {
         return new PacketHeader((headerByte & 64) > 0,(headerByte & 32) > 0,(headerByte & 16) > 0,(headerByte & 8) > 0);
      }
      
      public function get expectedLen() : int
      {
         return this._expectedLen;
      }
      
      public function set expectedLen(value:int) : void
      {
         this._expectedLen = value;
      }
      
      public function get binary() : Boolean
      {
         return this._binary;
      }
      
      public function set binary(value:Boolean) : void
      {
         this._binary = value;
      }
      
      public function get compressed() : Boolean
      {
         return this._compressed;
      }
      
      public function set compressed(value:Boolean) : void
      {
         this._compressed = value;
      }
      
      public function get encrypted() : Boolean
      {
         return this._encrypted;
      }
      
      public function set encrypted(value:Boolean) : void
      {
         this._encrypted = value;
      }
      
      public function get blueBoxed() : Boolean
      {
         return this._blueBoxed;
      }
      
      public function set blueBoxed(value:Boolean) : void
      {
         this._blueBoxed = value;
      }
      
      public function get bigSized() : Boolean
      {
         return this._bigSized;
      }
      
      public function set bigSized(value:Boolean) : void
      {
         this._bigSized = value;
      }
      
      public function encode() : int
      {
         var headerByte:int = 0;
         if(this.binary)
         {
            headerByte += 128;
         }
         if(this.encrypted)
         {
            headerByte += 64;
         }
         if(this.compressed)
         {
            headerByte += 32;
         }
         if(this.blueBoxed)
         {
            headerByte += 16;
         }
         if(this.bigSized)
         {
            headerByte += 8;
         }
         return headerByte;
      }
      
      public function toString() : String
      {
         var buf:String = "";
         buf += "---------------------------------------------\n";
         buf += "Binary:  \t" + this.binary + "\n";
         buf += "Compressed:\t" + this.compressed + "\n";
         buf += "Encrypted:\t" + this.encrypted + "\n";
         buf += "BlueBoxed:\t" + this.blueBoxed + "\n";
         buf += "BigSized:\t" + this.bigSized + "\n";
         return buf + "---------------------------------------------\n";
      }
   }
}
