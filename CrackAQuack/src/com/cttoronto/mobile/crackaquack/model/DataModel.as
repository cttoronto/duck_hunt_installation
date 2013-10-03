package com.cttoronto.mobile.crackaquack.model
{

	import com.cttoronto.mobile.crackaquack.ConfigValues;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;

	public class DataModel extends EventDispatcher
	{
		
		private var _uid:int = 0;
		private var _color:uint;
		private var _toleranceHigh:int = 90;
		private var _toleranceLow:int = 90;
		
		public static const IPHONE_1G:String = "iPhone1,1"; 
		// first gen is 1,1 
		public static const IPHONE_3G:String = "iPhone1"; 
		// second gen is 1,2 
		public static const IPHONE_3GS:String = "iPhone2"; 
		// third gen is 2,1 
		public static const IPHONE_4:String = "iPhone3"; 
		// normal:3,1 verizon:3,3 
		public static const IPHONE_4S:String = "iPhone4"; 
		// 4S is 4,1 
		public static const IPHONE_5PLUS:String = "iPhone"; 
		public static const TOUCH_1G:String = "iPod1,1"; 
		public static const TOUCH_2G:String = "iPod2,1"; 
		public static const TOUCH_3G:String = "iPod3,1"; 
		public static const TOUCH_4G:String = "iPod4,1"; 
		public static const TOUCH_5PLUS:String = "iPod"; 
		public static const IPAD_1:String = "iPad1"; 
		// iPad1 is 1,1 
		public static const IPAD_2:String = "iPad2"; 
		// wifi:2,1 gsm:2,2 cdma:2,3 
		public static const IPAD_3:String = "iPad3"; 
		// (guessing) 
		public static const IPAD_4PLUS:String = "iPad"; 
		public static const UNKNOWN:String = "unknown"; 
		private static const IOS_DEVICES:Array = [IPHONE_1G, IPHONE_3G, IPHONE_3GS, IPHONE_4, IPHONE_4S, IPHONE_5PLUS, IPAD_1, IPAD_2, IPAD_3, IPAD_4PLUS, TOUCH_1G, TOUCH_2G, TOUCH_3G, TOUCH_4G, TOUCH_5PLUS];
		
		private static var instance:DataModel;
		private static var allowInstantiation:Boolean = true;
		
		private var _guiSize:Rectangle; 
		private var _deviceSize:Rectangle; 
		private var _appScale:Number; 
		private var _appSize:Rectangle; 
		private var _appLeftOffset:Number; 
		
		
		private var _loaded:Boolean = false;
				
		private var _path:String = '';				

		public function get toleranceLow():int
		{
			return _toleranceLow;
		}

		public function set toleranceLow(value:int):void
		{
			_toleranceLow = value;
		}

		public function get toleranceHigh():int
		{
			return _toleranceHigh;
		}

		public function set toleranceHigh(value:int):void
		{
			_toleranceHigh = value;
		}
		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
		}

		public function get uid():int
		{
			return _uid;
		}

		public function set uid(value:int):void
		{
			_uid = value;
		}

		public function get guiSize():Rectangle
		{
			return _guiSize;
		}

		public function set guiSize(value:Rectangle):void
		{
			_guiSize = value;
		}

		public function get deviceSize():Rectangle
		{
			return _deviceSize;
		}

		public function set deviceSize(value:Rectangle):void
		{
			_deviceSize = value;
		}

		public function get appLeftOffset():Number
		{
			return _appLeftOffset;
		}

		public function set appLeftOffset(value:Number):void
		{
			_appLeftOffset = value;
		}

		public function get appSize():Rectangle
		{
			return _appSize;
		}

		public function set appSize(value:Rectangle):void
		{
			_appSize = value;
		}

		public function get appScale():Number
		{
			return _appScale;
		}

		public function set appScale(value:Number):void
		{
			_appScale = value;
		}

		public function get busy():Boolean
		{
			return _busy;
		}

		public function set busy(value:Boolean):void
		{
			_busy = value;
		}

		public function get path():String { return _path; }
		public function set path(ARG_val:String):void { _path = ARG_val; }
		
		private var _busy:Boolean = false;
		
		
		private var _xmlData:XML;							
		public function get xmlData():XML { return _xmlData; }
		
		public function DataModel() {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use DataModel.getInstance() instead of new.");
			}
		}
		
		/**
		 * load XML
		 *	creates a loader and listener for that load.
		 *	uses a URL Request to load the XML file
		 * 
		 * @ARG_xmlFile - path to the XML file
		 */
		public function loadXML(ARG_xmlFile:String):void {
			
			// initialize by getting the data from the XML
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadXMLComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			loader.load(new URLRequest("http://ewe.insomniacbychoice.com/data.json"));	
		}
		
		private function xmlLoadError(ARG_evt:IOErrorEvent):void {
		
//			var loader:URLLoader = new URLLoader();
//			loader.addEventListener(Event.COMPLETE, loadXMLComplete);
//			loader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
//			loader.load(new URLRequest("data/content.xml"));	
		
		}
		
		/**
		 * XML loading is complete
		 * set the XML data to a variable and
		 * dispatch an event to let listeners know it is ready
		 * 
		 * @param ARG_evt load event
		 * @throws Event initialization event
		 */
		private function loadXMLComplete(ARG_event:Event):void {
			
			_loaded = true;
			XML.ignoreWhitespace = true;
			var l:URLLoader = URLLoader(ARG_event.currentTarget);
			
			// get the loaded xml
			//_xmlData = new XML(ARG_event.target.data);
			var json:Object = JSON.parse(l.data);
			// dispatch the loaded event
			
			if (!isNaN(json.toleranceHigh)) instance.toleranceHigh = json.toleranceHigh as int;
			if (!isNaN(json.toleranceLow)) instance.toleranceLow = json.toleranceLow as int;
			
			
		}

		public static function getInstance() : DataModel
		{
			if (DataModel.instance == null)
			{
				DataModel.instance = new DataModel();
				allowInstantiation = false;
			}
			return DataModel.instance;
		}// end function
		
		
		public static function getDevice():String { 
			var info:Array = Capabilities.os.split(" "); 
			
			if (String(info[1]).indexOf("cyanogen")!= -1) { 
				return String(info[1]); 
			} 
			
			if (info[0] + " " + info[1] != "iPhone OS") { 
				return UNKNOWN; 
			} 
			
			// ordered from specific (iPhone1,1) to general (iPhone) 
			for each (var device:String in IOS_DEVICES) { 
				if (info[3].indexOf(device) != -1) { 
					return device; 
				} 
			}
			
			return UNKNOWN; 
		} 
		
		public function setScaling(stage:Stage):void {
			
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
			
			guiSize = new Rectangle(0, 0, ConfigValues.START_SCALE.width, ConfigValues.START_SCALE.height); 
			deviceSize = new Rectangle(0, 0, Math.max(stage.fullScreenWidth, stage.fullScreenHeight), Math.min(stage.fullScreenWidth, stage.fullScreenHeight)); 
			appScale = 1; 
			appSize = guiSize.clone(); 
			appLeftOffset = 0; 
			
			// if device is wider than GUI's aspect ratio, height determines scale 
			if ((deviceSize.width/deviceSize.height) > (guiSize.width/guiSize.height)) { 
				appScale = deviceSize.height / guiSize.height; 
				appSize.width = deviceSize.width / appScale; 
				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2); 
			} else { 
				// if device is taller than GUI's aspect ratio, width determines scale
				appScale = deviceSize.width / guiSize.width; 
				appSize.height = deviceSize.height / appScale; 
				appLeftOffset = 0; 
			}

			// scale the entire interface 
