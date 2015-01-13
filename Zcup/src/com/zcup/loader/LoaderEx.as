package com.zcup.loader
{
	/**
	 * 整合Loader和URLLoader一起使用。可以设定存取客户端存储的数据
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Nov 2, 2011 12:05:52 PM 
	 **/ 
	
	import com.zcup.cache.LocalCache;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class LoaderEx extends EventDispatcher
	{
		private var urlLoader:URLLoader;
		private var loader:Loader;
		private var _url:String = "";
		private var _content:Object;
		private var _context:LoaderContext;
		public var $useCache:Boolean;
		public var contentType:String;
		
		
		public function LoaderEx(useCache:Boolean = false)
		{
			$useCache = useCache; 
			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader = new Loader();
			loader.mouseChildren = false;
			loader.mouseEnabled = false;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComp);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function onLoaderComp(event:Event) : void
		{
			var lf:LoaderInfo = event.target as LoaderInfo;	
			contentType = lf.contentType;
			_content = lf.content;
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function loadBtyes(byte:ByteArray, loaderContext:LoaderContext = null) : void
		{
			loader.loadBytes(byte, loaderContext);
		}
		
		private function ioErrorHandler(event:IOErrorEvent) : void
		{
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		private function completeHandler(event:Event) : void
		{
			if($useCache)
			{
				LocalCache.getInstance().setFile(_url, event.target.data);
			}
			loadBtyes(event.target.data, _context);
		}
		
		public function load(url:String, context:LoaderContext = null) : void
		{
			_url = url;
			_context = context;
			var resBytes:ByteArray = null;
			if($useCache)
			{
				resBytes = LocalCache.getInstance().getFile(_url);
			}
			if (resBytes != null)
			{
				loadBtyes(resBytes, _context);
			}
			else
			{
				urlLoader.load(new URLRequest(_url));
			}
		}
		
		private function progressHandler(event:ProgressEvent) : void
		{
			var pe:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			pe.bytesLoaded = event.bytesLoaded;
			pe.bytesTotal = event.bytesTotal;
			this.dispatchEvent(pe);
		}
		
		public function close():void
		{
			try{
				urlLoader.close();
				loader.close();
			}
			catch(e:Error)
			{
				trace("111"+e.message);
			}
		}
		
		public function dispose() : void
		{
			urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
			urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComp);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.unload();
			if (_content is MovieClip)
			{
				MovieClip(_content).stop();
			}
			urlLoader = null;
			loader = null;
			_content = null;
			_context = null;
		}
		
		public function get content() : Object
		{
			return _content;
		}
	}
}