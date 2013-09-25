package com.cttoronto.mobile.crackaquack.model
{
	import com.cttoronto.mobile.crackaquack.events.BaseEvent;
	import com.cultcreative.utils.Debug;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class CommunicationManager extends EventDispatcher
	{
		
		private static var instance:CommunicationManager;
		private static var allowInstantiation:Boolean = true;
		
		private var url: String = 'http://localhost:8080';
		
		private var _connected:Boolean = false;
		private var attempts:int = 0;
		
		public function CommunicationManager() {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use CommunicationManager.getInstance() instead of new.");
			}
		}

		public static function getInstance() : CommunicationManager
		{
			if (CommunicationManager.instance == null)
			{
				CommunicationManager.instance = new CommunicationManager();
				allowInstantiation = false;
			}
			return CommunicationManager.instance;
		}// end function
		
		public function submitScore(ARG_score:int, ARG_uid:String):void {
			var req:URLRequest = new URLRequest(url + "/score/" + ARG_uid + "/" + ARG_score);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onScoreSubmitted);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(req);
		}
		
		
		private function onScoreSubmitted(e:Event):void {
			var l:URLLoader = e.target as URLLoader;
			var data:Object = l.data;
			
		}
		
		private function onError(e:IOErrorEvent):void {
			
		}
		
		
	}
}