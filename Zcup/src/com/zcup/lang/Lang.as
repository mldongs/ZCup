package com.zcup.lang
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/**
	 * 語言包類
	 * @author centrno
	 * 2011-1-20 
	 */
	public class Lang
	{
		public function Lang()
		{
		}
		
		private static var langData:Object=new Object();
		
		/**
		 *設置語言包文件 
		 * @param value
		 * 
		 */		
		public static function setLangFileUrl(value:String):void{
			var urlreq:URLRequest=new URLRequest(value);
			var urlload:URLLoader=new URLLoader();
			urlload.addEventListener(Event.COMPLETE,onLoadComplete);
			urlload.load(urlreq);
		}
		
		public static function onLoadComplete(e:Event):void{
			var langString:String=(e.currentTarget as URLLoader).data;
			var langArray:Array=langString.split('\n');
			for each(var dataString:String in langArray){
				try{
					var urlvar:URLVariables=new URLVariables(dataString);
					var key:String;
					for(key in urlvar){
						if(urlvar[key].toString().substr(0,5)=='[get]'){
							langData[key]=langData[urlvar[key].toString().substring(5)];	
						}else{
							langData[key]=urlvar[key];
							var reg:RegExp=/\@@/g;
							langData[key]=langData[key].toString().replace(reg,'%');
						}
					}
				}catch(e:Error){
					
				}
				
			}
		}
		
		public static function getLang(key:String):String{
			if(key==null){
				key='null';
			}
			if(langData.hasOwnProperty(key)){
				return langData[key].toString();
			}
			return key;
		}
	}
}