package com.cttoronto.mobile.crackaquack.model
{
	import com.cttoronto.mobile.crackaquack.ConfigValues;
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
		
		private var url: String = 'http://ewe.insomniacbychoice.com:8090';
		
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
		
		// ******************************
		// @ARG_uid = user name
		// @ARG_type = "hunter" or "duck"
		public function login(ARG_uid:String, ARG_type:String):void {
			
			var req:URLRequest = new URLRequest(url + "/userName/" + ARG_uid + "/roomId/" + ConfigValues.ROOM_ID + "/playerType/" + ARG_type);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoggedIn);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(req);
			
		}
		
		private function onLoggedIn(e:Event):void {
			// TODO: set user id
			// TODO: set color of duck
		}

		// ******************************
		// @ARG_uid = user name
		public function leaveRoom(ARG_uid:int):void {
			var req:URLRequest = new URLRequest(url + "/leaveRoom/" + ARG_uid);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLeave);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(req);
		}
		
		private function onLeave(e:Event):void {
			
		}
		
		// ******************************
		// @ARG_uid = user name
		// @ARG_score = current score for flying
		// @ARG_dir = direction in values
		public function flyDuck(ARG_uid:int, ARG_score:int, ARG_dir:Number):void {
			var req:URLRequest = new URLRequest(url + "/uid/" + ARG_uid + "/direction/" + ARG_dir + "/score/" + ARG_score);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onFly);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(req);
		}
		
		private function onFly(e:Event):void {
			
		}
		
		// ******************************
		// @ARG_uid = UID from login
		// @ARG_type = color of the duck
		public function hit(ARG_uid:int, ARG_color:String):void {
			var req:URLRequest = new URLRequest(url + "/uid/" + ARG_uid + "/hit/" + ARG_color);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onHit);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(req);
			
		}
		
		private function onHit(e:Event):void {
			
		}
		
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