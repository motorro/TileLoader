package tileloader.controller.tasks
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	
	/**
	 * Loads local configuration file
	 *  
	 * @author kochetkov
	 * 
	 */
	public class LoadConfigFileTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(LoadConfigFileTask);

		/**
		 * @private
		 * Reference to configuration file 
		 */
		private var _file:File;
		
		/**
		 * Constructor 
		 * @param file Configuration file reference
		 */
		public function LoadConfigFileTask(file:File) {
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
				_logger.info("Loading configuration file: " + _file.nativePath);
			}
			
			var stream:FileStream = new FileStream();
			stream.addEventListener(Event.COMPLETE, onFileComplete);
			stream.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
			
			stream.openAsync(_file, FileMode.READ);
			
		}
		
		/**
		 * @private
		 * File read complete handler 
		 */
		private function onFileComplete(event:Event):void {
			if (null != _logger) {
				_logger.info("Config file loaded.");
			}
		}
		
		/**
		 * @Private 
		 * File read error handler
		 */
		private function onFileError(event:IOErrorEvent):void {
			var message:String = "Error loading configuration file: " + event.text;
			if (null != _logger) {
				_logger.error(message);
			}
			error(message);
		}
	}
}