package com.cttoronto.mobile.crackaquack.events
{
	import flash.events.Event;
	
	public class BaseEvent extends Event
	{
		public static const SAMPLE_BASE_EVENT:String = "SAMPLE_BASE_EVENT";
		
		public var data:Object;
		
		public function BaseEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}