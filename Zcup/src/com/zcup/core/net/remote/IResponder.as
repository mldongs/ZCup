package com.zcup.core.net.remote
{
	/**
	 * 
	 * @atuhor: mldongs
	 * @qq: 25772076
	 * @time: Aug 11, 2011 3:28:51 PM
	 **/
	
	public interface IResponder
	{
		/**
		 * 回调成功函数
		 * @param result
		 * 	结果
		 *
		 */
		function onResult(result:Result):void;
		
		/**
		 * 回调失败函数
		 * @param fault
		 *
		 */
		function onFault(fault:Object):void;
	}
}