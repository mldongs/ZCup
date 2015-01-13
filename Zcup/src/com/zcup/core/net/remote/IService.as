package com.zcup.core.net.remote
{
	/**
	 * 
	 * @atuhor: mldongs
	 * @qq: 25772076
	 * @time: Aug 11, 2011 3:25:25 PM
	 **/
	
	public interface IService
	{
		/**
		 * 远程服务名称
		 * 包括：包、类名以及函数名
		 * @return
		 * 	远程服务名称
		 *
		 */
		function get serviceName():String;
		
		/**
		 * 获得Gateway.
		 * @return
		 * 	gateway地址
		 *
		 */
		function get gateway():String;
		
		/**
		 * 调用远程服务.
		 * @param par
		 * 	传送的参数.
		 *
		 */
		function call(... par):void;
		
		/**
		 * 回调处理接口.
		 * @param value
		 *
		 */
		function set responder(value:IResponder):void;
		
		/**
		 * 将上下文标头添加到 AMF 数据包结构, 此标头将随以后的每个 AMF 数据包一起发送, 
		 * 如果使用相同的名称调用 NetConnection.addHeader()，则新标头将代替现有标头，
		 * 并在 NetConnection 对象的持续时间内始终使用新标头。
		 *  通过调用具有标头名称的 NetConnection.addHeader() 可以删除标头，进而删除未定义对象
		 * @param operation
		 * 	标识名.
		 * @param mustUnderstand
		 * 	服务器端必须优先处理.
		 * @param param
		 * 	数据内容.
		 *
		 */
		function addHeader(operation:String, mustUnderstand:Boolean=false, param:Object=null):void;
		
	}
}