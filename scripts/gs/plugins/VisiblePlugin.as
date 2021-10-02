package gs.plugins
{
   import gs.TweenLite;
   
   public class VisiblePlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
       
      
      protected var _target:Object;
      
      protected var _tween:TweenLite;
      
      protected var _visible:Boolean;
      
      public function VisiblePlugin()
      {
         super();
         this.propName = "visible";
         this.overwriteProps = ["visible"];
         this.onComplete = this.onCompleteTween;
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         this._target = $target;
         this._tween = $tween;
         this._visible = Boolean($value);
         return true;
      }
      
      public function onCompleteTween() : void
      {
         if(this._tween.vars.runBackwards != true && this._tween.ease == this._tween.vars.ease)
         {
            this._target.visible = this._visible;
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         if(this._target.visible != true)
         {
            this._target.visible = true;
         }
      }
   }
}
