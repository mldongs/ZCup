package com.zcup.core.net.socket
{
	/**
	 *	zcup专用解码器
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Mar 3, 2011 3:46:54 PM 
	 **/ 
	
	import com.zcup.core.log.Logger;
	
	import flash.utils.ByteArray;
	
	import mx.core.ByteArrayAsset;
	
	public class ZcupCodec implements ICodec
	{
		private var SEPARATOR:String = '/z/0';
		private var LEN:int = 4;
		public function ZcupCodec()
		{
		}
		
		/**
		 *解码 
		 * @param data
		 * @return 
		 * 
		 */
		public function deCode(data:Array):Array
		{
			var ary:Array=[];
			var bytes:ByteArray=new ByteArray();
			var value:String;
			
			while(data.length)
			{
				bytes.position=bytes.length; // 将拼合缓冲区的位移到尾部.
				bytes.writeBytes(data.shift()); // 拼接数据.
			}
			
			bytes.position = 0;
			while (bytes.bytesAvailable > LEN)
			{
				// 读取该条消息的长度
				var len:int=bytes.readUnsignedInt();
				//Logger.debug("當前緩衝區數據量："+len);
				
				if (bytes.bytesAvailable < len)
				{
					//Logger.debug("數據長度不夠："+bytes.bytesAvailable);
					break;
				}
				
				bytes.position = LEN;
				var amfBytes:ByteArray = new ByteArray;
				bytes.readBytes(amfBytes,0,len-1);
				
				if(amfBytes.bytesAvailable)
				{
					var obj:Object = amfBytes.readObject();
					ary.push(obj);
				}
				bytes.position++;
				
				bytes=copyByteArray(bytes);
				bytes.position=0;
			}
			if(bytes.bytesAvailable > 0)
			{
				//獲取不到數據有可能出現問題
				if(bytes.bytesAvailable<len)
				{
					data.push(bytes);
				}
			}
			return ary;
		}
		
		private function copyByteArray(source:ByteArray, posit:int = 0):ByteArray
		{
			var bytes:ByteArray=new ByteArray();
			source.readBytes(bytes, posit);
			return bytes;
		}
		
		/**
		 *编码 
		 * @param data
		 * @return 
		 * 
		 */
		public function enCode(data:Object):ByteArray
		{
			var byte:ByteArray = new ByteArray;
//			if (data is ByteArray)
//			{
//				byte=data as ByteArray;
//				byte.position=0;
//			}
//			else
//			{
//				byte=new ByteArray();
//				if (data is String)
//				{
//					byte.writeUTFBytes(data as String);
//				}
//				else
//				{
//					byte.writeObject(data);
//				}
//			}
			
			var by:ByteArray = new ByteArray();
			by.writeObject(data);
			
			byte.writeUnsignedInt(by.length);
			byte.writeBytes(by);
			//分隔符
			byte.writeUTFBytes(SEPARATOR);
			//byte.writeByte("/z/0");
			return byte;
		}
	}
}