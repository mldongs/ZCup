package com.rpg.astar
{
	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 10, 2011 4:40:49 PM 
	 **/ 
	
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.binding.utils.BindingUtils;
	
	[Bindable]
	public class Cell extends Sprite
	{
		/**
		 *阻挡 
		 */
		public static const BLOCK:int = 1;
		/**
		 *遮罩 
		 */
		public static const TRANS:int = 2;
		/**
		 *通畅 
		 */
		public static const CLEAR:int = 0;
		
		private var _id:int; //标识
		private var _location:String;  //定位
		private var _cost:Number = 1; //代价
		private var _type:int = 0 //1：阻挡，2:透明，0：可通过
		private var sh:Shape;
		private var ch:int = 30;
		private var cw:int = 60;
		private var currentFillColor:uint = 0xeeeeee;
		private var fillColor:uint = 0xeeeeee;
		private var transparentFillColor:uint = 0x00ff00;
		private var blockFillColor:uint = 0xff0000;
		private var lineColor:uint = 0x333333;
		private var costColor:uint = 0x0000ff;
		
		private var txt:TextField;
		
		private var currentAlpha:Number = 0.2;
		private var defaultAlpha:Number = 0.2;
		private var overAlpha:Number = 0.5;
		
		private static var colorAry:Array = [0xffff00,
											 0xe3cf57,
											 0xff9912,
											 0xeb8e55,
											 0xffe384,
											 0xffd700,
											 0xdaa569,
											 0xff6103,
											 0xe3a869,
											 0xff6100,
											 0xed9121,
											 0xff8000,
											 0xf5deb3
											];
		private static var colorAry2:Array = [0xa020f0,
											  0x8a2be2,
											  0xa066d3,
											  0x9933fa,
											  0xda70d6,
											  0xdda0dd
											  ];
		
		public function Cell(w:int,h:int)
		{
			mouseChildren = false;
			
			ch = h;
			cw = w;
			sh = new Shape;
			addChild(sh);
			drawCell();
			
			super();
			
			cacheAsBitmap = true;
		}
		
		private function drawCell():void
		{
			sh.graphics.clear();
			sh.graphics.lineStyle(0.8,lineColor);
			sh.graphics.beginFill(currentFillColor,currentAlpha);
			sh.graphics.lineTo(cw,0);
			sh.graphics.lineTo(cw,ch);
			sh.graphics.lineTo(0,ch);
			sh.graphics.lineTo(0,0);
			sh.graphics.endFill();
		}
		

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
			if(_type==Cell.CLEAR)
			{
				currentFillColor = fillColor;
			}
			if(_type==Cell.BLOCK)
			{
				currentFillColor = blockFillColor;
			}
			if(_type==Cell.TRANS)
			{
				currentFillColor = transparentFillColor;
			}
			drawCell();
		}

	}
}