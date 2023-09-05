package com.smartfoxserver.v2.requests
{
     public class RoomExtension
     {
           
          
          private var _id:String;
          
          private var _className:String;
          
          private var _propertiesFile:String;
          
          public function RoomExtension(id:String, className:String)
          {
               super();
               this._id = id;
               this._className = className;
               this._propertiesFile = "";
          }
          
          public function get id() : String
          {
               return this._id;
          }
          
          public function get className() : String
          {
               return this._className;
          }
          
          public function get propertiesFile() : String
          {
               return this._propertiesFile;
          }
          
          public function set propertiesFile(fileName:String) : void
          {
               this._propertiesFile = fileName;
          }
     }
}
