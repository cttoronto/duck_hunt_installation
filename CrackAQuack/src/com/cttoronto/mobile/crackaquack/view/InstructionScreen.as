package com.cttoronto.mobile.crackaquack.view
{
	import com.greensock.TweenMax;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class InstructionScreen extends MasterView
	{		
		private var assets_instructions:MovieClip;
		public static const MODE_SHOOT:String = "SHOOT";
		public static const MODE_FLY:String = "FLY";
		private var _mode:String;
		
		public function InstructionScreen()
		{
			super();
		}
		
		override protected function initLayout():void{
			if (mode == MODE_FLY){
				assets_instructions = new mc_view_fly();
			}else if (mode == MODE_SHOOT){
				assets_instructions = new mc_view_shoot();
			}else{
				assets_instructions = new mc_view_about();
			}
			addChild(assets_instructions);
			super.initLayout();
		}
		
		override protected function init():void{
			super.init();
			assets_instructions.mc_btn_cancel.addEventListener(MouseEvent.MOUSE_UP, onCancelClick);
			assets_instructions.mc_btn_play.addEventListener(MouseEvent.MOUSE_UP, onPlayClick);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_UP, onKey);
			
			if(assets_instructions.mc_game_image){
				assets_instructions.mc_game_image.addEventListener(MouseEvent.MOUSE_UP, onPlayClick);
			}
		}
		
		private function onKey(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.BACK) {
				onCancelClick(null);
			}
		}
		
		private function onCancelClick(e:MouseEvent):void{
			TweenMax.to(this, 0.5,{x:-this.width, onComplete:onExit});
		}
		
		private function onExit():void{
			
			assets_instructions.mc_btn_cancel.removeEventListener(MouseEvent.MOUSE_UP, onCancelClick);
			assets_instructions.mc_btn_play.removeEventListener(MouseEvent.MOUSE_UP, onPlayClick);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_UP, onKey);
			
			dispatchEvent(new Event("CANCEL"));
		}
		
		private function onPlayClick(e:MouseEvent):void{
			if (mode == MODE_FLY){
				dispatchEvent(new Event("START_FLY"));
			}else if (mode == MODE_SHOOT){
				dispatchEvent(new Event("START_SHOOT"));
			}else{
				dispatchEvent(new Event("START"));
			}
		}
		
		override public function destroy():void{
			assets_instructions.mc_btn_cancel.removeEventListener(MouseEvent.MOUSE_UP, onCancelClick);
			assets_instructions.mc_btn_play.removeEventListener(MouseEvent.MOUSE_UP, onPlayClick);
			super.destroy();
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function set mode(value:String):void
		{
			_mode = value;
		}

	}
}