package com.zcup.manager
{
	import com.zcup.core.log.Logger;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class DisplayManager extends EventDispatcher
	{
		
		private static var instance:DisplayManager;
		
		public function DisplayManager()
		{
			if ( instance!= null )			 
			{
				throw new Error( "只能产生一个实例" );
			}
		}
		
		public static function getInstance():DisplayManager
		{
			if (instance == null)
			{
				instance = new DisplayManager;
			}
			return instance;
		}
		
		public function addEvent(event:String,cb:Function,displayer:DisplayObject):void{
			getInstance().addEventListener(event,cb);
			displayer.addEventListener(Event.REMOVED_FROM_STAGE,rm);
			
			function rm(e:Event):void{
				displayer.removeEventListener(Event.REMOVED_FROM_STAGE,rm);
				getInstance().removeEventListener(event,cb);
				Logger.debug('删除事件侦听'+event);
			}
		}
	}
}