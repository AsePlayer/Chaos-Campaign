package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import flash.Boot;
   
   public class DLLNode
   {
       
      
      public var val:Object;
      
      public var prev:DLLNode;
      
      public var next:DLLNode;
      
      public var _list:DLL;
      
      public function DLLNode(x:Object = undefined, list:DLL = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         val = x;
         _list = list;
      }
      
      public function unlink() : DLLNode
      {
         null;
         return _list.unlink(this);
      }
      
      public function toString() : String
      {
         return Sprintf.format("{DLLNode %s}",[Std.string(val)]);
      }
      
      public function prevVal() : Object
      {
         null;
         return prev.val;
      }
      
      public function prependTo(node:DLLNode) : DLLNode
      {
         null;
         null;
         null;
         next = node;
         if(node != null)
         {
            node.prev = this;
         }
         return this;
      }
      
      public function prepend(node:DLLNode) : DLLNode
      {
         null;
         null;
         null;
         node.next = this;
         prev = node;
         return node;
      }
      
      public function nextVal() : Object
      {
         null;
         return next.val;
      }
      
      public function isTail() : Boolean
      {
         null;
         return this == _list.tail;
      }
      
      public function isHead() : Boolean
      {
         null;
         return this == _list.head;
      }
      
      public function hasPrev() : Boolean
      {
         return prev != null;
      }
      
      public function hasNext() : Boolean
      {
         return next != null;
      }
      
      public function getList() : DLL
      {
         return _list;
      }
      
      public function free() : void
      {
         var _loc1_:Object = null;
         val = _loc1_;
         next = prev = null;
         _list = null;
      }
      
      public function appendTo(node:DLLNode) : DLLNode
      {
         null;
         null;
         null;
         prev = node;
         if(node != null)
         {
            node.next = this;
         }
         return this;
      }
      
      public function append(node:DLLNode) : DLLNode
      {
         null;
         null;
         null;
         next = node;
         node.prev = this;
         return node;
      }
      
      public function _unlink() : DLLNode
      {
         var _loc1_:DLLNode = next;
         if(prev != null)
         {
            prev.next = next;
         }
         if(next != null)
         {
            next.prev = prev;
         }
         next = prev = null;
         return _loc1_;
      }
      
      public function _insertBefore(node:DLLNode) : void
      {
         node.next = this;
         node.prev = prev;
         if(prev != null)
         {
            prev.next = node;
         }
         prev = node;
      }
      
      public function _insertAfter(node:DLLNode) : void
      {
         node.next = next;
         node.prev = this;
         if(next != null)
         {
            next.prev = node;
         }
         next = node;
      }
   }
}
