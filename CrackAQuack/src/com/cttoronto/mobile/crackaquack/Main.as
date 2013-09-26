package com.cttoronto.mobile.crackaquack
{
	import com.cttoronto.mobile.crackaquack.view.GameScreen;
	import com.cttoronto.mobile.crackaquack.view.HomeScreen;
	import com.cttoronto.mobile.crackaquack.view.InstructionScreen;
	import com.cttoronto.mobile.crackaquack.view.IntroScreen;
	import com.cultcreative.utils.Debug;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends Sprite
	{
		private var homeScreen:HomeScreen;
		private var introScreen:IntroScreen;
		private var instructionScreen:InstructionScreen;
		private var gameScreen:GameScreen;
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			showIntro();
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
		
		private function showInstructions():void {
			instructionScreen = new InstructionScreen();
			instructionScreen.addEventListener("CANCEL", onInstructionHomeLoad);
			instructionScreen.addEventListener("START", onStartLoad);
			addChild(instructionScreen);
		}
		private function onInstructionHomeLoad(e:Event):void{
			removeInstructions();
			
			showHome();
		}
		private function removeInstructions():void {
			instructionScreen.removeEventListener("CANCEL", onInstructionHomeLoad);
			instructionScreen.removeEventListener("START", onStartLoad);
			removeChild(instructionScreen);
			
			instructionScreen.destroy();
			instructionScreen = null;
		}
		private function showHome():void {
			homeScreen = new HomeScreen();
			homeScreen.addEventListener("INSTRUCTIONS", onInstructionsLoad);
			
			addChild(homeScreen);
		}
		
		private function removeHome():void {
			homeScreen.removeEventListener("INSTRUCTIONS", onInstructionsLoad);
			removeChild(homeScreen);
			
			homeScreen.destroy();
			homeScreen = null;
		}
		private function onHomeLoad(e:Event):void {
			removeIntro();
			
			showHome();
		}
		private function onInstructionsLoad(e:Event):void {
			removeHome();
			
			showInstructions();
		}
		private function onStartLoad(e:Event):void {
			removeInstructions();
			gameScreen = new GameScreen();
			gameScreen.addEventListener("HOME", onGameHomeLoad);
			addChild(gameScreen);
		}
		private function onGameHomeLoad(e:Event):void{
			removeGame();
			
			showHome();
		}
		private function removeGame():void{
			gameScreen.removeEventListener("HOME", onGameHomeLoad)
			removeChild(gameScreen);
			
			gameScreen.destroy();
			gameScreen = null;
		}
		private function onAboutLoad(e:Event):void {
			
		}
	}
}