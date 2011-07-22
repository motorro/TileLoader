package tileloader.controller.tasks
{
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.ImageEvent;
	import tileloader.model.ResizerModel;
	
	/**
	 * Clean-up after image is resized
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageResizeCleanupTask extends Task
	{
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageResizeCleanupTask);

		/**
		 * Constructor 
		 */
		public function ImageResizeCleanupTask() {
			super();

			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			var model:ResizerModel = ResizerModel(data);	
			
			model.imageInProgress.resizeComplete = true;
			model.imageInProgress.dispatchEvent(new ImageEvent(ImageEvent.RESIZE_COMPLETE));
			
			model.initialize();
			
			if (null != _logger) {
				_logger.info("Resize complete.");
			}
			
			complete();
		}
	}
}