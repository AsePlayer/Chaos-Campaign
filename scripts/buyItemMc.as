package
{
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public dynamic class buyItemMc extends MovieClip
   {
       
      
      public var balance:TextField;
      
      public var cost:TextField;
      
      public var empiresPoints:TLFTextField;
      
      public var closeButton:SimpleButton;
      
      public var current:TextField;
      
      public var displayBox:MovieClip;
      
      public var unlockButton:SimpleButton;
      
      public var __cacheXMLSettings:Object;
      
      public function buyItemMc()
      {
         super();
         this.__cacheXMLSettings = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            XML.prettyPrinting = false;
            RuntimeManager.getSingleton().addInstance(this,"empiresPoints",new Rectangle(0,0,53.35,17.1),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="1" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="normal" embedFonts="false"><TextFlow blockProgression="tb" lineBreak="explicit" locale="en" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" textAlign="start" textAlignLast="start" textIndent="0" textJustify="interWord"><span color="#ffff00" fontFamily="Arial" fontSize="14" fontStyle="normal" fontWeight="bold" kerning="on" lineHeight="120%" textAlpha="1" textRotation="auto" trackingRight="0%">0</span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
         }
         finally
         {
            XML.setSettings(this.__cacheXMLSettings);
         }
         RuntimeManager.getSingleton().addInstanceComplete(this);
      }
   }
}
