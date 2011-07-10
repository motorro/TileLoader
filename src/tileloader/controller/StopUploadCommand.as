package tileloader.controller
{
	import mx.logging.ILogger;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.StopUploadMessage;
	import tileloader.model.UploaderModel;

	/**
	 * Command to handle user cancelled upload 
	 *  
	 * @author kochetkov
	 * 
	 */
	public class StopUploadCommand {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(StopUploadCommand);
		
		[Inject]
		/**
		 * @private
		 * Uploader model refeence 
		 */
		public var model:UploaderModel;
		
		/**
		 * Stops upload
		 *  
		 * @param message
		 * 
		 */
		public function execute(message:StopUploadMessage):void {
			//TODO: Think about things to do on different upload stops
			if (null != _logger) {
				_logger.info("Upload stopped. Reason: " + message.type);
			}
			model.uploading = false;
		}
	}
}