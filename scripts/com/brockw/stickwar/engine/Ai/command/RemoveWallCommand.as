package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   
   public class RemoveWallCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandStop());
       
      
      public function RemoveWallCommand(game:StickWar)
      {
         super();
         type = UnitCommand.REMOVE_WALL_COMMAND;
         hotKey = 83;
         buttonBitmap = actualButtonBitmap;
         _intendedEntityType = Unit.U_WALL;
         if(game != null)
         {
            this.loadXML(game.xml.xml.Order.Units.wall.remove);
         }
         this.isSingleSpell = true;
      }
      
      override public function isFinished(unit:Unit) : Boolean
      {
         return false;
      }
   }
}
