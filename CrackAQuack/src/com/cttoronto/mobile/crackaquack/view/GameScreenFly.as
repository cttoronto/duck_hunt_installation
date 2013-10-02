package com.cttoronto.mobile.crackaquack.view
{
	import com.cttoronto.mobile.crackaquack.ConfigValues;
	import com.cttoronto.mobile.crackaquack.model.CommunicationManager;
	import com.cttoronto.mobile.crackaquack.model.DataModel;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Expo;
	
	import flash.display.MovieClip;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class GameScreenFly extends MasterView
	{
		private var scaleFactor:Number;
		private const APP_SIZE:Point = new Point(800, 480);
		private var accl:Accelerometer;
		private var _registered	: Boolean = false;
		public static const DEV_KEY : String = "";
		private var lastAccelX:Number = 0, lastAccelY:Number = 0, lastAccelZ:Number = 0;
		
		private var heading:Number = 0;
		
		private var shaking:Boolean = false;
		
		private var mc_arrow:MovieClip = new MovieClip();
		private var assets_game:mc_view_game_fly = new mc_view_game_fly();
		private var _score:int  = 0;
		private var color_fill:MovieClip = new MovieClip();
		private var score_timer:Timer = new Timer(1000);
		private var touching:Boolean = false;
//		private var color_fill_flapmessage:MovieClip = new MovieClip();
		public function GameScreenFly()
		{
			super();
			
		}
		override protected function initLayout():void{
			addChild(assets_game);
			assets_game.graphics.beginFill(0x000000,0);
			assets_game.graphics.drawRect(0,0,ConfigValues.START_SCALE.width,ConfigValues.START_SCALE.height);
			
			color_fill.graphics.beginFill(ConfigValues.PLAYER_COLOR.green, 1);
			color_fill.graphics.drawRect(0,0, ConfigValues.START_SCALE.width, ConfigValues.START_SCALE.height);
			
			assets_game.addChild(color_fill);
			
			color_fill.mask = assets_game.mc_duck;
			
			super.initLayout();
		}
		private function animateFlapIndicator():void{
			assets_game.mc_flap.x = ConfigValues.START_SCALE.width/2 - 20;
			TweenMax.to(assets_game.mc_flap, 0.35, {x:ConfigValues.START_SCALE.width/2 + 20, repeat:-1, yoyo:true, ease:Circ.easeInOut});
		}
		override protected function init():void {
			setupShakeDetection();
			/* removed ane start 
			setupCompass();
			/*end removed ane */
			
			assets_game.mc_btn_endgame.addEventListener(MouseEvent.MOUSE_UP, onExit);
			assets_game.mc_dead_duck.visible = false;
			
			super.init();
			register(true);
			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
			score_timer.addEventListener(TimerEvent.TIMER, onTimer);
			score_timer.start();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseInteraction);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseInteraction);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onMouseInteraction(e:MouseEvent):void{
			
			if (e.type == MouseEvent.MOUSE_DOWN){
				touching = true;
			}else if (e.type == MouseEvent.MOUSE_UP){
				touching = false;
			}
		}
		private function onEnterFrame(e:Event):void{
			if (touching == true){
				var dx:Number = mouseX - ConfigValues.START_SCALE.width/2;
				var dy:Number = mouseY - ConfigValues.START_SCALE.height/2;
				var angle:Number = Math.atan2(dy, dx);
				assets_game.mc_north_arrow.rotation = angle * (180 / Math.PI)+90;
				heading = angle * (180 / Math.PI)+180;
			}
		}
		private function onTimer(e:TimerEvent):void{
			score++;
		}
		private function deadduck():void{
			score_timer.stop();
			score_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			assets_game.mc_dead_duck.visible = true;
			assets_game.mc_duck.visible = assets_game.mc_flap.visible = false;
		}
		private function onExit(e:MouseEvent):void{
			assets_game.mc_btn_endgame.removeEventListener(MouseEvent.MOUSE_UP, onExit);
			TweenMax.to(this, 0.5, {x:-this.width*2});
			TweenMax.delayedCall(0.5, onDispatchHome);
		}
		private function onDispatchHome():void{
			dispatchEvent(new Event("HOME"));
		}
		private function setupCompass():void {
			try
			{
				/* removed ane start 
				Compass.init( ConfigValues.DEV_KEY );
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_AVAILABLE, 		compass_magneticFieldAvailableHandler, false, 0, true );
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_UNAVAILABLE, 	compass_magneticFieldUnavailableHandler, false, 0, true );
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_UPDATED, 		compass_magneticFieldUpdatedHandler, false, 0, true );
				Compass.service.addEventListener(CompassEvent.HEADING_UPDATED, onHeadingUpdated, false, 0, true );
				//Compass.service.addEventListener(CompassEvent.HEADING_RAW_UPDATED, onHeadingRaw);
				/*end removed ane */
			}
			catch (e:Error)
			{
				trace( "ERROR:"+e.message );
			}
		}
		/* removed ane start 
		private function onHeadingRaw(e:CompassEvent):void{
			message(String(e.magneticHeading));
			heading = e.magneticHeading;
			assets_game.mc_north_arrow.rotation = e.magneticHeading;
		}
		private function onHeadingUpdated(e:CompassEvent):void{
			message(String(e.magneticHeading));
//			assets_game.mc_north_arrow.rotation = e.magneticHeading;
		}				
		/*end removed ane */
		private function setupShakeDetection():void {
			
			if (Accelerometer.isSupported) {
				accl = new Accelerometer();
				accl.addEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
			}
		}
		
		private function onAccelerometer(e:AccelerometerEvent):void {
			
			if (Math.abs(e.accelerationX - lastAccelX) > 0.5 || Math.abs(e.accelerationY - lastAccelY) > 0.5  || Math.abs(e.accelerationZ - lastAccelZ) > 0.5 ) {
				shaking = true;
				
				//score ++;
				assets_game.mc_duck.gotoAndPlay(2);
				TweenMax.killTweensOf(assets_game.mc_flap);
				TweenMax.to(assets_game.mc_flap, 0.5, {alpha:0});
				CommunicationManager.getInstance().flyDuck(DataModel.getInstance().uid, _score, heading);
			} else {
				if (shaking == true){
					TweenMax.killTweensOf(assets_game.mc_flap);
					TweenMax.to(assets_game.mc_flap, 0.5, {alpha:1});
					animateFlapIndicator();
				}
				shaking = false;
			}
			
			lastAccelX = e.accelerationX;
			lastAccelY = e.accelerationY;
			lastAccelZ = e.accelerationZ;
		}
		
		
		private function onEnter(e:Event):void {
			//trace(shaking);
		}
		
		private function message(str:String):void {
			if (shaking) trace(str);
		}
		
		private function register( reg:Boolean ):void
		{
			try
			{
				/* removed ane start 
				if (Compass.isSupported)
				{
					if (reg && !_registered)
					{
						trace("registering" );
						Compass.service.register();
					}
					
					if (!reg && _registered)
					{
						message("unregistering");
						Compass.service.unregister();
					}
					_registered = reg;
				}
				else
				{
					message("not supported");
				}
				/*end removed ane */
			}
			catch (e:Error)
			{
				message( "ERROR:"+e.message );
			}
		}
		/* removed ane start 
		private function compass_headingUpdatedHandler( event:CompassEvent ):void
		{
			message( event.type +":"+ event.magneticHeading+":"+ event.trueHeading+":"+ event.headingAccuracy );
			//			_heading.text = String(event.magneticHeading) +"   ["+event.headingAccuracy+"]";
		}
		private function compass_headingRawUpdatedHandler( event:CompassEvent ):void
		{
			message( event.type +":"+ event.magneticHeading+":"+ event.trueHeading+":"+ event.headingAccuracy );
			//			_headingRaw.text = String(event.magneticHeading) +"   ["+event.headingAccuracy+"]";
		}
		
		/*end removed ane */
		
		private function activateHandler( event:Event ):void
		{
			register(true) 	
		}
		
		
		private function deactivateHandler( event:Event ):void
		{
			register(false) 	
		}
		/* removed ane start 
		
		private function compass_magneticFieldUpdatedHandler( event:MagneticFieldEvent ):void
		{
			//			message("x:"+ event.fieldX + " y:"+event.fieldY  +" z:"+ event.fieldZ) ;
			
		}
		
		
		private function compass_magneticFieldAvailableHandler( event:MagneticFieldEvent ):void
		{
			message( "magnetic field available" );
		}
		
		
		private function compass_magneticFieldUnavailableHandler( event:MagneticFieldEvent ):void
		{
			message( "magnetic field unavailable" );
		}

		/*end removed ane */
		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score = value;
			assets_game.fly_score.text = String(_score);
		}
		override public function destroy():void{
			score_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			super.destroy();
		}
	}
}