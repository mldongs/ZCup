package com.zcup.timer
{
	import com.zcup.utils.FormatUtil;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * 请使用TimerManager类实现时间控制器功能。
	 * （此类还没研究透彻。以后慢慢研究）
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 21, 2011 6:15:10 PM 
	 **/ 
	
	internal class TimerCenter
	{
		public static const TIME_RegExp:RegExp = /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/;
		
		/**每秒多少帧* */		
		public static const FRAME_RATE:int = 24;
		
		/** 用以监听flash enter_frame**/
		private static var _shape:Shape;
		
		/** @private Gets updated on every frame.**/
		private static var _rootFrame:int; 
		
		/**flash运行时所经过的毫秒数**/
		private static var _passedTime:int;
		
		/**毫秒表,timer调用,回调参数为帧耗时（毫秒 int）**/
		private static var _timerLib:Dictionary;
		
		/**毫秒表,enter_frame调用，回调参数为帧耗时（毫秒int)**/
		private static var _tickLib:Dictionary;
		
		/**秒表 回调支持自定义参数**/
		private static var _entityLib:Dictionary;
		
		/**超时表 仅返回是否超时**/
		private static var _durationLib:Dictionary;
		
		/** 全局timer控制器 **/
		private static var _timer:Timer;
		
		private static var _localToServer:Number;		// local + localToServer = server
		
		public function TimerCenter()
		{
		}
		
		/**
		 *init TimerServer 
		 * 
		 */		
		public static function init():void{
			if(!_shape)
			{
				_timerLib = new Dictionary();
				_tickLib = new Dictionary();
				_entityLib = new Dictionary();		
				_durationLib = new Dictionary();	
				_shape = new Shape();
				_passedTime = getTimer();
				//testFrameSpeed();
				_shape.addEventListener(Event.ENTER_FRAME, updateAllTick);
			}
			if(!_timer)
			{
				_timer = new Timer(1);
				_timer.addEventListener(TimerEvent.TIMER,updateAllTimer);
			}
		}
		
		/**
		 * 延迟函数执行
		 * @param handler
		 * @param delay 延迟毫秒数
		 * @param args handler的参数
		 * @return Timer
		 * 
		 */
		public static function laterCall(handler:Function,delay:Number,...args):Timer
		{			
			var t:Timer=new Timer(delay,1);
			if(args.length>0){
				t.addEventListener(TimerEvent.TIMER_COMPLETE,function ():void{handler.apply(null,args);},false,0);
			}else{
				t.addEventListener(TimerEvent.TIMER_COMPLETE,function ():void{handler();},false,0);
			}
			t.start();
			return t;
		}
		
		/**
		 * 每多少秒执行一次handler, 参数必须是秒数, 回调handler(time:int),time表示上一帧到这一帧所耗费的时间(毫秒)
		 * 不再需要此服务的时候请调用removeSecTick以解除服务
		 * handler第一次被执行的时间不确定，仅可用于不求精确的计时服务
		 * @param handler 回调函数
		 * @param second 秒数
		 */		
		public static function addSecTick(handler:Function, second:int):void
		{			
			addTick(handler, second*FRAME_RATE);
		}
		
		/**
		 *解除秒handler服务
		 */		
		public static function removeSecTick(handler:Function, second:int):void{
			removeTick(handler, second*FRAME_RATE);
		}
		
		/**
		 * 给函数增加脉博,回调fun(time:int), time表示上一帧到这一帧所耗费的时间(毫秒),可用于累加计时
		 * @param fun function
		 * @param everyFrames 每多少帧执行一次tick
		 * @return 
		 * 
		 */		
		public static function addTick(fun:Function, everyFrames:int=2):void{
			var k:int = everyFrames;
			var funs:Vector.<Function>;
			funs= _tickLib[k];
			if(!funs){
				funs = _tickLib[k] = new Vector.<Function>();
			}
			if(funs.indexOf(fun) == -1)
				funs.push(fun);
		}
		
		/**
		 * 删除函数脉博
		 * @param fun
		 * @param everyFrames  Hash key 必需提供此参数以加快运行效率
		 * 
		 */		
		public static function removeTick(fun:Function, everyFrames:int):void{
			var k:int = everyFrames, funs:Vector.<Function>;
			funs = _tickLib[k];
			if(funs){
				var i:int = funs.indexOf(fun);
				if(i != -1)funs.splice(i, 1);
				if(!funs.length)
					delete _tickLib[k];
			}
		}
		
		/**
		 *运行定时服务，delay秒后handle会被执行,一经运行无法被修改/撤销/暂停
		 */		
		public static function run(delay:int, handle:Function, ...param):void{
			var args:Array = param;
			args.unshift(delay * 1000);		// 秒 -> 毫秒
			args.unshift(handle);
			(TimerCenter.setInterval as Function).apply(null, args);
		}
		
		/**
		 * 添加定时服务，delay毫秒后handle会被执行,定时服务自动解除
		 * 此定时服务可修改(edit) /撤销(remove) /暂停(pause) /恢复(resume)
		 */		
		public static function add(delay:int, handle:Function, ...param):void{
			_entityLib[ handle ] = new Entity(delay, handle, param);
		}
		
		// 修改某个 handle
		public static function edit(handle:Function, delay:int):void{
			var e:Entity = _entityLib[ handle ];
			if(e != null)e.delay = delay;
		}
		
		// 删除某个 handle
		public static function remove(handle:Function):void{
			delete _entityLib[ handle ];
		}
		
		// 判断一个 handle 是否存在
		public static function exist(handle:Function):Boolean{
			return _entityLib[ handle ] != null;
		}
		
		// 判断一个 handle 是否存在, 并返回剩余的秒数, 但 !=0 时表示存在
		public static function exist_remain(handle:Function):int{
			var e:Entity = _entityLib[ handle ];
			return (e!=null? e.delay: 0);
		}
		
		// 暂停某个 handle
		public static function pause(handle:Function):void{
			var e:Entity = _entityLib[ handle ];
			if(e && e.delay>=0) e.delay = -e.delay;
		}
		
		// 恢复某个 handle
		public static function resume(handle:Function):void{
			var e:Entity = _entityLib[ handle ];
			if(e && e.delay<0) e.delay = -e.delay;
		}
		
		/**
		 *设置延时调用, 单位毫秒,仅回调1次, 外部无法删除定时器
		 */		
		public static function setInterval(closure:Function, delay:Number, ...args):void {
			var timer:Timer = new Timer(delay, 1);
			
			var onTimerComplete:Function = function(event:TimerEvent):void{
				timer.removeEventListener(TimerEvent.TIMER, onTimerComplete);
				closure.apply(null, args);
			}
			
			timer.addEventListener(TimerEvent.TIMER, onTimerComplete);
			timer.start();
		}
		
		// 获取 time (毫秒)时刻对应的理论帧
		public static function getFrameAtTime(time:int):int{
			return _rootFrame + (time - getTimer()) / 1000 * FRAME_RATE;
		}
		
		//////////////////////////////////////////////////
		// 服务器时间同步
		
		// 设置服务器当前时间		// 可以多次调用, 维护 服务器-本机 的时间差, 之后可以根据本机时间, 估计当前的服务器时间
		public static function set_server_timer(str:String, time_cost:int=0):void{
			if (str == null || str.length == 0)	return;
			// 2009-03-27 14:56:04
			//			if( isNaN(_localToServer) )
			{
				var server:Date = parseTime(str);
				var local:Date = new Date();
				_localToServer = server.time - local.time + time_cost / 2;
			} 
		}
		
		// 获取服务服务器当前时间
		public static function get server_timer():Date{
			var d:Date = new Date;
			d.time += (isNaN(_localToServer)? 0: _localToServer);
			return d;
		}
		public static function get server_timer_str():String{
			var d:Date = server_timer;
			var str:String = FormatUtil.printf_d("%4d-%2d-%2d %2d:%2d:%2d", d.fullYear, d.month+1, d.date, d.hours, d.minutes, d.seconds);
			return str;
		}
		
		// 返回相对的日期
		public static function getYourDate(yourDay:int = 0, fullDate:Boolean = true, isChinese:Boolean = false):String
		{
			var d:Date = server_timer;
			var str:String = "";
			var format:String = "%4d-%2d-%2d";
			if (fullDate) {
				format = "%4d-%2d-%2d";
				if (isChinese) format = "%4d年%2d月%2d日";
				str = FormatUtil.printf_d(format, d.fullYear, d.month+1, (d.date - yourDay));
			} else {
				format = "%2d-%2d";
				if (isChinese) format = "%2d月%2d日";
				str = FormatUtil.printf_d(format, d.month+1, (d.date + yourDay));
			}
			return str;
		}
		
		// 解析服务器时间格式, 如果失败, 则返回默认的 0 值(1977年....)
		public static function parseTime(str:String):Date{
			var obj:Object = TIME_RegExp.exec(str);
			if(!obj){
				var d:Date = new Date;
				d.time = 0;
				return d;
			}
			d = new Date(obj[1], obj[2] - 1, obj[3], obj[4], obj[5], obj[6]);
			return d;
		}
		
		// 判断某个服务器时间是否到达, 返回超过的时间
		public static function getTimerElapse(serverTime:String):Number{
			var d1:Date = parseTime(serverTime);
			var d2:Date = server_timer;
			return d1.time - d2.time; 
		}
		
		//////////////////////////////////////////////////
		// 频率控制
		
		/**
		 * 判断上次调用该函数时, 与当前时间的间隔, 是否超过了 duration 指定的毫秒数
		 * @param key 将被长久保留引用, 因此 key 最好是静态/全局变量,否则不需要时应该调用removeDuration清除引用;
		 * 如果key不存在，将创建此key,并立即返回flase
		 * @param duration 时间间隔
		 * @param reset 是否记录此次调用时间
		 * @return 是否超时
		 * 
		 */		
		public static function checkDuration(key:Object, duration:int, reset:Boolean=true):Boolean{
			var prev_time:int = _durationLib[key];
			var now_time:int = rootTime;
			if(prev_time == 0){
				_durationLib[key] = now_time;
				return true;
			}
			if(now_time - prev_time >= duration){
				_durationLib[key] = now_time
				return true;
			}
			if(reset)_durationLib[key] = now_time;
			return false;
		}
		public static function removeDuration(key:*):void{
			delete _durationLib[key];
		}
		
		
		//////////////////////////////////////////////////
		// 格式化显示
		
		// 格式化: 秒 -> 时分		// sec=秒数, hunit=小时单位, munit=分钟单位
		public static function fmt_sec_to_hm(sec:Number, hunit:String=null, munit:String=null):String{
			sec += 59;
			var h:int = sec / 3600;		sec %= 3600;
			var m:int = sec / 60;
			
			var str:String = "";
			if(h>0) str += "" + h + (hunit || "小时");
			if(m>0) str += "" + m + (munit || "分钟");
			if(str == "") str = "0" + (munit || "分钟");
			
			return str;
		}
		//格式化时间戳  时、分、秒的格式
		public static function fmt_sec_to_hms_xiao(sec:Number, style:String=null):String{
			var h:int = sec / 3600;		sec %= 3600;
			var m:int = sec / 60;
			var s:int = sec % 60;
			
			var str:String = "";
			if(h>0){
				h>9?str += "" + h:str += "0" + h;	
			}else{
				str +="00";
			}
			str +=(style || "小时");
			if(m>0){
				m>9?str += "" + m:str += "0" + m;	
			}else{
				str +="00";
			}
			str +=(style || "分钟");
			if(s>0){
				s>9?str += "" + s:str += "0" + s;	
			}else{
				str +="00";
			}
			style?null:str +="秒";			
			return str;			
		}
		
		public static function getsimple_dhms(sec:Number, hunit:String=null, munit:String=null, sunit:String=null):String{
			var d:int = sec / (3600 * 24); sec %= (3600 * 24);
			var h:int = sec / 3600;		sec %= 3600;
			var m:int = sec / 60;
			var s:int = sec % 60;
			
			var str:String = "";
			if(d>0) return (str = "" + d + (hunit || "天"));
			if(h>0) return (str = "" + h + (hunit || "小时"));
			if(m>0) return (str = "" + m + (munit || "分钟"));
			//if(s>0) return (str = "" + s + (munit || "秒"));	
			return ""
		}
		
		public static function fmt_sec_to_hms(sec:Number, hunit:String=null, munit:String=null, sunit:String=null):String
		{
			var h:int = sec / 3600;		sec %= 3600;
			var m:int = sec / 60;
			var s:int = sec % 60;
			
			var str:String = "";
			if(h>0) str += "" + h + (hunit || "小时");
			if(m>0) str += "" + m + (munit || "分钟");
			if(s>0) str += "" + s + (munit || "秒");
			if(str == "") str = "0秒";
			
			return str;
		}
		public static function fmt_sec_to_dhms(sec:Number, hunit:String=null, munit:String=null, sunit:String=null):String
		{
			var d:int = sec / (3600 * 24); sec %= (3600 * 24);
			var h:int = sec / 3600;		sec %= 3600;
			var m:int = sec / 60;
			var s:int = sec % 60;
			
			var str:String = "";
			if(d>0) str += "" + d + (hunit || "天");
			if(h>0) str += "" + h + (hunit || "小时");
			if(m>0) str += "" + m + (munit || "分钟");
			
			if(d <= 0){
				if(s>0) str += "" + s + (munit || "秒");
				if(str == "") str = "0秒";
			}			
			
			return str;
		}
		
		// 格式化显示 天/小时/分钟/秒 中的一种单位
		public static function fmt_oneof_d_h_m_s(time:Number, def:String=null):String{
			time /= 1000;	// 毫秒 -> 秒
			if(time >= 7*24*3600) return Math.floor( time/(7*24*3600) + 0.5) + "天";		// 超过1星期才显示为天
			if(time >= 3600) return Math.floor( time/3600 + 0.5) + "小时";
			if(time >= 60) return Math.floor( time/60 + 0.5) + "分钟";
			if(time >= 1) return Math.floor(time/1 + 0.5) + "秒";
			return def || "0";
		}
		
		/**
		 * 格式化日期(Y/M/D H:M) 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function getDateString(date:Object,isContainTime:Boolean=true, s1:String="/", s2:String=":"):String
		{
			if(date is Number){
				var d:Date = new Date();
				d.setTime(date);
				date = d;
			}
			
			var dYear:String = String(date.getFullYear());
			
			var dMouth:String = ((date.getMonth() + 1 < 10) ? "0" : "") + (date.getMonth() + 1);
			
			var dDate:String = ((date.getDate() < 10) ? "0" : "") + date.getDate();
			
			var ret:String = "";
			
			ret += dYear + s1 + dMouth + s1 + dDate + " ";		
			
			if(!isContainTime) return ret;
			
			ret += ((date.getHours() < 10) ? "0" : "") + date.getHours();
			
			ret += s2 + ((date.getMinutes() < 10) ? "0" : "") + date.getMinutes();
			
			// 想要获取秒的话，date.getSeconds() ，语句同小时、分
			
			return ret;
		}
		
		// 比较两个日期大小 2009-4-29 BY ANDY
		public static function cmp_date(first:Date, second:Date) : Boolean
		{
			return (first.time > second.time) ? true : false;
		}
		
		// 获取当前时间
		public static function getDate(secondAdd:int=0):Date{
			var date:Date = new Date;
			date.time += (secondAdd * 1000);
			return date;
		}
		
		private static var _lastTestFrame:int;
		private static function printFrameSpeed(time:int):void{
			trace("<---经过, 共播放帧数: ", _rootFrame-_lastTestFrame);
			_lastTestFrame = _rootFrame;
		}
		public static function testFrameSpeed():void{
			addSecTick(printFrameSpeed, 1);
		}
		
		//////////////////////////////////////////////////
		// private
		
		/**
		 * @private
		 * Updates All Ticks
		 * 
		 * @param e ENTER_FRAME Event
		 */
		private static function updateAllTick(event:Event = null):void{
			_rootFrame++;
			
			// 上一帧到这一帧所耗费的时间(毫秒)
			var pass:int = getTimer() - _passedTime;
			
			_passedTime = getTimer();
			
			updateTickLib(pass);
			updateEntityLib(pass);
		}
		
		private static function updateAllTimer(event:Event=null):void
		{
			
		}
		
		public static function get rootTime():int{
			return _passedTime;
		}
		
		private static function updateTimerLib(pass:int):void
		{
			var d:Dictionary = _timerLib, k:String;
			for(k in d){
				if(_rootFrame%int(k) == 0 ){
					for each(var f:Function in d[k]){
						if(f != null)f(pass);
					}
				}
			}
		}
		
		private static function updateTickLib(pass:int):void{
			var d:Dictionary = _tickLib, k:String;
			for(k in d){
				if(_rootFrame%int(k) == 0 ){
					for each(var f:Function in d[k]){
						if(f != null)f(pass);
					}
				}
			}
		}
		
		private static function updateEntityLib(pass:int):void{
			var d:Dictionary = _entityLib, f:*, e:Entity;
			for (f in d)
			{
				e = d[ f ];
				if(e.delay >= 0){
					e.delay -= pass;	// 倒计时
					if(e.delay <= 0){
						e.invoke();
						delete d[ f ];
					}
				} 
			}
		}
	}
}



class Entity{
	public var delay:int;
	public var handle:Function;
	public var param:Array;
	
	public function Entity(delay:int, handle:Function, param:Array):void{
		this.delay = delay;
		this.handle = handle;
		this.param = param;
	}
	
	public function invoke():void{
		handle.apply(null, param);
	}
}