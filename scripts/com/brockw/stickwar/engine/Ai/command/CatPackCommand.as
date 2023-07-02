package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class CatPackCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new packMentalityBitmap());
       
      
      public function CatPackCommand(game:StickWar)
      {
         super();
         type = UnitCommand.CAT_PACK;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_CAT;
         requiresMouseInput = false;
         isSingleSpell = false;
         isActivatable = false;
         this.buttonBitmap = actualButtonBitmap;
         cursor = new nukeCursor();
         if(game != null)
         {
            this.loadXML(game.xml.xml.Chaos.Units.cat.pack);
         }
      }
   }
}
