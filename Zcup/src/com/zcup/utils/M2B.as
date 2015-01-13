package com.zcup.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;

	/**
	 * MovieClip to Bitmap 
	 * @author mldongs
	 * 
	 */    
	public class M2B
	{
		
		public function M2B()
		{
		}
		
		/**
		 * 转换MovieClip为BitmapData数组 
		 * @param mc                                        目标MovieClip对象
		 * @param useCenterTranslate        是否使用中心点偏移
		 * @param xOffset                                横向偏移量
		 * @param yOffset                                纵向偏移量
		 * @return 
		 * 
		 */        
		public static function transformM2B( mc:MovieClip, 
											 useCenterTranslate:Boolean=false, xOffset:Number=0, yOffset:Number=0 ):Array
		{
			var result:Array = new Array();
			var bmd:BitmapData;
			for(var i:int=1; i<mc.totalFrames; i++)
			{
				mc.gotoAndStop( i ); 
				
				var m:Matrix = new Matrix();
				if( useCenterTranslate )
				{
					m.translate( (mc.width + xOffset) / 2, (mc.height + yOffset) / 2 );
				}
				
				bmd = new BitmapData( mc.width + xOffset, mc.height + yOffset, true, 0 );
				bmd.draw( mc, m );
				result.push( bmd );
			}
			return result;
		}
	}
}