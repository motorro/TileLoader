package tileloader.model
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.StringUtil;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.AuthResultMessage;
	import tileloader.messages.AuthenticateMessage;
	import tileloader.messages.ExitMessage;
	import tileloader.messages.MessageCodes;

	[ResourceBundle("interface")]
	/**
	 * Authentication view presentation model
	 *  
	 * @author kochetkov
	 * 
	 */
	public class AuthenticationViewModel {
		/**
		 * @private
		 * Logger 
		 */
		private static const _logger:ILogger = LogUtils.getLoggerByClass(AuthenticationViewModel);
		
		/**
		 * @private
		 * Loader for welcome page 
		 */
		private var _welcomeLoader:URLLoader;
		
		[Inject]
		/**
		 * @private
		 * Authentication model reference 
		 */
		public var model:AuthenticationModel;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		[Bindable]
		/**
		 * @private
		 * Welcome message loaded from server 
		 */
		public var welcomeMessage:TextFlow;
		
		[Init]
		/**
		 * View initialization 
		 */
		public function init():void {
			getWelcomeText();
		}
		
		/**
		 * @private 
		 * Loads welcome text from resource file or external reference
		 */
		private function getWelcomeText():void {
			var rm:IResourceManager = ResourceManager.getInstance();
			var welcomeTextURL:XML = XML(rm.getString("interface", "msgWelcome"));
			if (null == welcomeTextURL) return;
			
			_welcomeLoader = new URLLoader();
			_welcomeLoader.addEventListener(Event.COMPLETE, onWelcomeLoadComplete);
			_welcomeLoader.load(new URLRequest(welcomeTextURL));
			
			function onWelcomeLoadComplete(event:Event):void {
				welcomeMessage = TextConverter.importToFlow(_welcomeLoader.data, TextConverter.TEXT_LAYOUT_FORMAT);
				
				//Remove loader
				_welcomeLoader.removeEventListener(Event.COMPLETE, onWelcomeLoadComplete);
				_welcomeLoader = null;
			}
		}
		
		/**
		 * Checks passed token at authorization server 
		 * @param token String token given for upload
		 */
		public function checkToken(token:String):void {
			//Check for empty string
			if (null == token || "" == StringUtil.trim(token)) return;
			
			//TODO: Checking token serverside goes here
			
			if (null != _logger) {
				_logger.info("Authenticating upload token: " + token);
			}
			
			sendMessage(new AuthenticateMessage(token));
		}
		
		[CommandComplete]
		/**
		 * @private 
		 * Authenticate complete handler
		 */
		public function onAuthComplete(message:AuthenticateMessage):void {
			if (null != _logger) {
				_logger.info("Authentication complete for: " + message.token);
			}
			sendMessage(new AuthResultMessage(AuthResultMessage.AUTH_COMPLETE));
			model.authenticated = true;
		}
		
		[CommandError]
		/**
		 * @private 
		 * Authentication error
		 */
		public function onAuthError(fault:ErrorEvent, message:AuthenticateMessage):void {
//			var listener:Function = function(event:CloseEvent):void {
//				if (null == event || Alert.NO == event.detail) {
//					//TODO: Log output
//					sendMessage(new ExitMessage(MessageCodes.CONFIG_ERROR));
//					return;
//				} else {
//					sendMessage(message);
//				}
//			}
			
			if (null != _logger) {
				_logger.error("Authenticate error: " + fault.text);
			}
			
			var rm:IResourceManager = ResourceManager.getInstance();
			
			Alert.show(rm.getString("messages", "authenticationError", [fault.text]), rm.getString("messages", 'authenticationErrorTitle'), Alert.OK, null);
		}
	}
}