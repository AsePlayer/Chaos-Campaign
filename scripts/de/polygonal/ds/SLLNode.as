package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import flash.Boot;
   
   public class SLLNode
   {
       
      
      public var val:Object;
      
      public var next:SLLNode;
      
      public var _list:SLL;
      
      public function SLLNode(x:Object = undefined, list:SLL = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         val = x;
         _list = list;
      }
      
      public function unlink() : SLLNode
      {
         var _loc3_:* = null as SLLNode;
         var _loc4_:* = null as SLLNode;
         var _loc5_:* = null as Object;
         var _loc6_:* = null as Object;
         null;
         var _loc1_:SLL = _list;
         null;
         null;
         null;
         var _loc2_:SLLNode = next;
         if(this == _loc1_.head)
         {
            null;
            _loc3_ = _loc1_.head;
            if(_loc1_._size > 1)
            {
               _loc1_.head = _loc1_.head.next;
               if(_loc1_.head == null)
               {
                  _loc1_.tail = null;
               }
               _loc1_._size = _loc1_._size - 1;
            }
            else
            {
               _loc1_.head = _loc1_.tail = null;
               _loc1_._size = 0;
            }
            _loc3_.next = null;
            _loc5_ = _loc3_.val;
            if(_loc1_._reservedSize > 0 && _loc1_._poolSize < _loc1_._reservedSize)
            {
               null;
               _loc1_._tailPool = _loc1_._tailPool.next = _loc3_;
               _loc6_ = null;
               _loc3_.val = _loc6_;
               _loc3_.next = null;
               _loc1_._poolSize = _loc1_._poolSize + 1;
            }
            else
            {
               _loc3_._list = null;
            }
            _loc5_;
         }
         else
         {
            _loc4_ = _loc1_.head;
            while(_loc4_.next != this)
            {
               _loc4_ = _loc4_.next;
            }
            _loc3_ = _loc4_;
            if(_loc3_.next == _loc1_.tail)
            {
               _loc1_.tail = _loc3_;
            }
            _loc3_.next = next;
            _loc5_ = val;
            if(_loc1_._reservedSize > 0 && _loc1_._poolSize < _loc1_._reservedSize)
            {
               null;
               _loc1_._tailPool = _loc1_._tailPool.next = this;
               _loc6_ = null;
               val = _loc6_;
               next = null;
               _loc1_._poolSize = _loc1_._poolSize + 1;
            }
            else
            {
               _list = null;
            }
            _loc5_;
            _loc1_._size = _loc1_._size - 1;
         }
         return _loc2_;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{SLLNode: %s}",[Std.string(val)]);
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
      
      public function hasNext() : Boolean
      {
         return next != null;
      }
      
      public function getList() : SLL
      {
         return _list;
      }
      
      public function free() : void
      {
         var _loc1_:Object = null;
         val = _loc1_;
         next = null;
      }
      
      public function _insertAfter(node:SLLNode) : void
      {
         node.next = next;
         next = node;
      }
   }
}
