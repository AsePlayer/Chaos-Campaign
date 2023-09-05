package com.brockw.random
{
     import flash.utils.ByteArray;
     
     public class Random
     {
           
          
          private var _inext:int;
          
          private var _inextp:int;
          
          private const MBIG:int = 2147483647;
          
          private const MSEED:int = 161803398;
          
          private const MZ:int = 0;
          
          private var _seed:int;
          
          private var _seedArray:Vector.<int>;
          
          private var _lastRandom:Number;
          
          public function Random(seed:int)
          {
               var index:int = 0;
               var k:int = 0;
               super();
               this._seed = seed;
               this._lastRandom = 0;
               this._seedArray = new Vector.<int>(56,true);
               var num2:int = 161803398 - Math.abs(seed);
               this._seedArray[55] = num2;
               var num3:int = 1;
               for(var i:int = 1; i < 55; i++)
               {
                    index = 21 * i % 55;
                    this._seedArray[index] = num3;
                    num3 = num2 - num3;
                    if(num3 < 0)
                    {
                         num3 += 2147483647;
                    }
                    num2 = this._seedArray[index];
               }
               for(var j:int = 1; j < 5; j++)
               {
                    for(k = 1; k < 56; k++)
                    {
                         this._seedArray[k] -= this._seedArray[1 + (k + 30) % 55];
                         if(this._seedArray[k] < 0)
                         {
                              this._seedArray[k] += 2147483647;
                         }
                    }
               }
               this._inext = 0;
               this._inextp = 21;
               seed = 1;
          }
          
          public function get seed() : int
          {
               return this._seed;
          }
          
          private function getSampleForLargeRange() : Number
          {
               var num:int = this.internalSample();
               if(this.internalSample() % 2 == 0)
               {
                    num = -num;
               }
               var num2:Number = num;
               num2 += 2147483646;
               return num2 / 4294967293;
          }
          
          private function internalSample() : int
          {
               var inext:int = this._inext;
               var inextp:int = this._inextp;
               if(++inext >= 56)
               {
                    inext = 1;
               }
               if(++inextp >= 56)
               {
                    inextp = 1;
               }
               var num:int = this._seedArray[inext] - this._seedArray[inextp];
               if(num < 0)
               {
                    num += 2147483647;
               }
               this._seedArray[inext] = num;
               this._inext = inext;
               this._inextp = inextp;
               return num;
          }
          
          public function nextMax(maxValue:int) : int
          {
               if(maxValue < 0)
               {
                    throw new ArgumentError("Argument \"maxValue\" must be positive.");
               }
               return int(this.sample() * maxValue);
          }
          
          public function nextMinMax(minValue:int, maxValue:int) : int
          {
               if(minValue > maxValue)
               {
                    throw new ArgumentError("Argument \"minValue\" must be less than or equal to \"maxValue\".");
               }
               var num:Number = maxValue - minValue;
               if(num <= 2147483647)
               {
                    return int(this.sample() * num) + minValue;
               }
               return int(Number(this.getSampleForLargeRange() * num)) + minValue;
          }
          
          public function nextBytes(buffer:ByteArray, length:int) : void
          {
               if(buffer == null)
               {
                    throw new ArgumentError("Argument \"buffer\" cannot be null.");
               }
               for(var i:int = 0; i < length; i++)
               {
                    buffer.writeByte(this.internalSample() % 256);
               }
          }
          
          public function nextInt() : int
          {
               this._lastRandom = this.internalSample();
               return this._lastRandom;
          }
          
          public function nextNumber() : Number
          {
               return this.sample();
          }
          
          protected function sample() : Number
          {
               this._lastRandom = this.internalSample() * 4.656612875245797e-10;
               return this._lastRandom;
          }
          
          public function get lastRandom() : Number
          {
               return this._lastRandom;
          }
          
          public function set lastRandom(value:Number) : void
          {
               this._lastRandom = value;
          }
     }
}
