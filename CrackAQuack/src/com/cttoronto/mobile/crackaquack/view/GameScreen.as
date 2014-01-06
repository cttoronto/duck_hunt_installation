package com.cttoronto.mobile.crackaquack.view {
	//* 
	import com.adobe.nativeExtensions.Vibration;
	import com.cttoronto.mobile.crackaquack.ConfigValues;
	import com.cttoronto.mobile.crackaquack.model.CommunicationManager;
	import com.cttoronto.mobile.crackaquack.model.DataModel;
	import com.greensock.TweenMax;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.sensors.Accelerometer;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
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
		private var hitbmpd:BitmapData;
		
		private var assets_game:mc_view_game = new mc_view_game();
		private var _kills:int = 0;
		
		private var _reload:Boolean = false;
		private var sound_gun:audio_gunfire = new audio_gunfire();
		private var sound_reload:audio_reload = new audio_reload();
		
//		private var mc_mask_vid:MovieClip = new MovieClip();
//		private var mc_mask_game:MovieClip = new MovieClip();
		
		private var _videoScale:Number = 1;
		
		private var zoom_slider:MovieClip;
		
		private var zoom_drag:Boolean = false;
		
		private var zoom_hit:mc_transparent_pixel = new mc_transparent_pixel();
		
		private var zoom_percent_max:Number = 1.75;
		private var zoom_percent_min:Number = 0.75;
		
		private var vid_startScale:Number = 2.5;
		
		private var vid_parent:MovieClip = new MovieClip();
		
		public function GameScreen():void {
			super();
		}
		override protected function initLayout():void{
			addChild(assets_game);
			
			for (var i:Number = 0; i < assets_game.numChildren; i ++){
				assets_game.getChildAt(i);
				assets_game.cacheAsBitmap = true;
			}
			
			var size_filler:mc_transparent_pixel = new mc_transparent_pixel();
			var mask_filler:mc_transparent_pixel = new mc_transparent_pixel();
			var mask_filler_vid:mc_transparent_pixel = new mc_transparent_pixel();
//			addChild(size_filler);
//			
			mask_filler_vid.width = mask_filler.width = size_filler.width = ConfigValues.START_SCALE.width;
			mask_filler_vid.height = mask_filler.height = size_filler.height = ConfigValues.START_SCALE.height;
			
			assets_game.addChild(size_filler);
//			assets_game.graphics.beginFill(0x000000,0);
//			assets_game.graphics.drawRect(0,0,ConfigValues.START_SCALE.width,ConfigValues.START_SCALE.height);
			
//			mc_mask_game.graphics.beginFill(0x00FF00, 0);
//			mc_mask_game.graphics.drawRect(0,0,ConfigValues.START_SCALE.width, ConfigValues.START_SCALE.height);
			addChild(mask_filler);
			assets_game.mask = mask_filler;
			
//			mc_mask_vid.graphics.beginFill(0x00FF00, 0);
//			mc_mask_vid.graphics.drawRect(0,0,ConfigValues.START_SCALE.width, ConfigValues.START_SCALE.height);
			
			vid = new Video();
			vid_parent.addChild(mask_filler_vid);
//			vid.mask = mc_mask_vid;
			vid_parent.addChild(vid);
			zoom_slider = assets_game.mc_zoom_indicator;
			
			assets_game.mc_duck_calibration.visible = false;
			
			super.initLayout();
			
		}
		override protected function init():void {
			super.init();
			cam = Camera.getCamera();
			if (DataModel.getDevice().indexOf("cyanogen") > -1){
				cam.setMode(480,360,24);
			}else{
				cam.setMode(640,480,24);
			}
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
			videoScale = vid.scaleX;
			vid_startScale = vid.scaleX;
			
			addChildAt(vid_parent, 0);

			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.MOUSE_UP, onClick);
			
			samplebmpd = new BitmapData(100,100,false);
			hitbmpd = new BitmapData(50,50,false);
			displaybmp = new Bitmap(samplebmpd);
//			addChild(displaybmp);
			
			accel = new Accelerometer();
			accel_val = {x:0, y:0, z:0};
			
			tf.background = true;
			tf.wordWrap = tf.multiline = true;
			
			accel.addEventListener(AccelerometerEvent.UPDATE, onAccelUpdate);
//			addChild(tf);
			for (var i:Number = 1; i < 6; i++){ 
				assets_game["b"+i].gotoAndStop(1);
			}
			assets_game.mc_reload.visible = false;
			
			assets_game.mc_btn_endgame.addEventListener(MouseEvent.MOUSE_UP, onExit);
			
			if (!Accelerometer.isSupported){
				assets_game.mc_reload.addEventListener(MouseEvent.MOUSE_UP, reloadRounds);
			}
			//zoom_slider.x = this.width - zoom_slider.width;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onZoomMouseInteraction);
			zoom_hit.addEventListener(MouseEvent.MOUSE_DOWN, onZoomMouseInteraction);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_OUT, onZoomMouseInteraction);
			
			zoom_hit.width = ConfigValues.START_SCALE.width;
			zoom_hit.height = ConfigValues.START_SCALE.height;
