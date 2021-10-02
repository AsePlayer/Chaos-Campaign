package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.engine.units.Wall;
   import flash.utils.Dictionary;
   
   public class SpatialHash
   {
       
      
      private var partitions:Vector.<Vector.<Entity>>;
      
      private var partitionSizes:Vector.<int>;
      
      private var width:Number;
      
      private var height:Number;
      
      private var boxWidth:Number;
      
      private var boxHeight:Number;
      
      private var cols:int;
      
      private var rows:int;
      
      var visited:Dictionary;
      
      var game:StickWar;
      
      public function SpatialHash(game:StickWar, width:Number, height:Number, boxWidth:Number, boxHeight:Number, maxEntitys:int)
      {
         var x:int = 0;
         super();
         this.game = game;
         this.partitions = new Vector.<Vector.<Entity>>(width / boxWidth * height / boxHeight,false);
         this.partitionSizes = new Vector.<int>(width / boxWidth * height / boxHeight,false);
         this.visited = new Dictionary();
         this.width = width;
         this.height = height;
         this.boxWidth = boxWidth;
         this.boxHeight = boxHeight;
         this.rows = height / boxHeight;
         this.cols = width / boxWidth;
         for(var y:int = 0; y < this.rows; y++)
         {
            for(x = 0; x < this.cols; x++)
            {
               this.partitions[this.cols * y + x] = new Vector.<Entity>(maxEntitys,false);
               this.partitionSizes[this.cols * y + x] = 0;
            }
         }
      }
      
      public function cleanUp() : void
      {
         var x:int = 0;
         var i:int = 0;
         for(var y:int = 0; y < this.rows; y++)
         {
            for(x = 0; x < this.cols; x++)
            {
               for(i = 0; i < this.partitions[this.cols * y + x].length; i++)
               {
                  this.partitions[this.cols * y + x][i] = null;
               }
               this.partitions[this.cols * y + x] = null;
            }
         }
         this.partitions = null;
         this.partitionSizes = null;
      }
      
      public function add(entity:Entity) : void
      {
         var x:int = entity.px / this.boxWidth;
         var y:int = entity.py / this.boxHeight;
         if(x < 0 || x >= this.cols || y < 0 || y >= this.rows)
         {
            return;
         }
         Vector.<Entity>(this.partitions[this.cols * y + x])[this.partitionSizes[this.cols * y + x]] = entity;
         ++this.partitionSizes[this.cols * y + x];
         if(x > 0)
         {
            Vector.<Entity>(this.partitions[this.cols * y + x - 1])[this.partitionSizes[this.cols * y + x - 1]] = entity;
            ++this.partitionSizes[this.cols * y + x - 1];
         }
         if(y > 0)
         {
            Vector.<Entity>(this.partitions[this.cols * (y - 1) + x])[this.partitionSizes[this.cols * (y - 1) + x]] = entity;
            ++this.partitionSizes[this.cols * (y - 1) + x];
         }
         if(y < this.rows - 1)
         {
            Vector.<Entity>(this.partitions[this.cols * (y + 1) + x])[this.partitionSizes[this.cols * (y + 1) + x]] = entity;
            ++this.partitionSizes[this.cols * (y + 1) + x];
         }
         if(x < this.cols - 1)
         {
            Vector.<Entity>(this.partitions[this.cols * y + x + 1])[this.partitionSizes[this.cols * y + x + 1]] = entity;
            ++this.partitionSizes[this.cols * y + x + 1];
         }
      }
      
      public function mapInArea(xs:Number, ys:Number, xe:Number, ye:Number, f:Function, includeWalls:Boolean = true) : void
      {
         var _loc10_:* = null;
         var _loc11_:Wall = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc7_:Number = Math.min(xs,xe);
         var _loc8_:Number = Math.max(xs,xe);
         if(includeWalls)
         {
            for each(_loc11_ in this.game.teamA.walls)
            {
               if(_loc11_.px > _loc7_ && _loc11_.px < _loc8_)
               {
                  f(_loc11_);
               }
            }
            for each(_loc11_ in this.game.teamB.walls)
            {
               if(_loc11_.px > _loc7_ && _loc11_.px < _loc8_)
               {
                  f(_loc11_);
               }
            }
         }
         xs /= this.boxWidth;
         ys /= this.boxHeight;
         xe /= this.boxWidth;
         ye /= this.boxHeight;
         for(var _loc9_:int = xs; _loc9_ < xe; _loc9_++)
         {
            for(_loc12_ = ys; _loc12_ < ye; _loc12_++)
            {
               if(!(this.cols * _loc12_ + _loc9_ < 0 || this.cols * _loc12_ + _loc9_ >= this.partitions.length))
               {
                  for(_loc13_ = 0; _loc13_ < this.partitionSizes[this.cols * _loc12_ + _loc9_]; _loc13_++)
                  {
                     if(!(this.partitions[this.cols * _loc12_ + _loc9_][_loc13_].id in this.visited))
                     {
                        f(this.partitions[this.cols * _loc12_ + _loc9_][_loc13_]);
                        this.visited[this.partitions[this.cols * _loc12_ + _loc9_][_loc13_].id] = 0;
                     }
                  }
               }
            }
         }
         for(_loc10_ in this.visited)
         {
            delete this.visited[_loc10_];
         }
      }
      
      public function getNearbyEntitys(entity:Entity) : Vector.<Entity>
      {
         var x:int = entity.px / this.boxWidth;
         var y:int = entity.py / this.boxHeight;
         if(this.cols * y + x < 0 || this.cols * y + x >= this.partitions.length)
         {
            return new Vector.<Entity>();
         }
         return this.partitions[this.cols * y + x];
      }
      
      public function getNearbyEntitysXY(x:Number, y:Number) : Vector.<Entity>
      {
         x = Math.floor(x / this.boxWidth);
         y = Math.floor(y / this.boxHeight);
         if(this.cols * y + x < 0 || this.cols * y + x >= this.partitions.length)
         {
            return new Vector.<Entity>();
         }
         return this.partitions[this.cols * y + x];
      }
      
      public function getNumberOfNearbyEntitysXY(x:Number, y:Number) : int
      {
         x = Math.floor(x / this.boxWidth);
         y = Math.floor(y / this.boxHeight);
         if(this.cols * y + x < 0 || this.cols * y + x >= this.partitions.length)
         {
            return 0;
         }
         return this.partitionSizes[this.cols * y + x];
      }
      
      public function getNumberOfNearbyEntitys(entity:Entity) : int
      {
         var x:int = entity.px / this.boxWidth;
         var y:int = entity.py / this.boxHeight;
         if(this.cols * y + x < 0 || this.cols * y + x >= this.partitions.length)
         {
            return 0;
         }
         return this.partitionSizes[this.cols * y + x];
      }
      
      public function clear() : void
      {
         var x:int = 0;
         for(var y:int = 0; y < this.rows; y++)
         {
            for(x = 0; x < this.cols; x++)
            {
               this.partitionSizes[this.cols * y + x] = 0;
            }
         }
      }
   }
}
