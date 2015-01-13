package com.zcup.core.log
{

	/**
	 * 日志输出
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	public interface ILoggerOutput
	{
		/**
		 * 输出消息.
		 * @param msg
		 *
		 */
		function output(msg:String):void;
	}
}