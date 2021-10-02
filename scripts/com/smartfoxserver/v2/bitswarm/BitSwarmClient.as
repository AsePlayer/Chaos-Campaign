package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.bitswarm.bbox.BBClient;
   import com.smartfoxserver.v2.bitswarm.bbox.BBEvent;
   import com.smartfoxserver.v2.controllers.ExtensionController;
   import com.smartfoxserver.v2.controllers.SystemController;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.logging.Logger;
   import com.smartfoxserver.v2.util.ClientDisconnectionReason;
   import com.smartfoxserver.v2.util.ConnectionMode;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class BitSwarmClient extends EventDispatcher
   {
       
      
      private var _socket:Socket;
      
      private var _bbClient:BBClient;
      
      private var _ioHandler:IoHandler;
      
      private var _controllers:Object;
      
      private var _compressionThreshold:int = 2000000;
      
      private var _maxMessageSize:int = 10000;
      
      private var _sfs:SmartFox;
      
      private var _connected:Boolean;
      
      private var _lastIpAddress:String;
      
      private var _lastTcpPort:int;
      
      private var _reconnectionDelayMillis:int = 1000;
      
      private var _reconnectionSeconds:int = 0;
      
      private var _attemptingReconnection:Boolean = false;
      
      private var _log:Logger;
      
      private var _sysController:SystemController;
      
      private var _extController:ExtensionController;
      
      private var _udpManager:IUDPManager;
      
      private var _controllersInited:Boolean = false;
      
      private var _useBlueBox:Boolean = false;
      
      private var _connectionMode:String;
      
      public function BitSwarmClient(sfs:SmartFox = null)
      {
         super();
         this._controllers = {};
         this._sfs = sfs;
         this._connected = false;
         this._log = Logger.getInstance();
         this._udpManager = new DefaultUDPManager(sfs);
      }
      
      public function get sfs() : SmartFox
      {
         return this._sfs;
      }
      
      public function get connected() : Boolean
      {
         return this._connected;
      }
      
      public function get connectionMode() : String
      {
         return this._connectionMode;
      }
      
      public function get ioHandler() : IoHandler
      {
         return this._ioHandler;
      }
      
      public function set ioHandler(value:IoHandler) : void
      {
         this._ioHandler = value;
      }
      
      public function get maxMessageSize() : int
      {
         return this._maxMessageSize;
      }
      
      public function set maxMessageSize(value:int) : void
      {
         this._maxMessageSize = value;
      }
      
      public function get compressionThreshold() : int
      {
         return this._compressionThreshold;
      }
      
      public function set compressionThreshold(value:int) : void
      {
         if(value > 100)
         {
            this._compressionThreshold = value;
            return;
         }
         throw new ArgumentError("Compression threshold cannot be < 100 bytes.");
      }
      
      public function get reconnectionDelayMillis() : int
      {
         return this._reconnectionDelayMillis;
      }
      
      public function get useBlueBox() : Boolean
      {
         return this._useBlueBox;
      }
      
      public function forceBlueBox(value:Boolean) : void
      {
         if(!this.connected)
         {
            this._useBlueBox = value;
            return;
         }
         throw new IllegalOperationError("You can\'t change the BlueBox mode while the connection is running");
      }
      
      public function set reconnectionDelayMillis(millis:int) : void
      {
         this._reconnectionDelayMillis = millis;
      }
      
      public function enableBBoxDebug(value:Boolean) : void
      {
         this._bbClient.isDebug = value;
      }
      
      public function init() : void
      {
         if(!this._controllersInited)
         {
            this.initControllers();
            this._controllersInited = true;
         }
         this._socket = new Socket();
         if(this._socket.hasOwnProperty("timeout"))
         {
            this._socket.timeout = 5000;
         }
         this._socket.addEventListener(Event.CONNECT,this.onSocketConnect);
         this._socket.addEventListener(Event.CLOSE,this.onSocketClose);
         this._socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onSocketIOError);
         this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurityError);
         this._bbClient = new BBClient();
         this._bbClient.addEventListener(BBEvent.CONNECT,this.onBBConnect);
         this._bbClient.addEventListener(BBEvent.DATA,this.onBBData);
         this._bbClient.addEventListener(BBEvent.DISCONNECT,this.onBBDisconnect);
         this._bbClient.addEventListener(BBEvent.IO_ERROR,this.onBBError);
         this._bbClient.addEventListener(BBEvent.SECURITY_ERROR,this.onBBError);
      }
      
      public function destroy() : void
      {
         this._socket.removeEventListener(Event.CONNECT,this.onSocketConnect);
         this._socket.removeEventListener(Event.CLOSE,this.onSocketClose);
         this._socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         this._socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketIOError);
         this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurityError);
         if(this._socket.connected)
         {
            this._socket.close();
         }
         this._socket = null;
      }
      
      public function getController(id:int) : IController
      {
         return this._controllers[id] as IController;
      }
      
      public function get systemController() : SystemController
      {
         return this._sysController;
      }
      
      public function get extensionController() : ExtensionController
      {
         return this._extController;
      }
      
      public function get isReconnecting() : Boolean
      {
         return this._attemptingReconnection;
      }
      
      public function set isReconnecting(value:Boolean) : void
      {
         this._attemptingReconnection = value;
      }
      
      public function getControllerById(id:int) : IController
      {
         return this._controllers[id];
      }
      
      public function get connectionIp() : String
      {
         if(!this.connected)
         {
            return "Not Connected";
         }
         return this._lastIpAddress;
      }
      
      public function get connectionPort() : int
      {
         if(!this.connected)
         {
            return -1;
         }
         return this._lastTcpPort;
      }
      
      private function addController(id:int, controller:IController) : void
      {
         if(controller == null)
         {
            throw new ArgumentError("Controller is null, it can\'t be added.");
         }
         if(this._controllers[id] != null)
         {
            throw new ArgumentError("A controller with id: " + id + " already exists! Controller can\'t be added: " + controller);
         }
         this._controllers[id] = controller;
      }
      
      public function addCustomController(id:int, controllerClass:Class) : void
      {
         var controller:IController = controllerClass(this);
         this.addController(id,controller);
      }
      
      public function connect(host:String = "127.0.0.1", port:int = 9933) : void
      {
         this._lastIpAddress = host;
         this._lastTcpPort = port;
         if(this._useBlueBox)
         {
            this._bbClient.connect(host,port);
            this._connectionMode = ConnectionMode.HTTP;
         }
         else
         {
            this._socket.connect(host,port);
            this._connectionMode = ConnectionMode.SOCKET;
         }
      }
      
      public function send(message:IMessage) : void
      {
         this._ioHandler.codec.onPacketWrite(message);
      }
      
      public function get socket() : Socket
      {
         return this._socket;
      }
      
      public function get httpSocket() : BBClient
      {
         return this._bbClient;
      }
      
      public function disconnect(reason:String = null) : void
      {
         if(this._useBlueBox)
         {
            this._bbClient.close();
         }
         else
         {
            this._socket.close();
         }
         this.onSocketClose(new BitSwarmEvent(BitSwarmEvent.DISCONNECT,{"reason":reason}));
      }
      
      public function nextUdpPacketId() : Number
      {
         return this._udpManager.nextUdpPacketId();
      }
      
      public function killConnection() : void
      {
         this._socket.close();
         this.onSocketClose(new Event(Event.CLOSE));
      }
      
      public function get udpManager() : IUDPManager
      {
         return this._udpManager;
      }
      
      public function set udpManager(manager:IUDPManager) : void
      {
         this._udpManager = manager;
      }
      
      private function initControllers() : void
      {
         this._sysController = new SystemController(this);
         this._extController = new ExtensionController(this);
         this.addController(0,this._sysController);
         this.addController(1,this._extController);
      }
      
      public function get reconnectionSeconds() : int
      {
         return this._reconnectionSeconds;
      }
      
      public function set reconnectionSeconds(seconds:int) : void
      {
         if(seconds < 0)
         {
            this._reconnectionSeconds = 0;
         }
         else
         {
            this._reconnectionSeconds = seconds;
         }
      }
      
      private function onSocketConnect(evt:Event) : void
      {
         this._connected = true;
         var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT);
         event.params = {
            "success":true,
            "_isReconnection":this._attemptingReconnection
         };
         dispatchEvent(event);
      }
      
      private function onSocketClose(evt:Event) : void
      {
         this._connected = false;
         var isRegularDisconnection:Boolean = !this._attemptingReconnection && this.sfs.getReconnectionSeconds() == 0;
         var isManualDisconnection:Boolean = evt is BitSwarmEvent && (evt as BitSwarmEvent).params.reason == ClientDisconnectionReason.MANUAL;
         if(this._attemptingReconnection || isRegularDisconnection || isManualDisconnection)
         {
            this._udpManager.reset();
            if(evt is BitSwarmEvent)
            {
               dispatchEvent(evt);
            }
            else
            {
               dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT,{"reason":ClientDisconnectionReason.UNKNOWN}));
            }
            return;
         }
         this._attemptingReconnection = true;
         dispatchEvent(new BitSwarmEvent(BitSwarmEvent.RECONNECTION_TRY));
         setTimeout(function():void
         {
            connect(_lastIpAddress,_lastTcpPort);
         },this._reconnectionDelayMillis);
      }
      
      private function onSocketData(evt:ProgressEvent) : void
      {
         var buffer:ByteArray = null;
         var event:BitSwarmEvent = null;
         try
         {
            buffer = new ByteArray();
            this._socket.readBytes(buffer);
            this._ioHandler.onDataRead(buffer);
         }
         catch(error:SFSError)
         {
            trace("## SocketDataError: " + error.message);
            event = new BitSwarmEvent(BitSwarmEvent.DATA_ERROR);
            event.params = {
               "message":error.message,
               "details":error.details
            };
            dispatchEvent(event);
         }
      }
      
      private function onSocketIOError(evt:IOErrorEvent) : void
      {
         if(this._attemptingReconnection)
         {
            dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT,{"reason":ClientDisconnectionReason.UNKNOWN}));
            return;
         }
         trace("## SocketError: " + evt.toString());
         var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
         event.params = {"message":evt.toString()};
         dispatchEvent(event);
      }
      
      private function onSocketSecurityError(evt:SecurityErrorEvent) : void
      {
         trace("## SecurityError: " + evt.toString());
         var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.SECURITY_ERROR);
         event.params = {"message":evt.text};
         dispatchEvent(event);
      }
      
      private function onBBConnect(evt:BBEvent) : void
      {
         this._connected = true;
         var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT);
         event.params = {"success":true};
         dispatchEvent(event);
      }
      
      private function onBBData(evt:BBEvent) : void
      {
         var buffer:ByteArray = evt.params.data;
         if(buffer != null)
         {
            this._ioHandler.onDataRead(buffer);
         }
      }
      
      private function onBBDisconnect(evt:BBEvent) : void
      {
         this._connected = false;
         dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT,{"reason":ClientDisconnectionReason.UNKNOWN}));
      }
      
      private function onBBError(evt:BBEvent) : void
      {
         trace("## BlueBox Error: " + evt.params.message);
         var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
         event.params = {"message":evt.params.message};
         dispatchEvent(event);
      }
   }
}
