package com.zcup.core.net.remote
{
	/**
	 * 
	 * @atuhor: mldongs
	 * @qq: 25772076
	 * @time: Aug 11, 2011 7:55:51 PM
	 **/
	
	public class Result
	{
		/**
		 * 返回的数据
		 */
		public var data:Object;
		
		/**
		 * 花费时间
		 */
		public var costTime:Number;
		
		/**
		 * 附加数据.
		 */
		public var exteralData:Object;
		
		public function Result(data:Object=null, costTime:Number=0)
		{
			this.data=data;
			this.costTime=costTime;
		}
		
		public function toString():String
		{
			return '[ constTime:' + costTime + ', data:' + data + ' ]';
		}

	}
}