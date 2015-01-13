package com.zcup.core.net.socket
{
	/**
	 * socket状态信息
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	[Bindable]
	public class SocketStatus
	{
		/** 已成功链接 */		
		public static const CONNECTED:int=1;
		/** 链接中.. */
		public static const CONNECTING:int=0;
		/** 断开链接 */
		public static const DISCONNECT:int=-1;
		
		/** 当前Socket的状态码 */
		public var status:int;
		/** 接收的字节数 */
		public var inBytes:int;
		/** 发送的字节数 */
		public var outBytes:int;
		
		public function SocketStatus()
		{
			status=DISCONNECT;
			inBytes=outBytes=0;
		}
	}
}