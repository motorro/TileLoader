package tileloader.controller
{
	import flash.events.ErrorEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.spicefactory.parsley.core.context.Context;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.AuthResultMessage;
	import tileloader.messages.AuthenticateMessage;
	import tileloader.messages.CheckForUpdatesMessage;
	import tileloader.messages.ConfigMessage;
	import tileloader.messages.ConfigResultMessage;
	import tileloader.messages.ExitMessage;
	import tileloader.messages.MessageCodes;
	import tileloader.messages.FileAddMessage;
	import tileloader.messages.OrderCleanupMessage;
	import tileloader.messages.RescanFileQueueMessage;
	import tileloader.messages.RescanUploadQueueMessage;
	import tileloader.messages.ResizeImageMessage;
	import tileloader.messages.StartUploadMessage;
	import tileloader.messages.StopUploadMessage;
	import tileloader.messages.UploadImageMessage;
	import tileloader.model.ApplicationConfig;
	import tileloader.model.AuthenticationModel;
	import tileloader.model.GlobalConstants;
	import tileloader.model.ResizerModel;
	import tileloader.model.SharedModel;
	import tileloader.model.UploaderModel;

	[ResourceBundle("messages")]
	/**
	 * Main workflow controller
	 *  
	 * @author kochetkov
	 * 
	 */
	public class WorkflowController {
		/**
		 * @private
		 * Logger 
		 */
		private static const _logger:ILogger = LogUtils.getLoggerByClass(WorkflowController);
		
		[Inject]
		/**
		 * @private
		 * Shared model reference 
		 */
		public var sharedModel:SharedModel;
		
		[Inject]
		/**
		 * @private
		 * Configuration data 
		 */
		public var appConfig:ApplicationConfig;
		
		[Inject]
		/**
		 * @private
		 * Authentication data 
		 */
		public var authenticationModel:AuthenticationModel;
		
		[Inject]
		/**
		 * @private
		 * Resizer data 
		 */
		public var resizerModel:ResizerModel;
		
		[Inject]
		/**
		 * @private
		 * Uploader data 
		 */
		public var uploaderModel:UploaderModel;
		
		[Inject]
		/**
		 * @private
		 * Context reference 
		 */
		public var context:Context;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;

		/**
		 * Starts main workflow 
		 */
		public function run():void {
			appConfig.configured = false;
			
			if (null != _logger) {
				_logger.info("Application start");
			}
			
			//Check for updates
			sendMessage(new CheckForUpdatesMessage(GlobalConstants.UPDATE_CHECK_URL));
			
			//Configure
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
			appConfig.configured = true;

			if (null != _logger) {
				_logger.info("Authenticating.");
			}
			//TODO: Implement unfinished order restore
			
			//For now - just clean the folder
			sendMessage(new OrderCleanupMessage(null));			
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
					sendMessage(new ExitMessage(MessageCodes.CONFIG_ERROR));
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
			authenticationModel.authenticated = false;
			
			//Wait for authentication here...
		}

		[CommandError]
		/**
		 * @private 
		 * Cleanup error
		 */
		public function onCleanupError(fault:ErrorEvent, message:OrderCleanupMessage):void {
			var listener:Function = function(event:CloseEvent):void {
				if (null == event || Alert.NO == event.detail) {
					//TODO: Log output
					sendMessage(new ExitMessage(MessageCodes.DISK_OPERATION_ERROR));
					return;
				} else {
					sendMessage(message);
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
			//Clear error flag if was set before
			resizerModel.sufferingError = false;

			//Upload new file if in upload state
			if (uploaderModel.uploading) {
				sendMessage(new RescanUploadQueueMessage());	
			}
			sendMessage(new RescanFileQueueMessage());	
		}
		
		[CommandError]
		/**
		 * @private 
		 * File resize error
		 */
		public function onResizeError(fault:ErrorEvent, message:ResizeImageMessage):void {
			var listener:Function = function(event:CloseEvent):void {
				if (null == event || Alert.NO == event.detail) {
					//TODO: Log output
					sendMessage(new ExitMessage(MessageCodes.DISK_OPERATION_ERROR));
					return;
				} else {
					sendMessage(message);
				} 
			}
			
			if (null != _logger) {
				_logger.error("Resize error: " + fault.text);
			}
			
			//Set error flag
			resizerModel.sufferingError = true;
			
			var rm:IResourceManager = ResourceManager.getInstance();
			
			Alert.show(rm.getString("messages", "resizeError", [fault.text]), rm.getString("messages", 'resizeErrorTitle'), Alert.YES | Alert.NO, null, listener);
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
			//Clear error flag if was set before
			uploaderModel.sufferingError = false;

			if (0 == sharedModel.fileList.length) {
				//All files uploaded
				sendMessage(new StopUploadMessage(StopUploadMessage.FINISHED));
				return;
			}
			sendMessage(new RescanUploadQueueMessage());	
		}
		
		[CommandError]
		/**
		 * @private 
		 * File upload error
		 */
		public function onImageUploadError(fault:ErrorEvent, message:UploadImageMessage):void {
			var listener:Function = function(event:CloseEvent):void {
				if (null == event || Alert.NO == event.detail) {
					//TODO: Log output
					sendMessage(new ExitMessage(MessageCodes.NETWORK_ERROR));
					return;
				} else {
					sendMessage(message);
				} 
			}
			
			if (null != _logger) {
				_logger.error("Upload error: " + fault.text);
			}
			
			//Set error flag
			uploaderModel.sufferingError = true;

			var rm:IResourceManager = ResourceManager.getInstance();
			
			Alert.show(rm.getString("messages", "uploadError", [fault.text]), rm.getString("messages", 'uploadErrorTitle'), Alert.YES | Alert.NO, null, listener);
		}
	}
}