package flashx.textLayout.edit
{
   import flash.display.DisplayObjectContainer;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IMEEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.system.Capabilities;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.DivElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ListElement;
   import flashx.textLayout.elements.ListItemElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SubParagraphGroupElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.operations.ApplyElementIDOperation;
   import flashx.textLayout.operations.ApplyElementTypeNameOperation;
   import flashx.textLayout.operations.ApplyFormatOperation;
   import flashx.textLayout.operations.ApplyFormatToElementOperation;
   import flashx.textLayout.operations.ApplyLinkOperation;
   import flashx.textLayout.operations.ApplyTCYOperation;
   import flashx.textLayout.operations.ClearFormatOnElementOperation;
   import flashx.textLayout.operations.ClearFormatOperation;
   import flashx.textLayout.operations.CompositeOperation;
   import flashx.textLayout.operations.CreateDivOperation;
   import flashx.textLayout.operations.CreateListOperation;
   import flashx.textLayout.operations.CreateSubParagraphGroupOperation;
   import flashx.textLayout.operations.CutOperation;
   import flashx.textLayout.operations.DeleteTextOperation;
   import flashx.textLayout.operations.FlowOperation;
   import flashx.textLayout.operations.InsertInlineGraphicOperation;
   import flashx.textLayout.operations.InsertTextOperation;
   import flashx.textLayout.operations.ModifyInlineGraphicOperation;
   import flashx.textLayout.operations.MoveChildrenOperation;
   import flashx.textLayout.operations.PasteOperation;
   import flashx.textLayout.operations.RedoOperation;
   import flashx.textLayout.operations.SplitElementOperation;
   import flashx.textLayout.operations.SplitParagraphOperation;
   import flashx.textLayout.operations.UndoOperation;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.CharacterUtil;
   import flashx.textLayout.utils.NavigationUtil;
   import flashx.undo.IOperation;
   import flashx.undo.IUndoManager;
   
   public class EditManager extends SelectionManager implements IEditManager
   {
      
      public static var overwriteMode:Boolean = false;
       
      
      private var pendingInsert:InsertTextOperation;
      
      private var enterFrameListener:DisplayObjectContainer;
      
      private var _delayUpdates:Boolean = false;
      
      private var _allowDelayedOperations:Boolean = true;
      
      private var redrawListener:DisplayObjectContainer;
      
      private var _undoManager:IUndoManager;
      
      private var _imeSession:IMEClient;
      
      private var _imeOperationInProgress:Boolean;
      
      tlf_internal var captureLevel:int = 0;
      
      private var captureOperations:Array;
      
      private var parentStack:Array;
      
      public function EditManager(undoManager:IUndoManager = null)
      {
         this.captureOperations = [];
         super();
         this._undoManager = undoManager;
      }
      
      public function get undoManager() : IUndoManager
      {
         return this._undoManager;
      }
      
      tlf_internal function setUndoManager(undoManager:IUndoManager) : void
      {
         this._undoManager = undoManager;
      }
      
      override public function editHandler(event:Event) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         super.editHandler(event);
         switch(event.type)
         {
            case Event.CUT:
            case Event.CLEAR:
               if(activePosition != anchorPosition)
               {
                  if(event.type == Event.CUT)
                  {
                     TextClipboard.setContents(this.cutTextScrap());
                  }
                  else
                  {
                     this.deleteText(null);
                  }
                  event.preventDefault();
               }
               break;
            case Event.PASTE:
               this.pasteTextScrap(TextClipboard.getContents());
               event.preventDefault();
         }
      }
      
      override public function keyDownHandler(event:KeyboardEvent) : void
      {
         var listItem:ListItemElement = null;
         var operationState:SelectionState = null;
         var discretionaryHyphenString:String = null;
         var firstLeaf:FlowLeafElement = null;
         var source:FlowGroupElement = null;
         var target:FlowGroupElement = null;
         var numElements:int = 0;
         var sourceIndex:int = 0;
         var targetIndex:int = 0;
         var element:FlowGroupElement = null;
         if(!hasSelection() || event.isDefaultPrevented())
         {
            return;
         }
         if(Boolean(this.redrawListener))
         {
            this.updateAllControllers();
         }
         super.keyDownHandler(event);
         if(event.ctrlKey)
         {
            if(!event.altKey)
            {
               if(this._imeSession != null && (event.charCode == 122 || event.charCode == 121))
               {
                  this._imeSession.compositionAbandoned();
               }
               switch(event.charCode)
               {
                  case 122:
                     if(!Configuration.tlf_internal::versionIsAtLeast(10,1) && Capabilities.os.search("Mac OS") > -1)
                     {
                        ignoreNextTextEvent = true;
                     }
                     this.undo();
                     event.preventDefault();
                     break;
                  case 121:
                     ignoreNextTextEvent = true;
                     this.redo();
                     event.preventDefault();
                     break;
                  case Keyboard.BACKSPACE:
                     if(Boolean(this._imeSession))
                     {
                        this._imeSession.compositionAbandoned();
                     }
                     this.deletePreviousWord();
                     event.preventDefault();
               }
               if(event.keyCode == Keyboard.DELETE)
               {
                  if(Boolean(this._imeSession))
                  {
                     this._imeSession.compositionAbandoned();
                  }
                  this.deleteNextWord();
                  event.preventDefault();
               }
               if(event.shiftKey)
               {
                  if(event.charCode == 95)
                  {
                     if(Boolean(this._imeSession))
                     {
                        this._imeSession.compositionAbandoned();
                     }
                     discretionaryHyphenString = String.fromCharCode(173);
                     if(overwriteMode)
                     {
                        this.overwriteText(discretionaryHyphenString);
                     }
                     else
                     {
                        this.insertText(discretionaryHyphenString);
                     }
                     event.preventDefault();
                  }
               }
            }
         }
         else if(event.altKey)
         {
            if(event.charCode == Keyboard.BACKSPACE)
            {
               this.deletePreviousWord();
               event.preventDefault();
            }
            else if(event.keyCode == Keyboard.DELETE)
            {
               this.deleteNextWord();
               event.preventDefault();
            }
         }
         else if(event.keyCode == Keyboard.DELETE)
         {
            this.deleteNextCharacter();
            event.preventDefault();
         }
         else if(event.keyCode == Keyboard.INSERT)
         {
            overwriteMode = !overwriteMode;
            event.preventDefault();
         }
         else
         {
            switch(event.charCode)
            {
               case Keyboard.BACKSPACE:
                  this.deletePreviousCharacter();
                  event.preventDefault();
                  break;
               case Keyboard.ENTER:
                  if(textFlow.configuration.manageEnterKey)
                  {
                     firstLeaf = textFlow.findLeaf(absoluteStart);
                     listItem = firstLeaf.getParentByType(ListItemElement) as ListItemElement;
                     if(Boolean(listItem) && firstLeaf.getParentByType(ListElement) != listItem.getParentByType(ListElement))
                     {
                        listItem = null;
                     }
                     if(Boolean(listItem) && !event.shiftKey)
                     {
                        if(listItem.textLength == 1 && listItem.parent.getChildIndex(listItem) == listItem.parent.numChildren - 1)
                        {
                           operationState = this.tlf_internal::defaultOperationState();
                           if(!operationState)
                           {
                              return;
                           }
                           this.doOperation(new MoveChildrenOperation(operationState,listItem.parent,listItem.parent.getChildIndex(listItem),1,listItem.parent.parent,listItem.parent.parent.getChildIndex(listItem.parent) + 1));
                        }
                        else
                        {
                           this.splitElement(listItem);
                           selectRange(absoluteStart + 1,absoluteStart + 1);
                           refreshSelection();
                        }
                     }
                     else
                     {
                        this.splitParagraph();
                     }
                     event.preventDefault();
                     event.stopImmediatePropagation();
                  }
                  break;
               case Keyboard.TAB:
                  if(textFlow.configuration.manageTabKey)
                  {
                     listItem = textFlow.findLeaf(absoluteStart).getParentByType(ListItemElement) as ListItemElement;
                     if(Boolean(listItem) && listItem.getAbsoluteStart() == absoluteStart)
                     {
                        operationState = this.tlf_internal::defaultOperationState();
                        if(!operationState)
                        {
                           return;
                        }
                        if(event.shiftKey)
                        {
                           if(listItem.parent.parent is ListElement && listItem.parent.getChildIndex(listItem) == 0)
                           {
                              source = listItem.parent;
                              target = listItem.parent.parent;
                              numElements = listItem.parent.numChildren;
                              sourceIndex = 0;
                              targetIndex = listItem.parent.parent.getChildIndex(listItem.parent);
                              this.doOperation(new MoveChildrenOperation(operationState,source,sourceIndex,numElements,target,targetIndex));
                           }
                        }
                        else
                        {
                           element = listItem;
                           if(listItem.parent.getChildIndex(listItem) == 0)
                           {
                              element = listItem.parent;
                           }
                           this.doOperation(new CreateListOperation(new SelectionState(textFlow,element.getAbsoluteStart(),element.getAbsoluteStart() + element.textLength),listItem.parent));
                        }
                     }
                     else if(overwriteMode)
                     {
                        this.overwriteText(String.fromCharCode(event.charCode));
                     }
                     else
                     {
                        this.insertText(String.fromCharCode(event.charCode));
                     }
                     event.preventDefault();
                  }
            }
         }
      }
      
      override public function keyUpHandler(event:KeyboardEvent) : void
      {
         if(!hasSelection() || event.isDefaultPrevented())
         {
            return;
         }
         super.keyUpHandler(event);
         if(Boolean(textFlow.configuration.manageEnterKey) && event.charCode == Keyboard.ENTER || Boolean(textFlow.configuration.manageTabKey) && event.charCode == Keyboard.TAB)
         {
            event.stopImmediatePropagation();
         }
      }
      
      override public function keyFocusChangeHandler(event:FocusEvent) : void
      {
         if(textFlow.configuration.manageTabKey)
         {
            event.preventDefault();
         }
      }
      
      override public function mouseDownHandler(event:MouseEvent) : void
      {
         if(Boolean(this.redrawListener))
         {
            this.updateAllControllers();
         }
         super.mouseDownHandler(event);
      }
      
      override public function textInputHandler(event:TextEvent) : void
      {
         var charCode:int = 0;
         if(!ignoreNextTextEvent)
         {
            charCode = event.text.charCodeAt(0);
            if(charCode >= 32)
            {
               if(overwriteMode)
               {
                  this.overwriteText(event.text);
               }
               else
               {
                  this.insertText(event.text);
               }
            }
         }
         ignoreNextTextEvent = false;
      }
      
      override public function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(Boolean(this._imeSession) && tlf_internal::selectionFormatState != SelectionFormatState.FOCUSED)
         {
            this._imeSession.compositionAbandoned();
         }
      }
      
      override public function deactivateHandler(event:Event) : void
      {
         super.deactivateHandler(event);
         if(Boolean(this._imeSession))
         {
            this._imeSession.compositionAbandoned();
         }
      }
      
      override public function imeStartCompositionHandler(event:IMEEvent) : void
      {
         this.flushPendingOperations();
         if(!event["imeClient"])
         {
            this._imeSession = new IMEClient(this);
            this._imeOperationInProgress = false;
            event["imeClient"] = this._imeSession;
         }
      }
      
      override public function setFocus() : void
      {
         var flowComposer:IFlowComposer = Boolean(textFlow) ? textFlow.flowComposer : null;
         if(this._imeSession && flowComposer && flowComposer.numControllers > 1)
         {
            this._imeSession.setFocus();
            tlf_internal::setSelectionFormatState(SelectionFormatState.FOCUSED);
         }
         else
         {
            super.setFocus();
         }
      }
      
      tlf_internal function endIMESession() : void
      {
         this._imeSession = null;
         var flowComposer:IFlowComposer = Boolean(textFlow) ? textFlow.flowComposer : null;
         if(Boolean(flowComposer) && flowComposer.numControllers > 1)
         {
            this.setFocus();
         }
      }
      
      tlf_internal function beginIMEOperation() : void
      {
         this._imeOperationInProgress = true;
         this.beginCompositeOperation();
      }
      
      tlf_internal function endIMEOperation() : void
      {
         this.endCompositeOperation();
         this._imeOperationInProgress = false;
      }
      
      override public function doOperation(operation:FlowOperation) : void
      {
         if(Boolean(this._imeSession) && !this._imeOperationInProgress)
         {
            this._imeSession.compositionAbandoned();
         }
         this.flushPendingOperations();
         try
         {
            ++this.tlf_internal::captureLevel;
            operation = this.doInternal(operation);
         }
         catch(e:Error)
         {
            --tlf_internal::captureLevel;
            throw e;
         }
         --this.tlf_internal::captureLevel;
         if(Boolean(operation))
         {
            this.finalizeDo(operation);
         }
      }
      
      private function finalizeDo(op:FlowOperation) : void
      {
         var parentOperation:CompositeOperation = null;
         var parent:Object = null;
         var lastOp:FlowOperation = null;
         var combinedOp:FlowOperation = null;
         var opEvent:FlowOperationEvent = null;
         if(Boolean(this.parentStack) && this.parentStack.length > 0)
         {
            parent = this.parentStack[this.parentStack.length - 1];
            if(parent.captureLevel == this.tlf_internal::captureLevel)
            {
               parentOperation = parent.operation as CompositeOperation;
            }
         }
         if(Boolean(parentOperation))
         {
            parentOperation.addOperation(op);
         }
         else if(this.tlf_internal::captureLevel == 0)
         {
            this.captureOperations.length = 0;
            if(Boolean(this._undoManager))
            {
               if(Boolean(this._undoManager.canUndo()) && allowOperationMerge)
               {
                  lastOp = this._undoManager.peekUndo() as FlowOperation;
                  if(Boolean(lastOp))
                  {
                     combinedOp = lastOp.tlf_internal::merge(op);
                     if(Boolean(combinedOp))
                     {
                        this._undoManager.popUndo();
                        op = combinedOp;
                     }
                  }
               }
               if(op.canUndo())
               {
                  this._undoManager.pushUndo(op);
               }
               allowOperationMerge = true;
               this._undoManager.clearRedo();
            }
            this.handleUpdate();
            if(!this._imeSession)
            {
               opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_COMPLETE,false,false,op,0,null);
               textFlow.dispatchEvent(opEvent);
            }
         }
      }
      
      private function doInternal(op:FlowOperation) : FlowOperation
      {
         var opError:Error;
         var opEvent:FlowOperationEvent = null;
         var beforeGeneration:uint = 0;
         var index:int = 0;
         var captureStart:int = int(this.captureOperations.length);
         var success:Boolean = false;
         if(!this._imeSession)
         {
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_BEGIN,false,true,op,this.tlf_internal::captureLevel - 1,null);
            textFlow.dispatchEvent(opEvent);
            if(opEvent.isDefaultPrevented())
            {
               return null;
            }
            op = opEvent.operation;
            if(op is UndoOperation || op is RedoOperation)
            {
               throw new IllegalOperationError(GlobalSettings.resourceStringFunction("illegalOperation",[getQualifiedClassName(op)]));
            }
         }
         opError = null;
         try
         {
            beforeGeneration = textFlow.generation;
            op.tlf_internal::setGenerations(beforeGeneration,0);
            this.captureOperations.push(op);
            success = op.doOperation();
            if(success)
            {
               textFlow.tlf_internal::normalize();
               op.tlf_internal::setGenerations(beforeGeneration,textFlow.generation);
            }
            else
            {
               index = this.captureOperations.indexOf(op);
               if(index >= 0)
               {
                  this.captureOperations.splice(index,1);
               }
            }
         }
         catch(e:Error)
         {
            opError = e;
         }
         if(!this._imeSession)
         {
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_END,false,true,op,this.tlf_internal::captureLevel - 1,opError);
            textFlow.dispatchEvent(opEvent);
            opError = opEvent.isDefaultPrevented() ? null : opEvent.error;
         }
         if(Boolean(opError))
         {
            throw opError;
         }
         if(this.captureOperations.length - captureStart > 1)
         {
            op = new CompositeOperation(this.captureOperations.slice(captureStart));
            op.tlf_internal::setGenerations(FlowOperation(CompositeOperation(op).operations[0]).beginGeneration,textFlow.generation);
            allowOperationMerge = false;
            this.captureOperations.length = captureStart;
         }
         return success ? op : null;
      }
      
      override public function set textFlow(value:TextFlow) : void
      {
         this.flushPendingOperations();
         if(Boolean(this.redrawListener))
         {
            this.updateAllControllers();
         }
         super.textFlow = value;
      }
      
      public function get delayUpdates() : Boolean
      {
         return this._delayUpdates;
      }
      
      public function set delayUpdates(value:Boolean) : void
      {
         this._delayUpdates = value;
      }
      
      private function redrawHandler(e:Event) : void
      {
         this.updateAllControllers();
      }
      
      public function updateAllControllers() : void
      {
         var controllerIndex:int = 0;
         this.flushPendingOperations();
         if(Boolean(this.redrawListener))
         {
            this.redrawListener.removeEventListener(Event.ENTER_FRAME,this.redrawHandler);
            this.redrawListener = null;
         }
         if(Boolean(textFlow.flowComposer))
         {
            textFlow.flowComposer.updateAllControllers();
            if(hasSelection())
            {
               controllerIndex = int(textFlow.flowComposer.findControllerIndexAtPosition(activePosition));
               if(controllerIndex >= 0)
               {
                  textFlow.flowComposer.getControllerAt(controllerIndex).scrollToRange(activePosition,anchorPosition);
               }
            }
         }
         this.tlf_internal::selectionChanged(true,false);
      }
      
      private function handleUpdate() : void
      {
         var controller:ContainerController = null;
         if(this._delayUpdates)
         {
            if(!this.redrawListener)
            {
               controller = textFlow.flowComposer.getControllerAt(0);
               if(Boolean(controller))
               {
                  this.redrawListener = controller.container;
                  if(Boolean(this.redrawListener))
                  {
                     this.redrawListener.addEventListener(Event.ENTER_FRAME,this.redrawHandler,false,1,true);
                  }
               }
            }
         }
         else
         {
            this.updateAllControllers();
         }
      }
      
      public function get allowDelayedOperations() : Boolean
      {
         return this._allowDelayedOperations;
      }
      
      public function set allowDelayedOperations(value:Boolean) : void
      {
         if(!value)
         {
            this.flushPendingOperations();
         }
         this._allowDelayedOperations = value;
      }
      
      override public function flushPendingOperations() : void
      {
         var pi0:InsertTextOperation = null;
         super.flushPendingOperations();
         if(Boolean(this.pendingInsert))
         {
            pi0 = this.pendingInsert;
            this.pendingInsert = null;
            if(Boolean(this.enterFrameListener))
            {
               this.enterFrameListener.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
               this.enterFrameListener = null;
            }
            this.doOperation(pi0);
         }
      }
      
      public function undo() : void
      {
         if(Boolean(this._imeSession))
         {
            this._imeSession.compositionAbandoned();
         }
         if(Boolean(this.undoManager))
         {
            this.undoManager.undo();
         }
      }
      
      public function performUndo(theop:IOperation) : void
      {
         var opError:Error;
         var undoPsuedoOp:UndoOperation = null;
         var opEvent:FlowOperationEvent = null;
         var rslt:SelectionState = null;
         var operation:FlowOperation = theop as FlowOperation;
         if(!operation || operation.textFlow != textFlow)
         {
            return;
         }
         if(!this._imeSession)
         {
            undoPsuedoOp = new UndoOperation(operation);
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_BEGIN,false,true,undoPsuedoOp,0,null);
            textFlow.dispatchEvent(opEvent);
            if(opEvent.isDefaultPrevented())
            {
               this.undoManager.pushUndo(operation);
               return;
            }
            undoPsuedoOp = opEvent.operation as UndoOperation;
            if(!undoPsuedoOp)
            {
               throw new IllegalOperationError(GlobalSettings.resourceStringFunction("illegalOperation",[getQualifiedClassName(opEvent.operation)]));
            }
            operation = undoPsuedoOp.operation;
         }
         if(operation.endGeneration != textFlow.generation)
         {
            return;
         }
         opError = null;
         try
         {
            rslt = operation.undo();
            setSelectionState(rslt);
            if(Boolean(this._undoManager))
            {
               this._undoManager.pushRedo(operation);
            }
         }
         catch(e:Error)
         {
            opError = e;
         }
         if(!this._imeSession)
         {
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_END,false,true,undoPsuedoOp,0,opError);
            textFlow.dispatchEvent(opEvent);
            opError = opEvent.isDefaultPrevented() ? null : opEvent.error;
         }
         if(Boolean(opError))
         {
            throw opError;
         }
         this.handleUpdate();
         textFlow.tlf_internal::setGeneration(operation.beginGeneration);
         if(!this._imeSession)
         {
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_COMPLETE,false,false,undoPsuedoOp,0,null);
            textFlow.dispatchEvent(opEvent);
         }
      }
      
      public function redo() : void
      {
         if(Boolean(this._imeSession))
         {
            this._imeSession.compositionAbandoned();
         }
         if(Boolean(this.undoManager))
         {
            this.undoManager.redo();
         }
      }
      
      public function performRedo(theop:IOperation) : void
      {
         var opError:Error;
         var opEvent:FlowOperationEvent = null;
         var redoPsuedoOp:RedoOperation = null;
         var rslt:SelectionState = null;
         var controllerIndex:int = 0;
         var op:FlowOperation = theop as FlowOperation;
         if(!op || op.textFlow != textFlow)
         {
            return;
         }
         if(!this._imeSession)
         {
            redoPsuedoOp = new RedoOperation(op);
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_BEGIN,false,true,redoPsuedoOp,0,null);
            textFlow.dispatchEvent(opEvent);
            if(opEvent.isDefaultPrevented() && Boolean(this._undoManager))
            {
               this._undoManager.pushRedo(op);
               return;
            }
            redoPsuedoOp = opEvent.operation as RedoOperation;
            if(!redoPsuedoOp)
            {
               throw new IllegalOperationError(GlobalSettings.resourceStringFunction("illegalOperation",[getQualifiedClassName(opEvent.operation)]));
            }
            op = redoPsuedoOp.operation;
         }
         if(op.beginGeneration != textFlow.generation)
         {
            return;
         }
         opError = null;
         try
         {
            rslt = op.redo();
            setSelectionState(rslt);
            if(Boolean(this._undoManager))
            {
               this._undoManager.pushUndo(op);
            }
         }
         catch(e:Error)
         {
            opError = e;
         }
         if(!this._imeSession)
         {
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_END,false,true,redoPsuedoOp,0,opError);
            textFlow.dispatchEvent(opEvent);
            opError = opEvent.isDefaultPrevented() ? null : opEvent.error;
         }
         if(Boolean(opError))
         {
            throw opError;
         }
         this.handleUpdate();
         textFlow.tlf_internal::setGeneration(op.endGeneration);
         if(hasSelection())
         {
            controllerIndex = int(textFlow.flowComposer.findControllerIndexAtPosition(activePosition));
            if(controllerIndex >= 0)
            {
               textFlow.flowComposer.getControllerAt(controllerIndex).scrollToRange(activePosition,anchorPosition);
            }
         }
         if(!this._imeSession)
         {
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_COMPLETE,false,false,redoPsuedoOp,0,null);
            textFlow.dispatchEvent(opEvent);
         }
      }
      
      override public function get editingMode() : String
      {
         return EditingMode.READ_WRITE;
      }
      
      tlf_internal function defaultOperationState(operationState:SelectionState = null) : SelectionState
      {
         var markActive:Mark = null;
         var markAnchor:Mark = null;
         if(Boolean(operationState))
         {
            markActive = tlf_internal::createMark();
            markAnchor = tlf_internal::createMark();
            try
            {
               markActive.position = operationState.activePosition;
               markAnchor.position = operationState.anchorPosition;
               this.flushPendingOperations();
            }
            finally
            {
               tlf_internal::removeMark(markActive);
               tlf_internal::removeMark(markAnchor);
               operationState.activePosition = markActive.position;
               operationState.anchorPosition = markAnchor.position;
            }
         }
         else
         {
            this.flushPendingOperations();
            if(hasSelection())
            {
               operationState = getSelectionState();
               operationState.tlf_internal::selectionManagerOperationState = true;
            }
         }
         return operationState;
      }
      
      public function splitParagraph(operationState:SelectionState = null) : ParagraphElement
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         var op:SplitElementOperation = new SplitParagraphOperation(operationState);
         this.doOperation(op);
         return op.newElement as ParagraphElement;
      }
      
      public function splitElement(target:FlowGroupElement, operationState:SelectionState = null) : FlowGroupElement
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         var op:SplitElementOperation = new SplitElementOperation(operationState,target);
         this.doOperation(op);
         return op.newElement;
      }
      
      public function createDiv(parent:FlowGroupElement = null, format:ITextLayoutFormat = null, operationState:SelectionState = null) : DivElement
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         var operation:CreateDivOperation = new CreateDivOperation(operationState,parent,format);
         this.doOperation(operation);
         return operation.newDivElement;
      }
      
      public function createList(parent:FlowGroupElement = null, format:ITextLayoutFormat = null, operationState:SelectionState = null) : ListElement
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         var operation:CreateListOperation = new CreateListOperation(operationState,parent,format);
         this.doOperation(operation);
         return operation.newListElement;
      }
      
      public function moveChildren(source:FlowGroupElement, sourceIndex:int, numChildren:int, destination:FlowGroupElement, destinationIndex:int, selectionState:SelectionState = null) : void
      {
         selectionState = this.tlf_internal::defaultOperationState(selectionState);
         if(!selectionState)
         {
            return;
         }
         var operation:MoveChildrenOperation = new MoveChildrenOperation(selectionState,source,sourceIndex,numChildren,destination,destinationIndex);
         this.doOperation(operation);
      }
      
      public function createSubParagraphGroup(parent:FlowGroupElement = null, format:ITextLayoutFormat = null, operationState:SelectionState = null) : SubParagraphGroupElement
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         var operation:CreateSubParagraphGroupOperation = new CreateSubParagraphGroupOperation(operationState,parent,format);
         this.doOperation(operation);
         return operation.newSubParagraphGroupElement;
      }
      
      public function deleteText(operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         this.doOperation(new DeleteTextOperation(operationState,operationState,false));
      }
      
      public function deleteNextCharacter(operationState:SelectionState = null) : void
      {
         var deleteOp:DeleteTextOperation = null;
         var nextPosition:int = 0;
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         if(operationState.absoluteStart == operationState.absoluteEnd)
         {
            nextPosition = NavigationUtil.nextAtomPosition(textFlow,absoluteStart);
            deleteOp = new DeleteTextOperation(operationState,new SelectionState(textFlow,absoluteStart,nextPosition,pointFormat),true);
         }
         else
         {
            deleteOp = new DeleteTextOperation(operationState,operationState,false);
         }
         this.doOperation(deleteOp);
      }
      
      public function deleteNextWord(operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState || operationState.anchorPosition == operationState.activePosition && operationState.anchorPosition >= textFlow.textLength - 1)
         {
            return;
         }
         var nextWordSelState:SelectionState = this.getNextWordForDelete(operationState.absoluteStart);
         if(nextWordSelState.anchorPosition == nextWordSelState.activePosition)
         {
            return;
         }
         setSelectionState(new SelectionState(textFlow,operationState.absoluteStart,operationState.absoluteStart,new TextLayoutFormat(textFlow.findLeaf(operationState.absoluteStart).format)));
         this.doOperation(new DeleteTextOperation(operationState,nextWordSelState,false));
      }
      
      private function getNextWordForDelete(absoluteStart:int) : SelectionState
      {
         var curPos:int = 0;
         var curPosCharCode:int = 0;
         var prevPosCharCode:int = 0;
         var nextPosCharCode:int = 0;
         var leafEl:FlowLeafElement = textFlow.findLeaf(absoluteStart);
         var paraEl:ParagraphElement = leafEl.getParagraph();
         var paraElAbsStart:int = paraEl.getAbsoluteStart();
         var nextPosition:int = -1;
         if(absoluteStart - paraElAbsStart >= paraEl.textLength - 1)
         {
            nextPosition = NavigationUtil.nextAtomPosition(textFlow,absoluteStart);
         }
         else
         {
            curPos = absoluteStart - paraElAbsStart;
            curPosCharCode = paraEl.getCharCodeAtPosition(curPos);
            prevPosCharCode = -1;
            if(curPos > 0)
            {
               prevPosCharCode = paraEl.getCharCodeAtPosition(curPos - 1);
            }
            nextPosCharCode = paraEl.getCharCodeAtPosition(curPos + 1);
            if(!CharacterUtil.isWhitespace(curPosCharCode) && (curPos == 0 || curPos > 0 && CharacterUtil.isWhitespace(prevPosCharCode)))
            {
               nextPosition = NavigationUtil.nextWordPosition(textFlow,absoluteStart);
            }
            else
            {
               if(CharacterUtil.isWhitespace(curPosCharCode) && (curPos > 0 && !CharacterUtil.isWhitespace(prevPosCharCode)))
               {
                  curPos = paraEl.findNextWordBoundary(curPos);
               }
               nextPosition = paraElAbsStart + paraEl.findNextWordBoundary(curPos);
            }
         }
         return new SelectionState(textFlow,absoluteStart,nextPosition,pointFormat);
      }
      
      public function deletePreviousCharacter(operationState:SelectionState = null) : void
      {
         var deleteOp:DeleteTextOperation = null;
         var leaf:FlowLeafElement = null;
         var para:ParagraphElement = null;
         var parent:FlowGroupElement = null;
         var movePara:Boolean = false;
         var source:FlowGroupElement = null;
         var target:FlowGroupElement = null;
         var numElementsToMove:int = 0;
         var targetIndex:int = 0;
         var beginPrevious:int = 0;
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         if(operationState.absoluteStart == operationState.absoluteEnd)
         {
            leaf = textFlow.findLeaf(operationState.absoluteStart);
            para = leaf.getParagraph();
            parent = para.parent;
            movePara = false;
            if(!(parent is TextFlow))
            {
               if(operationState.absoluteStart == para.getAbsoluteStart() && parent.getChildIndex(para) == 0 && (!(parent is ListItemElement) || parent.parent.getChildIndex(parent) == 0))
               {
                  movePara = true;
               }
            }
            if(movePara)
            {
               if(parent is ListItemElement)
               {
                  if(parent.parent.parent is ListElement)
                  {
                     source = parent.parent;
                     numElementsToMove = 1;
                     target = parent.parent.parent;
                     targetIndex = parent.parent.parent.getChildIndex(parent.parent);
                  }
                  else
                  {
                     source = para.parent;
                     numElementsToMove = para.parent.numChildren;
                     target = parent.parent.parent;
                     targetIndex = parent.parent.parent.getChildIndex(parent.parent);
                  }
               }
               else
               {
                  source = para.parent;
                  numElementsToMove = 1;
                  target = parent.parent;
                  targetIndex = parent.parent.getChildIndex(parent);
               }
               this.doOperation(new MoveChildrenOperation(operationState,source,0,numElementsToMove,target,targetIndex));
            }
            else
            {
               beginPrevious = NavigationUtil.previousAtomPosition(textFlow,operationState.absoluteStart);
               deleteOp = new DeleteTextOperation(operationState,new SelectionState(textFlow,beginPrevious,operationState.absoluteStart),true);
               this.doOperation(deleteOp);
            }
         }
         else
         {
            deleteOp = new DeleteTextOperation(operationState);
            this.doOperation(deleteOp);
         }
      }
      
      public function deletePreviousWord(operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         var prevWordSelState:SelectionState = this.getPreviousWordForDelete(operationState.absoluteStart);
         if(prevWordSelState.anchorPosition == prevWordSelState.activePosition)
         {
            return;
         }
         setSelectionState(new SelectionState(textFlow,operationState.absoluteStart,operationState.absoluteStart,new TextLayoutFormat(textFlow.findLeaf(operationState.absoluteStart).format)));
         this.doOperation(new DeleteTextOperation(operationState,prevWordSelState,false));
      }
      
      private function getPreviousWordForDelete(absoluteStart:int) : SelectionState
      {
         var beginPrevious:int = 0;
         var leafEl:FlowLeafElement = textFlow.findLeaf(absoluteStart);
         var paraEl:ParagraphElement = leafEl.getParagraph();
         var paraElAbsStart:int = paraEl.getAbsoluteStart();
         if(absoluteStart == paraElAbsStart)
         {
            beginPrevious = NavigationUtil.previousAtomPosition(textFlow,absoluteStart);
            return new SelectionState(textFlow,beginPrevious,absoluteStart);
         }
         var curPos:int = absoluteStart - paraElAbsStart;
         var curPosCharCode:int = paraEl.getCharCodeAtPosition(curPos);
         var prevPosCharCode:int = paraEl.getCharCodeAtPosition(curPos - 1);
         var curAbsStart:int = absoluteStart;
         if(CharacterUtil.isWhitespace(curPosCharCode) && curPos != paraEl.textLength - 1)
         {
            if(CharacterUtil.isWhitespace(prevPosCharCode))
            {
               curPos = paraEl.findPreviousWordBoundary(curPos);
            }
            if(curPos > 0)
            {
               curPos = paraEl.findPreviousWordBoundary(curPos);
               if(curPos > 0)
               {
                  prevPosCharCode = paraEl.getCharCodeAtPosition(curPos - 1);
                  if(CharacterUtil.isWhitespace(prevPosCharCode))
                  {
                     curPos = paraEl.findPreviousWordBoundary(curPos);
                  }
               }
            }
         }
         else if(CharacterUtil.isWhitespace(prevPosCharCode))
         {
            curPos = paraEl.findPreviousWordBoundary(curPos);
            if(curPos > 0)
            {
               curPos = paraEl.findPreviousWordBoundary(curPos);
               if(curPos > 0)
               {
                  prevPosCharCode = paraEl.getCharCodeAtPosition(curPos - 1);
                  if(!CharacterUtil.isWhitespace(prevPosCharCode))
                  {
                     curAbsStart--;
                  }
               }
            }
         }
         else
         {
            curPos = paraEl.findPreviousWordBoundary(curPos);
         }
         return new SelectionState(textFlow,paraElAbsStart + curPos,curAbsStart);
      }
      
      public function insertText(text:String, origOperationState:SelectionState = null) : void
      {
         var operationState:SelectionState = null;
         var controller:ContainerController = null;
         if(origOperationState == null && Boolean(this.pendingInsert))
         {
            this.pendingInsert.text += text;
         }
         else
         {
            operationState = this.tlf_internal::defaultOperationState(origOperationState);
            if(!operationState)
            {
               return;
            }
            this.pendingInsert = new InsertTextOperation(operationState,text);
            controller = textFlow.flowComposer.getControllerAt(0);
            if(this.tlf_internal::captureLevel == 0 && origOperationState == null && controller && controller.container && this.allowDelayedOperations)
            {
               this.enterFrameListener = controller.container;
               this.enterFrameListener.addEventListener(Event.ENTER_FRAME,enterFrameHandler,false,1,true);
            }
            else
            {
               this.flushPendingOperations();
            }
         }
      }
      
      public function overwriteText(text:String, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         var selState:SelectionState = getSelectionState();
         NavigationUtil.nextCharacter(selState,true);
         this.doOperation(new InsertTextOperation(operationState,text,selState));
      }
      
      public function insertInlineGraphic(source:Object, width:Object, height:Object, options:Object = null, operationState:SelectionState = null) : InlineGraphicElement
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         var operation:InsertInlineGraphicOperation = new InsertInlineGraphicOperation(operationState,source,width,height,options);
         this.doOperation(operation);
         return operation.newInlineGraphicElement;
      }
      
      public function modifyInlineGraphic(source:Object, width:Object, height:Object, options:Object = null, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         this.doOperation(new ModifyInlineGraphicOperation(operationState,source,width,height,options));
      }
      
      public function applyFormat(leafFormat:ITextLayoutFormat, paragraphFormat:ITextLayoutFormat, containerFormat:ITextLayoutFormat, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         this.doOperation(new ApplyFormatOperation(operationState,leafFormat,paragraphFormat,containerFormat));
      }
      
      public function clearFormat(leafFormat:ITextLayoutFormat, paragraphFormat:ITextLayoutFormat, containerFormat:ITextLayoutFormat, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         this.doOperation(new ClearFormatOperation(operationState,leafFormat,paragraphFormat,containerFormat));
      }
      
      public function applyLeafFormat(characterFormat:ITextLayoutFormat, operationState:SelectionState = null) : void
      {
         this.applyFormat(characterFormat,null,null,operationState);
      }
      
      public function applyParagraphFormat(paragraphFormat:ITextLayoutFormat, operationState:SelectionState = null) : void
      {
         this.applyFormat(null,paragraphFormat,null,operationState);
      }
      
      public function applyContainerFormat(containerFormat:ITextLayoutFormat, operationState:SelectionState = null) : void
      {
         this.applyFormat(null,null,containerFormat,operationState);
      }
      
      public function applyFormatToElement(targetElement:FlowElement, format:ITextLayoutFormat, relativeStart:int = 0, relativeEnd:int = -1, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         this.doOperation(new ApplyFormatToElementOperation(operationState,targetElement,format,relativeStart,relativeEnd));
      }
      
      public function clearFormatOnElement(targetElement:FlowElement, format:ITextLayoutFormat, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         this.doOperation(new ClearFormatOnElementOperation(operationState,targetElement,format));
      }
      
      public function cutTextScrap(operationState:SelectionState = null) : TextScrap
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         if(operationState.anchorPosition == operationState.activePosition)
         {
            return null;
         }
         var tScrap:TextScrap = TextScrap.createTextScrap(operationState);
         var beforeOpLen:int = textFlow.textLength;
         this.doOperation(new CutOperation(operationState,tScrap));
         if(operationState.textFlow.textLength != beforeOpLen)
         {
            return tScrap;
         }
         return null;
      }
      
      public function pasteTextScrap(scrapToPaste:TextScrap, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         this.doOperation(new PasteOperation(operationState,scrapToPaste));
      }
      
      public function applyTCY(tcyOn:Boolean, operationState:SelectionState = null) : TCYElement
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         var operation:ApplyTCYOperation = new ApplyTCYOperation(operationState,tcyOn);
         this.doOperation(operation);
         return operation.newTCYElement;
      }
      
      public function applyLink(href:String, targetString:String = null, extendToLinkBoundary:Boolean = false, operationState:SelectionState = null) : LinkElement
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return null;
         }
         if(operationState.absoluteStart == operationState.absoluteEnd)
         {
            return null;
         }
         var operation:ApplyLinkOperation = new ApplyLinkOperation(operationState,href,targetString,extendToLinkBoundary);
         this.doOperation(operation);
         return operation.newLinkElement;
      }
      
      public function changeElementID(newID:String, targetElement:FlowElement, relativeStart:int = 0, relativeEnd:int = -1, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         if(operationState.absoluteStart == operationState.absoluteEnd)
         {
            return;
         }
         this.doOperation(new ApplyElementIDOperation(operationState,targetElement,newID,relativeStart,relativeEnd));
      }
      
      [Deprecated(replacement="applyFormatToElement",deprecatedSince="2.0")]
      public function changeStyleName(newName:String, targetElement:FlowElement, relativeStart:int = 0, relativeEnd:int = -1, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         var format:TextLayoutFormat = new TextLayoutFormat();
         format.styleName = newName;
         this.doOperation(new ApplyFormatToElementOperation(operationState,targetElement,format,relativeStart,relativeEnd));
      }
      
      public function changeTypeName(newName:String, targetElement:FlowElement, relativeStart:int = 0, relativeEnd:int = -1, operationState:SelectionState = null) : void
      {
         operationState = this.tlf_internal::defaultOperationState(operationState);
         if(!operationState)
         {
            return;
         }
         this.doOperation(new ApplyElementTypeNameOperation(operationState,targetElement,newName,relativeStart,relativeEnd));
      }
      
      public function beginCompositeOperation() : void
      {
         var opEvent:FlowOperationEvent = null;
         this.flushPendingOperations();
         if(!this.parentStack)
         {
            this.parentStack = [];
         }
         var operation:CompositeOperation = new CompositeOperation();
         if(!this._imeSession)
         {
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_BEGIN,false,false,operation,this.tlf_internal::captureLevel,null);
            textFlow.dispatchEvent(opEvent);
         }
         operation.tlf_internal::setGenerations(textFlow.generation,0);
         ++this.tlf_internal::captureLevel;
         var parent:Object = new Object();
         parent.operation = operation;
         parent.captureLevel = this.tlf_internal::captureLevel;
         this.parentStack.push(parent);
      }
      
      public function endCompositeOperation() : void
      {
         var opEvent:FlowOperationEvent = null;
         --this.tlf_internal::captureLevel;
         var parent:Object = this.parentStack.pop();
         var operation:FlowOperation = parent.operation;
         if(!this._imeSession)
         {
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_END,false,false,operation,this.tlf_internal::captureLevel,null);
            textFlow.dispatchEvent(opEvent);
         }
         operation.tlf_internal::setGenerations(operation.beginGeneration,textFlow.generation);
         this.finalizeDo(operation);
      }
      
      override tlf_internal function selectionChanged(doDispatchEvent:Boolean = true, resetPointFormat:Boolean = true) : void
      {
         if(Boolean(this._imeSession))
         {
            this._imeSession.selectionChanged();
         }
         super.tlf_internal::selectionChanged(doDispatchEvent,resetPointFormat);
      }
   }
}
