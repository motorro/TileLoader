package tileloader.controller.tasks
{
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.ImageEvent;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageFormatFileVO;
	import tileloader.model.VO.ImageFormatVO;
	import tileloader.model.VO.ImageVO;
	
	/**
	 * Performes cleanup after completing file resize and save
	 *  
	 * @author kochetkov
	 * 
	 */
	public class FormatResizeCleanupTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(FormatResizeCleanupTask);

		/**
		 * @private
		 * Image VO being processed storage 
		 */
		private var _image:ImageVO;
		
		/**
		 * @private
		 * Format being processed storage 
		 */
		private var _formatFile:ImageFormatFileVO;
		
		/**
		 * @private
		 * Thumbnail format reference 
		 */
		private var _thumbnailFormat:ImageFormatVO;
		
		/**
		 * Constructor 
		 */
		public function FormatResizeCleanupTask(image:ImageVO, formatFile:ImageFormatFileVO, thumbnailFormat:ImageFormatVO) {
			super();
			
			_image = image;
			_formatFile = formatFile;
			_thumbnailFormat = thumbnailFormat;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override protected function doStart():void {
			//Add encoded format reference to image VO
			if (null == _image.formats) {
				_image.formats = new Dictionary();
			}
			_image.formats[_formatFile.format] = _formatFile;
			
			//If processed format is thumbnail - copy bitmap data
			if (_thumbnailFormat === _formatFile.format) {
				if (null != _logger) {
					_logger.info("Encoded format is set as thumbnail");
				}
				_image.thumbnail = new Bitmap(ResizerModel(data).output.clone(), PixelSnapping.AUTO, true);
			}
			
			//Dispatch format complete message
			_image.dispatchEvent(new ImageEvent(ImageEvent.FORMAT_RESIZE_COMPLETE, _formatFile.format));
			
			//Cleanup model
			var model:ResizerModel = ResizerModel(data);
			model.encoded = null;
			
			complete();
		}
	}
}