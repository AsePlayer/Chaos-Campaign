package as3reflect
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class MetadataUtils
   {
      
      private static var _cache:Object = new Object();
      
      public static var CLEAR_CACHE_INTERVAL:uint = 60000;
      
      private static var _timer:Timer;
       
      
      public function MetadataUtils()
      {
         super();
      }
      
      public static function getFromString(className:String) : XML
      {
         var classDefinition:Class = getDefinitionByName(className) as Class;
         return getFromObject(classDefinition);
      }
      
      public static function clearCache() : void
      {
         _cache = new Object();
         if(_timer && _timer.running)
         {
            _timer.stop();
         }
      }
      
      private static function _timerHandler(e:TimerEvent) : void
      {
         clearCache();
      }
      
      public static function getFromObject(object:Object) : XML
      {
         var metadata:XML = null;
         var className:String = getQualifiedClassName(object);
         if(_cache.hasOwnProperty(className))
         {
            metadata = _cache[className];
         }
         else
         {
            if(!_timer)
            {
               _timer = new Timer(CLEAR_CACHE_INTERVAL,1);
               _timer.addEventListener(TimerEvent.TIMER,_timerHandler);
            }
            if(!(object is Class))
            {
               object = object.constructor;
            }
            metadata = describeType(object);
            _cache[className] = metadata;
            if(!_timer.running)
            {
               _timer.start();
            }
         }
         return metadata;
      }
   }
}
