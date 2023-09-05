package com.smartfoxserver.v2.requests
{
     import com.smartfoxserver.v2.SmartFox;
     
     public class ManualDisconnectionRequest extends BaseRequest
     {
           
          
          public function ManualDisconnectionRequest()
          {
               super(BaseRequest.ManualDisconnection);
          }
          
          override public function validate(sfs:SmartFox) : void
          {
          }
          
          override public function execute(sfs:SmartFox) : void
          {
          }
     }
}
