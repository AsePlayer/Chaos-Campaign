package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.engine.units.Miner;
   
   public interface Ore
   {
       
      
      function getMiningSpot(unit:Miner) : Number;
      
      function reserveMiningSpot(unit:Miner) : Boolean;
      
      function hasMiningSpot(unit:Miner) : Boolean;
      
      function releaseMiningSpot(unit:Miner) : void;
      
      function mayMine(unit:Miner) : Boolean;
      
      function startMining(unit:Miner) : void;
      
      function stopMining(unit:Miner) : void;
      
      function hitTest(x:int, y:int) : Boolean;
      
      function miningRate(lvl:int) : Number;
      
      function mine(lvl:int, unit:Miner) : Number;
      
      function isMineFull() : Boolean;
      
      function inMineRange(unit:Miner) : Boolean;
      
      function get id() : int;
      
      function set id(value:int) : void;
      
      function get x() : Number;
      
      function set x(n:Number) : void;
      
      function get y() : Number;
      
      function set y(n:Number) : void;
   }
}
