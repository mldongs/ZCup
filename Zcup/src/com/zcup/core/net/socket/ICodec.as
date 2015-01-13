package com.zcup.core.net.socket
{
	import flash.utils.ByteArray;
	
	/**
	 * 编码器接口
	 * @author： mldongs  
	 * @qq: 25772076 
	 * @time：Mar 3, 2011 3:22:08 PM 
	 * 
	 **/ 
	public interface ICodec
	{
		/**
		 * 解码. 
		 * @param data	指socket缓冲区中的数组,它将不同时刻接收的数据变成一个数组.
		 * 				在解码的过程中将数中的数据拼接起来就形成了一个Socket数据流.
		 * @return 		返回一个解码后的对象数组.
		 * 
		 */		
		function deCode(data:Array):Array;
		
		/**
		 * 编码. 
		 * @param data	传入需要编码的数据对象,将对象及其分隔符一起写入到ByteArray.
		 * @return 		
		 * 
		 */		
		function enCode(data:Object):ByteArray;
	}
}