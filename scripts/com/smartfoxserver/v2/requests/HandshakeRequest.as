package com.smartfoxserver.v2.requests
{
     import flash.system.Capabilities;
     
     public class HandshakeRequest extends BaseRequest
     {
          
          public static const KEY_SESSION_TOKEN:String = "tk";
          
          public static const KEY_API:String = "api";
          
          public static const KEY_COMPRESSION_THRESHOLD:String = "ct";
          
          public static const KEY_RECONNECTION_TOKEN:String = "rt";
          
          public static const KEY_CLIENT_TYPE:String = "cl";
          
          public static const KEY_MAX_MESSAGE_SIZE:String = "ms";
           
          
          public function HandshakeRequest(apiVersion:String, reconnectionToken:String = null)
          {
               super(BaseRequest.Handshake);
               _sfso.putUtfString(KEY_API,apiVersion);
               var clientType:String = "FlashPlayer:" + Capabilities.playerType + ":" + Capabilities.version;
               _sfso.putUtfString(KEY_CLIENT_TYPE,clientType);
               if(reconnectionToken != null)
               {
                    _sfso.putUtfString(KEY_RECONNECTION_TOKEN,reconnectionToken);
               }
          }
     }
}
