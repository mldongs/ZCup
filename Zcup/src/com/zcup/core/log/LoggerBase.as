package com.zcup.core.log
{
	import flash.external.ExternalInterface;

	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Mar 3, 2011 4:00:54 PM 
	 **/ 

	public class LoggerBase implements ILogger
	{
		private var level:int;
		private var target:String;
		
		public function LoggerBase(target:String)
		{
			this.target=target;
			level=LoggerFactory.level;
		}
		
		public function debug(... args):void
		{
			
			if (level <= 1)
			{
				print("debug", args);
			}
		}
		
		public function warn(... args):void
		{
			if (level <= 2)
			{
				print("warn", args);
			}
		}
		
		public function error(... args):void
		{
			if (level <= 3)
			{
				print("error", args);
			}
		}
		
		private function print(_level:String, args:Array):void
		{
			var msg:String="[" + this.target + "]-[";
			var i:int=0;
			if (args.length > 1)
			{
				for (; i < args.length - 1; i++)
				{
					msg=msg + args[i].toString() + "\t";
				}
			}
			
			if (args[i] != null || args[i] != undefined)
				msg=msg + args[i].toString();
			msg=msg + "]";
			
			try
			{
				ExternalInterface.call("console." + _level, msg);
			}
			catch (e:Error)
			{
			}
			msg="[" + _level + "]-" + msg
			LoggerFactory.out.output(msg);
		}
	}
}