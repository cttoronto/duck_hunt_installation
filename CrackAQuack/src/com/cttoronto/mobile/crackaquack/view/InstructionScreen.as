package com.cttoronto.mobile.crackaquack.view
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class InstructionScreen extends MasterView
	{
		import com.cttoronto.mobile.crackaquack.ConfigValues;
		
		private var assets_instructions:mc_view_about = new mc_view_about();
		
		public function InstructionScreen()
		{
			super();
		}
		override protected function initLayout():void{
			addChild(assets_instructions);
			super.initLayout();
		}
		override protected function init():void{
			super.init();
			assets_instructions.mc_btn_cancel.addEventListener(MouseEvent.CLICK, onCancelClick);
			assets_instructions.mc_btn_play.addEventListener(MouseEvent.CLICK, onPlayClick);
		}
		private function onCancelClick(e:MouseEvent):void{
			TweenMax.to(this, 0.5,{x:-this.width, onComplete:onExit});
		}
		private function onExit():void{
			dispatchEvent(new Event("CANCEL"));
		}
		private function onPlayClick(e:MouseEvent):void{
			dispatchEvent(new Event("START"));
		}
		override public function destroy():void{
			assets_instructions.mc_btn_cancel.removeEventListener(MouseEvent.CLICK, onCancelClick);
			assets_instructions.mc_btn_play.removeEventListener(MouseEvent.CLICK, onPlayClick);
			super.destroy();
		}
	}
}