package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   
   public class PingPongRequest extends BaseRequest
   {
       
      
      public function PingPongRequest()
      {
         super(BaseRequest.PingPong);
      }
      
      override public function execute(sfs:SmartFox) : void
      {
      }
      
      override public function validate(sfs:SmartFox) : void
      {
      }
   }
}
