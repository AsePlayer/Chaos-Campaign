package com.brockw.stickwar.engine.Team
{
     import com.brockw.stickwar.engine.StickWar;
     import flash.utils.Dictionary;
     
     public class Tech
     {
          
          public static const MEELE_WEAPON_1:int = -1;
          
          public static const MEELE_ARMOUR_1:int = -2;
          
          public static const SWORDWRATH_RAGE:int = -3;
          
          public static const BLOCK:int = -4;
          
          public static const SPEAR_THROW:int = -5;
          
          public static const CLOAK:int = -6;
          
          public static const NINJA_CRITICAL_STRIKE:int = -7;
          
          public static const SPEARTON:int = -8;
          
          public static const NINJA:int = -9;
          
          public static const ARCHIDON:int = -10;
          
          public static const FLYING_CROSSBOWMAN:int = -11;
          
          public static const HARD_SHOT:int = -12;
          
          public static const FLYING_CROSSBOWMAN_STUN:int = -13;
          
          public static const RANGED_WEAPON_1:int = -14;
          
          public static const RANGED_ARMOUR_1:int = -15;
          
          public static const MONK:int = -16;
          
          public static const MAGIKILL:int = -17;
          
          public static const MEELE_WEAPON_2:int = -18;
          
          public static const MEELE_ARMOUR_2:int = -19;
          
          public static const MEELE_WEAPON_3:int = -20;
          
          public static const MEELE_ARMOUR_3:int = -21;
          
          public static const ARCHIDON_FIRE:int = -22;
          
          public static const ARCHIDON_POISON:int = -23;
          
          public static const MAGIKILL_NUKE:int = -24;
          
          public static const MAGIKILL_WALL:int = -25;
          
          public static const MAGIKILL_POISON:int = -26;
          
          public static const ARCHIDON_QUICK_FIRE:int = -27;
          
          public static const CASTLE_ARCHER_1:int = -28;
          
          public static const CASTLE_ARCHER_2:int = -29;
          
          public static const CASTLE_ARCHER_3:int = -30;
          
          public static const CASTLE_ARCHER_4:int = -31;
          
          public static const CASTLE_ARCHER_5:int = -32;
          
          public static const WINGIDON_SPEED:int = -33;
          
          public static const SHIELD_BASH:int = -34;
          
          public static const BANK_BAG_SIZE:int = -35;
          
          public static const BANK_PASSIVE_1:int = -36;
          
          public static const GIANT_PROJECTILE_SPLIT:int = -37;
          
          public static const BANK_PASSIVE_2:int = -38;
          
          public static const BANK_PASSIVE_3:int = -39;
          
          public static const STATUE_HEALTH:int = -42;
          
          public static const MONK_CURE:int = -43;
          
          public static const MONK_PROTECT:int = -44;
          
          public static const DEAD_POISON:int = -45;
          
          public static const CAT_PACK:int = -46;
          
          public static const GIANT_GROWTH_I:int = -47;
          
          public static const GIANT_GROWTH_II:int = -48;
          
          public static const MEDUSA_POISON:int = -49;
          
          public static const CHAOS_GIANT_GROWTH_I:int = -50;
          
          public static const CHAOS_GIANT_GROWTH_II:int = -51;
          
          public static const KNIGHT_CHARGE:int = -52;
          
          public static const SKELETON_FIST_ATTACK:int = -53;
          
          public static const MINER_WALL:int = -54;
          
          public static const MINER_TOWER:int = -55;
          
          public static const MINER_SPEED:int = -56;
          
          public static const CAT_SPEED:int = -57;
          
          public static const CLOAK_II:int = -58;
          
          public static const CROSSBOW_FIRE:int = -59;
          
          public static const TOWER_SPAWN_I:int = -60;
          
          public static const TOWER_SPAWN_II:int = -61;
           
          
          public var upgrades:Dictionary;
          
          protected var team:com.brockw.stickwar.engine.Team.Team;
          
          protected var researchingMap:Object;
          
          protected var _isResearchedMap:Dictionary;
          
          private var isDebug:Boolean;
          
          internal var toDecrement:Array;
          
          private var game:StickWar;
          
          public function Tech(game:StickWar, team:com.brockw.stickwar.engine.Team.Team)
          {
               super();
               this.game = game;
               this.team = team;
               this.isResearchedMap = new Dictionary();
               this.isDebug = game.xml.xml.debug == 1;
               this.researchingMap = new Object();
               this.toDecrement = [];
          }
          
          public function update(game:StickWar) : void
          {
               var key:* = null;
               for(key in this.researchingMap)
               {
                    if(this.researchingMap[key] < 0 || this.isDebug)
                    {
                         this.isResearchedMap[key] = true;
                         delete this.researchingMap[key];
                         game.gameScreen.userInterface.selectedUnits.refresh(true);
                         game.gameScreen.userInterface.actionInterface.refresh();
                    }
                    else if(this.toDecrement.indexOf(key) == -1)
                    {
                         this.toDecrement.push(key);
                         --this.researchingMap[key];
                    }
                    else
                    {
                         trace("that bug would have happenend");
                    }
               }
               this.toDecrement.splice(0,this.toDecrement.length);
          }
          
          public function cleanUp() : void
          {
               this.upgrades = null;
               this.team = null;
               this.researchingMap = null;
               this.isResearchedMap = null;
          }
          
          public function isResearched(type:int) : Boolean
          {
               if(this.team.techAllowed != null && !(type in this.team.techAllowed))
               {
                    return false;
               }
               return type in this.isResearchedMap;
          }
          
          public function isResearching(type:int) : Boolean
          {
               return false;
          }
          
          public function getResearchCooldown(type:int) : Number
          {
               return 0;
          }
          
          public function getTechAllowed(type:int) : Boolean
          {
               return this.team.techAllowed == null || type in this.team.techAllowed;
          }
          
          public function startResearching(type:int) : void
          {
               if(this.team.techAllowed != null && !(type in this.team.techAllowed))
               {
                    return;
               }
               var t:TechItem = this.upgrades[type];
               if(t == null)
               {
                    return;
               }
               if(t.cost <= this.team.gold && t.mana <= this.team.mana)
               {
                    this.team.gold -= t.cost;
                    this.team.mana -= t.mana;
                    this.researchingMap[type] = t.researchTime;
               }
          }
          
          public function get isResearchedMap() : Dictionary
          {
               return this._isResearchedMap;
          }
          
          public function set isResearchedMap(value:Dictionary) : void
          {
               this._isResearchedMap = value;
          }
     }
}
