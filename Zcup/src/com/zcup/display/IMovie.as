package com.zcup.display
{

	/**
	 * 
	 * @atuhor: mldongs
	 * @qq: 25772076
	 * @time: 2011-9-19 下午12:18:06
	 **/
	
	public interface IMovie
	{
		
		function removeAllFrameScript():void;
		function removeFrameScript(frame:int):void;
		function addFrameScript(frame:int,func:Function = null):void;
		function play(delay:int=0):void;
		function stop():void;
		function gotoAndPlay(frame:int,scene:String=null):void;
		function gotoAndStop(frame:int,scene:String=null):void;
		function nextFrame():void;
		function prevFrame():void;
		function destroy():void;
		function get currentFrame():int;
		function set currentFrame(value:int):void;
		function get totalFrames():int;
		function set totalFrames(value:int):void;
		function set endFrameAction(value:Function):void;
		function set defaultFrameAction(value:Function):void
			
	}
}