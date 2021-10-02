package com.google.analytics.external
{
   import com.google.analytics.debug.DebugConfiguration;
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   
   public class JavascriptProxy
   {
      
      public static var setProperty_js:XML = <script>
                <![CDATA[
                    function( path , value )
                    {
                        var paths;
                        var prop;
                        if( path.indexOf(".") > 0 )
                        {
                            paths = path.split(".");
                            prop  = paths.pop() ;
                        }
                        else
                        {
                            paths = [];
                            prop  = path;
                        }
                        var target = window ;
                        var len    = paths.length ;
                        for( var i = 0 ; i < len ; i++ )
                        {
                            target = target[ paths[i] ] ;
                        }
                        
                        target[ prop ] = value ;
                    }
                ]]>
            </script>;
      
      public static var hasProperty_js:XML = <script>
                <![CDATA[
                    function( path )
                    {
                        var paths;
                        if( path.indexOf(".") > 0 )
                        {
                            paths = path.split(".");
                        }
                        else
                        {
                            paths = [path];
                        }
                        var target = window ;
                        var len    = paths.length ;
                        for( var i = 0 ; i < len ; i++ )
                        {
                            target = target[ paths[i] ] ;
                        }
                        if( target )
                        {
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                ]]>
            </script>;
      
      public static var setPropertyRef_js:XML = <script>
                <![CDATA[
                    function( path , target )
                    {
                        var paths;
                        var prop;
                        if( path.indexOf(".") > 0 )
                        {
                            paths = path.split(".");
                            prop  = paths.pop() ;
                        }
                        else
                        {
                            paths = [];
                            prop  = path;
                        }
                        alert( "paths:"+paths.length+", prop:"+prop );
                        var targets;
                        var name;
                        if( target.indexOf(".") > 0 )
                        {
                            targets = target.split(".");
                            name    = targets.pop();
                        }
                        else
                        {
                            targets = [];
                            name    = target;
                        }
                        alert( "targets:"+targets.length+", name:"+name );
                        var root = window;
                        var len  = paths.length;
                        for( var i = 0 ; i < len ; i++ )
                        {
                            root = root[ paths[i] ] ;
                        }
                        var ref   = window;
                        var depth = targets.length;
                        for( var j = 0 ; j < depth ; j++ )
                        {
                            ref = ref[ targets[j] ] ;
                        }
                        root[ prop ] = ref[name] ;
                    }
                ]]>
            </script>;
       
      
      private var _notAvailableWarning:Boolean = true;
      
      private var _debug:DebugConfiguration;
      
      public function JavascriptProxy(debug:DebugConfiguration)
      {
         super();
         _debug = debug;
      }
      
      public function getProperty(name:String) : *
      {
         return call(name + ".valueOf");
      }
      
      public function hasProperty(path:String) : Boolean
      {
         return call(hasProperty_js,path);
      }
      
      public function setProperty(path:String, value:*) : void
      {
         call(setProperty_js,path,value);
      }
      
      public function executeBlock(data:String) : void
      {
         if(isAvailable())
         {
            try
            {
               ExternalInterface.call(data);
            }
            catch(e:SecurityError)
            {
               if(_debug.javascript)
               {
                  _debug.warning("ExternalInterface is not allowed.\nEnsure that allowScriptAccess is set to \"always\" in the Flash embed HTML.");
               }
            }
            catch(e:Error)
            {
               if(_debug.javascript)
               {
                  _debug.warning("ExternalInterface failed to make the call\nreason: " + e.message);
               }
            }
         }
      }
      
      public function getPropertyString(name:String) : String
      {
         return call(name + ".toString");
      }
      
      public function setPropertyByReference(path:String, target:String) : void
      {
         call(setPropertyRef_js,path,target);
      }
      
      public function call(functionName:String, ... args) : *
      {
         var output:String = null;
         if(isAvailable())
         {
            try
            {
               if(_debug.javascript && _debug.verbose)
               {
                  output = "";
                  output = "Flash->JS: " + functionName;
                  output += "( ";
                  if(args.length > 0)
                  {
                     output += args.join(",");
                  }
                  output += " )";
                  _debug.info(output);
               }
               args.unshift(functionName);
               return ExternalInterface.call.apply(ExternalInterface,args);
            }
            catch(e:SecurityError)
            {
               if(_debug.javascript)
               {
                  _debug.warning("ExternalInterface is not allowed.\nEnsure that allowScriptAccess is set to \"always\" in the Flash embed HTML.");
               }
            }
            catch(e:Error)
            {
               if(_debug.javascript)
               {
                  _debug.warning("ExternalInterface failed to make the call\nreason: " + e.message);
               }
            }
         }
         return null;
      }
      
      public function isAvailable() : Boolean
      {
         var available:Boolean = ExternalInterface.available;
         if(available && Capabilities.playerType == "External")
         {
            available = false;
         }
         if(!available && _debug.javascript && _notAvailableWarning)
         {
            _debug.warning("ExternalInterface is not available.");
            _notAvailableWarning = false;
         }
         return available;
      }
   }
}
