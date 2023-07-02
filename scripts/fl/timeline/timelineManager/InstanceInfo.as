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
      
      public var prev:fl.timeline.timelineManager.InstanceInfo;
      
      public var realIIForXn:fl.timeline.timelineManager.InstanceInfo;
      
      public var endFrame:int;
      
      public var extraInfo;
      
      public var data:XML;
      
      public var startFrame:int;
      
      public var next:fl.timeline.timelineManager.InstanceInfo;
      
      public var bounds:Rectangle;
      
      public var sceneName:String;
      
      public var parent:fl.timeline.timelineManager.InstanceInfo;
      
      public var xns:Vector.<fl.timeline.timelineManager.InstanceInfo>;
      
      public var children:Vector.<fl.timeline.timelineManager.InstanceInfo>;
      
      public function InstanceInfo(container:DisplayObject, instanceName:String, startFrame:int, endFrame:int, type:int, bounds:Rectangle = null, data:XML = null, xns:Vector.<fl.timeline.timelineManager.InstanceInfo> = null, extraInfo:* = undefined, sceneName:String = null)
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
      
      public function clone() : fl.timeline.timelineManager.InstanceInfo
      {
         var ii:fl.timeline.timelineManager.InstanceInfo = null;
         var i:int = 0;
         var newXns:Vector.<fl.timeline.timelineManager.InstanceInfo> = new Vector.<InstanceInfo>();
         for(i = 0; i < this.xns.length; i++)
         {
            ii = this.xns[i];
            newXns.push(new fl.timeline.timelineManager.InstanceInfo(ii.container,ii.instanceName,ii.startFrame,ii.endFrame,ii.type));
         }
         if(this.prev != null)
         {
            newXns.push(new fl.timeline.timelineManager.InstanceInfo(this.prev.container,this.prev.instanceName,this.prev.startFrame,this.prev.endFrame,TimelineManager.PREV));
         }
         if(this.next != null)
         {
            newXns.push(new fl.timeline.timelineManager.InstanceInfo(this.next.container,this.next.instanceName,this.next.startFrame,this.next.endFrame,TimelineManager.NEXT));
         }
         if(this.parent != null)
         {
            newXns.push(new fl.timeline.timelineManager.InstanceInfo(this.parent.container,this.parent.instanceName,this.parent.startFrame,this.parent.endFrame,TimelineManager.PARENT));
         }
         if(this.children != null)
         {
            for(i = 0; i < this.children.length; i++)
            {
               ii = this.children[i];
               newXns.push(new fl.timeline.timelineManager.InstanceInfo(ii.container,ii.instanceName,ii.startFrame,ii.endFrame,TimelineManager.CHILD));
            }
         }
         return new fl.timeline.timelineManager.InstanceInfo(this.container,this.instanceName,this.startFrame,this.endFrame,this.type,new Rectangle(this.bounds.x,this.bounds.y,this.bounds.width,this.bounds.height),this.data.copy(),newXns,this.extraInfo,this.sceneName);
      }
   }
}
