package com.zcup.core.fps  
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author mldongs
	 * qq:25772076
	 */
	public class FPS extends MovieClip 
	{
		private var maxMem:Number = 0;
		private var maxFPS:int = 0;
		private var currMem:Number = 0;
		private var currFPS:int = 0;
		private var mArr:Array = new Array();
		private var fArr:Array = new Array();
		private var time:Timer = new Timer(1000);
		private var g:Graphics;
		private var w:int = 120;
		private var h:int = 25;
		private var max:int = 50;
		private var txt:TextField = new TextField();
		
		public function FPS() 
		{
			g = graphics;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.mouseEnabled = false;
			addChild(txt);
			
			this.addEventListener(Event.ENTER_FRAME, counter);
			time.addEventListener(TimerEvent.TIMER, update);
			time.start();
		}
		
		private function counter(e:Event):void {
			currFPS++;
		}
		
		private function update(e:TimerEvent):void {
			fArr.push(currFPS);
			if (fArr.length > max)
				fArr.shift();
			maxFPS = currFPS > maxFPS?currFPS:maxFPS;
			currMem = int(System.totalMemory / 1024 / 1024 * 100) / 100;
			mArr.push(currMem);
			if (mArr.length > max)
				mArr.shift();
			maxMem = currMem > maxMem ? currMem:maxMem;
			
			g.clear();
			g.beginFill(0xffffff, .8);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			var str:String = "FPS:<font color='#0000ff'>" + currFPS + "</font> MEM:<font color='#0000ff'>" + currMem+"</font>";
			txt.htmlText = str;
			
			showLine();
			currFPS = 0;
		}
		
		private function showLine():void{
			//FPS
			g.lineStyle(1, 0x00ff00, .3);
			g.beginFill(0x00ff00, .3);
			g.moveTo(0, h);
			fArr.reverse();
			for (var i:int = 0; i <fArr.length; i++) {
				var vx:* = w * (i / max);
				var vy:* = h - h * (fArr[i] / maxFPS);
				g.lineTo(vx, vy);
			}
			g.lineTo(vx, h);
			g.endFill();
			fArr.reverse();
			//内存
			g.beginFill(0xff0000, .5);
			g.lineStyle(1, 0xff0000,.5);
			g.moveTo(0, h);
			mArr.reverse();
			for (i = 0; i <mArr.length; i++) {
				vx = w * (i / max);
				vy = h - h * (mArr[i] / maxMem);
				g.lineTo(vx, vy);
			}
			g.lineTo(vx, h);
			g.endFill();
			mArr.reverse();
		}
		
	}

}