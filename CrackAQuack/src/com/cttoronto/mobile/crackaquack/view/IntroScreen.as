package com.cttoronto.mobile.crackaquack.view
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import com.cttoronto.mobile.crackaquack.ConfigValues;
	
	public class IntroScreen extends MasterView
	{
		private var assets_intro:mc_view_intro = new mc_view_intro();
		
		public function IntroScreen()
		{
			super();
		}
		override public function initLayout():void{
			addChild(assets_intro);
			super.initLayout();
			/*
			graphics.lineStyle(5, 0xFF0000, 0.5);
			graphics.drawRect(2,2,ConfigValues.START_SCALE.width, ConfigValues.START_SCALE.height);
			graphics.lineStyle(5, 0x00FF00, 0.5);
			graphics.drawRect(1,1,stage.fullScreenWidth-2, stage.fullScreenHeight-2);
			graphics.lineStyle(5, 0x0000FF, 0.5);
			graphics.drawRect(0,0,Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			*/
		}
		override public function init():void{
			super.init();
			TweenMax.delayedCall(5.5, onExit);
			stage.addEventListener(MouseEvent.CLICK, onExit);
		}
		private function onExit(e:MouseEvent = null):void{
			TweenMax.killDelayedCallsTo(onExit);
			
			stage.removeEventListener(MouseEvent.CLICK, onExit);
			
			TweenMax.to(this, 0.5, {x:-stage.stageWidth, onComplete:onLoadHome});
		}
		protected function onLoadHome(e:Event = null):void
		{
			dispatchEvent(new Event("HOME"));
		}
	}
}