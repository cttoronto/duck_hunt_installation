package com.cttoronto.mobile.crackaquack.view
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import com.cttoronto.mobile.crackaquack.ConfigValues;
	
	public class MasterView extends Sprite
	{
		public function MasterView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		public function initLayout():void{
			scaleObject();
		}
		public function scaleObject(target:DisplayObject = null){
			if (target == null){
				target = this;
			}
			target.scaleX = target.scaleY = Capabilities.screenResolutionX/ConfigValues.START_SCALE.width;
			if (target.scaleX*ConfigValues.START_SCALE.width > Capabilities.screenResolutionY){
				target.scaleX = target.scaleY = Capabilities.screenResolutionY/ConfigValues.START_SCALE.height;
				target.x = (Capabilities.screenResolutionX -target.width)/2;
			}	
		}
		public function onAdded(e:Event):void {
			//this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			initLayout();
			init();
		}
		public function init():void{
			x = Capabilities.screenResolutionX;
			TweenMax.to(this, 0.5, {x:0});
		}
		public function destroy():void {			
			this.removeChildren();			
		}
	}
}