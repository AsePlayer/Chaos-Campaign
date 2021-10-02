package de.polygonal.core.fmt
{
   public class NumberFormat
   {
      
      public static var _hexLUT:Array = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
       
      
      public function NumberFormat()
      {
      }
      
      public static function toBin(x:int, byteDelimiter:String = undefined, leadingZeros:Boolean = false) : String
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         if(byteDelimiter == null)
         {
            byteDelimiter = "";
         }
         _loc5_ = x;
         var _loc4_:int = 32 - (_loc5_ < 0 ? 0 : (_loc5_ |= _loc5_ >> 1, _loc5_ |= _loc5_ >> 2, _loc5_ |= _loc5_ >> 4, _loc5_ |= _loc5_ >> 8, _loc5_ |= _loc5_ >> 16, _loc6_ = _loc5_, _loc6_ -= _loc6_ >> 1 & 1431655765, _loc6_ = (_loc6_ >> 2 & 858993459) + (_loc6_ & 858993459), _loc6_ = (_loc6_ >> 4) + _loc6_ & 252645135, _loc6_ += _loc6_ >> 8, _loc6_ += _loc6_ >> 16, 32 - (_loc6_ & 63)));
         var _loc7_:String = (x & 1) > 0 ? "1" : "0";
         x >>= 1;
         _loc5_ = 1;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc5_++;
            _loc7_ = ((x & 1) > 0 ? "1" : "0") + ((_loc6_ & 7) == 0 ? byteDelimiter : "") + _loc7_;
            x >>= 1;
         }
         if(leadingZeros)
         {
            _loc5_ = 0;
            _loc6_ = 32 - _loc4_;
            while(_loc5_ < _loc6_)
            {
               _loc8_ = _loc5_++;
               _loc7_ = "0" + _loc7_;
            }
         }
         return _loc7_;
      }
      
      public static function toHex(x:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:Array = NumberFormat._hexLUT;
         while(x != 0)
         {
            _loc2_ = _loc3_[x & 15] + _loc2_;
            x >>>= 4;
         }
         return _loc2_;
      }
      
      public static function toOct(x:int) : String
      {
         var _loc4_:int = 0;
         var _loc2_:String = "";
         var _loc3_:int = x;
         while(_loc3_ > 0)
         {
            _loc4_ = _loc3_ & 7;
            _loc2_ = _loc4_ + _loc2_;
            _loc3_ >>= 3;
         }
         return _loc2_;
      }
      
      public static function toRadix(x:int, radix:int) : String
      {
         var _loc5_:int = 0;
         var _loc3_:String = "";
         var _loc4_:int = x;
         while(_loc4_ > 0)
         {
            _loc5_ = int(_loc4_ % radix);
            _loc3_ = _loc5_ + _loc3_;
            _loc4_ /= radix;
         }
         return _loc3_;
      }
      
      public static function toFixed(x:Number, decimalPlaces:int) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as String;
         if(Math.isNaN(x))
         {
            return "NaN";
         }
         _loc4_ = 10;
         _loc5_ = decimalPlaces;
         _loc6_ = 1;
         _loc7_ = 0;
         while(true)
         {
            if((_loc5_ & 1) != 0)
            {
               _loc6_ = _loc4_ * _loc6_;
            }
            _loc5_ >>= 1;
            if(_loc5_ == 0)
            {
               _loc7_ = _loc6_;
               break;
            }
            _loc4_ *= _loc4_;
         }
         _loc3_ = _loc7_;
         _loc8_ = Std.string(int(x * _loc3_) / _loc3_);
         _loc4_ = int(_loc8_.indexOf("."));
         if(_loc4_ != -1)
         {
            _loc5_ = _loc8_.substr(_loc4_ + 1).length;
            while(_loc5_ < decimalPlaces)
            {
               _loc6_ = _loc5_++;
               _loc8_ += "0";
            }
         }
         else
         {
            _loc8_ += ".";
            _loc5_ = 0;
            while(_loc5_ < decimalPlaces)
            {
               _loc6_ = _loc5_++;
               _loc8_ += "0";
            }
         }
         return _loc8_;
      }
      
      public static function toMMSS(x:int) : String
      {
         var _loc2_:int = int(x % 1000);
         var _loc3_:Number = (x - _loc2_) / 1000;
         var _loc4_:Number = _loc3_ % 60;
         return ("0" + (_loc3_ - _loc4_) / 60).substr(-2) + ":" + ("0" + _loc4_).substr(-2);
      }
      
      public static function groupDigits(x:int, thousandsSeparator:String = undefined) : String
      {
         var _loc6_:* = null as String;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(thousandsSeparator == null)
         {
            thousandsSeparator = ".";
         }
         var _loc3_:Number = x;
         var _loc4_:int = 0;
         while(_loc3_ > 1)
         {
            _loc3_ /= 10;
            _loc4_++;
         }
         _loc4_ /= 3;
         var _loc5_:String = Std.string(x);
         if(_loc4_ == 0)
         {
            return _loc5_;
         }
         _loc6_ = "";
         _loc7_ = 0;
         _loc8_ = _loc5_.length - 1;
         while(_loc8_ >= 0)
         {
            if(_loc7_ == 3)
            {
               _loc6_ = _loc5_.charAt(_loc8_--) + thousandsSeparator + _loc6_;
               _loc7_ = 0;
               _loc4_--;
            }
            else
            {
               _loc6_ = _loc5_.charAt(_loc8_--) + _loc6_;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      public static function centToEuro(x:int, decimalSeparator:String = undefined, thousandsSeparator:String = undefined) : String
      {
         var _loc5_:* = null as String;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(decimalSeparator == null)
         {
            decimalSeparator = ",";
         }
         if(thousandsSeparator == null)
         {
            thousandsSeparator = ".";
         }
         var _loc4_:int = int(x / 100);
         if(_loc4_ == 0)
         {
            if(x < 10)
            {
               return "0" + decimalSeparator + "0" + x;
            }
            return "0" + decimalSeparator + x;
         }
         _loc6_ = x - _loc4_ * 100;
         if(_loc6_ < 10)
         {
            _loc5_ = decimalSeparator + "0" + _loc6_;
         }
         else
         {
            _loc5_ = decimalSeparator + _loc6_;
         }
         if(_loc4_ >= 1000)
         {
            _loc7_ = _loc4_;
            while(_loc7_ >= 1000)
            {
               _loc7_ = int(_loc4_ / 1000);
               _loc8_ = _loc4_ - _loc7_ * 1000;
               if(_loc8_ < 10)
               {
                  _loc5_ = thousandsSeparator + "00" + _loc8_ + _loc5_;
               }
               else if(_loc8_ < 100)
               {
                  _loc5_ = thousandsSeparator + "0" + _loc8_ + _loc5_;
               }
               else
               {
                  _loc5_ = thousandsSeparator + _loc8_ + _loc5_;
               }
               _loc4_ = _loc7_;
            }
            return _loc7_ + _loc5_;
         }
         return _loc4_ + _loc5_;
      }
   }
}
