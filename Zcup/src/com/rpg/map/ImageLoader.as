package com.rpg.map
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	/**
	 * 测试用loader
	 * 读取位图后获得其bitmapdata
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 17, 2011 2:56:44 PM 
	 * 
	 **/ 
	public class ImageLoader extends Loader
	{
		public var row:int;
		public var col:int;
		public var url:String;
		public var timer:int = 0;
		private var _bitmapData:BitmapData;
		public var hasCopy:Boolean = false;
		public var mapId:int;
		
		public function ImageLoader()
		{
			contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
		}
		
		public function loadImage() : void
		{
			load(new URLRequest(url));
		}
		
		private function completeHandler(event:Event) : void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			if (loaderInfo.contentType == "application/x-shockwave-flash")
			{
				_bitmapData = new BitmapData(loaderInfo.width, loaderInfo.height);
				_bitmapData.draw(content);
			}
			else if (loaderInfo.contentType == "image/jpeg" || loaderInfo.contentType == "image/gif" || loaderInfo.contentType == "image/png")
			{
				_bitmapData = Bitmap(content).bitmapData;
			}
			try
			{
				this.close();
			}
			catch (e:Error)
			{
				try
				{
					this.unload();
				}catch (e:Error)
				{
				}
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function IOErrorHandler(event:IOErrorEvent) : void
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		public function get bitmapData() : BitmapData
		{
			var bmd:BitmapData = _bitmapData;
			_bitmapData = null;
			hasCopy = true;
			return bmd;
		}
		
		public function disposeBitmapData() : void
		{
			if (_bitmapData)
			{
				_bitmapData.dispose();
			}
			_bitmapData = null;
		}
		
		public function dispose() : void
		{
			contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			try
			{
				this.close();
			}
			catch (e:Error)
			{
				try
				{
					unload();
					unloadAndStop();
				}
				catch (e:Error)
				{
				}
			}
			
		}
	}
}
