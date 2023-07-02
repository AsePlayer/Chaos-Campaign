package gs.plugins
{
   import flash.display.*;
   import gs.*;
   import gs.utils.tween.*;
   
   public class EndArrayPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
       
      
      protected var _a:Array;
      
      protected var _info:Array;
      
      public function EndArrayPlugin()
      {
         this._info = [];
         super();
         this.propName = "endArray";
         this.overwriteProps = ["endArray"];
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         if(!($target is Array) || !($value is Array))
         {
            return false;
         }
         this.init($target as Array,$value);
         return true;
      }
      
      public function init($start:Array, $end:Array) : void
      {
         this._a = $start;
         for(var i:int = $end.length - 1; i > -1; i--)
         {
            if($start[i] != $end[i] && $start[i] != null)
            {
               this._info[this._info.length] = new ArrayTweenInfo(i,this._a[i],$end[i] - this._a[i]);
            }
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         var i:int = 0;
         var ti:ArrayTweenInfo = null;
         var val:Number = NaN;
         var neg:int = 0;
         if(this.round)
         {
            for(i = this._info.length - 1; i > -1; i--)
            {
               ti = this._info[i];
               val = ti.start + ti.change * $n;
               neg = val < 0 ? -1 : 1;
               this._a[ti.index] = val % 1 * neg > 0.5 ? int(val) + neg : int(val);
            }
         }
         else
         {
            for(i = this._info.length - 1; i > -1; i--)
            {
               ti = this._info[i];
               this._a[ti.index] = ti.start + ti.change * $n;
            }
         }
      }
   }
}
