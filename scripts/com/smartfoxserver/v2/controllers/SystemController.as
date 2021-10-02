package com.smartfoxserver.v2.controllers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.bitswarm.BaseController;
   import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.core.SFSBuddyEvent;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.SFSBuddy;
   import com.smartfoxserver.v2.entities.SFSRoom;
   import com.smartfoxserver.v2.entities.SFSUser;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.invitation.Invitation;
   import com.smartfoxserver.v2.entities.invitation.SFSInvitation;
   import com.smartfoxserver.v2.entities.managers.IRoomManager;
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
   import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
   import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import com.smartfoxserver.v2.kernel;
   import com.smartfoxserver.v2.requests.BaseRequest;
   import com.smartfoxserver.v2.requests.ChangeRoomCapacityRequest;
   import com.smartfoxserver.v2.requests.ChangeRoomNameRequest;
   import com.smartfoxserver.v2.requests.ChangeRoomPasswordStateRequest;
   import com.smartfoxserver.v2.requests.CreateRoomRequest;
   import com.smartfoxserver.v2.requests.FindRoomsRequest;
   import com.smartfoxserver.v2.requests.FindUsersRequest;
   import com.smartfoxserver.v2.requests.GenericMessageRequest;
   import com.smartfoxserver.v2.requests.GenericMessageType;
   import com.smartfoxserver.v2.requests.JoinRoomRequest;
   import com.smartfoxserver.v2.requests.LoginRequest;
   import com.smartfoxserver.v2.requests.LogoutRequest;
   import com.smartfoxserver.v2.requests.PlayerToSpectatorRequest;
   import com.smartfoxserver.v2.requests.SetRoomVariablesRequest;
   import com.smartfoxserver.v2.requests.SetUserVariablesRequest;
   import com.smartfoxserver.v2.requests.SpectatorToPlayerRequest;
   import com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest;
   import com.smartfoxserver.v2.requests.buddylist.AddBuddyRequest;
   import com.smartfoxserver.v2.requests.buddylist.BlockBuddyRequest;
   import com.smartfoxserver.v2.requests.buddylist.GoOnlineRequest;
   import com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest;
   import com.smartfoxserver.v2.requests.buddylist.RemoveBuddyRequest;
   import com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest;
   import com.smartfoxserver.v2.requests.game.InviteUsersRequest;
   import com.smartfoxserver.v2.util.BuddyOnlineState;
   import com.smartfoxserver.v2.util.ClientDisconnectionReason;
   import com.smartfoxserver.v2.util.SFSErrorCodes;
   
   public class SystemController extends BaseController
   {
       
      
      private var sfs:SmartFox;
      
      private var bitSwarm:BitSwarmClient;
      
      private var requestHandlers:Object;
      
      public function SystemController(bitSwarm:BitSwarmClient)
      {
         super();
         this.bitSwarm = bitSwarm;
         this.sfs = bitSwarm.sfs;
         this.requestHandlers = new Object();
         this.initRequestHandlers();
      }
      
      private function initRequestHandlers() : void
      {
         this.requestHandlers[BaseRequest.Handshake] = "fnHandshake";
         this.requestHandlers[BaseRequest.Login] = "fnLogin";
         this.requestHandlers[BaseRequest.Logout] = "fnLogout";
         this.requestHandlers[BaseRequest.JoinRoom] = "fnJoinRoom";
         this.requestHandlers[BaseRequest.CreateRoom] = "fnCreateRoom";
         this.requestHandlers[BaseRequest.GenericMessage] = "fnGenericMessage";
         this.requestHandlers[BaseRequest.ChangeRoomName] = "fnChangeRoomName";
         this.requestHandlers[BaseRequest.ChangeRoomPassword] = "fnChangeRoomPassword";
         this.requestHandlers[BaseRequest.ChangeRoomCapacity] = "fnChangeRoomCapacity";
         this.requestHandlers[BaseRequest.ObjectMessage] = "fnSendObject";
         this.requestHandlers[BaseRequest.SetRoomVariables] = "fnSetRoomVariables";
         this.requestHandlers[BaseRequest.SetUserVariables] = "fnSetUserVariables";
         this.requestHandlers[BaseRequest.CallExtension] = "fnCallExtension";
         this.requestHandlers[BaseRequest.SubscribeRoomGroup] = "fnSubscribeRoomGroup";
         this.requestHandlers[BaseRequest.UnsubscribeRoomGroup] = "fnUnsubscribeRoomGroup";
         this.requestHandlers[BaseRequest.SpectatorToPlayer] = "fnSpectatorToPlayer";
         this.requestHandlers[BaseRequest.PlayerToSpectator] = "fnPlayerToSpectator";
         this.requestHandlers[BaseRequest.InitBuddyList] = "fnInitBuddyList";
         this.requestHandlers[BaseRequest.AddBuddy] = "fnAddBuddy";
         this.requestHandlers[BaseRequest.RemoveBuddy] = "fnRemoveBuddy";
         this.requestHandlers[BaseRequest.BlockBuddy] = "fnBlockBuddy";
         this.requestHandlers[BaseRequest.GoOnline] = "fnGoOnline";
         this.requestHandlers[BaseRequest.SetBuddyVariables] = "fnSetBuddyVariables";
         this.requestHandlers[BaseRequest.FindRooms] = "fnFindRooms";
         this.requestHandlers[BaseRequest.FindUsers] = "fnFindUsers";
         this.requestHandlers[BaseRequest.InviteUser] = "fnInviteUsers";
         this.requestHandlers[BaseRequest.InvitationReply] = "fnInvitationReply";
         this.requestHandlers[BaseRequest.QuickJoinGame] = "fnQuickJoinGame";
         this.requestHandlers[BaseRequest.PingPong] = "fnPingPong";
         this.requestHandlers[1000] = "fnUserEnterRoom";
         this.requestHandlers[1001] = "fnUserCountChange";
         this.requestHandlers[1002] = "fnUserLost";
         this.requestHandlers[1003] = "fnRoomLost";
         this.requestHandlers[1004] = "fnUserExitRoom";
         this.requestHandlers[1005] = "fnClientDisconnection";
      }
      
      override public function handleMessage(message:IMessage) : void
      {
         if(this.sfs.debug)
         {
            log.info(this.getEvtName(message.id),message);
         }
         var fnName:String = this.requestHandlers[message.id];
         if(fnName != null)
         {
            this[fnName](message);
         }
         else
         {
            log.warn("Unknown message id: " + message.id);
         }
      }
      
      private function getEvtName(id:int) : String
      {
         var fName:String = this.requestHandlers[id];
         return fName.substr(2);
      }
      
      private function fnHandshake(msg:IMessage) : void
      {
         var evtParams:Object = {"message":msg};
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.HANDSHAKE,evtParams));
      }
      
      private function fnLogin(msg:IMessage) : void
      {
         var errorCd:int = 0;
         var errorMsg:String = null;
         var obj:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(obj.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            this.populateRoomList(obj.getSFSArray(LoginRequest.KEY_ROOMLIST));
            this.sfs.mySelf = new SFSUser(obj.getInt(LoginRequest.KEY_ID),obj.getUtfString(LoginRequest.KEY_USER_NAME),true);
            this.sfs.mySelf.userManager = this.sfs.userManager;
            this.sfs.mySelf.privilegeId = obj.getShort(LoginRequest.KEY_PRIVILEGE_ID);
            this.sfs.userManager.addUser(this.sfs.mySelf);
            this.sfs.setReconnectionSeconds(obj.getShort(LoginRequest.KEY_RECONNECTION_SECONDS));
            evtParams.zone = obj.getUtfString(LoginRequest.KEY_ZONE_NAME);
            evtParams.user = this.sfs.mySelf;
            evtParams.data = obj.getSFSObject(LoginRequest.KEY_PARAMS);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGIN,evtParams));
         }
         else
         {
            errorCd = obj.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,obj.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGIN_ERROR,evtParams));
         }
      }
      
      private function fnCreateRoom(msg:IMessage) : void
      {
         var roomManager:IRoomManager = null;
         var newRoom:Room = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var obj:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(obj.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            roomManager = this.sfs.roomManager;
            newRoom = SFSRoom.fromSFSArray(obj.getSFSArray(CreateRoomRequest.KEY_ROOM));
            newRoom.roomManager = this.sfs.roomManager;
            roomManager.addRoom(newRoom);
            evtParams.room = newRoom;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_ADD,evtParams));
         }
         else
         {
            errorCd = obj.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,obj.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CREATION_ERROR,evtParams));
         }
      }
      
      private function fnJoinRoom(msg:IMessage) : void
      {
         var roomObj:ISFSArray = null;
         var userList:ISFSArray = null;
         var room:Room = null;
         var j:int = 0;
         var userObj:ISFSArray = null;
         var user:User = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var roomManager:IRoomManager = this.sfs.roomManager;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         this.sfs.isJoining = false;
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            roomObj = sfso.getSFSArray(JoinRoomRequest.KEY_ROOM);
            userList = sfso.getSFSArray(JoinRoomRequest.KEY_USER_LIST);
            room = SFSRoom.fromSFSArray(roomObj);
            room.roomManager = this.sfs.roomManager;
            room = roomManager.replaceRoom(room,roomManager.containsGroup(room.groupId));
            for(j = 0; j < userList.size(); j++)
            {
               userObj = userList.getSFSArray(j);
               user = this.getOrCreateUser(userObj,true,room);
               user.setPlayerId(userObj.getShort(3),room);
               room.addUser(user);
            }
            room.isJoined = true;
            this.sfs.lastJoinedRoom = room;
            evtParams.room = room;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN,evtParams));
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN_ERROR,evtParams));
         }
      }
      
      private function fnUserEnterRoom(msg:IMessage) : void
      {
         var userObj:ISFSArray = null;
         var user:User = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var room:Room = this.sfs.roomManager.getRoomById(sfso.getInt("r"));
         if(room != null)
         {
            userObj = sfso.getSFSArray("u");
            user = this.getOrCreateUser(userObj,true,room);
            room.addUser(user);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_ENTER_ROOM,{
               "user":user,
               "room":room
            }));
         }
      }
      
      private function fnUserCountChange(msg:IMessage) : void
      {
         var uCount:int = 0;
         var sCount:int = 0;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var room:Room = this.sfs.roomManager.getRoomById(sfso.getInt("r"));
         if(room != null)
         {
            uCount = sfso.getShort("uc");
            sCount = 0;
            if(sfso.containsKey("sc"))
            {
               sCount = sfso.getShort("sc");
            }
            room.userCount = uCount;
            room.spectatorCount = sCount;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_COUNT_CHANGE,{
               "room":room,
               "uCount":uCount,
               "sCount":sCount
            }));
         }
      }
      
      private function fnUserLost(msg:IMessage) : void
      {
         var joinedRooms:Array = null;
         var room:Room = null;
         var sfso:ISFSObject = msg.content;
         var uId:int = sfso.getInt("u");
         var user:User = this.sfs.userManager.getUserById(uId);
         if(user != null)
         {
            joinedRooms = this.sfs.roomManager.getUserRooms(user);
            this.sfs.roomManager.removeUser(user);
            this.sfs.userManager.removeUser(user);
            for each(room in joinedRooms)
            {
               this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_EXIT_ROOM,{
                  "user":user,
                  "room":room
               }));
            }
         }
      }
      
      private function fnRoomLost(msg:IMessage) : void
      {
         var user:User = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var rId:int = sfso.getInt("r");
         var room:Room = this.sfs.roomManager.getRoomById(rId);
         var globalUserManager:IUserManager = this.sfs.userManager;
         if(room != null)
         {
            this.sfs.roomManager.removeRoom(room);
            for each(user in room.userList)
            {
               globalUserManager.removeUser(user);
            }
            evtParams.room = room;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_REMOVE,evtParams));
         }
      }
      
      private function fnGenericMessage(msg:IMessage) : void
      {
         var sfso:ISFSObject = msg.content;
         var msgType:int = sfso.getByte(GenericMessageRequest.KEY_MESSAGE_TYPE);
         switch(msgType)
         {
            case GenericMessageType.PUBLIC_MSG:
               this.handlePublicMessage(sfso);
               break;
            case GenericMessageType.PRIVATE_MSG:
               this.handlePrivateMessage(sfso);
               break;
            case GenericMessageType.BUDDY_MSG:
               this.handleBuddyMessage(sfso);
               break;
            case GenericMessageType.MODERATOR_MSG:
               this.handleModMessage(sfso);
               break;
            case GenericMessageType.ADMING_MSG:
               this.handleAdminMessage(sfso);
               break;
            case GenericMessageType.OBJECT_MSG:
               this.handleObjectMessage(sfso);
         }
      }
      
      private function handlePublicMessage(sfso:ISFSObject) : void
      {
         var evtParams:Object = {};
         var rId:int = sfso.getInt(GenericMessageRequest.KEY_ROOM_ID);
         var room:Room = this.sfs.roomManager.getRoomById(rId);
         if(room != null)
         {
            evtParams.room = room;
            evtParams.sender = this.sfs.userManager.getUserById(sfso.getInt(GenericMessageRequest.KEY_USER_ID));
            evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
            evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PUBLIC_MESSAGE,evtParams));
         }
         else
         {
            log.warn("Unexpected, PublicMessage target room doesn\'t exist. RoomId: " + rId);
         }
      }
      
      public function handlePrivateMessage(sfso:ISFSObject) : void
      {
         var evtParams:Object = {};
         var senderId:int = sfso.getInt(GenericMessageRequest.KEY_USER_ID);
         var sender:User = this.sfs.userManager.getUserById(senderId);
         if(sender == null)
         {
            if(!sfso.containsKey(GenericMessageRequest.KEY_SENDER_DATA))
            {
               log.warn("Unexpected. Private message has no Sender details!");
               return;
            }
            sender = SFSUser.fromSFSArray(sfso.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
         }
         evtParams.sender = sender;
         evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
         evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PRIVATE_MESSAGE,evtParams));
      }
      
      public function handleBuddyMessage(sfso:ISFSObject) : void
      {
         var evtParams:Object = {};
         var senderId:int = sfso.getInt(GenericMessageRequest.KEY_USER_ID);
         var senderBuddy:Buddy = this.sfs.buddyManager.getBuddyById(senderId);
         evtParams.isItMe = this.sfs.mySelf.id == senderId;
         evtParams.buddy = senderBuddy;
         evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
         evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_MESSAGE,evtParams));
      }
      
      public function handleModMessage(sfso:ISFSObject) : void
      {
         var evtParams:Object = {};
         evtParams.sender = SFSUser.fromSFSArray(sfso.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
         evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
         evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.MODERATOR_MESSAGE,evtParams));
      }
      
      public function handleAdminMessage(sfso:ISFSObject) : void
      {
         var evtParams:Object = {};
         evtParams.sender = SFSUser.fromSFSArray(sfso.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
         evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
         evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ADMIN_MESSAGE,evtParams));
      }
      
      public function handleObjectMessage(sfso:ISFSObject) : void
      {
         var evtParams:Object = {};
         var senderId:int = sfso.getInt(GenericMessageRequest.KEY_USER_ID);
         evtParams.sender = this.sfs.userManager.getUserById(senderId);
         evtParams.message = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.OBJECT_MESSAGE,evtParams));
      }
      
      private function fnUserExitRoom(msg:IMessage) : void
      {
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var rId:int = sfso.getInt("r");
         var uId:int = sfso.getInt("u");
         var room:Room = this.sfs.roomManager.getRoomById(rId);
         var user:User = this.sfs.userManager.getUserById(uId);
         if(room != null && user != null)
         {
            room.removeUser(user);
            this.sfs.userManager.removeUser(user);
            if(user.isItMe && room.isJoined)
            {
               room.isJoined = false;
               if(this.sfs.joinedRooms.length == 0)
               {
                  this.sfs.lastJoinedRoom = null;
               }
               if(!room.isManaged)
               {
                  this.sfs.roomManager.removeRoom(room);
               }
            }
            evtParams.user = user;
            evtParams.room = room;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_EXIT_ROOM,evtParams));
         }
         else
         {
            log.debug("Failed to handle UserExit event. Room: " + room + ", User: " + user);
         }
      }
      
      private function fnClientDisconnection(msg:IMessage) : void
      {
         var sfso:ISFSObject = msg.content;
         var reasonId:int = sfso.getByte("dr");
         this.sfs.handleClientDisconnection(ClientDisconnectionReason.getReason(reasonId));
      }
      
      private function fnSetRoomVariables(msg:IMessage) : void
      {
         var j:int = 0;
         var roomVar:RoomVariable = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var rId:int = sfso.getInt(SetRoomVariablesRequest.KEY_VAR_ROOM);
         var varListData:ISFSArray = sfso.getSFSArray(SetRoomVariablesRequest.KEY_VAR_LIST);
         var targetRoom:Room = this.sfs.roomManager.getRoomById(rId);
         var changedVarNames:Array = [];
         if(targetRoom != null)
         {
            for(j = 0; j < varListData.size(); j++)
            {
               roomVar = SFSRoomVariable.fromSFSArray(varListData.getSFSArray(j));
               targetRoom.setVariable(roomVar);
               changedVarNames.push(roomVar.name);
            }
            evtParams.changedVars = changedVarNames;
            evtParams.room = targetRoom;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_VARIABLES_UPDATE,evtParams));
         }
         else
         {
            log.warn("RoomVariablesUpdate, unknown Room id = " + rId);
         }
      }
      
      private function fnSetUserVariables(msg:IMessage) : void
      {
         var j:int = 0;
         var userVar:UserVariable = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var uId:int = sfso.getInt(SetUserVariablesRequest.KEY_USER);
         var varListData:ISFSArray = sfso.getSFSArray(SetUserVariablesRequest.KEY_VAR_LIST);
         var user:User = this.sfs.userManager.getUserById(uId);
         var changedVarNames:Array = [];
         if(user != null)
         {
            for(j = 0; j < varListData.size(); j++)
            {
               userVar = SFSUserVariable.fromSFSArray(varListData.getSFSArray(j));
               user.setVariable(userVar);
               changedVarNames.push(userVar.name);
            }
            evtParams.changedVars = changedVarNames;
            evtParams.user = user;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_VARIABLES_UPDATE,evtParams));
         }
         else
         {
            log.warn("UserVariablesUpdate: unknown user id = " + uId);
         }
      }
      
      private function fnSubscribeRoomGroup(msg:IMessage) : void
      {
         var groupId:String = null;
         var roomListData:ISFSArray = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            groupId = sfso.getUtfString(SubscribeRoomGroupRequest.KEY_GROUP_ID);
            roomListData = sfso.getSFSArray(SubscribeRoomGroupRequest.KEY_ROOM_LIST);
            if(this.sfs.roomManager.containsGroup(groupId))
            {
               log.warn("SubscribeGroup Error. Group:",groupId,"already subscribed!");
            }
            this.populateRoomList(roomListData);
            evtParams.groupId = groupId;
            evtParams.newRooms = this.sfs.roomManager.getRoomListFromGroup(groupId);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_SUBSCRIBE,evtParams));
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR,evtParams));
         }
      }
      
      private function fnUnsubscribeRoomGroup(msg:IMessage) : void
      {
         var groupId:String = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            groupId = sfso.getUtfString(SubscribeRoomGroupRequest.KEY_GROUP_ID);
            if(!this.sfs.roomManager.containsGroup(groupId))
            {
               log.warn("UnsubscribeGroup Error. Group:",groupId,"is not subscribed!");
            }
            this.sfs.roomManager.removeGroup(groupId);
            evtParams.groupId = groupId;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_UNSUBSCRIBE,evtParams));
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR,evtParams));
         }
      }
      
      private function fnChangeRoomName(msg:IMessage) : void
      {
         var roomId:int = 0;
         var targetRoom:Room = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            roomId = sfso.getInt(ChangeRoomNameRequest.KEY_ROOM);
            targetRoom = this.sfs.roomManager.getRoomById(roomId);
            if(targetRoom != null)
            {
               evtParams.oldName = targetRoom.name;
               this.sfs.roomManager.changeRoomName(targetRoom,sfso.getUtfString(ChangeRoomNameRequest.KEY_NAME));
               evtParams.room = targetRoom;
               this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_NAME_CHANGE,evtParams));
            }
            else
            {
               log.warn("Room not found, ID:",roomId,", Room name change failed.");
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_NAME_CHANGE_ERROR,evtParams));
         }
      }
      
      private function fnChangeRoomPassword(msg:IMessage) : void
      {
         var roomId:int = 0;
         var targetRoom:Room = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            roomId = sfso.getInt(ChangeRoomPasswordStateRequest.KEY_ROOM);
            targetRoom = this.sfs.roomManager.getRoomById(roomId);
            if(targetRoom != null)
            {
               this.sfs.roomManager.changeRoomPasswordState(targetRoom,sfso.getBool(ChangeRoomPasswordStateRequest.KEY_PASS));
               evtParams.room = targetRoom;
               this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_PASSWORD_STATE_CHANGE,evtParams));
            }
            else
            {
               log.warn("Room not found, ID:",roomId,", Room password change failed.");
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_PASSWORD_STATE_CHANGE_ERROR,evtParams));
         }
      }
      
      private function fnChangeRoomCapacity(msg:IMessage) : void
      {
         var roomId:int = 0;
         var targetRoom:Room = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            roomId = sfso.getInt(ChangeRoomCapacityRequest.KEY_ROOM);
            targetRoom = this.sfs.roomManager.getRoomById(roomId);
            if(targetRoom != null)
            {
               this.sfs.roomManager.changeRoomCapacity(targetRoom,sfso.getInt(ChangeRoomCapacityRequest.KEY_USER_SIZE),sfso.getInt(ChangeRoomCapacityRequest.KEY_SPEC_SIZE));
               evtParams.room = targetRoom;
               this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CAPACITY_CHANGE,evtParams));
            }
            else
            {
               log.warn("Room not found, ID:",roomId,", Room capacity change failed.");
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CAPACITY_CHANGE_ERROR,evtParams));
         }
      }
      
      private function fnLogout(msg:IMessage) : void
      {
         this.sfs.handleLogout();
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         evtParams.zoneName = sfso.getUtfString(LogoutRequest.KEY_ZONE_NAME);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGOUT,evtParams));
      }
      
      private function fnSpectatorToPlayer(msg:IMessage) : void
      {
         var roomId:int = 0;
         var userId:int = 0;
         var playerId:int = 0;
         var user:User = null;
         var targetRoom:Room = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            roomId = sfso.getInt(SpectatorToPlayerRequest.KEY_ROOM_ID);
            userId = sfso.getInt(SpectatorToPlayerRequest.KEY_USER_ID);
            playerId = sfso.getShort(SpectatorToPlayerRequest.KEY_PLAYER_ID);
            user = this.sfs.userManager.getUserById(userId);
            targetRoom = this.sfs.roomManager.getRoomById(roomId);
            if(targetRoom != null)
            {
               if(user != null)
               {
                  if(user.isJoinedInRoom(targetRoom))
                  {
                     user.setPlayerId(playerId,targetRoom);
                     evtParams.room = targetRoom;
                     evtParams.user = user;
                     evtParams.playerId = playerId;
                     this.sfs.dispatchEvent(new SFSEvent(SFSEvent.SPECTATOR_TO_PLAYER,evtParams));
                  }
                  else
                  {
                     log.warn("User: " + user + " not joined in Room: ",targetRoom,", SpectatorToPlayer failed.");
                  }
               }
               else
               {
                  log.warn("User not found, ID:",userId,", SpectatorToPlayer failed.");
               }
            }
            else
            {
               log.warn("Room not found, ID:",roomId,", SpectatorToPlayer failed.");
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.SPECTATOR_TO_PLAYER_ERROR,evtParams));
         }
      }
      
      private function fnPlayerToSpectator(msg:IMessage) : void
      {
         var roomId:int = 0;
         var userId:int = 0;
         var user:User = null;
         var targetRoom:Room = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            roomId = sfso.getInt(PlayerToSpectatorRequest.KEY_ROOM_ID);
            userId = sfso.getInt(PlayerToSpectatorRequest.KEY_USER_ID);
            user = this.sfs.userManager.getUserById(userId);
            targetRoom = this.sfs.roomManager.getRoomById(roomId);
            if(targetRoom != null)
            {
               if(user != null)
               {
                  if(user.isJoinedInRoom(targetRoom))
                  {
                     user.setPlayerId(-1,targetRoom);
                     evtParams.room = targetRoom;
                     evtParams.user = user;
                     this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PLAYER_TO_SPECTATOR,evtParams));
                  }
                  else
                  {
                     log.warn("User: " + user + " not joined in Room: ",targetRoom,", PlayerToSpectator failed.");
                  }
               }
               else
               {
                  log.warn("User not found, ID:",userId,", PlayerToSpectator failed.");
               }
            }
            else
            {
               log.warn("Room not found, ID:",roomId,", PlayerToSpectator failed.");
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PLAYER_TO_SPECTATOR_ERROR,evtParams));
         }
      }
      
      private function fnInitBuddyList(msg:IMessage) : void
      {
         var bListData:ISFSArray = null;
         var myVarsData:ISFSArray = null;
         var buddyStates:Array = null;
         var i:int = 0;
         var myBuddyVariables:Array = null;
         var b:Buddy = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            bListData = sfso.getSFSArray(InitBuddyListRequest.KEY_BLIST);
            myVarsData = sfso.getSFSArray(InitBuddyListRequest.KEY_MY_VARS);
            buddyStates = sfso.getUtfStringArray(InitBuddyListRequest.KEY_BUDDY_STATES);
            this.sfs.buddyManager.clearAll();
            for(i = 0; i < bListData.size(); i++)
            {
               b = SFSBuddy.fromSFSArray(bListData.getSFSArray(i));
               this.sfs.buddyManager.addBuddy(b);
            }
            if(buddyStates != null)
            {
               this.sfs.buddyManager.setBuddyStates(buddyStates);
            }
            myBuddyVariables = [];
            for(i = 0; i < myVarsData.size(); i++)
            {
               myBuddyVariables.push(SFSBuddyVariable.fromSFSArray(myVarsData.getSFSArray(i)));
            }
            this.sfs.buddyManager.setMyVariables(myBuddyVariables);
            this.sfs.buddyManager.setInited();
            evtParams.buddyList = this.sfs.buddyManager.buddyList;
            evtParams.myVariables = this.sfs.buddyManager.myVariables;
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_LIST_INIT,evtParams));
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,evtParams));
         }
      }
      
      private function fnAddBuddy(msg:IMessage) : void
      {
         var buddy:Buddy = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            buddy = SFSBuddy.fromSFSArray(sfso.getSFSArray(AddBuddyRequest.KEY_BUDDY_NAME));
            this.sfs.buddyManager.addBuddy(buddy);
            evtParams.buddy = buddy;
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ADD,evtParams));
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,evtParams));
         }
      }
      
      private function fnRemoveBuddy(msg:IMessage) : void
      {
         var buddyName:String = null;
         var buddy:Buddy = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            buddyName = sfso.getUtfString(RemoveBuddyRequest.KEY_BUDDY_NAME);
            buddy = this.sfs.buddyManager.removeBuddyByName(buddyName);
            if(buddy != null)
            {
               evtParams.buddy = buddy;
               this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_REMOVE,evtParams));
            }
            else
            {
               log.warn("RemoveBuddy failed, buddy not found: " + buddyName);
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,evtParams));
         }
      }
      
      private function fnBlockBuddy(msg:IMessage) : void
      {
         var buddyName:String = null;
         var buddy:Buddy = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            buddyName = sfso.getUtfString(BlockBuddyRequest.KEY_BUDDY_NAME);
            buddy = this.sfs.buddyManager.getBuddyByName(buddyName);
            if(buddy != null)
            {
               buddy.setBlocked(sfso.getBool(BlockBuddyRequest.KEY_BUDDY_BLOCK_STATE));
               evtParams.buddy = buddy;
               this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_BLOCK,evtParams));
            }
            else
            {
               log.warn("BlockBuddy failed, buddy not found: " + buddyName + ", in local BuddyList");
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,evtParams));
         }
      }
      
      private function fnGoOnline(msg:IMessage) : void
      {
         var buddyName:String = null;
         var buddy:Buddy = null;
         var isItMe:Boolean = false;
         var onlineValue:int = 0;
         var onlineState:Boolean = false;
         var fireEvent:Boolean = false;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            buddyName = sfso.getUtfString(GoOnlineRequest.KEY_BUDDY_NAME);
            buddy = this.sfs.buddyManager.getBuddyByName(buddyName);
            isItMe = buddyName == this.sfs.mySelf.name;
            onlineValue = sfso.getByte(GoOnlineRequest.KEY_ONLINE);
            onlineState = onlineValue == BuddyOnlineState.ONLINE;
            fireEvent = true;
            if(isItMe)
            {
               if(this.sfs.buddyManager.myOnlineState != onlineState)
               {
                  log.warn("Unexpected: MyOnlineState is not in synch with the server. Resynching: " + onlineState);
                  this.sfs.buddyManager.setMyOnlineState(onlineState);
               }
            }
            else
            {
               if(buddy == null)
               {
                  log.warn("GoOnline error, buddy not found: " + buddyName + ", in local BuddyList.");
                  return;
               }
               buddy.setId(sfso.getInt(GoOnlineRequest.KEY_BUDDY_ID));
               buddy.setVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_ONLINE,onlineState));
               if(onlineValue == BuddyOnlineState.LEFT_THE_SERVER)
               {
                  buddy.clearVolatileVariables();
               }
               fireEvent = this.sfs.buddyManager.myOnlineState;
            }
            if(fireEvent)
            {
               evtParams.buddy = buddy;
               evtParams.isItMe = isItMe;
               this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE,evtParams));
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,evtParams));
         }
      }
      
      private function fnSetBuddyVariables(msg:IMessage) : void
      {
         var buddyName:String = null;
         var buddyVarsData:ISFSArray = null;
         var buddy:Buddy = null;
         var isItMe:Boolean = false;
         var changedVarNames:Array = null;
         var variables:Array = null;
         var fireEvent:Boolean = false;
         var j:int = 0;
         var buddyVar:BuddyVariable = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            buddyName = sfso.getUtfString(SetBuddyVariablesRequest.KEY_BUDDY_NAME);
            buddyVarsData = sfso.getSFSArray(SetBuddyVariablesRequest.KEY_BUDDY_VARS);
            buddy = this.sfs.buddyManager.getBuddyByName(buddyName);
            isItMe = buddyName == this.sfs.mySelf.name;
            changedVarNames = [];
            variables = [];
            fireEvent = true;
            for(j = 0; j < buddyVarsData.size(); j++)
            {
               buddyVar = SFSBuddyVariable.fromSFSArray(buddyVarsData.getSFSArray(j));
               variables.push(buddyVar);
               changedVarNames.push(buddyVar.name);
            }
            if(isItMe)
            {
               this.sfs.buddyManager.setMyVariables(variables);
            }
            else
            {
               if(buddy == null)
               {
                  log.warn("Unexpected. Target of BuddyVariables update not found: " + buddyName);
                  return;
               }
               buddy.setVariables(variables);
               fireEvent = this.sfs.buddyManager.myOnlineState;
            }
            if(fireEvent)
            {
               evtParams.isItMe = isItMe;
               evtParams.changedVars = changedVarNames;
               evtParams.buddy = buddy;
               this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_VARIABLES_UPDATE,evtParams));
            }
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,evtParams));
         }
      }
      
      private function fnFindRooms(msg:IMessage) : void
      {
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var roomListData:ISFSArray = sfso.getSFSArray(FindRoomsRequest.KEY_FILTERED_ROOMS);
         var roomList:Array = [];
         for(var i:int = 0; i < roomListData.size(); i++)
         {
            roomList.push(SFSRoom.fromSFSArray(roomListData.getSFSArray(i)));
         }
         evtParams.rooms = roomList;
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_FIND_RESULT,evtParams));
      }
      
      private function fnFindUsers(msg:IMessage) : void
      {
         var u:User = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var userListData:ISFSArray = sfso.getSFSArray(FindUsersRequest.KEY_FILTERED_USERS);
         var userList:Array = [];
         var mySelf:User = this.sfs.mySelf;
         for(var i:int = 0; i < userListData.size(); i++)
         {
            u = SFSUser.fromSFSArray(userListData.getSFSArray(i));
            if(u.id == mySelf.id)
            {
               u = mySelf;
            }
            userList.push(u);
         }
         evtParams.users = userList;
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_FIND_RESULT,evtParams));
      }
      
      private function fnInviteUsers(msg:IMessage) : void
      {
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         var inviter:User = null;
         if(sfso.containsKey(InviteUsersRequest.KEY_USER_ID))
         {
            inviter = this.sfs.userManager.getUserById(sfso.getInt(InviteUsersRequest.KEY_USER_ID));
         }
         else
         {
            inviter = SFSUser.fromSFSArray(sfso.getSFSArray(InviteUsersRequest.KEY_USER));
         }
         var expiryTime:int = sfso.getShort(InviteUsersRequest.KEY_TIME);
         var invitationId:int = sfso.getInt(InviteUsersRequest.KEY_INVITATION_ID);
         var invParams:ISFSObject = sfso.getSFSObject(InviteUsersRequest.KEY_PARAMS);
         var invitation:Invitation = new SFSInvitation(inviter,this.sfs.mySelf,expiryTime,invParams);
         invitation.id = invitationId;
         evtParams.invitation = invitation;
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION,evtParams));
      }
      
      private function fnInvitationReply(msg:IMessage) : void
      {
         var invitee:User = null;
         var reply:int = 0;
         var data:ISFSObject = null;
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            invitee = null;
            if(sfso.containsKey(InviteUsersRequest.KEY_USER_ID))
            {
               invitee = this.sfs.userManager.getUserById(sfso.getInt(InviteUsersRequest.KEY_USER_ID));
            }
            else
            {
               invitee = SFSUser.fromSFSArray(sfso.getSFSArray(InviteUsersRequest.KEY_USER));
            }
            reply = sfso.getUnsignedByte(InviteUsersRequest.KEY_REPLY_ID);
            data = sfso.getSFSObject(InviteUsersRequest.KEY_PARAMS);
            evtParams.invitee = invitee;
            evtParams.reply = reply;
            evtParams.data = data;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION_REPLY,evtParams));
         }
         else
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION_REPLY_ERROR,evtParams));
         }
      }
      
      private function fnQuickJoinGame(msg:IMessage) : void
      {
         var errorCd:int = 0;
         var errorMsg:String = null;
         var sfso:ISFSObject = msg.content;
         var evtParams:Object = {};
         if(sfso.containsKey(BaseRequest.KEY_ERROR_CODE))
         {
            errorCd = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
            errorMsg = SFSErrorCodes.getErrorMessage(errorCd,sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            evtParams = {
               "errorMessage":errorMsg,
               "errorCode":errorCd
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN_ERROR,evtParams));
         }
      }
      
      private function fnPingPong(msg:IMessage) : void
      {
         var avg:int = this.sfs.kernel::lagMonitor.onPingPong();
         var newEvt:SFSEvent = new SFSEvent(SFSEvent.PING_PONG,{"lagValue":avg});
         this.sfs.dispatchEvent(newEvt);
      }
      
      private function populateRoomList(roomList:ISFSArray) : void
      {
         var roomObj:ISFSArray = null;
         var newRoom:Room = null;
         var roomManager:IRoomManager = this.sfs.roomManager;
         for(var j:int = 0; j < roomList.size(); j++)
         {
            roomObj = roomList.getSFSArray(j);
            newRoom = SFSRoom.fromSFSArray(roomObj);
            roomManager.replaceRoom(newRoom);
         }
      }
      
      private function getOrCreateUser(userObj:ISFSArray, addToGlobalManager:Boolean = false, room:Room = null) : User
      {
         var uVars:ISFSArray = null;
         var i:int = 0;
         var uId:int = userObj.getInt(0);
         var user:User = this.sfs.userManager.getUserById(uId);
         if(user == null)
         {
            user = SFSUser.fromSFSArray(userObj,room);
            user.userManager = this.sfs.userManager;
         }
         else if(room != null)
         {
            user.setPlayerId(userObj.getShort(3),room);
            uVars = userObj.getSFSArray(4);
            for(i = 0; i < uVars.size(); i++)
            {
               user.setVariable(SFSUserVariable.fromSFSArray(uVars.getSFSArray(i)));
            }
         }
         if(addToGlobalManager)
         {
            this.sfs.userManager.addUser(user);
         }
         return user;
      }
   }
}
