package com.smartfoxserver.v2.requests
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.entities.Room;
     import com.smartfoxserver.v2.entities.User;
     import com.smartfoxserver.v2.entities.data.ISFSObject;
     import com.smartfoxserver.v2.exceptions.SFSError;
     import com.smartfoxserver.v2.exceptions.SFSValidationError;
     import com.smartfoxserver.v2.logging.Logger;
     import de.polygonal.ds.ListSet;
     
     public class GenericMessageRequest extends BaseRequest
     {
          
          public static const KEY_ROOM_ID:String = "r";
          
          public static const KEY_USER_ID:String = "u";
          
          public static const KEY_MESSAGE:String = "m";
          
          public static const KEY_MESSAGE_TYPE:String = "t";
          
          public static const KEY_RECIPIENT:String = "rc";
          
          public static const KEY_RECIPIENT_MODE:String = "rm";
          
          public static const KEY_XTRA_PARAMS:String = "p";
          
          public static const KEY_SENDER_DATA:String = "sd";
           
          
          protected var _type:int = -1;
          
          protected var _room:Room;
          
          protected var _user:User;
          
          protected var _message:String;
          
          protected var _params:ISFSObject;
          
          protected var _recipient;
          
          protected var _sendMode:int = -1;
          
          protected var _log:Logger;
          
          public function GenericMessageRequest()
          {
               super(BaseRequest.GenericMessage);
               this._log = Logger.getInstance();
          }
          
          override public function validate(sfs:SmartFox) : void
          {
               if(this._type < 0)
               {
                    throw new SFSValidationError("PublicMessage request error",["Unsupported message type: " + this._type]);
               }
               var errors:Array = [];
               switch(this._type)
               {
                    case GenericMessageType.PUBLIC_MSG:
                         this.validatePublicMessage(sfs,errors);
                         break;
                    case GenericMessageType.PRIVATE_MSG:
                         this.validatePrivateMessage(sfs,errors);
                         break;
                    case GenericMessageType.OBJECT_MSG:
                         this.validateObjectMessage(sfs,errors);
                         break;
                    case GenericMessageType.BUDDY_MSG:
                         this.validateBuddyMessage(sfs,errors);
                         break;
                    default:
                         this.validateSuperUserMessage(sfs,errors);
               }
               if(errors.length > 0)
               {
                    throw new SFSValidationError("Request error - ",errors);
               }
          }
          
          override public function execute(sfs:SmartFox) : void
          {
               _sfso.putByte(KEY_MESSAGE_TYPE,this._type);
               switch(this._type)
               {
                    case GenericMessageType.PUBLIC_MSG:
                         this.executePublicMessage(sfs);
                         break;
                    case GenericMessageType.PRIVATE_MSG:
                         this.executePrivateMessage(sfs);
                         break;
                    case GenericMessageType.OBJECT_MSG:
                         this.executeObjectMessage(sfs);
                         break;
                    case GenericMessageType.BUDDY_MSG:
                         this.executeBuddyMessage(sfs);
                         break;
                    default:
                         this.executeSuperUserMessage(sfs);
               }
          }
          
          private function validatePublicMessage(sfs:SmartFox, errors:Array) : void
          {
               if(this._message == null || this._message.length == 0)
               {
                    errors.push("Public message is empty!");
               }
               if(this._room != null && !sfs.mySelf.isJoinedInRoom(this._room))
               {
                    errors.push("You are not joined in the target Room: " + this._room);
               }
          }
          
          private function validatePrivateMessage(sfs:SmartFox, errors:Array) : void
          {
               if(this._message == null || this._message.length == 0)
               {
                    errors.push("Private message is empty!");
               }
               if(this._recipient < 0)
               {
                    errors.push("Invalid recipient id: " + this._recipient);
               }
          }
          
          private function validateObjectMessage(sfs:SmartFox, errors:Array) : void
          {
               if(this._params == null)
               {
                    errors.push("Object message is null!");
               }
          }
          
          private function validateBuddyMessage(sfs:SmartFox, errors:Array) : void
          {
               if(!sfs.buddyManager.isInited)
               {
                    errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
               }
               if(sfs.buddyManager.myOnlineState == false)
               {
                    errors.push("Can\'t send messages while off-line");
               }
               if(this._message == null || this._message.length == 0)
               {
                    errors.push("Buddy message is empty!");
               }
               var recipientId:int = Number(this._recipient);
               if(recipientId < 0)
               {
                    errors.push("Recipient is not online or not in your buddy list");
               }
          }
          
          private function validateSuperUserMessage(sfs:SmartFox, errors:Array) : void
          {
               if(this._message == null || this._message.length == 0)
               {
                    errors.push("Moderator message is empty!");
               }
               switch(this._sendMode)
               {
                    case MessageRecipientMode.TO_USER:
                         if(!(this._recipient is User))
                         {
                              errors.push("TO_USER expects a User object as recipient");
                         }
                         break;
                    case MessageRecipientMode.TO_ROOM:
                         if(!(this._recipient is Room))
                         {
                              errors.push("TO_ROOM expects a Room object as recipient");
                         }
                         break;
                    case MessageRecipientMode.TO_GROUP:
                         if(!(this._recipient is String))
                         {
                              errors.push("TO_GROUP expects a String object (the groupId) as recipient");
                         }
               }
          }
          
          private function executePublicMessage(sfs:SmartFox) : void
          {
               if(this._room == null)
               {
                    this._room = sfs.lastJoinedRoom;
               }
               if(this._room == null)
               {
                    throw new SFSError("User should be joined in a room in order to send a public message");
               }
               _sfso.putInt(KEY_ROOM_ID,this._room.id);
               _sfso.putInt(KEY_USER_ID,sfs.mySelf.id);
               _sfso.putUtfString(KEY_MESSAGE,this._message);
               if(this._params != null)
               {
                    _sfso.putSFSObject(KEY_XTRA_PARAMS,this._params);
               }
          }
          
          private function executePrivateMessage(sfs:SmartFox) : void
          {
               _sfso.putInt(KEY_RECIPIENT,this._recipient as int);
               _sfso.putUtfString(KEY_MESSAGE,this._message);
               if(this._params != null)
               {
                    _sfso.putSFSObject(KEY_XTRA_PARAMS,this._params);
               }
          }
          
          private function executeBuddyMessage(sfs:SmartFox) : void
          {
               _sfso.putInt(KEY_RECIPIENT,this._recipient as int);
               _sfso.putUtfString(KEY_MESSAGE,this._message);
               if(this._params != null)
               {
                    _sfso.putSFSObject(KEY_XTRA_PARAMS,this._params);
               }
          }
          
          private function executeSuperUserMessage(sfs:SmartFox) : void
          {
               _sfso.putUtfString(KEY_MESSAGE,this._message);
               if(this._params != null)
               {
                    _sfso.putSFSObject(KEY_XTRA_PARAMS,this._params);
               }
               _sfso.putInt(KEY_RECIPIENT_MODE,this._sendMode);
               switch(this._sendMode)
               {
                    case MessageRecipientMode.TO_USER:
                         _sfso.putInt(KEY_RECIPIENT,this._recipient.id);
                         break;
                    case MessageRecipientMode.TO_ROOM:
                         _sfso.putInt(KEY_RECIPIENT,this._recipient.id);
                         break;
                    case MessageRecipientMode.TO_GROUP:
                         _sfso.putUtfString(KEY_RECIPIENT,this._recipient);
               }
          }
          
          private function executeObjectMessage(sfs:SmartFox) : void
          {
               var potentialRecipients:Array = null;
               var item:* = undefined;
               if(this._room == null)
               {
                    this._room = sfs.lastJoinedRoom;
               }
               var recipients:ListSet = new ListSet();
               if(this._recipient is Array)
               {
                    potentialRecipients = this._recipient as Array;
                    if(potentialRecipients.length > this._room.capacity)
                    {
                         throw new ArgumentError("The number of recipients is bigger than the target Room capacity: " + potentialRecipients.length);
                    }
                    for each(item in potentialRecipients)
                    {
                         if(item is User)
                         {
                              recipients.set(item.id);
                         }
                         else
                         {
                              this._log.warn("Bad recipient in ObjectMessage recipient list: " + typeof item + ", expected type: User");
                         }
                    }
               }
               _sfso.putInt(KEY_ROOM_ID,this._room.id);
               _sfso.putSFSObject(KEY_XTRA_PARAMS,this._params);
               if(recipients.size() > 0)
               {
                    _sfso.putIntArray(KEY_RECIPIENT,recipients.toDA().getArray());
               }
          }
     }
}
