package com.brockw.stickwar.engine
{
     import com.brockw.game.*;
     import com.brockw.random.*;
     import com.brockw.simulationSync.*;
     import com.brockw.stickwar.BaseMain;
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.engine.Ai.TeamGoodAi;
     import com.brockw.stickwar.engine.Ai.command.*;
     import com.brockw.stickwar.engine.Team.*;
     import com.brockw.stickwar.engine.Team.Chaos.*;
     import com.brockw.stickwar.engine.Team.Order.*;
     import com.brockw.stickwar.engine.dual.DualFactory;
     import com.brockw.stickwar.engine.maps.*;
     import com.brockw.stickwar.engine.multiplayer.*;
     import com.brockw.stickwar.engine.projectile.*;
     import com.brockw.stickwar.engine.units.*;
     import flash.display.*;
     import flash.filters.*;
     import flash.geom.Point;
     import flash.utils.Dictionary;
     
     public class StickWar extends Simulation
     {
          
          public static var GRAVITY:Number;
          
          protected static var _frontScale:Number;
          
          protected static var _backScale:Number;
           
          
          private var _postCursors:Array;
          
          private var _cursorSprite:com.brockw.stickwar.engine.Entity;
          
          private var _battlefield:Sprite;
          
          private var _map:Map;
          
          private var _background:com.brockw.stickwar.engine.Background;
          
          private var _screenX:Number;
          
          private var _targetScreenX:Number;
          
          private var _team:Team;
          
          private var _teamA:Team;
          
          private var _teamB:Team;
          
          private var _units:Dictionary;
          
          private var _currentId:int;
          
          private var shadowClip:com.brockw.stickwar.engine.Shadows;
          
          private var _random:Random;
          
          private var _dualFactory:DualFactory;
          
          private var _spatialHash:com.brockw.stickwar.engine.SpatialHash;
          
          private var _fogOfWar:com.brockw.stickwar.engine.FogOfWar;
          
          private var _unitFactory:UnitFactory;
          
          private var _oreFactory:com.brockw.stickwar.engine.OreFactory;
          
          private var _projectileManager:ProjectileManager;
          
          private var _xml:XMLLoader;
          
          private var soundLoader:com.brockw.stickwar.engine.SoundLoader;
          
          private var _soundManager:com.brockw.stickwar.engine.SoundManager;
          
          private var _rain:com.brockw.stickwar.engine.Rain;
          
          private var _inEconomy:Boolean;
          
          private var _util:Util;
          
          private var _mouseOverUnit:com.brockw.stickwar.engine.Entity;
          
          private var _tipBox:com.brockw.stickwar.engine.TipBox;
          
          private var _main:BaseMain;
          
          private var _gameScreen:GameScreen;
          
          private var _incomeDisplay:com.brockw.stickwar.engine.IncomeDisplay;
          
          private var _bloodManager:com.brockw.stickwar.engine.BloodManager;
          
          private var _commandFactory:CommandFactory;
          
          private var isDebug:Boolean;
          
          private var _mapId:int;
          
          private var _economyRecords:Array;
          
          private var _militaryRecords:Array;
          
          public var pausedGameMc:gamePausedDisplay;
          
          private var _showGameOverAnimation:Boolean;
          
          public function StickWar(main:BaseMain, gameScreen:GameScreen)
          {
               super();
               this._main = main;
          }
          
          public function initGame(main:BaseMain, gameScreen:GameScreen, mapId:int = -1) : void
          {
               gameOver = this.showGameOverAnimation = false;
               super.init(main.seed);
               ++main.loadingFraction;
               this.economyRecords = [];
               this.militaryRecords = [];
               isReplay = false;
               this._gameScreen = gameScreen;
               this.commandFactory = new CommandFactory(this);
               ++main.loadingFraction;
               this.mapId = mapId;
               this._random = new Random(main.seed);
               ++main.loadingFraction;
               if(!this._xml)
               {
                    this._xml = new XMLLoader();
               }
               ++main.loadingFraction;
               if(!this._incomeDisplay)
               {
                    this._incomeDisplay = new com.brockw.stickwar.engine.IncomeDisplay(this);
               }
               ++main.loadingFraction;
               gameScreen.isDebug = this._xml.xml.debug;
               GRAVITY = this._xml.xml.gravity;
               _frontScale = this._xml.xml.frontScale;
               _backScale = this._xml.xml.backScale;
               winner = null;
               this._currentId = 0;
               this._postCursors = [];
               if(!this._oreFactory)
               {
                    this._oreFactory = new com.brockw.stickwar.engine.OreFactory(20,this);
               }
               ++main.loadingFraction;
               if(!this._dualFactory)
               {
                    this._dualFactory = new DualFactory(this);
               }
               ++main.loadingFraction;
               if(!this.projectileManager)
               {
                    this.projectileManager = new ProjectileManager(this);
               }
               ++main.loadingFraction;
               if(!this.tipBox)
               {
                    this.tipBox = new com.brockw.stickwar.engine.TipBox(this);
               }
               ++main.loadingFraction;
               if(!this._util)
               {
                    this._util = new Util();
               }
               ++main.loadingFraction;
               this.units = new Dictionary();
               this.targetScreenX = this._screenX = 0;
               this._map = Map.getMapFromId(mapId,this);
               ++main.loadingFraction;
               if(this._cursorSprite == null)
               {
                    this._cursorSprite = new com.brockw.stickwar.engine.Entity();
                    this._cursorSprite.py = this.map.height + 1;
                    this._cursorSprite.graphics.beginFill(0,0);
                    this._cursorSprite.graphics.drawRect(0,0,this.map.width,this.map.height);
                    this._cursorSprite.x = 0;
                    this._cursorSprite.y = this.map.y;
                    this._cursorSprite.name = "cursorSprite";
               }
               ++main.loadingFraction;
               if(!this._rain)
               {
                    this._rain = new com.brockw.stickwar.engine.Rain(this,0);
               }
               ++main.loadingFraction;
               this._battlefield = new Sprite();
               this._battlefield.x = 0;
               this._battlefield.y = this._map.y;
               ++main.loadingFraction;
               this.shadowClip = new com.brockw.stickwar.engine.Shadows(this._map);
               this.shadowClip.x = 0;
               this.shadowClip.y = this.map.y;
               this.shadowClip.alpha = 0.5;
               var shadowFilter:BlurFilter = new BlurFilter();
               shadowFilter.blurX = shadowFilter.blurY = 12;
               shadowFilter.quality = 1;
               addChild(this.shadowClip);
               ++main.loadingFraction;
               if(!this._bloodManager)
               {
                    this._bloodManager = new com.brockw.stickwar.engine.BloodManager();
               }
               this._bloodManager.y = this.battlefield.y;
               addChild(this._bloodManager);
               addChild(this._battlefield);
               addChild(this._rain);
               ++main.loadingFraction;
               this._rain.mouseEnabled = false;
               this._cursorSprite.mouseChildren = false;
               this._cursorSprite.mouseEnabled = false;
               addChild(this.tipBox);
               this.tipBox.mouseChildren = false;
               this.tipBox.mouseEnabled = false;
               this._rain.mouseChildren = false;
               ++main.loadingFraction;
               this._spatialHash = new com.brockw.stickwar.engine.SpatialHash(this,this.map.width,this.map.height,50,this.map.height / 7,100);
               ++main.loadingFraction;
               if(!this._unitFactory)
               {
                    this._unitFactory = new UnitFactory(100,this);
               }
               ++main.loadingFraction;
               this._inEconomy = false;
               this._map.addElementsToMap(this);
               this.isDebug = this.xml.xml.debug == 1;
               this.soundLoader = main.soundLoader;
               this.soundManager = main.soundManager;
               this.pausedGameMc = new gamePausedDisplay();
               this.pausedGameMc.x = stage.stageWidth / 2;
               this.pausedGameMc.y = stage.stageHeight / 2;
               this.pausedGameMc.visible = false;
               addChild(this.pausedGameMc);
               ++main.loadingFraction;
          }
          
          override public function postInit() : void
          {
               this.fogOfWar = new com.brockw.stickwar.engine.FogOfWar(this);
               addChild(this.fogOfWar);
               this.fogOfWar.isFogOn = this.xml.xml.isFogOfWar == 1;
          }
          
          public function cleanUp() : void
          {
               if(Boolean(this._cursorSprite.parent) && this._cursorSprite.parent.contains(this._cursorSprite))
               {
                    this._cursorSprite.parent.removeChild(this._cursorSprite);
               }
               this._cursorSprite = null;
               this._map = null;
               this._team = null;
               this._teamA.cleanUp();
               this._teamA = null;
               this._teamB.cleanUp();
               this._teamB = null;
               this._background.cleanUp();
               this._background = null;
               this._units = new Dictionary();
               this.shadowClip = null;
               this.random = null;
               this._dualFactory.cleanUp();
               this._dualFactory = null;
               this._spatialHash.cleanUp();
               this._spatialHash = null;
               this._projectileManager.cleanUp();
               this._battlefield = null;
               this._projectileManager = null;
               this._oreFactory = null;
               this.unitFactory.cleanUp();
               this.unitFactory = null;
               this._mouseOverUnit = null;
               this._tipBox = null;
               Util.recursiveRemoval(Sprite(this));
          }
          
          public function getNextUnitId() : int
          {
               return this._currentId++;
          }
          
          public function initTeams(race1:int, race2:int, health1:int, health2:int, techAllowedA:Dictionary = null, techAllowedB:Dictionary = null, handicap1:Number = 1, handicap2:Number = 1, healthModifierA:Number = 1, healthModifierB:Number = 1, damageModifierA:Number = 1, damageModifierB:Number = 1) : void
          {
               this._teamA = Team.getTeamFromId(race1,this,health1,techAllowedA,handicap1,healthModifierA);
               this._teamB = Team.getTeamFromId(race2,this,health2,techAllowedB,handicap2,healthModifierB);
               this._teamA.name = 0;
               this._teamB.name = 1;
               this._teamA.direction = 1;
               this._teamB.direction = -1;
               this._teamA.homeX = this._teamA.direction * this.map.screenWidth;
               this._teamB.homeX = this.map.width + this._teamB.direction * this.map.screenWidth;
               this._teamA.ai = new TeamGoodAi(this._teamA);
               this._teamB.ai = new TeamGoodAi(this._teamB);
               this._teamA.enemyTeam = this._teamB;
               this._teamB.enemyTeam = this._teamA;
               if(this.xml.xml.debug == 1)
               {
                    this._teamA.gold = 100000;
                    this._teamB.gold = 100000;
                    this._teamA.mana = 100000;
                    this._teamB.mana = 100000;
               }
               else
               {
                    this._teamA.gold = this.xml.xml.startingGold;
                    this._teamB.gold = this.xml.xml.startingGold;
                    this._teamA.mana = this.xml.xml.startingMana;
                    this._teamB.mana = this.xml.xml.startingMana;
               }
               this.battlefield.addChild(this._teamA.castleBack);
               this.battlefield.addChild(this._teamB.castleBack);
               this.battlefield.addChild(this._teamA.statue);
               this.battlefield.addChild(this._teamB.statue);
               this.battlefield.addChild(this._teamA.castleFront);
               this.battlefield.addChild(this._teamB.castleFront);
               this.battlefield.addChild(this._teamA.base);
               this.battlefield.addChild(this._teamB.base);
               this._teamA.init();
               this._teamB.init();
               this._teamA.damageModifier = damageModifierA;
               this._teamB.damageModifier = damageModifierB;
          }
          
          public function setPaused(p:Boolean) : void
          {
               this.pausedGameMc.visible = p;
          }
          
          private function determineIfBetterSelection(e:com.brockw.stickwar.engine.Entity) : Boolean
          {
               if(e is Unit && Unit(e).isDead)
               {
                    return false;
               }
               if(this.mouseOverUnit == null)
               {
                    return true;
               }
               if(Math.abs(this.battlefield.mouseX - e.px) < Math.abs(this.battlefield.mouseX - this.mouseOverUnit.px))
               {
                    return true;
               }
               return false;
          }
          
          public function updateVisibilityOfUnits() : void
          {
               var unit:String = null;
               for(unit in this.teamA.units)
               {
                    if(Entity(this.teamA.units[unit]).onScreen(this))
                    {
                         this.teamA.units[unit].visible = true;
                    }
                    else
                    {
                         this.teamA.units[unit].visible = false;
                    }
               }
               for(unit in this.teamB.units)
               {
                    if(Entity(this.teamB.units[unit]).onScreen(this))
                    {
                         this.teamB.units[unit].visible = true;
                    }
                    else
                    {
                         this.teamB.units[unit].visible = false;
                    }
               }
          }
          
          override public function update(screen:Screen) : void
          {
               var hill:Hill = null;
               var unit:String = null;
               var gold:String = null;
               var wall:Wall = null;
               this.teamA.updateStatue();
               this.teamB.updateStatue();
               if(this.showGameOverAnimation)
               {
                    return;
               }
               if(frame % 60 == 0)
               {
                    this.militaryRecords.push(this.team.population);
                    this.militaryRecords.push(this.team.enemyTeam.population);
                    this.economyRecords.push(this.team.getNumberOfMiners());
                    this.economyRecords.push(this.team.enemyTeam.getNumberOfMiners());
               }
               super.update(screen);
               this.mouseOverUnit = null;
               this._incomeDisplay.update(this);
               var gameScreen:GameScreen = GameScreen(screen);
               this._rain.update(this);
               if(this.teamA.statue.health <= 0)
               {
                    this.showGameOverAnimation = true;
                    this.soundManager.playSoundFullVolume("StatueDestroyed");
                    winner = this.teamB;
               }
               if(this.teamB.statue.health <= 0)
               {
                    this.showGameOverAnimation = true;
                    this.soundManager.playSoundFullVolume("StatueDestroyed");
                    winner = this.teamA;
               }
               this.projectileManager.update(this);
               this.projectileManager.airEffects.splice(0,this.projectileManager.airEffects.length);
               for each(hill in this.map.hills)
               {
                    hill.update(this);
               }
               this._spatialHash.clear();
               this._spatialHash.add(this.teamA.statue);
               this._spatialHash.add(this.teamB.statue);
               this.team.enemyTeam.statue.mouseIsOver = false;
               if(this.team.enemyTeam.statue.hitTestPoint(stage.mouseX,stage.mouseY,true) && this.determineIfBetterSelection(this.team.enemyTeam.statue))
               {
                    this.mouseOverUnit = this.team.enemyTeam.statue;
               }
               for(unit in this.teamA.units)
               {
                    if(Unit(this.teamA.units[unit]).isTargetable())
                    {
                         this._spatialHash.add(this.teamA.units[unit]);
                    }
                    if(Entity(this.teamA.units[unit]).onScreen(this))
                    {
                         this.teamA.units[unit].visible = true;
                         this.teamA.units[unit].mouseIsOver = false;
                         if(Boolean(this.teamA.units[unit].mc.mc.hitTestPoint(stage.mouseX,stage.mouseY,false)))
                         {
                              if(this.determineIfBetterSelection(this.teamA.units[unit]))
                              {
                                   this.mouseOverUnit = this.teamA.units[unit];
                              }
                         }
                    }
                    else
                    {
                         this.teamA.units[unit].visible = false;
                    }
               }
               for(unit in this.teamB.units)
               {
                    if(Unit(this.teamB.units[unit]).isTargetable())
                    {
                         this._spatialHash.add(this.teamB.units[unit]);
                    }
                    if(Entity(this.teamB.units[unit]).onScreen(this))
                    {
                         this.teamB.units[unit].visible = true;
                         this.teamB.units[unit].mouseIsOver = false;
                         if(Boolean(this.teamB.units[unit].mc.mc.hitTestPoint(stage.mouseX,stage.mouseY,false)))
                         {
                              if(this.determineIfBetterSelection(this.teamB.units[unit]))
                              {
                                   this.mouseOverUnit = this.teamB.units[unit];
                              }
                         }
                    }
                    else
                    {
                         this.teamB.units[unit].visible = false;
                    }
               }
               for(gold in this.map.gold)
               {
                    Entity(this.map.gold[gold]).mouseIsOver = false;
                    if(Gold(this.map.gold[gold]).frontOre.hitTestPoint(stage.mouseX,stage.mouseY,true) || Gold(this.map.gold[gold]).ore.hitTestPoint(stage.mouseX,stage.mouseY,true))
                    {
                         if(this.determineIfBetterSelection(Entity(this.map.gold[gold])))
                         {
                              this.mouseOverUnit = Entity(this.map.gold[gold]);
                         }
                    }
                    Gold(this.map.gold[gold]).update(this);
               }
               this.team.statue.mouseIsOver = false;
               if(this.team.statue.hitTestPoint(stage.mouseX,stage.mouseY,true) && this.determineIfBetterSelection(this.team.statue))
               {
                    this.mouseOverUnit = this.team.statue;
               }
               if(this.mouseOverUnit == null)
               {
                    for each(wall in this.team.enemyTeam.walls)
                    {
                         if(wall.checkForHitPoint2(new Point(stage.mouseX,stage.mouseY)))
                         {
                              this.mouseOverUnit = wall;
                         }
                    }
               }
               this.team.statue.update(this);
               if(this.mouseOverUnit != null)
               {
                    this.mouseOverUnit.mouseIsOver = true;
               }
               this.sortZ(this.battlefield);
               this._teamA.update(this);
               this._teamB.update(this);
               this.team.updateButtonOverPost(this);
               this.tipBox.update(this);
          }
          
          public function getTeamFromId(id:int) : *
          {
               if(this.team.id == id)
               {
                    return this.team;
               }
               if(this.team.enemyTeam.id == id)
               {
                    return this.team.enemyTeam;
               }
               return null;
          }
          
          private function sortZ(dParent:DisplayObjectContainer, skip:int = 20) : void
          {
               var bFlipped:Boolean = false;
               var o:int = 0;
               skip = 1;
               if(dParent.numChildren > 60)
               {
                    skip = 10 + (dParent.numChildren - 60);
               }
               var isOdd:int = this.random.nextInt() % skip;
               var i:int = dParent.numChildren - 1 - isOdd;
               while(i > 0)
               {
                    bFlipped = false;
                    o = 0;
                    while(o < i)
                    {
                         if(dParent.getChildAt(o) is com.brockw.stickwar.engine.Entity && dParent.getChildAt(o + 1) is com.brockw.stickwar.engine.Entity)
                         {
                              if(Entity(dParent.getChildAt(o)).py > Entity(dParent.getChildAt(o + 1)).py)
                              {
                                   dParent.swapChildrenAt(o,o + 1);
                                   bFlipped = true;
                              }
                         }
                         o++;
                    }
                    if(!bFlipped)
                    {
                         return;
                    }
                    i -= skip;
               }
          }
          
          public function getPerspectiveScale(y:*) : Number
          {
               return this.backScale + y / this.map.height * (this.frontScale - this.backScale);
          }
          
          public function requestToSpawn(teamName:int, unitType:int) : void
          {
               if(this._teamA.name == teamName)
               {
                    this._teamA.spawnUnit(unitType,this);
               }
               else if(this._teamB.name == teamName)
               {
                    this._teamB.spawnUnit(unitType,this);
               }
          }
          
          public function get screenX() : Number
          {
               return this._screenX;
          }
          
          public function set screenX(value:Number) : void
          {
               this._screenX = value;
          }
          
          override public function executeTurn(turn:Turn) : void
          {
               var move:Move = null;
               while(!turn.moves.isEmpty())
               {
                    move = Move(turn.moves.pop());
                    move.execute(this);
               }
          }
          
          override public function getCheckSum() : int
          {
               var i:String = null;
               var sum2:int = 0;
               var p:Projectile = null;
               var sum3:int = 0;
               var sum:int = 0;
               for(i in this.units)
               {
                    sum += Entity(this.units[i]).px + Entity(this.units[i]).py;
               }
               sum2 = 0;
               for each(p in this._projectileManager.projectiles)
               {
                    sum2 += p.px + p.py;
               }
               sum3 = int(Math.floor(1000 * this.random.lastRandom));
               return sum + sum2 + sum3;
          }
          
          public function get targetScreenX() : Number
          {
               return this._targetScreenX;
          }
          
          public function set targetScreenX(value:Number) : void
          {
               this._targetScreenX = value;
          }
          
          public function get battlefield() : Sprite
          {
               return this._battlefield;
          }
          
          public function set battlefield(value:Sprite) : void
          {
               this._battlefield = value;
          }
          
          public function get background() : com.brockw.stickwar.engine.Background
          {
               return this._background;
          }
          
          public function set background(value:com.brockw.stickwar.engine.Background) : void
          {
               this._background = value;
          }
          
          public function get map() : Map
          {
               return this._map;
          }
          
          public function set map(value:Map) : void
          {
               this._map = value;
          }
          
          public function get teamA() : Team
          {
               return this._teamA;
          }
          
          public function set teamA(value:Team) : void
          {
               this._teamA = value;
          }
          
          public function get teamB() : Team
          {
               return this._teamB;
          }
          
          public function set teamB(value:Team) : void
          {
               this._teamB = value;
          }
          
          public function get spatialHash() : com.brockw.stickwar.engine.SpatialHash
          {
               return this._spatialHash;
          }
          
          public function set spatialHash(value:com.brockw.stickwar.engine.SpatialHash) : void
          {
               this._spatialHash = value;
          }
          
          public function get dualFactory() : DualFactory
          {
               return this._dualFactory;
          }
          
          public function set dualFactory(value:DualFactory) : void
          {
               this._dualFactory = value;
          }
          
          public function get random() : Random
          {
               return this._random;
          }
          
          public function set random(value:Random) : void
          {
               this._random = value;
          }
          
          public function get units() : Dictionary
          {
               return this._units;
          }
          
          public function set units(value:Dictionary) : void
          {
               this._units = value;
          }
          
          public function get unitFactory() : UnitFactory
          {
               return this._unitFactory;
          }
          
          public function set unitFactory(value:UnitFactory) : void
          {
               this._unitFactory = value;
          }
          
          public function get frontScale() : Number
          {
               return _frontScale;
          }
          
          public function set frontScale(value:Number) : void
          {
               _frontScale = value;
          }
          
          public function get backScale() : Number
          {
               return _backScale;
          }
          
          public function set backScale(value:Number) : void
          {
               _backScale = value;
          }
          
          public function get projectileManager() : ProjectileManager
          {
               return this._projectileManager;
          }
          
          public function set projectileManager(value:ProjectileManager) : void
          {
               this._projectileManager = value;
          }
          
          public function get cusorSprite() : com.brockw.stickwar.engine.Entity
          {
               return this._cursorSprite;
          }
          
          public function set cusorSprite(value:com.brockw.stickwar.engine.Entity) : void
          {
               this._cursorSprite = value;
          }
          
          public function get xml() : XMLLoader
          {
               return this._xml;
          }
          
          public function set xml(value:XMLLoader) : void
          {
               this._xml = value;
          }
          
          public function get inEconomy() : Boolean
          {
               return this._inEconomy;
          }
          
          public function set inEconomy(value:Boolean) : void
          {
               this._inEconomy = value;
          }
          
          public function get util() : Util
          {
               return this._util;
          }
          
          public function set util(value:Util) : void
          {
               this._util = value;
          }
          
          public function get tipBox() : com.brockw.stickwar.engine.TipBox
          {
               return this._tipBox;
          }
          
          public function set tipBox(value:com.brockw.stickwar.engine.TipBox) : void
          {
               this._tipBox = value;
          }
          
          public function get team() : Team
          {
               return this._team;
          }
          
          public function set team(value:Team) : void
          {
               this._team = value;
          }
          
          public function get mouseOverUnit() : com.brockw.stickwar.engine.Entity
          {
               return this._mouseOverUnit;
          }
          
          public function set mouseOverUnit(value:com.brockw.stickwar.engine.Entity) : void
          {
               this._mouseOverUnit = value;
          }
          
          public function get main() : BaseMain
          {
               return this._main;
          }
          
          public function set main(value:BaseMain) : void
          {
               this._main = value;
          }
          
          public function get gameScreen() : GameScreen
          {
               return this._gameScreen;
          }
          
          public function set gameScreen(value:GameScreen) : void
          {
               this._gameScreen = value;
          }
          
          public function get incomeDisplay() : com.brockw.stickwar.engine.IncomeDisplay
          {
               return this._incomeDisplay;
          }
          
          public function set incomeDisplay(value:com.brockw.stickwar.engine.IncomeDisplay) : void
          {
               this._incomeDisplay = value;
          }
          
          public function get bloodManager() : com.brockw.stickwar.engine.BloodManager
          {
               return this._bloodManager;
          }
          
          public function set bloodManager(value:com.brockw.stickwar.engine.BloodManager) : void
          {
               this._bloodManager = value;
          }
          
          public function get postCursors() : Array
          {
               return this._postCursors;
          }
          
          public function set postCursors(value:Array) : void
          {
               this._postCursors = value;
          }
          
          public function get fogOfWar() : com.brockw.stickwar.engine.FogOfWar
          {
               return this._fogOfWar;
          }
          
          public function set fogOfWar(value:com.brockw.stickwar.engine.FogOfWar) : void
          {
               this._fogOfWar = value;
          }
          
          public function get commandFactory() : CommandFactory
          {
               return this._commandFactory;
          }
          
          public function set commandFactory(value:CommandFactory) : void
          {
               this._commandFactory = value;
          }
          
          public function get mapId() : int
          {
               return this._mapId;
          }
          
          public function set mapId(value:int) : void
          {
               this._mapId = value;
          }
          
          public function get economyRecords() : Array
          {
               return this._economyRecords;
          }
          
          public function set economyRecords(value:Array) : void
          {
               this._economyRecords = value;
          }
          
          public function get militaryRecords() : Array
          {
               return this._militaryRecords;
          }
          
          public function set militaryRecords(value:Array) : void
          {
               this._militaryRecords = value;
          }
          
          public function get soundManager() : com.brockw.stickwar.engine.SoundManager
          {
               return this._soundManager;
          }
          
          public function set soundManager(value:com.brockw.stickwar.engine.SoundManager) : void
          {
               this._soundManager = value;
          }
          
          public function get cursorSprite() : com.brockw.stickwar.engine.Entity
          {
               return this._cursorSprite;
          }
          
          public function set cursorSprite(value:com.brockw.stickwar.engine.Entity) : void
          {
               this._cursorSprite = value;
          }
          
          public function get showGameOverAnimation() : Boolean
          {
               return this._showGameOverAnimation;
          }
          
          public function set showGameOverAnimation(value:Boolean) : void
          {
               this._showGameOverAnimation = value;
          }
     }
}
