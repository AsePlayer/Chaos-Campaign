package com.brockw.stickwar.engine.Team.Chaos
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
   
   public class TeamChaos extends Team
   {
       
      
      public function TeamChaos(game:StickWar, health:int, techAllowed:Dictionary = null, handicap:* = 1, healthModifier:Number = 1)
      {
         var healthyCats:int = 0;
         var bulding:Building = null;
         var unit:* = null;
         var un:Unit = null;
         var e:Entity = new Entity();
         e.addChild(new chaosCastle());
         castleFront = e;
         e = new Entity();
         e.addChild(new chaosCastleBack());
         castleBack = e;
         var u:Statue = new Statue(new _statueMc(),game,health);
         game.units[u.id] = u;
         statue = u;
         super(game);
         this.handicap = handicap;
         this.techAllowed = techAllowed;
         type = T_CHAOS;
         buttonOver = null;
         sameButtonCount = 0;
         e = new Entity();
         var b:chaosBase = new chaosBase();
         Util.animateToNeutral(b,4);
         e.addChild(b);
         base = e;
         b.baseBacking.cacheAsBitmap = true;
         tech = new ChaosTech(game,this);
         buildings["BarracksBuilding"] = new ChaosBarracksBuilding(game,ChaosTech(tech),b.chaosBarrackButton,b.chaosBarracksHitArea);
         buildings["ArcheryBuilding"] = new ChaosFletchersBuilding(game,ChaosTech(tech),b.chaosFletcherButton,b.chaosFletcherHitArea);
         buildings["UndeadBuilding"] = new ChaosUndeadBuilding(game,ChaosTech(tech),b.chaosUndeadButton,b.chaosUndeadHitArea);
         buildings["GiantBuilding"] = new ChaosGiantBuilding(game,ChaosTech(tech),b.chaosGiantButton,b.chaosGiantHitArea);
         buildings["MedusaBuilding"] = new ChaosMedusaBuilding(game,ChaosTech(tech),b.chaosMedusaButton,b.chaosMedusaHitArea);
         buildings["BankBuilding"] = new ChaosBankBuilding(game,ChaosTech(tech),b.chaosBankButton,b.chaosBankHitArea);
         for each(bulding in buildings)
         {
            this._unitProductionQueue[bulding.type] = [];
         }
         castleDefence = new CastleDeads(game,this);
         unitInfo[Unit.U_BOMBER] = [game.xml.xml.Chaos.Units.bomber.gold * handicap,game.xml.xml.Chaos.Units.bomber.mana * handicap];
         unitInfo[Unit.U_WINGIDON] = [game.xml.xml.Chaos.Units.wingidon.gold * handicap,game.xml.xml.Chaos.Units.wingidon.mana * handicap];
         unitInfo[Unit.U_SKELATOR] = [game.xml.xml.Chaos.Units.skelator.gold * handicap,game.xml.xml.Chaos.Units.skelator.mana * handicap];
         unitInfo[Unit.U_DEAD] = [game.xml.xml.Chaos.Units.dead.gold * handicap,game.xml.xml.Chaos.Units.dead.mana * handicap];
         unitInfo[Unit.U_CAT] = [game.xml.xml.Chaos.Units.cat.gold * handicap,game.xml.xml.Chaos.Units.cat.mana * handicap];
         unitInfo[Unit.U_KNIGHT] = [game.xml.xml.Chaos.Units.knight.gold * handicap,game.xml.xml.Chaos.Units.knight.mana * handicap];
         unitInfo[Unit.U_MEDUSA] = [game.xml.xml.Chaos.Units.medusa.gold * handicap,game.xml.xml.Chaos.Units.medusa.mana * handicap];
         unitInfo[Unit.U_GIANT] = [game.xml.xml.Chaos.Units.giant.gold * handicap,game.xml.xml.Chaos.Units.giant.mana * handicap];
         unitInfo[Unit.U_CHAOS_MINER] = [game.xml.xml.Chaos.Units.miner.gold * handicap,game.xml.xml.Chaos.Units.miner.mana * handicap];
         unitInfo[Unit.U_CHAOS_TOWER] = [game.xml.xml.Order.Units.tower.gold * handicap,game.xml.xml.Order.Units.tower.mana * handicap];
         buildingHighlights = [];
         for(unit in unitInfo)
         {
            un = game.unitFactory.getUnit(int(unit));
            un.team = this;
            un.setBuilding();
            unitInfo[unit].push(un.building.type);
            unitGroups[un.type] = [];
            game.unitFactory.returnUnit(un.type,un);
         }
         this.healthModifier = healthModifier;
      }
      
      override protected function getSpawnUnitType(game:StickWar) : int
      {
         if(tech.isResearched(Tech.TOWER_SPAWN_II))
         {
            return Unit.U_GIANT;
         }
         return Unit.U_KNIGHT;
      }
      
      override public function getNumberOfMiners() : int
      {
         return unitGroups[Unit.U_CHAOS_MINER].length;
      }
      
      public function getNumberOfCats() : int
      {
         return unitGroups[Unit.U_CAT].length;
      }
      
      public function getNumberOfHealthyCrawlers() : int
      {
         this.healthyCats = 0;
         for each(un in unitGroups[Unit.U_CAT].length)
         {
            if(un.health == un.maxHealth)
            {
               this.healthyCats++;
            }
         }
         return this.healthyCats;
      }
      
      override public function getMinerType() : int
      {
         return Unit.U_CHAOS_MINER;
      }
      
      override public function updateStatue() : void
      {
         if(statueType != "default")
         {
            statue.mc.statue.gotoAndStop(statueType);
         }
         else
         {
            statue.mc.statue.gotoAndStop("chaos");
         }
      }
      
      override public function init() : void
      {
         _population = 0;
         _castleBack.x = this.homeX - this.direction * game.map.screenWidth;
         _castleBack.y = -game.battlefield.y;
         _castleBack.py = _castleBack.y = -game.battlefield.y;
         _castleBack.scaleX *= this.direction;
         _castleFront.x = this.homeX - this.direction * game.map.screenWidth;
         _castleFront.y = -game.battlefield.y;
         _castleFront.py = game.map.height / 2 + 40;
         _castleFront.scaleX *= this.direction;
         statue.x = this.homeX + direction * 500;
         statue.py = game.map.height / 2;
         statue.px = statue.x;
         statue.y = statue.py;
         statue.scaleX *= 0.8;
         statue.scaleY *= 0.8;
         statue.scaleX *= this.direction;
         base.x = this.homeX - direction * game.map.screenWidth;
         base.scaleX = direction;
         base.py = 0;
         base.px = base.x;
         base.y = -game.map.y;
         base.mouseEnabled = true;
         castleFront.cacheAsBitmap = true;
         castleBack.cacheAsBitmap = true;
         statue.cacheAsBitmap = true;
         statue.team = this;
      }
      
      override public function detectedUserInput(userInterface:UserInterface) : void
      {
         if(!userInterface.keyBoardState.isCtrl && !userInterface.keyBoardState.isShift)
         {
            singlePlayerDebugInputSwitch(userInterface,Unit.U_CHAOS_MINER,49);
            singlePlayerDebugInputSwitch(userInterface,Unit.U_CAT,50);
            singlePlayerDebugInputSwitch(userInterface,Unit.U_DEAD,51);
            singlePlayerDebugInputSwitch(userInterface,Unit.U_SKELATOR,52);
            singlePlayerDebugInputSwitch(userInterface,Unit.U_MEDUSA,53);
            singlePlayerDebugInputSwitch(userInterface,Unit.U_BOMBER,54);
            singlePlayerDebugInputSwitch(userInterface,Unit.U_KNIGHT,55);
            singlePlayerDebugInputSwitch(userInterface,Unit.U_WINGIDON,56);
            singlePlayerDebugInputSwitch(userInterface,Unit.U_GIANT,57);
         }
      }
      
      override public function spawnMiners() : void
      {
         var u2:Unit = null;
         var u1:Unit = game.unitFactory.getUnit(Unit.U_CHAOS_MINER);
         u2 = game.unitFactory.getUnit(Unit.U_CHAOS_MINER);
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
         buttonInfoMap[Unit.U_CHAOS_MINER] = [gameScreen.userInterface.hud.hud.minerButton,gameScreen.userInterface.hud.hud.minerOverlay,gameScreen.game.xml.xml.Chaos.Units.miner,0,new cancelButton(),game.xml.xml.Chaos.Units.miner.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.bankHighlight,null];
         buttonInfoMap[Unit.U_BOMBER] = [gameScreen.userInterface.hud.hud.bomberButton,gameScreen.userInterface.hud.hud.bomberOverlay,gameScreen.game.xml.xml.Chaos.Units.bomber,0,new cancelButton(),game.xml.xml.Chaos.Units.bomber.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.barracksHighlight,gameScreen.userInterface.hud.hud.barracksUnderlay];
         buttonInfoMap[Unit.U_WINGIDON] = [gameScreen.userInterface.hud.hud.wingidonButton,gameScreen.userInterface.hud.hud.wingidonOverlay,gameScreen.game.xml.xml.Chaos.Units.wingidon,0,new cancelButton(),game.xml.xml.Chaos.Units.wingidon.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.fletcherBuilding,gameScreen.userInterface.hud.hud.archerUnderlay];
         buttonInfoMap[Unit.U_SKELATOR] = [gameScreen.userInterface.hud.hud.skeletalButton,gameScreen.userInterface.hud.hud.skeletonOverlay,gameScreen.game.xml.xml.Chaos.Units.skelator,0,new cancelButton(),game.xml.xml.Chaos.Units.skelator.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.skeletalHighlight,null];
         buttonInfoMap[Unit.U_DEAD] = [gameScreen.userInterface.hud.hud.deadButton,gameScreen.userInterface.hud.hud.deadOverlay,gameScreen.game.xml.xml.Chaos.Units.dead,0,new cancelButton(),game.xml.xml.Chaos.Units.dead.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.fletcherBuilding,gameScreen.userInterface.hud.hud.archerUnderlay];
         buttonInfoMap[Unit.U_CAT] = [gameScreen.userInterface.hud.hud.catButton,gameScreen.userInterface.hud.hud.catOverlay,gameScreen.game.xml.xml.Chaos.Units.cat,0,new cancelButton(),game.xml.xml.Chaos.Units.cat.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.barracksHighlight,gameScreen.userInterface.hud.hud.barracksUnderlay];
         buttonInfoMap[Unit.U_KNIGHT] = [gameScreen.userInterface.hud.hud.knightButton,gameScreen.userInterface.hud.hud.knightOverlay,gameScreen.game.xml.xml.Chaos.Units.knight,0,new cancelButton(),game.xml.xml.Chaos.Units.knight.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.barracksHighlight,gameScreen.userInterface.hud.hud.barracksUnderlay];
         buttonInfoMap[Unit.U_MEDUSA] = [gameScreen.userInterface.hud.hud.medusaButton,gameScreen.userInterface.hud.hud.medusaOverlay,gameScreen.game.xml.xml.Chaos.Units.medusa,0,new cancelButton(),game.xml.xml.Chaos.Units.medusa.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.medusaHighlight,null];
         buttonInfoMap[Unit.U_GIANT] = [gameScreen.userInterface.hud.hud.giantButton,gameScreen.userInterface.hud.hud.giantOverlay,gameScreen.game.xml.xml.Chaos.Units.giant,0,new cancelButton(),game.xml.xml.Chaos.Units.giant.cost * handicap,new MovieClip(),gameScreen.userInterface.hud.hud.giantHighlight,null];
         buildingHighlights = [gameScreen.userInterface.hud.hud.bankHighlight,gameScreen.userInterface.hud.hud.barracksHighlight,gameScreen.userInterface.hud.hud.giantHighlight,gameScreen.userInterface.hud.hud.fletcherBuilding,gameScreen.userInterface.hud.hud.skeletalHighlight,gameScreen.userInterface.hud.hud.medusaHighlight,gameScreen.userInterface.hud.hud.barracksUnderlay,gameScreen.userInterface.hud.hud.archerUnderlay];
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
