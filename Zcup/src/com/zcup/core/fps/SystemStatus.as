package com.zcup.core.fps
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 显示当前系统资源状态
	 * @author mldongs
	 * qq:25772076
	 */
    public class SystemStatus extends Sprite
    {
        private var statTime:uint;
        private var timer:Timer;
        private var statFrame:uint = 0;
        private var tf:TextField;
        private static var _instance:SystemStatus;

        public function SystemStatus()
        {
            if (_instance != null)
            {
                throw new Error("singleton");
            }
            addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
            this.timer = new Timer(1000);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.timer.start();
            this.statTime = getTimer();
            this.tf = new TextField();
            this.tf.border = true;
            this.tf.backgroundColor = 16777215;
            this.tf.background = true;
            addChild(this.tf);
            this.tf.autoSize = TextFieldAutoSize.LEFT;
            this.tf.mouseEnabled = false;
            this.alpha = 0.5;
        }

        private function onTimer(event:TimerEvent) : void
        {
            var st:* = getTimer();
            var ft:* = st - this.statTime;
            var cost:* = this.statFrame / ft * 1000;
            this.statTime = st;
            this.statFrame = 0;
            this.tf.text = "fps:" + cost + "\n";
            this.tf.appendText("vmVersion:" + System.vmVersion + "\n");
            this.tf.appendText("player:" + Capabilities.version + " ");
            if (Capabilities.isDebugger)
            {
                this.tf.appendText("debug");
            }
            this.tf.appendText("\nmem:" + System.totalMemory / 1024 / 1024 + "MB\n");
            this.tf.appendText("os:" + Capabilities.os + "\n");
            this.tf.appendText("os language:" + Capabilities.language + "\n");
            this.tf.appendText("pageCode:" + System.useCodePage + "\n");
            this.tf.appendText("playerType:" + Capabilities.playerType + "\n");
            this.tf.appendText("screenResolution:" + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY + "\n");
        }

        private function _onEnterFrame(event:Event) : void
        {
             var cf:* = this.statFrame + 1;
            statFrame = cf;
        }

        public static function getInstance() : SystemStatus
        {
            if (_instance == null)
            {
                _instance = new SystemStatus;
            }
            return _instance;
        }

    }
}
