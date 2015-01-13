package com.rpg.map
{
	import flash.geom.Point;

	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 17, 2011 2:56:44 PM 
	 **/ 
	
	public class MapData
	{
		public var elementList:Array;
		//costAry
		public var requirement:Array;
		public var level:int;
		public var width:Number = 2500;
		public var height:Number = 700;
		public var left:Number=0;
		public var top:Number=0;
		public var right:Number = 2500;
		public var bottom:Number = 700;
		public var pid:String;
		public var name:String;
		public var mapUrl:String;
		
		public var version:int = 0;
		public var frontBGImagePath:String = "";
		public var id:String = "0";
		public var startX:int;
		public var startY:int;
		
		public var rect:Object = null;
		public var tileHeight:Number = 300;
		public var tileWidth:Number = 300;
		public var type:int = 0;
		//typeAry 0通过，1阻挡，2阴影
		public var data:Array;
		public var isDefault:Boolean;
		public var createComplete:Boolean = false;
		
		public var cellTotalNum:int;
		public var rowNum:int;
		public var colNum:int;
		public var cellWidth:int;
		public var cellHeight:int;
		
		public function MapData()
		{
		}
	}
}