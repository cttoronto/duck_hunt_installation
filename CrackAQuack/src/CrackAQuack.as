package
{
	import com.cttoronto.mobile.crackaquack.Main;
	import com.cttoronto.mobile.crackaquack.model.CommunicationManager;
	import com.cttoronto.mobile.crackaquack.model.DataModel;
	import com.cultcreative.utils.Debug;
	import com.distriqt.extension.testflightsdk.TestFlightSDK;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(backgroundColor="#000000")]
	public class CrackAQuack extends Sprite
	{
		private var main:Main;
		
		public static const DEV_KEY:String = "c4074e539ed11835393595b26c0670da_MzIyNTAzMjAxNC0wMS0wOSAxNjoyOTozMC42MTQ0Mjk";
		public static const TESTFLIGHT_APPTOKEN_IOS:String = "d850af38-2fea-4565-91a7-8971a90f8061";
		
		public function CrackAQuack()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			DataModel.getInstance().setScaling(stage);
			DataModel.getInstance().loadXML("");
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE , handleDeactivate, false, 0, true);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
		}
		
		private function initTestFlight():void {
			try
			{
				TestFlightSDK.init( DEV_KEY );
				
				var ns:Namespace = NativeApplication.nativeApplication.applicationDescriptor.namespace();
				var version:String = NativeApplication.nativeApplication.applicationDescriptor.ns::versionNumber;
				Debug.getInstance().info( "Starting application: " + NativeApplication.nativeApplication.applicationID +" ["+version+"]" );
				
				Debug.getInstance().info( "TestFlightSDK Supported: "+ TestFlightSDK.isSupported );
				Debug.getInstance().info( "TestFlightSDK Version: "  + TestFlightSDK.service.version );
				
				//
				//	Call startTestFlight with the appToken for the correct platform 
				if (TestFlightSDK.service.version.indexOf( "Android" ) != -1)
				{					
					//					message( "Starting TestFlight for Android...");
					//					message( "app token = " + TESTFLIGHT_APPTOKEN_ANDROID );
					
					//					TestFlightSDK.service.startTestFlight( TESTFLIGHT_APPTOKEN_ANDROID );
				}
				else	
				{
					Debug.getInstance().info( "Starting TestFlight for iOS...");
					Debug.getInstance().info( "app token = " + TESTFLIGHT_APPTOKEN_IOS );
					
					TestFlightSDK.service.startTestFlight( TESTFLIGHT_APPTOKEN_IOS );
				}
				
				//				stage.addEventListener( MouseEvent.CLICK, testFlightActionHandler, false, 0, true );
			}
			catch (e:Error)
			{
				Debug.getInstance().info( "ERROR:: " +e.message );
			}
		}
		
		private function handleDeactivate(e:Event):void {
			CommunicationManager.getInstance().leaveRoom(DataModel.getInstance().uid);
		}
		
		private function onAdded(e:Event):void {
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.initTestFlight();
			
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(e:Event):void {
			if (main == null) {
				main = new Main();
				
				addChild(main);
			}
		}
	}
}