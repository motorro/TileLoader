package tileloader.controller.tasks
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageVO;
	
	/**
	 * Measures original image
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageMeasureTask extends Task {
		
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageMeasureTask);

		/**
		 * @private
		 * Image VO storage 
		 */
		private var _image:ImageVO;
		
		/**
		 * Constructor 
		 * @param image Image to measure
		 */
		public function ImageMeasureTask(image:ImageVO) {
			super();
			
			_image = image;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			var bitmap:Bitmap = ResizerModel(data).original.content as Bitmap;
			
			if (null == bitmap) {
				var message:String = "Error loading image: Loaded file is not an image!";
				if (null != _logger) {
					_logger.error(message);
				}
				error(message);
				return;
			}
			
			_image.orientation = bitmap.width >= bitmap.height ? ImageVO.LANDSCAPE : ImageVO.PORTRAIT;
			
			if (null != _logger) {
				_logger.info("Loaded image: " + bitmap.width + "x" + bitmap.height + " (" + _image.orientation + ")");
			}
			
			complete();
		}
	}
}