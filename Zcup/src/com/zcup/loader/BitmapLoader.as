package com.zcup.loader
{
	/**
	 * 读取后直接转化为bitmap的loader
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 26, 2011 4:49:25 PM 
	 **/ 
	
	import com.zcup.core.log.ILogger;
	import com.zcup.core.log.Logger;
	import com.zcup.core.log.LoggerFactory;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class BitmapLoader extends Bitmap
	{
		//[Bindable(event="complete")]
		//[Event(name="complete", type="flash.events.Event")]

		private var errorTime:int = 0;
		private var reloadTime:int = 3;
		private var loader:LoaderEx;
		private var _url:String;
		private var isLoading:Boolean = true;
		protected var $logger:ILogger = LoggerFactory.getLogger(this);
		/**
		 *是否开启本地共享数据 
		 */
		public var useLocalCache:Boolean = false;
		
		public function BitmapLoader(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false,reLoadTimes:int=3)
		{
			cacheAsBitmap = true;
			smoothing = true;
			reloadTime = reLoadTimes;
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		public function load(murl:String = null):void
		{
			if(murl!=null)
			{
				_url = murl;
			}
			loader = new LoaderEx(useLocalCache);
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(_url);
			isLoading = true;
		}
		
		public function dispose():void
		{
			if(isLoading)
			{
				$logger.debug("关闭流。。。");
				loader.close();
				clear();
			}
			if(bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
		}
		
		private function completeHandler(e:Event):void
		{
			var type:String = e.currentTarget.contentType;
			var content:DisplayObject;
			if(e.currentTarget.content is DisplayObject)
			{
				content = e.currentTarget.content as DisplayObject;
			}
			if (type == "application/x-shockwave-flash")
			{
				bitmapData = new BitmapData(content.width, content.height);
				bitmapData.draw(content);
				//循环帧。draw成一幅大图
			}
			else if (type == "image/jpeg" || type == "image/gif" || type == "image/png")
			{
				bitmapData = Bitmap(content).bitmapData;
			}
			
			clear();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function IOErrorHandler(e:IOErrorEvent):void
		{
			errorTime++;
			clear();
			if(errorTime<=reloadTime)
			{
				load();
				//测试用
				//延迟2秒再加载
				//setTimeout(load,Math.random()*20000);
			}
			else
			{
				//load(url.substr(0,url.length-1));
				$logger.debug("加载资源:"+url+"不存在");
				//dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			}
		}
		
		private function clear() : void
		{
			isLoading = false;
			loader.removeEventListener(Event.COMPLETE, completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.dispose();
			loader = null;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
			//load();
		}
		
		public function getBitmapData():BitmapData
		{
			var bmd:BitmapData;
			bmd = this.bitmapData;
			this.bitmapData = null;
			return bmd;
		}
	}
}