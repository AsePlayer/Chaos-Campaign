package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.Pool;
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Skelator;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class ProjectileManager
   {
       
      
      private var arrowPool:Pool;
      
      private var gutPool:Pool;
      
      private var boltPool:Pool;
      
      private var electricWallPool:Pool;
      
      private var nukePool:Pool;
      
      private var poisonDartPool:Pool;
      
      private var curePool:Pool;
      
      private var healPool:Pool;
      
      private var _projectiles:Array;
      
      private var _waitingToBeCleaned:Array;
      
      private var _projectileMap:Dictionary;
      
      private var medusaPoisonAmount:int;
      
      private var _airEffects:Array;
      
      private var _game:StickWar;
      
      public function ProjectileManager(game:StickWar)
      {
         super();
         this._game = game;
         this._projectileMap = new Dictionary();
         this._projectileMap[Projectile.ARROW] = new Pool(10,Arrow,game);
         this._projectileMap[Projectile.GUTS] = new Pool(10,Guts,game);
         this._projectileMap[Projectile.BOLT] = new Pool(10,Bolt,game);
         this._projectileMap[Projectile.ELECTRIC_WALL] = new Pool(10,ElectricWall,game);
         this._projectileMap[Projectile.NUKE] = new Pool(10,Nuke,game);
         this._projectileMap[Projectile.WALL_EXPLOSION] = new Pool(10,WallExplosion,game);
         this._projectileMap[Projectile.TOWER_SPAWN] = new Pool(10,TowerSpawn,game);
         this._projectileMap[Projectile.SPAWN_DRIP] = new Pool(10,SpawnDrip,game);
         this._projectileMap[Projectile.POISON_DART] = new Pool(10,PoisonDart,game);
         this._projectileMap[Projectile.CURE] = new Pool(10,Cure,game);
         this._projectileMap[Projectile.HEAL] = new Pool(10,Heal,game);
         this._projectileMap[Projectile.SLOW_DART] = new Pool(10,SlowDart,game);
         this._projectileMap[Projectile.BOULDER] = new Pool(10,Boulder,game);
         this._projectileMap[Projectile.POISON_SPRAY] = new Pool(10,PoisonSpray,game);
         this._projectileMap[Projectile.FIST_ATTACK] = new Pool(10,FistAttack,game);
         this._projectileMap[Projectile.REAPER] = new Pool(10,Reaper,game);
         this._projectileMap[Projectile.POISON_POOL] = new Pool(10,PoisonPool,game);
         this._projectileMap[Projectile.TOWER_DART] = new Pool(10,ChaosTowerDart,game);
         this._projectileMap[Projectile.HEAL_EFFECT] = new Pool(10,HealEffect,game);
         this.projectiles = [];
         this._waitingToBeCleaned = [];
         this._airEffects = [];
         this.medusaPoisonAmount = game.xml.xml.Chaos.Units.medusa.poison.poison;
      }
      
      public function cleanUp() : void
      {
         var _loc1_:Projectile = null;
         for each(_loc1_ in this.projectiles)
         {
            this._projectileMap[_loc1_.type].returnItem(_loc1_);
            if(this._game.battlefield.contains(_loc1_))
            {
               this._game.battlefield.removeChild(_loc1_);
            }
         }
         for each(_loc1_ in this._waitingToBeCleaned)
         {
            this._projectileMap[_loc1_.type].returnItem(_loc1_);
            if(this._game.battlefield.contains(_loc1_))
            {
               this._game.battlefield.removeChild(_loc1_);
            }
         }
         this._waitingToBeCleaned = [];
         this.projectiles = [];
      }
      
      public function initReaper(unit:Unit, target:Unit) : void
      {
         var n:Reaper = Reaper(this._projectileMap[Projectile.REAPER].getItem());
         if(n == null)
         {
            return;
         }
         n.inflictor = unit;
         n.target = target;
         n.init(unit.px,unit.py,unit.pz,target,0,unit.team);
         n.visible = false;
         n.damageToDeal = unit.team.game.xml.xml.Chaos.Units.skelator.reaper.damage;
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
         unit.team.game.soundManager.playSoundRandom("ReaperAir",3,unit.px,unit.py);
      }
      
      public function initFistAttack(x:Number, y:Number, unit:Unit, num:int) : void
      {
         var n:FistAttack = null;
         var dy:Number = NaN;
         var numFloat:Number = NaN;
         n = FistAttack(this._projectileMap[Projectile.FIST_ATTACK].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = false;
         var p:Point = MovieClip(unit.mc).localToGlobal(new Point(0,0));
         var r:Point = unit.team.game.battlefield.globalToLocal(p);
         n.team = unit.team;
         n.x = r.x;
         n.y = r.y;
         n.startX = r.x;
         n.startY = r.y;
         n.endX = x;
         n.endY = y;
         var under:Number = Math.sqrt(Math.pow(n.endX - n.startX,2) + Math.pow(n.endY - n.startY,2));
         var dx:Number = (n.endX - n.startX) / under;
         dy = (n.endY - n.startY) / under;
         numFloat = num + 1.5;
         n.x = n.px = n.startX + dx * numFloat * 400 / 6;
         n.y = n.py = n.startY + dy * numFloat * 400 / 6;
         n.inflictor = unit;
         n.damageToDeal = Skelator(unit).fistDamage;
         n.spellMc.gotoAndStop(1);
         n.stunTime = 0;
         unit.team.game.battlefield.addChild(n);
         this.projectiles.push(n);
         n.visible = false;
         if(n.py < 0)
         {
            n.visible = false;
         }
      }
      
      public function initPoisonSpray(x:Number, y:Number, unit:Unit) : void
      {
         var n:PoisonSpray = null;
         n = PoisonSpray(this._projectileMap[Projectile.POISON_SPRAY].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = false;
         n.px = unit.px;
         n.py = unit.py;
         n.inflictor = unit;
         var p:Point = MovieClip(unit.mc.mc.wizstaff).localToGlobal(new Point(0,0));
         var r:Point = unit.team.game.battlefield.globalToLocal(p);
         n.team = unit.team;
         n.x = r.x;
         n.y = r.y;
         n.startX = r.x;
         n.startY = r.y;
         n.endX = x;
         n.endY = y;
         n.rotation = 180 / Math.PI * Math.atan2(y - n.py,x - n.px);
         n.poisonDamage = unit.team.game.xml.xml.Order.Units.magikill.poisonSpray.damage;
         n.spellMc.gotoAndStop(1);
         n.stunTime = 0;
         unit.team.game.battlefield.addChild(n);
         this.projectiles.push(n);
      }
      
      public function initSlowDart(x:Number, y:Number, z:Number, unit:Unit, target:Unit) : void
      {
         var n:SlowDart = SlowDart(this._projectileMap[Projectile.SLOW_DART].getItem());
         if(n == null)
         {
            return;
         }
         n.inflictor = unit;
         n.init(x,y,z,target,0,unit.team);
         n.slowFrames = target.team.game.xml.xml.Order.Units.monk.slowFrames;
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
         n.visible = false;
      }
      
      public function initTowerDart(x:Number, y:Number, z:Number, unit:Unit, target:Unit) : void
      {
         var n:ChaosTowerDart = ChaosTowerDart(this._projectileMap[Projectile.TOWER_DART].getItem());
         if(n == null)
         {
            return;
         }
         n.inflictor = unit;
         n.init(x,y,z,target,0,unit.team);
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
         n.visible = false;
      }
      
      public function initArrow(x:Number, y:Number, rotation:Number, velocity:Number, targetY:Number, dy:Number, unit:Unit, damage:Number, poison:Number, isFire:Boolean, area:Number = 0, areaDamage:Number = 0) : void
      {
         var n:Arrow = Arrow(this._projectileMap[Projectile.ARROW].getItem());
         n.setArrowGraphics(isFire > 0 ? Boolean(true) : Boolean(false));
         n.isFire = isFire;
         if(n == null)
         {
            return;
         }
         n.initProjectile();
         n.px = x;
         n.py = unit.py;
         n.pz = y - unit.py;
         var scale:Number = unit.team.game.backScale + unit.py / unit.team.game.map.height * (unit.team.game.frontScale - unit.team.game.backScale);
         n.inflictor = unit;
         n.scaleX = scale;
         n.scaleY = scale;
         n.dx = velocity * Util.cos(rotation * Math.PI / 180);
         n.dz = velocity * Util.sin(rotation * Math.PI / 180);
         n.dy = dy;
         n.team = unit.team;
         n.x = -100;
         n.y = -100;
         n.damageToDeal = damage;
         n.stunTime = 0;
         n.poisonDamage = poison;
         n.visible = false;
         n.area = area;
         n.areaDamage = areaDamage;
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
         n.update(unit.team.game);
         n.update(unit.team.game);
      }
      
      public function initBoulder(x:Number, y:Number, rotation:Number, velocity:Number, targetY:Number, dy:Number, unit:Unit, damage:Number, isDebris:Boolean) : void
      {
         var n:Boulder = Boulder(this._projectileMap[Projectile.BOULDER].getItem());
         if(n == null)
         {
            return;
         }
         var scale:Number = unit.team.game.backScale + unit.py / unit.team.game.map.height * (unit.team.game.frontScale - unit.team.game.backScale);
         n.initProjectile();
         n.px = x;
         n.py = unit.py;
         n.pz = y - unit.py;
         n.inflictor = unit;
         n.dx = velocity * Util.cos(rotation * Math.PI / 180);
         n.dz = velocity * Util.sin(rotation * Math.PI / 180);
         n.dy = dy;
         n.team = unit.team;
         n.x = -100;
         n.y = -100;
         n.scale = 1;
         n.stunTime = 0;
         n.drotation = unit.team.game.random.nextInt() % 4 - 2;
         n.rot = unit.team.game.random.nextInt() % 360;
         n.isDebris = false;
         this.projectiles.push(n);
         n.visible = false;
         unit.team.game.battlefield.addChild(n);
      }
      
      public function initBoulderDebris(x:Number, y:Number, z:Number, dx:Number, dy:Number, dz:Number, scale:Number, game:StickWar, inflictor:Unit, fromUnit:Unit) : void
      {
         var n:Boulder = Boulder(this._projectileMap[Projectile.BOULDER].getItem());
         if(n == null)
         {
            return;
         }
         n.initProjectile();
         n.visible = false;
         n.px = x;
         n.py = y;
         n.pz = z;
         n.dx = dx;
         n.dz = dz;
         n.dy = dy;
         n.x = -100;
         n.y = -100;
         n.isDebris = true;
         n.inflictor = null;
         n.unitNotToHit = fromUnit;
         n.scale = scale;
         n.damageToDeal = game.xml.xml.Order.Units.giant.debrisDamage;
         n.stunTime = 0;
         n.drotation = game.random.nextInt() % 4 - 2;
         n.rot = game.random.nextInt() % 360;
         this.projectiles.push(n);
         game.battlefield.addChild(n);
      }
      
      public function initBolt(x:Number, y:Number, rotation:Number, velocity:Number, targetY:Number, dy:Number, unit:Unit, damage:Number, slowFrames:int, isFire:Boolean) : void
      {
         var n:Bolt = Bolt(this._projectileMap[Projectile.BOLT].getItem());
         if(n == null)
         {
            return;
         }
         n.initProjectile();
         n.visible = false;
         n.inflictor = unit;
         var scale:Number = unit.team.game.backScale + unit.py / unit.team.game.map.height * (unit.team.game.frontScale - unit.team.game.backScale);
         n.px = x;
         n.py = unit.py;
         n.pz = y - unit.py;
         n.dx = velocity * Util.cos(rotation * Math.PI / 180);
         n.dz = velocity * Util.sin(rotation * Math.PI / 180);
         n.dy = dy;
         n.team = unit.team;
         n.x = -100;
         n.y = -100;
         n.damageToDeal = damage;
         n.slowFrames = 0;
         n.isFire = isFire;
         n.setArrowGraphics(isFire);
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
         n.update(unit.team.game);
         n.update(unit.team.game);
         n.update(unit.team.game);
      }
      
      public function initGuts(x:Number, y:Number, rotation:Number, velocity:Number, targetY:Number, dy:Number, poisonDamage:Number, unit:Unit) : void
      {
         var n:Guts = Guts(this._projectileMap[Projectile.GUTS].getItem());
         if(n == null)
         {
            return;
         }
         n.initProjectile();
         n.visible = true;
         n.px = x;
         n.py = unit.py;
         n.pz = y - unit.py;
         n.inflictor = unit;
         n.poisonDamage = poisonDamage;
         n.dx = velocity * Util.cos(rotation * Math.PI / 180);
         n.dz = velocity * Util.sin(rotation * Math.PI / 180);
         n.dy = dy;
         n.team = unit.team;
         n.x = -100;
         n.y = -100;
         n.drotation = unit.team.game.random.nextInt() % 4 - 2;
         n.rot = unit.team.game.random.nextInt() % 360;
         n.stunTime = 0;
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
      }
      
      public function initStun(x:Number, y:Number, damage:int, unit:Unit) : void
      {
         var n:ElectricWall = ElectricWall(this._projectileMap[Projectile.ELECTRIC_WALL].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         if(Math.abs(x - unit.x) > unit.team.game.xml.xml.Order.Units.magikill.electricWall.range)
         {
            x = -unit.team.game.xml.xml.Order.Units.magikill.electricWall.area / 2 + unit.x + Util.sgn(x - unit.x) * unit.team.game.xml.xml.Order.Units.magikill.electricWall.range;
         }
         n.inflictor = unit;
         n.damageToDeal = unit.team.game.xml.xml.Order.Units.magikill.electricWall.damage;
         n.px = x;
         n.py = 0;
         n.spellMc.height = unit.team.game.map.height;
         n.team = unit.team;
         n.x = n.px;
         n.y = n.py;
         n.spellMc.gotoAndStop(1);
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
         unit.team.game.soundManager.playSound("ElectricWallSoundEffect",x,y);
      }
      
      public function initNuke(x:Number, y:Number, unit:Unit, damage:Number) : void
      {
         var n:Nuke = Nuke(this._projectileMap[Projectile.NUKE].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         if(Math.abs(x - unit.px) > unit.team.game.xml.xml.Order.Units.magikill.nuke.range)
         {
            x = unit.px + Util.sgn(x - unit.px) * unit.team.game.xml.xml.Order.Units.magikill.nuke.range;
         }
         n.inflictor = unit;
         if(n.inflictor.type == Unit.U_BOMBER)
         {
            n.whoNuked = n.inflictor.bomberType;
         }
         if(n.whoNuked == "minerTargeter")
         {
            damage /= 2;
         }
         n.px = x;
         n.py = y;
         n.team = unit.team;
         n.x = n.px;
         n.y = n.py;
         Util.animateToNeutral(n.spellMc);
         n.spellMc.gotoAndStop(1);
         n.stunTime = 0;
         n.explosionDamage = damage;
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
         unit.team.game.bloodManager.addAsh(x,y,unit.team.direction,unit.team.game);
      }
      
      public function initWallExplosion(x:Number, y:Number, team:Team) : void
      {
         var n:WallExplosion = WallExplosion(this._projectileMap[Projectile.WALL_EXPLOSION].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         n.px = x;
         n.py = y;
         n.x = n.px;
         n.y = n.py;
         Util.animateToNeutral(n.spellMc);
         n.spellMc.gotoAndStop(1);
         n.stunTime = 0;
         this.projectiles.push(n);
         team.game.battlefield.addChild(n);
         team.game.bloodManager.addAsh(x,y,team.direction,team.game);
      }
      
      public function initTowerSpawn(x:Number, y:Number, team:Team, scale:Number = 1) : void
      {
         var n:TowerSpawn = TowerSpawn(this._projectileMap[Projectile.TOWER_SPAWN].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         n.px = x;
         n.py = y;
         n.x = n.px;
         n.y = n.py;
         Util.animateToNeutral(n.spellMc);
         n.spellMc.gotoAndStop(1);
         n.scale = scale;
         n.stunTime = 0;
         this.projectiles.push(n);
         team.game.battlefield.addChild(n);
         n.team = team;
      }
      
      public function initSpawnDrip(x:Number, y:Number, team:Team) : void
      {
         var n:SpawnDrip = SpawnDrip(this._projectileMap[Projectile.SPAWN_DRIP].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         n.px = x;
         n.py = y;
         n.x = n.px;
         n.y = n.py;
         Util.animateToNeutral(n.spellMc);
         n.spellMc.gotoAndStop(1);
         n.stunTime = 0;
         this.projectiles.push(n);
         team.game.battlefield.addChild(n);
         n.team = team;
      }
      
      public function initHealEffect(x:Number, y:Number, py:Number, team:Team, unit:Unit, isCure:Boolean = false) : void
      {
         var n:HealEffect = HealEffect(this._projectileMap[Projectile.HEAL_EFFECT].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         n.isCure = isCure;
         n.unit = unit;
         n.px = x;
         n.py = py;
         n.x = n.px;
         n.y = y;
         Util.animateToNeutral(n.spellMc);
         n.spellMc.gotoAndStop(1);
         n.stunTime = 0;
         this.projectiles.push(n);
         team.game.battlefield.addChild(n);
         n.team = team;
      }
      
      public function initPoisonPool(x:Number, y:Number, unit:Unit, damage:Number) : void
      {
         var n:PoisonPool = PoisonPool(this._projectileMap[Projectile.POISON_POOL].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         if(Math.abs(x - unit.px) > unit.team.game.xml.xml.Chaos.Units.medusa.poison.range)
         {
            x = unit.x + Util.sgn(x - unit.px) * unit.team.game.xml.xml.Chaos.Units.medusa.poison.range;
         }
         n.inflictor = unit;
         n.px = x;
         n.py = y;
         n.team = unit.team;
         n.x = n.px;
         n.y = n.py;
         Util.animateToNeutral(n.spellMc);
         n.frames = 0;
         n.scaleX = Util.sgn(unit.mc.scaleX);
         n.spellMc.gotoAndStop(1);
         n.poisonDamage = this.medusaPoisonAmount;
         n.stunTime = 0;
         n.explosionDamage = damage;
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
      }
      
      public function initCure(x:Number, y:Number, nukeDamage:Number, unit:Unit) : void
      {
         var n:Cure = Cure(this._projectileMap[Projectile.CURE].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         n.inflictor = unit;
         n.px = x;
         n.py = y;
         n.team = unit.team;
         n.x = n.px;
         n.y = n.py;
         n.spellMc.gotoAndStop(1);
         n.stunTime = 0;
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
      }
      
      public function initHeal(x:Number, y:Number, nukeDamage:Number, unit:Unit) : void
      {
         var n:Heal = Heal(this._projectileMap[Projectile.HEAL].getItem());
         if(n == null)
         {
            return;
         }
         n.visible = true;
         n.inflictor = unit;
         n.px = x;
         n.py = y;
         n.team = unit.team;
         n.x = n.px;
         n.y = n.py;
         n.spellMc.gotoAndStop(1);
         n.stunTime = 0;
         this.projectiles.push(n);
         unit.team.game.battlefield.addChild(n);
      }
      
      public function update(param1:StickWar) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Projectile = null;
         _loc2_ = 0;
         while(_loc2_ < this.projectiles.length)
         {
            if(!Projectile(this.projectiles[_loc2_]).isInFlight())
            {
               _loc3_ = this.projectiles.splice(_loc2_,1)[0];
               _loc3_.framesDead = 0;
               this._waitingToBeCleaned.push(_loc3_);
            }
            else
            {
               this.projectiles[_loc2_].update(param1);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._waitingToBeCleaned.length)
         {
            ++this._waitingToBeCleaned[_loc2_].framesDead;
            _loc2_++;
         }
         while(this._waitingToBeCleaned.length != 0 && this._waitingToBeCleaned[0].isReadyForCleanup())
         {
            _loc3_ = this._waitingToBeCleaned.shift();
            if(param1.battlefield.contains(_loc3_))
            {
               param1.battlefield.removeChild(_loc3_);
            }
            this._projectileMap[_loc3_.type].returnItem(_loc3_);
         }
      }
      
      public function get projectiles() : Array
      {
         return this._projectiles;
      }
      
      public function set projectiles(value:Array) : void
      {
         this._projectiles = value;
      }
      
      public function get airEffects() : Array
      {
         return this._airEffects;
      }
      
      public function set airEffects(value:Array) : void
      {
         this._airEffects = value;
      }
   }
}
