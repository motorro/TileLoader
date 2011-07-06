package tileloader.model
{
	import flash.events.ErrorEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.AuthResultMessage;
	import tileloader.messages.AuthenticateMessage;
	import tileloader.messages.ConfigResultMessage;
	import tileloader.messages.ExitMessage;
	import tileloader.messages.ExitMessages;
	import tileloader.messages.OrderCleanupMessage;

	/**
	 * Authentication model
	 * Holds user credentials and al
	 *  
	 * @author kochetkov
	 * 
	 */
	public class AuthenticationModel {
		
		/**
		 * @private
		 * Logger 
		 */
		private static const _logger:ILogger = LogUtils.getLoggerByClass(AuthenticationModel);

		[Bindable]
		/**
		 * Authenticated flag 
		 */
		public var authenticated:Boolean; 
		
		//TODO: Temporal order data
		/**
		 * Order token that is provided from outside 
		 */
		public var orderToken:String = "-=ORDER=-";
		
		/**
		 * Order temporary directory 
		 */
		public var orderDirectory:File;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;

		[MessageHandler(selector="configComplete")]
		/**
		 * Configuration complete handler. 
		 * Performs authentication steps on startup 
		 */
		public function onConfigComplete(message:ConfigResultMessage):void {
			if (null != _logger) {
				_logger.info("Authenticating.");
			}
			//TODO: Implement authentication
			
			//For now - just clean the folder and create new one
			sendMessage(new OrderCleanupMessage(orderToken));			
		}

		[CommandError]
		/**
		 * @private 
		 * Cleanup error
		 */
		public function onConfigError(fault:ErrorEvent, message:OrderCleanupMessage):void {
			var listener:Function = function(event:CloseEvent):void {
				if (null == event || Alert.NO == event.detail) {
					//TODO: Log output
					sendMessage(new ExitMessage(ExitMessages.DISK_OPERATION_ERROR));
					return;
				} 
			}
			
			if (null != _logger) {
				_logger.error("Configuration error: " + fault.text);
			}
			
			var rm:IResourceManager = ResourceManager.getInstance();
			
			Alert.show(rm.getString("messages", "removeFolderError", [fault.text]), rm.getString("messages", 'removeFolderErrorTitle'), Alert.YES | Alert.NO, null, listener);
		}
		
		[CommandComplete]
		/**
		 * @private 
		 * Cleanup complete handler
		 */
		public function onCleanupComplete(message:OrderCleanupMessage):void {
			if (null != _logger) {
				_logger.info("Clean");
			}
			sendMessage(new AuthResultMessage(AuthResultMessage.AUTH_REMOVED));
			authenticated = false;
			
			//Authenticate
			sendMessage(new AuthenticateMessage("-=ORDER=-"));
		}

		[CommandComplete]
		/**
		 * @private 
		 * Authenticate complete handler
		 */
		public function onAuthComplete(message:AuthenticateMessage):void {
			if (null != _logger) {
				_logger.info("Authentication complete for: " + message.order);
			}
			sendMessage(new AuthResultMessage(AuthResultMessage.AUTH_COMPLETE));
			authenticated = true;
		}
		
		[CommandError]
		/**
		 * @private 
		 * Cleanup error
		 */
		public function onAuthError(fault:ErrorEvent, message:AuthenticateMessage):void {
			var listener:Function = function(event:CloseEvent):void {
				if (null == event || Alert.NO == event.detail) {
					//TODO: Log output
					sendMessage(new ExitMessage(ExitMessages.CONFIG_ERROR));
					return;
				} 
			}
			
			if (null != _logger) {
				_logger.error("Authenticate error: " + fault.text);
			}
			
			var rm:IResourceManager = ResourceManager.getInstance();
			
			Alert.show(rm.getString("messages", "authenticationError", [fault.text]), rm.getString("messages", 'authenticationErrorTitle'), Alert.YES | Alert.NO, null, listener);
		}

		
	}
}