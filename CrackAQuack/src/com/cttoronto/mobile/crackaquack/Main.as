package com.cttoronto.mobile.crackaquack
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.cttoronto.mobile.crackaquack.view.GameScreen;
	import com.cttoronto.mobile.crackaquack.view.HomeScreen;
	import com.cttoronto.mobile.crackaquack.view.IntroScreen;
	
	public class Main extends Sprite
	{
		private var homeScreen:HomeScreen;
		private var introScreen:IntroScreen;
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);	
		}
		
		private function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			showIntro();
			//showHome();
			
		}
		private function showIntro():void{
			introScreen = new IntroScreen();
			introScreen.addEventListener("HOME", onHomeLoad);
			addChild(introScreen);
		}
		private function removeIntro():void {
			introScreen.removeEventListener("HOME", onHomeLoad);
			removeChild(introScreen);
			
			introScreen.destroy();
			introScreen = null;
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
		private function onHomeLoad(e:Event):void {
			removeIntro();
			
			showHome();
		}
		private function onStartLoad(e:Event):void {
			trace("START LOAD GAMESCREEN");
			removeHome();
			
			addChild(new GameScreen());
		}
		
		private function onAboutLoad(e:Event):void {
			
		}
	}
}