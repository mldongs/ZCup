package com.zcup.core.net.socket
{
	import flash.events.IEventDispatcher;

	/**
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	public interface ISocket extends IEventDispatcher
	{
		function getStatus():SocketStatus;
		function sendData(data:Object):void;
		function setCodec(codec:ICodec):void;
		function connect(host:String="", port:int=-1):void;
		function setConnectInfo(connect:ConnectInfo):void;		
	}
}