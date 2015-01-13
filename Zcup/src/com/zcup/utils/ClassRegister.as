package com.zcup.utils
{
	import flash.net.registerClassAlias;

	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 10, 2011 4:15:11 PM 
	 **/ 
	
	public class ClassRegister
	{
		public function ClassRegister()
		{
		}
		
		public static function register(aliasName:String,classObj:Class):void
		{
			AMF(aliasName,classObj);
		}
		
		public static function AMF(aliasName:String,classObj:Class):void
		{
			registerClassAlias(aliasName,classObj);	
		}
		
		public static function ZCUP():void
		{
			
		}
	}
}