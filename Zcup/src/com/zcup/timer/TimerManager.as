package com.zcup.timer
{
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 21, 2011 6:15:10 PM 
	 **/ 
	public class TimerManager extends Object
	{
		/**
		 *所有func的集合（func对应timer）
		 */		
		private var funcList:Dictionary;
		/**
		 *所有timer的集合（以delay定义）
		 */
		private var timerList:Dictionary;
		/**
		 *每一个timer挂载的func集合（以timer定义） 
		 */
		private var funcInTimerList:Dictionary;
		/**
		 *当前计时器数 
		 */
		private var currentNum:int = 0;
		/**
		 * 计时器上限
		 */		
		public static var TIMER_NUM_MAX:int = 10;
		
		private static var _instance:TimerManager = null;
		
		public function TimerManager()
		{
			timerList = new Dictionary();
			funcList = new Dictionary();
			funcInTimerList = new Dictionary();
		}
		
		/**
		 *	增加一个定时方法 
		 * @param seq
		 * @param func
		 * 
		 */		
		public function add(seq:int, func:Function) : void
		{
			if (funcList[func] != undefined)
			{
				return;
			}
			if(currentNum>=TIMER_NUM_MAX&&timerList[seq]==undefined)
			{
				throw new Error("已达最大计时器数");
				return;
			}
			createTimer(seq);
			funcList[func] = seq;
			funcInTimerList[seq].push(func);
		}
		/**
		 * 删除一个定时方法 
		 * @param func
		 * 
		 */		
		public function remove(func:Function) : void
		{
			var timer:Timer = null;
			if (funcList[func] == undefined)
			{
				return;
			}
			var seq:int = funcList[func];
			delete funcList[func];
			var seqFuncs:Array = funcInTimerList[seq];
			while (seqFuncs.indexOf(func) > -1)
			{
				seqFuncs.splice(seqFuncs.indexOf(func), 1);
			}
			if (seqFuncs.length == 0)
			{
				timer = timerList[seq];
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				delete funcInTimerList[seq];
				delete timerList[seq];
				currentNum--;
			}
		}
		
		/**
		 * 定时方法执行 
		 * @param event
		 * 
		 */
//		private function timerHandler(event:TimerEvent) : void
//		{
//			var _loc_4:* = undefined;
//			var _loc_2:* = Timer(event.target).delay;
//			var _loc_3:* = funcListDic[_loc_2];
//			for (_loc_4 in _loc_3)
//			{
//				
//				var _loc_7:* = _loc_3;
//				_loc_7._loc_3[_loc_4]();
//			}
//			return;
//		}
		private function timerHandler(event:TimerEvent) : void
		{
			var func:* = undefined;
			var seq:int = Timer(event.target).delay;
			var seqFuncs:Array = funcInTimerList[seq];
			for (func in seqFuncs)
			{
				seqFuncs[func]();
			}
		}
		/**
		 *创建定时器 
		 * @param seq
		 * @return 
		 * 
		 */		
		private function createTimer(seq:int) : Timer
		{
			var timer:Timer = null;
			if (timerList[seq] == undefined)
			{
				currentNum++;
				timer = new Timer(seq);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
				timerList[seq] = timer;
			}
			if (funcInTimerList[seq] == undefined)
			{
				funcInTimerList[seq] = new Array();
			}
			return timerList[seq];
		}
		/**
		 * 停止某计时器 
		 * @param seq
		 * 
		 */		
		public function stop(seq:int):void
		{
			if(timerList[seq])
			{
				(timerList[seq] as Timer).stop();
			}
		}
		/**
		 * 开始某计时器 
		 * @param seq
		 * 
		 */		
		public function start(seq:int):void
		{
			if(timerList[seq])
			{
				if(!(timerList[seq] as Timer).running)
					(timerList[seq] as Timer).start();
			}
		}
		
		public static function getInstance() : TimerManager
		{
			if (_instance == null)
			{
				_instance = new TimerManager;
			}
			return _instance;
		}
		
	}
}
