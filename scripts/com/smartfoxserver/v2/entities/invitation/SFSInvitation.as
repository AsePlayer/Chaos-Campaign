package com.smartfoxserver.v2.entities.invitation
{
     import com.smartfoxserver.v2.entities.User;
     import com.smartfoxserver.v2.entities.data.ISFSObject;
     
     public class SFSInvitation implements Invitation
     {
           
          
          protected var _id:int;
          
          protected var _inviter:User;
          
          protected var _invitee:User;
          
          protected var _secondsForAnswer:int;
          
          protected var _params:ISFSObject;
          
          public function SFSInvitation(inviter:User, invitee:User, secondsForAnswer:int = 15, params:ISFSObject = null)
          {
               super();
               this._inviter = inviter;
               this._invitee = invitee;
               this._secondsForAnswer = secondsForAnswer;
               this._params = params;
          }
          
          public function get id() : int
          {
               return this._id;
          }
          
          public function set id(value:int) : void
          {
               this._id = value;
          }
          
          public function get inviter() : User
          {
               return this._inviter;
          }
          
          public function get invitee() : User
          {
               return this._invitee;
          }
          
          public function get secondsForAnswer() : int
          {
               return this._secondsForAnswer;
          }
          
          public function get params() : ISFSObject
          {
               return this._params;
          }
     }
}
