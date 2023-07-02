package fl.timeline
{
   import fl.timeline.timelineManager.*;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   [ExcludeClass]
   public class TimelineManager
   {
      
      public static const PARENT:int = 3;
      
      public static const PREV:int = 0;
      
      public static const NEXT:int = 1;
      
      private static var _patentIDB1104:String = "AdobePatentID=\"B1104\"";
      
      public static const CHILD:int = 2;
       
      
      protected var initTargetDict:Dictionary;
      
      protected var _supportNextPrevAcrossFrames:Boolean;
      
      protected var containerDict:Dictionary;
      
      protected var targetDict:Dictionary;
      
      protected var _supportParentChildAcrossFrames:Boolean;
      
      public function TimelineManager()
      {
         super();
         this.containerDict = new Dictionary(true);
         this.targetDict = new Dictionary(true);
         this.initTargetDict = new Dictionary(true);
      }
      
      private static function findTarget(ii:InstanceInfo, parent:DisplayObject) : DisplayObject
      {
         var target:DisplayObject = null;
         var btn:SimpleButton = null;
         var container:DisplayObjectContainer = parent as DisplayObjectContainer;
         if(container != null)
         {
            try
            {
               target = container[ii.instanceName];
            }
            catch(e:Error)
            {
               target = null;
            }
            if(target == null)
            {
               target = container.getChildByName(ii.instanceName);
            }
         }
         else
         {
            btn = parent as SimpleButton;
            if(btn != null)
            {
               switch(ii.startFrame)
               {
                  case 0:
                     target = btn.upState;
                     break;
                  case 1:
                     target = btn.overState;
                     break;
                  case 2:
                     target = btn.downState;
               }
               if(ii.endFrame >= 0)
               {
                  try
                  {
                     target = DisplayObjectContainer(target).getChildAt(ii.endFrame);
                  }
                  catch(err:Error)
                  {
                     target = null;
                  }
               }
            }
         }
         return target;
      }
      
      public function initInstance(instance:DisplayObject, parent:DisplayObjectContainer) : void
      {
         var ii:InstanceInfo = null;
         var list:Vector.<InstanceInfo> = null;
         var mc:MovieClip = null;
         var currentFrame:int = 0;
         var i:int = 0;
         var instanceDict:Dictionary = this.containerDict[parent];
         if(instanceDict != null)
         {
            list = instanceDict[instance.name];
            if(list != null)
            {
               mc = parent as MovieClip;
               if(mc == null)
               {
                  ii = list[0];
               }
               else
               {
                  currentFrame = mc.currentFrame - 1;
                  for(i = 0; i < list.length; i++)
                  {
                     ii = list[i];
                     if(mc.currentScene.name == ii.sceneName && ii.startFrame <= currentFrame && currentFrame <= ii.endFrame)
                     {
                        break;
                     }
                     ii = null;
                  }
               }
            }
         }
         if(ii != null)
         {
            if(this.getInstanceForInfo(ii,instance) == null)
            {
               this.initTargetDict[instance] = ii;
               instance.addEventListener(Event.FRAME_CONSTRUCTED,this.handleInit);
               instance.addEventListener(Event.REMOVED,this.handleInitRemoved);
            }
         }
      }
      
      private function fixXnEntry(ii:InstanceInfo, xnII:InstanceInfo, realIIForXn:InstanceInfo) : void
      {
         switch(xnII.type)
         {
            case PREV:
               ii.prev = realIIForXn;
               realIIForXn.realIIForXn = realIIForXn;
               break;
            case NEXT:
               ii.next = realIIForXn;
               realIIForXn.realIIForXn = realIIForXn;
               break;
            case CHILD:
               if(ii.children == null)
               {
                  ii.children = new Vector.<InstanceInfo>(1);
                  ii.children[0] = realIIForXn;
               }
               else
               {
                  ii.children.push(realIIForXn);
               }
               realIIForXn.realIIForXn = realIIForXn;
               break;
            case PARENT:
               ii.parent = realIIForXn;
               realIIForXn.realIIForXn = realIIForXn;
               break;
            default:
               xnII.realIIForXn = realIIForXn;
         }
      }
      
      public function getInstance(container:DisplayObject, instanceName:String, frame:int, sceneName:String = null) : DisplayObject
      {
         var ii:InstanceInfo = null;
         var newTarget:DisplayObject = null;
         var instanceDict:Dictionary = Dictionary(this.containerDict[container]);
         if(instanceDict == null)
         {
            return null;
         }
         var list:Vector.<InstanceInfo> = instanceDict[instanceName];
         if(list == null)
         {
            return null;
         }
         var containerIsBtn:Boolean = container is SimpleButton;
         for(var i:int = 0; i < list.length; i++)
         {
            ii = list[i];
            if(containerIsBtn && ii.startFrame == frame || !containerIsBtn && ii.startFrame <= frame && frame <= ii.endFrame && (sceneName == null || sceneName.length < 1 || sceneName == ii.sceneName))
            {
               newTarget = this.getInstanceForInfoWithXns(ii);
               if(newTarget != null)
               {
                  this.targetDict[newTarget] = ii;
               }
               return newTarget;
            }
         }
         return null;
      }
      
      protected function getInstanceForInfo(ii:InstanceInfo, instance:DisplayObject = null) : DisplayObject
      {
         return null;
      }
      
      public function addInstance(container:DisplayObject, instanceName:String, bounds:Rectangle, data:XML, xns:Array, extraInfo:* = undefined, startFrame:int = 0, endFrame:int = 0, sceneName:String = null, cacheInDict:Boolean = true, processImmediately:Boolean = false) : void
      {
         var instance:DisplayObject = null;
         var added:Boolean = false;
         var i:int = 0;
         var compII:InstanceInfo = null;
         var ii:InstanceInfo = new InstanceInfo(container,instanceName,startFrame,endFrame,-1,bounds,data,xns == null ? null : Vector.<InstanceInfo>(xns),extraInfo,sceneName);
         if(processImmediately)
         {
            instance = findTarget(ii,ii.container);
            if(this.getInstanceForInfo(ii,instance) == null)
            {
               this.initTargetDict[instance] = ii;
               instance.addEventListener(Event.FRAME_CONSTRUCTED,this.handleInit);
               instance.addEventListener(Event.REMOVED,this.handleInitRemoved);
            }
         }
         if(!cacheInDict)
         {
            return;
         }
         var instanceDict:Dictionary = this.containerDict[container];
         if(!instanceDict)
         {
            instanceDict = new Dictionary();
            this.containerDict[container] = instanceDict;
         }
         var list:Vector.<InstanceInfo> = instanceDict[instanceName];
         if(list == null)
         {
            list = new Vector.<InstanceInfo>(1);
            list[0] = ii;
            instanceDict[instanceName] = list;
         }
         else if(container is SimpleButton)
         {
            list.push(ii);
         }
         else
         {
            added = false;
            i = 0;
            while(i < list.length)
            {
               compII = list[i];
               if(sceneName != null && sceneName.length > 0 && compII.sceneName != sceneName)
               {
                  i++;
               }
               else
               {
                  if(compII.startFrame > startFrame)
                  {
                     list.splice(i,0,ii);
                     added = true;
                     i++;
                     while(i < list.length)
                     {
                        compII = list[i];
                        if(endFrame < compII.startFrame)
                        {
                           break;
                        }
                        list.splice(i,1);
                     }
                     break;
                  }
                  if(compII.endFrame >= startFrame)
                  {
                     list.splice(i,1);
                  }
                  else
                  {
                     i++;
                  }
               }
            }
            if(!added)
            {
               list.push(ii);
            }
         }
      }
      
      protected function handleInit(e:Event) : void
      {
         var ii:InstanceInfo = this.initTargetDict[e.target];
         if(ii == null || this.getInstanceForInfo(ii,DisplayObject(e.target)) != null)
         {
            delete this.initTargetDict[e.target];
            this.handleInitRemoved(e);
         }
      }
      
      protected function removeXn(content:DisplayObject, ii:InstanceInfo, type:int) : void
      {
      }
      
      public function isTargetForFrame(target:DisplayObject, frame:int, sceneName:String = null) : Boolean
      {
         var ii:InstanceInfo = this.targetDict[target];
         if(ii == null)
         {
            return false;
         }
         return ii.startFrame <= frame && frame <= ii.endFrame && (sceneName == null || sceneName.length < 1 || sceneName == ii.sceneName) && (target.parent == null || target.parent == ii.container);
      }
      
      protected function handleInitRemoved(e:Event) : void
      {
         e.target.removeEventListener(Event.REMOVED,this.handleInitRemoved);
         e.target.removeEventListener(Event.FRAME_CONSTRUCTED,this.handleInit);
      }
      
      protected function getInstanceForInfoWithXns(ii:InstanceInfo) : DisplayObject
      {
         var content:DisplayObject = null;
         var currentII:InstanceInfo = null;
         var prevII:InstanceInfo = null;
         var len:int = 0;
         var i:int = 0;
         var childII:InstanceInfo = null;
         if(ii.content != null)
         {
            content = ii.content;
            if(this._supportNextPrevAcrossFrames && ii.next != null && ii.next.content == null)
            {
               ii.next.content = this.getInstanceForInfo(ii.next);
            }
         }
         else if(!this._supportNextPrevAcrossFrames || ii.prev == null && ii.next == null)
         {
            ii.content = this.getInstanceForInfo(ii);
         }
         else
         {
            currentII = ii;
            while(currentII.prev != null)
            {
               currentII = currentII.prev;
            }
            while(currentII != null && currentII != ii)
            {
               if(currentII.content == null)
               {
                  currentII.content = this.getInstanceForInfo(currentII);
               }
               if(prevII != null && prevII.content != null && currentII.content != null)
               {
                  this.addXn(prevII.content,currentII.content,currentII,TimelineManager.NEXT);
                  this.addXn(currentII.content,prevII.content,prevII,TimelineManager.PREV);
               }
               prevII = currentII;
               currentII = currentII.next;
            }
            if(currentII != ii)
            {
               prevII = null;
            }
            ii.content = this.getInstanceForInfo(ii);
            if(ii.content != null)
            {
               if(prevII != null && prevII.content != null)
               {
                  this.addXn(prevII.content,ii.content,ii,TimelineManager.NEXT);
                  this.addXn(ii.content,prevII.content,prevII,TimelineManager.PREV);
               }
               if(ii.next != null)
               {
                  if(ii.next.content == null)
                  {
                     ii.next.content = this.getInstanceForInfo(ii.next);
                  }
                  if(ii.next.content != null)
                  {
                     this.addXn(ii.content,ii.next.content,ii.next,TimelineManager.NEXT);
                     this.addXn(ii.next.content,ii.content,ii,TimelineManager.PREV);
                  }
               }
            }
         }
         if(this._supportParentChildAcrossFrames && ii.children != null)
         {
            len = int(ii.children.length);
            for(i = 0; i < len; i++)
            {
               childII = ii.children[i];
               if(childII.content == null)
               {
                  childII.content = this.getInstanceForInfo(childII);
               }
               if(childII.content != null)
               {
                  this.addXn(ii.content,childII.content,childII,TimelineManager.CHILD);
                  this.addXn(childII.content,ii.content,ii,TimelineManager.PARENT);
               }
            }
         }
         if(this._supportParentChildAcrossFrames && ii.parent != null)
         {
            if(ii.parent.content == null)
            {
               ii.parent.content = this.getInstanceForInfo(ii.parent);
            }
            if(Boolean(ii.parent.content))
            {
               this.addXn(ii.content,ii.parent.content,ii.parent,TimelineManager.PARENT);
               this.addXn(ii.parent.content,ii.content,ii,TimelineManager.CHILD);
            }
         }
         if(!this._supportNextPrevAcrossFrames && (ii.next != null || ii.prev != null) || !this._supportParentChildAcrossFrames && (ii.children != null || ii.parent != null) || ii.xns != null && ii.xns.length > 0)
         {
            if(content != null)
            {
               this.handleXns(content,ii);
            }
            ii.content.addEventListener(Event.FRAME_CONSTRUCTED,this.handleXns);
            if(ii.container is MovieClip)
            {
               ii.content.addEventListener(Event.REMOVED,this.handleRemoved,false,1);
            }
         }
         if(content == null)
         {
            content = ii.content;
         }
         if((!this._supportNextPrevAcrossFrames || ii.next == null && ii.prev == null) && (!this._supportParentChildAcrossFrames || ii.parent == null && ii.children == null))
         {
            ii.content = null;
         }
         return content;
      }
      
      public function addInstanceComplete(container:DisplayObject) : void
      {
         var moreAdded:Boolean = false;
         var list:* = undefined;
         var i:* = undefined;
         var ii:* = undefined;
         var xnList:* = undefined;
         var j:* = undefined;
         var xnII:* = undefined;
         var realIIForXnList:* = undefined;
         var k:* = undefined;
         var realIIForXn:* = undefined;
         var instanceDict:Dictionary = this.containerDict[container];
         if(instanceDict == null)
         {
            return;
         }
         var containerIsBtn:Boolean = container is SimpleButton;
         var handledDict:Dictionary = new Dictionary();
         do
         {
            moreAdded = false;
            for each(list in instanceDict)
            {
               for(i = 0; i < list.length; i++)
               {
                  ii = list[i];
                  if(handledDict[ii] == undefined)
                  {
                     handledDict[ii] = true;
                     if(ii.xns != null)
                     {
                        xnList = ii.xns;
                        for(j = 0; j < xnList.length; j++)
                        {
                           xnII = xnList[j];
                           if(xnII.type >= PREV && xnII.type <= PARENT)
                           {
                              xnList.splice(j,1);
                              j--;
                           }
                           realIIForXnList = instanceDict[xnII.instanceName];
                           if(realIIForXnList != null)
                           {
                              for(k = 0; k < realIIForXnList.length; k++)
                              {
                                 realIIForXn = realIIForXnList[k];
                                 if(containerIsBtn)
                                 {
                                    if(ii.startFrame == realIIForXn.startFrame)
                                    {
                                       this.fixXnEntry(ii,xnII,realIIForXn);
                                       break;
                                    }
                                 }
                                 else if(realIIForXn.startFrame == xnII.startFrame && realIIForXn.endFrame == xnII.endFrame && (ii.sceneName == null || ii.sceneName.length < 1 || realIIForXn.sceneName == ii.sceneName))
                                 {
                                    this.fixXnEntry(ii,xnII,realIIForXn);
                                    break;
                                 }
                              }
                              if(containerIsBtn && k >= realIIForXnList.length)
                              {
                                 realIIForXn = realIIForXnList[0].clone();
                                 realIIForXn.startFrame = ii.startFrame;
                                 realIIForXnList.push(realIIForXn);
                                 moreAdded = true;
                                 this.fixXnEntry(ii,xnII,realIIForXn);
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         while(moreAdded);
         
      }
      
      protected function handleRemoved(e:Event) : void
      {
         e.target.removeEventListener(Event.REMOVED,this.handleRemoved);
         e.target.removeEventListener(Event.FRAME_CONSTRUCTED,this.handleXns);
      }
      
      protected function handleXns(e:Object, ii:InstanceInfo = null) : void
      {
         var content:DisplayObject = null;
         var xnII:InstanceInfo = null;
         var len:int = 0;
         var j:int = 0;
         var childII:InstanceInfo = null;
         var isEvent:Boolean = ii == null;
         if(isEvent)
         {
            content = e.target as DisplayObject;
            ii = this.targetDict[content];
            if(ii == null)
            {
               return;
            }
         }
         else
         {
            content = e as DisplayObject;
         }
         if(content == null)
         {
            return;
         }
         var mc:MovieClip = ii.container as MovieClip;
         var isSprite:Boolean = mc == null;
         var currentFrame:int = isSprite ? 0 : mc.currentFrame - 1;
         if(!isSprite && mc.scenes.length > 1 && ii.sceneName != null && ii.sceneName.length > 0 && mc.currentScene.name != ii.sceneName)
         {
            return;
         }
         if(isSprite && isEvent)
         {
            content.removeEventListener(Event.FRAME_CONSTRUCTED,this.handleXns);
         }
         for(var i:int = 0; i < ii.xns.length; i++)
         {
            xnII = ii.xns[i];
            this.handleXn(content,ii,xnII,xnII.type,currentFrame,isSprite);
         }
         if(!this._supportNextPrevAcrossFrames)
         {
            if(ii.prev != null)
            {
               this.handleXn(content,ii,ii.prev,TimelineManager.PREV,currentFrame,isSprite);
            }
            if(ii.next != null)
            {
               this.handleXn(content,ii,ii.next,TimelineManager.NEXT,currentFrame,isSprite);
            }
         }
         if(!this._supportParentChildAcrossFrames)
         {
            if(ii.parent != null)
            {
               this.handleXn(content,ii,ii.parent,TimelineManager.PARENT,currentFrame,isSprite);
            }
            if(ii.children != null)
            {
               len = int(ii.children.length);
               for(j = 0; j < len; j++)
               {
                  childII = ii.children[j];
                  this.handleXn(content,ii,childII,TimelineManager.CHILD,currentFrame,isSprite);
               }
            }
         }
      }
      
      protected function addXn(content:DisplayObject, target:DisplayObject, ii:InstanceInfo, type:int) : void
      {
      }
      
      protected function handleXn(content:DisplayObject, ii:InstanceInfo, xnII:InstanceInfo, type:int, currentFrame:int, isSprite:Boolean) : void
      {
         var target:DisplayObject = null;
         if(isSprite || xnII.startFrame <= currentFrame && currentFrame <= xnII.endFrame)
         {
            target = findTarget(xnII,ii.container);
            if(target == null && xnII.realIIForXn != null)
            {
               target = xnII.content = this.getInstanceForInfoWithXns(xnII.realIIForXn);
            }
            if(target != null)
            {
               this.addXn(content,target,xnII,type);
            }
         }
         else
         {
            this.removeXn(content,xnII,type);
         }
      }
   }
}
