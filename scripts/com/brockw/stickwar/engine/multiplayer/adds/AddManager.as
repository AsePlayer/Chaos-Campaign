package com.brockw.stickwar.engine.multiplayer.adds
{
   import com.brockw.stickwar.BaseMain;
   import com.brockw.stickwar.Main;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class AddManager extends MovieClip
   {
       
      
      var adds:Array;
      
      var main:BaseMain;
      
      var currentAdd:Add;
      
      public function AddManager(main:BaseMain)
      {
         super();
         this.main = main;
         this.adds = [];
         this.adds.push(new AddItems(this));
         this.adds.push(new AddChaos(this));
      }
      
      public function update() : void
      {
         if(this.currentAdd)
         {
            this.currentAdd.update();
         }
      }
      
      public function exit(e:Event) : void
      {
         this.hideAdd();
      }
      
      public function signUp(e:Event) : void
      {
         this.hideAdd();
         if(this.main is Main)
         {
            this.main.showScreen("armoury");
            Main(this.main).armourScreen.update(null);
            Main(this.main).armourScreen.openPaymentScreen(null);
         }
      }
      
      public function showAdd() : void
      {
         if(this.currentAdd)
         {
            this.adds.push(this.currentAdd);
         }
         this.currentAdd = this.adds.shift();
         addChild(this.currentAdd);
         this.currentAdd.enter();
      }
      
      public function hideAdd() : void
      {
         if(this.currentAdd)
         {
            this.currentAdd.leave();
            this.adds.push(this.currentAdd);
            removeChild(this.currentAdd);
            this.currentAdd = null;
         }
      }
   }
}
