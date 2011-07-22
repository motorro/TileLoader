package tileloader.controller
{
	import mx.logging.ILogger;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.RescanFileQueueMessage;
	import tileloader.messages.ResizeImageMessage;
	import tileloader.model.ResizerModel;
	import tileloader.model.SharedModel;
	import tileloader.model.VO.ImageVO;

	/**
	 * Rescans image queue and starts encoding files on complete
	 *   
	 * @author kochetkov
	 * 
	 */
	public class RescanFileQueueCommand {
		
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(RescanFileQueueCommand);

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
		public var resizerModel:ResizerModel;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		/**
		 * Rescans message queue 
		 */
		public function execute(message:RescanFileQueueMessage):void {
			if (null != _logger) {
				_logger.info("Rescanning image queue...");
			}
			
			if (resizerModel.working) {
				if (null != _logger) {
					_logger.info("Resizer busy. Waiting till resize complete.");
				}
				return;
			}
			
			var queue:Array = sharedModel.fileList.source;
			
			for (var i:int = 0; i < queue.length; ++i) {
				var image:ImageVO = ImageVO(queue[i]);
				if (image.resizeComplete) continue;
				
				//Found incomplete image
				if (null != _logger) {
					_logger.info("Found image to resize: " + image.path.nativePath);
				}
				sendMessage(new ResizeImageMessage(image));
				break;
			}
		}
	}
}