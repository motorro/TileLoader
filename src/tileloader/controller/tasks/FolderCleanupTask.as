package tileloader.controller.tasks
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	
	/**
	 * Removes folder and all it's content
	 *  
	 * @author kochetkov
	 * 
	 */
	public class FolderCleanupTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(FolderCleanupTask);
		
		/**
		 * @private
		 * Folder to remove 
		 */
		private var _folder:File;
		
		/**
		 * Constructor 
		 * @param folder to be removed
		 */
		public function FolderCleanupTask(folder:File) {
			super();
			_folder = folder;
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			var message:String;
			
			if (null != _logger) {
				_logger.info("Cleaning up folder: " + _folder.nativePath);
			}
			
			if (false == _folder.exists) {
				if (null != _logger) {
					_logger.info("Directory not found.");
				}
				complete();
				return;
			}
			
			if (false == _folder.isDirectory) {
				message = "Given path is not directory.";
				if (null != _logger) {
					_logger.error(message);
				}
				error(message);
				return;
			}
			
			_folder.addEventListener(Event.COMPLETE, onComplete);
			_folder.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			_folder.deleteDirectoryAsync(true);
		}

		/**
		 * @private
		 * Delete complete handler 
		 */
		private function onComplete(event:Event):void {
			if (null != _logger) {
				_logger.info("Folder removed.");
			}
			complete();
		}
		
		/**
		 * @private
		 * Delete error handler 
		 */
		private function onError(event:IOErrorEvent):void {
			if (null != _logger) {
				_logger.error("Error removing folder: " + event.text);
			}
			error(event.text);
		}
	}
}