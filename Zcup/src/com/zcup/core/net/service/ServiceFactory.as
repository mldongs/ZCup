package com.zcup.core.net.service
{
	import com.zcup.core.net.remote.AbstractRemoteService;
	import com.zcup.core.net.remote.IResponder;
	import com.zcup.core.net.remote.IService;

	/**
	 * 
	 * @atuhor: mldongs
	 * @qq: 25772076
	 * @time: Aug 11, 2011 9:05:31 PM
	 **/
	
	public class ServiceFactory
	{
		/**
		 * 默认gateWay.
		 */
		public static var defaultGateway:String='http://host/gateway.jsp';
		
		/**
		 *  默认AMF模板服务类.
		 */
		public static var defaultService:Class=AbstractRemoteService;
		
		/**
		 * 获取一个服务.
		 * @param serviceName
		 * 			服务路径及名称.
		 * @param responder
		 * 			响应处理对象.
		 * @param gateway
		 * 			请求网关.
		 * @param type
		 * 			服务类型.
		 * @param objectEncoding
		 * 			编码方式.
		 * @return
		 *
		 */
		public static function getService(serviceName:String, responder:IResponder, gateway:String=null, type:String=null, objectEncoding:uint=3):IService
		{
			if (gateway == null)
			{
				gateway=defaultGateway;
			}
			var service:IService=new defaultService(serviceName, responder, gateway);
			return service;
		}
		
		public static function registerService(ser:Class):void
		{
			
		}
		
		public function ServiceFactory()
		{
		}
	}
}