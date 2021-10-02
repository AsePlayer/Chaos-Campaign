package com.brockw.stickwar.engine.Team.Order
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Ai.command.StandCommand;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Building;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.UserInterface;
   import com.brockw.stickwar.engine.units.Statue;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   
   public class TeamGood extends Team
   {
       
      
      public function TeamGood(game:StickWar, statueHealth:int, techAllowed:Dictionary = null, handicap:* = 1.0, healthModifier:Number = 1.0)
      {
         var bulding:Building = null;
         var unit:* = null;
         var un:Unit = null;
         var e:Entity = new Entity();
         e.addChild(new _castleFrontMc());
         castleFront = e;
         e = new Entity();
         e.addChild(new _castleBackMc());
         castleBack = e;
         var u:Statue = new Statue(new _statueMc(),game,statueHealth);
         game.units[u.id] = u;
         statue = u;
         super(game);
         this.handicap = handicap;
         this.techAllowed = techAllowed;
         type = T_GOOD;
         buttonOver = null;
         sameButtonCount = 0;
         e = new Entity();
         var b:baseMc = new baseMc();
         b.baseBacking.cacheAsBitmap = true;
         b.baseFront.cacheAsBitmap = true;
         Util.animateToNeutral(b,4);
         e.addChild(b);
         base = e;
         tech = new GoodTech(game,this);
         buildings["BarracksBuilding"] = new BarracksBuilding(game,GoodTech(tech),b.barracksMc,b.barracksHitArea);
         buildings["ArcheryBuilding"] = new ArcheryBuilding(game,GoodTech(tech),b.archeryRangeMc,b.fletcherHitArea);
         buildings["MagicGuildBuilding"] = new MagicGuildBuilding(game,GoodTech(tech),b.magicShopMc,b.magicHitArea);
         buildings["SiegeBuilding"] = new SiegeBuilding(game,GoodTech(tech),b.siegeShop,b.dungeonHitArea);
         buildings["TempleBuilding"] = new TempleBuilding(game,GoodTech(tech),b.templeMc,b.templeHitArea);
         buildings["BankBuilding"] = new BankBuilding(game,GoodTech(tech),b.bankMc,b.bankHitArea);
         for each(bulding in buildings)
         {
            this._unitProductionQueue[bulding.type] = [];
         }
         castleDefence = new CastleArchers(game,this);
         unitInfo[Unit.U_MINER] = [game.xml.xml.Order.Units.miner.gold * handicap,game.xml.xml.Order.Units.miner.mana * handicap];
         unitInfo[Unit.U_SWORDWRATH] = [game.xml.xml.Order.Units.swordwrath.gold * handicap,game.xml.xml.Order.Units.swordwrath.mana * handicap];
         unitInfo[Unit.U_ARCHER] = [game.xml.xml.Order.Units.archer.gold * handicap,game.xml.xml.Order.Units.archer.mana * handicap];
         unitInfo[Unit.U_SPEARTON] = [game.xml.xml.Order.Units.spearton.gold * handicap,game.xml.xml.Order.Units.spearton.mana * handicap];
         unitInfo[Unit.U_NINJA] = [game.xml.xml.Order.Units.ninja.gold * handicap,game.xml.xml.Order.Units.ninja.mana * handicap];
         unitInfo[Unit.U_FLYING_CROSSBOWMAN] = [game.xml.xml.Order.Units.flyingCrossbowman.gold * handicap,game.xml.xml.Order.Units.flyingCrossbowman.mana * handicap];
         unitInfo[Unit.U_MONK] = [game.xml.xml.Order.Units.monk.gold * handicap,game.xml.xml.Order.Units.monk.mana * handicap];
         unitInfo[Unit.U_MAGIKILL] = [game.xml.xml.Order.Units.magikill.gold * handicap,game.xml.xml.Order.Units.magikill.mana * handicap];
         unitInfo[Unit.U_ENSLAVED_GIANT] = [game.xml.xml.Order.Units.giant.gold * handicap,game.xml.xml.Order.Units.giant.mana * handicap];
         if(game.unitFactory)
         {
            for(unit in unitInfo)
            {
               un = game.unitFactory.getUnit(int(unit));
               un.team = this;
               un.setBuilding();
               unitInfo[unit].push(un.building.type);
               unitGroups[un.type] = [];
               game.unitFactory.returnUnit(un.type,un);
            }
         }
         this.healthModifier = healthModifier;
      }
      
      override protected function getSpawnUnitType(game:StickWar) : int
      {
         if(tech.isResearched(Tech.TOWER_SPAWN_II))
         {
            return Unit.U_ENSLAVED_GIANT;
         }
         return Unit.U_SPEARTON;
      }
      
      override public function getNumberOfMiners() : int
      {
         return unitGroups[Unit.U_MINER].length;
      }
      
      override public function detectedUserInput(userInterface:UserInterface) : void
      {
         singlePlayerDebugInputSwitch(userInterface,Unit.U_MINER,49);
         singlePlayerDebugInputSwitch(userInterface,Unit.U_SWORDWRATH,50);
         singlePlayerDebugInputSwitch(userInterface,Unit.U_ARCHER,51);
         singlePlayerDebugInputSwitch(userInterface,Unit.U_MONK,52);
         singlePlayerDebugInputSwitch(userInterface,Unit.U_MAGIKILL,53);
         singlePlayerDebugInputSwitch(userInterface,Unit.U_SPEARTON,54);
         singlePlayerDebugInputSwitch(userInterface,Unit.U_NINJA,55);
         singlePlayerDebugInputSwitch(userInterface,Unit.U_FLYING_CROSSBOWMAN,56);
         singlePlayerDebugInputSwitch(userInterface,Unit.U_ENSLAVED_GIANT,57);
      }
      
      override public function getMinerType() : int
      {
         return Unit.U_MINER;
      }
      
      override public function spawnMiners() : void
      {
         var u1:Unit = null;
         var u2:Unit = null;
         u1 = game.unitFactory.getUnit(Unit.U_MINER);
         u2 = game.unitFactory.getUnit(Unit.U_MINER);
         spawn(u1,game);
         spawn(u2,game);
         u1.px = homeX + 650 * direction;
         u2.px = homeX + 650 * direction;
         u1.py = game.map.height / 3;
         u2.py = game.map.height / 3 * 2;
         u1.ai.setCommand(game,new StandCommand(game));
         u2.ai.setCommand(game,new StandCommand(game));
         this.population += 4;
      }
      
      override public function initTeamButtons(gameScreen:GameScreen) : void
      {
         var key:* = null;
         var overlay:MovieClip = null;
         var button:MovieClip = null;
         var cancelButtonMc:MovieClip = null;
         var output:TextField = null;
         var myFormat:TextFormat = null;
         buttonInfoMap = new Dictionary();
         buttonInfoMap[Unit.U_MINER] = [gameScreen.userInterface.hud.hud.minerButton,gameScreen.userInterface.hud.hud.minerOverlay,gameScreen.game.xml.xml.Order.Units.miner,0,new cancelButton(),game.xml.xml.Order.Units.miner.gold * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.bankHighlight,null];
         buttonInfoMap[Unit.U_SWORDWRATH] = [gameScreen.userInterface.hud.hud.swordwrathButton,gameScreen.userInterface.hud.hud.swordwrathOverlay,gameScreen.game.xml.xml.Order.Units.swordwrath,0,new cancelButton(),game.xml.xml.Order.Units.swordwrath.gold * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.barracksHighlight,gameScreen.userInterface.hud.hud.barracksUnderlay];
         buttonInfoMap[Unit.U_ARCHER] = [gameScreen.userInterface.hud.hud.archerButton,gameScreen.userInterface.hud.hud.archerOverlay,gameScreen.game.xml.xml.Order.Units.archer,0,new cancelButton(),game.xml.xml.Order.Units.archer.gold * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.archerHighlight,gameScreen.userInterface.hud.hud.archerUnderlay];
         buttonInfoMap[Unit.U_SPEARTON] = [gameScreen.userInterface.hud.hud.speartonButton,gameScreen.userInterface.hud.hud.speartonOverlay,gameScreen.game.xml.xml.Order.Units.spearton,0,new cancelButton(),game.xml.xml.Order.Units.spearton.gold * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.barracksHighlight,gameScreen.userInterface.hud.hud.barracksUnderlay];
         buttonInfoMap[Unit.U_NINJA] = [gameScreen.userInterface.hud.hud.ninjaButton,gameScreen.userInterface.hud.hud.ninjaOverlay,gameScreen.game.xml.xml.Order.Units.ninja,0,new cancelButton(),game.xml.xml.Order.Units.ninja.gold * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.barracksHighlight,gameScreen.userInterface.hud.hud.barracksUnderlay];
         buttonInfoMap[Unit.U_FLYING_CROSSBOWMAN] = [gameScreen.userInterface.hud.hud.flyingcrossbowmanButton,gameScreen.userInterface.hud.hud.flyingcrossbowmanOverlay,gameScreen.game.xml.xml.Order.Units.flyingCrossbowman,0,new cancelButton(),game.xml.xml.Order.Units.flyingcrossbowman.gold * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.archerHighlight,gameScreen.userInterface.hud.hud.archerUnderlay];
         buttonInfoMap[Unit.U_MONK] = [gameScreen.userInterface.hud.hud.monkButton,gameScreen.userInterface.hud.hud.monkOverlay,gameScreen.game.xml.xml.Order.Units.monk,0,new cancelButton(),game.xml.xml.Order.Units.monk.gold,new MovieClip(),gameScreen.userInterface.hud.hud.templeHighlight,null];
         buttonInfoMap[Unit.U_MAGIKILL] = [gameScreen.userInterface.hud.hud.magikillButton,gameScreen.userInterface.hud.hud.magikillOverlay,gameScreen.game.xml.xml.Order.Units.magikill,0,new cancelButton(),game.xml.xml.Order.Units.magikill.gold * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.magikillHighlight,null];
         buttonInfoMap[Unit.U_ENSLAVED_GIANT] = [gameScreen.userInterface.hud.hud.giantButton,gameScreen.userInterface.hud.hud.giantOverlay,gameScreen.game.xml.xml.Order.Units.giant,0,new cancelButton(),game.xml.xml.Order.Units.giant.gold * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.giantHighlight,null];
         buildingHighlights = [gameScreen.userInterface.hud.hud.bankHighlight,gameScreen.userInterface.hud.hud.barracksHighlight,gameScreen.userInterface.hud.hud.archerHighlight,gameScreen.userInterface.hud.hud.templeHighlight,gameScreen.userInterface.hud.hud.giantHighlight,gameScreen.userInterface.hud.hud.magikillHighlight,gameScreen.userInterface.hud.hud.barracksUnderlay,gameScreen.userInterface.hud.hud.archerUnderlay];
         for(key in buttonInfoMap)
         {
            overlay = buttonInfoMap[key][1];
            button = buttonInfoMap[key][0];
            button.addChild(buttonInfoMap[key][6]);
            cancelButtonMc = buttonInfoMap[key][4];
            cancelButtonMc.x = button.x + button.width - cancelButtonMc.width;
            cancelButtonMc.y = button.y;
            gameScreen.userInterface.hud.hud.addChild(cancelButtonMc);
            cancelButtonMc.visible = false;
            output = new TextField();
            output.name = "number";
            myFormat = new TextFormat(null,20,16777215);
            output.defaultTextFormat = myFormat;
            output.width = 25;
            output.height = 25;
            output.x = 25;
            output.y = 15;
            output.selectable = false;
            output.text = "0";
            button.addChild(output);
         }
      }
   }
}