//			base.scale = appScale; 
			
			// map stays at the top left and fills the whole screen 
//			base.map.x = 0; 
			
			// menus are centered horizontally 
//			base.menus.x = appLeftOffset; 
			
			// crop some menus which are designed to run off the sides of the screen 
//			base.scrollRect = appSize; 
			
		}
		
		public static function convertVectorToBitmap(object:DisplayObject, stage:Stage):Bitmap {
			// the original object's size (won't include glow effects!) 
			var objectBounds:Rectangle = object.getBounds(object); 
			objectBounds.x *= object.scaleX; 
			objectBounds.y *= object.scaleY; 
			objectBounds.width *= object.scaleX; 
			objectBounds.height *= object.scaleY; 
			
			// the target bitmap size 
			var scaledBounds:Rectangle = objectBounds.clone(); 
			scaledBounds.x *= instance.appScale; 
			scaledBounds.y *= instance.appScale; 
			scaledBounds.width *= instance.appScale; 
			scaledBounds.height *= instance.appScale; 
			
			// scale and translate up-left to fit the entire object 
			var matrix:Matrix = new Matrix(); 
			matrix.scale(object.scaleX, object.scaleY); 
			matrix.scale(instance.appScale, instance.appScale); 
			matrix.translate(-scaledBounds.x, -scaledBounds.y); 
			
			// briefly increase stage quality while creating bitmapData 
			stage.quality = StageQuality.HIGH; 
			var bitmapData:BitmapData = new BitmapData(scaledBounds.width, scaledBounds.height, true); 
			bitmapData.draw(object, matrix); 
			stage.quality = StageQuality.LOW; 
			
			// line up bitmap with the original object and replace it 
			var bitmap:Bitmap = new Bitmap(bitmapData); 
			bitmap.x = objectBounds.x + object.x; 
			bitmap.y = objectBounds.y + object.y; 
			object.parent.addChildAt(bitmap, object.parent.getChildIndex(object)); 
			object.parent.removeChild(object); 
			
			// invert the scale of the bitmap so it fits within the original gui 
			// this will be reversed when the entire application base is scaled 
			
			bitmap.scaleX = bitmap.scaleY = (1 / instance.appScale);
			return bitmap;
		}
		
		/**
		 * DATA ACCESS FUNCTIONS
		 */
		
		
	}
}