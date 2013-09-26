package com.cttoronto.mobile.crackaquack.view {
	import com.adobe.nativeExtensions.Vibration;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
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
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.cttoronto.mobile.crackaquack.ConfigValues;
	
	
	public class GameScreen extends MasterView {
		
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
		
		private var assets_game:mc_view_game = new mc_view_game();
		private var _kills:int = 0;
		
		private var _reload:Boolean = false;
		
		public function GameScreen():void {
			super();
			//this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		/*
		private function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			init();
		}
		*/
		override public function initLayout():void{
			addChild(assets_game);
			assets_game.graphics.beginFill(0x000000,0);
			assets_game.graphics.drawRect(0,0,ConfigValues.START_SCALE.width,ConfigValues.START_SCALE.height); 
			super.initLayout();
		}
		override public function init():void {
			super.init();
			
			cam = Camera.getCamera();
			vid = new Video();
			
			tformat.size = 12;
			tf.defaultTextFormat = tformat;
			tf.x = 100;
			tf.width = 400;
			tf.height = 400;
			tf.wordWrap = true;
			//tf.text = "assets_game:"+assets_game.scaleX+ assets_game.scaleY;
			vid.attachCamera(cam); 
			scaleObject(vid);
			//tf.text += "vid:",vid.scaleX+ vid.scaleY+ vid.width+ vid.height;
			vid.x=0;
			vid.y=0;
			
			vid.width = 800;//assets_game.width;
			//vid.height = 440;
			vid.scaleY = vid.scaleX;
			if (vid.height > Capabilities.screenResolutionY){
				vid.y = -(vid.height-Capabilities.screenResolutionX)/2;
				//vid.x = Capabilities.screenResolutionX - vid.width)/2;
			}
			/**/
			//TweenMax.to(vid, 10,{x:100,y:100});
			addChildAt(vid, 0);

			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			
			samplebmpd = new BitmapData(100,100,false);
			displaybmp = new Bitmap(samplebmpd);
			//addChild(displaybmp);
			
			samplematrix = new Matrix();
			accel = new Accelerometer();
			accel_val = {x:0, y:0, z:0};
			
			tf.background = true;
			tf.wordWrap = tf.multiline = true;
			
			accel.addEventListener(AccelerometerEvent.UPDATE, onAccelUpdate);
			//addChild(tf);
			for (var i = 1; i < 6; i++){ 
				assets_game["b"+i].gotoAndStop(1);
			}
			assets_game.mc_reload.visible = false;
			
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
		private function updateRounds():void{
			for (var i = 1; i < 6; i++){ 
				assets_game["b"+i].gotoAndStop(2);
			}
			for (i = 0; i < rounds; i++){
				assets_game["b"+(i+1)].gotoAndStop(1);
			}
		}
		
		private function onClick(e:MouseEvent):void{	
			//tf.text = accel_val.x + "\n" + accel_val.y + "\n" + accel_val.z + "\n";
			rounds --;
			if (accel_val.x <0.5 && accel_val.x >-0.5 &&accel_val.y <0.5 && accel_val.y >-0.5 &&accel_val.z <1.5 && accel_val.z >0.75){
				rounds = 5;
				
				updateRounds();
				reload = false;
				//tf.text = "Rounds: " + rounds + "\n";
				vibe(200);
				TweenMax.delayedCall(0.3, vibe);
				
				return
			}
			if (rounds >= 0){
				//tf.text = "Rounds: " + rounds + "\n";
				vibe(50);
			}else{
				//tf.text = "RELOAD";
				vibe(500);
				
				reload = true;
				return;
			}
			updateRounds();
			
			//vid.width = stage.stageWidth;
			//vid.height = stage.stageHeight;
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
						//tf.appendText("\nIt's a duck: "+ duckCheck.colorname);
						kills++;
					}
				}
			}
			/*
			var ret:assets.mc_reticle = new mc_reticle();
			ret.x = stage.stageWidth / 2 - ret.width / 2;
			ret.y = stage.stageHeight / 2 - ret.height / 2;
			addChild(ret);
			*/
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

		public function get kills():int
		{
			return _kills;
		}

		public function set kills(value:int):void
		{
			_kills = value;
			assets_game.kill_score.text = String(_kills);
		}

		public function get reload():Boolean
		{
			return _reload;
		}
		public function set reload(value:Boolean):void
		{
			if (value == false){
				//TweenMax.to(assets_game.mc_reload,0,{alpha:0, onComplete:reloadHide});
				TweenMax.killTweensOf(assets_game.mc_reload);
				assets_game.mc_reload.visible = false;
				assets_game.mc_reload.alpha = 1;
				assets_game.mc_reload.y = assets_game.height/2 - assets_game.mc_reload.height/2;
				assets_game.mc_reticle.visible = true;
			}else if (value == true){
				assets_game.mc_reload.visible = true;
				assets_game.mc_reload.y = assets_game.height/2 - assets_game.mc_reload.height/2;
				assets_game.mc_reticle.visible = false;
				assets_game.mc_reload.alpha = 1;
				TweenMax.from(assets_game.mc_reload,0.5,{alpha:0, y:assets_game.height/4});
			}
			_reload = value;
		}


	}
}