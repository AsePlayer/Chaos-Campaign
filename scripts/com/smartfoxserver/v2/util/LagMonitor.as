package com.smartfoxserver.v2.util
{
     import com.smartfoxserver.v2.SmartFox;
     import com.smartfoxserver.v2.requests.PingPongRequest;
     import flash.events.Event;
     import flash.events.EventDispatcher;
     import flash.events.TimerEvent;
     import flash.utils.Timer;
     import flash.utils.getTimer;
     
     public class LagMonitor extends EventDispatcher
     {
           
          
          private var _lastReqTime:int;
          
          private var _valueQueue:Array;
          
          private var _interval:int;
          
          private var _queueSize:int;
          
          private var _thread:Timer;
          
          private var _sfs:SmartFox;
          
          public function LagMonitor(sfs:SmartFox, interval:int = 4, queueSize:int = 10)
          {
               super();
               if(interval < 1)
               {
                    interval = 1;
               }
               this._sfs = sfs;
               this._valueQueue = [];
               this._interval = interval;
               this._queueSize = queueSize;
               this._thread = new Timer(interval * 1000);
               this._thread.addEventListener(TimerEvent.TIMER,this.threadRunner);
          }
          
          public function start() : void
          {
               if(!this.isRunning)
               {
                    this._thread.start();
               }
          }
          
          public function stop() : void
          {
               if(this.isRunning)
               {
                    this._thread.stop();
               }
          }
          
          public function destroy() : void
          {
               if(this._thread != null)
               {
                    this.stop();
                    this._thread.removeEventListener(TimerEvent.TIMER,this.threadRunner);
                    this._thread = null;
                    this._sfs = null;
               }
          }
          
          public function get isRunning() : Boolean
          {
               return this._thread.running;
          }
          
          public function onPingPong() : int
          {
               var lagValue:int = getTimer() - this._lastReqTime;
               if(this._valueQueue.length >= this._queueSize)
               {
                    this._valueQueue.shift();
               }
               this._valueQueue.push(lagValue);
               return this.averagePingTime;
          }
          
          public function get lastPingTime() : int
          {
               if(this._valueQueue.length > 0)
               {
                    return this._valueQueue[this._valueQueue.length - 1];
               }
               return 0;
          }
          
          public function get averagePingTime() : int
          {
               var lagValue:int = 0;
               if(this._valueQueue.length == 0)
               {
                    return 0;
               }
               var lagAverage:int = 0;
               for each(lagValue in this._valueQueue)
               {
                    lagAverage += lagValue;
               }
               return lagAverage / this._valueQueue.length;
          }
          
          private function threadRunner(evt:Event) : void
          {
               this._lastReqTime = getTimer();
               this._sfs.send(new PingPongRequest());
          }
     }
}
