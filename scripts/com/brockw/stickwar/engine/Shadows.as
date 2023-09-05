package com.brockw.stickwar.engine
{
     import com.brockw.stickwar.engine.maps.Map;
     import com.brockw.stickwar.engine.projectile.Projectile;
     import com.brockw.stickwar.engine.units.Statue;
     import com.brockw.stickwar.engine.units.Unit;
     import com.brockw.stickwar.engine.units.Wingidon;
     import flash.display.Bitmap;
     import flash.display.BitmapData;
     import flash.geom.ColorTransform;
     import flash.geom.Matrix;
     import flash.geom.Rectangle;
     
     public class Shadows extends Bitmap
     {
           
          
          private var shadowBitmap:BitmapData;
          
          private var map:Map;
          
          private var shadowTransform:Matrix;
          
          private var rec:Rectangle;
          
          private var c:ColorTransform;
          
          public function Shadows(map:Map)
          {
               this.shadowBitmap = new BitmapData(map.screenWidth,map.height,true,0);
               this.map = map;
               this.shadowTransform = new Matrix();
               this.rec = new Rectangle(0,0,map.screenWidth,map.height);
               this.c = new ColorTransform(0,0,0,1,0,0,0,0);
               super(this.shadowBitmap);
          }
          
          public function update(game:StickWar) : void
          {
               var u:Entity = null;
               this.shadowBitmap.fillRect(this.rec,0);
               for(var i:int = 0; i < game.battlefield.numChildren; i++)
               {
                    u = Entity(game.battlefield.getChildAt(i));
                    if(u is Unit)
                    {
                         if(u is Unit && !(u is Statue))
                         {
                              Unit(u).healthBar.visible = false;
                         }
                         this.shadowTransform.identity();
                         if(u is Wingidon)
                         {
                              this.shadowTransform.scale(u.scaleX * 1,1 * -1 * u.scaleY + Math.pow(Math.abs(u.x - this.map.width / 2) / 1000,1.5) * 0.2);
                              this.shadowTransform.translate(u.x - game.screenX,Wingidon(u).py);
                         }
                         else if(u is Projectile)
                         {
                              this.shadowTransform.scale(u.scaleX * 1,1 * -1 * u.scaleY + Math.pow(Math.abs(u.x - this.map.width / 2) / 1000,1.5) * 0.2);
                              this.shadowTransform.translate(u.x - game.screenX,Projectile(u).py);
                         }
                         else
                         {
                              this.shadowTransform.scale(u.scaleX,-1 * u.scaleY + Math.pow(Math.abs(u.px - this.map.width / 2) / 1000,1.5) * 0.2);
                              this.shadowTransform.translate(u.px - game.screenX,u.py);
                         }
                         this.shadowTransform.c = Math.tan((u.x - this.map.width / 2) / 1000 * -35 * ((1 - 1) * 0.5 + 0.5) * Math.PI / 180);
                         this.shadowBitmap.draw(u,this.shadowTransform,this.c);
                         if(u is Unit && !(u is Statue))
                         {
                              Unit(u).healthBar.visible = true;
                         }
                    }
               }
          }
     }
}
