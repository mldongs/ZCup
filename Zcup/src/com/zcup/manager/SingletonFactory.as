package com.zcup.manager
{
	import com.zcup.utils.HashMap;

	/**
	 * 单例工厂
	 * @author pvsp
	 *
	 */
	public class SingletonFactory
	{
		private static var objectCache:HashMap=new HashMap();

		/**
		 * 创建对象
		 * @param clz  对象类型
		 * @return
		 *
		 */
		public static function createObject(clz:Class):*
		{
			var result:Object=objectCache.get(clz);
			if (result == null)
			{
				result=new clz();
				objectCache.put(clz, result);
			}
			return result;
		}
	}
}