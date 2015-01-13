package com.zcup.core.net.remote
{
	import com.zcup.core.log.ILogger;
	import com.zcup.core.log.Logger;
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * 
	 * @atuhor: mldongs
	 * @qq: 25772076
	 * @time: Aug 11, 2011 5:29:39 PM
	 **/
	
	public class AbstractRemoteService implements IService
	{
		/**
		 * gateWay
		 */
		protected var $gateWay:String;
		
		/**
		 * 请求响应, 针对NetConnection的.
		 */
		protected var $myResponder:Responder;
		
		/**
		 * 请求链接.
		 */
		protected var $net:NetConnection;
		
		/**
		 * 请求响应.
		 */
		protected var $responder:IResponder;
		
		/**
		 * 服务名
		 */
		protected var $serviceName:String;
		
		/**
		 * 日志信息.
		 */
		protected var $logger:ILogger;
		
		/**
		 * 调用历史记录.
		 */
		protected var $callHistory:Array;
		
		/**
		 *  
		 * @param responder
		 * 			响应处理
		 * @param gateWay
		 * 			gateWay地址.
		 * @param serviceName
		 * 			服务名称.
		 * @param net
		 * 			请求链接.
		 * @param objectEncoding
		 * 			对象编码.
		 *
		 */
		public function AbstractRemoteService(serviceName:String, responder:IResponder, gateWay:String, net:NetConnection, objectEncoding:uint=3)
		{
			if (net == null)
			{
				throw new Error("必须在子类初始化网络连接!");
			}
			
			this.$logger=Logger.getLogger(this);
			this.$callHistory=[];
			this.$net=net;
			
			this.$gateWay=gateWay;
			this.$serviceName=serviceName;
			this.$myResponder=new Responder(onNetResult,onFault);
			this.$responder=responder;
		}
		
		/**
		 * 将上下文标头添加到 AMF 数据包结构, 此标头将随以后的每个 AMF 数据包一起发送, 如果使用相同的名称调用 NetConnection.addHeader()，则新标头将代替现有标头，并在 NetConnection 对象的持续时间内始终使用新标头。 通过调用具有标头名称的 NetConnection.addHeader() 可以删除标头，进而删除未定义对象
		 * @param operation
		 * 			标识名.
		 * @param mustUnderstand
		 * 			服务器端必须优先处理.
		 * @param param
		 * 			数据内容.
		 *
		 */
		public function addHeader(operation:String, mustUnderstand:Boolean=false, param:Object=null):void
		{
			if (this.$net != null)
			{
				this.$net.addHeader(operation, mustUnderstand, param);
				//$logger.debug("添加一个消息头[key:", operation, ",value:", (param == null ? '' : param), "]");
			}
		}
		
		/**
		 * 开始链接.
		 *
		 */
		protected function connect():void
		{
			if (!$net.connected)
			{
				try
				{
					$net.connect(this.$gateWay);
					$logger.debug("连接服务器网关："+this.gateway + ", 时间：" + (new Date).toTimeString());
				}
				catch (e:Error)
				{
					$logger.error(e);
				}
			}
		}
		
		/**
		 * 执行服务器端的方法.
		 * @param par
		 * 			服务器端方法的参数.
		 */
		public function call(... par):void
		{
			//$net.call(null,$myResponder,par);
			var args:Array=[$serviceName, $myResponder];
			args=args.concat(par);
			callServer(args);
		}
		
		/**
		 * 执行服务器端方法.
		 * @param args
		 * 			执行的数组参数.
		 *
		 */
		protected function callServer(args:Array):void
		{
			$callHistory.push(new History(getTimer(), args));
			
			var call:Function=$net.call;
			$logger.debug("请求服务器,方法:", $serviceName, " ,参数: ", args);
			try{
				call.apply(this, args);
			}
			catch(e:Error)
			{
				$logger.debug(e.message);
			}
			/*
			$net.call(args[0],args[1],args[2]);
			*/
		}
		
		/**
		 * 设置gateWay地址.
		 * @return
		 *
		 */
		public function get gateway():String
		{
			return this.$gateWay;
		}
		
		/**
		 * 设置响应接口.
		 * @param value
		 *
		 */
		public function set responder(value:IResponder):void
		{
			this.$responder=value;
		}
		
		/**
		 * 获取服务名称.
		 * @return
		 *
		 */
		public function get serviceName():String
		{
			return this.$serviceName;
		}
		
		/**
		 * 执行服务器端返回成功.
		 * @param result
		 * 			服务器端返回的结果.
		 */
		protected function onResult(result:Result):void
		{
			$logger.debug("接收服务器端数据,方法:" + $serviceName + ",返回: ", result);
			//this.$responder.onResult(result as RPCResult);
			
		}
		
		/**
		 * 执行服务器端返回成功.
		 * @param result
		 * 			服务器端返回的结果.
		 */
		protected function onNetResult(result:Object):void
		{
			var callHistory:History=$callHistory.shift() as History;
			var callDuration:Number=getTimer() - callHistory.time;
			var args:Array=callHistory.param as Array;
			
			args.shift();
			args.shift();
			
			var zResult:Result=new Result(result, callDuration);
			
			onResult(zResult);
		}
		
		/**
		 * 执行服务器端返回失败.
		 * @param fault
		 * 			出错的信息.
		 */
		protected function onFault(fault:Object):void
		{
			$logger.error("执行服务器端方法" + $serviceName + "失败,出错信息: ", fault.message);
			//this.$responder.onFault(faultVO);
		}
		
	}
}

class History
{
	public var time:int;
	public var param:Array;
	
	public function History(time:int, param:Array)
	{
		this.time=time;
		this.param=param;
	}
}