//			zoom_hit.graphics.beginFill(0x00FF00,0);
//			zoom_hit.graphics.drawRect(0,0,zoom_slider.width, ConfigValues.START_SCALE.height);
			assets_game.addChild(zoom_hit);
			zoom_hit.x = zoom_slider.x;
			
			assets_game.addChild(assets_game.mc_reload);
			assets_game.addChild(assets_game.mc_btn_endgame);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 0, true);
			
		}
		
		private function onKey(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.BACK) {
				e.preventDefault();
				e.stopImmediatePropagation();
				this.onExit(null);
			}
		}
		
		private function onZoomMouseInteraction(e:MouseEvent):void{
			if (e.type == MouseEvent.MOUSE_UP || e.type == MouseEvent.MOUSE_OUT){
				zoom_drag = false;
				 
				assets_game.mc_duck_calibration.visible = false;
				assets_game.mc_reticle.visible = true;
//				zoom_slider.stopDrag();
			}else if (e.type == MouseEvent.MOUSE_DOWN){
				zoom_drag = true;
				
				assets_game.mc_reticle.visible = false;
				assets_game.mc_duck_calibration.visible = true;
				onMouseMove();
			//	zoom_slider.startDrag(false, new Rectangle(zoom_slider.x,0,zoom_slider.x, this.height));
			}
		}
		private function onMouseMove(e:MouseEvent = null):void{
			if (zoom_drag == true){
				var local_height:Number = (zoom_slider.localToGlobal(new Point(0,zoom_slider.y + zoom_slider.height)).y - zoom_slider.localToGlobal(new Point(0,zoom_slider.y)).y)/2;
				zoom_slider.y = globalToLocal(new Point(0,stage.mouseY)).y - 5;
				
				var amt_scale:Number = (zoom_hit.height - zoom_slider.y)/zoom_hit.height;
				
				amt_scale = Math.floor((zoom_percent_min+amt_scale*(zoom_percent_max - zoom_percent_min))*100)/100;
				
				zoom_slider.text.text = (amt_scale*100)+"%";
				vid.scaleX = vid.scaleY = vid_startScale * amt_scale;
				
				var local_offset:Point = this.localToGlobal(new Point(vid.width, vid.height));
				local_offset = this.globalToLocal(local_offset);
//				vid.x = ((this.scaleX * ConfigValues.START_SCALE.width) - local_offset.x)/2;
//				vid.y = ((this.scaleY * ConfigValues.START_SCALE.height) - local_offset.y)/2;
				vid.x = ConfigValues.START_SCALE.width/2 - vid.width/2;
				vid.y = ConfigValues.START_SCALE.height/2 - vid.height/2;
			}
		}
		private function onExit(e:MouseEvent):void{
			assets_game.mc_btn_endgame.removeEventListener(MouseEvent.MOUSE_UP, onExit);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onClick);
			TweenMax.to(this, 0.5, {x:-this.width*2});
			TweenMax.delayedCall(0.5, onDispatchHome);
			
			CommunicationManager.getInstance().leaveRoom(DataModel.getInstance().uid);
		}
		
		private function onDispatchHome():void{
			dispatchEvent(new Event("HOME"));
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
			//* removed ane start 
			var vibe:Vibration;
			if (Vibration.isSupported) {
				vibe = new Vibration();
				vibe.vibrate(t);
			}
			/*end removed ane */
		}
		private function updateRounds():void{
			for (var i:Number = 1; i < 6; i++){ 
				assets_game["b"+i].gotoAndStop(2);
			}
			for (i = 0; i < rounds; i++){
				assets_game["b"+(i+1)].gotoAndStop(1);
			}
		}
		private function reloadRounds(e:Event = null):void{
			rounds = 5;
			
			sound_reload.play(0);
			
			updateRounds();
			reload = false;
			//tf.text = "Rounds: " + rounds + "\n";
			vibe(200);
			TweenMax.delayedCall(0.3, vibe);
		}
		private function onClick(e:MouseEvent):void{	
			
			rounds --;
			
			if (accel_val.x <0.5 && accel_val.x >-0.5 &&accel_val.y <0.5 && accel_val.y >-0.5 &&accel_val.z <1.5 && accel_val.z >0.75){
				reloadRounds()
				
				return
			}
			
			if (rounds >= 0){
				//tf.text = "Rounds: " + rounds + "\n";
				sound_gun.play(0);
				vibe(50);
			}else{
				//tf.text = "RELOAD";
				vibe(500);
				
				reload = true;
				return;
			}
			updateRounds();
			/*
			vid.scaleX *= 1.1;
			vid.scaleY = vid.scaleX;
			*/
			//vid.width = stage.stageWidth;
			//vid.height = stage.stageHeight;
			//vid.x = stage.stageWidth/2;
			//vid.y = stage.stageHeight/2;
			
			//samplematrix.tx = -(cam.width-50);
			//samplematrix.ty = -(cam.height-50);
			samplematrix = new Matrix();
			//samplematrix.scale(vid.scaleX, vid.scaleY);
			samplematrix.tx = -(ConfigValues.START_SCALE.width/2-50);
			samplematrix.ty = -(ConfigValues.START_SCALE.height/2-50);
//			vid.mask = null;
			
			
			// draw the center of the screen to the hitbitmap
//			hitbmpd.draw(cropBitmap(vid_parent, -(vid_parent.width / 2) - 25, -(vid_parent.height / 2) - 25, 50, 50));
			
			
			samplebmpd.draw(vid_parent,samplematrix);
//			vid.mask = mc_mask_vid;
			samplepixel = hexToRGB(samplebmpd.getPixel(50, 50));
			
			//tf.text += samplepixel.r + " " + samplepixel.g + " " + samplepixel.b;
			
			var k_tolerance:Number = 102;
			
//			 check the center 
//			samplepixel = hexToRGB(samplebmpd.getPixel(50,25));
			duckCheck = checkTargColor(samplepixel)
			//				trace(duckCheck.colorname);
			if (duckCheck.hit){
				//tf.appendText("\n"+samplepixel.r + " " + samplepixel.g + " " + samplepixel.b);
				duckCheck = checkTargColor(samplepixel)
				if (duckCheck.hit){
//					samplepixel = hexToRGB(samplebmpd.getPixel(50, 0));
					//tf.appendText("\n"+samplepixel.r + " " + samplepixel.g + " " + samplepixel.b);
					//tf.appendText("\nIt's a duck: "+ duckCheck.colorname);
					kills++;
					
					CommunicationManager.getInstance().hit(DataModel.getInstance().uid, duckCheck.colorname);
					return;
				}
			}
			
			return;
			
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
							
						CommunicationManager.getInstance().hit(DataModel.getInstance().uid, duckCheck.colorname);
						return;
					}
				}
				
				samplepixel = hexToRGB(samplebmpd.getPixel(50,25));
				duckCheck = checkTargColor(samplepixel)
