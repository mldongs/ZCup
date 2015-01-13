package com.zcup.core.log
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	

	/**
	 *日志工厂
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Mar 3, 2011 4:02:15 PM 
	 **/ 
	public class LoggerFactory
	{
		public static const LEVEL_DEBUG:Number=1;
		public static const LEVEL_WARN:Number=2;
		public static const LEVEL_ERROR:Number=3;
		
		public static var level:Number=LEVEL_DEBUG; // 默认情况下是最低级别.
		public static var out:ILoggerOutput=new LoggerOutConsole(); // 默认情况下是控制台输出.
		public static var cls:Class=LoggerBase; // 默认输出日志类.
		internal static var map:Dictionary=new Dictionary(); // 多日志对象模式.
		
		/**
		 * 获取一个日志输出对象.
		 * @param target
		 * @param flag
		 * @return
		 *
		 */
		public static function getLogger(target:Object, flag:Boolean=true):ILogger
		{
			var name:String;
			if (target == null)
			{
				name="NONE";
			}
			else
			{
				name=getQualifiedClassName(target);
			}
			if (map[name] == null)
			{
				map[name]=new cls(name);
				if (target as DisplayObject)
				{ // 如果是显示对象,在删除的时候清除日志引用.
					(target as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE, function():void
					{
						LoggerFactory.map[name]=null;
					});
				}
			}
			return (map[name]as ILogger);
		}
	}
}