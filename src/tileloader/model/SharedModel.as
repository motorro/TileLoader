package tileloader.model
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.spicefactory.parsley.core.context.Context;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.ConfigMessage;
	import tileloader.messages.ConfigResultMessage;
	import tileloader.messages.ExitMessage;
	import tileloader.messages.ExitMessages;
	import tileloader.messages.FileAddMessage;
	import tileloader.messages.OrderCleanupMessage;
	import tileloader.messages.RescanFileQueueMessage;
	import tileloader.messages.RescanUploadQueueMessage;
	import tileloader.messages.ResizeImageMessage;
	import tileloader.messages.StartUploadMessage;
	import tileloader.messages.UploadImageMessage;
	import tileloader.view.UploadProgress;

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
		
		[Bindable]
		/**
		 * Files to be processed with application 
		 */
		public var fileList:ArrayCollection;
		
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
		
		[Inject]
		/**
		 * @private
		 * Context reference 
		 */
		public var context:Context;
		
		[Init]
		public function init():void {
			initialized = false;

			//Load configuration
			if (null != _logger) {
				_logger.info("Application start");
			}
			
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
			
			sendMessage(new ConfigResultMessage(ConfigResultMessage.CONFIG_COMPLETE));
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
					//TODO: Log output
					sendMessage(new ExitMessage(ExitMessages.CONFIG_ERROR));
					return;
				} 
			}
				
			if (null != _logger) {
				_logger.error("Configuration error: " + fault.text);
			}
			sendMessage(new ConfigResultMessage(ConfigResultMessage.CONFIG_FAILED));
			
			var rm:IResourceManager = ResourceManager.getInstance();
			
			Alert.show(rm.getString("messages", "configError", [fault.text]), rm.getString("messages", 'configErrorTitle'), Alert.OK, null, listener);
		}
		
		//TODO: Think about moving those commands elsewhere
		[CommandComplete]
		/**
		 * @private 
		 * File added handler
		 */
		public function onFileAdded(message:FileAddMessage):void {
			sendMessage(new RescanFileQueueMessage());			
		}

		[CommandComplete]
		/**
		 * @private 
		 * File resize complete handler
		 */
		public function onFileResized(message:ResizeImageMessage):void {
			sendMessage(new RescanFileQueueMessage());	
		}
		

		//Uploading
		
		/**
		 * Starts image upload 
		 */
		public function startUpload():void {
			sendMessage(new StartUploadMessage());			
		}
		
		[CommandComplete]
		/**
		 * @private 
		 * File resize complete handler
		 */
		public function onStartUploadRequested(message:StartUploadMessage):void {
			//TODO: Add popup
		}
		
		[CommandComplete(selector="userCancelled")]
		/**
		 * @private 
		 * File resize complete handler
		 */
		public function onCancelUploadRequested(message:StartUploadMessage):void {
			//TODO: Remove popup
		}

		[CommandComplete]
		/**
		 * @private 
		 * File resize complete handler
		 */
		public function onImageUploaded(message:UploadImageMessage):void {
			sendMessage(new RescanUploadQueueMessage());	
		}
		
	}
}