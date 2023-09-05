package com.brockw.stickwar.engine.dual
{
     import com.brockw.stickwar.engine.StickWar;
     import com.brockw.stickwar.engine.units.*;
     import flash.utils.Dictionary;
     
     public class DualFactory
     {
           
          
          private var duals:Dictionary;
          
          public function DualFactory(game:StickWar)
          {
               var unitA:String = null;
               var unitB:String = null;
               super();
               var units:Array = [new Swordwrath(game),new Miner(game),new Archer(game),new Spearton(game),new Cat(game),new Knight(game)];
               this.duals = new Dictionary();
               for(unitA in units)
               {
                    this.duals[Unit(units[unitA]).type] = new Dictionary();
                    for(unitB in units)
                    {
                         Dictionary(this.duals[Unit(units[unitA]).type])[Unit(units[unitB]).type] = this.createDuals(Unit(units[unitA]),Unit(units[unitB]));
                    }
               }
          }
          
          public function cleanUp() : void
          {
          }
          
          private function createDuals(unitA:Unit, unitB:Unit) : Array
          {
               var a:String = null;
               var b:String = null;
               var dual:Dual = null;
               var duals:Array = [];
               for(a in unitA.syncAttackLabels)
               {
                    for(b in unitB.syncDefendLabels)
                    {
                         if(unitA.syncAttackLabels[a][0] == unitB.syncDefendLabels[b])
                         {
                              dual = new Dual();
                              dual.attackLabel = "syncAttack_" + unitA.syncAttackLabels[a][0] + "_" + unitA.syncAttackLabels[a][1] + "_" + unitA.syncAttackLabels[a][2];
                              dual.defendLabel = "syncDefend_" + unitB.syncDefendLabels[a];
                              dual.yDiff = 0;
                              dual.xDiff = unitA.syncAttackLabels[a][1];
                              dual.finalXOffset = unitA.syncAttackLabels[a][2];
                              duals.push(dual);
                         }
                    }
               }
               return duals;
          }
          
          public function getDuals(typeA:int, typeB:int) : Array
          {
               var duals:Array = null;
               if(typeA in this.duals && typeB in this.duals[typeA])
               {
                    duals = this.duals[typeA][typeB];
                    if(duals == null)
                    {
                         return null;
                    }
                    if(duals.length == 0)
                    {
                         return null;
                    }
                    return duals;
               }
               return null;
          }
     }
}
