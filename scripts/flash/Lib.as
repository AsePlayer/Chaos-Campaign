package flash
{
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.fscommand;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   
   public class Lib
   {
      
      public static var current:MovieClip;
       
      
      public function Lib()
      {
      }
      
      public static function getTimer() : int
      {
         return getTimer();
      }
      
      public static function eval(path:String) : *
      {
         var _loc6_:* = null;
         var _loc8_:* = null as String;
         var _loc3_:Array = path.split(".");
         var _loc4_:Array = [];
         var _loc5_:* = null;
         while(int(_loc3_.length) > 0)
         {
            try
            {
               _loc5_ = getDefinitionByName(_loc3_.join("."));
            }
            catch(_loc_e_:*)
            {
               _loc4_.unshift(_loc3_.pop());
               if(_loc5_ != null)
               {
                  break;
               }
               continue;
            }
         }
         var _loc7_:int = 0;
         while(_loc7_ < int(_loc4_.length))
         {
            _loc8_ = _loc4_[_loc7_];
            _loc7_++;
            if(_loc5_ == null)
            {
               return null;
            }
            _loc5_ = _loc5_[_loc8_];
         }
         return _loc5_;
      }
      
      public static function getURL(url:URLRequest, target:String = undefined) : void
      {
         var _loc3_:Function = navigateToURL;
         if(target == null)
         {
            _loc3_(url);
         }
         else
         {
            _loc3_(url,target);
         }
      }
      
      public static function fscommand(cmd:String, param:String = undefined) : void
      {
         fscommand(cmd,param == null ? "" : param);
      }
      
      public static function trace(arg:*) : void
      {
         trace(arg);
      }
      
      public static function attach(name:String) : MovieClip
      {
         var _loc2_:* = getDefinitionByName(name) as Class;
         return new _loc2_();
      }
      
      public static function §as§(v:*, c:Class) : Object
      {
         return v as c;
      }
   }
}
