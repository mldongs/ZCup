package com.zcup.core.net.remote
{
	/**
	 * 
	 * @atuhor: mldongs
	 * @qq: 25772076
	 * @time: Aug 11, 2011 8:49:40 PM
	 **/
	
	public class ZResponder implements IResponder
	{
		private var _onResult:Function;
		private var _onFault:Function;
		
		/**
		 * 构造函数
		 * @param onResult 成功处理函数
		 * @param onFault 失败处理函数
		 *
		 */
		public function ZResponder(onResult:Function, onFault:Function=null)
		{
			_onResult=onResult;
			_onFault=onFault;
		}
		
		public function onResult(result:Result):void
		{
			if (_onResult != null)
			{
				_onResult(result);
			}
		}
		
		public function onFault(fault:Object):void
		{
			if (_onFault != null)
			{
				_onFault(fault);
			}
		}
	}
}