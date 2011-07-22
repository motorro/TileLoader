package tileloader.controller.tasks
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.VO.ImageFormatFileVO;
	import tileloader.model.VO.ImageVO;
	
	/**
	 * Removes image from queue and disk
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageRemoveTask extends RetriableTask {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageRemoveTask);
		
		/**
		 * @private
		 * File list reference 
		 */
		private var _fileList:ArrayCollection;
		
		/**
		 * @private
		 * Image to be removed reference 
		 */
		private var _image:ImageVO;
		
		/**
		 * Constructor 
		 * @param fileList File list
		 * @param image Image to remove
		 */
		public function ImageRemoveTask(fileList:ArrayCollection, image:ImageVO) {
			super();
			
			_fileList = fileList;
			_image = image;

			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doRetryStart():void {
			if (null != _logger) {
				_logger.info("Removing image: " + _image.path.nativePath);
			}
			
			//Remove file from collection
			//TODO: Check for correct index
			var index:int = _fileList.source.indexOf(_image);
			if (index >= 0) {
				_fileList.removeItemAt(index)
			}
			
			//Remove files on disk if has any
			for each (var format:ImageFormatFileVO in _image.formats) {
				if (false == format.file.exists) continue;
				try {
					format.file.deleteFile();
					format
				} catch (e:Error) {
					var message:String = "Can't delete file: " + e.message;
					if (null != _logger) {
						_logger.error(message);
					}
					error (message);
				}
			}
			
			complete();
		}
	}
}