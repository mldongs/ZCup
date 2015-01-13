package com.zcup.loader
{
	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Feb 13, 2012 10:53:52 AM 
	 **/ 
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import org.osmf.events.LoaderEvent;
	
	public class BatchLoaderEx extends EventDispatcher
	{
		private var loaderEx:LoaderEx;
		public var resTotal:int;
		public var resLoaded:int;
		private var waitForLoad:Array;
		
		private var contentAry:Array;
		
		public function BatchLoaderEx(useCache:Boolean=false,target:IEventDispatcher=null)
		{
			super(target);
			
			loaderEx = new LoaderEx(useCache);
			loaderEx.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loaderEx.addEventListener(Event.COMPLETE,onLoadComplete);
			loaderEx.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		private function onLoadComplete():void
		{
			resLoaded++;
			contentAry.push(loaderEx.content);
			if(waitForLoad.length>0)
			{
				startLoad();
			}
			else
			{
				onAllComplete();
			}
		}
		
		private function onAllComplete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function ioErrorHandler(event:IOErrorEvent) : void
		{
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			dispatchEvent(e);
		}
		
		public function load(ary:Array):void
		{
			waitForLoad = ary;
			resTotal = waitForLoad.length;
			resLoaded = 0;
			
			startLoad();
		}
		
		private function startLoad():void
		{
			loaderEx.load(waitForLoad.shift());
		}
	}
}