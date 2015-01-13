package com.zcup.loader
{
	import com.zcup.core.log.Logger;
	import com.zcup.core.log.LoggerFactory;
	import com.zcup.manager.Material;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 *加载文件单元 
	 * @author lnz
	 * 
	 */	
	public class LoaderFile extends EventDispatcher
	{
		
		private var _tip:String='';
		
		private var _urlStr:String='';
		
		public function LoaderFile(url:String,completeFunction:Function,tip:String='')
		{
			super(null);
			_urlStr=url;
			_tip=tip;
			func=completeFunction;
			_url=new URLRequest(url);
			if(url.match('.swf') || url.match('.sba') || url.match('.png')){
				isswf=true;
				file.contentLoaderInfo.addEventListener(Event.COMPLETE,onComp);
				file.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onP);
			}else{
				isswf=false;
				fileU.addEventListener(Event.COMPLETE,onComp);
				fileU.addEventListener(ProgressEvent.PROGRESS,onP);
			}
			
		}
		
		private var isswf:Boolean=true;
		
		public function load(e:Event=null):void{
			if(isswf){
				file.load(_url);
			}else{
				fileU.load(_url);
			}
			LoaderTip.tipLabel=_tip+' 0%';
		}
		
		private function onP(e:ProgressEvent):void{
			LoaderTip.tipLabel=_tip+' '+int(e.bytesLoaded/e.bytesTotal*100)+'%';
			LoaderTip.pc=e.bytesLoaded+','+e.bytesTotal;
		}
		
		private var file:Loader=new Loader();
		private var fileU:URLLoader=new URLLoader();
		private var _url:URLRequest;
		private var func:Function;
		
		public function set dataFormat(str:String):void
		{
			fileU.dataFormat = str;
		}
		
		private function onComp(e:Event):void{
			Logger.debug('加载'+_urlStr+'完成',this);
			//Material.getInstance().push(e.currentTarget.applicationDomain);
			//try{
				func(e);
			//}catch(e:Error){
				//LoggerFactory.getLogger(this).debug(e.message);
			//}
			
			if(isswf){
				file.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComp);
				file.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onP);
			}else{
				fileU.removeEventListener(Event.COMPLETE,onComp);
				fileU.removeEventListener(ProgressEvent.PROGRESS,onP);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}