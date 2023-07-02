package flashx.textLayout.elements
{
   import flashx.textLayout.formats.IListMarkerFormat;
   import flashx.textLayout.tlf_internal;
   
   public final class ListItemElement extends ContainerFormattedElement
   {
       
      
      tlf_internal var _listNumberHint:int = 2147483647;
      
      public function ListItemElement()
      {
         super();
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function get defaultTypeName() : String
      {
         return "li";
      }
      
      tlf_internal function computedListMarkerFormat() : IListMarkerFormat
      {
         var tf:TextFlow = null;
         var format:IListMarkerFormat = this.tlf_internal::getUserStyleWorker(ListElement.tlf_internal::LIST_MARKER_FORMAT_NAME) as IListMarkerFormat;
         if(format == null)
         {
            tf = this.getTextFlow();
            if(Boolean(tf))
            {
               format = tf.configuration.defaultListMarkerFormat;
            }
         }
         return format;
      }
      
      tlf_internal function normalizeNeedsInitialParagraph() : Boolean
      {
         var p:FlowGroupElement = this;
         while(Boolean(p))
         {
            p = p.getChildAt(0) as FlowGroupElement;
            if(p is ParagraphElement)
            {
               return false;
            }
            if(!(p is DivElement))
            {
               return true;
            }
         }
         return true;
      }
      
      override tlf_internal function normalizeRange(normalizeStart:uint, normalizeEnd:uint) : void
      {
         var p:ParagraphElement = null;
         super.tlf_internal::normalizeRange(normalizeStart,normalizeEnd);
         this.tlf_internal::_listNumberHint = int.MAX_VALUE;
         if(this.tlf_internal::normalizeNeedsInitialParagraph())
         {
            p = new ParagraphElement();
            p.replaceChildren(0,0,new SpanElement());
            replaceChildren(0,0,p);
            p.tlf_internal::normalizeRange(0,p.textLength);
         }
      }
      
      tlf_internal function getListItemNumber(listMarkerFormat:IListMarkerFormat = null) : int
      {
         var counterReset:Object = null;
         var counterIncrement:Object = null;
         var idx:int = 0;
         var sibling:ListItemElement = null;
         if(this.tlf_internal::_listNumberHint == int.MAX_VALUE)
         {
            if(listMarkerFormat == null)
            {
               listMarkerFormat = this.tlf_internal::computedListMarkerFormat();
            }
            counterReset = listMarkerFormat.counterReset;
            if(Boolean(counterReset) && counterReset.hasOwnProperty("ordered"))
            {
               this.tlf_internal::_listNumberHint = counterReset.ordered;
            }
            else
            {
               idx = parent.getChildIndex(this);
               this.tlf_internal::_listNumberHint = 0;
               while(idx > 0)
               {
                  idx--;
                  sibling = parent.getChildAt(idx) as ListItemElement;
                  if(Boolean(sibling))
                  {
                     this.tlf_internal::_listNumberHint = sibling.tlf_internal::getListItemNumber();
                     break;
                  }
               }
            }
            counterIncrement = listMarkerFormat.counterIncrement;
            this.tlf_internal::_listNumberHint += Boolean(counterIncrement) && counterIncrement.hasOwnProperty("ordered") ? counterIncrement.ordered : 1;
         }
         return this.tlf_internal::_listNumberHint;
      }
   }
}
