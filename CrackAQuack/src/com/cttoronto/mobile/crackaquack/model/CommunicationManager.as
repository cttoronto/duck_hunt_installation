package com.cttoronto.mobile.crackaquack.model
{
	import com.cttoronto.mobile.crackaquack.ConfigValues;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class CommunicationManager extends EventDispatcher
	{
		
		private static var instance:CommunicationManager;
		private static var allowInstantiation:Boolean = true;
		
		private var url: String = 'http://www.crackaquack.com:8090';
		
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
			trace(req.url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoggedIn);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(req);
			
		}
		
		private function onLoggedIn(e:Event):void {
			
			var l:URLLoader = e.target as URLLoader;
			var json:Object = JSON.parse(l.data);
//			trace(json.result);
			if (json.result == "SUCCESS") {
				DataModel.getInstance().uid = json["user"].uid as int;
				if (json["user"].playerType == "duck") {
					// set the color
					DataModel.getInstance().color = ConfigValues.PLAYER_COLOR[json["user"].color];
					DataModel.getInstance().colorString = json["user"].color;
				}
				DataModel.getInstance().dispatchEvent(new Event("LOGIN_COMPLETE"));
			} else {
				// TODO: handle error for no ducks left
				// TODO: handle error for user taken
				trace("ERROR LOGGING IN " + json["message"]);
				DataModel.getInstance().dispatchEvent(new Event("LOGIN_ERROR"));
			}
			// {"result":"SUCCESS","user":{"userName":"sss","score":0,"ranking":0,"hits":0,"roomId":"demo","playerType":"duck","uid":0, "color": "green"}}
			// {"result":"ERROR","type":"JOIN_ROOM","message":"You are already in room: demo"}
			
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
			var l:URLLoader = e.target as URLLoader;
			var json:Object = JSON.parse(l.data);
			
			l.removeEventListener(Event.COMPLETE, onFly);
			l.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			if (json.result == "SUCCESS") {
				if (json["user"].dead == true) {
					DataModel.getInstance().dispatchEvent(new Event("DUCK_DIED"));
				}
			} else if (json.result == "ERROR") {
				DataModel.getInstance().dispatchEvent(new Event("DUCK_DIED"));
			}
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
			var l:URLLoader = e.target as URLLoader;
			var json:Object = (JSON.parse(l.data));
			l.removeEventListener(Event.COMPLETE, onHit);
			l.removeEventListener(IOErrorEvent.IO_ERROR, onError);
//			trace(json.result, json.user.uid);
			//{"result":"SUCCESS","user":{"__v":0,"_id":"524b5b378ceb21793b000001","active":true,"hits":6,"loggedIn":true,"password":"password","playerType":"hunter","ranking":1,"registered":"true","roomId":"demo","score":0,"socialId":0,"type":"","uid":0,"userName":"testUserName"}}
		}
		
		
		private function onError(e:IOErrorEvent):void {
			trace("io error");
			DataModel.getInstance().dispatchEvent(new Event("LOGIN_ERROR"));
		}
		
		
	}
}