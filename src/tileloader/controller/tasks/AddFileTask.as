package tileloader.controller.tasks
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.VO.ImageVO;
	
	public class AddFileTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(AddFileTask);
		
		/**
		 * @private
		 * File types (by extention) tha are allowed 
		 */
		private static const ALLOWED_EXTENTIONS:Array = ["png", "jpg", "jpeg"];

		/**
		 * @private
		 * Reference to configuration file 
		 */
		private var _file:File;

		/**
		 * Constructor 
		 * @param file File reference
		 */
		public function AddFileTask(file:File) {
			super();
			
			_file = file;
			
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
				_logger.info("Adding file: " + _file.nativePath);
			}
			
			var message:String;
			//Basic check file
			if (_file.isDirectory) {
				message = "Can't add directory!";
				if (null != _logger) {
					_logger.warn(message);
				}
				error(message);
				return;
			}
			
			var nativePath:String = _file.nativePath;
			var extention:String = nativePath.substr(nativePath.lastIndexOf(".") + 1).toLowerCase();
			if (ALLOWED_EXTENTIONS.indexOf(extention) < 0) {
				message = "File type '" + extention + "' is not allowed!";
				if (null != _logger) {
					_logger.warn(message);
				}
				error(message);
				return;
			}
			
			//TODO: Check for duplicates
			
			var image:ImageVO = new ImageVO(_file);
			ArrayCollection(data).addItem(image);
			
			complete();
		}	
	}
}