package
{
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.geom.Rectangle;
   
   public dynamic class itemUnlockResultMc extends MovieClip
   {
       
      
      public var description:TLFTextField;
      
      public var resultText:TLFTextField;
      
      public var doneButton:SimpleButton;
      
      public var __cacheXMLSettings:Object;
      
      public function itemUnlockResultMc()
      {
         super();
         this.__cacheXMLSettings = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            XML.prettyPrinting = false;
            RuntimeManager.getSingleton().addInstance(this,"resultText",new Rectangle(0,0,265.05,24),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="1" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="normal" embedFonts="false"><TextFlow blockProgression="tb" lineBreak="toFit" locale="en" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" textAlign="center" textAlignLast="start" textIndent="0" textJustify="interWord"><span color="#ffff00" fontFamily="CopprplGoth Bd BT" fontSize="20" fontStyle="normal" fontWeight="normal" kerning="on" lineHeight="120%" textAlpha="1" textRotation="auto" trackingRight="0.00%">item unlocked!</span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
            RuntimeManager.getSingleton().addInstance(this,"description",new Rectangle(0,0,274.05,120.05),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="1" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="normal" embedFonts="false"><TextFlow blockProgression="tb" lineBreak="toFit" locale="en" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" textAlign="start" textAlignLast="start" textIndent="0" textJustify="interWord"><span color="#ffb400" fontFamily="Arial" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="on" lineHeight="120%" textAlpha="1" textRotation="auto" trackingRight="0.00%">Congratulations! You've unlocked ...</span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
         }
         finally
         {
            XML.setSettings(this.__cacheXMLSettings);
         }
         RuntimeManager.getSingleton().addInstanceComplete(this);
      }
   }
}
