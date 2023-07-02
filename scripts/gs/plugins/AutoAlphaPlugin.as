package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class AutoAlphaPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
       
      
      protected var _tweenVisible:Boolean;
      
      protected var _visible:Boolean;
      
      protected var _tween:TweenLite;
      
      protected var _target:Object;
      
      public function AutoAlphaPlugin()
      {
         super();
         this.propName = "autoAlpha";
         this.overwriteProps = ["alpha","visible"];
         this.onComplete = this.onCompleteTween;
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         this._target = $target;
         this._tween = $tween;
         this._visible = Boolean($value != 0);
         this._tweenVisible = true;
         addTween($target,"alpha",$target.alpha,$value,"alpha");
         return true;
      }
      
      override public function killProps($lookup:Object) : void
      {
         super.killProps($lookup);
         this._tweenVisible = !Boolean("visible" in $lookup);
      }
      
      public function onCompleteTween() : void
      {
         if(this._tweenVisible && this._tween.vars.runBackwards != true && this._tween.ease == this._tween.vars.ease)
         {
            this._target.visible = this._visible;
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         updateTweens($n);
         if(this._target.visible != true && this._tweenVisible)
         {
            this._target.visible = true;
         }
      }
   }
}
