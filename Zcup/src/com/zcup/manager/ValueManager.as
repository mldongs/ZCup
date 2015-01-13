package com.zcup.manager
{
	public class ValueManager
	{
		public function ValueManager()
		{
		}
		/**
		 *通用静态信息管理 
		 * @param ary 数据源
		 * @param by 筛选字段
		 * @param byValue 筛选字段值
		 * @param select 获取字段
		 * 
		 */		
		public static function selectItem(ary:Array,by:String,byValue:Object,select:String,by2:String="",by2Value:Object=null):Object{
			var obj:Object;
			for(var s:int=0;s<ary.length;s++){
				if(ary[s][by]==byValue){
					
					obj=new Object();
					
					if(select=="INDEX"){
						obj=s;
					}else if(select=="THIS"){
						obj=ary[s];
					}else{
						obj=ary[s][select];
					}
				}
			}
			if(obj==null){
				//Logger.debug("找不到 数据 Array:"+ary.toString()+"的"+by+"值为:"+byValue.toString()+"的"+select.toString());
			}
			return obj;
		}
		
		
		public static function ran():Number{
			return Math.random()-0.5;
		}
		
		public static function hasId(value:Array,id:int):Boolean{
			for each(var i:int in value){
				if(id==i){
					return true;
				}
			}
			return false;
		}
		public static function hasFromArray(array1:Array,array2:Array):Array{
			var rd:Array=new Array();
			for each(var id:int in array1){
				if(hasId(array2,id)==false){
					rd.push(id);
				}
			}
			return rd;
		}
		
	}
}