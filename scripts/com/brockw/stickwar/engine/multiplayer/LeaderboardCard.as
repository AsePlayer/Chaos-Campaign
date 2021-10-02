package com.brockw.stickwar.engine.multiplayer
{
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class LeaderboardCard extends rankEntryMc
   {
       
      
      private var wins:int;
      
      private var loses:int;
      
      private var _rating:int;
      
      private var rank:int;
      
      public function LeaderboardCard(data:SFSObject)
      {
         super();
         this.wins = data.getInt("w");
         this.loses = data.getInt("l");
         this.rating = data.getInt("r");
         name = data.getUtfString("n");
         this.rank = -1;
         this.nameText.text = name;
         this.winText.text = "" + this.wins + "/" + this.loses;
         this.rankText.text = "N/A";
         this.ratingText.text = "" + this.rating;
      }
      
      public function setRank(rank:int) : *
      {
         this.rank = rank;
         this.rankText.text = "" + rank;
      }
      
      public function get rating() : int
      {
         return this._rating;
      }
      
      public function set rating(value:int) : void
      {
         this._rating = value;
      }
   }
}
