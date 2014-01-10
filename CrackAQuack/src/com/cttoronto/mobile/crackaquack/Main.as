package com.cttoronto.mobile.crackaquack
{
	import com.cttoronto.mobile.crackaquack.view.GameScreen;
	import com.cttoronto.mobile.crackaquack.view.GameScreenFly;
	import com.cttoronto.mobile.crackaquack.view.HomeScreen;
	import com.cttoronto.mobile.crackaquack.view.InstructionScreen;
	import com.cttoronto.mobile.crackaquack.view.IntroScreen;
	import com.cttoronto.mobile.crackaquack.view.LoginRegistrationScreen;
	import com.cttoronto.mobile.crackaquack.view.MasterView;
	import com.cultcreative.utils.Debug;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends Sprite
	{
		private var homeScreen:HomeScreen;
		private var introScreen:IntroScreen;
		private var instructionScreen:InstructionScreen;
		private var gameScreen:MasterView;
		private var loginScreen:LoginRegistrationScreen; 
		
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
			introScreen.destroy();
			removeChild(introScreen);
			
			introScreen = null;
		}
		
		private function showInstructions():void {
			instructionScreen = new InstructionScreen();
			initInstructionEvents();
			addChild(instructionScreen);
		}
		
		private function showInstructionsFly():void {
			instructionScreen = new InstructionScreen();
			instructionScreen.mode = InstructionScreen.MODE_FLY;
			initInstructionEvents();
			addChild(instructionScreen);
		}
		
		private function showInstructionsShoot():void {
			instructionScreen = new InstructionScreen();
			instructionScreen.mode = InstructionScreen.MODE_SHOOT;
			initInstructionEvents();
			addChild(instructionScreen);
		}
		
		private function initInstructionEvents():void{
			instructionScreen.addEventListener("CANCEL", onInstructionHomeLoad);
			instructionScreen.addEventListener("START", onStartLoad);
			instructionScreen.addEventListener("START_FLY", onStartLoad);
			instructionScreen.addEventListener("START_SHOOT", onStartLoad);
		}
		
		private function onInstructionHomeLoad(e:Event):void{
			removeInstructions();
			
			showHome();
		}
		
		private function removeInstructions():void {
			instructionScreen.removeEventListener("CANCEL", onInstructionHomeLoad);
			instructionScreen.removeEventListener("START", onStartLoad);
			
			instructionScreen.removeEventListener("START_FLY", onStartLoad);
			instructionScreen.removeEventListener("START_SHOOT", onStartLoad);
			
			instructionScreen.destroy();
			removeChild(instructionScreen);
			
			instructionScreen = null;
		}
		
		private function showHome():void {
			homeScreen = new HomeScreen();
			Debug.getInstance().info("SHOW HOME");
			//homeScreen.addEventListener("INSTRUCTIONS", onInstructionsLoad);
			homeScreen.addEventListener("INSTRUCTIONS_FLY", onInstructionsLoadFly);
			homeScreen.addEventListener("INSTRUCTIONS_SHOOT", onInstructionsLoadShoot);
			
			addChild(homeScreen);
		}
		
		private function removeHome():void {
			Debug.getInstance().info(homeScreen);
			if (homeScreen) {
				homeScreen.removeEventListener("INSTRUCTIONS", onInstructionsLoad);
				homeScreen.removeEventListener("INSTRUCTIONS_FLY", onInstructionsLoadFly);
				homeScreen.removeEventListener("INSTRUCTIONS_SHOOT", onInstructionsLoadShoot);
				homeScreen.destroy();
				removeChild(homeScreen);
			}
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
		private function onInstructionsLoadShoot(e:Event):void {
			removeHome();
			
			Debug.getInstance().info("ON INSTRUCTIONS LOAD SHOOT");
			
			showInstructionsShoot();
		}
		private function onInstructionsLoadFly(e:Event):void {
			removeHome();
			Debug.getInstance().info("ON INSTRUCTIONS LOAD FLY");
			
			showInstructionsFly();
		}
		
		private function onStartLoad(e:Event):void {
			
			Debug.getInstance().info("ON START LOAD");
			
			removeInstructions();
			
			if (e.type == "START_FLY"){
				gameScreen = new GameScreenFly();
			}else{
				gameScreen = new GameScreen();
			}
			
			gameScreen.addEventListener("HOME", onGameHomeLoad);
			addChild(gameScreen);
			
		}
		
		private function onGameHomeLoad(e:Event):void{
			removeGame();
			
			Debug.getInstance().info("ON GAME LOAD");
			
			showHome();
		}
		
		private function removeGame():void{
			gameScreen.removeEventListener("HOME", onGameHomeLoad)
			gameScreen.destroy();
			removeChild(gameScreen);
			gameScreen = null;
		}
		
		private function onAboutLoad(e:Event):void {
			
		}
	}
}