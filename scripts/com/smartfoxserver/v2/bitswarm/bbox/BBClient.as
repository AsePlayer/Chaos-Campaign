package com.smartfoxserver.v2.bitswarm.bbox
{
   import com.hurlant.util.Base64;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class BBClient extends EventDispatcher
   {
       
      
      private const BB_DEFAULT_HOST:String = "localhost";
      
      private const BB_DEFAULT_PORT:int = 8080;
      
      private const BB_SERVLET:String = "BlueBox/BlueBox.do";
      
      private const BB_NULL:String = "null";
      
      private const CMD_CONNECT:String = "connect";
      
      private const CMD_POLL:String = "poll";
      
      private const CMD_DATA:String = "data";
      
      private const CMD_DISCONNECT:String = "disconnect";
      
      private const ERR_INVALID_SESSION:String = "err01";
      
      private const SFS_HTTP:String = "sfsHttp";
      
      private const SEP:String = "|";
      
      private const MIN_POLL_SPEED:int = 20;
      
      private const MAX_POLL_SPEED:int = 10000;
      
      private const DEFAULT_POLL_SPEED:int = 100;
      
      private var _isConnected:Boolean = false;
      
      private var _host:String = "localhost";
      
      private var _port:int = 8080;
      
      private var _bbUrl:String;
      
      private var _debug:Boolean;
      
      private var _sessId:String;
      
      private var _loader:URLLoader;
      
      private var _urlRequest:URLRequest;
      
      private var _pollSpeed:int = 100;
      
      public function BBClient(host:String = "localhost", port:int = 8080, debug:Boolean = false)
      {
         super();
         this._host = host;
         this._port = port;
         this._debug = debug;
      }
      
      public function get isConnected() : Boolean
      {
         return this._sessId != null;
      }
      
      public function get isDebug() : Boolean
      {
         return this._debug;
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      public function get sessionId() : String
      {
         return this._sessId;
      }
      
      public function get pollSpeed() : int
      {
         return this._pollSpeed;
      }
      
      public function set pollSpeed(value:int) : void
      {
         this._pollSpeed = value;
      }
      
      public function set isDebug(value:Boolean) : void
      {
         this._debug = value;
      }
      
      public function connect(host:String = "127.0.0.1", port:int = 8080) : void
      {
         if(this.isConnected)
         {
            throw new IllegalOperationError("BlueBox session is already connected");
         }
         this._host = host;
         this._port = port;
         this._bbUrl = "http://" + this._host + ":" + port + "/" + this.BB_SERVLET;
         this.sendRequest(this.CMD_CONNECT);
      }
      
      public function send(binData:ByteArray) : void
      {
         if(!this.isConnected)
         {
            throw new IllegalOperationError("Can\'t send data, BlueBox connection is not active");
         }
         this.sendRequest(this.CMD_DATA,binData);
      }
      
      public function disconnect() : void
      {
         this.sendRequest(this.CMD_DISCONNECT);
      }
      
      public function close() : void
      {
         this.handleConnectionLost(false);
      }
      
      private function onHttpResponse(evt:Event) : void
      {
         var binData:ByteArray = null;
         var loader:URLLoader = evt.target as URLLoader;
         var rawData:String = loader.data as String;
         if(this._debug)
         {
            trace("[ BB-Receive ]: " + rawData);
         }
         var reqBits:Array = rawData.split(this.SEP);
         var cmd:String = reqBits[0];
         var data:String = reqBits[1];
         if(cmd == this.CMD_CONNECT)
         {
            this._sessId = data;
            this._isConnected = true;
            dispatchEvent(new BBEvent(BBEvent.CONNECT,{}));
            this.poll();
         }
         else if(cmd == this.CMD_POLL)
         {
            binData = null;
            if(data != this.BB_NULL)
            {
               binData = this.decodeResponse(data);
            }
            if(this._isConnected)
            {
               setTimeout(this.poll,this._pollSpeed);
            }
            dispatchEvent(new BBEvent(BBEvent.DATA,{"data":binData}));
         }
         else if(cmd == this.ERR_INVALID_SESSION)
         {
            this.handleConnectionLost();
         }
      }
      
      private function onHttpIOError(evt:IOErrorEvent) : void
      {
         var bbEvt:BBEvent = new BBEvent(BBEvent.IO_ERROR,{"message":evt.text});
         dispatchEvent(bbEvt);
      }
      
      private function onSecurityError(evt:SecurityErrorEvent) : void
      {
         var bbEvt:BBEvent = new BBEvent(BBEvent.IO_ERROR,{"message":evt.text});
         dispatchEvent(bbEvt);
      }
      
      private function poll() : void
      {
         this.sendRequest(this.CMD_POLL);
      }
      
      private function sendRequest(cmd:String, data:* = null) : void
      {
         this._urlRequest = new URLRequest(this._bbUrl);
         this._urlRequest.method = URLRequestMethod.POST;
         var vars:URLVariables = new URLVariables();
         vars[this.SFS_HTTP] = this.encodeRequest(cmd,data);
         this._urlRequest.data = vars;
         if(this._debug)
         {
            trace("[ BB-Send ]: " + vars[this.SFS_HTTP]);
         }
         var urlLoader:URLLoader = this.getLoader();
         urlLoader.data = vars;
         urlLoader.load(this._urlRequest);
      }
      
      private function getLoader() : URLLoader
      {
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
         urlLoader.addEventListener(Event.COMPLETE,this.onHttpResponse);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onHttpIOError);
         urlLoader.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onHttpIOError);
         urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         return urlLoader;
      }
      
      private function handleConnectionLost(fireEvent:Boolean = true) : void
      {
         if(this._isConnected)
         {
            this._isConnected = false;
            this._sessId = null;
            if(fireEvent)
            {
               dispatchEvent(new BBEvent(BBEvent.DISCONNECT,{}));
            }
         }
      }
      
      private function encodeRequest(cmd:String, data:* = null) : String
      {
         var encoded:String = "";
         if(cmd == null)
         {
            cmd = this.BB_NULL;
         }
         if(data == null)
         {
            data = this.BB_NULL;
         }
         else if(data is ByteArray)
         {
            data = Base64.encodeByteArray(data);
         }
         return encoded + ((this._sessId == null ? this.BB_NULL : this._sessId) + this.SEP + cmd + this.SEP + data);
      }
      
      private function decodeResponse(rawData:String) : ByteArray
      {
         return Base64.decodeToByteArray(rawData);
      }
   }
}
