package flashx.textLayout.elements
{
   import flash.events.IEventDispatcher;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.events.ModelChange;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   [IMXMLObject]
   public class FlowElement implements ITextLayoutFormat
   {
      
      private static const idString:String = "id";
      
      private static const typeNameString:String = "typeName";
      
      private static const impliedElementString:String = "impliedElement";
      
      tlf_internal static var _scratchTextLayoutFormat:TextLayoutFormat = new TextLayoutFormat();
       
      
      private var _parent:FlowGroupElement;
      
      private var _format:FlowValueHolder;
      
      protected var _computedFormat:TextLayoutFormat;
      
      private var _parentRelativeStart:int = 0;
      
      private var _textLength:int = 0;
      
      public function FlowElement()
      {
         super();
         if(this.abstract)
         {
            throw new Error(GlobalSettings.resourceStringFunction("invalidFlowElementConstruct"));
         }
      }
      
      tlf_internal static function createTextLayoutFormatPrototype(localStyles:ITextLayoutFormat, parentPrototype:TextLayoutFormat) : TextLayoutFormat
      {
         var parentStylesPrototype:Object = null;
         var key:* = null;
         var val:* = undefined;
         var prop:Property = null;
         var rslt:TextLayoutFormat = null;
         var noInheritParentStylesPrototype:Object = null;
         var lvh:TextLayoutFormat = null;
         var coreStyles:Object = null;
         var parentPrototypeUsable:Boolean = true;
         var hasStylesSet:Boolean = false;
         if(parentPrototype)
         {
            parentStylesPrototype = parentPrototype.getStyles();
            if(parentStylesPrototype.hasNonInheritedStyles !== undefined)
            {
               if(parentStylesPrototype.hasNonInheritedStyles === true)
               {
                  noInheritParentStylesPrototype = Property.createObjectWithPrototype(parentStylesPrototype);
                  TextLayoutFormat.resetModifiedNoninheritedStyles(noInheritParentStylesPrototype);
                  parentStylesPrototype.hasNonInheritedStyles = noInheritParentStylesPrototype;
                  parentStylesPrototype = noInheritParentStylesPrototype;
               }
               else
               {
                  parentStylesPrototype = parentStylesPrototype.hasNonInheritedStyles;
               }
               parentPrototypeUsable = false;
            }
         }
         else
         {
            parentPrototype = TextLayoutFormat.defaultFormat as TextLayoutFormat;
            parentStylesPrototype = parentPrototype.getStyles();
         }
         var stylesObject:Object = Property.createObjectWithPrototype(parentStylesPrototype);
         var hasNonInheritedStyles:Boolean = false;
         if(localStyles != null)
         {
            lvh = localStyles as TextLayoutFormat;
            if(lvh)
            {
               coreStyles = lvh.getStyles();
               for(key in coreStyles)
               {
                  val = coreStyles[key];
                  if(val == FormatValue.INHERIT)
                  {
                     if(parentPrototype)
                     {
                        prop = TextLayoutFormat.description[key];
                        if(prop && !prop.inherited)
                        {
                           val = parentPrototype[key];
                           if(stylesObject[key] != val)
                           {
                              stylesObject[key] = val;
                              hasNonInheritedStyles = true;
                              hasStylesSet = true;
                           }
                        }
                     }
                  }
                  else if(stylesObject[key] != val)
                  {
                     prop = TextLayoutFormat.description[key];
                     if(prop && !prop.inherited)
                     {
                        hasNonInheritedStyles = true;
                     }
                     stylesObject[key] = val;
                     hasStylesSet = true;
                  }
               }
            }
            else
            {
               for each(prop in TextLayoutFormat.description)
               {
                  key = prop.name;
                  val = localStyles[key];
                  if(val !== undefined)
                  {
                     if(val == FormatValue.INHERIT)
                     {
                        if(parentPrototype)
                        {
                           if(!prop.inherited)
                           {
                              val = parentPrototype[key];
                              if(stylesObject[key] != val)
                              {
                                 stylesObject[key] = val;
                                 hasNonInheritedStyles = true;
                                 hasStylesSet = true;
                              }
                           }
                        }
                     }
                     else if(stylesObject[key] != val)
                     {
                        if(!prop.inherited)
                        {
                           hasNonInheritedStyles = true;
                        }
                        stylesObject[key] = val;
                        hasStylesSet = true;
                     }
                  }
               }
            }
         }
         if(!hasStylesSet)
         {
            if(parentPrototypeUsable)
            {
               return parentPrototype;
            }
            rslt = new TextLayoutFormat();
            rslt.setStyles(stylesObject,true);
            return rslt;
         }
         if(hasNonInheritedStyles)
         {
            stylesObject.hasNonInheritedStyles = true;
            stylesObject.setPropertyIsEnumerable("hasNonInheritedStyles",false);
         }
         else if(stylesObject.hasNonInheritedStyles !== undefined)
         {
            stylesObject.hasNonInheritedStyles = undefined;
            stylesObject.setPropertyIsEnumerable("hasNonInheritedStyles",false);
         }
         rslt = new TextLayoutFormat();
         rslt.setStyles(stylesObject,false);
         return rslt;
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
      }
      
      protected function get abstract() : Boolean
      {
         return true;
      }
      
      public function get userStyles() : Object
      {
         return Boolean(this._format) ? this._format.userStyles : null;
      }
      
      public function set userStyles(styles:Object) : void
      {
         var val:* = null;
         for(val in this.userStyles)
         {
            this.setStyle(val,undefined);
         }
         for(val in styles)
         {
            if(!TextLayoutFormat.description.hasOwnProperty(val))
            {
               this.setStyle(val,styles[val]);
            }
         }
      }
      
      public function get coreStyles() : Object
      {
         return Boolean(this._format) ? this._format.coreStyles : null;
      }
      
      public function get styles() : Object
      {
         return Boolean(this._format) ? this._format.styles : null;
      }
      
      tlf_internal function setStylesInternal(styles:Object) : void
      {
         if(styles)
         {
            this.writableTextLayoutFormat().setStyles(Property.shallowCopy(styles),false);
         }
         else if(this._format)
         {
            this._format.clearStyles();
         }
         this.formatChanged();
      }
      
      public function equalUserStyles(otherElement:FlowElement) : Boolean
      {
         return Property.equalStyles(this.userStyles,otherElement.userStyles,null);
      }
      
      tlf_internal function equalStylesForMerge(elem:FlowElement) : Boolean
      {
         return this.id == elem.id && this.typeName == elem.typeName && TextLayoutFormat.isEqual(elem.format,this.format);
      }
      
      public function shallowCopy(relativeStart:int = 0, relativeEnd:int = -1) : FlowElement
      {
         var retFlow:FlowElement = new (getDefinitionByName(getQualifiedClassName(this)) as Class)();
         if(this._format != null)
         {
            retFlow._format = new FlowValueHolder(this._format);
         }
         return retFlow;
      }
      
      public function deepCopy(relativeStart:int = 0, relativeEnd:int = -1) : FlowElement
      {
         if(relativeEnd == -1)
         {
            relativeEnd = this._textLength;
         }
         return this.shallowCopy(relativeStart,relativeEnd);
      }
      
      public function getText(relativeStart:int = 0, relativeEnd:int = -1, paragraphSeparator:String = "\n") : String
      {
         return "";
      }
      
      public function splitAtPosition(relativePosition:int) : FlowElement
      {
         if(relativePosition < 0 || relativePosition > this._textLength)
         {
            throw RangeError(GlobalSettings.resourceStringFunction("invalidSplitAtPosition"));
         }
         return this;
      }
      
      tlf_internal function get bindableElement() : Boolean
      {
         return this.getPrivateStyle("bindable") == true;
      }
      
      tlf_internal function set bindableElement(value:Boolean) : void
      {
         this.setPrivateStyle("bindable",value);
      }
      
      tlf_internal function mergeToPreviousIfPossible() : Boolean
      {
         return false;
      }
      
      tlf_internal function createContentElement() : void
      {
      }
      
      tlf_internal function releaseContentElement() : void
      {
      }
      
      public function get parent() : FlowGroupElement
      {
         return this._parent;
      }
      
      tlf_internal function setParentAndRelativeStart(newParent:FlowGroupElement, newStart:int) : void
      {
         this._parent = newParent;
         this._parentRelativeStart = newStart;
         this.attributesChanged(false);
      }
      
      tlf_internal function setParentAndRelativeStartOnly(newParent:FlowGroupElement, newStart:int) : void
      {
         this._parent = newParent;
         this._parentRelativeStart = newStart;
      }
      
      public function get textLength() : int
      {
         return this._textLength;
      }
      
      tlf_internal function setTextLength(newLength:int) : void
      {
         this._textLength = newLength;
      }
      
      public function get parentRelativeStart() : int
      {
         return this._parentRelativeStart;
      }
      
      tlf_internal function setParentRelativeStart(newStart:int) : void
      {
         this._parentRelativeStart = newStart;
      }
      
      public function get parentRelativeEnd() : int
      {
         return this._parentRelativeStart + this._textLength;
      }
      
      tlf_internal function getAncestorWithContainer() : ContainerFormattedElement
      {
         var contElement:ContainerFormattedElement = null;
         var elem:FlowElement = this;
         while(elem)
         {
            contElement = elem as ContainerFormattedElement;
            if(contElement)
            {
               if(!contElement._parent || contElement.flowComposer)
               {
                  return contElement;
               }
            }
            elem = elem._parent;
         }
         return null;
      }
      
      tlf_internal function getPrivateStyle(styleName:String) : *
      {
         return Boolean(this._format) ? this._format.getPrivateData(styleName) : undefined;
      }
      
      tlf_internal function setPrivateStyle(styleName:String, val:*) : void
      {
         if(this.getPrivateStyle(styleName) != val)
         {
            this.writableTextLayoutFormat().setPrivateData(styleName,val);
            this.modelChanged(ModelChange.STYLE_SELECTOR_CHANGED,this,0,this._textLength);
         }
      }
      
      public function get id() : String
      {
         return this.getPrivateStyle(idString);
      }
      
      public function set id(val:String) : void
      {
         return this.setPrivateStyle(idString,val);
      }
      
      public function get typeName() : String
      {
         var typeName:String = this.getPrivateStyle(typeNameString);
         return Boolean(typeName) ? typeName : this.defaultTypeName;
      }
      
      public function set typeName(val:String) : void
      {
         if(val != this.typeName)
         {
            this.setPrivateStyle(typeNameString,val == this.defaultTypeName ? undefined : val);
         }
      }
      
      tlf_internal function get defaultTypeName() : String
      {
         return null;
      }
      
      tlf_internal function get impliedElement() : Boolean
      {
         return this.getPrivateStyle(impliedElementString) !== undefined;
      }
      
      tlf_internal function set impliedElement(value:*) : void
      {
         this.setPrivateStyle(impliedElementString,value);
      }
      
      public function get color() : *
      {
         return Boolean(this._format) ? this._format.color : undefined;
      }
      
      public function set color(colorValue:*) : void
      {
         this.writableTextLayoutFormat().color = colorValue;
         this.formatChanged();
      }
      
      public function get backgroundColor() : *
      {
         return Boolean(this._format) ? this._format.backgroundColor : undefined;
      }
      
      public function set backgroundColor(backgroundColorValue:*) : void
      {
         this.writableTextLayoutFormat().backgroundColor = backgroundColorValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="true,false,inherit")]
      public function get lineThrough() : *
      {
         return Boolean(this._format) ? this._format.lineThrough : undefined;
      }
      
      public function set lineThrough(lineThroughValue:*) : void
      {
         this.writableTextLayoutFormat().lineThrough = lineThroughValue;
         this.formatChanged();
      }
      
      public function get textAlpha() : *
      {
         return Boolean(this._format) ? this._format.textAlpha : undefined;
      }
      
      public function set textAlpha(textAlphaValue:*) : void
      {
         this.writableTextLayoutFormat().textAlpha = textAlphaValue;
         this.formatChanged();
      }
      
      public function get backgroundAlpha() : *
      {
         return Boolean(this._format) ? this._format.backgroundAlpha : undefined;
      }
      
      public function set backgroundAlpha(backgroundAlphaValue:*) : void
      {
         this.writableTextLayoutFormat().backgroundAlpha = backgroundAlphaValue;
         this.formatChanged();
      }
      
      public function get fontSize() : *
      {
         return Boolean(this._format) ? this._format.fontSize : undefined;
      }
      
      public function set fontSize(fontSizeValue:*) : void
      {
         this.writableTextLayoutFormat().fontSize = fontSizeValue;
         this.formatChanged();
      }
      
      public function get baselineShift() : *
      {
         return Boolean(this._format) ? this._format.baselineShift : undefined;
      }
      
      public function set baselineShift(baselineShiftValue:*) : void
      {
         this.writableTextLayoutFormat().baselineShift = baselineShiftValue;
         this.formatChanged();
      }
      
      public function get trackingLeft() : *
      {
         return Boolean(this._format) ? this._format.trackingLeft : undefined;
      }
      
      public function set trackingLeft(trackingLeftValue:*) : void
      {
         this.writableTextLayoutFormat().trackingLeft = trackingLeftValue;
         this.formatChanged();
      }
      
      public function get trackingRight() : *
      {
         return Boolean(this._format) ? this._format.trackingRight : undefined;
      }
      
      public function set trackingRight(trackingRightValue:*) : void
      {
         this.writableTextLayoutFormat().trackingRight = trackingRightValue;
         this.formatChanged();
      }
      
      public function get lineHeight() : *
      {
         return Boolean(this._format) ? this._format.lineHeight : undefined;
      }
      
      public function set lineHeight(lineHeightValue:*) : void
      {
         this.writableTextLayoutFormat().lineHeight = lineHeightValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="all,any,auto,none,inherit")]
      public function get breakOpportunity() : *
      {
         return Boolean(this._format) ? this._format.breakOpportunity : undefined;
      }
      
      public function set breakOpportunity(breakOpportunityValue:*) : void
      {
         this.writableTextLayoutFormat().breakOpportunity = breakOpportunityValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="default,lining,oldStyle,inherit")]
      public function get digitCase() : *
      {
         return Boolean(this._format) ? this._format.digitCase : undefined;
      }
      
      public function set digitCase(digitCaseValue:*) : void
      {
         this.writableTextLayoutFormat().digitCase = digitCaseValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="default,proportional,tabular,inherit")]
      public function get digitWidth() : *
      {
         return Boolean(this._format) ? this._format.digitWidth : undefined;
      }
      
      public function set digitWidth(digitWidthValue:*) : void
      {
         this.writableTextLayoutFormat().digitWidth = digitWidthValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom,inherit")]
      public function get dominantBaseline() : *
      {
         return Boolean(this._format) ? this._format.dominantBaseline : undefined;
      }
      
      public function set dominantBaseline(dominantBaselineValue:*) : void
      {
         this.writableTextLayoutFormat().dominantBaseline = dominantBaselineValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="on,off,auto,inherit")]
      public function get kerning() : *
      {
         return Boolean(this._format) ? this._format.kerning : undefined;
      }
      
      public function set kerning(kerningValue:*) : void
      {
         this.writableTextLayoutFormat().kerning = kerningValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="minimum,common,uncommon,exotic,inherit")]
      public function get ligatureLevel() : *
      {
         return Boolean(this._format) ? this._format.ligatureLevel : undefined;
      }
      
      public function set ligatureLevel(ligatureLevelValue:*) : void
      {
         this.writableTextLayoutFormat().ligatureLevel = ligatureLevelValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom,useDominantBaseline,inherit")]
      public function get alignmentBaseline() : *
      {
         return Boolean(this._format) ? this._format.alignmentBaseline : undefined;
      }
      
      public function set alignmentBaseline(alignmentBaselineValue:*) : void
      {
         this.writableTextLayoutFormat().alignmentBaseline = alignmentBaselineValue;
         this.formatChanged();
      }
      
      public function get locale() : *
      {
         return Boolean(this._format) ? this._format.locale : undefined;
      }
      
      public function set locale(localeValue:*) : void
      {
         this.writableTextLayoutFormat().locale = localeValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps,inherit")]
      public function get typographicCase() : *
      {
         return Boolean(this._format) ? this._format.typographicCase : undefined;
      }
      
      public function set typographicCase(typographicCaseValue:*) : void
      {
         this.writableTextLayoutFormat().typographicCase = typographicCaseValue;
         this.formatChanged();
      }
      
      public function get fontFamily() : *
      {
         return Boolean(this._format) ? this._format.fontFamily : undefined;
      }
      
      public function set fontFamily(fontFamilyValue:*) : void
      {
         this.writableTextLayoutFormat().fontFamily = fontFamilyValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="none,underline,inherit")]
      public function get textDecoration() : *
      {
         return Boolean(this._format) ? this._format.textDecoration : undefined;
      }
      
      public function set textDecoration(textDecorationValue:*) : void
      {
         this.writableTextLayoutFormat().textDecoration = textDecorationValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="normal,bold,inherit")]
      public function get fontWeight() : *
      {
         return Boolean(this._format) ? this._format.fontWeight : undefined;
      }
      
      public function set fontWeight(fontWeightValue:*) : void
      {
         this.writableTextLayoutFormat().fontWeight = fontWeightValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="normal,italic,inherit")]
      public function get fontStyle() : *
      {
         return Boolean(this._format) ? this._format.fontStyle : undefined;
      }
      
      public function set fontStyle(fontStyleValue:*) : void
      {
         this.writableTextLayoutFormat().fontStyle = fontStyleValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="preserve,collapse,inherit")]
      public function get whiteSpaceCollapse() : *
      {
         return Boolean(this._format) ? this._format.whiteSpaceCollapse : undefined;
      }
      
      public function set whiteSpaceCollapse(whiteSpaceCollapseValue:*) : void
      {
         this.writableTextLayoutFormat().whiteSpaceCollapse = whiteSpaceCollapseValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="normal,cff,inherit")]
      public function get renderingMode() : *
      {
         return Boolean(this._format) ? this._format.renderingMode : undefined;
      }
      
      public function set renderingMode(renderingModeValue:*) : void
      {
         this.writableTextLayoutFormat().renderingMode = renderingModeValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="none,horizontalStem,inherit")]
      public function get cffHinting() : *
      {
         return Boolean(this._format) ? this._format.cffHinting : undefined;
      }
      
      public function set cffHinting(cffHintingValue:*) : void
      {
         this.writableTextLayoutFormat().cffHinting = cffHintingValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="device,embeddedCFF,inherit")]
      public function get fontLookup() : *
      {
         return Boolean(this._format) ? this._format.fontLookup : undefined;
      }
      
      public function set fontLookup(fontLookupValue:*) : void
      {
         this.writableTextLayoutFormat().fontLookup = fontLookupValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="rotate0,rotate180,rotate270,rotate90,auto,inherit")]
      public function get textRotation() : *
      {
         return Boolean(this._format) ? this._format.textRotation : undefined;
      }
      
      public function set textRotation(textRotationValue:*) : void
      {
         this.writableTextLayoutFormat().textRotation = textRotationValue;
         this.formatChanged();
      }
      
      public function get textIndent() : *
      {
         return Boolean(this._format) ? this._format.textIndent : undefined;
      }
      
      public function set textIndent(textIndentValue:*) : void
      {
         this.writableTextLayoutFormat().textIndent = textIndentValue;
         this.formatChanged();
      }
      
      public function get paragraphStartIndent() : *
      {
         return Boolean(this._format) ? this._format.paragraphStartIndent : undefined;
      }
      
      public function set paragraphStartIndent(paragraphStartIndentValue:*) : void
      {
         this.writableTextLayoutFormat().paragraphStartIndent = paragraphStartIndentValue;
         this.formatChanged();
      }
      
      public function get paragraphEndIndent() : *
      {
         return Boolean(this._format) ? this._format.paragraphEndIndent : undefined;
      }
      
      public function set paragraphEndIndent(paragraphEndIndentValue:*) : void
      {
         this.writableTextLayoutFormat().paragraphEndIndent = paragraphEndIndentValue;
         this.formatChanged();
      }
      
      public function get paragraphSpaceBefore() : *
      {
         return Boolean(this._format) ? this._format.paragraphSpaceBefore : undefined;
      }
      
      public function set paragraphSpaceBefore(paragraphSpaceBeforeValue:*) : void
      {
         this.writableTextLayoutFormat().paragraphSpaceBefore = paragraphSpaceBeforeValue;
         this.formatChanged();
      }
      
      public function get paragraphSpaceAfter() : *
      {
         return Boolean(this._format) ? this._format.paragraphSpaceAfter : undefined;
      }
      
      public function set paragraphSpaceAfter(paragraphSpaceAfterValue:*) : void
      {
         this.writableTextLayoutFormat().paragraphSpaceAfter = paragraphSpaceAfterValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="left,right,center,justify,start,end,inherit")]
      public function get textAlign() : *
      {
         return Boolean(this._format) ? this._format.textAlign : undefined;
      }
      
      public function set textAlign(textAlignValue:*) : void
      {
         this.writableTextLayoutFormat().textAlign = textAlignValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="left,right,center,justify,start,end,inherit")]
      public function get textAlignLast() : *
      {
         return Boolean(this._format) ? this._format.textAlignLast : undefined;
      }
      
      public function set textAlignLast(textAlignLastValue:*) : void
      {
         this.writableTextLayoutFormat().textAlignLast = textAlignLastValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="interWord,distribute,inherit")]
      public function get textJustify() : *
      {
         return Boolean(this._format) ? this._format.textJustify : undefined;
      }
      
      public function set textJustify(textJustifyValue:*) : void
      {
         this.writableTextLayoutFormat().textJustify = textJustifyValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="eastAsian,space,auto,inherit")]
      public function get justificationRule() : *
      {
         return Boolean(this._format) ? this._format.justificationRule : undefined;
      }
      
      public function set justificationRule(justificationRuleValue:*) : void
      {
         this.writableTextLayoutFormat().justificationRule = justificationRuleValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly,auto,inherit")]
      public function get justificationStyle() : *
      {
         return Boolean(this._format) ? this._format.justificationStyle : undefined;
      }
      
      public function set justificationStyle(justificationStyleValue:*) : void
      {
         this.writableTextLayoutFormat().justificationStyle = justificationStyleValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="ltr,rtl,inherit")]
      public function get direction() : *
      {
         return Boolean(this._format) ? this._format.direction : undefined;
      }
      
      public function set direction(directionValue:*) : void
      {
         this.writableTextLayoutFormat().direction = directionValue;
         this.formatChanged();
      }
      
      public function get wordSpacing() : *
      {
         return Boolean(this._format) ? this._format.wordSpacing : undefined;
      }
      
      public function set wordSpacing(wordSpacingValue:*) : void
      {
         this.writableTextLayoutFormat().wordSpacing = wordSpacingValue;
         this.formatChanged();
      }
      
      public function get tabStops() : *
      {
         return Boolean(this._format) ? this._format.tabStops : undefined;
      }
      
      public function set tabStops(tabStopsValue:*) : void
      {
         this.writableTextLayoutFormat().tabStops = tabStopsValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="romanUp,ideographicTopUp,ideographicCenterUp,ideographicTopDown,ideographicCenterDown,approximateTextField,ascentDescentUp,box,auto,inherit")]
      public function get leadingModel() : *
      {
         return Boolean(this._format) ? this._format.leadingModel : undefined;
      }
      
      public function set leadingModel(leadingModelValue:*) : void
      {
         this.writableTextLayoutFormat().leadingModel = leadingModelValue;
         this.formatChanged();
      }
      
      public function get columnGap() : *
      {
         return Boolean(this._format) ? this._format.columnGap : undefined;
      }
      
      public function set columnGap(columnGapValue:*) : void
      {
         this.writableTextLayoutFormat().columnGap = columnGapValue;
         this.formatChanged();
      }
      
      public function get paddingLeft() : *
      {
         return Boolean(this._format) ? this._format.paddingLeft : undefined;
      }
      
      public function set paddingLeft(paddingLeftValue:*) : void
      {
         this.writableTextLayoutFormat().paddingLeft = paddingLeftValue;
         this.formatChanged();
      }
      
      public function get paddingTop() : *
      {
         return Boolean(this._format) ? this._format.paddingTop : undefined;
      }
      
      public function set paddingTop(paddingTopValue:*) : void
      {
         this.writableTextLayoutFormat().paddingTop = paddingTopValue;
         this.formatChanged();
      }
      
      public function get paddingRight() : *
      {
         return Boolean(this._format) ? this._format.paddingRight : undefined;
      }
      
      public function set paddingRight(paddingRightValue:*) : void
      {
         this.writableTextLayoutFormat().paddingRight = paddingRightValue;
         this.formatChanged();
      }
      
      public function get paddingBottom() : *
      {
         return Boolean(this._format) ? this._format.paddingBottom : undefined;
      }
      
      public function set paddingBottom(paddingBottomValue:*) : void
      {
         this.writableTextLayoutFormat().paddingBottom = paddingBottomValue;
         this.formatChanged();
      }
      
      public function get columnCount() : *
      {
         return Boolean(this._format) ? this._format.columnCount : undefined;
      }
      
      public function set columnCount(columnCountValue:*) : void
      {
         this.writableTextLayoutFormat().columnCount = columnCountValue;
         this.formatChanged();
      }
      
      public function get columnWidth() : *
      {
         return Boolean(this._format) ? this._format.columnWidth : undefined;
      }
      
      public function set columnWidth(columnWidthValue:*) : void
      {
         this.writableTextLayoutFormat().columnWidth = columnWidthValue;
         this.formatChanged();
      }
      
      public function get firstBaselineOffset() : *
      {
         return Boolean(this._format) ? this._format.firstBaselineOffset : undefined;
      }
      
      public function set firstBaselineOffset(firstBaselineOffsetValue:*) : void
      {
         this.writableTextLayoutFormat().firstBaselineOffset = firstBaselineOffsetValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="top,middle,bottom,justify,inherit")]
      public function get verticalAlign() : *
      {
         return Boolean(this._format) ? this._format.verticalAlign : undefined;
      }
      
      public function set verticalAlign(verticalAlignValue:*) : void
      {
         this.writableTextLayoutFormat().verticalAlign = verticalAlignValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="rl,tb,inherit")]
      public function get blockProgression() : *
      {
         return Boolean(this._format) ? this._format.blockProgression : undefined;
      }
      
      public function set blockProgression(blockProgressionValue:*) : void
      {
         this.writableTextLayoutFormat().blockProgression = blockProgressionValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="explicit,toFit,inherit")]
      public function get lineBreak() : *
      {
         return Boolean(this._format) ? this._format.lineBreak : undefined;
      }
      
      public function set lineBreak(lineBreakValue:*) : void
      {
         this.writableTextLayoutFormat().lineBreak = lineBreakValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="upperAlpha,lowerAlpha,upperRoman,lowerRoman,none,disc,circle,square,box,check,diamond,hyphen,arabicIndic,bengali,decimal,decimalLeadingZero,devanagari,gujarati,gurmukhi,kannada,persian,thai,urdu,cjkEarthlyBranch,cjkHeavenlyStem,hangul,hangulConstant,hiragana,hiraganaIroha,katakana,katakanaIroha,lowerAlpha,lowerGreek,lowerLatin,upperAlpha,upperGreek,upperLatin,inherit")]
      public function get listStyleType() : *
      {
         return Boolean(this._format) ? this._format.listStyleType : undefined;
      }
      
      public function set listStyleType(listStyleTypeValue:*) : void
      {
         this.writableTextLayoutFormat().listStyleType = listStyleTypeValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="inside,outside,inherit")]
      public function get listStylePosition() : *
      {
         return Boolean(this._format) ? this._format.listStylePosition : undefined;
      }
      
      public function set listStylePosition(listStylePositionValue:*) : void
      {
         this.writableTextLayoutFormat().listStylePosition = listStylePositionValue;
         this.formatChanged();
      }
      
      public function get listAutoPadding() : *
      {
         return Boolean(this._format) ? this._format.listAutoPadding : undefined;
      }
      
      public function set listAutoPadding(listAutoPaddingValue:*) : void
      {
         this.writableTextLayoutFormat().listAutoPadding = listAutoPaddingValue;
         this.formatChanged();
      }
      
      [Inspectable(enumeration="start,end,left,right,both,none,inherit")]
      public function get clearFloats() : *
      {
         return Boolean(this._format) ? this._format.clearFloats : undefined;
      }
      
      public function set clearFloats(clearFloatsValue:*) : void
      {
         this.writableTextLayoutFormat().clearFloats = clearFloatsValue;
         this.formatChanged();
      }
      
      public function get styleName() : *
      {
         return Boolean(this._format) ? this._format.styleName : undefined;
      }
      
      public function set styleName(styleNameValue:*) : void
      {
         this.writableTextLayoutFormat().styleName = styleNameValue;
         this.styleSelectorChanged();
      }
      
      public function get linkNormalFormat() : *
      {
         return Boolean(this._format) ? this._format.linkNormalFormat : undefined;
      }
      
      public function set linkNormalFormat(linkNormalFormatValue:*) : void
      {
         this.writableTextLayoutFormat().linkNormalFormat = linkNormalFormatValue;
         this.formatChanged();
      }
      
      public function get linkActiveFormat() : *
      {
         return Boolean(this._format) ? this._format.linkActiveFormat : undefined;
      }
      
      public function set linkActiveFormat(linkActiveFormatValue:*) : void
      {
         this.writableTextLayoutFormat().linkActiveFormat = linkActiveFormatValue;
         this.formatChanged();
      }
      
      public function get linkHoverFormat() : *
      {
         return Boolean(this._format) ? this._format.linkHoverFormat : undefined;
      }
      
      public function set linkHoverFormat(linkHoverFormatValue:*) : void
      {
         this.writableTextLayoutFormat().linkHoverFormat = linkHoverFormatValue;
         this.formatChanged();
      }
      
      public function get listMarkerFormat() : *
      {
         return Boolean(this._format) ? this._format.listMarkerFormat : undefined;
      }
      
      public function set listMarkerFormat(listMarkerFormatValue:*) : void
      {
         this.writableTextLayoutFormat().listMarkerFormat = listMarkerFormatValue;
         this.formatChanged();
      }
      
      public function get format() : ITextLayoutFormat
      {
         return this._format;
      }
      
      public function set format(value:ITextLayoutFormat) : void
      {
         if(value == this._format)
         {
            return;
         }
         var oldStyleName:String = this.styleName;
         if(value == null)
         {
            this._format.clearStyles();
         }
         else
         {
            this.writableTextLayoutFormat().copy(value);
         }
         this.formatChanged();
         if(oldStyleName != this.styleName)
         {
            this.styleSelectorChanged();
         }
      }
      
      tlf_internal function writableTextLayoutFormat() : FlowValueHolder
      {
         if(this._format == null)
         {
            this._format = new FlowValueHolder();
         }
         return this._format;
      }
      
      tlf_internal function formatChanged(notifyModelChanged:Boolean = true) : void
      {
         if(notifyModelChanged)
         {
            this.modelChanged(ModelChange.TEXTLAYOUT_FORMAT_CHANGED,this,0,this._textLength);
         }
         this._computedFormat = null;
      }
      
      tlf_internal function styleSelectorChanged() : void
      {
         this.modelChanged(ModelChange.STYLE_SELECTOR_CHANGED,this,0,this._textLength);
         this._computedFormat = null;
      }
      
      tlf_internal function get formatForCascade() : ITextLayoutFormat
      {
         var elemStyle:TextLayoutFormat = null;
         var localFormat:ITextLayoutFormat = null;
         var rslt:TextLayoutFormat = null;
         var tf:TextFlow = this.getTextFlow();
         if(tf)
         {
            elemStyle = tf.getTextLayoutFormatStyle(this);
            if(elemStyle)
            {
               localFormat = this.format;
               if(localFormat == null)
               {
                  return elemStyle;
               }
               rslt = new TextLayoutFormat();
               rslt.apply(elemStyle);
               rslt.apply(localFormat);
               return rslt;
            }
         }
         return this._format;
      }
      
      public function get computedFormat() : ITextLayoutFormat
      {
         if(this._computedFormat == null)
         {
            this._computedFormat = this.doComputeTextLayoutFormat();
         }
         return this._computedFormat;
      }
      
      tlf_internal function doComputeTextLayoutFormat() : TextLayoutFormat
      {
         var parentPrototype:TextLayoutFormat = Boolean(this._parent) ? TextLayoutFormat(this._parent.computedFormat) : null;
         return FlowElement.createTextLayoutFormatPrototype(this.formatForCascade,parentPrototype);
      }
      
      tlf_internal function attributesChanged(notifyModelChanged:Boolean = true) : void
      {
         this.formatChanged(notifyModelChanged);
      }
      
      public function getStyle(styleProp:String) : *
      {
         if(TextLayoutFormat.description.hasOwnProperty(styleProp))
         {
            return this.computedFormat.getStyle(styleProp);
         }
         var tf:TextFlow = this.getTextFlow();
         if(!tf || !tf.formatResolver)
         {
            return this.computedFormat.getStyle(styleProp);
         }
         return this.getUserStyleWorker(styleProp);
      }
      
      tlf_internal function getUserStyleWorker(styleProp:String) : *
      {
         var userStyle:* = undefined;
         if(this._format != null)
         {
            userStyle = this._format.getStyle(styleProp);
            if(userStyle !== undefined)
            {
               return userStyle;
            }
         }
         var tf:TextFlow = this.getTextFlow();
         if(tf && tf.formatResolver)
         {
            userStyle = tf.formatResolver.resolveUserFormat(this,styleProp);
            if(userStyle !== undefined)
            {
               return userStyle;
            }
         }
         return Boolean(this._parent) ? this._parent.getUserStyleWorker(styleProp) : undefined;
      }
      
      public function setStyle(styleProp:String, newValue:*) : void
      {
         if(TextLayoutFormat.description[styleProp])
         {
            this[styleProp] = newValue;
         }
         else
         {
            this.writableTextLayoutFormat().setStyle(styleProp,newValue);
            this.formatChanged();
         }
      }
      
      public function clearStyle(styleProp:String) : void
      {
         this.setStyle(styleProp,undefined);
      }
      
      tlf_internal function modelChanged(changeType:String, element:FlowElement, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true) : void
      {
         var tf:TextFlow = this.getTextFlow();
         if(tf)
         {
            tf.processModelChanged(changeType,element,this.getAbsoluteStart() + changeStart,changeLen,needNormalize,bumpGeneration);
         }
      }
      
      tlf_internal function appendElementsForDelayedUpdate(tf:TextFlow, changeType:String) : void
      {
      }
      
      tlf_internal function applyDelayedElementUpdate(textFlow:TextFlow, okToUnloadGraphics:Boolean, hasController:Boolean) : void
      {
      }
      
      tlf_internal function getEffectivePaddingLeft() : Number
      {
         return this.computedFormat.paddingLeft == FormatValue.AUTO ? Number(0) : Number(this.computedFormat.paddingLeft);
      }
      
      tlf_internal function getEffectivePaddingRight() : Number
      {
         return this.computedFormat.paddingRight == FormatValue.AUTO ? Number(0) : Number(this.computedFormat.paddingRight);
      }
      
      tlf_internal function getEffectivePaddingTop() : Number
      {
         return this.computedFormat.paddingTop == FormatValue.AUTO ? Number(0) : Number(this.computedFormat.paddingTop);
      }
      
      tlf_internal function getEffectivePaddingBottom() : Number
      {
         return this.computedFormat.paddingBottom == FormatValue.AUTO ? Number(0) : Number(this.computedFormat.paddingBottom);
      }
      
      public function set tracking(trackingValue:Object) : void
      {
         this.trackingRight = trackingValue;
      }
      
      tlf_internal function applyWhiteSpaceCollapse(collapse:String) : void
      {
         if(this.whiteSpaceCollapse !== undefined)
         {
            this.whiteSpaceCollapse = undefined;
         }
         this.setPrivateStyle(impliedElementString,undefined);
      }
      
      public function getAbsoluteStart() : int
      {
         var rslt:int = this._parentRelativeStart;
         for(var elem:FlowElement = this._parent; elem; elem = elem._parent)
         {
            rslt += elem._parentRelativeStart;
         }
         return rslt;
      }
      
      public function getElementRelativeStart(ancestorElement:FlowElement) : int
      {
         var rslt:int = this._parentRelativeStart;
         var elem:FlowElement = this._parent;
         while(elem && elem != ancestorElement)
         {
            rslt += elem._parentRelativeStart;
            elem = elem._parent;
         }
         return rslt;
      }
      
      public function getTextFlow() : TextFlow
      {
         var elem:FlowElement = this;
         while(elem._parent != null)
         {
            elem = elem._parent;
         }
         return elem as TextFlow;
      }
      
      public function getParagraph() : ParagraphElement
      {
         var para:ParagraphElement = null;
         var rslt:FlowElement = this;
         while(rslt)
         {
            para = rslt as ParagraphElement;
            if(para)
            {
               break;
            }
            rslt = rslt._parent;
         }
         return para;
      }
      
      public function getParentByType(elementType:Class) : FlowElement
      {
         var curElement:FlowElement = this._parent;
         while(curElement)
         {
            if(curElement is elementType)
            {
               return curElement;
            }
            curElement = curElement._parent;
         }
         return null;
      }
      
      public function getPreviousSibling() : FlowElement
      {
         if(!this._parent)
         {
            return null;
         }
         var idx:int = this._parent.getChildIndex(this);
         return idx == 0 ? null : this._parent.getChildAt(idx - 1);
      }
      
      public function getNextSibling() : FlowElement
      {
         if(!this._parent)
         {
            return null;
         }
         var idx:int = this._parent.getChildIndex(this);
         return idx == this._parent.numChildren - 1 ? null : this._parent.getChildAt(idx + 1);
      }
      
      public function getCharAtPosition(relativePosition:int) : String
      {
         return null;
      }
      
      public function getCharCodeAtPosition(relativePosition:int) : int
      {
         var str:String = this.getCharAtPosition(relativePosition);
         return str && str.length > 0 ? int(str.charCodeAt(0)) : int(0);
      }
      
      tlf_internal function applyFunctionToElements(func:Function) : Boolean
      {
         return func(this);
      }
      
      tlf_internal function getEventMirror() : IEventDispatcher
      {
         return null;
      }
      
      tlf_internal function hasActiveEventMirror() : Boolean
      {
         return false;
      }
      
      private function updateRange(len:int) : void
      {
         this.setParentRelativeStart(this._parentRelativeStart + len);
      }
      
      tlf_internal function updateLengths(startIdx:int, len:int, updateLines:Boolean) : void
      {
         var idx:int = 0;
         var pElementCount:int = 0;
         var child:FlowElement = null;
         this.setTextLength(this._textLength + len);
         var p:FlowGroupElement = this._parent;
         if(p)
         {
            idx = p.getChildIndex(this) + 1;
            pElementCount = p.numChildren;
            while(idx < pElementCount)
            {
               child = p.getChildAt(idx++);
               child.updateRange(len);
            }
            p.updateLengths(startIdx,len,updateLines);
         }
      }
      
      tlf_internal function getEnclosingController(relativePos:int) : ContainerController
      {
         var textFlow:TextFlow = this.getTextFlow();
         if(textFlow == null || textFlow.flowComposer == null)
         {
            return null;
         }
         var curItem:FlowElement = this;
         while(curItem && (!(curItem is ContainerFormattedElement) || ContainerFormattedElement(curItem).flowComposer == null))
         {
            curItem = curItem._parent;
         }
         var flowComposer:IFlowComposer = ContainerFormattedElement(curItem).flowComposer;
         if(!flowComposer)
         {
            return null;
         }
         var controllerIndex:int = ContainerFormattedElement(curItem).flowComposer.findControllerIndexAtPosition(this.getAbsoluteStart() + relativePos,false);
         return controllerIndex != -1 ? flowComposer.getControllerAt(controllerIndex) : null;
      }
      
      tlf_internal function deleteContainerText(endPos:int, deleteTotal:int) : void
      {
         var absoluteEndPos:int = 0;
         var absStartIdx:int = 0;
         var charsDeletedFromCurContainer:int = 0;
         var enclosingController:ContainerController = null;
         var enclosingControllerBeginningPos:int = 0;
         var containerTextLengthDelta:int = 0;
         var flowComposer:IFlowComposer = null;
         var myIdx:int = 0;
         var previousEnclosingWithContent:ContainerController = null;
         if(this.getTextFlow())
         {
            absoluteEndPos = this.getAbsoluteStart() + endPos;
            absStartIdx = absoluteEndPos - deleteTotal;
            while(deleteTotal > 0)
            {
               enclosingController = this.getEnclosingController(endPos - 1);
               if(!enclosingController)
               {
                  enclosingController = this.getEnclosingController(endPos - deleteTotal);
                  if(enclosingController)
                  {
                     flowComposer = enclosingController.flowComposer;
                     myIdx = flowComposer.getControllerIndex(enclosingController);
                     previousEnclosingWithContent = enclosingController;
                     while(myIdx + 1 < flowComposer.numControllers && enclosingController.absoluteStart + enclosingController.textLength < endPos)
                     {
                        enclosingController = flowComposer.getControllerAt(myIdx + 1);
                        if(enclosingController.textLength)
                        {
                           previousEnclosingWithContent = enclosingController;
                           break;
                        }
                        myIdx++;
                     }
                  }
                  if(!enclosingController || !enclosingController.textLength)
                  {
                     enclosingController = previousEnclosingWithContent;
                  }
                  if(!enclosingController)
                  {
                     break;
                  }
               }
               enclosingControllerBeginningPos = enclosingController.absoluteStart;
               if(absStartIdx < enclosingControllerBeginningPos)
               {
                  charsDeletedFromCurContainer = absoluteEndPos - enclosingControllerBeginningPos + 1;
               }
               else if(absStartIdx < enclosingControllerBeginningPos + enclosingController.textLength)
               {
                  charsDeletedFromCurContainer = deleteTotal;
               }
               containerTextLengthDelta = enclosingController.textLength < charsDeletedFromCurContainer ? int(enclosingController.textLength) : int(charsDeletedFromCurContainer);
               if(containerTextLengthDelta <= 0)
               {
                  break;
               }
               ContainerController(enclosingController).setTextLengthOnly(enclosingController.textLength - containerTextLengthDelta);
               deleteTotal -= containerTextLengthDelta;
               absoluteEndPos -= containerTextLengthDelta;
               endPos -= containerTextLengthDelta;
            }
         }
      }
      
      tlf_internal function normalizeRange(normalizeStart:uint, normalizeEnd:uint) : void
      {
      }
      
      tlf_internal function quickCloneTextLayoutFormat(sibling:FlowElement) : void
      {
         this._format = Boolean(sibling._format) ? new FlowValueHolder(sibling._format) : null;
         this._computedFormat = null;
      }
      
      tlf_internal function updateForMustUseComposer(textFlow:TextFlow) : Boolean
      {
         return false;
      }
   }
}
