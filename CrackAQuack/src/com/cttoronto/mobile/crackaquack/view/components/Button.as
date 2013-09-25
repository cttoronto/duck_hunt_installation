package com.cttoronto.mobile.crackaquack.view.components
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Button extends Sprite
	{
		
		private var label:String;
		private var w:Number;
		private var h:Number;
		
		private var rad:Number = 8;
		
		public function Button(ARG_label:String, ARG_w:Number = 0, ARG_h:Number = 0)
		{
			super();
			
			label = ARG_label;
			w = (ARG_w == 0) ? 300 : ARG_w;
			h = (ARG_h == 0) ? 40 : ARG_h;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void {
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			var format:TextFormat = new TextFormat("Arial", 18, 0xffffff, true);
			format.align = TextFormatAlign.CENTER;
			var tf:TextField = new TextField();
			tf.defaultTextFormat = format;
			
			tf.text = label;
			tf.width = w;
			tf.height = tf.textHeight + 4;
			tf.mouseEnabled = false;
			tf.y = h / 2 - tf.height / 2;
			
			var bg:Shape = new Shape();
			bg.graphics.lineStyle(2, 0xffffff);
			bg.graphics.beginFill(0x0078b4);
			bg.graphics.drawRoundRect(0,0,w, h, rad, rad);
			bg.graphics.endFill();
			addChild(bg);
			
			addChild(tf);
			
		}
	}
}