package com.google.analytics.v4
{
   import com.google.analytics.core.EventTracker;
   import com.google.analytics.core.ServerOperationMode;
   
   public interface GoogleAnalyticsAPI
   {
       
      
      function setCampSourceKey(newCampSrcKey:String) : void;
      
      function getServiceMode() : ServerOperationMode;
      
      function resetSession() : void;
      
      function setLocalServerMode() : void;
      
      function setCampContentKey(newCampContentKey:String) : void;
      
      function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void;
      
      function setDetectFlash(enable:Boolean) : void;
      
      function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : Object;
      
      function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean;
      
      function setCampTermKey(newCampTermKey:String) : void;
      
      function setCampNameKey(newCampNameKey:String) : void;
      
      function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void;
      
      function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void;
      
      function setAllowLinker(enable:Boolean) : void;
      
      function getClientInfo() : Boolean;
      
      function getDetectFlash() : Boolean;
      
      function setCampaignTrack(enable:Boolean) : void;
      
      function createEventTracker(objName:String) : EventTracker;
      
      function setCookieTimeout(newDefaultTimeout:int) : void;
      
      function setAllowAnchor(enable:Boolean) : void;
      
      function trackTrans() : void;
      
      function clearOrganic() : void;
      
      function trackPageview(pageURL:String = "") : void;
      
      function setLocalGifPath(newLocalGifPath:String) : void;
      
      function getVersion() : String;
      
      function getLocalGifPath() : String;
      
      function setVar(newVal:String) : void;
      
      function clearIgnoredOrganic() : void;
      
      function setCampMediumKey(newCampMedKey:String) : void;
      
      function addIgnoredRef(newIgnoredReferrer:String) : void;
      
      function setClientInfo(enable:Boolean) : void;
      
      function setCookiePath(newCookiePath:String) : void;
      
      function setSampleRate(newRate:Number) : void;
      
      function setSessionTimeout(newTimeout:int) : void;
      
      function setRemoteServerMode() : void;
      
      function clearIgnoredRef() : void;
      
      function setDomainName(newDomainName:String) : void;
      
      function setDetectTitle(enable:Boolean) : void;
      
      function setAllowHash(enable:Boolean) : void;
      
      function getAccount() : String;
      
      function linkByPost(formObject:Object, useHash:Boolean = false) : void;
      
      function link(targetUrl:String, useHash:Boolean = false) : void;
      
      function setCampNOKey(newCampNOKey:String) : void;
      
      function setLocalRemoteServerMode() : void;
      
      function cookiePathCopy(newPath:String) : void;
      
      function getDetectTitle() : Boolean;
   }
}
