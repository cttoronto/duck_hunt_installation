package com.cultcreative.utils
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;

	public class Debug extends EventDispatcher
	{
		// severity types
		public static const CRITICAL_ERROR:String = "criticalError";
		public static const ERROR:String= "error";
		public static const FILE_ERROR:String = "fileError";
		public static const DEBUG:String = "debug";
		public static const INFO:String = "info";
		
		// setup a list of debug domains 
		// if left blank, will always trace and out to console unless otherwise specified
		private var _debugDomains:Array = [];
		// set the entire debug list (will overwrite any individually set domains)
		public function set debugDomains(ARG_arr:Array):void { _debugDomains = ARG_arr; }
		// add a single domain to the debug list
		public function addDebugDomain(ARG_item:String):void { _debugDomains.push(ARG_item); }
		// remove a single domain to the debug list
		public function removeDebugDomain(ARG_item:String):void { if (_debugDomains.indexOf(ARG_item) != -1) _debugDomains.splice(_debugDomains.indexOf(ARG_item), 1); }
		
		private static var instance:Debug;
		private static var allowInstantiation:Boolean;
		
		// should i trace?
		private var _trace:Boolean = true;
		public function set displayTraces(ARG_bool:Boolean):void { _trace = ARG_bool; }
		
		// should i write to the console?
		private var _console:Boolean = true;
		public function set displayConsole(ARG_bool:Boolean):void {
			// check to see if external interface is available 
			if (ExternalInterface.available) {
				_console = ARG_bool;
			} else {
				_console = false;
				trace("ExternalInterface is unavailable");
			} 
		}
		
		public static function getInstance():Debug {
			if (instance == null) {
				allowInstantiation = true;
				instance = new Debug();
				allowInstantiation = false;
				instance.displayConsole = true;
			}
			return instance;
		}
		  
		public function Debug():void {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use Debug.getInstance() instead of new.");
			}
		}
		
		public function log(ARG_errorType:String, ... args):void {
			
			var message:String = args.join(",");
			
			
			switch (ARG_errorType) {
				
				case CRITICAL_ERROR:
					this.onCriticalError(message);
					break;
				case ERROR:
					this.onError(message);
					break;
				case FILE_ERROR:
					this.onFileError(message);
					break;
				case DEBUG:
					this.onDebug(message);
					break;
				case INFO:
				default:
					this.onInfo(message);
			}
		}
		
		public function info(... args):void {
			var message:String = args.join(", ");
			this.onInfo(message);
		}
		
		public function error(... args):void {
			var message:String = args.join(", ");
			this.onError(message);
		}
		
		private function onCriticalError(ARG_message:String):void {
			
			var isDebugDomain:Boolean = checkDebugDomains();
			
			// console log
			if (_console && isDebugDomain) ExternalInterface.call("console.error", ARG_message);
			// trace
			if (_trace && isDebugDomain) trace("[CRITICAL ERROR] " + ARG_message);
			// track
			
			// log
		}
		
		private function onError(ARG_message:String):void {
			
			var isDebugDomain:Boolean = checkDebugDomains();
			
			// console log
			if (_console && isDebugDomain) ExternalInterface.call("console.warning", ARG_message);
			// trace
			if (_trace && isDebugDomain) trace("[ERROR] " + ARG_message);
			// track
			
			// log
		}
		
		private function onFileError(ARG_message:String):void {
			
			var isDebugDomain:Boolean = checkDebugDomains();
			
			// console log
			if (_console && isDebugDomain) ExternalInterface.call("console.error", ARG_message);
			// trace
			if (_trace && isDebugDomain) trace("[FILE ERROR] " + ARG_message);
			// track
			
			// log
		}
		
		private function onDebug(ARG_message:String):void {
			
			var isDebugDomain:Boolean = checkDebugDomains();
			
			// console log
			if (_console && isDebugDomain) ExternalInterface.call("console.debug", ARG_message);
			// trace
			if (_trace && isDebugDomain) trace("[DEBUG] " + ARG_message);
		}
		
		private function onInfo(ARG_message:String):void {
			
			var isDebugDomain:Boolean = checkDebugDomains();
			
			// console log
			if (_console && isDebugDomain) ExternalInterface.call("console.info", ARG_message);
			// trace
			if (_trace && isDebugDomain) trace("[INFO] " + ARG_message);
		}
		
		/**
		* check debug domains
		* Run through the debug domains and check them against the current domains
		* 
		* @return 	Boolean	- true if the domain is is in the debug list or the domain list is empty
		**/
		private function checkDebugDomains():Boolean {
			
			// if there are debug domains and external interface is available
			if (_debugDomains.length > 0 && ExternalInterface.available) {
				
				// get the current domain
				var curDomain:String = ExternalInterface.call("window.location.href.toString");
				
				// set a found var to track if the url is found
				var found:Boolean = false;
				
				// run through all the debug domains
				for(var i:int = 0; i < _debugDomains.length; i++) {
					// if it is a debug domain set found
					if (curDomain.indexOf(_debugDomains[i]) != -1) found = true;
				}
				
				// set is debug to found
				return found;
			} else {
				return true;
			}
		}
		
	}
}