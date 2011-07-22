package tileloader.controller.tasks
{
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.events.ErrorEvent;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.events.TaskEvent;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageFormatVO;
	import tileloader.model.VO.ImageVO;
	
	/**
	 * Creates image thumbnail if needed
	 *  
	 * @author kochetkov
	 * 
	 */
	public class CreateThumbnailTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(CreateThumbnailTask);

		/**
		 * @private
		 * Image storage 
		 */
		private var _image:ImageVO;
		
		/**
		 * @private
		 * Thumbnail format reference 
		 */
		private var _thumbnailFormat:ImageFormatVO;
		
		/**
		 * @private
		 * Resize task 
		 */
		private var _resizeTask:Task;
		
		/**
		 * Constructor 
		 * @param image Image to make thumbnail for
		 * @param thumbnailFormat Thumbnail format
		 */
		public function CreateThumbnailTask(image:ImageVO, thumbnailFormat:ImageFormatVO) {
			super();
			
			_image = image;
			_thumbnailFormat = thumbnailFormat;
			
			setCancelable(true);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			if (null != _image.thumbnail) {
				if (null != _logger) {
					_logger.info("Thumbnail already created. Canceling...");
				}
				cancel();
				return;
			}
			if (null != _logger) {
				_logger.info("Creating thumbnail");
			}
			
			_resizeTask = new ImageResizeTask(_thumbnailFormat);
			_resizeTask.data = data;
			_resizeTask.addEventListener(TaskEvent.COMPLETE, onResizeComplete, false, 0, true);
			_resizeTask.addEventListener(ErrorEvent.ERROR, onResizeError, false, 0, true);
			_resizeTask.start();
		}
		
		/**
		 * @private
		 * Resize complete handler 
		 */
		private function onResizeComplete(event:TaskEvent):void {
			if (null != _logger) {
				_logger.info("Thumbnail created.");
			}
			
			_image.thumbnail = new Bitmap(ResizerModel(data).output.clone(), PixelSnapping.AUTO, true);
			complete();
		}
		
		/**
		 * @private
		 * Error handler 
		 */
		private function onResizeError(event:ErrorEvent):void {
			var message:String = "Error creating thumbnail: " + event.text;
			if (null != _logger) {
				_logger.error(message);
			}
			error(message);
		}
	}
}