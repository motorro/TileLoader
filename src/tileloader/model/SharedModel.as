package tileloader.model
{
	import flash.events.ErrorEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.ConfigMessage;
	import tileloader.messages.ExitMessage;
	import tileloader.messages.ExitMessages;

	[ResourceBundle("messages")]
	/**
	 * Global application data model
	 *  
	 * @author kochetkov
	 * 
	 */
	public class SharedModel {
		
		/**
		 * @private
		 * Logger 
		 */
		private static const _logger:ILogger = LogUtils.getLoggerByClass(SharedModel);

		[Bindable]
		/**
		 * Initialization flag 
		 */
		public var initialized:Boolean;
		
		/**
		 * Application configuration 
		 */
		public var applicationConfig:ApplicationConfig;
		
		//Logging
		/**
		 * Maximum number of strings in log file 
		 */
		public static const MAX_LOG_MESSAGE_COUNT:int = 1000;
		
		[Bindable]
		/**
		 * Application log
		 */
		public var applicationLog:Vector.<String>;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		[Init]
		public function init():void {
			initialized = false;

			//Load configuration
			sendMessage(new ConfigMessage());
		}
		
		[CommandComplete]
		/**
		 * @private 
		 * Config complete handler
		 */
		public function onConfigComplete(message:ConfigMessage):void {
			if (null != _logger) {
				_logger.info("Application configured");
			}
			initialized = true;
		}
		
		[CommandError]
		/**
		 * @private 
		 * Config load error
		 */
		public function onConfigError(fault:ErrorEvent, message:ConfigMessage):void {
			var listener:Function = function(event:CloseEvent):void {
				if (null == event || Alert.OK == event.detail) {
					//Log
					sendMessage(new ExitMessage(ExitMessages.CONFIG_ERROR));
					return;
				} 
			}
				
			if (null != _logger) {
				_logger.error("Configuration error: " + fault.text);
			}
			
			var rm:IResourceManager = ResourceManager.getInstance();
			
			Alert.show(rm.getString("messages", "configError", [fault.text]), rm.getString("messages", 'configErrorTitle'), Alert.OK, null, listener);
		}
		
	}
}