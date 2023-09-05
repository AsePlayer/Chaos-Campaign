package com.brockw.stickwar.engine.maps
{
     import com.brockw.stickwar.engine.Entity;
     import com.brockw.stickwar.engine.Gold;
     import com.brockw.stickwar.engine.Hill;
     import com.brockw.stickwar.engine.Ore;
     import com.brockw.stickwar.engine.StickWar;
     import flash.display.MovieClip;
     
     public class Map
     {
          
          public static const M_ICE_WORLD:int = 0;
          
          public static const M_GRASS_HILLS:int = 1;
          
          public static const M_SWAMP_LANDS:int = 2;
          
          public static const M_DESERT:int = 3;
          
          public static const M_FOREST:int = 4;
          
          public static const M_MOUNTAINS:int = 5;
          
          public static const M_GATES:int = 6;
          
          public static const M_CASTLE:int = 7;
          
          public static const M_HALLOWEEN:int = 8;
           
          
          private var _width:int;
          
          private var _height:int;
          
          private var _y:int;
          
          private var _screenWidth:int;
          
          private var _screenHeight:int;
          
          private var _gold:Vector.<Ore>;
          
          private var _hills:Vector.<Hill>;
          
          public function Map()
          {
               super();
               this._gold = new Vector.<Ore>();
               this._hills = new Vector.<Hill>();
          }
          
          public static function getMapNameFromId(id:int) : String
          {
               if(id == M_ICE_WORLD)
               {
                    return "Ice World";
               }
               if(id == M_GRASS_HILLS)
               {
                    return "Grass Hills";
               }
               if(id == M_SWAMP_LANDS)
               {
                    return "Swamp Lands";
               }
               if(id == M_DESERT)
               {
                    return "Desert";
               }
               if(id == M_FOREST)
               {
                    return "Forest";
               }
               if(id == M_MOUNTAINS)
               {
                    return "Mountains";
               }
               if(id == M_GATES)
               {
                    return "Gates";
               }
               if(id == M_CASTLE)
               {
                    return "Castle";
               }
               if(id == M_HALLOWEEN)
               {
                    return "Halloween";
               }
               return "Bad ID";
          }
          
          public static function getMapDisplayFromId(id:int) : MovieClip
          {
               if(id == M_ICE_WORLD)
               {
                    return new iceWorldDisplayMc();
               }
               if(id == M_GRASS_HILLS)
               {
                    return new grassHillsDisplayMc();
               }
               if(id == M_SWAMP_LANDS)
               {
                    return new swampDisplayMc();
               }
               if(id == M_DESERT)
               {
                    return new desertDisplayMc();
               }
               if(id == M_FOREST)
               {
                    return new forestDisplayMc();
               }
               if(id == M_MOUNTAINS)
               {
                    return new iceWorldDisplayMc();
               }
               if(id == M_GATES)
               {
                    return new gatesDisplayMc();
               }
               if(id == M_CASTLE)
               {
                    return new castleDisplayMc();
               }
               if(id == M_HALLOWEEN)
               {
                    return new halloweanDisplayMc();
               }
               return new iceWorldDisplayMc();
          }
          
          public static function getMapFromId(id:int, game:StickWar) : Map
          {
               if(id == M_ICE_WORLD)
               {
                    return new IceWorld(game);
               }
               if(id == M_GRASS_HILLS)
               {
                    return new GrassHills(game);
               }
               if(id == M_SWAMP_LANDS)
               {
                    return new SwampLands(game);
               }
               if(id == M_DESERT)
               {
                    return new Desert(game);
               }
               if(id == M_FOREST)
               {
                    return new Forest(game);
               }
               if(id == M_MOUNTAINS)
               {
                    return new Mountains(game);
               }
               if(id == M_GATES)
               {
                    return new Gates(game);
               }
               if(id == M_CASTLE)
               {
                    return new CastleLevel(game);
               }
               if(id == M_HALLOWEEN)
               {
                    return new Halloween(game);
               }
               return new IceWorld(game);
          }
          
          protected function compareX(a:Entity, b:Entity) : int
          {
               return a.px - b.px;
          }
          
          protected function createMiningBlock(game:StickWar, pos:Number, dir:int) : void
          {
               var o:Gold = new Gold(game);
               o.init(pos + dir * -10,this._height / 2 - 100,game.xml.xml.goldAtStartOfMap,game);
               this._gold.push(o);
               game.units[o.id] = o;
               o = new Gold(game);
               o.init(pos + dir * -10,this._height / 2 + 100,game.xml.xml.goldAtStartOfMap,game);
               this._gold.push(o);
               game.units[o.id] = o;
               o = new Gold(game);
               o = new Gold(game);
               o.init(pos + dir * 70,this._height / 2 - 60,game.xml.xml.goldAtStartOfMap,game);
               this._gold.push(o);
               game.units[o.id] = o;
               o = new Gold(game);
               o.init(pos + dir * 70,this._height / 2 + 60,game.xml.xml.goldAtStartOfMap,game);
               this._gold.push(o);
               game.units[o.id] = o;
          }
          
          protected function setDimensions(game:StickWar) : void
          {
               this.width = game.background.mapLength;
               this.height = game.xml.xml.battlefieldHeight;
               this.y = game.xml.xml.battlefieldY;
               this.screenWidth = game.stage.stageWidth;
               this.screenHeight = game.stage.stageHeight;
          }
          
          public function init(game:StickWar) : void
          {
               this._gold.sort(this.compareX);
          }
          
          public function addElementsToMap(game:*) : void
          {
               var h:Hill = null;
               var g:Gold = null;
               for(var i:int = 0; i < this._gold.length; i++)
               {
                    g = Gold(this._gold[i]);
                    game.battlefield.addChild(g.frontOre);
                    game.battlefield.addChild(g.ore);
               }
               for each(h in this.hills)
               {
                    game.battlefield.addChild(h);
               }
          }
          
          public function get y() : int
          {
               return this._y;
          }
          
          public function set y(value:int) : void
          {
               this._y = value;
          }
          
          public function get width() : int
          {
               return this._width;
          }
          
          public function set width(value:int) : void
          {
               this._width = value;
          }
          
          public function get height() : int
          {
               return this._height;
          }
          
          public function set height(value:int) : void
          {
               this._height = value;
          }
          
          public function get gold() : Vector.<Ore>
          {
               return this._gold;
          }
          
          public function set gold(value:Vector.<Ore>) : void
          {
               this._gold = value;
          }
          
          public function get screenWidth() : int
          {
               return this._screenWidth;
          }
          
          public function set screenWidth(value:int) : void
          {
               this._screenWidth = value;
          }
          
          public function get screenHeight() : int
          {
               return this._screenHeight;
          }
          
          public function set screenHeight(value:int) : void
          {
               this._screenHeight = value;
          }
          
          public function get hills() : Vector.<Hill>
          {
               return this._hills;
          }
          
          public function set hills(value:Vector.<Hill>) : void
          {
               this._hills = value;
          }
     }
}
