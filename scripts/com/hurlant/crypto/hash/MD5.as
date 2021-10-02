package com.hurlant.crypto.hash
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class MD5 implements IHash
   {
      
      public static const HASH_SIZE:int = 16;
       
      
      public function MD5()
      {
         super();
      }
      
      private function ff(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, t:uint) : uint
      {
         return cmn(b & c | ~b & d,a,b,x,s,t);
      }
      
      private function hh(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, t:uint) : uint
      {
         return cmn(b ^ c ^ d,a,b,x,s,t);
      }
      
      private function cmn(q:uint, a:uint, b:uint, x:uint, s:uint, t:uint) : uint
      {
         return rol(a + q + x + t,s) + b;
      }
      
      public function getHashSize() : uint
      {
         return HASH_SIZE;
      }
      
      private function ii(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, t:uint) : uint
      {
         return cmn(c ^ (b | ~d),a,b,x,s,t);
      }
      
      private function rol(num:uint, cnt:uint) : uint
      {
         return num << cnt | num >>> 32 - cnt;
      }
      
      public function toString() : String
      {
         return "md5";
      }
      
      public function getInputSize() : uint
      {
         return 64;
      }
      
      private function gg(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, t:uint) : uint
      {
         return cmn(b & d | c & ~d,a,b,x,s,t);
      }
      
      public function hash(src:ByteArray) : ByteArray
      {
         var len:uint = 0;
         var savedEndian:String = null;
         var a:Array = null;
         var i:uint = 0;
         var h:Array = null;
         var out:ByteArray = null;
         len = src.length * 8;
         savedEndian = src.endian;
         while(src.length % 4 != 0)
         {
            src[src.length] = 0;
         }
         src.position = 0;
         a = [];
         src.endian = Endian.LITTLE_ENDIAN;
         for(i = 0; i < src.length; i += 4)
         {
            a.push(src.readUnsignedInt());
         }
         h = core_md5(a,len);
         out = new ByteArray();
         out.endian = Endian.LITTLE_ENDIAN;
         for(i = 0; i < 4; i++)
         {
            out.writeUnsignedInt(h[i]);
         }
         src.length = len / 8;
         src.endian = savedEndian;
         return out;
      }
      
      private function core_md5(x:Array, len:uint) : Array
      {
         var a:uint = 0;
         var b:uint = 0;
         var c:uint = 0;
         var d:uint = 0;
         var i:uint = 0;
         var olda:uint = 0;
         var oldb:uint = 0;
         var oldc:uint = 0;
         var oldd:uint = 0;
         x[len >> 5] |= 128 << len % 32;
         x[(len + 64 >>> 9 << 4) + 14] = len;
         a = 1732584193;
         b = 4023233417;
         c = 2562383102;
         d = 271733878;
         for(i = 0; i < x.length; i += 16)
         {
            x[i] = x[i] || 0;
            x[i + 1] = x[i + 1] || 0;
            x[i + 2] = x[i + 2] || 0;
            x[i + 3] = x[i + 3] || 0;
            x[i + 4] = x[i + 4] || 0;
            x[i + 5] = x[i + 5] || 0;
            x[i + 6] = x[i + 6] || 0;
            x[i + 7] = x[i + 7] || 0;
            x[i + 8] = x[i + 8] || 0;
            x[i + 9] = x[i + 9] || 0;
            x[i + 10] = x[i + 10] || 0;
            x[i + 11] = x[i + 11] || 0;
            x[i + 12] = x[i + 12] || 0;
            x[i + 13] = x[i + 13] || 0;
            x[i + 14] = x[i + 14] || 0;
            x[i + 15] = x[i + 15] || 0;
            olda = a;
            oldb = b;
            oldc = c;
            oldd = d;
            a = ff(a,b,c,d,x[i + 0],7,3614090360);
            d = ff(d,a,b,c,x[i + 1],12,3905402710);
            c = ff(c,d,a,b,x[i + 2],17,606105819);
            b = ff(b,c,d,a,x[i + 3],22,3250441966);
            a = ff(a,b,c,d,x[i + 4],7,4118548399);
            d = ff(d,a,b,c,x[i + 5],12,1200080426);
            c = ff(c,d,a,b,x[i + 6],17,2821735955);
            b = ff(b,c,d,a,x[i + 7],22,4249261313);
            a = ff(a,b,c,d,x[i + 8],7,1770035416);
            d = ff(d,a,b,c,x[i + 9],12,2336552879);
            c = ff(c,d,a,b,x[i + 10],17,4294925233);
            b = ff(b,c,d,a,x[i + 11],22,2304563134);
            a = ff(a,b,c,d,x[i + 12],7,1804603682);
            d = ff(d,a,b,c,x[i + 13],12,4254626195);
            c = ff(c,d,a,b,x[i + 14],17,2792965006);
            b = ff(b,c,d,a,x[i + 15],22,1236535329);
            a = gg(a,b,c,d,x[i + 1],5,4129170786);
            d = gg(d,a,b,c,x[i + 6],9,3225465664);
            c = gg(c,d,a,b,x[i + 11],14,643717713);
            b = gg(b,c,d,a,x[i + 0],20,3921069994);
            a = gg(a,b,c,d,x[i + 5],5,3593408605);
            d = gg(d,a,b,c,x[i + 10],9,38016083);
            c = gg(c,d,a,b,x[i + 15],14,3634488961);
            b = gg(b,c,d,a,x[i + 4],20,3889429448);
            a = gg(a,b,c,d,x[i + 9],5,568446438);
            d = gg(d,a,b,c,x[i + 14],9,3275163606);
            c = gg(c,d,a,b,x[i + 3],14,4107603335);
            b = gg(b,c,d,a,x[i + 8],20,1163531501);
            a = gg(a,b,c,d,x[i + 13],5,2850285829);
            d = gg(d,a,b,c,x[i + 2],9,4243563512);
            c = gg(c,d,a,b,x[i + 7],14,1735328473);
            b = gg(b,c,d,a,x[i + 12],20,2368359562);
            a = hh(a,b,c,d,x[i + 5],4,4294588738);
            d = hh(d,a,b,c,x[i + 8],11,2272392833);
            c = hh(c,d,a,b,x[i + 11],16,1839030562);
            b = hh(b,c,d,a,x[i + 14],23,4259657740);
            a = hh(a,b,c,d,x[i + 1],4,2763975236);
            d = hh(d,a,b,c,x[i + 4],11,1272893353);
            c = hh(c,d,a,b,x[i + 7],16,4139469664);
            b = hh(b,c,d,a,x[i + 10],23,3200236656);
            a = hh(a,b,c,d,x[i + 13],4,681279174);
            d = hh(d,a,b,c,x[i + 0],11,3936430074);
            c = hh(c,d,a,b,x[i + 3],16,3572445317);
            b = hh(b,c,d,a,x[i + 6],23,76029189);
            a = hh(a,b,c,d,x[i + 9],4,3654602809);
            d = hh(d,a,b,c,x[i + 12],11,3873151461);
            c = hh(c,d,a,b,x[i + 15],16,530742520);
            b = hh(b,c,d,a,x[i + 2],23,3299628645);
            a = ii(a,b,c,d,x[i + 0],6,4096336452);
            d = ii(d,a,b,c,x[i + 7],10,1126891415);
            c = ii(c,d,a,b,x[i + 14],15,2878612391);
            b = ii(b,c,d,a,x[i + 5],21,4237533241);
            a = ii(a,b,c,d,x[i + 12],6,1700485571);
            d = ii(d,a,b,c,x[i + 3],10,2399980690);
            c = ii(c,d,a,b,x[i + 10],15,4293915773);
            b = ii(b,c,d,a,x[i + 1],21,2240044497);
            a = ii(a,b,c,d,x[i + 8],6,1873313359);
            d = ii(d,a,b,c,x[i + 15],10,4264355552);
            c = ii(c,d,a,b,x[i + 6],15,2734768916);
            b = ii(b,c,d,a,x[i + 13],21,1309151649);
            a = ii(a,b,c,d,x[i + 4],6,4149444226);
            d = ii(d,a,b,c,x[i + 11],10,3174756917);
            c = ii(c,d,a,b,x[i + 2],15,718787259);
            b = ii(b,c,d,a,x[i + 9],21,3951481745);
            a += olda;
            b += oldb;
            c += oldc;
            d += oldd;
         }
         return [a,b,c,d];
      }
   }
}