//				trace(duckCheck.colorname);
				if (duckCheck.hit){
					//tf.appendText("\n"+samplepixel.r + " " + samplepixel.g + " " + samplepixel.b);
					duckCheck = checkTargColor(samplepixel)
					if (duckCheck.hit){
						samplepixel = hexToRGB(samplebmpd.getPixel(50, 0));
						//tf.appendText("\n"+samplepixel.r + " " + samplepixel.g + " " + samplepixel.b);
						//tf.appendText("\nIt's a duck: "+ duckCheck.colorname);
						kills++;
						
						CommunicationManager.getInstance().hit(DataModel.getInstance().uid, duckCheck.colorname);
						return;
					}
				}
				
				samplepixel = hexToRGB(samplebmpd.getPixel(75, 50));
				duckCheck = checkTargColor(samplepixel);
				trace(duckCheck.colorname);
				if (duckCheck.hit){
					//tf.appendText("\n"+samplepixel.r + " " + samplepixel.g + " " + samplepixel.b);
					duckCheck = checkTargColor(samplepixel)
					if (duckCheck.hit){
						samplepixel = hexToRGB(samplebmpd.getPixel(99, 50));
						//tf.appendText("\n"+samplepixel.r + " " + samplepixel.g + " " + samplepixel.b);
						//tf.appendText("\nIt's a duck: "+ duckCheck.colorname);
						kills++;
						
						CommunicationManager.getInstance().hit(DataModel.getInstance().uid, duckCheck.colorname);
						return;
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
		
		/**
		 * cropBitmap
		 * @ARG_object   the display object to crop
		 * @ARG_x        the horizontal amount to shift the crop (0 = no shift)
		 * @ARG_y        the vertical amount to shift the crop (0 = no shift)
		 * @ARG_width    width to crop to
		 * @ARG_height   height to crop to
		 **/
		private function cropBitmap( ARG_object:DisplayObject, ARG_x:Number, ARG_y:Number, ARG_width:Number, ARG_height:Number):Bitmap {
			// create a rectangle of the specific crop size
			var cropArea:Rectangle = new Rectangle(0, 0, ARG_width, ARG_height);
			// create a BitmapData object the size of the crop
			var bmpd:BitmapData = new BitmapData(ARG_width, ARG_height);
			// create the cropped Bitmap object from the bitmap data
			var croppedBitmap:Bitmap = new Bitmap(bmpd, PixelSnapping.ALWAYS, true);
			// create the matrix that will shift the crop from 0,0
			var cropMatrix:Matrix = new Matrix();
			cropMatrix.translate(-ARG_x, -ARG_y);
			// draw the supplied object, cropping to the cropArea with the cropMatrix offseting the result
			bmpd.draw( ARG_object, cropMatrix, null, null, cropArea, true );
			return croppedBitmap; // return the cropped bitmap
		}
		private function checkTargColor(samplepixel:Object):Object{
			
			var highTolerance:Number = DataModel.getInstance().toleranceHigh;
			var lowTolerance:Number = DataModel.getInstance().toleranceLow;
			
			if (samplepixel.r > highTolerance && samplepixel.g < lowTolerance&& samplepixel.b >highTolerance){
				return {hit:true, color:0xFF00FF, colorname:"magenta"};
			} else if (samplepixel.r >highTolerance&& samplepixel.g > highTolerance&& samplepixel.b <lowTolerance){
				return {hit:true, color:0xFFFF00, colorname:"yellow"};
			}else if (samplepixel.r >highTolerance&& samplepixel.g < lowTolerance&& samplepixel.b <lowTolerance){
				return {hit:true, color:0xFF0000, colorname:"red"};
			}else if (samplepixel.r <lowTolerance&& samplepixel.g > highTolerance && samplepixel.b < lowTolerance){
				return {hit:true, color:0x00FF00, colorname:"green"};
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
		override public function destroy():void{
			super.destroy();
		}

		public function get videoScale():Number
		{
			return _videoScale;
		}

		public function set videoScale(value:Number):void
		{
			vid.scaleY = vid.scaleX = value;
			vid.x = 0;
			vid.y = 0;
			//video left and bottom point
			var vid_dimensions:Point = this.localToGlobal(new Point(vid.width,vid.height));
			/*
			if (vid_dimensions.x > Capabilities.screenResolutionX){
				var offset_x:Number = this.globalToLocal(new Point((vid_dimensions.x-Capabilities.screenResolutionX)/2, (vid_dimensions.y-Capabilities.screenResolutionY)/2)).x;
				vid.x = offset_x;
				addChild(tf);
				tf.text = String(offset_x) + " " + String(vid.x) + " " +  String(Capabilities.screenResolutionX) + " " + String(vid_dimensions.x);
			}
			*/
			if (vid_dimensions.y > Capabilities.screenResolutionY){
				var offset_y:Number = -this.globalToLocal(new Point((vid_dimensions.x-Capabilities.screenResolutionX)/2, (vid_dimensions.y-Capabilities.screenResolutionY)/2)).y;
				vid.y = offset_y;
			}
			_videoScale = value;
		}

	}
}