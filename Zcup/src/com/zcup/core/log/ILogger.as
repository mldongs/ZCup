package com.zcup.core.log
{

	/**
	 * 日志接口
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	public interface ILogger
	{
		/**
		 * 输出调试信息
		 * @param args	输出参数.
		 *
		 */
		function debug(... args):void;

		/**
		 * 输出警告信息
		 * @param args	输出参数.
		 *
		 */
		function warn(... args):void;

		/**
		 * 输出出错信息
		 * @param args	输出参数.
		 *
		 */
		function error(... args):void;
	}
}