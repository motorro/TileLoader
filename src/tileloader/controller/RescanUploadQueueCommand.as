package tileloader.controller
{
	import mx.logging.ILogger;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.RescanUploadQueueMessage;
	import tileloader.messages.UploadImageMessage;
	import tileloader.model.SharedModel;
	import tileloader.model.UploaderModel;
	import tileloader.model.VO.ImageVO;

	/**
	 * Rescans file queue to find files ready for uploading
	 *  
	 * @author kochetkov
	 * 
	 */
	public class RescanUploadQueueCommand {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(RescanUploadQueueCommand);
		
		[Inject]
		/**
		 * @private
		 * Shared model reference 
		 */
		public var sharedModel:SharedModel;
		
		[Inject]
		/**
		 * @private
		 * Resizer model reference 
		 */		
		public var uploaderModel:UploaderModel;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		/**
		 * Rescans file queue to find files that are ready 
		 */
		public function execute(message:RescanUploadQueueMessage):void {
			if (null != _logger) {
				_logger.info("Rescanning image queue...");
			}
			
			if (uploaderModel.working) {
				if (null != _logger) {
					_logger.info("Uploader busy. Waiting till upload complete.");
				}
				return;
			}
			
			var queue:Array = sharedModel.fileList.source;
			
			for (var i:int = 0; i < queue.length; ++i) {
				var image:ImageVO = ImageVO(queue[i]);
				if (false == image.complete) continue;
				
				//Found complete image
				if (null != _logger) {
					_logger.info("Found image to upload: " + image.path.name);
				}
				sendMessage(new UploadImageMessage(image));
				break;
			}
		}
	}
}