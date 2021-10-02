package
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public dynamic class messageContainer extends MovieClip
   {
       
      
      public var message:TLFTextField;
      
      public var __cacheXMLSettings:Object;
      
      public function messageContainer()
      {
         super();
         RuntimeFontMapper.addFontMapEntry("[\'verdana*\',\'normal\',\'normal\']",["Verdana","normal","normal"]);
         this.__cacheXMLSettings = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            XML.prettyPrinting = false;
            RuntimeManager.getSingleton().addInstance(this,"message",new Rectangle(0,0,156,223),<tlfTextObject type="Paragraph" editPolicy="readSelect" columnCount="1" columnGap="12" verticalAlign="top" firstBaselineOffset="ascent" paddingLeft="0" paddingTop="0" paddingRight="0" paddingBottom="0" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="false"><TextFlow blockProgression="tb" direction="ltr" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p breakOpportunity="auto" direction="ltr" dominantBaseline="roman" justificationRule="auto" justificationStyle="prioritizeLeastAdjustment" leadingModel="romanUp" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" tabStops="s36 s72 s108 s144 s180" textAlign="justify" textAlignLast="start" textIndent="0" textJustify="interWord" textRotation="auto"><span baselineShift="0" cffHinting="horizontalStem" color="#999999" digitCase="default" digitWidth="default" dominantBaseline="roman" fontFamily="verdana*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="on" ligatureLevel="common" lineHeight="120%" lineThrough="false" locale="en" renderingMode="cff" textAlpha="1" textDecoration="none" trackingLeft="0%" trackingRight="0%">-Scroll bar in friends list.</span></p><p breakOpportunity="auto" direction="ltr" dominantBaseline="roman" justificationRule="auto" justificationStyle="prioritizeLeastAdjustment" leadingModel="romanUp" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" tabStops="s36 s72 s108 s144 s180" textAlign="justify" textAlignLast="start" textIndent="0" textJustify="interWord" textRotation="auto"><span baselineShift="0" cffHinting="horizontalStem" color="#999999" digitCase="default" digitWidth="default" dominantBaseline="roman" fontFamily="verdana*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="on" ligatureLevel="common" lineHeight="120%" lineThrough="false" locale="en" renderingMode="cff" textAlpha="1" textDecoration="none" trackingLeft="0%" trackingRight="0%">-Fixed casting of some spells such as the Medusa stone ability.</span></p><p breakOpportunity="auto" direction="ltr" dominantBaseline="roman" justificationRule="auto" justificationStyle="prioritizeLeastAdjustment" leadingModel="romanUp" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" tabStops="s36 s72 s108 s144 s180" textAlign="justify" textAlignLast="start" textIndent="0" textJustify="interWord" textRotation="auto"><span baselineShift="0" cffHinting="horizontalStem" color="#999999" digitCase="default" digitWidth="default" dominantBaseline="roman" fontFamily="verdana*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="on" ligatureLevel="common" lineHeight="120%" lineThrough="false" locale="en" renderingMode="cff" textAlpha="1" textDecoration="none" trackingLeft="0%" trackingRight="0%">-Fixed issues with the Chaos tower not being destroyed and increased its damage output.</span></p><p breakOpportunity="auto" dominantBaseline="roman" justificationRule="auto" justificationStyle="prioritizeLeastAdjustment" leadingModel="romanUp" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" tabStops="s36 s72 s108 s144 s180" textAlign="justify" textAlignLast="start" textIndent="0" textJustify="interWord" textRotation="auto"><span baselineShift="0" cffHinting="horizontalStem" color="#999999" digitCase="default" digitWidth="default" dominantBaseline="roman" fontFamily="verdana*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="on" ligatureLevel="common" lineHeight="120%" lineThrough="false" locale="en" renderingMode="cff" textAlpha="1" textDecoration="none" trackingLeft="0%" trackingRight="0%">-Fixed issue where pressing space bar would not select all of your units.</span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
         }
         finally
         {
            XML.setSettings(this.__cacheXMLSettings);
         }
         RuntimeManager.getSingleton().addInstanceComplete(this);
      }
   }
}
