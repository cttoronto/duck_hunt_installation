package com.cttoronto.mobile.crackaquack.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import assets.crack_start;
	
	import com.cttoronto.mobile.crackaquack.view.components.Button;
	
	public class HomeScreen extends Sprite
	{
		
		private var about:Button;
		private var start:Button;
		
		public function HomeScreen()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			var cs:crack_start = new crack_start();
			cs.x = stage.stageWidth / 2 - cs.width / 2;
			cs.y = stage.stageHeight / 2 - cs.height / 2;
			
			addChild(cs);	
			
			about = new Button("ABOUT");
			start = new Button("START GAME");
			
			about.x = 10;
			about.y = 10;
			
			start.x = 10;
			start.y = 120;
			
			addChild(about);
			addChild(start);
			
			about.addEventListener(MouseEvent.CLICK, onAbout);
			start.addEventListener(MouseEvent.CLICK, onStart);
			
		}
		
		protected function onStart(event:MouseEvent):void
		{
			dispatchEvent(new Event("START"));
		}
		
		protected function onAbout(event:MouseEvent):void
		{
			dispatchEvent(new Event("ABOUT"));
		}
		
		public function destroy():void {
			
			about.removeEventListener(MouseEvent.CLICK, onAbout);
			start.removeEventListener(MouseEvent.CLICK, onStart);
			
			this.removeChildren();
			
		}
	}
}