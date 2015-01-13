package com.zcup.core.net.socket
{

	/**
	 * 链接信息
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	public class ConnectInfo
	{
		public var id:int;
		/** 主机地址,可是ip或是域名 */
		public var host:String;
		/** 链接的端口 */
		public var port:int;
		/** 账号信息	 */
		public var account:String;
		public var token:String;
		public var version:String;

		public function ConnectInfo()
		{
			host="sso.uwan.com";
			port=1234;
		}

		public function toString():String
		{
			return "host:" + this.host + ",port:" + this.port;
		}

	}
}