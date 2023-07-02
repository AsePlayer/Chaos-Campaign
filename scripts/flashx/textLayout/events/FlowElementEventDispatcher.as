package flashx.textLayout.events
{
   import flash.events.EventDispatcher;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.tlf_internal;
   
   [ExcludeClass]
   public class FlowElementEventDispatcher extends EventDispatcher
   {
       
      
      tlf_internal var _listenerCount:int = 0;
      
      tlf_internal var _element:FlowElement;
      
      public function FlowElementEventDispatcher(element:FlowElement)
      {
         this.tlf_internal::_element = element;
         super(null);
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var tf:TextFlow = null;
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         ++this.tlf_internal::_listenerCount;
         if(this.tlf_internal::_listenerCount == 1)
         {
            tf = this.tlf_internal::_element.getTextFlow();
            if(Boolean(tf))
            {
               tf.tlf_internal::incInteractiveObjectCount();
            }
         }
         this.tlf_internal::_element.tlf_internal::modelChanged(ModelChange.ELEMENT_MODIFIED,this.tlf_internal::_element,0,this.tlf_internal::_element.textLength);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         var tf:TextFlow = null;
         super.removeEventListener(type,listener,useCapture);
         --this.tlf_internal::_listenerCount;
         if(this.tlf_internal::_listenerCount == 0)
         {
            tf = this.tlf_internal::_element.getTextFlow();
            if(Boolean(tf))
            {
               tf.tlf_internal::decInteractiveObjectCount();
            }
         }
         this.tlf_internal::_element.tlf_internal::modelChanged(ModelChange.ELEMENT_MODIFIED,this.tlf_internal::_element,0,this.tlf_internal::_element.textLength);
      }
   }
}
