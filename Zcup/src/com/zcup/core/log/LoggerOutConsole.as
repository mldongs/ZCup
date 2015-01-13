package com.zcup.core.log
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 *日志控制台输出实现
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Mar 3, 2011 4:03:09 PM 
	 **/
	public class LoggerOutConsole extends EventDispatcher implements ILoggerOutput
	{
		public function output(msg:String):void
		{
			trace(msg);
			var e:LoggerEvent = new LoggerEvent(LoggerEvent.LOGGER_OUTPUT);
			e.data = msg;
			dispatchEvent(e);
		}
	}
}