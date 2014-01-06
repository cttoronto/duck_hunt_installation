package com.cttoronto.mobile.crackaquack.view
{
	import com.cttoronto.mobile.crackaquack.ConfigValues;
	import com.cttoronto.mobile.crackaquack.model.DataModel;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	
	public class MasterView extends Sprite
	{
		private var sizing_filler:mc_transparent_pixel = new mc_transparent_pixel();
		
		public function MasterView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		protected function initLayout():void{
//			graphics.beginFill(0x00FF00, 0);
//			graphics.drawRect(0,0,ConfigValues.START_SCALE.width, ConfigValues.START_SCALE.height);
			scaleObject();
		}
		public function get screenDimensions():Rectangle{
			//return new Point(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			return DataModel.getInstance().deviceSize;
		}
		protected function scaleObject(target:DisplayObject = null):void {
			if (target == null){
				target = this;
			}
			target.scaleX = target.scaleY = screenDimensions.width/ConfigValues.START_SCALE.width;
			if (target.scaleY*ConfigValues.START_SCALE.height > screenDimensions.height){
				target.scaleX = target.scaleY = screenDimensions.height/ConfigValues.START_SCALE.height;
				target.x = (screenDimensions.width -target.width)/2;
				target.y = 0;
			} else if (target.scaleY*ConfigValues.START_SCALE.height < screenDimensions.height){
				target.y = (screenDimensions.height/2 - (target.scaleX*ConfigValues.START_SCALE.height)/2);
			}
			return;
			target.scaleX = target.scaleY = DataModel.getInstance().appScale;
			target.x = DataModel.getInstance().appLeftOffset + (DataModel.getInstance().appSize.width / 2 - target.width / 2);
			target.y = DataModel.getInstance().appSize.height / 2 - ConfigValues.START_SCALE.height / 2;
			return;
			Capabilities.screenResolutionX/ConfigValues.START_SCALE.width;
			if (target.scaleX*ConfigValues.START_SCALE.width > Capabilities.screenResolutionY){
				target.scaleX = target.scaleY = Capabilities.screenResolutionY/ConfigValues.START_SCALE.height;
				target.x = (Capabilities.screenResolutionX -target.width)/2;
			}	
		}
		protected function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			sizing_filler.width = ConfigValues.START_SCALE.width;
			sizing_filler.height = ConfigValues.START_SCALE.height;
			addChild(sizing_filler);

			initLayout();
			init();
		}
		protected function init():void{
			
			var orig_x:Number = this.x;
			x = screenDimensions.width;
			
//			TweenMax.to(this, 0.5, {x:(stage.fullScreenWidth-ConfigValues.START_SCALE.width)/2-(ConfigValues.START_SCALE.width/stage.fullScreenWidth)});
//			x = DataModel.getInstance().appSize.width; //Capabilities.screenResolutionX;
			TweenMax.to(this, 0.5, {x:orig_x});
		}
		public function destroy():void {
			while (this.numChildren > 0) { removeChildAt(0); }
		}
	}
}