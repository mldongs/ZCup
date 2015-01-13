package com.zcup.core.net.socket
{
	import com.zcup.core.log.ILogger;
	import com.zcup.core.log.Logger;
	import com.zcup.core.net.socket.SocketEvent;
	import com.zcup.core.net.socket.SocketStatus;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;



	/**
	 * socket服务对象
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	public class SocketService extends EventDispatcher implements ISocket
	{
		private var $codec:ICodec; // 解码器接口.
		private var $socket:Socket; // socket 链接.			
		private var $receiveBuffer:Array; // 接收缓冲区.
		private var $bufferTimer:Timer; // 接收缓冲区计时器.
		private var $inArr:Array; // 接收缓冲区.
		private var $connet:ConnectInfo; // 当前Socket配置.
		private var $logger:ILogger; // 日志类; 
		protected var $status:SocketStatus // socket 链接状态.

		public function SocketService()
		{
			this.$socket=new Socket();
			this.$socket.objectEncoding = ObjectEncoding.AMF3;
			this.$logger=Logger.getLogger(this);			
			this.$connet=new ConnectInfo();
			this.$status=new SocketStatus();
			this.$receiveBuffer=new Array();
			this.$inArr=new Array();

			this.$socket.addEventListener(Event.CONNECT, onConnect);
			this.$socket.addEventListener(Event.CLOSE, onClose);
			this.$socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			this.$socket.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			this.$socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			this.$bufferTimer=new Timer(10, 0);
			this.$bufferTimer.addEventListener(TimerEvent.TIMER, dispatchMsg);
		}

		/**
		 * 尝度链接服务器.
		 * @param event
		 *
		 */
		public function connect(host:String="", port:int=-1):void
		{
			if (this.$codec == null)
				throw new Error("在尝试链接Socket发现没有设置解码器~!");
			if (host != "")
				this.$connet.host=host;
			if (port != -1)
				this.$connet.port=port;
			try
			{
				$socket.connect(this.$connet.host, this.$connet.port);
				this.$status.status=SocketStatus.CONNECTING;
			}
			catch (e:Error)
			{
				this.$logger.error("在尝试链接host:" + host + ",port:" + port + "时发生错误~!", this);
				$socket.close();
			}
		}
		
		/**
		 *断线重链 
		 * 
		 */
		public function reConnect():void
		{
			connect();
		}

		/**
		 * 设置链接的服务器地址.
		 * @param config
		 *
		 */
		public function setConnectInfo(connect:ConnectInfo):void
		{
			this.$connet=connect;
		}

		/**
		 * 返回当前链接的状态.
		 * @return
		 *
		 */
		public function getStatus():SocketStatus
		{
			return $status;
		}

		/**
		 * 发送消息.
		 * @param data
		 *
		 */
		public function sendData(data:Object):void
		{
			if (this.$socket.connected)
			{
				var bytes:ByteArray=this.$codec.enCode(data);
				if (bytes.length > 0)
				{ // 编码成功,发送数据到socket
					$socket.writeBytes(bytes);
					$socket.flush();
					this.$status.outBytes+=bytes.length;
				}
			}
		}

		/**
		 * 设置编码器类型.
		 * @param codec
		 *
		 */
		public function setCodec(codec:ICodec):void
		{
			this.$codec=codec;
		}

		/**
		 * 接收到数据.
		 * @param event
		 *
		 */
		private function onData(event:ProgressEvent):void
		{
			var bytes:ByteArray=new ByteArray();
			this.$socket.readBytes(bytes, 0, this.$socket.bytesAvailable);
			this.$status.inBytes+=bytes.length;
			this.$receiveBuffer.push(bytes);
						
			var arr:Array=this.$codec.deCode(this.$receiveBuffer);
			
			for (var i:int=0; i < arr.length; i++)
			{
				this.$inArr.push(arr[i]);
			}
			if (!this.$bufferTimer.running)
			{
				this.$bufferTimer.start();
			}
		}

		/**
		 * 收到消息,对外分发.
		 * @param event
		 *
		 */
		private function dispatchMsg(event:TimerEvent):void
		{
			if (this.$inArr.length > 0)
			{
				var data:Object=this.$inArr.shift();
				dispatchEvent(new SocketEvent(SocketEvent.ONDATA, data));
			}
			else
			{
				$bufferTimer.stop();
			}
		}

		/**
		 * 链接成功.
		 * @param event
		 *
		 */
		private function onConnect(event:Event):void
		{
			this.$logger.debug("链接服务器 (" + this.$connet + ") 状态:" + this.$socket.connected, this);
			if (this.$socket.connected)
			{
				this.$status.status=SocketStatus.CONNECTED;
				dispatchEvent(new SocketEvent(SocketEvent.CONNECTED));
			}
		}

		/**
		 * 链接关闭.
		 * @param event
		 *
		 */
		private function onClose(event:Event):void
		{
			this.$status.status=SocketStatus.DISCONNECT;
			this.$logger.error("服务器关闭.", this);
			dispatchEvent(new SocketEvent(SocketEvent.CLOSED));
		}

		/**
		 * 链接发生IO错误.
		 * @param event
		 *
		 */
		private function onIoError(event:IOErrorEvent):void
		{
			trace(event.toString());
			this.$status.status=SocketStatus.DISCONNECT;
			this.$logger.error("链接服务器发生IO错误~!", this);
			dispatchEvent(new SocketEvent(SocketEvent.CLOSED));
		}

		/**
		 * 链接发生安全沙箱错误.
		 * @param event
		 *
		 */
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			this.$status.status=SocketStatus.DISCONNECT;
			this.$logger.error("链接服务器发生安全沙箱错误!" + event.text, this);
			dispatchEvent(new SocketEvent(SocketEvent.CLOSED));
		}
	}
}