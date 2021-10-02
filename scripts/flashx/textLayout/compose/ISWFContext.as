package flashx.textLayout.compose
{
   public interface ISWFContext
   {
       
      
      function callInContext(fn:Function, thisArg:Object, argArray:Array, returns:Boolean = true) : *;
   }
}
