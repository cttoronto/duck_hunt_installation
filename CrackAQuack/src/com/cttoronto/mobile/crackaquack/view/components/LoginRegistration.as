package com.cttoronto.mobile.crackaquack.view.components
{
	import com.cttoronto.mobile.crackaquack.model.CommunicationManager;
	import com.cttoronto.mobile.crackaquack.model.DataModel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LoginRegistration extends MovieClip
	{
		private var assets_login:mc_login_lightboxes;
		private var type:String;
		
		public function LoginRegistration(ARG_type:String)
		{
			type = ARG_type;
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		private function onAdded(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			assets_login = new mc_login_lightboxes();
			addChild(assets_login);
			
//			assets_login.mc_btn_register.addEventListener(MouseEvent.MOUSE_UP, onRegister);
			assets_login.mc_btn_login.addEventListener(MouseEvent.MOUSE_UP, onLogin);
			
			show_dialogue = false;
			
			assets_login.mc_login_bg.addEventListener(MouseEvent.MOUSE_UP, onClickDialogue);
			
			login_success = true;
		}
		private function onClickDialogue(e:MouseEvent):void{
			show_dialogue = false;
		}
		private function onRegister(e:Event):void{
//			destroy();	
		}
		private function onLogin(e:Event):void{
//			destroy();
			DataModel.getInstance().addEventListener("LOGIN_COMPLETE", onLoginComplete);
			DataModel.getInstance().addEventListener("LOGIN_ERROR", onLoginError);
			CommunicationManager.getInstance().login(assets_login.tf_username.text, type); 
		}
		
		private function onLoginComplete(e:Event):void {
			login_success(true);
		}
		
		private function onLoginError(e:Event):void {
			login_success(false);
		}
		
		private function destroy():void{
			
		}
		private function onClickLoginSuccessDialogue(e:MouseEvent):void{
			this.visible = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function set registration_success($success:Boolean):void{
			show_dialogue = true;
			
			if ($success == true){
				show_registration_success = true;
			}else if ($success == false){
				show_registration_failure = true;
			}
		}
		
		private function set login_success($success:Boolean):void{
			show_dialogue = true;
			
			if ($success == true){
				show_login_success = true;
				assets_login.mc_login_bg.removeEventListener(MouseEvent.MOUSE_UP, onClickDialogue);
				assets_login.mc_login_bg.addEventListener(MouseEvent.MOUSE_UP, onClickLoginSuccessDialogue);
				dispatchEvent(new Event(Event.COMPLETE));
			}else if ($success == false){
				show_login_failure = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private function set show_dialogue($show:Boolean):void{
			assets_login.mc_login_bg.visible = $show;
			if ($show == false){
				show_usernametaken = show_noducks = show_login_success = show_login_failure = show_registration_failure = show_registration_success = false;
			}
		}
		private function set show_registration_success($show:Boolean):void{
			assets_login.mc_dialogue_reg_correct.visible = $show;
		}
		private function set show_registration_failure($show:Boolean):void{
			assets_login.mc_dialogue_reg_incorrect.visible = $show;
		}
		private function set show_login_success($show:Boolean):void{
			assets_login.mc_dialogue_correct.visible = $show;
		}
		private function set show_login_failure($show:Boolean):void{
			assets_login.mc_dialogue_incorrect.visible = $show;
		}
		private function set show_usernametaken($show:Boolean):void{
			assets_login.mc_dialogue_usernametaken.visible = $show;
		}
		private function set show_noducks($show:Boolean):void{
			assets_login.mc_dialogue_noducks.visible = $show;
		}
	}
}