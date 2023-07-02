package com.smartfoxserver.v2.protocol.serialization
{
   import com.smartfoxserver.v2.exceptions.SFSError;
   import flash.utils.ByteArray;
   
   public class DefaultObjectDumpFormatter
   {
      
      public static const TOKEN_INDENT_OPEN:String = "{";
      
      public static const TOKEN_INDENT_CLOSE:String = "}";
      
      public static const TOKEN_DIVIDER:String = ";";
      
      public static const NEW_LINE:String = "\n";
      
      public static const TAB:String = "\t";
      
      public static const DOT:String = ".";
      
      public static const HEX_BYTES_PER_LINE:int = 16;
       
      
      public function DefaultObjectDumpFormatter()
      {
         super();
      }
      
      public static function prettyPrintByteArray(ba:ByteArray) : String
      {
         if(ba == null)
         {
            return "Null";
         }
         return "Byte[" + ba.length + "]";
      }
      
      public static function prettyPrintDump(rawDump:String) : String
      {
         var ch:String = null;
         var strBuf:String = "";
         var indentPos:int = 0;
         var lastChar:String = null;
         for(var i:int = 0; i < rawDump.length; i++)
         {
            ch = rawDump.charAt(i);
            if(ch == TOKEN_INDENT_OPEN)
            {
               indentPos++;
               strBuf += NEW_LINE + getFormatTabs(indentPos);
            }
            else if(ch == TOKEN_INDENT_CLOSE)
            {
               indentPos--;
               if(indentPos < 0)
               {
                  throw new SFSError("DumpFormatter: the indentPos is negative. TOKENS ARE NOT BALANCED!");
               }
               strBuf += NEW_LINE + getFormatTabs(indentPos);
            }
            else if(ch == TOKEN_DIVIDER)
            {
               strBuf += NEW_LINE + getFormatTabs(indentPos);
            }
            else
            {
               strBuf += ch;
            }
         }
         if(indentPos != 0)
         {
            throw new SFSError("DumpFormatter: the indentPos is not == 0. TOKENS ARE NOT BALANCED!");
         }
         return strBuf;
      }
      
      private static function getFormatTabs(howMany:int) : String
      {
         return strFill(TAB,howMany);
      }
      
      private static function strFill(ch:String, howMany:int) : String
      {
         var strBuf:String = "";
         for(var i:int = 0; i < howMany; i++)
         {
            strBuf += ch;
         }
         return strBuf;
      }
      
      public static function hexDump(ba:ByteArray, bytesPerLine:int = -1) : String
      {
         var currChar:String = null;
         var currByte:int = 0;
         var hexByte:String = null;
         var j:int = 0;
         var savedByteArrayPosition:int = int(ba.position);
         ba.position = 0;
         if(bytesPerLine == -1)
         {
            bytesPerLine = HEX_BYTES_PER_LINE;
         }
         var sb:String = "Binary Size: " + ba.length + NEW_LINE;
         var hexLine:String = "";
         var chrLine:String = "";
         var index:int = 0;
         var count:int = 0;
         do
         {
            currByte = ba.readByte() & 255;
            hexByte = currByte.toString(16).toUpperCase();
            if(hexByte.length == 1)
            {
               hexByte = "0" + hexByte;
            }
            hexLine += hexByte + " ";
            if(currByte >= 33 && currByte <= 126)
            {
               currChar = String.fromCharCode(currByte);
            }
            else
            {
               currChar = DOT;
            }
            chrLine += currChar;
            if(++count == bytesPerLine)
            {
               count = 0;
               sb += hexLine + TAB + chrLine + NEW_LINE;
               hexLine = "";
               chrLine = "";
            }
         }
         while(++index < ba.length);
         
         if(count != 0)
         {
            for(j = bytesPerLine - count; j > 0; j--)
            {
               hexLine += "   ";
               chrLine += " ";
            }
            sb += hexLine + TAB + chrLine + NEW_LINE;
         }
         ba.position = savedByteArrayPosition;
         return sb;
      }
   }
}
