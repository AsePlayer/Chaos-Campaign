package fl.timeline.timelineManager
{
   import fl.timeline.TimelineManager;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   [ExcludeClass]
   public class InstanceInfo
   {
       
      
      public var container:DisplayObject;
      
      public var instanceName:String;
      
      public var content:DisplayObject;
      
      public var type:int;
      
      public var prev:InstanceInfo;
      
      public var realIIForXn:InstanceInfo;
      
      public var endFrame:int;
      
      public var extraInfo;
      
      public var data:XML;
      
      public var startFrame:int;
      
      public var next:InstanceInfo;
      
      public var bounds:Rectangle;
      
      public var sceneName:String;
      
      public var parent:InstanceInfo;
      
      public var xns:Vector.<InstanceInfo>;
      
      public var children:Vector.<InstanceInfo>;
      
      public function InstanceInfo(container:DisplayObject, instanceName:String, startFrame:int, endFrame:int, type:int, bounds:Rectangle = null, data:XML = null, xns:Vector.<InstanceInfo> = null, extraInfo:* = undefined, sceneName:String = null)
      {
         super();
         this.container = container;
         this.instanceName = instanceName;
         this.bounds = bounds;
         this.data = data;
         this.startFrame = startFrame;
         this.endFrame = endFrame;
         this.type = type;
         this.xns = xns;
         this.extraInfo = extraInfo;
         this.sceneName = sceneName;
      }
      
      public function clone() : InstanceInfo
      {
         var ii:InstanceInfo = null;
         var i:int = 0;
         var newXns:Vector.<InstanceInfo> = new Vector.<InstanceInfo>();
         for(i = 0; i < this.xns.length; i++)
         {
            ii = this.xns[i];
            newXns.push(new InstanceInfo(ii.container,ii.instanceName,ii.startFrame,ii.endFrame,ii.type));
         }
         if(this.prev != null)
         {
            newXns.push(new InstanceInfo(this.prev.container,this.prev.instanceName,this.prev.startFrame,this.prev.endFrame,TimelineManager.PREV));
         }
         if(this.next != null)
         {
            newXns.push(new InstanceInfo(this.next.container,this.next.instanceName,this.next.startFrame,this.next.endFrame,TimelineManager.NEXT));
         }
         if(this.parent != null)
         {
            newXns.push(new InstanceInfo(this.parent.container,this.parent.instanceName,this.parent.startFrame,this.parent.endFrame,TimelineManager.PARENT));
         }
         if(this.children != null)
         {
            for(i = 0; i < this.children.length; i++)
            {
               ii = this.children[i];
               newXns.push(new InstanceInfo(ii.container,ii.instanceName,ii.startFrame,ii.endFrame,TimelineManager.CHILD));
            }
         }
         return new InstanceInfo(this.container,this.instanceName,this.startFrame,this.endFrame,this.type,new Rectangle(this.bounds.x,this.bounds.y,this.bounds.width,this.bounds.height),this.data.copy(),newXns,this.extraInfo,this.sceneName);
      }
   }
}
