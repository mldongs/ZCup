package com.zcup.loader
{
	import flash.events.Event;
	
	public class LoadingEvent extends Event
	{
		public function LoadingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const SHOW_LOADING:String='show_loading';
		
		public var progessValue:int;
		
		public var cmd:String;
		
		public var lab:String;
		
		public static const CANCEL_LOADING:String='cancel_loading';
	}
}