package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class RemoveTowerCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandStop());
       
      
      public function RemoveTowerCommand(game:StickWar)
      {
         super();
         type = UnitCommand.REMOVE_TOWER_COMMAND;
         hotKey = 83;
         buttonBitmap = actualButtonBitmap;
         _intendedEntityType = Unit.U_CHAOS_TOWER;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Chaos.Units.tower.remove);
         }
         this.isSingleSpell = true;
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
   }
}
