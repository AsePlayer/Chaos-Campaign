package
{
   import adobe.utils.*;
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class armoryScreenMc extends MovieClip
   {
       
      
      public var editCard:editCardMc;
      
      public var paymentScreen:paymentPanelMc;
      
      public var unitDisplayBox:MovieClip;
      
      public var unlockChaosScreen:unlockChaosScreenMc;
      
      public var upDisabled:MovieClip;
      
      public var cardContainer:MovieClip;
      
      public var unlockMc:buyItemMc;
      
      public var __id6_:MovieClip;
      
      public var addPointsButton:SimpleButton;
      
      public var armorButton:MovieClip;
      
      public var empiresPoints:TextField;
      
      public var weaponButton:MovieClip;
      
      public var orderButton:MovieClip;
      
      public var downButton:SimpleButton;
      
      public var pillar:MovieClip;
      
      public var bottomPanel:MovieClip;
      
      public var teamBanner:MovieClip;
      
      public var chaosButton:MovieClip;
      
      public var miscButton:MovieClip;
      
      public var downDisabled:MovieClip;
      
      public var itemUnlockResult:itemUnlockResultMc;
      
      public var upButton:SimpleButton;
      
      public var __animFactory___id6_af1:AnimatorFactory3D;
      
      public var __animArray___id6_af1:Array;
      
      public var ____motion___id6_af1_mat3DVec__:Vector.<Number>;
      
      public var ____motion___id6_af1_matArray__:Array;
      
      public var __motion___id6_af1:MotionBase;
      
      public var __animFactory_cardContaineraf1:AnimatorFactory3D;
      
      public var __animArray_cardContaineraf1:Array;
      
      public var ____motion_cardContaineraf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_cardContaineraf1_matArray__:Array;
      
      public var __motion_cardContaineraf1:MotionBase;
      
      public function armoryScreenMc()
      {
         super();
         if(this.__animFactory___id6_af1 == null)
         {
            this.__animArray___id6_af1 = new Array();
            this.__motion___id6_af1 = new MotionBase();
            this.__motion___id6_af1.duration = 1;
            this.__motion___id6_af1.overrideTargetTransform();
            this.__motion___id6_af1.addPropertyArray("visible",[true]);
            this.__motion___id6_af1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion___id6_af1.addPropertyArray("blendMode",["normal"]);
            this.__motion___id6_af1.addPropertyArray("opaqueBackground",[null]);
            this.__motion___id6_af1.is3D = true;
            this.__motion___id6_af1.motion_internal::spanStart = 0;
            this.____motion___id6_af1_matArray__ = new Array();
            this.____motion___id6_af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion___id6_af1_mat3DVec__[0] = 1;
            this.____motion___id6_af1_mat3DVec__[1] = 0;
            this.____motion___id6_af1_mat3DVec__[2] = 0;
            this.____motion___id6_af1_mat3DVec__[3] = 0;
            this.____motion___id6_af1_mat3DVec__[4] = 0;
            this.____motion___id6_af1_mat3DVec__[5] = 1;
            this.____motion___id6_af1_mat3DVec__[6] = 0;
            this.____motion___id6_af1_mat3DVec__[7] = 0;
            this.____motion___id6_af1_mat3DVec__[8] = 0;
            this.____motion___id6_af1_mat3DVec__[9] = 0;
            this.____motion___id6_af1_mat3DVec__[10] = 1;
            this.____motion___id6_af1_mat3DVec__[11] = 0;
            this.____motion___id6_af1_mat3DVec__[12] = 425;
            this.____motion___id6_af1_mat3DVec__[13] = 350;
            this.____motion___id6_af1_mat3DVec__[14] = 0;
            this.____motion___id6_af1_mat3DVec__[15] = 1;
            this.____motion___id6_af1_matArray__.push(new Matrix3D(this.____motion___id6_af1_mat3DVec__));
            this.__motion___id6_af1.addPropertyArray("matrix3D",this.____motion___id6_af1_matArray__);
            this.__animArray___id6_af1.push(this.__motion___id6_af1);
            this.__animFactory___id6_af1 = new AnimatorFactory3D(null,this.__animArray___id6_af1);
            this.__animFactory___id6_af1.addTargetInfo(this,"__id6_",0,true,0,true,null,-1);
         }
         if(this.__animFactory_cardContaineraf1 == null)
         {
            this.__animArray_cardContaineraf1 = new Array();
            this.__motion_cardContaineraf1 = new MotionBase();
            this.__motion_cardContaineraf1.duration = 1;
            this.__motion_cardContaineraf1.overrideTargetTransform();
            this.__motion_cardContaineraf1.addPropertyArray("visible",[true]);
            this.__motion_cardContaineraf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_cardContaineraf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_cardContaineraf1.addPropertyArray("opaqueBackground",[null]);
            this.__motion_cardContaineraf1.is3D = true;
            this.__motion_cardContaineraf1.motion_internal::spanStart = 0;
            this.____motion_cardContaineraf1_matArray__ = new Array();
            this.____motion_cardContaineraf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_cardContaineraf1_mat3DVec__[0] = 1;
            this.____motion_cardContaineraf1_mat3DVec__[1] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[2] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[3] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[4] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[5] = 1;
            this.____motion_cardContaineraf1_mat3DVec__[6] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[7] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[8] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[9] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[10] = 1;
            this.____motion_cardContaineraf1_mat3DVec__[11] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[12] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[13] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[14] = 0;
            this.____motion_cardContaineraf1_mat3DVec__[15] = 1;
            this.____motion_cardContaineraf1_matArray__.push(new Matrix3D(this.____motion_cardContaineraf1_mat3DVec__));
            this.__motion_cardContaineraf1.addPropertyArray("matrix3D",this.____motion_cardContaineraf1_matArray__);
            this.__animArray_cardContaineraf1.push(this.__motion_cardContaineraf1);
            this.__animFactory_cardContaineraf1 = new AnimatorFactory3D(null,this.__animArray_cardContaineraf1);
            this.__animFactory_cardContaineraf1.addTargetInfo(this,"cardContainer",0,true,0,true,null,-1);
         }
      }
   }
}
