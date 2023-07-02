package com.smartfoxserver.v2.logging
{
   import flash.events.EventDispatcher;
   
   [Event(name="error",type="com.smartfoxserver.v2.logging.LoggerEvent")]
   [Event(name="warn",type="com.smartfoxserver.v2.logging.LoggerEvent")]
   [Event(name="info",type="com.smartfoxserver.v2.logging.LoggerEvent")]
   [Event(name="debug",type="com.smartfoxserver.v2.logging.LoggerEvent")]
   public class Logger extends EventDispatcher
   {
      
      private static var _instance:com.smartfoxserver.v2.logging.Logger;
      
      private static var _locked:Boolean = true;
       
      
      private var _enableConsoleTrace:Boolean = true;
      
      private var _enableEventDispatching:Boolean = false;
      
      private var _loggingLevel:int;
      
      public function Logger()
      {
         super();
         if(_locked)
         {
            throw new Error("Cannot instantiate the Logger using the constructor. Please use the getInstance() method");
         }
         this._loggingLevel = LogLevel.INFO;
      }
      
      public static function getInstance() : com.smartfoxserver.v2.logging.Logger
      {
         if(_instance == null)
         {
            _locked = false;
            _instance = new com.smartfoxserver.v2.logging.Logger();
            _locked = true;
         }
         return _instance;
      }
      
      public function get enableConsoleTrace() : Boolean
      {
         return this._enableConsoleTrace;
      }
      
      public function set enableConsoleTrace(value:Boolean) : void
      {
         this._enableConsoleTrace = value;
      }
      
      public function get enableEventDispatching() : Boolean
      {
         return this._enableEventDispatching;
      }
      
      public function set enableEventDispatching(value:Boolean) : void
      {
         this._enableEventDispatching = value;
      }
      
      public function get loggingLevel() : int
      {
         return this._loggingLevel;
      }
      
      public function set loggingLevel(level:int) : void
      {
         this._loggingLevel = level;
      }
      
      public function debug(... arguments) : void
      {
         this.log(LogLevel.DEBUG,arguments.join(" "));
      }
      
      public function info(... arguments) : void
      {
         this.log(LogLevel.INFO,arguments.join(" "));
      }
      
      public function warn(... arguments) : void
      {
         this.log(LogLevel.WARN,arguments.join(" "));
      }
      
      public function error(... arguments) : void
      {
         this.log(LogLevel.ERROR,arguments.join(" "));
      }
      
      private function log(level:int, message:String) : void
      {
         var params:Object = null;
         var evt:LoggerEvent = null;
         if(level < this._loggingLevel)
         {
            return;
         }
         var levelStr:String = LogLevel.fromString(level);
         if(this._enableConsoleTrace)
         {
            trace("[SFS - " + levelStr + "]",message);
         }
         if(this._enableEventDispatching)
         {
            params = {};
            params.message = message;
            evt = new LoggerEvent(levelStr.toLowerCase(),params);
            dispatchEvent(evt);
         }
      }
   }
}
