package com.zcup.object
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	public class DataWatcher
	{
		private var watcherList:Array;
		public function DataWatcher(view:Object=null,useWeakReference:Boolean=false)
		{
			watcherList = new Array;
			
			if(view is DisplayObject)
				(view as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE,remove);
			
		}
		
		public function bindProperty(site:Object, prop:String, host:Object, chain:Object, commitOnly:Boolean = false) : ChangeWatcher
		{
			var w:ChangeWatcher = BindingUtils.bindProperty(site,prop,host,chain,commitOnly);
			watcherList.push(w);
			return w;
		}
		
		public function bindSetter(setter:Function, host:Object, chain:Object, commitOnly:Boolean = false) : ChangeWatcher
		{
			if(!(chain is Array))
			{
				if (chain is String)
				{
					chain = String(chain).split(".");
				}
				else
				{
					chain = [chain];
				}
			}
			var w:ChangeWatcher = BindingUtils.bindSetter(setter, host, chain, commitOnly);
			watcherList.push(w);
			return w;
		}
		
		private function remove(e:Event):void
		{
			(e.currentTarget as DisplayObject).removeEventListener(Event.REMOVED_FROM_STAGE,remove);
			unwatch();
		}
		
		public function unwatch(e:Event=null) : void
		{
			var w:ChangeWatcher = null;
			while (watcherList != null && watcherList.length > 0)
			{
				w = watcherList.pop() as ChangeWatcher;
				w.unwatch();
			}
			return;
		}
	}
}