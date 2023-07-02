package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.engine.units.Miner;
   
   public interface Ore
   {
       
      
      function getMiningSpot(param1:Miner) : Number;
      
      function reserveMiningSpot(param1:Miner) : Boolean;
      
      function hasMiningSpot(param1:Miner) : Boolean;
      
      function releaseMiningSpot(param1:Miner) : void;
      
      function mayMine(param1:Miner) : Boolean;
      
      function startMining(param1:Miner) : void;
      
      function stopMining(param1:Miner) : void;
      
      function hitTest(param1:int, param2:int) : Boolean;
      
      function miningRate(param1:int) : Number;
      
      function mine(param1:int, param2:Miner) : Number;
      
      function isMineFull() : Boolean;
      
      function inMineRange(param1:Miner) : Boolean;
      
      function get id() : int;
      
      function set id(param1:int) : void;
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get y() : Number;
      
      function set y(param1:Number) : void;
   }
}
