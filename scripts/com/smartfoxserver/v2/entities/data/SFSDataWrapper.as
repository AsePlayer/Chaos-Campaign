package com.smartfoxserver.v2.entities.data
{
   public class SFSDataWrapper
   {
       
      
      private var _type:int;
      
      private var _data;
      
      public function SFSDataWrapper(type:int, data:*)
      {
         super();
         this._type = type;
         this._data = data;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get data() : *
      {
         return this._data;
      }
   }
}
