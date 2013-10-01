package com.cttoronto.mobile.crackaquack.view
{
	import com.cttoronto.mobile.crackaquack.ConfigValues;
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
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	import flash.utils.getTimer;

	public class GameScreenFly extends MasterView
	{
		private var scaleFactor:Number;
		private const APP_SIZE:Point = new Point(800, 480);
		private var accl:Accelerometer;
		private var _registered	: Boolean = false;
		public static const DEV_KEY : String = "";
		private var lastAccelX:Number = 0, lastAccelY:Number = 0, lastAccelZ:Number = 0;
		
		private var shaking:Boolean = false;
		
		private var mc_arrow:MovieClip = new MovieClip();
		private var assets_game:mc_view_game_fly = new mc_view_game_fly();
		private var _score:int  = 0;
		public function GameScreenFly()
		{
			super();
			
		}
		override protected function initLayout():void{
			addChild(assets_game);
			assets_game.graphics.beginFill(0x000000,0);
			assets_game.graphics.drawRect(0,0,ConfigValues.START_SCALE.width,ConfigValues.START_SCALE.height);
			
			super.initLayout();
		}
		private function animateFlapIndicator():void{
			assets_game.mc_flap.x = ConfigValues.START_SCALE.width/2 - 20;
			TweenMax.to(assets_game.mc_flap, 0.35, {x:ConfigValues.START_SCALE.width/2 + 20, repeat:-1, yoyo:true, ease:Circ.easeInOut});
		}
		override protected function init():void {
			setupShakeDetection();
			setupCompass();
			
			
			assets_game.mc_btn_endgame.addEventListener(MouseEvent.MOUSE_UP, onExit);
			assets_game.mc_dead_duck.visible = false;
			
			super.init();
			register(true);
			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
		}
		private function deadduck():void{
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
				/* removed ane 
				Compass.init( DEV_KEY );
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_AVAILABLE, 		compass_magneticFieldAvailableHandler, false, 0, true );
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_UNAVAILABLE, 	compass_magneticFieldUnavailableHandler, false, 0, true );
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_UPDATED, 		compass_magneticFieldUpdatedHandler, false, 0, true );
				Compass.service.addEventListener(CompassEvent.HEADING_UPDATED, onHeadingUpdated, false, 0, true );
				removed ane */
			}
			catch (e:Error)
			{
				trace( "ERROR:"+e.message );
			}
		}
		/* removed ane
		private function onHeadingUpdated(e:CompassEvent):void{
			message(String(e.magneticHeading));
			assets_game.mc_north_arrow.rotation = e.magneticHeading;
		}				
		removed ane */
		private function setupShakeDetection():void {
			
			if (Accelerometer.isSupported) {
				accl = new Accelerometer();
				accl.addEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
			}
		}
		
		private function onAccelerometer(e:AccelerometerEvent):void {
			
			if (Math.abs(e.accelerationX - lastAccelX) > 0.5 || Math.abs(e.accelerationY - lastAccelY) > 0.5  || Math.abs(e.accelerationZ - lastAccelZ) > 0.5 ) {
				shaking = true;
				
				score ++;
				assets_game.mc_duck.gotoAndPlay(2);
				TweenMax.killTweensOf(assets_game.mc_flap);
				TweenMax.to(assets_game.mc_flap, 0.5, {alpha:0});
				
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
				/* removed ane
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
				removed ane */
			}
			catch (e:Error)
			{
				message( "ERROR:"+e.message );
			}
		}
		/* removed ane
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
		
		removed ane */
		
		private function activateHandler( event:Event ):void
		{
			register(true) 	
		}
		
		
		private function deactivateHandler( event:Event ):void
		{
			register(false) 	
		}
		/* removed ane
		
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

		removed ane */
		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score = value;
			assets_game.fly_score.text = String(_score);
		}

	}
}