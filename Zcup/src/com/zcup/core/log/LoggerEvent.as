package com.zcup.core.log
{
	/**
	 * 
	 * @atuhor: mldongs
	 * @qq: 25772076
	 * @time: Aug 17, 2011 6:21:27 PM
	 **/
	
	import flash.events.Event;
	
	public class LoggerEvent extends Event
	{
		public static var LOGGER_OUTPUT:String="loggeroutput";
		
		public var data:Object;
		
		public function LoggerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}