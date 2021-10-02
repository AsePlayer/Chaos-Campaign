package com.smartfoxserver.v2.util
{
   public class ArrayUtil
   {
       
      
      public function ArrayUtil()
      {
         super();
         throw new Error("This class contains static methods only! Do not instaniate it");
      }
      
      public static function removeElement(arr:Array, item:*) : void
      {
         var p:int = arr.indexOf(item);
         if(p > -1)
         {
            arr.splice(p,1);
         }
      }
      
      public static function copy(arr:Array) : Array
      {
         var arrCopy:Array = new Array();
         for(var j:int = 0; j < arr.length; j++)
         {
            arrCopy[j] = arr[j];
         }
         return arrCopy;
      }
      
      public static function objToArray(obj:Object) : Array
      {
         var o:* = undefined;
         var array:Array = [];
         for each(o in obj)
         {
            array.push(o);
         }
         return array;
      }
   }
}
