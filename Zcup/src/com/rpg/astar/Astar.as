package com.rpg.astar
{
	import flash.geom.Point;

	/**
	 *
	 * @author： mldongs  
	 * @qq： 25772076 
	 * @time：Oct 17, 2011 8:28:29 PM 
	 **/ 
	
	public class Astar
	{
		private var _open:Array; 
		private var _closed:Array; 
		private var _grid:Grid; 
		private var _endNode:Node; 
		private var _startNode:Node; 
		private var _path:Array; 
		private var _heuristic:Function = euclidian2; 
		//private var _heuristic:Function = euclidian; 
		//private var _heuristic:Function = diagonal; 
		private var _straightCost:Number = 1.0; 
		private var _diagCost:Number = Math.SQRT2;
		
		public function Astar()
		{
		
		}
		
		public function findPath(grid:Grid):Boolean 
		{ 
			_grid = grid; 
			_open = new Array(); 
			_closed = new Array();
			_startNode = _grid.startNode;
			_endNode = _grid.endNode;
			_startNode.g = 0; 
			_startNode.h = _heuristic(_startNode); 
			_startNode.f = _startNode.g + _startNode.h;
			return search(); 
		}
		
//		public function find(param1:Point, param2:Point) : Array
//		{
//			var _loc_5:Array = null;
//			var _loc_6:int = 0;
//			var _loc_7:int = 0;
//			var _loc_8:Object = null;
//			_path = [];
//			if (_map[param1.y] == null)
//			{
//				return null;
//			}
//			_starPoint = _map[param1.y][param1.x];
//			if (_map[param2.y] == null)
//			{
//				return null;
//			}
//			_endPoint = _map[param2.y][param2.x];
//			if (_endPoint == null || _endPoint.value == 1)
//			{
//				return null;
//			}
//			if (_starPoint == null || _starPoint.value == 1)
//			{
//				return null;
//			}
//			if (_endPoint.x == _starPoint.x && _endPoint.y == _starPoint.y)
//			{
//				return null;
//			}
//			var _loc_3:Boolean = false;
//			initBlock();
//			var _loc_4:* = _starPoint;
//			while (!_loc_3)
//			{
//				
//				_loc_4.block = true;
//				_loc_5 = [];
//				if (_loc_4.y > 0)
//				{
//					_loc_5.push(_map[(_loc_4.y - 1)][_loc_4.x]);
//				}
//				if (_loc_4.x > 0)
//				{
//					_loc_5.push(_map[_loc_4.y][(_loc_4.x - 1)]);
//				}
//				if (_loc_4.x < (_w - 1))
//				{
//					_loc_5.push(_map[_loc_4.y][(_loc_4.x + 1)]);
//				}
//				if (_loc_4.y < (_h - 1))
//				{
//					_loc_5.push(_map[(_loc_4.y + 1)][_loc_4.x]);
//				}
//				if (_loc_4.y > 0 && _loc_4.x > 0 && !(_map[_loc_4.y][(_loc_4.x - 1)].value == 1 && _map[(_loc_4.y - 1)][_loc_4.x].value == 1))
//				{
//					_loc_5.push(_map[(_loc_4.y - 1)][(_loc_4.x - 1)]);
//				}
//				if (_loc_4.y < (_h - 1) && _loc_4.x > 0 && !(_map[_loc_4.y][(_loc_4.x - 1)].value == 1 && _map[(_loc_4.y + 1)][_loc_4.x].value == 1))
//				{
//					_loc_5.push(_map[(_loc_4.y + 1)][(_loc_4.x - 1)]);
//				}
//				if (_loc_4.y > 0 && _loc_4.x < (_w - 1) && !(_map[(_loc_4.y - 1)][_loc_4.x].value == 1 && _map[_loc_4.y][(_loc_4.x + 1)].value == 1))
//				{
//					_loc_5.push(_map[(_loc_4.y - 1)][(_loc_4.x + 1)]);
//				}
//				if (_loc_4.y < (_h - 1) && _loc_4.x < (_w - 1) && !(_map[(_loc_4.y + 1)][_loc_4.x].value == 1 && _map[_loc_4.y][(_loc_4.x + 1)].value == 1))
//				{
//					_loc_5.push(_map[(_loc_4.y + 1)][(_loc_4.x + 1)]);
//				}
//				_loc_6 = _loc_5.length;
//				_loc_7 = 0;
//				while (_loc_7 < _loc_6)
//				{
//					
//					_loc_8 = _loc_5[_loc_7];
//					if (_loc_8 == _endPoint)
//					{
//						_loc_8.nodeparent = _loc_4;
//						_loc_3 = true;
//						break;
//					}
//					if (_loc_8.value == 0)
//					{
//						count(_loc_8, _loc_4);
//					}
//					_loc_7++;
//				}
//				if (!_loc_3)
//				{
//					if (_open.length > 0)
//					{
//						_loc_4 = _open.splice(getMin(), 1)[0];
//						continue;
//					}
//					return [];
//				}
//			}
//			drawPath();
//			return _path;
//		}// end function

		
		public function search():Boolean
		{
			var node:Node = _startNode;
			if(!_endNode.walkable)
			{
				return false;
			}
			
			while(node != _endNode)
			{
				var startX:int = Math.max(0, node.x - 1);
				var endX:int = Math.min(_grid.numCols - 1, node.x + 1);
				var startY:int = Math.max(0, node.y - 1);
				var endY:int = Math.min(_grid.numRows - 1, node.y + 1);
				
				for(var i:int = startX; i <= endX; i++)
				{
					for(var j:int = startY; j <= endY; j++)
					{
						var test:Node = _grid.getNode(i, j);
						if(test == node || !test.walkable || !_grid.getNode(node.x, test.y).walkable || !_grid.getNode(test.x, node.y).walkable)
						{
							continue;
						}
						
						var cost:Number = _straightCost;
						if(!((node.x == test.x) || (node.y == test.y)))
						{
							cost = _diagCost;
							//continue;不能打斜走
						}
						var g:Number = node.g + cost * test.costMultiplier;
						var h:Number = _heuristic(test);
						var f:Number = g + h;
						if(isOpen(test) || isClosed(test))
						{
							if(test.f > f)
							{
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						}
						else
						{
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							_open.push(test);
						}
					}
				}
				
				_closed.push(node);
				if(_open.length == 0)
				{
					trace("no path found");
					return false
				}
				_open.sortOn("f", Array.NUMERIC);
				node = _open.shift() as Node;
			}
			buildPath();
			return true;
		}

		
		private function buildPath():void 
		{ 
			_path = new Array(); 
			var node:Node = _endNode; 
			_path.push(node); 
			while(node != _startNode) 
			{ 
				node = node.parent; 
				_path.unshift(node); 
			} 
		}
		
		public function get path():Array
		{
			return _path;
		}

		
		private function isOpen(node:Node):Boolean
		{
			for(var i:int = 0; i < _open.length; i++)
			{
				if(_open[i] == node)
				{
					return true;
				}
			}
			return false;
		}
		
		private function isClosed(node:Node):Boolean
		{
			for(var i:int = 0; i < _closed.length; i++)
			{
				if(_closed[i] == node)
				{
					return true;
				}
			}
			return false;
		}
		
		private function manhattan(node:Node):Number
		{
			return Math.abs(node.x - _endNode.x) * _straightCost + Math.abs(node.y + _endNode.y) * _straightCost;
		}
		
		private function euclidian(node:Node):Number
		{
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy) * _straightCost;
		}
		
		private function euclidian2(node:Node):Number
		{
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return dx * dx + dy * dy;
		}
		
		private function diagonal(node:Node):Number
		{
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
		
		public function get visited():Array
		{
			return _closed.concat(_open);
		}

	}
}