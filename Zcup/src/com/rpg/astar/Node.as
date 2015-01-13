package com.rpg.astar
{
	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 17, 2011 7:34:59 PM 
	 **/ 
	
	public class Node 
	{ 
		public var x:int; 
		public var y:int; 
		public var f:Number; 
		public var g:Number; 
		public var h:Number;
		public var walkType:int = 0;//1：阻挡，2:透明，0：可通过
		public var cost:int;
		public var walkable:Boolean = true; 
		public var parent:Node; 
		public var costMultiplier:Number = 1.0;
		public function Node(x:int, y:int) 
		{ 
			this.x = x; 
			this.y = y; 
		} 
	}
}