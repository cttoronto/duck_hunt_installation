package com.cttoronto.mobile.crackaquack.view
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
//	import assets.crack_start;
	
	import com.cttoronto.mobile.crackaquack.view.components.Button;
	
	public class HomeScreen extends MasterView
	{
		/*
		private var about:Button;
		private var start:Button;
		*/
		private var assets_start:mc_view_startscreen = new mc_view_startscreen();
		public function HomeScreen()
		{
			super();
			
			//this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		override protected function initLayout():void{
			addChild(assets_start);
			super.initLayout();
		}
		override protected function init():void{
			super.init();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onExit);
			stage.addEventListener(MouseEvent.MOUSE_UP, onExit);
		}
		private function onExit(e:MouseEvent = null):void{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onExit);
			TweenMax.killDelayedCallsTo(onExit);
			
			TweenMax.to(this, 0.5, {x:-stage.stageWidth, onComplete:onLoadGame});
		}
		protected function onLoadGame(event:MouseEvent = null):void
		{
			dispatchEvent(new Event("INSTRUCTIONS"));
		}
		/*
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
		*/
		override public function destroy():void {
			/*about.removeEventListener(MouseEvent.CLICK, onAbout);
			start.removeEventListener(MouseEvent.CLICK, onStart);
			*/
			
			super.destroy();			
		}
	}
}