package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Pool;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Chaos.*;
   import com.brockw.stickwar.engine.Team.Order.*;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class UnitFactory
   {
       
      
      private var pools:Dictionary;
      
      private var _profilePics:Dictionary;
      
      public function UnitFactory(maxUnits:int, game:StickWar)
      {
         super();
         this.pools = new Dictionary();
         this.pools[new Swordwrath(game).type] = new Pool(1,Swordwrath,game);
         this.pools[new Miner(game).type] = new Pool(1,Miner,game);
         this.pools[new Archer(game).type] = new Pool(1,Archer,game);
         this.pools[new Dead(game).type] = new Pool(1,Dead,game);
         this.pools[new Wingidon(game).type] = new Pool(1,Wingidon,game);
         this.pools[new FlyingCrossbowman(game).type] = new Pool(1,FlyingCrossbowman,game);
         this.pools[new Spearton(game).type] = new Pool(1,Spearton,game);
         this.pools[new Ninja(game).type] = new Pool(1,Ninja,game);
         this.pools[new Magikill(game).type] = new Pool(1,Magikill,game);
         this.pools[new Monk(game).type] = new Pool(1,Monk,game);
         this.pools[new EnslavedGiant(game).type] = new Pool(1,EnslavedGiant,game);
         this.pools[new Bomber(game).type] = new Pool(1,Bomber,game);
         this.pools[new Skelator(game).type] = new Pool(1,Skelator,game);
         this.pools[new Cat(game).type] = new Pool(1,Cat,game);
         this.pools[new Knight(game).type] = new Pool(1,Knight,game);
         this.pools[new Medusa(game).type] = new Pool(1,Medusa,game);
         this.pools[new Giant(game).type] = new Pool(1,Giant,game);
         this.pools[new MinerChaos(game).type] = new Pool(1,MinerChaos,game);
         this.pools[new ChaosTower(game).type] = new Pool(1,ChaosTower,game);
         this._profilePics = new Dictionary();
         this._profilePics[new Miner(game).type] = new minerProfile();
         this._profilePics[new Swordwrath(game).type] = new profileSwordwrath();
         this._profilePics[new Archer(game).type] = new profileArchidon();
         this._profilePics[new Dead(game).type] = new deadProfile();
         this._profilePics[new Wingidon(game).type] = new wingadonProfile();
         this._profilePics[new FlyingCrossbowman(game).type] = new profileFlyer();
         this._profilePics[new Spearton(game).type] = new profileSpearton();
         this._profilePics[new Ninja(game).type] = new profileAssassin();
         this._profilePics[new Magikill(game).type] = new profileMagikill();
         this._profilePics[new Monk(game).type] = new profileMonk();
         this._profilePics[new EnslavedGiant(game).type] = new Profile_Slave_Giant();
         this._profilePics[new Bomber(game).type] = new bomberProfile();
         this._profilePics[new Skelator(game).type] = new mageProfile();
         this._profilePics[new Cat(game).type] = new crawlerProfile();
         this._profilePics[new Knight(game).type] = new knightProfile();
         this._profilePics[new Medusa(game).type] = new medusaProfile();
         this._profilePics[new Giant(game).type] = new giantProfile();
         this._profilePics[new MinerChaos(game).type] = new minerProfile();
      }
      
      public function cleanUp() : void
      {
         var key:* = undefined;
         for(key in this.pools)
         {
            this.pools[key].cleanUp();
            this.pools[key] = null;
         }
         this.pools = null;
      }
      
      public function getProfile(type:int) : MovieClip
      {
         return this._profilePics[type];
      }
      
      public function getUnit(type:int) : Unit
      {
         return Unit(Pool(this.pools[type]).getItem());
      }
      
      public function returnUnit(type:int, unit:Unit) : void
      {
         Pool(this.pools[type]).returnItem(unit);
      }
      
      public function get profilePics() : Dictionary
      {
         return this._profilePics;
      }
      
      public function set profilePics(value:Dictionary) : void
      {
         this._profilePics = value;
      }
   }
}
