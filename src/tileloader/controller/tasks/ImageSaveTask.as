package tileloader.controller.tasks
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
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
		 * File stream reference 
		 */
		private var _fs:FileStream;
		
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
			
			_fs = new FileStream();
			
			_fs.addEventListener(Event.COMPLETE, onComplete);
			_fs.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			_fs.open(_formatFile.file, FileMode.WRITE);
			
			_fs.writeBytes(ResizerModel(data).encoded, 0, ResizerModel(data).encoded.length);
			
			//FIXME: Async operation does not work
			_fs.close();
			if (null != _logger) {
				_logger.info("Saved");
			}
			complete();
		}
		
		/**
		 * @private
		 * File write complete handler 
		 */
		private function onComplete(event:Event):void {
			_fs.close();
			if (null != _logger) {
				_logger.info("Saved");
			}
			complete();
		}
		
		/**
		 * @private 
		 * File write error handler
		 */
		private function onError(event:IOErrorEvent):void {
			_fs.close();
			var message:String = "File write error: " + event.text;
			if (null != _logger) {
				_logger.error(message);
			}
			error(message);
		}
		
		
	}
}