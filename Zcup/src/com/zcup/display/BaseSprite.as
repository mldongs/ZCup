package com.zcup.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/********************************************************************************
	 * wizard_tags
	 * Author:
	 * 		Dong
	 * Date:
	 * 		Dec 16, 2009
	 * Descriptor:显示对象的基类
	 * 		
	 ********************************************************************************/
	public class BaseSprite extends Sprite
	{
		public function BaseSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init); 
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init); 
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy); 
			
			removeAllChildren();
		}
		
		public function removeAllChildren():void
		{
			while(numChildren>0)
			{
				if(contains(getChildAt(numChildren-1)))
				{
					removeChildAt(numChildren-1);
				}
			}
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(contains(child))
			{
				super.removeChild(child);
			}
			return child;
		}
	}
}