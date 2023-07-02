package fl.display
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.LoaderInfo;
   import flash.errors.IllegalOperationError;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class ProLoaderInfo extends EventDispatcher
   {
       
      
      private var _proLoader:fl.display.ProLoader;
      
      private var _realLI:LoaderInfo;
      
      private var _realContentLI:LoaderInfo;
      
      private var _rslPreloaderLoaded:Boolean;
      
      private var _doneProgressStalling:Boolean;
      
      private var _numAdded:int;
      
      internal var _lcRequestedContentParentSet:Boolean;
      
      public function ProLoaderInfo(param1:fl.display.ProLoader)
      {
         super();
         this._realContentLI = null;
         this._lcRequestedContentParentSet = false;
         this._rslPreloaderLoaded = false;
         this._doneProgressStalling = false;
         this._numAdded = 0;
         this._proLoader = param1;
         this._realLI = param1.realLoader.contentLoaderInfo;
         this._realLI.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.handleAsyncErrorEvent,false,0,true);
         this._realLI.addEventListener(Event.COMPLETE,this.handleLoaderInfoEvent,false,0,true);
         this._realLI.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.handleLoaderInfoEvent,false,0,true);
         this._realLI.addEventListener(Event.INIT,this.handleLoaderInfoEvent,false,0,true);
         this._realLI.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoaderInfoEvent,false,0,true);
         this._realLI.addEventListener(Event.OPEN,this.handleLoaderInfoEvent,false,0,true);
         this._realLI.addEventListener(ProgressEvent.PROGRESS,this.handleProgressEvent,false,0,true);
         this._realLI.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityErrorEvent,false,0,true);
         this._realLI.addEventListener(Event.UNLOAD,this.handleLoaderInfoEvent,false,0,true);
      }
      
      internal function reset() : void
      {
         this._realContentLI = null;
         this._rslPreloaderLoaded = false;
         this._doneProgressStalling = false;
         this._lcRequestedContentParentSet = false;
      }
      
      public function get actionScriptVersion() : uint
      {
         return this._realLI.actionScriptVersion;
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         return this._realLI.applicationDomain;
      }
      
      public function get bytes() : ByteArray
      {
         return this._realLI.bytes;
      }
      
      public function get bytesLoaded() : uint
      {
         if(this._realLI.bytesLoaded >= this._realLI.bytesTotal && this._proLoader.content == null)
         {
            return this._realLI.bytesTotal - 1;
         }
         return this._realLI.bytesLoaded;
      }
      
      public function get bytesTotal() : uint
      {
         return this._realLI.bytesTotal;
      }
      
      public function get childAllowsParent() : Boolean
      {
         return this._realLI.childAllowsParent;
      }
      
      public function get childSandboxBridge() : Object
      {
         if(this._realContentLI != null)
         {
            return this._realContentLI["childSandboxBridge"];
         }
         return this._realLI["childSandboxBridge"];
      }
      
      public function set childSandboxBridge(param1:Object) : void
      {
         if(this._realContentLI != null)
         {
            this._realContentLI["childSandboxBridge"] = param1;
         }
         else
         {
            this._realLI["childSandboxBridge"] = param1;
         }
      }
      
      public function get content() : DisplayObject
      {
         return this._proLoader.content;
      }
      
      public function get contentType() : String
      {
         return this._realLI.contentType;
      }
      
      public function get frameRate() : Number
      {
         return this._realLI.frameRate;
      }
      
      public function get height() : int
      {
         return this._realLI.height;
      }
      
      public function get isURLInaccessible() : Boolean
      {
         return this._realLI.isURLInaccessible;
      }
      
      public function get loader() : fl.display.ProLoader
      {
         return this._proLoader;
      }
      
      public function get loaderURL() : String
      {
         return this._realLI.loaderURL;
      }
      
      public function get parameters() : Object
      {
         return this._realLI.parameters;
      }
      
      public function get parentAllowsChild() : Boolean
      {
         return this._realLI.parentAllowsChild;
      }
      
      public function get parentSandboxBridge() : Object
      {
         if(this._realContentLI != null)
         {
            return this._realContentLI["parentSandboxBridge"];
         }
         return this._realLI["parentSandboxBridge"];
      }
      
      public function set parentSandboxBridge(param1:Object) : *
      {
         if(this._realContentLI != null)
         {
            this._realContentLI["parentSandboxBridge"] = param1;
         }
         else
         {
            this._realLI["parentSandboxBridge"] = param1;
         }
      }
      
      public function get sameDomain() : Boolean
      {
         return this._realLI.sameDomain;
      }
      
      public function get sharedEvents() : EventDispatcher
      {
         if(this._realContentLI != null)
         {
            return this._realContentLI.sharedEvents;
         }
         return this._realLI.sharedEvents;
      }
      
      public function get swfVersion() : uint
      {
         return this._realLI.swfVersion;
      }
      
      public function get url() : String
      {
         return this._realLI.url;
      }
      
      public function get width() : int
      {
         return this._realLI.width;
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         Error.throwError(IllegalOperationError,2118);
         return false;
      }
      
      private function handleAsyncErrorEvent(param1:AsyncErrorEvent) : void
      {
         if(!this._lcRequestedContentParentSet)
         {
            super.dispatchEvent(param1);
         }
      }
      
      private function handleLoaderInfoEvent(param1:Event) : void
      {
         var theContent:DisplayObject = null;
         var theName:String = null;
         var rslPreloader:Object = null;
         var e:Event = param1;
         switch(e.type)
         {
            case HTTPStatusEvent.HTTP_STATUS:
            case IOErrorEvent.IO_ERROR:
            case Event.OPEN:
            case Event.UNLOAD:
               super.dispatchEvent(e);
               break;
            case Event.INIT:
               if(!this._rslPreloaderLoaded)
               {
                  try
                  {
                     theContent = this._realLI.content;
                     theName = getQualifiedClassName(theContent);
                     if(theName.substr(-13) == "__Preloader__")
                     {
                        rslPreloader = theContent["__rslPreloader"];
                        if(rslPreloader != null)
                        {
                           theName = getQualifiedClassName(rslPreloader);
                           if(theName == "fl.rsl::RSLPreloader")
                           {
                              this._rslPreloaderLoaded = true;
                              this._numAdded = 0;
                              theContent.addEventListener(Event.ADDED,this.handleAddedEvent,false,0,true);
                           }
                        }
                     }
                  }
                  catch(err:Error)
                  {
                     _rslPreloaderLoaded = false;
                  }
               }
               if(!this._rslPreloaderLoaded)
               {
                  this._proLoader.loadDoneCallback(theContent);
                  if(!this._doneProgressStalling && this._realLI.bytesLoaded >= this._realLI.bytesTotal)
                  {
                     this._doneProgressStalling = true;
                     super.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,this._realLI.bytesLoaded,this._realLI.bytesTotal));
                  }
                  super.dispatchEvent(e);
               }
               break;
            case Event.COMPLETE:
               if(!this._rslPreloaderLoaded)
               {
                  super.dispatchEvent(e);
               }
         }
      }
      
      private function handleProgressEvent(param1:ProgressEvent) : void
      {
         if(this._doneProgressStalling || param1.bytesLoaded < param1.bytesTotal)
         {
            super.dispatchEvent(param1);
         }
      }
      
      private function handleSecurityErrorEvent(param1:SecurityErrorEvent) : void
      {
         if(!this._lcRequestedContentParentSet || param1.errorID != 2047)
         {
            super.dispatchEvent(param1);
         }
      }
      
      private function handleAddedEvent(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         var _loc3_:DisplayObjectContainer = param1.currentTarget as DisplayObjectContainer;
         if(_loc2_ != null && _loc3_ != null && _loc2_.parent == _loc3_)
         {
            ++this._numAdded;
         }
         if(this._numAdded > 1)
         {
            param1.currentTarget.removeEventListener(Event.ADDED,this.handleAddedEvent);
            if(this._proLoader.loadDoneCallback(_loc2_))
            {
               if(!this._doneProgressStalling && this._realLI.bytesLoaded >= this._realLI.bytesTotal)
               {
                  this._doneProgressStalling = true;
                  super.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,this._realLI.bytesLoaded,this._realLI.bytesTotal));
               }
               super.dispatchEvent(new Event(Event.INIT,false,false));
               super.dispatchEvent(new Event(Event.COMPLETE,false,false));
            }
         }
      }
      
      internal function set realContentLoaderInfo(param1:LoaderInfo) : void
      {
         var obj:Object = null;
         var value:LoaderInfo = param1;
         this._realContentLI = value;
         this._realContentLI.addEventListener(Event.COMPLETE,this.handleRealContentEvent,false,0,true);
         this._realContentLI.addEventListener(Event.INIT,this.handleRealContentEvent,false,0,true);
         this._realContentLI.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoaderInfoEvent,false,0,true);
         this._realContentLI.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityErrorEvent,false,0,true);
         this._rslPreloaderLoaded = true;
         if(this._realContentLI.hasOwnProperty("childSandboxBridge"))
         {
            try
            {
               obj = this._realLI["childSandboxBridge"];
               if(obj != null)
               {
                  this._realContentLI["childSandboxBridge"] = obj;
               }
            }
            catch(se:SecurityError)
            {
            }
            try
            {
               obj = this._realLI["parentSandboxBridge"];
               if(obj != null)
               {
                  this._realContentLI["parentSandboxBridge"] = obj;
               }
            }
            catch(se:SecurityError)
            {
            }
         }
      }
      
      internal function get realContentLoaderInfo() : LoaderInfo
      {
         return this._realContentLI;
      }
      
      private function handleRealContentEvent(param1:Event) : void
      {
         var d:DisplayObject = null;
         var e:Event = param1;
         if(e.type == Event.INIT)
         {
            try
            {
               d = this._realContentLI.content;
            }
            catch(se:SecurityError)
            {
               d = null;
            }
            this._proLoader.loadDoneCallback(d);
            if(!this._doneProgressStalling && this._realLI.bytesLoaded >= this._realLI.bytesTotal)
            {
               this._doneProgressStalling = true;
               super.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,this._realLI.bytesLoaded,this._realLI.bytesTotal));
            }
         }
         super.dispatchEvent(e);
      }
   }
}
