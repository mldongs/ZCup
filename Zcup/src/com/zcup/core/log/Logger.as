package com.zcup.core.log
{
	import flash.utils.describeType;

	/**
	 * 日志输出类
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	
	public class Logger
	{

		/**
		 * 设置日志输出级别.
		 * @param value
		 *
		 */
		public static function set level(value:int):void
		{
			LoggerFactory.level=value;
		}

		/**
		 * 设置输出通道.
		 * @param pipe
		 *
		 */
		public static function set outPut(pipe:ILoggerOutput):void
		{
			LoggerFactory.out=pipe;
		}

		/**
		 * 设置日志输出类,这个类必须是ILogger.
		 * @param cls
		 *
		 */
		public static function set loggerClass(cls:Class):void
		{
			LoggerFactory.cls=cls;
		}

		/**
		 * 输出调试信息
		 * @param msg		消息.
		 * @param target	产生的对象.
		 *
		 */
		public static function debug(msg:String, target:Object=null):void
		{
			LoggerFactory.getLogger(target).debug(msg);
		}

		/**
		 * 输出警告消息
		 * @param msg		消息
		 * @param target	产生的对象
		 *
		 */
		public static function warn(msg:String, target:Object=null):void
		{
			LoggerFactory.getLogger(target).warn(msg);
		}

		/**
		 * 输出出错消息
		 * @param msg		消息
		 * @param target	产生的对象
		 *
		 */
		public static function error(msg:String, target:Object=null):void
		{
			LoggerFactory.getLogger(target).error(msg);
		}

		/**
		 * 获取一个日志输出类.
		 * @param target
		 * @return
		 *
		 */
		public static function getLogger(target:Object=null):ILogger
		{
			return LoggerFactory.getLogger(target);
		}
	}
}
