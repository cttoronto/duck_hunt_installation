package
{
	import com.cttoronto.mobile.crackaquack.Main;
	import com.cttoronto.mobile.crackaquack.model.DataModel;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	[SWF(backgroundColor="#000000")]
	public class CrackAQuack extends Sprite
	{
		private var main:Main;
		public function CrackAQuack()
		{
			super();
			
			// support autoOrients
//			stage.align = StageAlign.TOP_LEFT;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			
//			var guiSize:Rectangle = new Rectangle(0,0,1024, 600);
//			var deviceSize:Rectangle = new Rectangle(0,0, Math.max(stage.fullScreenWidth, stage.fullScreenHeight), Math.min(stage.fullScreenWidth, stage.fullScreenHeight));
//			var appScale:Number = 1;
//			var appSize:Rectangle = guiSize.clone();
//			var appLeftOffset:Number = 0;
//			
//			if ((deviceSize.width / deviceSize.height) > (guiSize.width / guiSize.height)) {
//				appScale = deviceSize.height / guiSize.height;
//				appSize.width = deviceSize.width / appScale;
//				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2);
//			} else {
//				appScale = deviceSize.width / guiSize.width;
//				appSize.height = deviceSize.height / appScale;
//				appLeftOffset = 0;
//			}
////			
////			base.scale = appScale;
////			base.map.x = 0;
////			base.menus.x = appLeftOffset;
////			base.scrollRect - appSize;
//			

			DataModel.getInstance().setScaling(stage);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
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