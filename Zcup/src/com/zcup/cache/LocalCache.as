package com.zcup.cache
{
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 客户端缓存类-用来存放素材到客户端
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Nov 1, 2011 7:58:48 PM 
	 **/ 
	
	public class LocalCache
	{
		private const NEEDSPACE:int = 3.14573e+007;
		
		private var secureList:Dictionary;
		private var _serverName:String = null;
		private var _fileList:Array;
		private var _sharedObject:SharedObject;
		private var _time:Timer;
		private var _canCache:Boolean = false;
		private var _isInit:Boolean = false;
		private static var _instance:LocalCache = null;
		
		public function LocalCache()
		{
			_time = new Timer(500);
			_time.addEventListener(TimerEvent.TIMER, timerHandler);
			secureList = new Dictionary();
			_fileList = new Array();
		}
		
		public static function getInstance() : LocalCache
		{
			if (_instance == null)
			{
				_instance = new LocalCache;
			}
			return _instance;
		}
		
		private function timerHandler(event:TimerEvent) : void
		{
			var obj:Object = null;
			if (_fileList.length > 0)
			{
				obj = _fileList.shift();
				updateFile(obj);
			}
		}
		
		private function updateFile(obj:Object) : void
		{
			var shareObject:SharedObject = SharedObject.getLocal(obj.url);
			shareObject.data[obj.url] = obj.data;
			if (_sharedObject.data["version"] == null)
			{
				_sharedObject.data["version"] = new Object();
			}
			var dataObj:Object = _sharedObject.data["version"];
			dataObj[obj.url] = obj.version;
			_sharedObject.data["version"] = dataObj;
		}
		
		public function checkCache(serverName:String) : Boolean
		{
			_serverName = serverName;
			_sharedObject = SharedObject.getLocal("zcupRpg/clientCache");
			if (_sharedObject.data["version"] != undefined)
			{
				_canCache = true;
				_time.start();
				return true;
			}
			return false;
		}
		
		private function netStatusHandler(event:NetStatusEvent) : void
		{
			if (event.info.code == "SharedObject.Flush.Failed")
			{
				trace("shareObject error");
			}
			else
			{
				initCache();
			}
		}
		
		public function connect(serverName:String) : void
		{
			_serverName = serverName;
			_sharedObject = SharedObject.getLocal("zcupRpg/clientCache");
			openLimite();
		}
		
		public function openLimite() : Boolean
		{
			var state:String;
			var time:int = getTimer();
			try
			{
				state = _sharedObject.flush(NEEDSPACE);
				if (state != SharedObjectFlushStatus.PENDING)
				{
					initCache();
					return true;
				}
			}
			catch (e:Error)
			{
				Security.showSettings(SecurityPanel.LOCAL_STORAGE);
			}
			_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			return false;
		}
		
		private function initCache() : void
		{
			if (_isInit == true)
			{
				return;
			}
			_isInit = true;
			_canCache = true;
			_sharedObject.data["version"] = new Object();
			_sharedObject.flush();
			_time.start();
		}
		
		public function clearCache() : void
		{
			var ver:int = 0;
			if (getServerData("versionCode") == null)
			{
				setServerData("versionCode", 1);
			}
			else
			{
				ver = int(getServerData("versionCode")) + 1;
				setServerData("versionCode", ver);
			}
			flushServerData();
		}
		
		public function flushServerData() : void
		{
			try
			{
				_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				var str:String = _sharedObject.flush();
			}
			catch (e:Error)
			{
				trace(e.message);
			}
		}
		
		public function clearTemp() : void
		{
			var key:* = undefined;
			for (key in secureList)
			{
				delete secureList[key];
			}
		}
		
		public function getFile(url:String, secure:Boolean = false) : ByteArray
		{
			var time:int = getTimer();
			var fileObj:Object = getFileObj(url);
			if (secureList[fileObj.url] != null)
			{
				return secureList[fileObj.url];
			}
			if (_canCache == false)
			{
				return null;
			}
			var dataObj:Object = _sharedObject.data["version"];
			if (_sharedObject.data["version"] == null)
			{
				return null;
			}
			if (dataObj[fileObj.url] != fileObj.version)
			{
				return null;
			}
			var objByte:* = SharedObject.getLocal(fileObj.url).data[fileObj.url];
			if (SharedObject.getLocal(fileObj.url).data[fileObj.url] != null && secure == true)
			{
				secureList[fileObj.url] = objByte;
			}
			return objByte;
		}
		
		public function setFile(url:String, byte:ByteArray, secure:Boolean = false) : void
		{
			var fileObj:Object = getFileObj(url);
			if (secure == true)
			{
				secureList[fileObj.url] = byte;
			}
			if (_canCache == false)
			{
				return;
			}
			fileObj.data = byte;
			_fileList.push(fileObj);
		}
		
		public function getFileObj(url:String) : Object
		{
			var fileObj:Object = new Object();
			var ary:Array = url.split("?v=");
			if (ary.length == 1)
			{
				fileObj.version = 0;
			}
			else
			{
				fileObj.version = ary[1];
			}
			url = ary[0];
			if (url.indexOf("http://") > -1)
			{
				fileObj.url = url.substring(7);
			}
			else
			{
				fileObj.url = url;
			}
			return fileObj;
		}
		
		//远程共享对象
		public function getServerData(verCode:String) : Object
		{
			var dataObj:Object = getData(_serverName);
			if (dataObj == null)
			{
				return null;
			}
			return dataObj[verCode];
		}
		
		public function setServerData(verCode:String, ver:Object) : void
		{
			var dataObj:Object = getData(_serverName);
			if (dataObj == null)
			{
				dataObj = new Object();
			}
			dataObj[verCode] = ver;
			saveData(_serverName, dataObj);
		}
		
		public function getData(serverName:String) : Object
		{
			if (_sharedObject == null)
			{
				return null;
			}
			var dataObj:Object = _sharedObject.data[serverName];
			return dataObj;
		}
		
		public function saveData(serverName:String, dataObj:Object) : void
		{
			if (_sharedObject == null)
			{
				return;
			}
			_sharedObject.data[serverName] = dataObj;
		}
		
		public function get canCache() : Boolean
		{
			return _canCache;
		}
	}
}