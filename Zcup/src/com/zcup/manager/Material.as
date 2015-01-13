package com.zcup.manager
{
	import flash.display.*;
	import flash.system.*;
	import flash.utils.Dictionary;

	public class Material extends Object
	{
		private var _cachedBitmapData:Object;
		public var _materialArray:Array;
		private var _materialUrlArr:Array;
		private static var instance:Material;

		public function Material()
		{
			_materialUrlArr=[];
			_materialArray=[];
			_cachedBitmapData={};
			if (instance != null)
			{
				throw new Error("实例化单例类出错-MaterialLib");
			}
			return;
		}

		public function getClass(name:String):Class
		{
			return searchClass(name);
		}

		public function getCachedBitmapData(name:String, w:int, h:int):BitmapData
		{
			var bmd:*;
			if (_cachedBitmapData.hasOwnProperty(name))
			{
				return _cachedBitmapData[name];
			}
			var cls:*=getClass(name);
			if (getClass(name))
			{
				bmd=new cls(w, h) as BitmapData;
				if (bmd is BitmapData)
				{
					_cachedBitmapData[name]=bmd;
				}
				return bmd;
			}
			return null;
		}

		public function hasUrl(url:String):Boolean
		{
			var i:int;
			var n:*=_materialUrlArr.length;
			while (i < n)
			{

				if (_materialUrlArr[i] == url)
				{
					return true;
				}
				i++;
			}
			return false;
		}

		private function searchClass(name:String):Class
		{
			var i:int;
			var n:*=_materialArray.length;
			while (i < n)
			{

				if ((_materialArray[i] as ApplicationDomain).hasDefinition(name))
				{
					return (_materialArray[i] as ApplicationDomain).getDefinition(name) as Class;
				}
				i++;
			}
			return null;
		}

		public function push(domain:ApplicationDomain, url:String=""):void
		{
			if (url != "")
			{
				_materialUrlArr.push(url);
			}
			_materialArray.push(domain);
			return;
		}

		public function getMovie(name:String):MovieClip
		{
			if(getMaterial(name) is MovieClip)
			{
				return getMaterial(name) as MovieClip;
			}
			return null;
		}
		
		public function getMaterial(name:String):Object
		{
			var cls:*=getClass(name);
			if (cls != null)
			{
				return new cls;
			}
			return null;
		}
		public function icon(name:String,w:int=50,h:int=50):MovieClip
		{
			var sp2:MovieClip=Material.getInstance().getMaterial(name) as MovieClip;
			if (sp2==null){
				return null;
			}
			var rawWidth:Number=sp2.width;
			var rawHeight:Number=sp2.height;
			if (sp2.width > sp2.height){	
				sp2.width=w;
				sp2.height=(rawHeight)*w/(rawWidth);
			}else{
				sp2.height=h;
				sp2.width=(rawWidth) * h / (rawHeight);
			}
			return sp2;
		}

		public function getPic(name:String, maxWidth:int=50, maxHeight:int=50):Object
		{
			var cls:MovieClip=getMaterial(name) as MovieClip;
			if (cls == null)
				return null;

			cls.gotoAndStop(1);

			
			
			var mc:MovieClip=cls.getChildAt(0) as MovieClip;
			
			if(mc==null){
				//return null;
				mc=cls;
			}
			
			var rawWidth:Number=mc.width;
			var rawHeight:Number=mc.height;

			mc.stop();

			/**按比例缩放一下*/
			if (mc.width > mc.height)
			{
				mc.width=maxWidth;
				mc.height=rawHeight * maxWidth / rawWidth;
			}
			else
			{
				mc.height=maxHeight;
				mc.width=rawWidth * maxHeight / rawHeight;
			}

			//return cls;
			return mc;
		}

		public static function getInstance():Material
		{
			if (instance == null)
			{
				instance=new Material;
			}
			return instance;
		}
		
		private var materilBmdDict:Dictionary = new Dictionary();
		
		public function getBitmapData(param1:String) : BitmapData
		{
			var _loc_3:Class = null;
			if (!param1)
			{
				return null;
			}
			var _loc_2:* = materilBmdDict[param1];
			if (_loc_2 == null)
			{
				_loc_3 = getClass(param1);
				if (_loc_3)
				{
					_loc_2 = new _loc_3(0, 0);
					materilBmdDict[param1] = _loc_2;
				}
			}
			return _loc_2;
		}

	}
}
