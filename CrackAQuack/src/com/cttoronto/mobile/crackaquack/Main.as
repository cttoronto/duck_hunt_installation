package com.cttoronto.mobile.crackaquack
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.cttoronto.mobile.crackaquack.view.GameScreen;
	import com.cttoronto.mobile.crackaquack.view.HomeScreen;
	
	public class Main extends Sprite
	{
		private var homeScreen:HomeScreen;
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);	
		}
		
		private function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			showHome();
			
		}
		
		private function showHome():void {
			homeScreen = new HomeScreen();
			homeScreen.addEventListener("ABOUT", onAboutLoad);
			homeScreen.addEventListener("START", onStartLoad);
			addChild(homeScreen);
		}
		
		private function removeHome():void {
			homeScreen.removeEventListener("ABOUT", onAboutLoad);
			homeScreen.removeEventListener("START", onStartLoad);
			removeChild(homeScreen);
			
			homeScreen.destroy();
			homeScreen = null;
		}
		
		private function onStartLoad(e:Event):void {
			removeHome();
			
			addChild(new GameScreen());
		}
		
		private function onAboutLoad(e:Event):void {
			
		}
	}
}