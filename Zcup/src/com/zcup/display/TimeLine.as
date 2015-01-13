package com.zcup.display
{
	import com.zcup.core.log.ILogger;
	import com.zcup.core.log.Logger;
	import com.zcup.core.log.LoggerFactory;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimeLine extends Sprite
	{
		private static var _timer:Timer;
		private static var _frameRate:int = 40;
		
		protected var $logger:ILogger = LoggerFactory.getLogger(this);
		
		public static const ENTER_FRAME:String = "enterframe_timeline";
		
		private var _interval:int = 1;
		
		public function TimeLine()
		{
			super();
			if(_timer==null)
			{
				_timer = new Timer(_frameRate);
				_timer.start();
			}
			
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			
			//_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		private function onAdd(e:Event):void
		{
			//$logger.debug("加入时间轴");
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		private function onRemove(e:Event):void
		{
			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
			//$logger.debug("从时间轴移除");
		}
		
		public function destroy():void
		{
			if(parent!=null&&parent.contains(this))
				parent.removeChild(this);
			
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			//$logger.debug("对象销毁");
		}
		
		
		private function onTimer(e:TimerEvent):void
		{
			dispatchEvent(new Event(TimeLine.ENTER_FRAME));
			if(_interval!=1)
			{
				if(_timer.currentCount % _interval != 0)
				{
					return;
				}
			}
			onEnterFrame();
			
		}
		
		protected function onEnterFrame():void
		{
			
		}
		
		public static function timeStop():void
		{
			_timer.stop();
		}
		
		public static function timeStart():void
		{
			_timer.start();
		}
		
		private function get timer():Timer
		{
			return _timer;
		}

		private function set timer(value:Timer):void
		{
			_timer = value;
		}

		public static function get frameRate():int
		{
			return _frameRate;
		}

		public static function set frameRate(value:int):void
		{
			if(_frameRate!=value)
			{
				_frameRate = value;
				if(_timer)
				{
					_timer.stop();
					_timer.delay = _frameRate;
					_timer.start();
				}
			}
		}

		public function get interval():int
		{
			return _interval;
		}

		public function set interval(value:int):void
		{
			_interval = value;
		}

	}
}