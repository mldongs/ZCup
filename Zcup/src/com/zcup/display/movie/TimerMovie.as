package com.zcup.display.movie
{
	import com.zcup.core.log.ILogger;
	import com.zcup.core.log.Logger;
	import com.zcup.core.log.LoggerFactory;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimerMovie extends Sprite
	{
		private var _timer:Timer;
		
		protected var $logger:ILogger = LoggerFactory.getLogger(this);
		
		public static const ENTER_FRAME:String = "enterframe_timermovie";
		
		private var _interval:int = 1;
		
		public function TimerMovie()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
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
			_timer = null;
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			//$logger.debug("对象销毁");
		}
		
		
		private function onTimer(e:TimerEvent):void
		{
			dispatchEvent(new Event(TimerMovie.ENTER_FRAME));
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
		
		protected function get $timer():Timer
		{
			return _timer;
		}
		
		protected function set $timer(value:Timer):void
		{
			_timer = value;
		}
		//		
		//		public function get frameRate():int
		//		{
		//			return _frameRate;
		//		}
		//		
		//		public function set frameRate(value:int):void
		//		{
		//			if(_frameRate!=value)
		//			{
		//				_frameRate = value;
		//				if(_timer)
		//				{
		//					_timer.stop();
		//					_timer.delay = _frameRate;
		//					_timer.start();
		//				}
		//			}
		//		}
		
		/**
		 * 设置动画播放延迟倍数
		 * 以当前播放频率为基数 
		 * @return 
		 * 
		 */		
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