package com.cttoronto.mobile.crackaquack.view {
	import com.adobe.nativeExtensions.Vibration;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import assets.mc_reticle;
	
	public class GameScreen extends Sprite {
		
		private var cam:Camera
		private var vid:Video; 
		private var tf:TextField = new TextField();
		private var tformat:TextFormat = new TextFormat();
		
		private var rounds:Number = 5;
		private var samplematrix:Matrix = new Matrix();
		private var samplepixel:Object;
		private var accel:Accelerometer = new Accelerometer();
		private var accel_val:Object = {x:0, y:0, z:0};
		
		private var samplebmpd:BitmapData;
		private var displaybmp:Bitmap;
		
		public function GameScreen():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			init();
		}
		
		private function init():void {
			cam = Camera.getCamera();
			vid = new Video();
			
			tformat.size = 64;
			tf.defaultTextFormat = tformat;
			tf.x = 100;
			tf.width = 400;
			tf.height = 400;
			
			vid.attachCamera(cam); 
			addChild(vid);
			
			/*
			var mc_reticle:MovieClip = new MovieClip();
			mc_reticle.graphics.lineStyle(2,0xFF0000);
			mc_reticle.graphics.drawCircle(stage.stageWidth/2,stage.stageHeight/2,50);
			addChild(mc_reticle);
			*/
			addEventListener(Event.ENTER_FRAME, loop);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			samplebmpd = new BitmapData(100,100,false);
			displaybmp = new Bitmap(samplebmpd);
			addChild(displaybmp);
			
			samplematrix = new Matrix();
			accel = new Accelerometer();
			accel_val = {x:0, y:0, z:0};
			
			tf.background = true;
			tf.wordWrap = tf.multiline = true;
			
			accel.addEventListener(AccelerometerEvent.UPDATE, onAccelUpdate);
			addChild(tf);
		}
		
		private function onAccelUpdate(e:AccelerometerEvent):void{
			accel_val.x = Math.floor(e.accelerationX*100)/100;
			accel_val.y = Math.floor(e.accelerationY*100)/100;
			accel_val.z = Math.floor(e.accelerationZ*100)/100;
		}
		
		private function hexToRGB(hex:Number):Object
		{
			var rgbObj:Object = {
				r: ((hex & 0xFF0000) >> 16),
				g: ((hex & 0x00FF00) >> 8),
				b: ((hex & 0x0000FF))
			};
			
			return rgbObj;
		}
		
		
		private function vibe(t:Number = 100):void{
			var vibe:Vibration;
			if (Vibration.isSupported) {
				vibe = new Vibration();
				vibe.vibrate(t);
			}
		}
		
		private function onClick(e:MouseEvent):void{	
			//tf.text = accel_val.x + "\n" + accel_val.y + "\n" + accel_val.z + "\n";
			rounds --;
			if (accel_val.x <0.5 && accel_val.x >-0.5 &&accel_val.y <0.5 && accel_val.y >-0.5 &&accel_val.z <1.5 && accel_val.z >0.75){
				rounds = 5;
				tf.text = "Rounds: " + rounds + "\n";
				vibe(200);
				TweenMax.delayedCall(0.3, vibe);
				
				return
			}
			if (rounds >= 0){
				tf.text = "Rounds: " + rounds + "\n";
				vibe(50);
			}else{
				tf.text = "RELOAD";
				vibe(500);
				return;
			}
			
			
			vid.width = stage.stageWidth;
			vid.height = stage.stageHeight;
			//vid.x = stage.stageWidth/2;
			//vid.y = stage.stageHeight/2;
			
			samplematrix.tx = -(cam.width-50);
			samplematrix.ty = -(cam.height-50);
			
			samplebmpd.draw(vid, samplematrix);
			samplepixel = hexToRGB(samplebmpd.getPixel(50, 50));
			
			//tf.text += samplepixel.r + " " + samplepixel.g + " " + samplepixel.b;
			
			var k_tolerance:Number = 102;
			
			if (samplepixel.r < k_tolerance && samplepixel.g < k_tolerance && samplepixel.b < k_tolerance){
				//sample pixel is black or dark
				var duckCheck:Object;
				samplepixel = hexToRGB(samplebmpd.getPixel(75, 25));
				duckCheck = checkTargColor(samplepixel)
				if (duckCheck.hit){
					//tf.appendText("\n"+samplepixel.r + " " + samplepixel.g + " " + samplepixel.b);
					duckCheck = checkTargColor(samplepixel)
					if (duckCheck.hit){
						samplepixel = hexToRGB(samplebmpd.getPixel(99, 0));
						//tf.appendText("\n"+samplepixel.r + " " + samplepixel.g + " " + samplepixel.b);
						tf.appendText("\nIt's a duck: "+ duckCheck.colorname);			
					}
				}
			}
			var ret:assets.mc_reticle = new mc_reticle();
			ret.x = stage.stageWidth / 2 - ret.width / 2;
			ret.y = stage.stageHeight / 2 - ret.height / 2;
			addChild(ret);
			//	vid.x = mouseX;
			//	vid.y = mouseY;
			//	tf.text += "\n" + stage.stageWidth + " " + stage.stageHeight + " " + vid.width + " " + vid.height+ " " + mouseX + " " + mouseY;
		}
		private function checkTargColor(samplepixel:Object):Object{
			if (samplepixel.r >180 && samplepixel.g < 153 && samplepixel.b >180){
				return {hit:true, color:0xFF00FF, colorname:"Magenta"};
			} else if (samplepixel.r >180 && samplepixel.g > 180 && samplepixel.b <153 ){
				return {hit:true, color:0xFFFF00, colorname:"Yellow"};
			}else if (samplepixel.r >180 && samplepixel.g < 154 && samplepixel.b <153 ){
				return {hit:true, color:0xFF0000, colorname:"Red"};
			}else if (samplepixel.r <153 && samplepixel.g > 180 && samplepixel.b <153 ){
				return {hit:true, color:0x00FF00, colorname:"Green"};
			}
			return {hit:false};
		}
		private function loop(e:Event):void{
		}
	}
}