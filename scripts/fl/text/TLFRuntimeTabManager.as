package fl.text
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.elements.TextFlow;
   
   public class TLFRuntimeTabManager
   {
      
      private static var sTabHandlerInited:Boolean = false;
       
      
      public function TLFRuntimeTabManager()
      {
         super();
      }
      
      private static function onKeyFocusChange(e:FocusEvent) : void
      {
         var obj:InteractiveObject = null;
         var sm:SelectionManager = null;
         var field:Object = null;
         var textFlow:TextFlow = null;
         var controller:ContainerController = null;
         if(Boolean(e.relatedObject))
         {
            obj = e.relatedObject;
            if(obj.parent.hasOwnProperty("textFlow"))
            {
               field = obj.parent;
               textFlow = field["textFlow"];
               if(textFlow != null && textFlow.interactionManager != null)
               {
                  sm = textFlow.interactionManager as SelectionManager;
                  if(textFlow.flowComposer.numControllers == 1)
                  {
                     textFlow.flowComposer.updateAllControllers();
                     sm.selectAll();
                  }
                  else
                  {
                     controller = field["controller"];
                     sm.selectRange(controller.absoluteStart,controller.absoluteStart + controller.textLength);
                  }
               }
            }
            else if(obj.parent.hasOwnProperty("tcm"))
            {
               sm = obj.parent["tcm"].beginInteraction() as SelectionManager;
               sm.selectAll();
            }
         }
      }
      
      private static function onAddedToStage(e:Event) : void
      {
         var displayObject:DisplayObject = e.target as DisplayObject;
         if(Boolean(displayObject))
         {
            displayObject.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
            if(!sTabHandlerInited)
            {
               displayObject.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onKeyFocusChange);
               sTabHandlerInited = true;
            }
         }
      }
      
      public static function InitTabHandler(inDisplayObject:DisplayObject) : void
      {
         if(!sTabHandlerInited)
         {
            if(Boolean(inDisplayObject.stage))
            {
               inDisplayObject.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onKeyFocusChange);
               sTabHandlerInited = true;
            }
            else
            {
               inDisplayObject.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
            }
         }
      }
   }
}
