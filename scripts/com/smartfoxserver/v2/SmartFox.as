package com.smartfoxserver.v2
{
     import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
     import com.smartfoxserver.v2.bitswarm.BitSwarmEvent;
     import com.smartfoxserver.v2.bitswarm.DefaultUDPManager;
     import com.smartfoxserver.v2.bitswarm.IMessage;
     import com.smartfoxserver.v2.bitswarm.IUDPManager;
     import com.smartfoxserver.v2.bitswarm.IoHandler;
     import com.smartfoxserver.v2.core.SFSEvent;
     import com.smartfoxserver.v2.core.SFSIOHandler;
     import com.smartfoxserver.v2.entities.Room;
     import com.smartfoxserver.v2.entities.User;
     import com.smartfoxserver.v2.entities.data.ISFSObject;
     import com.smartfoxserver.v2.entities.managers.IBuddyManager;
     import com.smartfoxserver.v2.entities.managers.IRoomManager;
     import com.smartfoxserver.v2.entities.managers.IUserManager;
     import com.smartfoxserver.v2.entities.managers.SFSBuddyManager;
     import com.smartfoxserver.v2.entities.managers.SFSGlobalUserManager;
     import com.smartfoxserver.v2.entities.managers.SFSRoomManager;
     import com.smartfoxserver.v2.exceptions.SFSCodecError;
     import com.smartfoxserver.v2.exceptions.SFSError;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     import com.smartfoxserver.v2.logging.Logger;
     import com.smartfoxserver.v2.requests.BaseRequest;
     import com.smartfoxserver.v2.requests.HandshakeRequest;
     import com.smartfoxserver.v2.requests.IRequest;
     import com.smartfoxserver.v2.requests.JoinRoomRequest;
     import com.smartfoxserver.v2.requests.ManualDisconnectionRequest;
     import com.smartfoxserver.v2.util.ClientDisconnectionReason;
     import com.smartfoxserver.v2.util.ConfigData;
     import com.smartfoxserver.v2.util.ConfigLoader;
     import com.smartfoxserver.v2.util.ConnectionMode;
     import com.smartfoxserver.v2.util.LagMonitor;
     import com.smartfoxserver.v2.util.SFSErrorCodes;
     import flash.errors.IllegalOperationError;
     import flash.events.EventDispatcher;
     import flash.system.Capabilities;
     import flash.utils.setTimeout;
     
     [Event(name="socketError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="pingPong",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="buddyVariablesUpdate",type="com.smartfoxserver.v2.core.SFSBuddyEvent")]
     [Event(name="buddyOnlineStateChange",type="com.smartfoxserver.v2.core.SFSBuddyEvent")]
     [Event(name="buddyMessage",type="com.smartfoxserver.v2.core.SFSBuddyEvent")]
     [Event(name="buddyError",type="com.smartfoxserver.v2.core.SFSBuddyEvent")]
     [Event(name="buddyRemove",type="com.smartfoxserver.v2.core.SFSBuddyEvent")]
     [Event(name="buddyBlock",type="com.smartfoxserver.v2.core.SFSBuddyEvent")]
     [Event(name="buddyAdd",type="com.smartfoxserver.v2.core.SFSBuddyEvent")]
     [Event(name="buddyListInit",type="com.smartfoxserver.v2.core.SFSBuddyEvent")]
     [Event(name="invitationReplyError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="invitationReply",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="invitation",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="userFindResult",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomFindResult",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomGroupUnsubscribeError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomGroupUnsubscribe",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomGroupSubscribeError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomGroupSubscribe",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="userVariablesUpdate",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomVariablesUpdate",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="extensionResponse",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="adminMessage",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="moderatorMessage",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="objectMessage",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="privateMessage",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="publicMessage",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomCapacityChangeError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomCapacityChange",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomPasswordStateChangeError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomPasswordStateChange",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomNameChangeError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomNameChange",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="spectatorToPlayerError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="spectatorToPlayer",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="playerToSpectatorError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="playerToSpectator",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="userCountChange",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="userExitRoom",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="userEnterRoom",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomJoinError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomJoin",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomRemove",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomCreationError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="roomAdd",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="logout",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="loginError",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="login",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="configLoadFailure",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="configLoadSuccess",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="udpInit",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="connectionAttemptHttp",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="connectionResume",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="connectionRetry",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="connectionLost",type="com.smartfoxserver.v2.core.SFSEvent")]
     [Event(name="connection",type="com.smartfoxserver.v2.core.SFSEvent")]
     public class SmartFox extends EventDispatcher
     {
           
          
          private const DEFAULT_HTTP_PORT:int = 8080;
          
          private var _majVersion:int = 1;
          
          private var _minVersion:int = 1;
          
          private var _subVersion:int = 1;
          
          private var _bitSwarm:BitSwarmClient;
          
          private var _lagMonitor:LagMonitor;
          
          private var _useBlueBox:Boolean = true;
          
          private var _isConnected:Boolean = false;
          
          private var _isJoining:Boolean = false;
          
          private var _mySelf:User;
          
          private var _sessionToken:String;
          
          private var _lastJoinedRoom:Room;
          
          private var _log:Logger;
          
          private var _inited:Boolean = false;
          
          private var _debug:Boolean = false;
          
          private var _isConnecting:Boolean = false;
          
          private var _userManager:IUserManager;
          
          private var _roomManager:IRoomManager;
          
          private var _buddyManager:IBuddyManager;
          
          private var _config:ConfigData;
          
          private var _currentZone:String;
          
          private var _autoConnectOnConfig:Boolean = false;
          
          private var _lastIpAddress:String;
          
          public function SmartFox(debug:Boolean = false)
          {
               super();
               this._log = Logger.getInstance();
               this._log.enableEventDispatching = true;
               this._debug = debug;
               this.initialize();
          }
          
          private function initialize() : void
          {
               if(this._inited)
               {
                    return;
               }
               this._bitSwarm = new BitSwarmClient(this);
               this._bitSwarm.ioHandler = new SFSIOHandler(this._bitSwarm);
               this._bitSwarm.init();
               this._bitSwarm.addEventListener(BitSwarmEvent.CONNECT,this.onSocketConnect);
               this._bitSwarm.addEventListener(BitSwarmEvent.DISCONNECT,this.onSocketClose);
               this._bitSwarm.addEventListener(BitSwarmEvent.RECONNECTION_TRY,this.onSocketReconnectionTry);
               this._bitSwarm.addEventListener(BitSwarmEvent.IO_ERROR,this.onSocketIOError);
               this._bitSwarm.addEventListener(BitSwarmEvent.SECURITY_ERROR,this.onSocketSecurityError);
               this._bitSwarm.addEventListener(BitSwarmEvent.DATA_ERROR,this.onSocketDataError);
               addEventListener(SFSEvent.HANDSHAKE,this.handleHandShake);
               addEventListener(SFSEvent.LOGIN,this.handleLogin);
               this._inited = true;
               this.reset();
          }
          
          private function reset() : void
          {
               this._userManager = new SFSGlobalUserManager(this);
               this._roomManager = new SFSRoomManager(this);
               this._buddyManager = new SFSBuddyManager(this);
               if(this._lagMonitor != null)
               {
                    this._lagMonitor.destroy();
               }
               this._isConnected = false;
               this._isJoining = false;
               this._currentZone = null;
               this._lastJoinedRoom = null;
               this._sessionToken = null;
               this._mySelf = null;
          }
          
          public function enableFullPacketDump(b:Boolean) : void
          {
               (this._bitSwarm.ioHandler as SFSIOHandler).enableFullPacketDump(b);
          }
          
          public function enableLagMonitor(enabled:Boolean, interval:int = 4, queueSize:int = 10) : void
          {
               if(this._mySelf == null)
               {
                    this.logger.warn("Lag Monitoring requires that you are logged in a Zone!");
                    return;
               }
               if(enabled)
               {
                    this._lagMonitor = new LagMonitor(this,interval,queueSize);
                    this._lagMonitor.start();
               }
               else
               {
                    this._lagMonitor.stop();
               }
          }
          
          kernel function setAlternateIOHandler(ioHandler:IoHandler) : void
          {
               if(!this._isConnected && !this._isConnecting)
               {
                    this._bitSwarm.ioHandler = ioHandler;
                    return;
               }
               throw new IllegalOperationError("This operation must be executed before connecting!");
          }
          
          kernel function get socketEngine() : BitSwarmClient
          {
               return this._bitSwarm;
          }
          
          kernel function get lagMonitor() : LagMonitor
          {
               return this._lagMonitor;
          }
          
          public function get isConnected() : Boolean
          {
               var value:Boolean = false;
               if(this._bitSwarm != null)
               {
                    value = this._bitSwarm.connected;
               }
               return value;
          }
          
          public function get connectionMode() : String
          {
               return this._bitSwarm.connectionMode;
          }
          
          public function get version() : String
          {
               return "" + this._majVersion + "." + this._minVersion + "." + this._subVersion;
          }
          
          public function get config() : ConfigData
          {
               return this._config;
          }
          
          public function get compressionThreshold() : int
          {
               return this._bitSwarm.compressionThreshold;
          }
          
          public function get maxMessageSize() : int
          {
               return this._bitSwarm.maxMessageSize;
          }
          
          public function getRoomById(id:int) : Room
          {
               return this.roomManager.getRoomById(id);
          }
          
          public function getRoomByName(name:String) : Room
          {
               return this.roomManager.getRoomByName(name);
          }
          
          public function getRoomListFromGroup(groupId:String) : Array
          {
               return this.roomManager.getRoomListFromGroup(groupId);
          }
          
          public function killConnection() : void
          {
               this._bitSwarm.killConnection();
          }
          
          public function connect(host:String = null, port:int = -1) : void
          {
               if(this.isConnected)
               {
                    this._log.warn("Already connected");
                    return;
               }
               if(this._isConnecting)
               {
                    this._log.warn("A connection attempt is already in progress");
                    return;
               }
               if(this.config != null)
               {
                    if(host == null)
                    {
                         host = this.config.host;
                    }
                    if(port == -1)
                    {
                         port = this.config.port;
                    }
               }
               if(host == null || host.length == 0)
               {
                    throw new ArgumentError("Invalid connection host/address");
               }
               if(port < 0 || port > 65535)
               {
                    throw new ArgumentError("Invalid connection port");
               }
               this._lastIpAddress = host;
               this._isConnecting = true;
               this._bitSwarm.connect(host,port);
          }
          
          public function disconnect() : void
          {
               if(this.isConnected)
               {
                    if(this._bitSwarm.reconnectionSeconds > 0)
                    {
                         this.send(new ManualDisconnectionRequest());
                    }
                    setTimeout(function():void
                    {
                         _bitSwarm.disconnect(ClientDisconnectionReason.MANUAL);
                    },100);
               }
               else
               {
                    this._log.info("You are not connected");
               }
          }
          
          public function get debug() : Boolean
          {
               return this._debug;
          }
          
          public function set debug(value:Boolean) : void
          {
               this._debug = value;
          }
          
          public function get currentIp() : String
          {
               return this._bitSwarm.connectionIp;
          }
          
          public function get currentPort() : int
          {
               return this._bitSwarm.connectionPort;
          }
          
          public function get currentZone() : String
          {
               return this._currentZone;
          }
          
          public function get mySelf() : User
          {
               return this._mySelf;
          }
          
          public function set mySelf(value:User) : void
          {
               this._mySelf = value;
          }
          
          public function get useBlueBox() : Boolean
          {
               return this._useBlueBox;
          }
          
          public function set useBlueBox(value:Boolean) : void
          {
               this._useBlueBox = value;
          }
          
          public function get logger() : Logger
          {
               return this._log;
          }
          
          public function get lastJoinedRoom() : Room
          {
               return this._lastJoinedRoom;
          }
          
          public function set lastJoinedRoom(value:Room) : void
          {
               this._lastJoinedRoom = value;
          }
          
          public function get joinedRooms() : Array
          {
               return this.roomManager.getJoinedRooms();
          }
          
          public function get roomList() : Array
          {
               return this._roomManager.getRoomList();
          }
          
          public function get roomManager() : IRoomManager
          {
               return this._roomManager;
          }
          
          public function get userManager() : IUserManager
          {
               return this._userManager;
          }
          
          public function get buddyManager() : IBuddyManager
          {
               return this._buddyManager;
          }
          
          public function get udpAvailable() : Boolean
          {
               return this.isAirRuntime();
          }
          
          public function get udpInited() : Boolean
          {
               return this._bitSwarm.udpManager.inited;
          }
          
          public function initUDP(manager:IUDPManager, udpHost:String = null, udpPort:int = -1) : void
          {
               if(this.isAirRuntime())
               {
                    if(!this.isConnected)
                    {
                         this._log.warn("Cannot initialize UDP protocol until the client is connected to SFS2X.");
                         return;
                    }
                    if(this.config != null)
                    {
                         if(udpHost == null)
                         {
                              udpHost = this.config.udpHost;
                         }
                         if(udpPort == -1)
                         {
                              udpPort = this.config.udpPort;
                         }
                    }
                    if(udpHost == null || udpHost.length == 0)
                    {
                         throw new ArgumentError("Invalid UDP host/address");
                    }
                    if(udpPort < 0 || udpPort > 65535)
                    {
                         throw new ArgumentError("Invalid UDP port range");
                    }
                    if(!this._bitSwarm.udpManager.inited && this._bitSwarm.udpManager is DefaultUDPManager)
                    {
                         manager.sfs = this;
                         this._bitSwarm.udpManager = manager;
                    }
                    this._bitSwarm.udpManager.initialize(udpHost,udpPort);
               }
               else
               {
                    this._log.warn("UDP Failure: the protocol is available only for the AIR 2.0 runtime.");
               }
          }
          
          private function isAirRuntime() : Boolean
          {
               return Capabilities.playerType.toLowerCase() == "desktop";
          }
          
          public function get isJoining() : Boolean
          {
               return this._isJoining;
          }
          
          public function set isJoining(value:Boolean) : void
          {
               this._isJoining = value;
          }
          
          public function get sessionToken() : String
          {
               return this._sessionToken;
          }
          
          public function getReconnectionSeconds() : int
          {
               return this._bitSwarm.reconnectionSeconds;
          }
          
          public function setReconnectionSeconds(seconds:int) : void
          {
               this._bitSwarm.reconnectionSeconds = seconds;
          }
          
          public function send(request:IRequest) : void
          {
               var errMsg:String = null;
               var errorItem:String = null;
               if(!this.isConnected)
               {
                    this._log.warn("You are not connected. Request cannot be sent: " + request);
                    return;
               }
               try
               {
                    if(request is JoinRoomRequest)
                    {
                         if(this._isJoining)
                         {
                              return;
                         }
                         this._isJoining = true;
                    }
                    request.validate(this);
                    request.execute(this);
                    this._bitSwarm.send(request.getMessage());
               }
               catch(problem:SFSValidationError)
               {
                    errMsg = String(problem.message);
                    for each(errorItem in problem.errors)
                    {
                         errMsg += "\t" + errorItem + "\n";
                    }
                    _log.warn(errMsg);
               }
               catch(error:SFSCodecError)
               {
                    _log.warn(error.message);
               }
          }
          
          public function loadConfig(filePath:String = "sfs-config.xml", connectOnSuccess:Boolean = true) : void
          {
               var configLoader:ConfigLoader = new ConfigLoader();
               configLoader.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
               configLoader.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
               this._autoConnectOnConfig = connectOnSuccess;
               configLoader.loadConfig(filePath);
          }
          
          public function addJoinedRoom(room:Room) : void
          {
               if(!this.roomManager.containsRoom(room.id))
               {
                    this.roomManager.addRoom(room);
                    this._lastJoinedRoom = room;
                    return;
               }
               throw new SFSError("Unexpected: joined room already exists for this User: " + this.mySelf.name + ", Room: " + room);
          }
          
          public function removeJoinedRoom(room:Room) : void
          {
               this.roomManager.removeRoom(room);
               if(this.joinedRooms.length > 0)
               {
                    this._lastJoinedRoom = this.joinedRooms[this.joinedRooms.length - 1];
               }
          }
          
          private function onSocketConnect(evt:BitSwarmEvent) : void
          {
               if(Boolean(evt.params.success))
               {
                    this.sendHandshakeRequest(evt.params._isReconnection);
               }
               else
               {
                    this._log.warn("Connection attempt failed");
                    this.handleConnectionProblem(evt);
               }
          }
          
          private function onSocketClose(evt:BitSwarmEvent) : void
          {
               this.reset();
               dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_LOST,{"reason":evt.params.reason}));
          }
          
          private function onSocketReconnectionTry(evt:BitSwarmEvent) : void
          {
               dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_RETRY,{}));
          }
          
          private function onSocketDataError(evt:BitSwarmEvent) : void
          {
               dispatchEvent(new SFSEvent(SFSEvent.SOCKET_ERROR,{
                    "errorMessage":evt.params.message,
                    "details":evt.params.details
               }));
          }
          
          private function onSocketIOError(evt:BitSwarmEvent) : void
          {
               if(this._isConnecting)
               {
                    this.handleConnectionProblem(evt);
               }
          }
          
          private function onSocketSecurityError(evt:BitSwarmEvent) : void
          {
               if(this._isConnecting)
               {
                    this.handleConnectionProblem(evt);
               }
          }
          
          private function onConfigLoadSuccess(evt:SFSEvent) : void
          {
               var cfgLoader:ConfigLoader = evt.target as ConfigLoader;
               var cfgData:ConfigData = evt.params.cfg as ConfigData;
               cfgLoader.removeEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
               cfgLoader.removeEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
               if(cfgData.host == null || cfgData.host.length == 0)
               {
                    throw new ArgumentError("Invalid Host/IpAddress in external config file");
               }
               if(cfgData.port < 0 || cfgData.port > 65535)
               {
                    throw new ArgumentError("Invalid TCP port in external config file");
               }
               if(cfgData.zone == null || cfgData.zone.length == 0)
               {
                    throw new ArgumentError("Invalid Zone name in external config file");
               }
               this._debug = cfgData.debug;
               this._useBlueBox = cfgData.useBlueBox;
               this._config = cfgData;
               var sfsEvt:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_SUCCESS,{"config":cfgData});
               dispatchEvent(sfsEvt);
               if(this._autoConnectOnConfig)
               {
                    this.connect(this._config.host,this._config.port);
               }
          }
          
          private function onConfigLoadFailure(evt:SFSEvent) : void
          {
               var cfgLoader:ConfigLoader = evt.target as ConfigLoader;
               cfgLoader.removeEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
               cfgLoader.removeEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
               var sfsEvt:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_FAILURE,{});
               dispatchEvent(sfsEvt);
          }
          
          private function handleHandShake(evt:SFSEvent) : void
          {
               var errorCd:int = 0;
               var errorMsg:String = null;
               var params:Object = null;
               var msg:IMessage = evt.params.message;
               var obj:ISFSObject = msg.content;
               if(obj.isNull(BaseRequest.KEY_ERROR_CODE))
               {
                    this._sessionToken = obj.getUtfString(HandshakeRequest.KEY_SESSION_TOKEN);
                    this._bitSwarm.compressionThreshold = obj.getInt(HandshakeRequest.KEY_COMPRESSION_THRESHOLD);
                    this._bitSwarm.maxMessageSize = obj.getInt(HandshakeRequest.KEY_MAX_MESSAGE_SIZE);
                    if(this._bitSwarm.isReconnecting)
                    {
                         this._bitSwarm.isReconnecting = false;
                         dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_RESUME,{}));
                    }
                    else
                    {
                         this._isConnecting = false;
                         dispatchEvent(new SFSEvent(SFSEvent.CONNECTION,{"success":true}));
                    }
               }
               else
               {
                    errorCd = int(obj.getShort(BaseRequest.KEY_ERROR_CODE));
                    errorMsg = SFSErrorCodes.getErrorMessage(errorCd,obj.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                    params = {
                         "success":false,
                         "errorMessage":errorMsg,
                         "errorCode":errorCd
                    };
                    dispatchEvent(new SFSEvent(SFSEvent.CONNECTION,params));
               }
          }
          
          private function handleLogin(evt:SFSEvent) : void
          {
               this._currentZone = evt.params.zone;
          }
          
          public function handleClientDisconnection(reason:String) : void
          {
               this._bitSwarm.reconnectionSeconds = 0;
               this._bitSwarm.disconnect(reason);
               this.reset();
          }
          
          public function handleLogout() : void
          {
               if(this._lagMonitor != null && this._lagMonitor.isRunning)
               {
                    this._lagMonitor.stop();
               }
               this._userManager = new SFSGlobalUserManager(this);
               this._roomManager = new SFSRoomManager(this);
               this._isJoining = false;
               this._lastJoinedRoom = null;
               this._currentZone = null;
               this._mySelf = null;
          }
          
          private function handleConnectionProblem(evt:BitSwarmEvent) : void
          {
               var bbPort:int = 0;
               var params:Object = null;
               trace("INSIDE HANDLE CONNECTION PROBLEM");
               trace("connectionMode",this._bitSwarm.connectionMode,"useBlueBox",this._useBlueBox);
               if(this._bitSwarm.connectionMode == ConnectionMode.SOCKET && this._useBlueBox)
               {
                    this._bitSwarm.forceBlueBox(true);
                    bbPort = this.config != null ? this.config.httpPort : this.DEFAULT_HTTP_PORT;
                    this._bitSwarm.connect(this._lastIpAddress,bbPort);
                    dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_ATTEMPT_HTTP,{}));
               }
               else
               {
                    params = {
                         "success":false,
                         "errorMessage":evt.params.message
                    };
                    dispatchEvent(new SFSEvent(SFSEvent.CONNECTION,params));
                    this._isConnecting = this._isConnected = false;
                    trace("EVENT DISPATCHED!!!");
               }
          }
          
          private function sendHandshakeRequest(isReconnection:Boolean = false) : void
          {
               var req:IRequest = new HandshakeRequest(this.version,isReconnection ? this._sessionToken : null);
               this.send(req);
          }
     }
}
