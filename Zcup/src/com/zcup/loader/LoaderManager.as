package com.zcup.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	import com.zcup.manager.Material;
	
	import mx.collections.ArrayCollection;
	
	public class LoaderManager extends EventDispatcher
	{
		public function LoaderManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function loaderFiles(loaderfiles:Array):void{
			for(var i:int=0;i<loaderfiles.length;i++){
				if(loaderfiles[i+1]!=null){
					LoaderFile(loaderfiles[i]).addEventListener(Event.COMPLETE,LoaderFile(loaderfiles[i+1]).load);
				}else{
					LoaderFile(loaderfiles[i]).addEventListener(Event.COMPLETE,allComplete);
				}
			}
			
			LoaderFile(loaderfiles[0]).load();
		}
		
		private function allComplete(e:Event):void{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}