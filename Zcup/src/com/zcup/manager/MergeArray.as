package com.zcup.manager
{
	
	/**
	 * ...合并多个数组,可合并一维数组和二维数组
	 * @author zkl
	 */
	public class MergeArray
	{
		private var i:int;
		
		private var j:int;
		
		public function Merge(...args):Array
		{
			var _newArray:Array = new Array;
			
			var len:int = args.length;
			
			if (len == 1) {
				
				//二维数组
				if (args[0] is Array) {
					
					for (i = 0; i < args[0].length; i++ ) {
						//合并一维数组
						_newArray = mergeing(args[0]); 
						
					}
				}
				
			}else {
				
				_newArray = mergeing(args);
				
			}
			
			return _newArray;
			
		}
		
		/**
		 * 合并一维数组
		 */
		private function mergeing(a1:Array):Array
		{
			var a:Array = new Array;
			
			for (i = 0; i < a1.length; i++ ) {
				
				if (a1[i] is Array) {
					
					for (j = 0; j < a1[i].length; j++ ) {
						
						a.push(a1[i][j]);
						
					}
					
				}
			}
			
			return a;
		}
		
	}
	
}