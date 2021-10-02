package fl.text
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   [ExcludeClass]
   interface IContainerManager
   {
       
      
      function get contentHeight() : Number;
      
      function get container() : Sprite;
      
      function get paddingTop() : Object;
      
      function set direction(value:String) : void;
      
      function setTextFormat(format:TextFormat, beginIndex:int, endIndex:int, charFormat:TextLayoutFormat, paraFormat:TextLayoutFormat) : void;
      
      function set editModeNoInteraction(value:String) : void;
      
      function setCompositionSize(width:Number, height:Number) : void;
      
      function get paddingRight() : Object;
      
      function setFormatForAllElements(flowGroupElem:FlowGroupElement, format:TextLayoutFormat) : void;
      
      function replaceText(beginIndex:int, endIndex:int, newText:String) : void;
      
      function compose() : void;
      
      function set paddingRight(value:Object) : void;
      
      function set paddingTop(value:Object) : void;
      
      function get numLines() : int;
      
      function set editMode(value:String) : void;
      
      function removeListeners() : void;
      
      function get controller() : ContainerController;
      
      function addListeners() : void;
      
      function get columnWidth() : Object;
      
      function set columnWidth(value:Object) : void;
      
      function get paddingBottom() : Object;
      
      function isTextStringAndFormat() : Boolean;
      
      function get contentLeft() : Number;
      
      function set firstBaselineOffset(value:Object) : void;
      
      function get firstBaselineOffset() : Object;
      
      function get absoluteStart() : int;
      
      function get verticalScrollPosition() : Number;
      
      function get text() : String;
      
      function get verticalAlign() : Object;
      
      function set columnCount(value:Object) : void;
      
      function convert(cls:Class) : IContainerManager;
      
      function get contentTop() : Number;
      
      function get antialiasType() : String;
      
      function get textColor() : uint;
      
      function set paddingBottom(value:Object) : void;
      
      function get embedFonts() : Boolean;
      
      function set horizontalScrollPosition(value:Number) : void;
      
      function get compositionWidth() : Number;
      
      function set antialiasType(value:String) : void;
      
      function get paddingLeft() : Object;
      
      function set columnGap(value:Object) : void;
      
      function get columnGap() : Object;
      
      function get hostFormat() : ITextLayoutFormat;
      
      function update() : void;
      
      function get contentWidth() : Number;
      
      function set lineBreak(value:String) : void;
      
      function set verticalScrollPosition(value:Number) : void;
      
      function get columnCount() : Object;
      
      function set text(value:String) : void;
      
      function set blockProgression(value:Object) : void;
      
      function getLineIndexBounds(index:int) : Rectangle;
      
      function set verticalAlign(value:Object) : void;
      
      function get horizontalScrollPosition() : Number;
      
      function set embedFonts(value:Boolean) : void;
      
      function appendText(newString:String) : void;
      
      function get lineBreak() : String;
      
      function set textColor(value:uint) : void;
      
      function get blockProgression() : Object;
      
      function set paddingLeft(value:Object) : void;
      
      function get compositionHeight() : Number;
      
      function get textLength() : int;
      
      function set textFlow(textFlow:TextFlow) : void;
      
      function getTextFormat(beginIndex:int, endIndex:int) : TextFormat;
      
      function get textFlow() : TextFlow;
      
      function set hostFormat(value:ITextLayoutFormat) : void;
      
      function get direction() : String;
   }
}
