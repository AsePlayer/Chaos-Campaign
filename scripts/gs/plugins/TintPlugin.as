package gs.plugins
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import gs.TweenLite;
   import gs.utils.tween.TweenInfo;
   
   public class TintPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.1;
      
      public static const API:Number = 1;
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
       
      
      protected var _target:DisplayObject;
      
      protected var _ct:ColorTransform;
      
      protected var _ignoreAlpha:Boolean;
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         if(!($target is DisplayObject))
         {
            return false;
         }
         var end:ColorTransform = new ColorTransform();
         if($value != null && $tween.exposedVars.removeTint != true)
         {
            end.color = uint($value);
         }
         this._ignoreAlpha = true;
         this.init($target as DisplayObject,end);
         return true;
      }
      
      public function init($target:DisplayObject, $end:ColorTransform) : void
      {
         var i:int = 0;
         var p:String = null;
         this._target = $target;
         this._ct = this._target.transform.colorTransform;
         for(i = _props.length - 1; i > -1; i--)
         {
            p = _props[i];
            if(this._ct[p] != $end[p])
            {
               _tweens[_tweens.length] = new TweenInfo(this._ct,p,this._ct[p],$end[p] - this._ct[p],"tint",false);
            }
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         var ct:ColorTransform = null;
         updateTweens($n);
         if(this._ignoreAlpha)
         {
            ct = this._target.transform.colorTransform;
            this._ct.alphaMultiplier = ct.alphaMultiplier;
            this._ct.alphaOffset = ct.alphaOffset;
         }
         this._target.transform.colorTransform = this._ct;
      }
   }
}
