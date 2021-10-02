package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class SelectedUnits
   {
       
      
      private var _selected:Array;
      
      private var gameScreen:GameScreen;
      
      private var profilePic:MovieClip;
      
      private var _unitTypes:Dictionary;
      
      private var unitTypeKeys:Array;
      
      private var currentUnitType:Number;
      
      private var _interactsWith:int;
      
      private var _hasFinishedSelecting:Boolean;
      
      private var _hasChanged:Boolean;
      
      public function SelectedUnits(gameScreen:GameScreen)
      {
         super();
         this.gameScreen = gameScreen;
         this.selected = new Array();
         this.profilePic = null;
         this.unitTypes = new Dictionary();
         this.unitTypeKeys = [];
         this.currentUnitType = -1;
         this._hasFinishedSelecting = true;
         this._hasChanged = false;
      }
      
      public function update(game:StickWar) : void
      {
         var i:int = 0;
         var d:DisplayObject = null;
         var m:MovieClip = null;
         if(this.profilePic != null)
         {
            if(game.gameScreen.hasEffects)
            {
               for(i = 0; i < this.profilePic.numChildren; i++)
               {
                  d = this.profilePic.getChildAt(i);
                  if(d is MovieClip)
                  {
                     m = MovieClip(d);
                     if(m.currentFrame == m.totalFrames)
                     {
                        m.gotoAndStop(1);
                     }
                     m.nextFrame();
                  }
               }
            }
         }
      }
      
      public function nextSelectedUnitType() : void
      {
         if(this.currentUnitType == -1)
         {
            return;
         }
         var i:int = this.unitTypeKeys.indexOf(this.currentUnitType);
         i = (i + 1) % this.unitTypeKeys.length;
         this.currentUnitType = this.unitTypeKeys[i];
         this.gameScreen.userInterface.actionInterface.setEntity(this._unitTypes[this.currentUnitType][0]);
         this.setProfilePic(this.gameScreen.game.unitFactory.getProfile(this.currentUnitType));
      }
      
      public function refresh(force:Boolean = false) : void
      {
         if(this.currentUnitType == -1)
         {
            return;
         }
         if(this._hasChanged || force)
         {
            this.gameScreen.userInterface.actionInterface.setEntity(this._unitTypes[this.currentUnitType][0]);
            this.setProfilePic(this.gameScreen.game.unitFactory.getProfile(this.currentUnitType));
         }
      }
      
      public function add(unit:Unit) : void
      {
         if(this.selected.indexOf(unit) != -1)
         {
            return;
         }
         this._hasChanged = true;
         if(this._interactsWith & Unit.I_IS_BUILDING || unit.interactsWith & Unit.I_IS_BUILDING)
         {
            this.clear();
         }
         if(unit.interactsWith & Unit.I_IS_BUILDING)
         {
            this.gameScreen.game.soundManager.playSoundFullVolume("MouseoverStructure");
         }
         this.selected.push(unit);
         if(!(unit.type in this.unitTypes))
         {
            this.unitTypes[unit.type] = [];
            this.currentUnitType = unit.type;
            this.unitTypeKeys.push(unit.type);
            this.unitTypeKeys.sort();
            this._interactsWith |= unit.interactsWith;
         }
         this.unitTypes[unit.type].push(unit);
         this.gameScreen.userInterface.actionInterface.setEntity(unit);
         this.setProfilePic(this.gameScreen.game.unitFactory.getProfile(unit.type));
      }
      
      public function getSelectedType() : Number
      {
         return this.currentUnitType;
      }
      
      public function setProfilePic(pic:MovieClip) : void
      {
         if(this.profilePic != null)
         {
            MovieClip(this.gameScreen.userInterface.hud.hud.profile).removeChild(this.profilePic);
         }
         if(pic != null)
         {
            MovieClip(this.gameScreen.userInterface.hud.hud.profile).addChild(pic);
         }
         this.profilePic = pic;
      }
      
      public function clear() : void
      {
         var key:* = undefined;
         var s:Unit = null;
         this._hasChanged = true;
         this._interactsWith = 0;
         this.currentUnitType = -1;
         this.gameScreen.userInterface.actionInterface.setEntity(null);
         for(key in this.unitTypes)
         {
            delete this.unitTypes[key];
         }
         for each(s in this.selected)
         {
            s.selected = false;
         }
         this.selected.splice(0,this.selected.length);
         this.unitTypeKeys.splice(0,this.unitTypeKeys.length);
         this.setProfilePic(null);
      }
      
      public function get unitTypes() : Dictionary
      {
         return this._unitTypes;
      }
      
      public function set unitTypes(value:Dictionary) : void
      {
         this._unitTypes = value;
      }
      
      public function get interactsWith() : int
      {
         return this._interactsWith;
      }
      
      public function set interactsWith(value:int) : void
      {
         this._interactsWith = value;
      }
      
      public function get hasFinishedSelecting() : Boolean
      {
         return this._hasFinishedSelecting;
      }
      
      public function set hasFinishedSelecting(value:Boolean) : void
      {
         this._hasFinishedSelecting = value;
      }
      
      public function get hasChanged() : Boolean
      {
         return this._hasChanged;
      }
      
      public function set hasChanged(value:Boolean) : void
      {
         this._hasChanged = value;
      }
      
      public function get selected() : Array
      {
         return this._selected;
      }
      
      public function set selected(value:Array) : void
      {
         this._selected = value;
      }
   }
}
