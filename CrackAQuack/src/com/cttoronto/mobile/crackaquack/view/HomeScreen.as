package com.cttoronto.mobile.crackaquack.view
{
	import com.cttoronto.mobile.crackaquack.view.components.Button;
	import com.cttoronto.mobile.crackaquack.view.components.LoginRegistration;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class HomeScreen extends MasterView
	{
		/*
		private var about:Button;
		private var start:Button;
		*/
		private var assets_start:mc_view_startscreen = new mc_view_startscreen();
		
		private var view_login:LoginRegistration;
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
			assets_start.mc_btn_shoot.addEventListener(MouseEvent.MOUSE_UP, onShoot);
			assets_start.mc_btn_fly.addEventListener(MouseEvent.MOUSE_UP, onFly);
			
			view_login = new LoginRegistration();
			addChild(view_login);
			
//			assets_start.mc_login_lightbox.tracer();
//			assets_start.mc_login_lightbox.visible = false;
			
			//stage.removeEventListener(MouseEvent.MOUSE_UP, onExit);
			//stage.addEventListener(MouseEvent.MOUSE_UP, onExit);
		}
		private function onShoot(e:MouseEvent):void{
			assets_start.mc_btn_shoot.removeEventListener(MouseEvent.MOUSE_UP, onShoot);
			TweenMax.to(this, 0.5, {x:-stage.stageWidth, onComplete:onLoadShoot});
		}
		private function onFly(e:MouseEvent):void{
			assets_start.mc_btn_fly.removeEventListener(MouseEvent.MOUSE_UP, onFly);
			TweenMax.killDelayedCallsTo(onExit);
			TweenMax.to(this, 0.5, {x:-stage.stageWidth, onComplete:onLoadFly});
		}
		private function onLoadFly(e:Event = null):void{
			dispatchEvent(new Event("INSTRUCTIONS_FLY"));			
		}
		private function onLoadShoot(e:Event = null):void{
			dispatchEvent(new Event("INSTRUCTIONS_SHOOT"));
		}
		private function onExit(e:MouseEvent = null):void{
			//stage.removeEventListener(MouseEvent.MOUSE_UP, onExit);
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