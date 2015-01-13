package com.zcup.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * ...
	 * @author mldongs
	 * @qq:25772076
	 * @desc: 用于位图渲染
	 */
	public class BitmapMovie extends TimeLine implements IMovie
	{
		private var _currentFrame:int = 0;
		private var _totalFrames:int = 0;
		private var _stop:Boolean = false;
		private var _loop:Boolean = true;
		
		private var _frameScript:Array;
		
		private var _frames:Array = [];
		private var _defaultFrameAction:Function;
		private var _endFrameAction:Function;
		
		private var _mc:Bitmap;
		
		public function BitmapMovie()
		{
			super();
			
			_mc = new Bitmap();
			addChild(_mc);
			_frameScript = [];
		}
		
		private function dispatch(frame:int) : void
		{
			dispatchEvent(new Event("mcz_" + frame));
		}
		
		public function removeAllFrameScript() : void
		{
			var index:String = null;
			for (index in _frameScript)
			{
				removeFrameScript(int(index));
			}
			
			_defaultFrameAction = null;
			_endFrameAction = null;
		}
		
		public function removeFrameScript(frame:int):void
		{
			if (_frameScript[frame])
			{
				removeEventListener("mcz_" + frame, _frameScript[frame],false);
				_frameScript[frame] = undefined;
			}
		}
		
		public function addFrameScript(frame:int,func:Function = null):void
		{
			if(frame>totalFrames)
			{
				return;
			}
			
			var handler:Function;
			var frame:int = frame-1;
			var func:Function = func;
			if (_frameScript[frame])
			{
				removeFrameScript(frame);
			}
			if (func != null)
			{
				handler = function (event:Event) : void
				{
					func();
				}
				addEventListener("mcz_" + frame, handler, false, 0, true);
				_frameScript[frame] = handler;
			}
		}
		
		override protected function onEnterFrame():void
		{
			if(_stop)
			{
				return;
			}
			_mc.bitmapData = _frames[_currentFrame];
			_currentFrame = _currentFrame + 1;
			//reset regPoint
			//			if (_regPoint.x != _changedRegPoint.x || _regPoint.y != _changedRegPoint.y)
			//			{
			//				regPoint = _changedRegPoint;
			//			}
			//			if (_defaultAction is Function)
			//			{
			//				_defaultAction();
			//			}
			if (_defaultFrameAction is Function)
			{
				_defaultFrameAction(_currentFrame);
			}
			if (_frameScript[_currentFrame])
			{
				dispatch(_currentFrame);
			}
			if (_currentFrame >= _totalFrames)//10
			{
				_currentFrame = 0;
				if (_endFrameAction is Function)
				{
					_endFrameAction();
				}
				if (_loop == false)
				{
					stop();
				}
				dispatchEvent(new Event("end_frame"));
			}
		}
		
		/**
		 * 
		 * @param delay
		 * 参数delay以帧数为单位。
		 * 例如delay=2,则延迟2帧后开始播放动画 
		 */
		public function play(delay:int=0):void
		{
			if(delay>0)
			{
				var delayTimer:Timer = new Timer(frameRate*delay,1);
				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function onDelay(e:TimerEvent):void{
					Timer(e.currentTarget).removeEventListener(TimerEvent.TIMER_COMPLETE,onDelay);
					_stop = false;
				});
				delayTimer.start();
				return;
			}
			_stop = false;
		}
		
		public function stop():void
		{
			_stop = true;
		}
		
		public function gotoAndPlay(frame:int,scene:String=null):void
		{
			_currentFrame = frame - 1 ;
			//_mc.bitmapData = _frames[_currentFrame];
			play();
		}
		
		public function gotoAndStop(frame:int,scene:String=null):void
		{
			_currentFrame = frame - 1;
			_mc.bitmapData = _frames[_currentFrame];
			stop();
		}
		
		public function nextFrame():void
		{
			_mc.bitmapData = _frames[_currentFrame++];
		}
		
		public function prevFrame():void
		{
			_mc.bitmapData = _frames[_currentFrame--];
		}
		
		override public function destroy():void
		{
			stop();
			super.destroy();
			
			_frameScript.length = 0;
			_frameScript = null;
			_currentFrame = 0;
			_totalFrames = 0;
			
			for each(var bmd:* in _frames){
				if(bmd is BitmapData)bmd.dispose();
			}
			//this.m_bmdArr = null;
			if(_mc.bitmapData)_mc.bitmapData.dispose();
			_mc.bitmapData = null;
			
			_frames = null;
			
			if(_mc!=null&&contains(_mc))
			{
				removeChild(_mc);
				_mc = null;
			}	
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		/**
		 * 设置播放组数。需手动play() 
		 * @param value
		 * 
		 */		
		public function playMovie(value:Array=null,delay:int=0):void
		{
			stop();
			
			if(value!=null)
			{
				movie = value;
			}
			
			currentFrame = 0;//重置当前帧
			totalFrames = _frames.length;
			removeAllFrameScript();
			play(delay);
		}
		
		public function set movie(value:Array):void
		{
			if(_frames!=value)
			{
				_frames = value;
				
				/*
				totalFrames = _frames.length;
				if(_frames)
				{
					_mc.bitmapData = _frames[0];
				}
				*/
			}
		}
		
		public function get movie():Array
		{
			return _frames;
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function set currentFrame(value:int):void
		{
			_currentFrame = value;
		}
		
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		public function set totalFrames(value:int):void
		{
			_totalFrames = value;
		}
		
		public function set endFrameAction(value:Function):void
		{
			_endFrameAction = value;
		}
		
		public function set defaultFrameAction(value:Function):void
		{
			_defaultFrameAction = value;
		}

		public function get mc():Bitmap
		{
			return _mc;
		}

		public function set mc(value:Bitmap):void
		{
			_mc = value;
		}

		public function get loop():Boolean
		{
			return _loop;
		}

		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
		
	}
}