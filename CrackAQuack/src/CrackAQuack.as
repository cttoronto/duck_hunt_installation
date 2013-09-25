package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import cttoronto.mobile.crackaquack.Main;
	
	[SWF(backgroundColor="#000000")]
	public class CrackAQuack extends Sprite
	{
		
		
		public function CrackAQuack()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
		}
		
		private function onAdded(e:Event):void {
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.addEventListener(Event.RESIZE, onResize);
			
			
		}
		
		private function onResize(e:Event):void {
			if (main == null) {
				var main:Main = new Main();
				addChild(main);
			}
		}
	}
}