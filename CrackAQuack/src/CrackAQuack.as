package
{
	import com.cttoronto.mobile.crackaquack.Main;
	import com.cttoronto.mobile.crackaquack.model.CommunicationManager;
	import com.cttoronto.mobile.crackaquack.model.DataModel;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(backgroundColor="#000000")]
	public class CrackAQuack extends Sprite
	{
		private var main:Main;
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
		
		private function handleDeactivate(e:Event):void {
			CommunicationManager.getInstance().leaveRoom(DataModel.getInstance().uid);
		}
		
		private function onAdded(e:Event):void {
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
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