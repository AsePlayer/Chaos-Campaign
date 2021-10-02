package flash
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public dynamic class Boot extends MovieClip
   {
      
      public static var tf:TextField;
      
      public static var lines:Array;
      
      public static var lastError:Error;
      
      public static var skip_constructor:Boolean = false;
       
      
      public function Boot()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
      }
      
      public static function enum_to_string(e:Object) : String
      {
         var _loc5_:* = null;
         if(e.params == null)
         {
            return e.tag;
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:Array = e.params;
         while(_loc3_ < int(_loc4_.length))
         {
            _loc5_ = _loc4_[_loc3_];
            _loc3_++;
            _loc2_.push(Boot.__string_rec(_loc5_,""));
         }
         return e.tag + "(" + _loc2_.join(",") + ")";
      }
      
      public static function __instanceof(v:*, t:*) : Boolean
      {
         var _loc4_:* = null;
         try
         {
            if(t == Dynamic)
            {
               return true;
            }
            return v is t;
         }
         catch(_loc_e_:*)
         {
         }
      }
      
      public static function __clear_trace() : void
      {
         if(Boot.tf == null)
         {
            return;
         }
         Boot.tf.parent.removeChild(Boot.tf);
         Boot.tf = null;
         Boot.lines = null;
      }
      
      public static function __set_trace_color(rgb:uint) : void
      {
         Boot.getTrace().textColor = rgb;
      }
      
      public static function getTrace() : TextField
      {
         var _loc2_:* = null as TextFormat;
         var _loc1_:MovieClip = Lib.current;
         if(Boot.tf == null)
         {
            Boot.tf = new TextField();
            _loc2_ = Boot.tf.getTextFormat();
            _loc2_.font = "_sans";
            Boot.tf.defaultTextFormat = _loc2_;
            Boot.tf.selectable = false;
            Boot.tf.width = _loc1_.stage == null ? 800 : _loc1_.stage.stageWidth;
            Boot.tf.autoSize = TextFieldAutoSize.LEFT;
            Boot.tf.mouseEnabled = false;
         }
         if(_loc1_.stage == null)
         {
            _loc1_.addChild(Boot.tf);
         }
         else
         {
            _loc1_.stage.addChild(Boot.tf);
         }
         return Boot.tf;
      }
      
      public static function __trace(v:*, pos:Object) : void
      {
         var _loc3_:TextField = Boot.getTrace();
         var _loc4_:String = pos == null ? "(null)" : pos.fileName + ":" + int(pos.lineNumber);
         if(Boot.lines == null)
         {
            Boot.lines = [];
         }
         Boot.lines = Boot.lines.concat((_loc4_ + ": " + Boot.__string_rec(v,"")).split("\n"));
         _loc3_.text = Boot.lines.join("\n");
         var _loc5_:Stage = Lib.current.stage;
         if(_loc5_ == null)
         {
            return;
         }
         while(int(Boot.lines.length) > 1 && _loc3_.height > _loc5_.stageHeight)
         {
            Boot.lines.shift();
            _loc3_.text = Boot.lines.join("\n");
         }
      }
      
      public static function __string_rec(v:*, str:String) : String
      {
         var _loc4_:* = null as String;
         var _loc5_:* = null as Array;
         var _loc6_:* = null as Array;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc9_:* = null as String;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:* = null as String;
         var _loc3_:String = getQualifiedClassName(v);
         _loc4_ = _loc3_;
         if(_loc4_ == "Object")
         {
            _loc7_ = 0;
            _loc6_ = [];
            _loc8_ = v;
            while(§§hasnext(_loc8_,_loc7_))
            {
               _loc6_.push(§§nextname(_loc7_,_loc8_));
            }
            _loc5_ = _loc6_;
            _loc9_ = "{";
            _loc10_ = true;
            _loc7_ = 0;
            _loc11_ = int(_loc5_.length);
            while(_loc7_ < _loc11_)
            {
               _loc12_ = _loc7_++;
               _loc13_ = _loc5_[_loc12_];
               if(_loc10_)
               {
                  _loc10_ = false;
               }
               else
               {
                  _loc9_ += ",";
               }
               _loc9_ += " " + _loc13_ + " : " + Boot.__string_rec(v[_loc13_],str);
            }
            if(!_loc10_)
            {
               _loc9_ += " ";
            }
            return _loc9_ + "}";
         }
         if(_loc4_ == "Array")
         {
            if(v == Array)
            {
               return "#Array";
            }
            _loc9_ = "[";
            _loc10_ = true;
            _loc5_ = v;
            _loc7_ = 0;
            _loc11_ = int(_loc5_.length);
            while(_loc7_ < _loc11_)
            {
               _loc12_ = _loc7_++;
               if(_loc10_)
               {
                  _loc10_ = false;
               }
               else
               {
                  _loc9_ += ",";
               }
               _loc9_ += Boot.__string_rec(_loc5_[_loc12_],str);
            }
            return _loc9_ + "]";
         }
         _loc4_ = typeof v;
         if(_loc4_ == "function")
         {
            return "<function>";
         }
         return new String(v);
      }
      
      public static function __unprotect__(s:String) : String
      {
         return s;
      }
      
      public function start() : void
      {
         var _loc3_:* = null;
         var _loc2_:MovieClip = Lib.current;
         try
         {
            if(_loc2_ == this && _loc2_.stage != null && _loc2_.stage.align == "")
            {
               _loc2_.stage.align = "TOP_LEFT";
            }
         }
         catch(_loc_e_:*)
         {
            if(_loc2_.stage == null)
            {
               _loc2_.addEventListener(Event.ADDED_TO_STAGE,doInitDelay);
            }
            else if(_loc2_.stage.stageWidth == 0)
            {
               setTimeout(start,1);
            }
            else
            {
               init();
            }
            return;
         }
      }
      
      public function init() : void
      {
         Boot.lastError = new Error();
         throw "assert";
      }
      
      public function doInitDelay(_:*) : void
      {
         Lib.current.removeEventListener(Event.ADDED_TO_STAGE,doInitDelay);
         start();
      }
   }
}
