package com.smartfoxserver.v2.entities.managers
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.entities.User;
     import com.smartfoxserver.v2.kernel;
     import com.smartfoxserver.v2.logging.Logger;
     import de.polygonal.ds.HashMap;
     import de.polygonal.ds.Itr;
     
     public class SFSUserManager implements IUserManager
     {
           
          
          private var _usersByName:HashMap;
          
          private var _usersById:HashMap;
          
          protected var _log:Logger;
          
          protected var _smartFox:SmartFox;
          
          public function SFSUserManager(sfs:SmartFox)
          {
               super();
               this._smartFox = sfs;
               this._log = Logger.getInstance();
               this._usersByName = new HashMap();
               this._usersById = new HashMap();
          }
          
          public function containsUserName(userName:String) : Boolean
          {
               return this._usersByName.hasKey(userName);
          }
          
          public function containsUserId(userId:int) : Boolean
          {
               return this._usersById.hasKey(userId);
          }
          
          public function containsUser(user:User) : Boolean
          {
               return this._usersByName.contains(user);
          }
          
          public function getUserByName(userName:String) : User
          {
               return this._usersByName.get(userName) as User;
          }
          
          public function getUserById(userId:int) : User
          {
               return this._usersById.get(userId) as User;
          }
          
          public function addUser(user:User) : void
          {
               if(this._usersById.hasKey(user.id))
               {
                    this._log.warn("Unexpected: duplicate user in UserManager: " + user);
               }
               this._addUser(user);
          }
          
          protected function _addUser(user:User) : void
          {
               this._usersByName.set(user.name,user);
               this._usersById.set(user.id,user);
          }
          
          public function removeUser(user:User) : void
          {
               this._usersByName.clr(user.name);
               this._usersById.clr(user.id);
          }
          
          public function removeUserById(id:int) : void
          {
               var user:User = this._usersById.get(id) as User;
               if(user != null)
               {
                    this.removeUser(user);
               }
          }
          
          public function get userCount() : int
          {
               return this._usersById.size();
          }
          
          public function get smartFox() : SmartFox
          {
               return this._smartFox;
          }
          
          public function getUserList() : Array
          {
               var userList:Array = [];
               var iter:Itr = this._usersById.iterator();
               while(iter.hasNext())
               {
                    userList.push(iter.next());
               }
               return userList;
          }
          
          kernel function clearAll() : void
          {
               this._usersByName = new HashMap();
               this._usersById = new HashMap();
          }
     }
}
