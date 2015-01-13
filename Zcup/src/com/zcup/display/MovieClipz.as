package com.zcup.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * 
	 * @author dong
	 * 矢量动画类（已由VectorMovie代替）
	 */	
	public class MovieClipz extends TimeLine
	{
		private var _movie:MovieClip;
		private var _currentFrame:int = 0;
		private var _totalFrames:int = 0;
		private var _stop:Boolean = false;
		private var _loop:Boolean = true;
		
		private var _frameScript:Array;
		
		
		private var _defaultFrameAction:Function;
		private var _endFrameAction:Function;
		
		
		public function MovieClipz()
		{
			super();
			
			_frameScript = [];
			cacheAsBitmap = true;
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
			var handler:Function;
			var frame:int = frame;
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
			_currentFrame = _currentFrame + 1;
			_movie.gotoAndStop(_currentFrame);
			//_mc.bitmapData = _frames[_currentFrame++];
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
			if (_currentFrame >= _totalFrames)
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
			}
		}
		
		public function play():void
		{
			_stop = false;
		}
		
		public function stop():void
		{
			_stop = true;
		}
		
		public function gotoAndPlay(frame:int,scene:String=null):void
		{
			_currentFrame = frame;
			_movie.gotoAndStop(_currentFrame);
			play();
		}
		
		public function gotoAndStop(frame:int,scene:String=null):void
		{
			_currentFrame = frame;
			_movie.gotoAndStop(_currentFrame);
			stop();
		}
		
		public function nextFrame():void
		{
			_movie.gotoAndStop(_currentFrame++);
		}
		
		public function prevFrame():void
		{
			_movie.gotoAndStop(_currentFrame--);	
		}
		
		
		public function nextScene():void
		{
			_movie.nextScene();
		}
		
		public function prevScene():void
		{
			_movie.prevScene();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_frameScript.length = 0;
			_frameScript = null;
			_currentFrame = 0;
			_totalFrames = 0;
			_movie.stop();
			if(_movie!=null&&contains(_movie))
			{
				removeChild(_movie);
				_movie = null;
			}	
		}
		
		public function playMovie(mc:MovieClip):void
		{
			stop();
			mc.gotoAndStop(1);
			
			movie = mc;
			
			currentFrame = 0;
			totalFrames = movie.totalFrames;
			
			removeAllFrameScript();
			play();
		}

		private function get movie():MovieClip
		{
			return _movie;
		}

		private function set movie(value:MovieClip):void
		{
			if(_movie!=value)
			{
				if(_movie)
				{
					if(contains(_movie))
					{
						removeChild(_movie);
					}
					_movie.stop();
					_movie = null;
				}
				_movie = value;
				addChild(_movie);
			}
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

		
	}
}