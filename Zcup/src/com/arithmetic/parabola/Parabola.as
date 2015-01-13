package com.arithmetic.parabola
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * 抛物线
	 * @author:wewell
	 * */
	public class Parabola
	{
		private var from:Point;    //起点
		private var toPos:Point;   //终点
		private var g:Number;  		  //重力加速度,数值越大越趋于水平
		private var unitPoints:int;   //单位时间记录点的个数,数值越大曲线越平滑
		private var type:int;
		private var path:Array;
		public const TYPE_Parabola:int=0; //抛物线
		public const TYPE_Line:int=1;	  //直线
		
		public function Parabola(){}
		
		public function getPaths(from:Point, toPos:Point,type:int=0, unitPoints:int=1, g:Number=1.58):Array{
			this.from = new Point(from.x, from.y);
			this.toPos = new Point(toPos.x, toPos.y);
			this.unitPoints = unitPoints >1 ? unitPoints : 1;
			this.g = getG(g);
			this.type = type;
			this.path = getPathByType(type);
			return path;
		}
		
		public function getTime():int{
			switch(type){
				case TYPE_Line:
					return 6+int(getDis()/40);
				case TYPE_Parabola:
					return 16+int(getDis()/40);
				default:
					return 16+int(getDis()/40);
			}
		}
		
		public function getUnitPoints():int{
			return unitPoints;
		}
		
		private function getG(g:Number):Number{
			return g+getDis()/40*0.01;
		}
		
		//取得横向位移
		private function getDX():Number{
			return toPos.x - from.x;
		}
		
		//取得纵向位移
		private function getDY():Number{
			return toPos.y - from.y;
		}
		
		//取得斜率
		private function getK():Number{
			return getDX() != 0 ? getDY()/getDX() : Math.PI;
		}
		
		//取得夹角
		private function getAngle():Number{
			return getK()!= Math.PI ? Math.atan(getK()): getK()/2;
		}
		
		//取得方向
		private function getDirection():int{
			return from.x > toPos.x ? -1 : 1;
		}
		
		//起点到终点位移
		private function getDis():Number{
			return Point.distance(from,toPos);
		}

		//取得投影到X轴上的平均速度
		private function getVx():Number{
			return getDX()/getTime();
		}
		
		//取得Y轴上的速度
		private function getVy():Number{
			return -g*getTime()*0.5;
		}
		
		private function getPathByType(type:int):Array
		{
			switch(type){
				case TYPE_Parabola:
					return getParabola();
				case TYPE_Line:
					return getLine();
				default:
					return getParabola();
			}
		}
		
		//取得直线
		private function getLine():Array{
			var paths:Array = new Array();
			var t:Number = 0;
			var va:Number = 2;
			while(t<getTime()){
				paths.push( new Point(getDX()/getTime()*t+from.x, getDY()/getTime()*t+from.y) );
				if(va>1){
					va-=0.1;
				}
				t+= 1/unitPoints*va;
			}
			return paths;
		}
		
		//取得抛物线
		private function getParabola():Array{		
			var paths:Array = new Array();
			var t:Number=0;
			var vx:Number = getVx();
			var vy:Number = getVy();
			var va:Number = 2;
			while(t < getTime()){
				var x:Number = vx*t+from.x;
				var y:Number = (vy*t + 0.5*g*t*t + from.y)+getK()*vx*t;
				paths.push(new Point(x,y));
				if(va>1){
					va -=0.1;
				}
				t += 1/unitPoints*va;
			}
			return paths; //paths记录的点个数:getTime()*unitPoints;
		}
		
		//扩展曲线类型...
		
		
		//--------------------------------动画处理---------------------------------------------------------
		private var target:DisplayObject;
		private var onComplete:Function;
		private var onCompleteParams:Array;
		private 	function nextPoint(evt:TimerEvent=null):void{
			if(path && path.length){
				var p:Point = path.shift();
				target.x = p.x;
				target.y = p.y;
			}else{
				if(onComplete != null){
					onComplete.apply(null, onCompleteParams);
				}
				Timer(evt.target).removeEventListener(TimerEvent.TIMER, nextPoint);
			}
		}
		
		public function startMove(target:DisplayObject, time:Number, vars:Object):void{
			if(vars && target){
				this.target = target;
				
				if(!vars.hasOwnProperty("type"))
					vars["type"] = 0;
				if(!vars.hasOwnProperty("unitPoints"))
					vars["unitPoints"] = Point.distance(new Point(target.x, target.y),new Point(vars.x, vars.y));
				if(!vars.hasOwnProperty("g"))
					vars["g"] = 1.58;
				if(vars.hasOwnProperty("onComplete"))
					this.onComplete = vars.onComplete;
				if(vars.hasOwnProperty("onCompleteParams"))
					this.onCompleteParams = vars.onCompleteParams;
				
				var path:Array = getPaths(new Point(target.x, target.y), new Point(vars.x, vars.y), vars["type"], vars["unitPoints"], vars["g"]);
				var speed:Number = time/path.length;
				var timer:Timer = new Timer(33);//int(parseFloat(speed.toFixed(3))*1000)
				timer.addEventListener(TimerEvent.TIMER, nextPoint);
				timer.start();
			}
		}
		
		//************************************************************************************
		/**
		 * 
		 * @param target
		 * @param time
		 * @param vars {x:x, y:y, type:0, unitPoints:1, g:1.58, onComplete:function, onCompleteParams:[]}
		 * 
		 */		
		public static function to(target:DisplayObject, time:Number, vars:Object):void{
			var parabola:Parabola = new Parabola();
			parabola.startMove(target, time, vars);
		}
	}
}