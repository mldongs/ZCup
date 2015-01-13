package com.rpg.map
{
	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 26, 2011 5:28:39 PM 
	 **/ 
	
	import com.zcup.loader.BitmapLoader;
	
	import flash.display.BitmapData;
	
	public class MapImage extends BitmapLoader
	{
		public var mapId:int;
		
		public function MapImage(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}