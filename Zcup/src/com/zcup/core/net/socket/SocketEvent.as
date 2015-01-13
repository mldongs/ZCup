package com.zcup.core.net.socket
{
	import flash.events.Event;

	/**
	 * socket 事件封装
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	public class SocketEvent extends Event
	{
		/** 收到数据 */
		public static const ONDATA:String="ondata";
		/** 已链接 */
		public static const CONNECTED:String="connected";
		/** 链接关闭 */
		public static const CLOSED:String="closed";
		/** 链接中 */
		public static const CONNECTING:String="connecting";

		/** 收到的数据 */
		public var data:Object;

		/** 链接次数 */
		public var times:int;

		public function SocketEvent(type:String, data:Object=null, times:int=0)
		{
			super(type);
			this.data=data;
			this.times=times;
		}
	}
}