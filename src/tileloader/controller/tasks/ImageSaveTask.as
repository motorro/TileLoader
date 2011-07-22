package tileloader.controller.tasks
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.graphics.codec.IImageEncoder;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageFormatFileVO;
	
	/**
	 * Saves resized image
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageSaveTask extends Task {
		
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageSaveTask);

		/**
		 * @private
		 * Format file storage 
		 */
		private var _formatFile:ImageFormatFileVO;
		
		/**
		 * Constructor 
		 * @param formatFile Image format storage VO
		 */
		public function ImageSaveTask(formatFile:ImageFormatFileVO)	{
			super();
			_formatFile = formatFile;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			if (null != _logger) {
				_logger.info("Saving image to: " + _formatFile.file.nativePath);
			}
			
			var fs:FileStream = new FileStream();
			
			try {
				fs.open(_formatFile.file.clone(), FileMode.WRITE);
				fs.writeBytes(ResizerModel(data).encoded, 0, ResizerModel(data).encoded.length);
				fs.close();
				if (null != _logger) {
					_logger.info("Saved");
				}
			} catch (e:Error) {
				fs.close();
				var message:String = "File write error: " + e.message;
				if (null != _logger) {
					_logger.error(message);
				}
				error(message);
				return;
			}
			complete();
		}
	}
}