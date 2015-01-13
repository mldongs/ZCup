package com.zcup.object
{
	import com.zcup.core.log.Logger;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	
	public class ModelBinder
	{
		private static var dict:Dictionary = new Dictionary(true);
		
		public function ModelBinder()
		{
			super();
		}
		/**
		 * 绑定数据 
		 * @param view
		 * @param data
		 * @param func
		 * 需要使用getItem,removeItemAt,itemUpdated
		 */		
		public static function BindingData(view:DisplayObject,data:ArrayCollection,func:Function):void
		{
			var obj:Object = new Object;
			obj["data"] = data;
			obj["func"] = func;
			
			dict[view] = obj;
			
			data.addEventListener(CollectionEvent.COLLECTION_CHANGE,func);
			view.addEventListener(Event.REMOVED_FROM_STAGE,removeDataBinding);
			
			Logger.debug("视图："+view.name+"开始绑定数据:"+data.toString());
		}
		
		private static function removeDataBinding(e:Event):void
		{
			dict[e.currentTarget]["data"].removeEventListener(CollectionEvent.COLLECTION_CHANGE,dict[e.currentTarget]["func"]);
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE,removeDataBinding);
			Logger.debug("视图："+e.currentTarget.name+"取消绑定事件:"+dict[e.currentTarget]["data"]);
			delete dict[e.currentTarget]["data"];
			delete dict[e.currentTarget]["func"];
			delete dict[e.currentTarget];
		}
		
		
		
		
		/**
		 * 绑定ResponderEvents事件 
		 * @param view
		 * @param events
		 * @param func
		 * 
		 */		
		public static function BindingEvent(view:DisplayObject,events:Array,func:Function):void
		{
			var obj:Object = new Object;
			obj["event"] = events;
			obj["func"] = func;

			dict[view] = obj;
			
			for(var i:int=0;i<events.length;i++)
			{
				getBinder().addEventListener(events[i],func);
				Logger.debug("视图："+view.name+"开始绑定事件:"+events[i],getBinder());
			}
			
			//view.addEventListener( Event.ADDED, registerView );
			view.addEventListener( Event.REMOVED_FROM_STAGE, unregisterView );
		}
		
		private static function registerView(e:Event):void
		{
			for(var i:int=0;i<(dict[e.currentTarget]["event"] as Array).length;i++)
			{
				getBinder().addEventListener(dict[e.currentTarget]["event"][i],dict[e.currentTarget]["func"]);
			}
		}
		
		private static function unregisterView(e:Event):void
		{
			for(var i:int=0;i<(dict[e.currentTarget]["event"] as Array).length;i++)
			{
				getBinder().removeEventListener(dict[e.currentTarget]["event"][i],dict[e.currentTarget]["func"]);
				Logger.debug("视图："+e.currentTarget.name+"取消绑定事件:"+dict[e.currentTarget]["event"][i],getBinder());
			}
			//e.currentTarget.removeEventListener(Event.ADDED,registerView);
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE,unregisterView);
			
			delete dict[e.currentTarget]["event"];
			delete dict[e.currentTarget]["func"];
			delete dict[e.currentTarget];
		}
		
		public static function dispatch(type:String):void
		{
			if(ModelBinder.getBinder().hasEventListener(type))
			{
				var event:Event = new Event(type);
				ModelBinder.getBinder().dispatchEvent(event);
			}
		}
		
		public static function getBinder():BinderDispatch
		{
			return BinderDispatch.getInstance();
		}
		
	}
}
import flash.events.EventDispatcher;

class BinderDispatch extends EventDispatcher
{
	private static var instance:BinderDispatch
	
	public function BinderDispatch()
	{
		
	}
	
	public static function getInstance():BinderDispatch
	{
		if (instance == null)
		{
			instance = new BinderDispatch;
		}
		return instance;
	}
	
}

