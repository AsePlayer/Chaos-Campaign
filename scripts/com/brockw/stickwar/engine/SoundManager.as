package com.brockw.stickwar.engine
{
     import com.brockw.stickwar.BaseMain;
     import flash.events.Event;
     import flash.events.TimerEvent;
     import flash.media.Sound;
     import flash.media.SoundChannel;
     import flash.media.SoundTransform;
     import flash.utils.Dictionary;
     import flash.utils.Timer;
     
     public class SoundManager
     {
          
          private static const globalSoundModifier:Number = 1.4;
           
          
          internal var sounds:Dictionary;
          
          internal var volumeMap:Dictionary;
          
          private var main:BaseMain;
          
          internal var playing:Array;
          
          internal var waiting:Array;
          
          private var lastX:Number;
          
          private var lastY:Number;
          
          private var _isMusic:Boolean;
          
          private var _isSound:Boolean;
          
          private var backgroundLoop:SoundChannel;
          
          private var backgroundVolume:Number;
          
          private var currentBackgroundName:String;
          
          private var targetBackgroundVolume:Number;
          
          private var timer:Timer;
          
          public function SoundManager(main:BaseMain)
          {
               super();
               this.sounds = new Dictionary();
               this.volumeMap = new Dictionary();
               this.main = main;
               this.playing = [];
               this.waiting = [];
               for(var i:int = 0; i < 20; i++)
               {
                    this.waiting.push(new SoundChannel());
               }
               this.lastX = this.lastY = 0;
               this.backgroundLoop = null;
               this.backgroundVolume = 0.3;
               this.timer = new Timer(1000 / 30);
               this.timer.addEventListener(TimerEvent.TIMER,this.update);
               this.timer.start();
               this.isMusic = true;
               this.isSound = true;
               this.currentBackgroundName = "";
               this.targetBackgroundVolume = 0.2;
          }
          
          public function cleanUp() : void
          {
               this.backgroundLoop.stop();
          }
          
          public function setPosition(x:Number, y:Number) : void
          {
               this.lastX = x;
               this.lastY = y;
          }
          
          public function update(evt:Event) : void
          {
               var s:SoundTransform = new SoundTransform();
               if(this.isMusic == true)
               {
                    this.backgroundVolume += (this.targetBackgroundVolume - this.backgroundVolume) * 0.2;
               }
               else
               {
                    this.backgroundVolume += (0 - this.backgroundVolume) * 0.2;
               }
               s.volume = this.backgroundVolume;
               if(Boolean(this.backgroundLoop))
               {
                    this.backgroundLoop.soundTransform = s;
               }
          }
          
          public function addSound(name:String, s:Class, n:int, soundModifier:Number = 1) : void
          {
               ++this.main.loadingFraction;
               if(s != null)
               {
                    this.sounds[name] = s;
                    this.volumeMap[name] = soundModifier * globalSoundModifier;
               }
          }
          
          public function playSoundInBackground(name:String) : void
          {
               if(name == this.currentBackgroundName)
               {
                    return;
               }
               if(this.backgroundLoop != null)
               {
                    this.backgroundLoop.stop();
               }
               if(name == "")
               {
                    return;
               }
               var s:Sound = new this.sounds[name]();
               this.backgroundLoop = s.play(0,int.MAX_VALUE);
               var transform:SoundTransform = new SoundTransform();
               transform.volume = this.backgroundVolume;
               this.backgroundLoop.soundTransform = transform;
               this.currentBackgroundName = name;
               this.targetBackgroundVolume = 0.2 * this.volumeMap[name];
          }
          
          public function playSoundFullVolumeRandom(baseName:String, range:int) : Number
          {
               var name:String = baseName + (1 + Math.floor(Math.random() * range));
               return this.playSoundFullVolume(name);
          }
          
          public function playSoundFullVolume(name:String) : Number
          {
               var sound:Sound = null;
               var s:SoundChannel = null;
               var transform:SoundTransform = null;
               if(this.sounds[name] != null)
               {
                    sound = new this.sounds[name]();
                    s = sound.play();
                    if(s != null)
                    {
                         transform = new SoundTransform();
                         transform.volume = this.volumeMap[name];
                         if(!this.isSound)
                         {
                              transform.volume = 0;
                         }
                         s.soundTransform = transform;
                    }
                    return sound.length;
               }
               return 0;
          }
          
          public function playSoundRandom(baseName:String, range:int, posX:Number, posY:Number) : void
          {
               var name:String = baseName + (1 + Math.floor(Math.random() * range));
               this.playSound(name,posX,posY);
          }
          
          public function playSound(name:String, posX:Number, posY:Number) : void
          {
               var s:SoundChannel = null;
               if(this.sounds[name] != null)
               {
                    s = new this.sounds[name]().play();
                    this.setSoundTransformation(s,this.lastX,this.lastY,posX,posY,this.volumeMap[name]);
               }
          }
          
          public function setSoundTransformation(s:SoundChannel, x:Number, y:Number, px:Number, py:Number, soundModifier:Number = 1) : void
          {
               var transform:SoundTransform = null;
               var pan:Number = NaN;
               if(s != null && this.main.stickWar != null)
               {
                    transform = new SoundTransform();
                    transform.volume = 0.3 * soundModifier;
                    pan = (px - x - this.main.stickWar.stage.stageWidth / 2) / this.main.stickWar.stage.stageWidth;
                    transform.volume *= 1 / Math.max(1,Math.pow(Math.abs(pan),4));
                    pan = Math.max(Math.min(pan,1),-1);
                    transform.pan = pan;
                    if(!this.isSound)
                    {
                         transform.volume = 0;
                    }
                    s.soundTransform = transform;
               }
          }
          
          public function soundComplete(evt:Event) : void
          {
          }
          
          public function get isMusic() : Boolean
          {
               return this._isMusic;
          }
          
          public function set isMusic(value:Boolean) : void
          {
               this._isMusic = value;
          }
          
          public function get isSound() : Boolean
          {
               return this._isSound;
          }
          
          public function set isSound(value:Boolean) : void
          {
               this._isSound = value;
          }
     }
}
